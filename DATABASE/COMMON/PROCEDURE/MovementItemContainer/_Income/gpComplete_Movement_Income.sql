-- Function: gpComplete_Movement_Income()

-- DROP FUNCTION gpComplete_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)                              
  RETURNS VOID AS
--  RETURNS TABLE (a1 TFloat, a2 TFloat, b1 TFloat, b2 TFloat) AS
--  RETURNS TABLE (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, MemberId_From Integer, UnitId Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar, OperCount TFloat, tmpOperSumm_Client TFloat, OperSumm_Client TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat, AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer, JuridicalId_basis Integer, BusinessId Integer, PartionMovementId Integer, PartionGoodsId Integer) AS

$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbOperSumm_Client_byItem TFloat;
  DECLARE vbOperSumm_Packer_byItem TFloat;

  DECLARE vbOperSumm_Client TFloat;
  DECLARE vbOperSumm_Packer TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Movement_Income());
   vbUserId:= inSession;


   -- ��� ��������� ����� ��� ������� �������� ���� �� ������� � ������������
   SELECT
         COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
       , COALESCE (MovementFloat_VATPercent.ValueData, 0)
       , COALESCE (MovementFloat_DiscountPercent.ValueData, 0)
       , COALESCE (MovementFloat_ExtraChargesPercent.ValueData, 0)
         INTO vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent
   FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                 ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
        LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                 ON MovementFloat_VATPercent.MovementId = Movement.Id
                AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
        LEFT JOIN MovementFloat AS MovementFloat_DiscountPercent
                 ON MovementFloat_DiscountPercent.MovementId = Movement.Id
                AND MovementFloat_DiscountPercent.DescId = zc_MovementFloat_DiscountPercent()
        LEFT JOIN MovementFloat AS MovementFloat_ExtraChargesPercent
                 ON MovementFloat_ExtraChargesPercent.MovementId = Movement.Id
                AND MovementFloat_ExtraChargesPercent.DescId = zc_MovementFloat_ExtraChargesPercent()
   WHERE Movement.Id = inMovementId
     AND Movement.StatusId = zc_Enum_Status_UnComplete();

if inMovementId = 0 then
 vbPriceWithVAT:=false;
 vbVATPercent:= 20;
 vbDiscountPercent:= 0;
 vbExtraChargesPercent:= 0;
