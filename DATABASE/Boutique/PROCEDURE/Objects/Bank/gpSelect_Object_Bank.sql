-- Function: gpSelect_Object_Bank(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Bank(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Bank(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MFO TVarChar, SWIFT TVarChar, IBAN TVarChar, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

     RETURN QUERY
     SELECT
       Object.Id                    AS Id
     , Object.ObjectCode            AS Code
     , Object.ValueData             AS Name
     , ObjectString_MFO.ValueData   AS MFO
     , ObjectString_SWIFT.ValueData AS SWIFT
     , ObjectString_IBAN.ValueData  AS IBAN
     , Object.isErased
     FROM Object
        LEFT JOIN ObjectString AS ObjectString_MFO
                 ON ObjectString_MFO.ObjectId = Object.Id
                AND ObjectString_MFO.DescId = zc_ObjectString_Bank_MFO()
        LEFT JOIN ObjectString AS ObjectString_SWIFT
                 ON ObjectString_SWIFT.ObjectId = Object.Id
                AND ObjectString_SWIFT.DescId = zc_ObjectString_Bank_SWIFT()
        LEFT JOIN ObjectString AS ObjectString_IBAN
                 ON ObjectString_IBAN.ObjectId = Object.Id
                AND ObjectString_IBAN.DescId = zc_ObjectString_Bank_IBAN()

     WHERE Object.DescId = zc_Object_Bank();


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Bank (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.10.14                                                       *
 17.06.14                         *
 19.02.14                                        *
 10.06.13          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Bank('2')