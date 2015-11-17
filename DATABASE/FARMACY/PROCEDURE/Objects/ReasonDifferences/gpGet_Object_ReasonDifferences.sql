﻿-- Function: gpGet_Object_ReasonDifferences()

DROP FUNCTION IF EXISTS gpGet_Object_ReasonDifferences(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReasonDifferences(
    IN inId          Integer,       -- Причина разногласия
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_ReasonDifferences());
    IF COALESCE (inId, 0) = 0
    THEN
        RETURN QUERY 
        SELECT
            CAST (0 as Integer)                                AS Id
          , lfGet_ObjectCode(0, zc_Object_ReasonDifferences()) AS Code
          , CAST ('' as TVarChar)                              AS Name
          , False                                              AS isErased;
    ELSE
        RETURN QUERY 
        SELECT 
            Object_ReasonDifferences.Id
          , Object_ReasonDifferences.ObjectCode::Integer AS Code
          , Object_ReasonDifferences.ValueData           AS Name
          , Object_ReasonDifferences.IsErased            AS isErased
        FROM 
           Object AS Object_ReasonDifferences
        WHERE 
            Object_ReasonDifferences.Id = inId;
    END IF;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_ReasonDifferences (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 17.11.15                                                         *
 
*/