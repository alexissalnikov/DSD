-- Function: gpGet_Object_CashSettings()

DROP FUNCTION IF EXISTS gpGet_Object_CashSettings(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashSettings(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShareFromPriceName TVarChar
             , ShareFromPriceCode TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_CashSettings.Id                     AS Id
        , Object_CashSettings.ObjectCode             AS Code
        , Object_CashSettings.ValueData              AS Name
        , ObjectString_CashSettings_ShareFromPriceName.ValueData  AS ShareFromPriceName
        , ObjectString_CashSettings_ShareFromPriceCode.ValueData  AS ShareFromPriceCode
   FROM Object AS Object_CashSettings
        LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceName
                               ON ObjectString_CashSettings_ShareFromPriceName.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_ShareFromPriceName.DescId = zc_ObjectString_CashSettings_ShareFromPriceName()
        LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceCode
                               ON ObjectString_CashSettings_ShareFromPriceCode.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_ShareFromPriceCode.DescId = zc_ObjectString_CashSettings_ShareFromPriceCode()
   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashSettings(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.08.19                                                       *

*/

-- ����
-- SELECT * FROM gpGet_Object_CashSettings ('3')