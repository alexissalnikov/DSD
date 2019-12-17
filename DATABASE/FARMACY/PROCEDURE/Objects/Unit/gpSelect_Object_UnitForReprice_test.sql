-- Function: gpSelect_Object_UnitForReprice_test()

DROP FUNCTION IF EXISTS gpSelect_Object_UnitForReprice_test (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitForReprice_test(
    IN inJuridicalId      Integer,       -- ���� ��.����
    IN inProvinceCityId   Integer,       -- �����
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, UnitName TVarChar)
AS
$BODY$
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

    RETURN QUERY 
     
        SELECT Object_Unit.Id                                             AS Id  
             , (COALESCE (Object_Juridical.ValueData, '') ||'  **  '|| 
                COALESCE (Object_Unit.ValueData, '') ||'  **  '|| 
                COALESCE (Object_ProvinceCity.ValueData, '')) :: TVarChar AS Name
        FROM Object AS Object_Unit

             LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                     ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

             LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto 
                                     ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                                    AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                  ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
             LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
             -- �������� ����
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsReprice
                                     ON ObjectBoolean_GoodsReprice.ObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                    AND ObjectBoolean_GoodsReprice.DescId = zc_ObjectBoolean_Retail_GoodsReprice()

        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND COALESCE (ObjectBoolean_isLeaf.ValueData,False) = TRUE
          AND COALESCE (ObjectBoolean_RepriceAuto.ValueData,False) = TRUE
          AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
          AND (ObjectLink_Unit_ProvinceCity.ChildObjectId = inProvinceCityId OR inProvinceCityId = 0)
          AND COALESCE (ObjectBoolean_GoodsReprice.ValueData, FALSE) = TRUE

        ORDER BY Object_Juridical.ValueData , Object_Unit.ValueData , Object_ProvinceCity.ValueData
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.19         * ������ ������ ����� ���  <��������� � ������ ���������� � �����> = ��
 12.03.18         *
 25.06.15                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_UnitForReprice_test (0, 0, zfCalc_UserAdmin());