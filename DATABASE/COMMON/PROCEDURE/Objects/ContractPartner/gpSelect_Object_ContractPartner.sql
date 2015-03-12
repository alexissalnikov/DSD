-- Function: gpSelect_Object_ContractPartner (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractPartner (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractPartner(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, InvNumber TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
             , isConnected Boolean
             , isErased Boolean
        
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractPartner());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_ContractPartner.Id          AS Id
           , Object_ContractPartner.ObjectCode  AS Code
         
           , Object_Contract_View.ContractId    AS ContractId
           , Object_Contract_View.InvNumber     AS InvNumber

           , Object_Partner.Id         AS PartnerId
           , Object_Partner.ObjectCode AS PartnerCode
           , Object_Partner.ValueData  AS PartnerName
       
           , TRUE AS isConnected
           , Object_ContractPartner.isErased    AS isErased

           
       FROM Object AS Object_ContractPartner
                                                            
            LEFT JOIN ObjectLink AS ContractPartner_Contract
                                 ON ContractPartner_Contract.ObjectId = Object_ContractPartner.Id
                                AND ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ContractPartner_Contract.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                 ON ObjectLink_ContractPartner_Partner.ObjectId = Object_ContractPartner.Id
                                AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_ContractPartner_Partner.ChildObjectId

     WHERE Object_ContractPartner.DescId = zc_Object_ContractPartner()
   UNION ALL
       SELECT 
             0 :: Integer  AS Id
           , 0 :: Integer  AS Code
         
           , Object_Contract_View.ContractId    AS ContractId
           , Object_Contract_View.InvNumber     AS InvNumber

           , Object_Partner.Id         AS PartnerId
           , Object_Partner.ObjectCode AS PartnerCode
           , Object_Partner.ValueData  AS PartnerName
       
           , FALSE AS isConnected
           , Object_Partner.isErased   AS isErased
           
       FROM Object AS Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId
       WHERE Object_Partner.DescId = zc_Object_Partner()
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractPartner(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.02.15         * 
 
        
*/

-- ����
--SELECT * FROM gpSelect_Object_ContractPartner (zfCalc_UserAdmin())