-- Function: gpGet_Movement_Cash()

DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_Cash (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Cash(
    IN inMovementId        Integer   , -- ���� ���������
    IN inOperDate          TDateTime , -- 
    IN inCashId            Integer   , -- 
    IN inCurrencyId        Integer   , -- 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat 
             , AmountOut TFloat 
             , AmountSumm TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , MemberId Integer, MemberName TVarChar
             , PositionId Integer, PositionName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , MovementId_Partion Integer, PartionMovementName TVarChar
             , MovementId_Invoice Integer, InvNumber_Invoice TVarChar, Comment_Invoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN

     RETURN QUERY 
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_Cash_seq') AS TVarChar)  AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime)                  AS OperDate
           , inOperDate                                        AS OperDate
           , lfObject_Status.Code                              AS StatusCode
           , lfObject_Status.Name                              AS StatusName
           
           , 0::TFloat                                         AS AmountIn
           , 0::TFloat                                         AS AmountOut
           , 0::TFloat                                         AS AmountSumm

           , DATE_TRUNC ('Month', inOperDate - INTERVAL '1 MONTH') :: TDateTime AS ServiceDate
           , ''::TVarChar                                      AS Comment
           , COALESCE (Object_Cash.Id, 0)                      AS CashId
           , COALESCE (Object_Cash.ValueData, '') :: TVarChar  AS CashName
           , 0                                                 AS MoneyPlaceId
           , CAST ('' as TVarChar)                             AS MoneyPlaceName
           , 0                                                 AS InfoMoneyId
           , CAST ('' as TVarChar)                             AS InfoMoneyName
           , 0                                                 AS MemberId
           , CAST ('' as TVarChar)                             AS MemberName
           , 0                                                 AS PositionId
           , CAST ('' as TVarChar)                             AS PositionName
           , 0                                                 AS ContractId
           , ''::TVarChar                                      AS ContractInvNumber
           , 0                                                 AS UnitId
           , CAST ('' as TVarChar)                             AS UnitName

           , Object_Currency.Id                AS CurrencyId
           , Object_Currency.ValueData         AS CurrencyName
           , 0 :: TFloat                                       AS CurrencyValue
           , 0 :: TFloat                                       AS ParValue
           , 0 :: TFloat                                       AS CurrencyPartnerValue
           , 0 :: TFloat                                       AS ParPartnerValue

           , 0                          AS MovementId_Partion
           , CAST ('' AS TVarChar)  	AS PartionMovementName

           , 0                                                 AS MovementId_Invoice
           , CAST ('' as TVarChar)                             AS InvNumber_Invoice
           , CAST ('' as TVarChar)                             AS Comment_Invoice

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = inCashId -- IN (SELECT MIN (Object.Id) FROM Object WHERE Object.AccessKeyId IN (SELECT MIN (lpGetAccessKey) FROM lpGetAccessKey (vbUserId, zc_Enum_Process_Get_Movement_Cash())))
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                   ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                  AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = CASE WHEN COALESCE (inCurrencyId,0) = 0 THEN ObjectLink_Cash_Currency.ChildObjectId ELSE inCurrencyId END
      ;
     ELSE
          -- ��������
          IF EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.ParentId >0)
          THEN
              RAISE EXCEPTION '������.�������� ����� ���� ������� ������ ����� <�����, ������� �� ���������>.';
          END IF;
     
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
                      
--           , CASE WHEN MovementItem.Amount > 0 THEN MovementItem.Amount ELSE 0 END::TFloat AS AmountIn
--           , CASE WHEN MovementItem.Amount < 0 THEN -1 * MovementItem.Amount ELSE 0 END::TFloat AS AmountOut
           , CASE WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData > 0 THEN
                       MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount > 0 THEN
                       MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountIn
           , CASE WHEN MILinkObject_Currency.ObjectId <> zc_Enum_Currency_Basis() AND MovementFloat_AmountCurrency.ValueData < 0 THEN
                       -1 * MovementFloat_AmountCurrency.ValueData
                  WHEN MovementItem.Amount < 0 THEN
                       -1 * MovementItem.Amount
                  ELSE
                      0
                  END::TFloat AS AmountOut
           
           , MovementFloat_Amount.ValueData    AS AmountSumm

           , COALESCE (MIDate_ServiceDate.ValueData, Movement.OperDate) AS ServiceDate
           , MIString_Comment.ValueData        AS Comment

           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName
           , Object_MoneyPlace.Id              AS MoneyPlaceId
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , Object_Member.Id                   AS MemberId
           , Object_Member.ValueData            AS MemberName
           , Object_Position.Id                 AS PositionId
           , Object_Position.ValueData          AS PositionName
           , View_Contract_InvNumber.ContractId AS ContractId
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName

           , Object_Currency.Id                AS CurrencyId
           , Object_Currency.ValueData         AS CurrencyName
           , MovementFloat_CurrencyValue.ValueData        AS CurrencyValue
           , MovementFloat_ParValue.ValueData             AS ParValue
           , MovementFloat_CurrencyPartnerValue.ValueData AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData      AS ParPartnerValue
           
           , MIFloat_MovementId.ValueData :: Integer AS MovementId_Partion
           , zfCalc_PartionMovementName (Movement_PartionMovement.DescId, MovementDesc_PartionMovement.ItemName, Movement_PartionMovement.InvNumber, MovementDate_OperDatePartner_PartionMovement.ValueData) AS PartionMovementName

           , Movement_Invoice.Id                 AS MovementId_Invoice
           , zfCalc_PartionMovementName (Movement_Invoice.DescId, MovementDesc_Invoice.ItemName, COALESCE (MovementString_InvNumberPartner.ValueData,'') || '/' || Movement_Invoice.InvNumber, Movement_Invoice.OperDate) AS InvNumber_Invoice
           , MS_Comment_Invoice.ValueData        AS Comment_Invoice

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementFloat AS MovementFloat_Amount
                                    ON MovementFloat_Amount.MovementId = Movement.Id
                                   AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                           ON MLM_Invoice.MovementId = Movement.Id
                                          AND MLM_Invoice.DescId = zc_MovementLinkMovement_Invoice()
            LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Invoice.MovementChildId
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement_Invoice.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            LEFT JOIN MovementDesc AS MovementDesc_Invoice ON MovementDesc_Invoice.Id = Movement_Invoice.DescId
            LEFT JOIN MovementString AS MS_Comment_Invoice
                                     ON MS_Comment_Invoice.MovementId = Movement_Invoice.Id
                                    AND MS_Comment_Invoice.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_PartionMovement ON Movement_PartionMovement.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDesc AS MovementDesc_PartionMovement ON MovementDesc_PartionMovement.Id = Movement_PartionMovement.DescId
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner_PartionMovement
                                   ON MovementDate_OperDatePartner_PartionMovement.MovementId =  Movement_PartionMovement.Id
                                  AND MovementDate_OperDatePartner_PartionMovement.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId
 
            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                             ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Currency.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = MILinkObject_Currency.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_AmountCurrency
                                    ON MovementFloat_AmountCurrency.MovementId = Movement.Id
                                   AND MovementFloat_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()

       WHERE Movement.Id =  inMovementId;

   END IF;  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Movement_Cash (Integer, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 21.05.17         * add inCurrencyId
 26.07.16         * invoice
 27.04.15         * add MIFloat_MovementId (sale)
 06.03.15         * add Currency...
 30.08.14                                        * all
 25.01.14                                        * add inOperDate
 26.12.13                                        * add View_InfoMoney
 23.12.13                         *
 19.11.13                         *
 09.08.13         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_Cash (inMovementId:= 1, inOperDate:= NULL, inCashId:= 1, inSession:= zfCalc_UserAdmin());
