﻿-- Function: gpGet_Object_ModelService()

DROP FUNCTION IF EXISTS gpGet_Object_ModelService();

CREATE OR REPLACE FUNCTION gpGet_Object_ModelService(
    IN inId          Integer,       -- Единица измерения 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , Comment TVarChar
             , UnitId Integer, UnitName TVarChar
             , ModelServiceKindId Integer, ModelServiceKindName TVarChar
             , isTrainee Boolean
             , isErased Boolean
             ) AS
$BODY$BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ModelService());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , COALESCE(MAX (Object.ObjectCode), 0) + 1 AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)     AS Comment

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS ModelServiceKindId
           , CAST ('' as TVarChar) AS ModelServiceKindName

           , CAST (FALSE AS Boolean) AS isTrainee
           , CAST (NULL AS Boolean) AS isErased
           
       FROM Object 
       WHERE Object.DescId = zc_Object_ModelService();
   ELSE
       RETURN QUERY 
       SELECT 
             Object_ModelService.Id          AS Id
           , Object_ModelService.ObjectCode  AS Code
           , Object_ModelService.ValueData   AS Name
           
           , ObjectString_Comment.ValueData  AS Comment
           
           , Object_Unit.Id          AS UnitId
           , Object_Unit.ValueData   AS UnitName

           , Object_ModelServiceKind.Id          AS ModelServiceKindId
           , Object_ModelServiceKind.ValueData   AS ModelServiceKindName
           
           , COALESCE (ObjectBoolean_Trainee.ValueData, FALSE) :: Boolean AS isTrainee
           , Object_ModelService.isErased        AS isErased
           
       FROM Object AS Object_ModelService
       
            LEFT JOIN ObjectString AS ObjectString_Comment 
                                   ON ObjectString_Comment.ObjectId = Object_ModelService.Id 
                                  AND ObjectString_Comment.DescId = zc_ObjectString_ModelService_Comment()
     
            LEFT JOIN ObjectLink AS ObjectLink_ModelService_Unit 
                                 ON ObjectLink_ModelService_Unit.ObjectId = Object_ModelService.Id
                                AND ObjectLink_ModelService_Unit.DescId = zc_ObjectLink_ModelService_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ModelService_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ModelService_ModelServiceKind
                                 ON ObjectLink_ModelService_ModelServiceKind.ObjectId = Object_ModelService.Id
                                AND ObjectLink_ModelService_ModelServiceKind.DescId = zc_ObjectLink_ModelService_ModelServiceKind()
            LEFT JOIN Object AS Object_ModelServiceKind ON Object_ModelServiceKind.Id = ObjectLink_ModelService_ModelServiceKind.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Trainee
                                    ON ObjectBoolean_Trainee.ObjectId = Object_ModelService.Id
                                   AND ObjectBoolean_Trainee.DescId = zc_ObjectBoolean_ModelService_Trainee()

       WHERE Object_ModelService.Id = inId;
   END IF;
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ModelService(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  09.12.19        * Trainee
  22.10.13        *
   
  
*/

-- тест
-- select * from gpGet_Object_ModelService(inId := 0 ,  inSession := '5'::TVarChar);