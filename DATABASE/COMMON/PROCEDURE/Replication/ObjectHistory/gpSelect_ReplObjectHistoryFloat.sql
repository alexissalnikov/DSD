﻿-- для SessionGUID - возвращает данные из табл. ReplObject -> Object - для формирования скриптов

DROP FUNCTION IF EXISTS gpSelect_ReplObjectHistoryFloat (TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ReplObjectHistoryFloat (TVarChar, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplObjectHistoryFloat(
    IN inSessionGUID  TVarChar,      --
    IN inStartId      Integer,       --
    IN inEndId        Integer,       --
    IN inDataBaseId   Integer,       -- для формирования "виртуального" GUID
    IN gConnectHost   TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (OperDate_last      TDateTime
             , ObjectDescId       Integer
             , ObjectId           Integer
             , ObjectHistoryId    Integer
             , DescId             Integer
             , DescName           VarChar (100)
             , ItemName           VarChar (100)
                                  
             , ValueDataS         VarChar (1)
             , ValueDataF         TFloat
             , ValueDataD         TDateTime
             , ValueDataB         Boolean
             , isValuDNull        Boolean
             , isValuBNull        Boolean
                                  
             , GUID               VarChar (35)
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат

     -- 1. Object
     RETURN QUERY
     SELECT
          ReplObject.OperDate_last                  AS OperDate_last
        , ReplObject.DescId                         AS ObjectDescId
        , ReplObject.ObjectId                       AS ObjectId
        , ObjectHistoryFloat.ObjectHistoryId               AS ObjectHistoryId
        , ObjectHistoryFloat.DescId                        AS DescId
        , ObjectHistoryFloatDesc.Code     :: VarChar (100) AS DescName
        , ObjectHistoryFloatDesc.ItemName :: VarChar (100) AS ItemName
                                                    
        , ''                       :: VarChar (1)   AS ValueDataS
        , ObjectHistoryFloat.ValueData :: TFloat    AS ValueDataF
        , NULL                     :: TDateTime     AS ValueDataD
        , NULL                     :: Boolean       AS ValueDataB
        , FALSE                    :: Boolean       AS isValuDNull
        , FALSE                    :: Boolean       AS isValuBNull

        , (CASE WHEN ObjectString_GUID.ValueData <> '' THEN ObjectString_GUID.ValueData ELSE ReplObject.ObjectId :: TVarChar || ' - ' || inDataBaseId :: TVarChar END) :: VarChar (35) AS GUID

     FROM ReplObject
          INNER JOIN ObjectHistory          ON ObjectHistory.ObjectId = ReplObject.ObjectId
          INNER JOIN ObjectHistoryFloat     ON ObjectHistoryFloat.ObjectHistoryId = ObjectHistory.Id
          LEFT JOIN ObjectHistoryFloatDesc ON ObjectHistoryFloatDesc.Id   = ObjectHistoryFloat.DescId
          LEFT JOIN ObjectString AS ObjectString_GUID
                                 ON ObjectString_GUID.ObjectId = ReplObject.ObjectId
                                AND ObjectString_GUID.DescId   = zc_ObjectString_GUID()
     WHERE ReplObject.SessionGUID = inSessionGUID
       AND ((ReplObject.Id BETWEEN inStartId AND inEndId) OR inEndId = 0)
     ORDER BY ReplObject.ObjectId, ObjectHistoryFloat.DescId
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplObjectHistoryFloat  (inSessionGUID:= CURRENT_TIMESTAMP :: TVarChar, inStartId:= 0, inEndId:= 0, inDataBaseId:= 0, gConnectHost:= '', inSession:= zfCalc_UserAdmin()) -- ORDER BY 1