end if;


   -- ������� - ��������� �������
   CREATE TEMP TABLE _tmpContainer (DescId Integer, ObjectId Integer) ON COMMIT DROP;

   -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
   CREATE TEMP TABLE _tmpItem (MovementItemId Integer, MovementId Integer, OperDate TDateTime, JuridicalId_From Integer, isCorporate Boolean, MemberId_From Integer, UnitId Integer, PersonalId_Packer Integer, PaidKindId Integer, ContractId Integer, GoodsId Integer, GoodsKindId Integer, AssetId Integer, PartionGoods TVarChar
                             , OperCount TFloat, tmpOperSumm_Client TFloat, OperSumm_Client TFloat, tmpOperSumm_Packer TFloat, OperSumm_Packer TFloat
                             , AccountDirectionId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer, InfoMoneyDestinationId_isCorporate Integer, InfoMoneyId_isCorporate Integer
                             , JuridicalId_basis Integer, BusinessId Integer
                             , PartionMovementId Integer, PartionGoodsId Integer) ON COMMIT DROP;
   -- ��������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
   INSERT INTO _tmpItem (MovementItemId, MovementId, OperDate, JuridicalId_From, isCorporate, MemberId_From, UnitId, PersonalId_Packer, PaidKindId, ContractId, GoodsId, GoodsKindId, AssetId, PartionGoods
                       , OperCount, tmpOperSumm_Client, OperSumm_Client, tmpOperSumm_Packer, OperSumm_Packer
                       , AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyDestinationId_isCorporate, InfoMoneyId_isCorporate
                       , JuridicalId_basis, BusinessId
                       , PartionMovementId, PartionGoodsId)
      SELECT
            _tmp.MovementItemId
          , _tmp.MovementId
          , _tmp.OperDate
          , _tmp.JuridicalId_From
          , _tmp.isCorporate
          , _tmp.MemberId_From
          , _tmp.UnitId
          , _tmp.PersonalId_Packer
          , _tmp.PaidKindId
          , _tmp.ContractId

          , _tmp.GoodsId
          , _tmp.GoodsKindId
          , _tmp.AssetId
          , _tmp.PartionGoods

          , _tmp.OperCount

            -- ������������� ����� �� ������� - � ����������� �� 2-� ������
          , _tmp.tmpOperSumm_Client
            -- �������� ����� �� �������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Client)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Client) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Client

            -- ������������� ����� �� ������������ - � ����������� �� 2-� ������
          , _tmp.tmpOperSumm_Packer
            -- �������� ����� �� ������������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (tmpOperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                    THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- ��������� ������ - �����������
          , _tmp.AccountDirectionId
            -- �������������� ����������
          , _tmp.InfoMoneyDestinationId
            -- ������ ����������
          , _tmp.InfoMoneyId
            -- �������������� ���������� (���� ���� ��������)
          , _tmp.InfoMoneyDestinationId_isCorporate
            -- ������ ���������� (���� ���� ��������)
          , _tmp.InfoMoneyId_isCorporate

          , _tmp.JuridicalId_basis
          , _tmp.BusinessId

            -- ������ ���������, ���������� �����
          , 0 AS PartionMovementId
            -- ������ ������, ���������� �����
          , 0 AS PartionGoodsId
      FROM 
          (SELECT
                 MovementItem.Id AS MovementItemId
               , MovementItem.MovementId
               , Movement.OperDate
               , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From
               , COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_Juridical
               , COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE) AS isCorporate
               , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id ELSE 0 END, 0) AS MemberId_From
               , COALESCE (MovementLinkObject_To.ObjectId, 0) AS UnitId
               , COALESCE (MovementLinkObject_PersonalPacker.ObjectId, 0) AS PersonalId_Packer
               , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
               , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

               , MovementItem.ObjectId AS GoodsId
               , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
               , COALESCE (MILinkObject_Asset.ObjectId, 0) AS AssetId
               , CASE WHEN COALESCE (MIString_PartionGoods.ValueData, '') <> '' THEN MIString_PartionGoods.ValueData ELSE '' END AS PartionGoods

               , MovementItem.Amount AS OperCount

                 -- ������������� ����� �� ������� - � ����������� �� 2-� ������
               , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                              ELSE COALESCE (CAST (MIFloat_AmountPartner.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                 END AS tmpOperSumm_Client
               -- , 0 AS OperSumm_Client

                 -- ������������� ����� �� ������������ - � ����������� �� 2-� ������
               , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 0) <> 0 THEN COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2)), 0)
                                                                              ELSE COALESCE (CAST (MIFloat_AmountPacker.ValueData * MIFloat_Price.ValueData AS NUMERIC (16, 2)), 0)
                 END AS tmpOperSumm_Packer
               -- , 0 AS OperSumm_Packer

                 -- ��������� ������ - �����������
               , COALESCE (ObjectLink_Unit_AccountDirection.ChildObjectId, 0) AS AccountDirectionId
                 -- �������������� ����������
               , COALESCE (lfObject_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                 -- ������ ����������
               , COALESCE (lfObject_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId
                 -- �������������� ���������� (���� ���� ��������)
               , COALESCE (lfObject_InfoMoney_isCorporate.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId_isCorporate
                 -- ������ ���������� (���� ���� ��������)
               , COALESCE (lfObject_InfoMoney_isCorporate.InfoMoneyId, 0) AS InfoMoneyId_isCorporate

               , COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) AS JuridicalId_basis
               , COALESCE (ObjectLink_Unit_Business.ChildObjectId, 0) AS BusinessId

           FROM Movement
                JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.isErased = FALSE

                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                 ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                            ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()

                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                LEFT JOIN MovementItemString AS MIString_PartionGoods
                                             ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = MovementItem.MovementId
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalPacker
                                             ON MovementLinkObject_PersonalPacker.MovementId = MovementItem.MovementId
                                            AND MovementLinkObject_PersonalPacker.DescId = zc_MovementLinkObject_PersonalPacker()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                             ON MovementLinkObject_PaidKind.MovementId = MovementItem.MovementId
                                            AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = MovementItem.MovementId
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

                LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                     ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                    AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                        ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                       AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

                LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                     ON ObjectLink_Unit_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                     ON ObjectLink_Unit_Business.ObjectId = MovementLinkObject_To.ObjectId
                                    AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                     ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney ON lfObject_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                LEFT JOIN lfSelect_Object_InfoMoney() AS lfObject_InfoMoney_isCorporate ON lfObject_InfoMoney_isCorporate.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
           WHERE Movement.Id = inMovementId
             AND Movement.StatusId = zc_Enum_Status_UnComplete()
          ) AS _tmp;


   -- ������ �������� ����� �� �������
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                  -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            ELSE SUM (tmpOperSumm_Client)
                       END
               WHEN vbVATPercent > 0
                  -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                       END
               WHEN vbVATPercent > 0
                  -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Client) AS NUMERIC (16, 2))
                       END
          END
          INTO vbOperSumm_Client
   FROM _tmpItem;

   -- ������ �������� ����� �� ������������ (����� ��� �� ��� � ��� �������)
   SELECT CASE WHEN vbPriceWithVAT OR vbVATPercent <= 0
                  -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % �������
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            ELSE SUM (tmpOperSumm_Packer)
                       END
               WHEN vbVATPercent > 0
                  -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                       END
               WHEN vbVATPercent > 0
                  -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��)
                  THEN CASE WHEN vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            WHEN vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                            ELSE CAST ( (1 + vbVATPercent / 100) * SUM (tmpOperSumm_Packer) AS NUMERIC (16, 2))
                       END
          END
          INTO vbOperSumm_Packer
   FROM _tmpItem;

   -- ������ �������� ����� �� ������� (�� ���������)
   SELECT SUM (OperSumm_Client) INTO vbOperSumm_Client_byItem FROM _tmpItem;
   -- ������ �������� ����� �� ������������ (�� ���������)
   SELECT SUM (OperSumm_Packer) INTO vbOperSumm_Packer_byItem FROM _tmpItem;


   -- ���� �� ����� ��� �������� ����� �� �������
   IF COALESCE (vbOperSumm_Client, 0) <> COALESCE (vbOperSumm_Client_byItem, 0)
   THEN
       -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
       UPDATE _tmpItem SET OperSumm_Client = OperSumm_Client - (vbOperSumm_Client_byItem - vbOperSumm_Client)
       WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Client IN (SELECT MAX (OperSumm_Client) FROM _tmpItem)
                               );
   END IF;

   -- ���� �� ����� ��� �������� ����� �� ������������
   IF COALESCE (vbOperSumm_Packer, 0) <> COALESCE (vbOperSumm_Packer_byItem, 0)
   THEN
       -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
       UPDATE _tmpItem SET OperSumm_Packer = OperSumm_Packer - (vbOperSumm_Packer_byItem - vbOperSumm_Packer)
       WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpItem WHERE OperSumm_Packer IN (SELECT MAX (OperSumm_Packer) FROM _tmpItem)
                               );
   END IF;

   -- ����������� ������ ���������, ���� �������������� ���������� = 10100; "������ �����" -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
   UPDATE _tmpItem SET PartionMovementId = lpInsertFind_Object_PartionMovement (MovementId)
   WHERE InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100(); 

   -- ����������� ������ ������, ���� PartionGoods <> ''
   UPDATE _tmpItem SET PartionGoodsId = lpInsertFind_Object_PartionGoods (PartionGoods, NULL) WHERE PartionGoods <> '';


