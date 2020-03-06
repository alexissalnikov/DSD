-- Function: gpGet_Object_CommentTR()

DROP FUNCTION IF EXISTS gpGet_Object_CommentTR(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CommentTR(
    IN inId          Integer,       -- ���� ������� <�������>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isExplanation Boolean
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)     AS Id
           , lfGet_ObjectCode(0, zc_Object_CommentTR()) AS Code
           , CAST ('' as TVarChar)   AS Name
           , CAST (FALSE AS Boolean) AS isExplanation
           , CAST (FALSE AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_CommentTR.Id                           AS Id
            , Object_CommentTR.ObjectCode                   AS Code
            , Object_CommentTR.ValueData                    AS Name
            , ObjectBoolean_CommentTR_Explanation.ValueData AS Explanation
            , Object_CommentTR.isErased                     AS isErased
       FROM Object AS Object_CommentTR

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Explanation
                                ON ObjectBoolean_CommentTR_Explanation.ObjectId = Object_CommentTR.Id 
                               AND ObjectBoolean_CommentTR_Explanation.DescId = zc_ObjectBoolean_CommentTR_Explanation()
                               
       WHERE Object_CommentTR.Id = inId;
   END IF; 
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CommentTR(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.02.20                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_CommentTR (0, '3')