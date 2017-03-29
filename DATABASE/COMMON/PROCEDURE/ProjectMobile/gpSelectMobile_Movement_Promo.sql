-- Function: gpSelectMobile_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelectMobile_Movement_Promo (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Movement_Promo(
    IN inSyncDateIn TDateTime, -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
    IN inSession    TVarChar   -- ������ ������������
)
RETURNS TABLE (Id              Integer   -- ���������� �������������, ����������� � ������� ��, � ������������ ��� �������������
             , InvNumber       TVarChar  -- ����� ���������
             , OperDate        TDateTime -- ���� ���������
             , StatusId        Integer   -- ���� ��������
             , StartSale       TDateTime -- ���� ������ �������� �� ��������� ����
             , EndSale         TDateTime -- ���� ��������� �������� �� ��������� ����
             , isChangePercent Boolean   -- ��������� % ������ �� ��������, *�����* - ���� FALSE, ����� � �������� ����� ������ ChangePercent ������ = 0 
             , CommentMain     TVarChar  -- ���������� (�����)
             , isSync          Boolean   
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- ���������
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpPromoPartner AS (SELECT DISTINCT Movement_PromoPartner.ParentId AS ParentId
                                      FROM Movement AS Movement_PromoPartner
                                           -- JOIN MovementLinkObject AS MovementLinkObject_Partner
                                           --                         ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                           --                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner() 
                                           INNER JOIN MovementItem AS MI_PromoPartner
                                                                   ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                                  AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                                  AND MI_PromoPartner.IsErased   = FALSE
                                           JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                           ON ObjectLink_Partner_PersonalTrade.ObjectId      = MI_PromoPartner.ObjectId -- MovementLinkObject_Partner.ObjectId 
                                                          AND ObjectLink_Partner_PersonalTrade.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                                                          AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                      WHERE Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                        -- AND Movement_PromoPartner.ParentId IS NOT NULL 
                                        AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                     )
             SELECT Movement_Promo.Id
                  , Movement_Promo.InvNumber
                  , Movement_Promo.Operdate
                  , Movement_Promo.StatusId
                  , MovementDate_StartSale.ValueData     AS StartSale
                  , MovementDate_EndSale.ValueData       AS EndSale
                  , (MI_Child.ObjectId IS NULL)          AS isChangePercent
                  , MovementString_CommentMain.ValueData AS CommentMain
                  , true::Boolean                        AS isSync  
             FROM tmpPromoPartner
                  JOIN Movement AS Movement_Promo ON Movement_Promo.Id       = tmpPromoPartner.ParentId
                                                 -- AND Movement_Promo.DescId   = zc_Movement_Promo()
                                                 AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                  JOIN MovementDate AS MovementDate_StartSale
                                    ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                   AND MovementDate_StartSale.ValueData <= CURRENT_DATE
                  JOIN MovementDate AS MovementDate_EndSale
                                    ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                   AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                  LEFT JOIN MovementItem AS MI_Child
                                         ON MI_Child.MovementId = Movement_Promo.Id
                                        AND MI_Child.DescId = zc_MI_Child() 
                                        AND MI_Child.ObjectId = zc_Enum_ConditionPromo_ContractChangePercentOff() -- ��� ����� % ������ �� ��������
                                        AND NOT MI_Child.isErased
                  LEFT JOIN MovementString AS MovementString_CommentMain
                                           ON MovementString_CommentMain.MovementId = Movement_Promo.Id
                                          AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain() 
             ;
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   �������� �.�.
 16.03.17                                                                          *
*/

-- SELECT * FROM gpSelectMobile_Movement_Promo (inSyncDateIn:= zc_DateStart(), inSession:= zfCalc_UserAdmin())