--  RETURN QUERY SELECT vbOperSumm_Client as a1, vbOperSumm_Client_byItem as a2, vbOperSumm_Packer as b1, vbOperSumm_Packer_byItem as b2; 
--  RETURN QUERY SELECT _tmpItem.MovementItemId, _tmpItem.MovementId, _tmpItem.OperDate, _tmpItem.JuridicalId_From, _tmpItem.isCorporate, _tmpItem.MemberId_From, _tmpItem.UnitId, _tmpItem.PersonalId_Packer, _tmpItem.PaidKindId, _tmpItem.ContractId, _tmpItem.GoodsId, _tmpItem.GoodsKindId, _tmpItem.AssetId, _tmpItem.PartionGoods, _tmpItem.OperCount, _tmpItem.tmpOperSumm_Client, _tmpItem.OperSumm_Client, _tmpItem.tmpOperSumm_Packer, _tmpItem.OperSumm_Packer, _tmpItem.AccountDirectionId, _tmpItem.InfoMoneyDestinationId, _tmpItem.InfoMoneyId, _tmpItem.InfoMoneyDestinationId_isCorporate, _tmpItem.InfoMoneyId_isCorporate, _tmpItem.JuridicalId_basis, _tmpItem.BusinessId, _tmpItem.PartionMovementId, _tmpItem.PartionGoodsId FROM _tmpItem;
          
          
--  return;

   -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   -- !!! �� � ������ - �������� !!!
   -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


   -- ����������� �������� ��� ��������� ����� � ���������� 
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Count()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                              -- 0)����� 1)������������� 2)������ ������
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_PartionGoods()
                                                                                                    , inObjectId_2 := PartionGoodsId
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- �������� � ������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                              -- 0)����� 1)������������� 2)�������� ��������(��� �������� ��������� ���)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_AssetTo()
                                                                                                    , inObjectId_2 := AssetId
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- ������    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                                                    , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                              -- 0)����� 1)������������� 2)��� ������
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_GoodsKind()
                                                                                                    , inObjectId_2 := GoodsKindId
                                                                                                     )
                                                                              -- 0)����� 1)�������������
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Count()
                                                                                                    , inObjectId:= GoodsId
                                                                                                    , inJuridicalId_basis:= NULL
                                                                                                    , inBusinessId       := NULL
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                     )
                                                                 END
                                               , inAmount:= OperCount
                                               , inOperDate:= OperDate
                                                )

           -- ����������� �������� ��� ��������� ����� � �����
         , lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Summ()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)������ ������ 4)������ ���������� 5)������ ����������(����������� �/�)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_PartionGoods()
                                                                                                    , inObjectId_3 := PartionGoodsId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100() -- �������� � ������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20100()
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)�������� ��������(��� �������� ��������� ���) 4)������ ���������� 5)������ ����������(����������� �/�)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_AssetTo()
                                                                                                    , inObjectId_3 := AssetId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                      WHEN InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20700()  -- ������    -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20700()
                                                                                                    , zc_Enum_InfoMoneyDestination_30100()) -- ��������� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)���� ������� 4)������ ���������� 5)������ ����������(����������� �/�)
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_GoodsKind()
                                                                                                    , inObjectId_3 := GoodsKindId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_5 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)������������� 2)����� 3)������ ���������� 4)������ ����������(����������� �/�)
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������ -- select * from gpSelect_Object_AccountGroup ('2') where Id = zc_Enum_AccountGroup_20000()
                                                                                                                                              , inAccountDirectionId     := AccountDirectionId
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Unit()
                                                                                                    , inObjectId_1 := UnitId
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_Goods()
                                                                                                    , inObjectId_2 := GoodsId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_3 := InfoMoneyId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoneyDetail()
                                                                                                    , inObjectId_4 := CASE WHEN isCorporate THEN InfoMoneyId_isCorporate ELSE InfoMoneyId END
                                                                                                     )
                                                                 END
                                               , inAmount:= OperSumm_Client + OperSumm_Packer
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem;

   -- ����������� �������� - ���� ���������� ��� ���������� (����������� ����)
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Summ()
                                               , inMovementId:= MovementId
                                               , inContainerId:= CASE WHEN InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- ������ ����� -- select * from lfSelect_Object_InfoMoney() where InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100()
                                                                       AND MemberId_From = 0
                                                                       AND NOT isCorporate
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ���������� 5)������ ���������
                                                                         THEN lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000() -- ��������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := zc_Enum_AccountDirection_70100() -- ���������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70100())
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Juridical()
                                                                                                    , inObjectId_1 := JuridicalId_From
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_PaidKind()
                                                                                                    , inObjectId_2 := PaidKindId
                                                                                                    , inDescId_3   := zc_ContainerLinkObject_Contract()
                                                                                                    , inObjectId_3 := ContractId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                    , inDescId_5   := zc_ContainerLinkObject_PartionMovement()
                                                                                                    , inObjectId_5 := PartionMovementId
                                                                                                     )
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������(����������� ����) 2)NULL 3)NULL 4)������ ����������
                                                                         ELSE lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := CASE WHEN MemberId_From <> 0 THEN zc_Enum_AccountGroup_30000() WHEN isCorporate THEN zc_Enum_AccountGroup_30000() ELSE zc_Enum_AccountGroup_70000() END -- then �������� then �������� else ��������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_30000(), zc_Enum_AccountGroup_30000(), zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := CASE WHEN MemberId_From <> 0 THEN zc_Enum_AccountDirection_30500() WHEN isCorporate THEN zc_Enum_AccountDirection_30200() ELSE zc_Enum_AccountDirection_70100() END -- then ���������� (����������� ����) then ���� �������� else ���������� -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_30500(), zc_Enum_AccountDirection_30200(), zc_Enum_AccountDirection_70100())
                                                                                                                                              , inInfoMoneyDestinationId := CASE WHEN isCorporate THEN InfoMoneyDestinationId_isCorporate ELSE InfoMoneyDestinationId END
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := CASE WHEN MemberId_From <> 0 THEN zc_ContainerLinkObject_Personal() ELSE zc_ContainerLinkObject_Juridical() END
                                                                                                    , inObjectId_1 := CASE WHEN MemberId_From <> 0 THEN MemberId_From ELSE JuridicalId_From END
                                                                                                    , inDescId_2   := CASE WHEN MemberId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_PaidKind() END
                                                                                                    , inObjectId_2 := PaidKindId
                                                                                                    , inDescId_3   := CASE WHEN MemberId_From <> 0 THEN NULL ELSE zc_ContainerLinkObject_Contract() END
                                                                                                    , inObjectId_3 := ContractId
                                                                                                    , inDescId_4   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_4 := InfoMoneyId
                                                                                                     )
                                                                 END
                                               , inAmount:= - SUM (OperSumm_Client)
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem
    GROUP BY MovementId, OperDate, JuridicalId_From, isCorporate, MemberId_From, PaidKindId, ContractId, InfoMoneyDestinationId, InfoMoneyId, InfoMoneyDestinationId_isCorporate, InfoMoneyId_isCorporate, JuridicalId_basis, BusinessId, PartionMovementId;


   -- ����������� �������� - ������� ������������
   PERFORM lpInsertUpdate_MovementItemContainer (ioId:= 0
                                               , inDescId:= zc_MovementItemContainer_Summ()
                                               , inMovementId:= MovementId
                                                                              -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1) ����������(����������)  3)������ ����������
                                               , inContainerId:=              lpInsertFind_Container (inContainerDescId:= zc_Container_Summ()
                                                                                                    , inObjectId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000() -- ��������� -- select * from gpSelect_Object_AccountGroup ('2') where Id in (zc_Enum_AccountGroup_70000())
                                                                                                                                              , inAccountDirectionId     := zc_Enum_AccountDirection_70600() -- ���������� (������������) -- select * from gpSelect_Object_AccountDirection ('2') where Id in (zc_Enum_AccountDirection_70600())
                                                                                                                                              , inInfoMoneyDestinationId := InfoMoneyDestinationId
                                                                                                                                              , inInfoMoneyId            := NULL
                                                                                                                                              , inUserId                 := vbUserId
                                                                                                                                               )
                                                                                                    , inJuridicalId_basis:= JuridicalId_basis
                                                                                                    , inBusinessId       := BusinessId
                                                                                                    , inDescId_1   := zc_ContainerLinkObject_Personal()
                                                                                                    , inObjectId_1 := PersonalId_Packer
                                                                                                    , inDescId_2   := zc_ContainerLinkObject_InfoMoney()
                                                                                                    , inObjectId_2 := InfoMoneyId
                                                                                                     )
                                               , inAmount:= - SUM (OperSumm_Packer)
                                               , inOperDate:= OperDate
                                                )
    FROM _tmpItem
    WHERE OperSumm_Packer <> 0
    GROUP BY MovementId, OperDate, PersonalId_Packer, InfoMoneyDestinationId, InfoMoneyId, JuridicalId_basis, BusinessId;




  -- ����������� ������ ������ ���������
  UPDATE Movement SET StatusId = zc_Object_Status_Complete() WHERE Id = inMovementId AND StatusId = zc_Enum_Status_UnComplete();


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
               
 04.07.13                                        * finich
 02.07.13                                        *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 5014, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 5014, inSession:= '2')
