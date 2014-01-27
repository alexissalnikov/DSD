-- Function: gpSelect_Movement_SendDebt()

DROP FUNCTION IF EXISTS gpSelect_Movement_SendDebt (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SendDebt(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , JuridicalBasisName TVarChar
             , BusinessName TVarChar

             , InfoMoneyGroupFromName TVarChar
             , InfoMoneyDestinationFromName TVarChar
             , InfoMoneyFromId Integer, InfoMoneyFromCode Integer, InfoMoneyFromName TVarChar
             , ContractFromId Integer, ContractFromName TVarChar
             , JuridicalFromId Integer, JuridicalFromCode Integer, JuridicalFromName TVarChar
             , FromOKPO TVarChar
             , PaidKindFromId Integer, PaidKindFromName TVarChar

             , InfoMoneyGroupToName TVarChar
             , InfoMoneyDestinationToName TVarChar
             , InfoMoneyToId Integer, InfoMoneyToCode Integer, InfoMoneyToName TVarChar
             , ContractToId Integer, ContractToName TVarChar
             , JuridicalToId Integer, JuridicalToCode Integer, JuridicalToName TVarChar
             , ToOKPO TVarChar
             , PaidKindToId Integer, PaidKindToName TVarChar
             
             , Amount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_SendDebt());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementFloat_TotalSumm.ValueData AS TotalSumm
                      
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Business.ValueData AS BusinessName

            , View_InfoMoney_From.InfoMoneyGroupName       AS InfoMoneyGroupFromName
            , View_InfoMoney_From.InfoMoneyDestinationName AS InfoMoneyDestinationFromName
            , View_InfoMoney_From.InfoMoneyId              AS InfoMoneyFromId
            , View_InfoMoney_From.InfoMoneyCode            AS InfoMoneyFromCode
            , View_InfoMoney_From.InfoMoneyName            AS InfoMoneyFromName

            , View_Contract_InvNumber_From.ContractId  AS ContractFromId
            , View_Contract_InvNumber_From.InvNumber   AS ContractFromName

            , Object_Juridical_From.Id                 AS JuridicalFromId
            , Object_Juridical_From.ObjectCode         AS JuridicalFromCode
            , Object_Juridical_From.ValueData          AS JuridicalFromName
            , ObjectHistory_JuridicalDetails_From.OKPO AS FromOKPO
            , Object_PaidKind_From.Id                  AS PaidKindFromId
            , Object_PaidKind_From.ValueData           AS PaidKindFromName


            , View_InfoMoney_To.InfoMoneyGroupName       AS InfoMoneyGroupToName
            , View_InfoMoney_To.InfoMoneyDestinationName AS InfoMoneyDestinationToName
            , View_InfoMoney_To.InfoMoneyId              AS InfoMoneyToId
            , View_InfoMoney_To.InfoMoneyCode            AS InfoMoneyToCode
            , View_InfoMoney_To.InfoMoneyName            AS InfoMoneyToName

            , View_Contract_InvNumber_To.ContractId  AS ContractToId
            , View_Contract_InvNumber_To.InvNumber   AS ContractToName

            , Object_Juridical_To.Id                 AS JuridicalToId
            , Object_Juridical_To.ObjectCode         AS JuridicalToCode
            , Object_Juridical_To.ValueData          AS JuridicalToName
            , ObjectHistory_JuridicalDetails_To.OKPO AS ToOKPO
            , Object_PaidKind_To.Id                  AS PaidKindToId
            , Object_PaidKind_To.ValueData           AS PaidKindToName

            , MI_Master.Amount         AS Amount

       FROM Movement
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                         ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                        AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = MovementLinkObject_JuridicalBasis.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                         ON MovementLinkObject_Business.MovementId = Movement.Id
                                        AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = MovementLinkObject_Business.ObjectId


            LEFT JOIN MovementItem AS MI_Master ON MI_Master.MovementId = Movement.Id
                                         AND MI_Master.DescId     = zc_MI_Master()

            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = MI_Master.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_From ON ObjectHistory_JuridicalDetails_From.JuridicalId = Object_Juridical_From.Id 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney_From
                                             ON MILinkObject_InfoMoney_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_InfoMoney_From.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_From ON View_InfoMoney_From.InfoMoneyId = MILinkObject_InfoMoney_From.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract_From
                                             ON MILinkObject_Contract_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_Contract_From.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_From ON View_Contract_InvNumber_From.ContractId = MILinkObject_Contract_From.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind_From
                                             ON MILinkObject_PaidKind_From.MovementItemId = MI_Master.Id
                                            AND MILinkObject_PaidKind_From.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_From ON Object_PaidKind_From.Id = MILinkObject_PaidKind_From.ObjectId

            
            LEFT JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id
                                         AND MI_Child.DescId     = zc_MI_Child()
                                         
            LEFT JOIN Object AS Object_Juridical_To ON Object_Juridical_To.Id = MI_Child.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View AS ObjectHistory_JuridicalDetails_To ON ObjectHistory_JuridicalDetails_To.JuridicalId = Object_Juridical_To.Id 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney_To
                                             ON MILinkObject_InfoMoney_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_InfoMoney_To.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney_To ON View_InfoMoney_To.InfoMoneyId = MILinkObject_InfoMoney_To.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract_To
                                             ON MILinkObject_Contract_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_Contract_To.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_To ON View_Contract_InvNumber_To.ContractId = MILinkObject_Contract_To.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind_To
                                             ON MILinkObject_PaidKind_To.MovementItemId = MI_Child.Id
                                            AND MILinkObject_PaidKind_To.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_To ON Object_PaidKind_To.Id = MILinkObject_PaidKind_To.ObjectId

      WHERE Movement.DescId = zc_Movement_SendDebt()
        AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_SendDebt (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 24.01.14         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_SendDebt (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
