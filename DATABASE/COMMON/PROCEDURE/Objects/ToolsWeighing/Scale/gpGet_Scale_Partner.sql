-- Function: gpGet_Scale_Partner()

DROP FUNCTION IF EXISTS gpGet_Scale_Partner (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Partner(
    IN inOperDate    TDateTime   ,
    IN inPartnerCode Integer     ,
    IN inSession     TVarChar      -- ������ ������������
)
RETURNS TABLE (PartnerId    Integer
             , PartnerCode  Integer
             , PartnerName  TVarChar
             , PaidKindId   Integer
             , PaidKindName TVarChar

             , PriceListId  Integer, PriceListCode  Integer, PriceListName TVarChar
             , ContractId   Integer, ContractCode   Integer, ContractNumber TVarChar, ContractTagName TVarChar

             , ChangePercent TFloat
             , ChangePercentAmount TFloat
             , isEdiOrdspr      Boolean
             , isEdiInvoice     Boolean
             , isEdiDesadv      Boolean
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY
       WITH Object_Partner AS (SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , lfGet_Object_Partner_PriceList_record (Object_Partner.Id, inOperDate) AS PriceListId
                               FROM Object AS Object_Partner
                               WHERE Object_Partner.ObjectCode = inPartnerCode
                                 AND Object_Partner.DescId = zc_Object_Partner()
                                 AND inPartnerCode > 0
                             UNION ALL
                              SELECT Object_Partner.Id             AS PartnerId
                                    , Object_Partner.ObjectCode     AS PartnerCode
                                    , Object_Partner.ValueData      AS PartnerName
                                    , lfGet_Object_Partner_PriceList_record (Object_Partner.Id, inOperDate) AS PriceListId
                               FROM Object AS Object_Partner
                               WHERE Object_Partner.Id = -1 * inPartnerCode
                                 AND Object_Partner.DescId = zc_Object_Partner()
                                 AND inPartnerCode < 0
                              )

       SELECT Object_Partner.PartnerId
            , Object_Partner.PartnerCode
            , Object_Partner.PartnerName
            , Object_PaidKind.Id                             AS PaidKindId
            , Object_PaidKind.ValueData                      AS PaidKindName

            , Object_PriceList.Id                            AS PriceListId
            , Object_PriceList.ObjectCode                    AS PriceListCode
            , Object_PriceList.ValueData                     AS PriceListName
            , Object_Contract_View.ContractId                AS ContractId
            , Object_Contract_View.ContractCode              AS ContractCode
            , Object_Contract_View.InvNumber                 AS ContractNumber
            , Object_Contract_View.ContractTagName           AS ContractTagName

            , Object_ContractCondition_PercentView.ChangePercent :: TFloat AS ChangePercent
            , CASE WHEN Object_Partner.PartnerCode = 1 THEN 1 WHEN Object_Partner.PartnerCode = 3 THEN 1 ELSE 1 END :: TFloat AS ChangePercentAmount

            , COALESCE (ObjectBoolean_Partner_EdiOrdspr.ValueData, FALSE)  :: Boolean AS isEdiOrdspr
            , COALESCE (ObjectBoolean_Partner_EdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
            , COALESCE (ObjectBoolean_Partner_EdiDesadv.ValueData, FALSE)  :: Boolean AS isEdiDesadv

       FROM Object_Partner
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = Object_Partner.PriceListId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.PartnerId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
                                          AND Object_Contract_View.InfoMoneyId = zc_Enum_InfoMoney_30101()
                                          AND Object_Contract_View.isErased = FALSE
            LEFT JOIN Object_ContractCondition_PercentView ON Object_ContractCondition_PercentView.ContractId = Object_Contract_View.ContractId

            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiOrdspr
                                    ON ObjectBoolean_Partner_EdiOrdspr.ObjectId =  Object_Partner.PartnerId
                                   AND ObjectBoolean_Partner_EdiOrdspr.DescId = zc_ObjectBoolean_Partner_EdiOrdspr()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiInvoice
                                    ON ObjectBoolean_Partner_EdiInvoice.ObjectId =  Object_Partner.PartnerId
                                   AND ObjectBoolean_Partner_EdiInvoice.DescId = zc_ObjectBoolean_Partner_EdiInvoice()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_EdiDesadv
                                    ON ObjectBoolean_Partner_EdiDesadv.ObjectId =  Object_Partner.PartnerId
                                   AND ObjectBoolean_Partner_EdiDesadv.DescId = zc_ObjectBoolean_Partner_EdiDesadv()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Partner (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.01.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_Partner ('01.01.2015', '0', zfCalc_UserAdmin())
