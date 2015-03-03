-- View: Object_ContractCondition_PercentView

-- DROP VIEW IF EXISTS Object_ContractCondition_PercentView;

CREATE OR REPLACE VIEW Object_ContractCondition_PercentView AS
  SELECT ObjectLink_ContractCondition_Contract.ChildObjectId  AS ContractId

       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePercent() THEN ObjectFloat_Value.ValueData ELSE NULL END) AS ChangePercent
       , MAX (CASE WHEN tmpContractConditionKind.Id = zc_Enum_ContractConditionKind_ChangePrice()   THEN ObjectFloat_Value.ValueData ELSE NULL END) AS ChangePrice
       
  FROM (SELECT zc_Enum_ContractConditionKind_ChangePercent() AS Id UNION ALL SELECT zc_Enum_ContractConditionKind_ChangePrice() AS Id) AS tmpContractConditionKind
       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                             ON ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId = tmpContractConditionKind.Id
                            AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
       INNER JOIN ObjectFloat AS ObjectFloat_Value
                              ON ObjectFloat_Value.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                             AND ObjectFloat_Value.DescId = zc_ObjectFloat_ContractCondition_Value()
                             AND ObjectFloat_Value.ValueData <> 0
       INNER JOIN ObjectLink AS ObjectLink_ContractCondition_Contract
                             ON ObjectLink_ContractCondition_Contract.ObjectId = ObjectLink_ContractCondition_ContractConditionKind.ObjectId
                            AND ObjectLink_ContractCondition_Contract.DescId = zc_ObjectLink_ContractCondition_Contract()

  GROUP BY ObjectLink_ContractCondition_Contract.ChildObjectId;


ALTER TABLE Object_ContractCondition_PercentView  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.11.13                                        *
*/

-- ����
-- SELECT * FROM Object_ContractCondition_PercentView
