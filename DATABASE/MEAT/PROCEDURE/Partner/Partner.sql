DO $$
   DECLARE vbAdmin integer;
BEGIN

delete from partner where kodbranch ='' and namebranch = ''  and juridicalname = '';
UPDATE partner SET PartnerId = null;


  vbAdmin :=  (SELECT 
         Object_User.Id
   FROM Object AS Object_User
   WHERE (Object_User.ValueData = '�����') AND (Object_User.DescId = zc_Object_User()));


PERFORM gpInsertUpdate_Object_StreetKind(0, 0, streettype, vbAdmin::TVarChar) 
  FROM   (
SELECT streettype
  FROM partner
GROUP BY streettype) AS streettype 
WHERE (streettype.streettype <> '') AND (NOT (streettype.streettype IN ( SELECT Name FROM gpSelect_Object_StreetKind('')))) ;

PERFORM gpInsertUpdate_Object_CityKind(0, 0, citytype, vbAdmin::TVarChar) 
  FROM   (
SELECT citytype
  FROM partner
GROUP BY citytype) AS citytype 
WHERE (citytype.citytype <> '') AND  (NOT (citytype.citytype IN ( SELECT Name FROM gpSelect_Object_CityKind(''))));

PERFORM gpInsertUpdate_Object_Region(0, 0, region, vbAdmin::TVarChar) 
  FROM   (
SELECT upper(trim(region)) as region
  FROM partner
GROUP BY  upper(trim(region)) ) AS region 
WHERE (upper(trim(region)) <> '') AND (NOT (region.region IN ( SELECT Name FROM gpSelect_Object_Region('')))) ;


PERFORM gpInsertUpdate_Object_City(0, 0, cityname, CityKind.Id, Region.Id, 0, vbAdmin::TVarChar)
 FROM 

(SELECT citytype, cityname, upper(trim(region)) AS Region


  FROM partner
 
WHERE cityname <> ''  
  
GROUP BY citytype, cityname, upper(trim(region))) AS partner

  
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Partner.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_Region('') AS Region ON Partner.Region = Region.Name
WHERE (cityname <> '') AND (NOT (cityname, CityKind.Id , Region.Id)  IN (
SELECT Name, CityKindId, RegionId FROM gpSelect_Object_City('') ORDER BY Name));

PERFORM gpInsertUpdate_Object_Street(0, 0, streetname, '', StreetKind.Id, City.Id, 0, vbAdmin::TVarChar) 
FROM (SELECT trim(citytype) AS citytype
     , trim(cityname) AS cityname
     , trim(regiontype) AS regiontype
     , upper(trim(region)) AS region
     , trim(streettype) AS streettype
     , trim(streetname) AS streetname
  FROM partner WHERE streetname <> ''
group BY trim(citytype)
       , trim(cityname)
       , trim(regiontype)
       , upper(trim(region))
       , trim(streettype)
       , trim(streetname)
ORDER BY streetname) AS Street

  LEFT JOIN gpSelect_Object_Region('') AS Region ON Street.Region = Region.Name
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Street.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_City('') AS City ON Street.cityname = City.Name AND City.CityKindId = CityKind.Id
  LEFT JOIN gpSelect_Object_StreetKind('') AS StreetKind ON Street.StreetType = StreetKind.Name
  
WHERE (streetname <> '') AND (NOT (streetname, StreetKind.Id, City.Id)  IN (
SELECT Name, StreetKindId, CityId FROM gpSelect_Object_Street('') ORDER BY Name));

UPDATE partner SET PartnerId = Object_Partner.Id

       FROM Object AS Object_Partner1CLink
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
             WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()  AND partner.codett1c <> ''
       AND partner.codett1c::integer = Object_Partner1CLink.ObjectCode
                             AND zfGetBranchFromBranchCode(kodbranch::integer) = ObjectLink_Partner1CLink_Branch.ChildObjectId;


PERFORM ObjectPartner.Name, ObjectRegion.name, ObjectCity.*, ObjectStreet.*, partner.*,  

gpInsertUpdate_Object_Partner(
 ObjectPartner.Id,    -- ���� ������� <����������> 
    ObjectPartner.Code                ,    -- ��� ������� <����������> 
    ObjectPartner.ShortName           ,    -- ������� ������������
    ObjectPartner.GLNCode             ,    -- ��� GLN
    partner.House         ,    -- ����� ����
    ''::TVarChar          ,    -- ����� �������
    ''::TVarChar          ,    -- ����� ��������
    ObjectStreet.Id            ,    -- �����/��������  
    ObjectPartner.PrepareDayCount     ,    -- �� ������� ���� ����������� �����
    ObjectPartner.DocumentDayCount    ,    -- ����� ������� ���� ����������� �������������
    ObjectPartner.JuridicalId         ,    -- ����������� ����
    ObjectPartner.RouteId             ,    -- �������
    ObjectPartner.RouteSortingId      ,    -- ���������� ���������
    ObjectPartner.PersonalTakeId      ,    -- ��������� (����������) 
    
    ObjectPartner.PriceListId         ,    -- �����-����
    ObjectPartner.PriceListPromoId    ,    -- �����-����(���������)
    ObjectPartner.StartPromo          ,    -- ���� ������ �����
    ObjectPartner.EndPromo            ,    -- ���� ��������� �����     
    
    vbAdmin::TVarChar
)


FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
HAVING COUNT(*) = 1

UNION
SELECT Count(*), ObjectPartner.Id
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) > 1

) AS dd 
JOIN partner ON dd.Id = partner.partnerId
JOIN gpSelect_Object_Partner(0, '') AS ObjectPartner ON ObjectPartner.id = partner.partnerId
JOIN gpSelect_Object_Region('') AS ObjectRegion ON ObjectRegion.name = upper(Partner.Region)
JOIN gpSelect_Object_City('') AS ObjectCity ON ObjectCity.Name = Partner.cityname AND ObjectCity.RegionId = ObjectRegion.Id 
JOIN gpSelect_Object_Street('') AS ObjectStreet ON ObjectStreet.Name = Partner.StreetName AND ObjectStreet.CityName = partner.CityName
                                AND ObjectStreet.StreetKindName = Partner.StreetType
;


-- ����� �������� ������ ����� �������, ��� �� ����� ������������ ������ �� ������ ��������
-- ��������� �� �� ������� �������� �����������

UPDATE partner SET partnerId = dd.PartnerId

FROM  

(select right(left(PartnerId::TEXT,7),6)::integer as PartnerId, codett1C from (SELECT gpInsertUpdate_Object_Partner(
 0,    -- ���� ������� <����������> 
    0                ,    -- ��� ������� <����������> 
    ObjectPartner.ShortName           ,    -- ������� ������������
    ObjectPartner.GLNCode             ,    -- ��� GLN
    partner.House         ,    -- ����� ����
    ''::TVarChar          ,    -- ����� �������
    ''::TVarChar          ,    -- ����� ��������
    ObjectStreet.Id            ,    -- �����/��������  
    ObjectPartner.PrepareDayCount     ,    -- �� ������� ���� ����������� �����
    ObjectPartner.DocumentDayCount    ,    -- ����� ������� ���� ����������� �������������
    ObjectPartner.JuridicalId         ,    -- ����������� ����
    ObjectPartner.RouteId             ,    -- �������
    ObjectPartner.RouteSortingId      ,    -- ���������� ���������
    ObjectPartner.PersonalTakeId      ,    -- ��������� (����������) 
    
    ObjectPartner.PriceListId         ,    -- �����-����
    ObjectPartner.PriceListPromoId    ,    -- �����-����(���������)
    ObjectPartner.StartPromo          ,    -- ���� ������ �����
    ObjectPartner.EndPromo            ,    -- ���� ��������� �����     
    
    vbAdmin::TVarChar
) AS PartnerId, partner.codett1C, 
  -- ��� �� ������ ����� � 1� � ��������
     lpUpdate_Object_Partner1CLink_Null(partner.codett1C::integer, ObjectPartner.Id, zfGetBranchFromBranchCode(kodbranch::integer))
 FROM 
(SELECT Count(*), ObjectPartner.Id, partner.codett1C,  partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName--, partner.StreetKindType, partner.*
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.codett1C,  partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) = 1
) dd 
JOIN partner ON dd.codett1C = partner.codett1C
JOIN gpSelect_Object_Partner(0, '') AS ObjectPartner ON ObjectPartner.id = partner.partnerId
JOIN gpSelect_Object_Region('') AS ObjectRegion ON ObjectRegion.name = upper(Partner.Region)
JOIN gpSelect_Object_City('') AS ObjectCity ON ObjectCity.Name = Partner.cityname AND ObjectCity.RegionId = ObjectRegion.Id 
JOIN gpSelect_Object_Street('') AS ObjectStreet ON ObjectStreet.Name = Partner.StreetName AND ObjectStreet.CityName = partner.CityName
                                AND ObjectStreet.StreetKindName = Partner.StreetType

ORDER BY 2) AS dd) AS dd  

WHERE partner.codett1C = dd.codett1C; 

-- � ���������� ����� � �����������
SELECT  gpInsertUpdate_Object_Partner1CLink(
    Partner1CLink.Id,    -- ���� �������
    Partner.codett1c::INTEGER,    -- ��� �������
    Partner.ttin1C,   -- �������� �������
    Partner.PartnerId              ,    -- 
    zfGetBranchFromBranchCode(kodbranch::integer),    -- 
    0,    -- 
    0,    -- 
    false,    -- 
    vbAdmin::TVarChar       -- ������ ������������
)
FROM Partner
LEFT JOIN gpSelect_Object_Partner1CLink('') AS Partner1CLink ON Partner1CLink.PartnerId = Partner.PartnerId
     AND Partner1CLink.Code = Partner.codett1c::INTEGER
     AND Partner1CLink.BranchId = zfGetBranchFromBranchCode(kodbranch::integer);



/*



��� ��� ���������!!!

SELECT Count(*), ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName--, partner.StreetKindType, partner.*
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) = 1

  */


END $$;


--SELECT  codett1c, ttin1c, Object_Partner.Id, Object_Partner.valuedata
--  FROM partner
--            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = partner.PartnerId;/