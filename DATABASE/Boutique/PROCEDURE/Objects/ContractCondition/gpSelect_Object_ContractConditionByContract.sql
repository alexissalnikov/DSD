-- Function: gpSelect_Object_ContractConditionByContract(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractConditionByContract(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractConditionByContract(
    IN inContractId  Integer,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Value TFloat
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar      
             , BonusKindId Integer, BonusKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractSendId Integer, ContractSendName TVarChar 
             , ContractStateKindCode_Send Integer
             , ContractTagName_Send TVarChar             
             , InfoMoneyCode_Send Integer, InfoMoneyName_Send TVarChar
             , JuridicalCode_Send Integer, JuridicalName_Send TVarChar
             , Comment TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractCondition());

   RETURN QUERY 
     SELECT 
           Object_ContractCondition.Id        AS Id
           
         , ObjectFloat_Value.ValueData     AS Value  
                                                        
         , Object_ContractConditionKind.Id          AS ContractConditionKindId
         , Object_ContractConditionKind.ValueData   AS ContractConditionKindName

         , Object_BonusKind.Id          AS BonusKindId
         , Object_BonusKind.ValueData   AS BonusKindName
 
         , Object_InfoMoney.Id          AS InfoMoneyId
         , Object_InfoMoney.ValueData   AS InfoMoneyName

         , Object_ContractSend.Id               AS ContractSendId
         , Object_ContractSend.ValueData        AS ContractSendName
         , Object_ContractSendStateKind.ObjectCode  AS ContractStateKindCode_Send
         , Object_ContractSendTag.ValueData         AS ContractTagName_Send
         , Object_InfoMoneySend.ObjectCode      AS InfoMoneyCode_Send
         , Object_InfoMoneySend.ValueData       AS InfoMoneyName_Send 
         , Object_JuridicalSend.ObjectCode      AS JuridicalCode_Send
         , Object_JuridicalSend.ValueData       AS JuridicalName_Send 

          
         , Object_ContractCondition.ValueData AS Comment
         
         , Object_ContractCondition.isErased AS isErased
         
     FROM ObjectLink AS ObjectLink_ContractCondition_Contract
          LEFT JOIN Object AS Object_ContractCondition ON Object_ContractCondition.Id = ObjectLink_ContractCondition_Contract.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                               ON ObjectLink_ContractCondition_ContractConditionKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
          LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_BonusKind
                               ON ObjectLink_ContractCondition_BonusKind.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_BonusKind.DescId = zc_ObjectLink_ContractCondition_BonusKind()
          LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = ObjectLink_ContractCondition_BonusKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_InfoMoney
                               ON ObjectLink_ContractCondition_InfoMoney.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_InfoMoney.DescId = zc_ObjectLink_ContractCondition_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = ObjectLink_ContractCondition_InfoMoney.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractCondition_ContractSend
                               ON ObjectLink_ContractCondition_ContractSend.ObjectId = Object_ContractCondition.Id
                              AND ObjectLink_ContractCondition_ContractSend.DescId = zc_ObjectLink_ContractCondition_ContractSend()
          LEFT JOIN Object AS Object_ContractSend ON Object_ContractSend.Id = ObjectLink_ContractCondition_ContractSend.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_Juridical
                               ON ObjectLink_ContractSend_Juridical.ObjectId = Object_ContractSend.Id 
                              AND ObjectLink_ContractSend_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
          LEFT JOIN Object AS Object_JuridicalSend ON Object_JuridicalSend.Id = ObjectLink_ContractSend_Juridical.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractTag
                               ON ObjectLink_ContractSend_ContractTag.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
          LEFT JOIN Object AS Object_ContractSendTag ON Object_ContractSendTag.Id = ObjectLink_ContractSend_ContractTag.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_ContractStateKind
                               ON ObjectLink_ContractSend_ContractStateKind.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
          LEFT JOIN Object AS Object_ContractSendStateKind ON Object_ContractSendStateKind.Id = ObjectLink_ContractSend_ContractStateKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ContractSend_InfoMoney
                               ON ObjectLink_ContractSend_InfoMoney.ObjectId = Object_ContractSend.Id
                              AND ObjectLink_ContractSend_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN Object AS Object_InfoMoneySend ON Object_InfoMoneySend.Id = ObjectLink_ContractSend_InfoMoney.ChildObjectId

           
          LEFT JOIN ObjectFloat AS ObjectFloat_Value 
                                ON ObjectFloat_Value.ObjectId = Object_ContractCondition.Id 
                               AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
          
     WHERE ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()
       AND ObjectLink_ContractCondition_Contract.ChildObjectId = inContractId;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractConditionByContract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 02.03.16         *
 14.03.14         * add InfoMoney
 18.12.13                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractConditionByContract (0,'2')