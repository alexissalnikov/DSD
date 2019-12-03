-- Function: gpGet_Object_DiffKind (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_DiffKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiffKind(
    IN inId          Integer,        -- ���������
    IN inSession     TVarChar        -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isClose Boolean
             , isErased Boolean
             , MaxOrderAmount TFloat
             , MaxOrderAmountSecond TFloat) AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_DiffKind());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_DiffKind()) AS Code
           , CAST ('' AS TVarChar)  AS NAME
           , FALSE                  AS isClose
           , FALSE                  AS isErased
           , NULL::TFloat           AS MaxOrderAmount
           , NULL::TFloat           AS MaxOrderAmountSecond;
   ELSE
       RETURN QUERY 
       SELECT Object_DiffKind.Id                                   AS Id
            , Object_DiffKind.ObjectCode                           AS Code
            , Object_DiffKind.ValueData                            AS Name
            , ObjectBoolean_DiffKind_Close.ValueData               AS isClose
            , Object_DiffKind.isErased                             AS isErased
            , ObjectFloat_DiffKind_MaxOrderAmount.ValueData        AS MaxOrderAmount
            , ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData  AS MaxOrderAmount
       FROM Object AS Object_DiffKind
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                    ON ObjectBoolean_DiffKind_Close.ObjectId = Object_DiffKind.Id 
                                   AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close() 
            LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmount
                                  ON ObjectFloat_DiffKind_MaxOrderAmount.ObjectId = Object_DiffKind.Id 
                                 AND ObjectFloat_DiffKind_MaxOrderAmount.DescId = zc_ObjectFloat_MaxOrderAmount() 
            LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmountSecond
                                  ON ObjectFloat_DiffKind_MaxOrderAmountSecond.ObjectId = Object_DiffKind.Id 
                                 AND ObjectFloat_DiffKind_MaxOrderAmountSecond.DescId = zc_ObjectFloat_MaxOrderAmountSecond() 
       WHERE Object_DiffKind.Id = inId;
   END IF;
   
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.12.19                                                       * 
 05.06.19                                                       * 
 11.12.18         *
*/

-- ����
-- SELECT * FROM gpGet_Object_DiffKind(0,'2')