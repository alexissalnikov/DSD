-- Function: gpGet_Object_BrandSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_BrandSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_BrandSP(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_BrandSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_BrandSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_BrandSP.Id          AS Id
            , Object_BrandSP.ObjectCode  AS Code
            , Object_BrandSP.ValueData   AS Name
            , Object_BrandSP.isErased    AS isErased
       FROM Object AS Object_BrandSP
       WHERE Object_BrandSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.12.16         *
*/

-- ����
-- SELECT * FROM gpGet_Object_BrandSP(0,'2')