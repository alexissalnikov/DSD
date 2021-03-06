-- Function: gpGet_Scale_PartnerParams()

-- DROP FUNCTION IF EXISTS gpGet_Scale_PartnerParams (TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_PartnerParams (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_PartnerParams(
    IN inOperDate     TDateTime   ,
    IN inPartnerId    Integer     ,
    IN inContractId   Integer     ,
    IN inSession      TVarChar      -- ������ ������������
)
RETURNS TABLE (PartnerId       Integer, PartnerCode       Integer, PartnerName       TVarChar
             , PriceListId     Integer, PriceListCode     Integer, PriceListName     TVarChar
             , GoodsPropertyId Integer, GoodsPropertyCode Integer, GoodsPropertyName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
           WITH tmpPartner AS (SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , lfGet_Object_Partner_PriceList_record (inContractId, Object_Partner.Id, inOperDate)            AS PriceListId
                                    , zfCalc_GoodsPropertyId (inContractId, ObjectLink_Partner_Juridical.ChildObjectId, inPartnerId) AS GoodsPropertyId
                               FROM Object AS Object_Partner
                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                WHERE Object_Partner.Id       = inPartnerId
                                  AND Object_Partner.DescId   = zc_Object_Partner()
                                  AND Object_Partner.isErased = FALSE
                              UNION ALL
                               SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , zc_PriceList_Basis()          AS PriceListId
                                    , 0                             AS GoodsPropertyId
                               FROM Object AS Object_Partner
                                    LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                         ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                        AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                WHERE Object_Partner.Id       = inPartnerId
                                  AND Object_Partner.DescId   IN (zc_Object_Unit(), zc_Object_ArticleLoss())
                                  AND Object_Partner.isErased = FALSE
                                  AND inContractId            >= 0
                              UNION ALL
                               SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , zc_PriceList_Basis()          AS PriceListId
                                    , 0                             AS GoodsPropertyId
                               FROM Object AS Object_Partner
                                WHERE Object_Partner.Id       = inPartnerId
                                  AND Object_Partner.DescId   = (-1 * inContractId)
                                  AND Object_Partner.isErased = FALSE
                                  AND inContractId            IN (-1 * zc_Object_Member(), -1 * zc_Object_Car())
                             )

       SELECT tmpPartner.PartnerId
            , tmpPartner.PartnerCode
            , tmpPartner.PartnerName

            , Object_PriceList.Id                  AS PriceListId
            , Object_PriceList.ObjectCode          AS PriceListCode
            , Object_PriceList.ValueData           AS PriceListName

            , Object_GoodsProperty.Id              AS GoodsPropertyId
            , Object_GoodsProperty.ObjectCode      AS GoodsPropertyCode
            , Object_GoodsProperty.ValueData       AS GoodsPropertyName

       FROM tmpPartner
            LEFT JOIN Object AS Object_PriceList     ON Object_PriceList.Id     = tmpPartner.PriceListId
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = tmpPartner.GoodsPropertyId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_PartnerParams (TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.05.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_PartnerParams ('01.01.2015', 1, 1, zfCalc_UserAdmin())
