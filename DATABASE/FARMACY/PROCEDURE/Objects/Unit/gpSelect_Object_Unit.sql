-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Unit(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , ParentId Integer, ParentName TVarChar
             , UserManagerId Integer, UserManagerName TVarChar, MemberName TVarChar
             , EMail_Member TVarChar, Phone_Member TVarChar
             , UserManager2Id Integer, UserManager2Name TVarChar, Member2Name TVarChar
             , EMail_Member2 TVarChar, Phone_Member2 TVarChar
             , UserManager3Id Integer, UserManager3Name TVarChar, Member3Name TVarChar
             , EMail_Member3 TVarChar, Phone_Member3 TVarChar
             , JuridicalName TVarChar, MarginCategoryName TVarChar, isLeaf boolean, isErased boolean
             , RouteId integer, RouteName TVarChar
             , RouteSortingId integer, RouteSortingName TVarChar
             , AreaId Integer, AreaName TVarChar
             , UnitRePriceId Integer, UnitRePriceName TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , DriverId Integer, DriverName TVarChar
             , ListDaySUN TVarChar, ListDaySUN_pi TVarChar
             , TaxService TFloat, TaxServiceNigth TFloat
             , KoeffInSUN TFloat, KoeffOutSUN TFloat
             , KoeffInSUN_v3 TFloat, KoeffOutSUN_v3 TFloat
             , SunIncome TFloat
             , StartServiceNigth TDateTime, EndServiceNigth TDateTime
             , CreateDate TDateTime, CloseDate TDateTime
             , TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime
             , isRepriceAuto Boolean
             , isOver Boolean
             , isUploadBadm Boolean
             , isMarginCategory Boolean
             , isReport Boolean
             , isGoodsCategory Boolean
             , Num_byReportBadm Integer
             , DateSP      TDateTime
             , StartTimeSP TDateTime
             , EndTimeSP   TDateTime
             , isSP        Boolean
             , isSUN       Boolean, isSUN_v2 Boolean, isSUN_v3 Boolean
             , isSUN_in Boolean, isSUN_out Boolean
             , isSUN_v2_in  Boolean, isSUN_v2_out Boolean
             , isSUN_v3_in  Boolean, isSUN_v3_out Boolean
             , isSUN_v4     Boolean, isSUN_v4_in  Boolean, isSUN_v4_out Boolean
             , isSUN_NotSold Boolean
             , isTopNo     Boolean
             , isNotCashMCS     Boolean, isNotCashListDiff     Boolean
             , isTechnicalRediscount Boolean, isAlertRecounting Boolean
             , TimeWork TVarChar

) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    WITH 
    tmpByBadm AS (SELECT ObjectBoolean_UploadBadm.ObjectId    AS UnitId
                       , ROW_NUMBER() OVER (ORDER BY ObjectBoolean_UploadBadm.ObjectId )  ::integer  AS Num_byReportBadm
                  FROM ObjectBoolean AS ObjectBoolean_UploadBadm
                  WHERE ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
                    AND ObjectBoolean_UploadBadm.ValueData = TRUE)

    SELECT 
        Object_Unit.Id                                       AS Id
      , Object_Unit.ObjectCode                               AS Code
      , Object_Unit.ValueData                                AS Name
      , ObjectString_Unit_Address.ValueData                  AS Address
      , ObjectString_Unit_Phone.ValueData                    AS Phone

      , Object_ProvinceCity.Id                               AS ProvinceCityId
      , Object_ProvinceCity.ValueData    ::TVarChar                    AS ProvinceCityName

      , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)     AS ParentId
      , Object_Parent.ValueData                              AS ParentName

      , COALESCE (Object_UserManager.Id, 0)                  AS UserManagerId
      , Object_UserManager.ValueData                         AS UserManagerName
      , Object_Member.ValueData                              AS MemberName
      , ObjectString_EMail.ValueData                         AS EMail_Member
      , ObjectString_Phone.ValueData                         AS Phone_Member

      , COALESCE (Object_UserManager2.Id, 0)                 AS UserManager2Id
      , Object_UserManager2.ValueData                        AS UserManager2Name
      , Object_Member2.ValueData                             AS Member2Name
      , ObjectString_EMail2.ValueData                        AS EMail_Member2
      , ObjectString_Phone2.ValueData                        AS Phone_Member2

      , COALESCE (Object_UserManager3.Id, 0)                 AS UserManager3Id
      , Object_UserManager3.ValueData                        AS UserManager3Name
      , Object_Member3.ValueData                             AS Member3Name
      , ObjectString_EMail3.ValueData                        AS EMail_Member3
      , ObjectString_Phone3.ValueData                        AS Phone_Member3

      , Object_Juridical.ValueData                           AS JuridicalName
      , Object_MarginCategory.ValueData                      AS MarginCategoryName
      , ObjectBoolean_isLeaf.ValueData                       AS isLeaf
      , Object_Unit.isErased                                 AS isErased

      , 0                                                    AS RouteId
      , ''::TVarChar                                         AS RouteName
      , 0                                                    AS RouteSortingId
      , ''::TVarChar                                         AS RouteSortingName

      , Object_Area.Id                                       AS AreaId
      , Object_Area.ValueData                                AS AreaName
      
      , COALESCE (Object_UnitRePrice.Id,0)          ::Integer  AS UnitRePriceId
      , COALESCE (Object_UnitRePrice.ValueData, '') ::TVarChar AS UnitRePriceName

      , COALESCE (Object_PartnerMedical.Id,0)          ::Integer  AS PartnerMedicalId
      , COALESCE (Object_PartnerMedical.ValueData, '') ::TVarChar AS PartnerMedicalName

      , COALESCE (Object_Driver.Id,0)          ::Integer     AS DriverId
      , COALESCE (Object_Driver.ValueData, '') ::TVarChar    AS DriverName
      
      , COALESCE (ObjectString_ListDaySUN.ValueData, '')    :: TVarChar AS ListDaySUN
      , COALESCE (ObjectString_ListDaySUN_pi.ValueData, '') :: TVarChar AS ListDaySUN_pi
                 
      , ObjectFloat_TaxService.ValueData                     AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData                AS TaxServiceNigth

      , COALESCE (ObjectFloat_KoeffInSUN.ValueData,0)  ::TFloat AS KoeffInSUN
      , COALESCE (ObjectFloat_KoeffOutSUN.ValueData,0) ::TFloat AS KoeffOutSUN

      , COALESCE (ObjectFloat_KoeffInSUN_v3.ValueData,0)  ::TFloat AS KoeffInSUN_v3
      , COALESCE (ObjectFloat_KoeffOutSUN_v3.ValueData,0) ::TFloat AS KoeffOutSUN_v3
      
      , CASE WHEN COALESCE (ObjectFloat_SunIncome.ValueData,0) > 0 THEN ObjectFloat_SunIncome.ValueData ELSE 30 END  ::TFloat AS SunIncome

      , ObjectDate_StartServiceNigth.ValueData               AS StartServiceNigth
      , ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

      , COALESCE (ObjectDate_Create.ValueData, NULL)  :: TDateTime  AS CreateDate
      , COALESCE (ObjectDate_Close.ValueData, NULL)   :: TDateTime  AS CloseDate
      , COALESCE (ObjectDate_TaxUnitStart.ValueData, NULL)   :: TDateTime AS TaxUnitStartDate
      , COALESCE (ObjectDate_TaxUnitEnd.ValueData, NULL)     :: TDateTime AS TaxUnitEndDate
      
      , COALESCE(ObjectBoolean_RepriceAuto.ValueData, FALSE) AS isRepriceAuto
      , COALESCE(ObjectBoolean_Over.ValueData, FALSE)        AS isOver
      , COALESCE(ObjectBoolean_UploadBadm.ValueData, FALSE)  AS isUploadBadm
      , COALESCE(ObjectBoolean_MarginCategory.ValueData, FALSE)  AS isMarginCategory
      , COALESCE(ObjectBoolean_Report.ValueData, FALSE)          AS isReport
      , COALESCE(ObjectBoolean_GoodsCategory.ValueData, FALSE)   AS isGoodsCategory
      , COALESCE(tmpByBadm.Num_byReportBadm, Null) ::Integer     AS Num_byReportBadm
      
      , ObjectDate_SP.ValueData                           :: TDateTime AS DateSP
      , ObjectDate_StartSP.ValueData                      :: TDateTime AS StartTimeSP
      , ObjectDate_EndSP.ValueData                        :: TDateTime AS EndTimeSP
      , COALESCE (ObjectBoolean_SP.ValueData, FALSE)      :: Boolean   AS isSP
      , COALESCE (ObjectBoolean_SUN.ValueData, FALSE)     :: Boolean   AS isSUN
      , COALESCE (ObjectBoolean_SUN_v2.ValueData, FALSE)  :: Boolean   AS isSUN_v2
      , COALESCE (ObjectBoolean_SUN_v3.ValueData, FALSE)  :: Boolean   AS isSUN_v3
      , COALESCE (ObjectBoolean_SUN_in.ValueData, FALSE)  :: Boolean   AS isSUN_in
      , COALESCE (ObjectBoolean_SUN_out.ValueData, FALSE) :: Boolean   AS isSUN_out
      , COALESCE (ObjectBoolean_SUN_v2_in.ValueData, FALSE)  :: Boolean   AS isSUN_v2_in
      , COALESCE (ObjectBoolean_SUN_v2_out.ValueData, FALSE) :: Boolean   AS isSUN_v2_out
      , COALESCE (ObjectBoolean_SUN_v3_in.ValueData, FALSE)  :: Boolean   AS isSUN_v3_in
      , COALESCE (ObjectBoolean_SUN_v3_out.ValueData, FALSE) :: Boolean   AS isSUN_v3_out
      
      , COALESCE (ObjectBoolean_SUN_v4.ValueData, FALSE)     :: Boolean   AS isSUN_v4
      , COALESCE (ObjectBoolean_SUN_v4_in.ValueData, FALSE)  :: Boolean   AS isSUN_v4_in
      , COALESCE (ObjectBoolean_SUN_v4_out.ValueData, FALSE) :: Boolean   AS isSUN_v4_out
      
      , COALESCE (ObjectBoolean_SUN_NotSold.ValueData, FALSE) :: Boolean  AS isSUN_NotSold
      , COALESCE (ObjectBoolean_TopNo.ValueData, FALSE)       :: Boolean  AS isTopNo
      , COALESCE (ObjectBoolean_NotCashMCS.ValueData, FALSE)     :: Boolean   AS isNotCashMCS
      , COALESCE (ObjectBoolean_NotCashListDiff.ValueData, FALSE):: Boolean   AS isNotCashListDiff
      , COALESCE (ObjectBoolean_TechnicalRediscount.ValueData, FALSE):: Boolean   AS isTechnicalRediscount
      , COALESCE (ObjectBoolean_AlertRecounting.ValueData, FALSE):: Boolean   AS isAlertRecounting

      , (CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
             THEN '��-�� '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
             ELSE ''
        END||'' ||
        CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
             THEN '�� '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
             ELSE ''
        END||''||
        CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
             THEN '�� '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
             ELSE ''
        END) :: TVarChar AS TimeWork

    FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_MarginCategory
                             ON ObjectLink_Unit_MarginCategory.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_MarginCategory.DescId = zc_ObjectLink_Unit_MarginCategory()
        LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_Unit_MarginCategory.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                             ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager
                             ON ObjectLink_Unit_UserManager.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager.DescId = zc_ObjectLink_Unit_UserManager()
        LEFT JOIN Object AS Object_UserManager ON Object_UserManager.Id = ObjectLink_Unit_UserManager.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_UserManager.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Driver
                             ON ObjectLink_Unit_Driver.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Driver.DescId = zc_ObjectLink_Unit_Driver()
        LEFT JOIN Object AS Object_Driver ON Object_Driver.Id = ObjectLink_Unit_Driver.ChildObjectId

        LEFT JOIN ObjectString AS ObjectString_ListDaySUN
                               ON ObjectString_ListDaySUN.ObjectId = Object_Unit.Id 
                              AND ObjectString_ListDaySUN.DescId = zc_ObjectString_Unit_ListDaySUN()

        LEFT JOIN ObjectString AS ObjectString_ListDaySUN_pi
                               ON ObjectString_ListDaySUN_pi.ObjectId = Object_Unit.Id 
                              AND ObjectString_ListDaySUN_pi.DescId = zc_ObjectString_Unit_ListDaySUN_pi()

        LEFT JOIN ObjectString AS ObjectString_EMail
                               ON ObjectString_EMail.ObjectId = Object_Member.Id 
                              AND ObjectString_EMail.DescId = zc_ObjectString_Member_EMail()
        LEFT JOIN ObjectString AS ObjectString_Phone
                               ON ObjectString_Phone.ObjectId = Object_Member.Id 
                              AND ObjectString_Phone.DescId = zc_ObjectString_Member_Phone()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager2
                             ON ObjectLink_Unit_UserManager2.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager2.DescId = zc_ObjectLink_Unit_UserManager2()
        LEFT JOIN Object AS Object_UserManager2 ON Object_UserManager2.Id = ObjectLink_Unit_UserManager2.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member2
                             ON ObjectLink_User_Member2.ObjectId = Object_UserManager2.Id
                            AND ObjectLink_User_Member2.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = ObjectLink_User_Member2.ChildObjectId
        
        LEFT JOIN ObjectString AS ObjectString_EMail2
                               ON ObjectString_EMail2.ObjectId = Object_Member2.Id 
                              AND ObjectString_EMail2.DescId = zc_ObjectString_Member_EMail()
        LEFT JOIN ObjectString AS ObjectString_Phone2
                               ON ObjectString_Phone2.ObjectId = Object_Member2.Id 
                              AND ObjectString_Phone2.DescId = zc_ObjectString_Member_Phone()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager3
                             ON ObjectLink_Unit_UserManager3.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager3.DescId = zc_ObjectLink_Unit_UserManager3()
        LEFT JOIN Object AS Object_UserManager3 ON Object_UserManager3.Id = ObjectLink_Unit_UserManager3.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member3
                             ON ObjectLink_User_Member3.ObjectId = Object_UserManager3.Id
                            AND ObjectLink_User_Member3.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = ObjectLink_User_Member3.ChildObjectId
        
        LEFT JOIN ObjectString AS ObjectString_EMail3
                               ON ObjectString_EMail3.ObjectId = Object_Member3.Id 
                              AND ObjectString_EMail3.DescId = zc_ObjectString_Member_EMail()
        LEFT JOIN ObjectString AS ObjectString_Phone3
                               ON ObjectString_Phone3.ObjectId = Object_Member3.Id 
                              AND ObjectString_Phone3.DescId = zc_ObjectString_Member_Phone()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                             ON ObjectLink_Unit_UnitRePrice.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()
        LEFT JOIN Object AS Object_UnitRePrice ON Object_UnitRePrice.Id = ObjectLink_Unit_UnitRePrice.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                             ON ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsCategory 
                                ON ObjectBoolean_GoodsCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_GoodsCategory.DescId = zc_ObjectBoolean_Unit_GoodsCategory()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SP 
                                ON ObjectBoolean_SP.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SP.DescId = zc_ObjectBoolean_Unit_SP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN
                                ON ObjectBoolean_SUN.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN.DescId = zc_ObjectBoolean_Unit_SUN()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2
                                ON ObjectBoolean_SUN_v2.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2.DescId = zc_ObjectBoolean_Unit_SUN_v2()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3
                                ON ObjectBoolean_SUN_v3.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3.DescId = zc_ObjectBoolean_Unit_SUN_v3()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_in
                                ON ObjectBoolean_SUN_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_in.DescId = zc_ObjectBoolean_Unit_SUN_in()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_out
                                ON ObjectBoolean_SUN_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_out.DescId = zc_ObjectBoolean_Unit_SUN_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_in
                                ON ObjectBoolean_SUN_v2_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_in.DescId = zc_ObjectBoolean_Unit_SUN_v2_in()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_out
                                ON ObjectBoolean_SUN_v2_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_out.DescId = zc_ObjectBoolean_Unit_SUN_v2_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3_in
                                ON ObjectBoolean_SUN_v3_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3_in.DescId = zc_ObjectBoolean_Unit_SUN_v3_in()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v3_out
                                ON ObjectBoolean_SUN_v3_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v3_out.DescId = zc_ObjectBoolean_Unit_SUN_v3_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4
                                ON ObjectBoolean_SUN_v4.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4.DescId = zc_ObjectBoolean_Unit_SUN_v4()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4_in
                                ON ObjectBoolean_SUN_v4_in.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4_in.DescId = zc_ObjectBoolean_Unit_SUN_v4_in()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v4_out
                                ON ObjectBoolean_SUN_v4_out.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v4_out.DescId = zc_ObjectBoolean_Unit_SUN_v4_out()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_NotSold
                                ON ObjectBoolean_SUN_NotSold.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_NotSold.DescId = zc_ObjectBoolean_Unit_SUN_NotSold()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_TopNo
                                ON ObjectBoolean_TopNo.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_TopNo.DescId = zc_ObjectBoolean_Unit_TopNo()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_TechnicalRediscount
                                ON ObjectBoolean_TechnicalRediscount.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_AlertRecounting
                                ON ObjectBoolean_AlertRecounting.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_AlertRecounting.DescId = zc_ObjectBoolean_Unit_AlertRecounting()

        LEFT JOIN ObjectString AS ObjectString_Unit_Address
                               ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

        LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                               ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                              ON ObjectFloat_TaxService.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Unit_TaxService()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxServiceNigth
                              ON ObjectFloat_TaxServiceNigth.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxServiceNigth.DescId = zc_ObjectFloat_Unit_TaxServiceNigth()

        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffInSUN
                              ON ObjectFloat_KoeffInSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffInSUN.DescId = zc_ObjectFloat_Unit_KoeffInSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffOutSUN
                              ON ObjectFloat_KoeffOutSUN.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffOutSUN.DescId = zc_ObjectFloat_Unit_KoeffOutSUN()

        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffInSUN_v3
                              ON ObjectFloat_KoeffInSUN_v3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffInSUN_v3.DescId = zc_ObjectFloat_Unit_KoeffInSUN_v3()
        LEFT JOIN ObjectFloat AS ObjectFloat_KoeffOutSUN_v3
                              ON ObjectFloat_KoeffOutSUN_v3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_KoeffOutSUN_v3.DescId = zc_ObjectFloat_Unit_KoeffOutSUN_v3()

        LEFT JOIN ObjectFloat AS ObjectFloat_SunIncome
                              ON ObjectFloat_SunIncome.ObjectId = Object_Unit.Id
                             AND ObjectFloat_SunIncome.DescId = zc_ObjectFloat_Unit_SunIncome()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto
                                ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Over
                                ON ObjectBoolean_Over.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_UploadBadm
                                ON ObjectBoolean_UploadBadm.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_MarginCategory
                                ON ObjectBoolean_MarginCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_MarginCategory.DescId = zc_ObjectBoolean_Unit_MarginCategory()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Report
                                ON ObjectBoolean_Report.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                               
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCashMCS
                                ON ObjectBoolean_NotCashMCS.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_NotCashMCS.DescId = zc_ObjectBoolean_Unit_NotCashMCS()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCashListDiff
                                ON ObjectBoolean_NotCashListDiff.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_NotCashListDiff.DescId = zc_ObjectBoolean_Unit_NotCashListDiff()

        LEFT JOIN ObjectDate AS ObjectDate_StartServiceNigth
                             ON ObjectDate_StartServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartServiceNigth.DescId = zc_ObjectDate_Unit_StartServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_EndServiceNigth
                             ON ObjectDate_EndServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndServiceNigth.DescId = zc_ObjectDate_Unit_EndServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_Create
                             ON ObjectDate_Create.ObjectId = Object_Unit.Id
                            AND ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
        LEFT JOIN ObjectDate AS ObjectDate_Close
                             ON ObjectDate_Close.ObjectId = Object_Unit.Id
                            AND ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitStart
                             ON ObjectDate_TaxUnitStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitStart.DescId = zc_ObjectDate_Unit_TaxUnitStart()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitEnd
                             ON ObjectDate_TaxUnitEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitEnd.DescId = zc_ObjectDate_Unit_TaxUnitEnd()

        LEFT JOIN ObjectDate AS ObjectDate_SP
                             ON ObjectDate_SP.ObjectId = Object_Unit.Id
                            AND ObjectDate_SP.DescId = zc_ObjectDate_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_StartSP
                             ON ObjectDate_StartSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartSP.DescId = zc_ObjectDate_Unit_StartSP()

        LEFT JOIN ObjectDate AS ObjectDate_EndSP
                             ON ObjectDate_EndSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndSP.DescId = zc_ObjectDate_Unit_EndSP()

        LEFT JOIN tmpByBadm ON tmpByBadm.UnitId = Object_Unit.Id

        LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                             ON ObjectDate_MondayStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
        LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                             ON ObjectDate_MondayEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
        LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                             ON ObjectDate_SaturdayStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
        LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                             ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
        LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                             ON ObjectDate_SundayStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
        LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                             ON ObjectDate_SundayEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()

    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND (inisShowAll = True OR Object_Unit.isErased = False);
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.04.20         * add ListDaySUN_pi
                        zc_ObjectBoolean_Unit_SUN_v4
                        zc_ObjectBoolean_Unit_SUN_v4_in
                        zc_ObjectBoolean_Unit_SUN_v4_out
 31.03.20         * 
 05.02.20         * add isSUN_NotSold
 17.12.19         * add SunIncome
 24.11.19                                                       * isNotCashMCS, isNotCashListDiff
 20.11.19         * ListDaySUN
 19.11.19         *
 23.09.19         * zc_ObjectLink_Unit_Driver
 04.09.19         * isTopNo
 11.07.19         *
 02.07.19         *
 20.03.19         *
 15.01.19         * 
 22.10.18         *
 29.08.18         * Phone
 15.09.17         * add inisShowAll
 09.08.17         * add isReport
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 31.01.17         * add isMarginCategory
 16.01.17         * add isUploadBadm
 13.10.16         * add isOver
 08.04.16         *
 24.02.16         * add RepriceAuto
 21.08.14                         *
 27.06.14         *
 25.06.13                         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit (False, '2')