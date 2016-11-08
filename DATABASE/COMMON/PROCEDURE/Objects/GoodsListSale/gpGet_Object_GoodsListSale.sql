-- Function: gpGet_Object_GoodsListSale (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsListSale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsListSale(
    IN inId                     Integer,       -- ���� ������� <>
    IN inSession                TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , UpdateDate TDateTime
             , GoodsId Integer, GoodsName TVarChar
             , ContractId Integer, ContractName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsListSale());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
    
           , CAST (Null as TDateTime) AS UpdateDate

           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName

           , CAST (0 as Integer)    AS ContractId
           , CAST ('' as TVarChar)  AS ContractName  

           , CAST (0 as Integer)    AS JuridicalId
           , CAST ('' as TVarChar)  AS JuridicalName
           
           , CAST (0 as Integer)    AS PartnerId
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (NULL AS Boolean) AS isErased

       ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsListSale.Id          AS Id
          
           , ObjectDate_Protocol_Update.ValueData AS UpdateDate

           , Object_Goods.Id                  AS GoodsId
           , Object_Goods.ValueData           AS GoodsName
                     
           , Object_Contract.Id               AS ContractId
           , Object_Contract.ValueData        AS ContractName

           , Object_Juridical.Id              AS JuridicalId
           , Object_Juridical.ValueData       AS JuridicalName

           , Object_Partner.Id                AS PartnerId
           , Object_Partner.ValueData         AS PartnerName

           , Object_GoodsListSale.isErased    AS isErased
           
       FROM Object AS Object_GoodsListSale
            LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                                 ON ObjectDate_Protocol_Update.ObjectId = Object_GoodsListSale.Id
                                AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                 ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsListSale_Goods.ChildObjectId

            LEFT JOIN ObjectLink AS GoodsListSale_Contract
                                 ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                                AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = GoodsListSale_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                                 ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_GoodsListSale_Juridical.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                 ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_GoodsListSale_Partner.ChildObjectId
            
       WHERE Object_GoodsListSale.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.10.16         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsListSale (0, inSession := '5')