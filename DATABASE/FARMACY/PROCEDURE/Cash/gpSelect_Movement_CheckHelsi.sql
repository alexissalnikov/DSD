-- Function: gpSelect_Movement_CheckHelsi()

  DROP FUNCTION IF EXISTS gpSelect_Movement_CheckHelsi (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckHelsi(
    IN inStartDate     TDateTime , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Ord Integer
             , Id Integer, InvNumber TVarChar, OperDate TDateTime
             , TotalSumm TFloat
             , CashRegisterName TVarChar, PaidTypeName TVarChar
             , FiscalCheckNumber TVarChar
             , InvNumberSP TVarChar, ConfirmationCodeSP TVarChar
             , SPKindName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , CountSP TFloat, IdSP TVarChar, DosageIdSP TVarChar, PriceRetSP TFloat, PaymentSP TFloat
             , State TVarChar
             , Color_calc Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;


     -- ���������
     RETURN QUERY
WITH -- ������ ���-������
           tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIString_IdSP.ValueData       AS IdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                                                                -- � �/� - �� ������ ������
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               -- ��������  ���� �� ��������, ���
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- ����� ������������ �� �������� (���. ������) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- ���� ������� �� ��������, ��� (���. ������) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- ʳ������ ������� ���������� ������ � ��������� �������� (���. ������)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- ID ���������� ������
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               -- DosageID ���������� ������
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )

      SELECT ROW_NUMBER() OVER (ORDER BY Movement.OperDate)::Integer AS Ord
           , Movement.ID
           , Movement.InvNumber
           , Movement.OperDate
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
           , MovementString_InvNumberSP.ValueData               AS InvNumberSP
           , MovementString_ConfirmationCodeSP.ValueData        AS ConfirmationCodeSP
           , Object_Helsi_IdSP.ValueData                        AS SPKindName

           , MovementItem.Id                                    AS MovementItemId
           , MovementItem.ObjectId                              AS GoodsId
           , Object_Goods.goodscodeInt                          AS GoodsCode
           , Object_Goods.goodsname                             AS GoodsName
           , MovementItem.Amount
           , MIFloat_Price.ValueData             AS Price
           , CASE WHEN COALESCE (MB_RoundingDown.ValueData, False) = True
                THEN TRUNC(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData, 1)::TFloat
                ELSE CASE WHEN COALESCE (MB_RoundingTo10.ValueData, False) = True
                THEN (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 1))::TFloat
                ELSE (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat END END AS AmountSumm

           , MIFloat_PriceSale.ValueData                                   AS PriceSale
           , (MIFloat_PriceSale.ValueData * MovementItem.Amount) :: TFloat AS SummSale

           , tmpGoodsSP.CountSP                                     AS CountSP
           , tmpGoodsSP.IdSP                                        AS IdSP
           , tmpGoodsSP.DosageIdSP                                  AS DosageIdSP
           , tmpGoodsSP.PriceRetSP                                  AS PriceRetSP
           , tmpGoodsSP.PaymentSP                                   AS PaymentSP
           , NULL::TVarChar                                         AS State
           , zc_Color_White()                                       AS Color_calc

      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId

           INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()

           INNER JOIN Object AS Object_Helsi_IdSP
                             ON Object_Helsi_IdSP.DescId = zc_Object_SPKind()
                            AND Object_Helsi_IdSP.ObjectCode  = 1
                            AND Object_Helsi_IdSP.Id  = MovementLinkObject_SPKind.ObjectId

           LEFT JOIN MovementString AS MovementString_InvNumberSP
                                    ON MovementString_InvNumberSP.MovementId = Movement.Id
                                   AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

           LEFT JOIN MovementString AS MovementString_ConfirmationCodeSP
                                    ON MovementString_ConfirmationCodeSP.MovementId = Movement.Id
                                   AND MovementString_ConfirmationCodeSP.DescId = zc_MovementString_ConfirmationCodeSP()

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                        ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                       AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
           LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                        ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
           LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

           LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                    ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                   AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id

           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = MovementItem.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                       ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
           LEFT JOIN MovementBoolean AS MB_RoundingTo10
                                     ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                    AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
           LEFT JOIN MovementBoolean AS MB_RoundingDown
                                     ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                    AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()

           LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            -- ���������� GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                    AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            -- ��� ������
            LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                                AND tmpGoodsSP.Ord     = 1 -- � �/� - �� ������ ������
            LEFT JOIN  Object AS Object_IntenalSP ON Object_IntenalSP.Id = tmpGoodsSP.IntenalSPId

      WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
        AND Movement.OperDate < DATE_TRUNC ('DAY', inStartDate) + INTERVAL '1 DAY'
        AND Movement.DescId = zc_Movement_Check()
        AND Movement.StatusId = zc_Enum_Status_Complete()
        AND MovementItem.Amount > 0
        AND MovementItem.IsErased = False
      ORDER BY Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 17.05.19                                                                                    *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_CheckHelsi (inStartDate:= '17.05.2019', inSession:= '3')
