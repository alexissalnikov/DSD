-- Function: gpInsert_Scale_MI()

-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_MI(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inGoodsKindId           Integer   , -- ���� �������
    IN inRealWeight            TFloat    , -- �������� ��� (��� �����: ����� ���� � % ������ ��� ���-��)
    IN inChangePercentAmount   TFloat    , -- % ������ ��� ���-��
    IN inCountTare             TFloat    , -- ���������� ����
    IN inWeightTare            TFloat    , -- ��� 1-�� ����
    IN inCountTare1            TFloat    , -- ���������� ��. ����1
    IN inWeightTare1           TFloat    , -- ��� ��. ����1
    IN inCountTare2            TFloat    , -- ���������� ��. ����2
    IN inWeightTare2           TFloat    , -- ��� ��. ����2
    IN inCountTare3            TFloat    , -- ���������� ��. ����3
    IN inWeightTare3           TFloat    , -- ��� ��. ����3
    IN inCountTare4            TFloat    , -- ���������� ��. ����4
    IN inWeightTare4           TFloat    , -- ��� ��. ����4
    IN inCountTare5            TFloat    , -- ���������� ��. ����5
    IN inWeightTare5           TFloat    , -- ��� ��. ����5
    IN inCountTare6            TFloat    , -- ���������� ��. ����6
    IN inWeightTare6           TFloat    , -- ��� ��. ����6
    IN inPrice                 TFloat    , -- ����
    IN inPrice_Return          TFloat    , -- ����
    IN inCountForPrice         TFloat    , -- ���� �� ����������
    IN inCountForPrice_Return  TFloat    , -- ���� �� ����������
    IN inDayPrior_PriceReturn  Integer,
    IN inCount                 TFloat    , -- ���������� ������� ��� ���������� ������� ��� ���-�� ������ (����� ������) ��� ���-�� ��� ������ ��������
    IN inHeadCount             TFloat    , --
    IN inBoxCount              TFloat    , --
    IN inBoxCode               Integer   , --
    IN inPartionGoods          TVarChar  , -- ������
    IN inPriceListId           Integer   , --
    IN inBranchCode            Integer   , --
    IN inMovementId_Promo      Integer   , --
    IN inIsBarCode             Boolean   , --
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS TABLE (Id        Integer
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementId_order Integer;
   DECLARE vbBoxId Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbRetailId Integer;

   DECLARE vbWeightTotal   TFloat;
   DECLARE vbWeightPack    TFloat;
   DECLARE vbAmount_byPack TFloat;

   DECLARE vbPriceListId_Dnepr Integer;
   DECLARE vbOperDate_Dnepr    TDateTime;

   DECLARE vbPricePromo            TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbChangePercent         TFloat;
            
   DECLARE vbPrice_301 TFloat; -- !!!���� ��� ������!!!

   DECLARE vbWeight_goods              TFloat;
   DECLARE vbWeightTare_goods          TFloat;
   DECLARE vbCountForWeight_goods      TFloat;
   DECLARE vbAmount_byWeightTare_goods TFloat;

   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Scale_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� ��������� ����� ������ ���������� ����.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- ��������
     IF inRealWeight > 1000000
     THEN
         RAISE EXCEPTION '������ ��� <%>.', inRealWeight;
     END IF;


     -- !!!������, �������� ��� - �� ���� �������� �. ��� ��.
     /*IF EXISTS (SELECT FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId NOT IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
     THEN
         inOperCount:= (WITH tmpWeight AS (SELECT OF_Weight.ValueData FROM ObjectFloat AS OF_Weight WHERE OF_Weight.ObjectId = inGoodsId AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight())
                        SELECT CASE WHEN tmpWeight.ValueData > 0 THEN tmp.OperCount / tmpWeight.ValueData ELSE tmp.OperCount
                        FROM (SELECT inOperCount AS OperCount) AS tmp
                             CROSS JOIN tmpWeight ON tmpWeight
                       );
     END IF;*/


     -- ����������
     SELECT Movement.OperDate, MovementFloat.ValueData :: Integer, COALESCE (MLM_Order.MovementChildId, 0)
          , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
            INTO vbOperDate, vbMovementDescId, vbMovementId_order, vbRetailId
     FROM Movement
          LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDesc()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;


     -- ���� ����� ������ + ���-�� ������ - ������ ��������
     IF inBranchCode BETWEEN 301 AND 310 AND 1=0
     THEN
         -- ��� ��� �������� �� ���� � ����� ��� ���-�� ���
         vbWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_Weight());
         --
         IF vbWeight_goods > 0
         THEN
             -- ���. ��� ����
             vbCountForWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_CountForWeight());
             IF COALESCE (vbCountForWeight_goods, 0) = 0 THEN vbCountForWeight_goods:= 1; END IF;
             -- ��� ������
             vbWeightTare_goods:= COALESCE ((SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_WeightTare()), 0);

             -- ��������
             IF 1=0 AND vbWeightTare_goods > 0 AND COALESCE (inCount, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ������� ���-�� ������ � ����� <%>', zfConvert_FloatToString (vbWeightTare_goods);
             END IF;
             -- ���� ���-���� ������ ���
             IF inCount < 0 THEN inCount:= 0; END IF;
             
             IF (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure())
                IN (zc_Measure_Sht() -- ��.
                   )
             THEN
                 -- ������ �������� - ������� �� ���� � ����� ��� ���-�� ��� ... � �������� ������
                 vbAmount_byWeightTare_goods:= ROUND (vbCountForWeight_goods * (inRealWeight - vbWeightTare_goods * inCount) / vbWeight_goods);
             ELSE
                 -- ������ �������� - ������� �� ���� � ����� ��� ���-�� ��� ... � �������� ������
                 vbAmount_byWeightTare_goods:= vbCountForWeight_goods * (inRealWeight - vbWeightTare_goods * inCount) / vbWeight_goods;
             END IF;

             -- ��������
             IF vbAmount_byWeightTare_goods <= 0
             THEN
                 RAISE EXCEPTION '������.��������� ���-�� �� ������� ���� ������ = <%> �� ����� ���� <= 0.', zfConvert_FloatToString (vbAmount_byWeightTare_goods);
             END IF;

         ELSE
             -- �������� ���-�� ������
             inCount:= 0;
         END IF;

     END IF;

     -- ���� ���� - ������ �������� �� 0
     IF inChangePercentAmount <> 0
        AND EXISTS (SELECT 1
                    FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                         JOIN Object_InfoMoney_View AS View_InfoMoney
                                                    ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                   AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                                                                                               , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                                                                                                )
                    WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   )
     THEN
         inChangePercentAmount:= 0;
     -- ���� ���� - ������ ��������                 \
     ELSEIF inChangePercentAmount = 0
        AND vbMovementDescId = zc_Movement_Sale()
        AND EXISTS (SELECT 1
                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                              ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                             AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                         INNER JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                               ON ObjectFloat_ChangePercentAmount.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                              AND ObjectFloat_ChangePercentAmount.DescId    = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                              AND ObjectFloat_ChangePercentAmount.ValueData <> 0
                         JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                         ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         JOIN Object_InfoMoney_View AS View_InfoMoney
                                                    ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                   AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                    WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                      AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())  = inGoodsKindId
                   )
     THEN
         inChangePercentAmount:= (SELECT ObjectFloat_ChangePercentAmount.ValueData
                                  FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                       INNER JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                                             ON ObjectFloat_ChangePercentAmount.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectFloat_ChangePercentAmount.DescId    = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                  WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                                    AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())  = inGoodsKindId
                                  LIMIT 1 -- !!!����� ����� � � ������ �������� � � zc_GoodsKind_Basis!!!
                                 );

     END IF;

     -- ���������� !!!������ ��� ��������� - ����� �����!!!
     IF vbMovementDescId IN (zc_Movement_ReturnIn())
     THEN
         SELECT tmp.MovementId
              , CASE WHEN /*tmp.TaxPromo <> 0 AND*/ (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()) = TRUE
                          THEN tmp.PriceWithVAT
                     WHEN /*tmp.TaxPromo <> 0 AND*/ 1=1
                          THEN tmp.PriceWithOutVAT
                     ELSE 0 -- ???����� ���� ����� ����� �� ������ ����� ���� ����� ��� ����� ������� ��� ��� �����???
                END
              , tmp.isChangePercent
                INTO inMovementId_Promo, vbPricePromo, vbIsChangePercent_Promo
         FROM lpGet_Movement_Promo_Data_all (inOperDate     := (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                           , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                           , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                           , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                           , inGoodsId      := inGoodsId
                                           , inGoodsKindId  := inGoodsKindId
                                           , inIsReturn     := TRUE
                                            ) AS tmp;
     END IF;



     -- !!!������ ����� ��� ���� - ���� ������� + �����!!!
     IF vbMovementDescId = zc_Movement_ReturnIn() AND inMovementId_Promo > 0
     THEN
         -- !!!������!!!
         inPrice_Return:= vbPricePromo;

     ELSE
     -- ���������� !!!������ ��� SPEC!!!
     IF vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
        AND inBranchCode BETWEEN 301 AND 310 -- Dnepr-SPEC-Zapch
        AND inBoxCount > 0
     THEN
         -- !!!�.�. ����� - �������� ���� ����� ���� ��������!!!
         vbPrice_301:= inBoxCount;
         inBoxCount:= 0;
     ELSE
     -- ���������� !!!������ ��� ������!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
        AND (inBranchCode = 1                 -- Dnepr
          OR inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
          OR inBranchCode BETWEEN 301 AND 310 -- ������ Dnepr-SPEC-Zapch
            )
     THEN
         -- !!!������!!!
         SELECT tmp.PriceListId, tmp.OperDate
               INTO vbPriceListId_Dnepr, vbOperDate_Dnepr
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId      := CASE WHEN vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                   THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                              ELSE (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                                         END
                                                   , inMovementDescId := vbMovementDescId
                                                   , inOperDate_order := CASE WHEN vbMovementId_order <> 0
                                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                              ELSE NULL
                                                                         END
                                                   , inOperDatePartner:= CASE WHEN 1=0 AND inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
                                                                                   THEN (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                              WHEN vbMovementId_order <> 0
                                                                                   THEN NULL
                                                                              ELSE (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                         END
                                                   , inDayPrior_PriceReturn:= inDayPrior_PriceReturn
                                                   , inIsPrior        := FALSE -- !!!���������� �� ������ ���!!!
                                                    ) AS tmp;
     END IF;
     END IF;
     END IF;


     -- ������ ��� ReturnIn ������ - ���������� (-)% ������ (+)% �������
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE AND vbMovementDescId = zc_Movement_ReturnIn()
                                 THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                            ELSE 0
                       END;

     -- ����������
     vbBoxId:= CASE WHEN inBoxCode > 0 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBoxCode AND Object.DescId = zc_Object_Box()) ELSE 0 END;
     -- ���������� ��� 1 ��. ��������� + �������� AND ��� �������� ��� 1-�� ��. ���������
     SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
          , CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0 AND ObjectFloat_WeightPackage.ValueData <> 0 AND ObjectFloat_WeightTotal.ValueData > ObjectFloat_WeightPackage.ValueData
                      THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                         / (1 - ObjectFloat_WeightPackage.ValueData / ObjectFloat_WeightTotal.ValueData)
                 ELSE (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
            END
            INTO vbWeightPack, vbWeightTotal, vbAmount_byPack
     FROM Object_GoodsByGoodsKind_View
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
     WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
       AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;


     -- ��������, �.�. ��������� �������
     IF 1 < (SELECT COUNT(*) FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure()) THEN
        RAISE EXCEPTION '������.������� � <%> ��� ��.��������� = <%>.', lfGet_Object_ValueData (inGoodsId)
          , (SELECT COUNT(*) FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure());
     END IF;
     -- ��������, �.�. ��������� �������
     IF 1 < (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inGoodsKindId:= inGoodsKindId
                                                                   , inSession    := inSession
                                                                    ) AS tmp) THEN
        RAISE EXCEPTION '������.������� � <%> <%> <%> <%> <%> <%> ��� ���� = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId), lfGet_Object_ValueData (vbPriceListId_Dnepr), lfGet_Object_ValueData (inPriceListId), DATE (vbOperDate_Dnepr), DATE (vbOperDate)
          , (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inGoodsKindId:= inGoodsKindId
                                                                   , inSession    := inSession
                                                                    ) AS tmp);
     END IF;
     -- ��������, �.�. ��������� �������
     IF 1 < (SELECT COUNT(*) FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()) THEN
        RAISE EXCEPTION '������.������� � <%> ��� �� = <%>.', lfGet_Object_ValueData (inGoodsId)
          , (SELECT COUNT(*) FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney());
     END IF;

                                                                                            
     -- �������� ���-��
     IF (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                   THEN vbAmount_byWeightTare_goods
              WHEN inIsBarCode = TRUE AND zc_Measure_Kg() = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure())
               AND vbAmount_byPack <> 0
                   THEN vbAmount_byPack
              ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6
         END) < 0
     OR (CASE -- !!!������ ��� ������������ �����!!!
              WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                   THEN vbAmount_byWeightTare_goods
              WHEN inIsBarCode = TRUE
                   THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
              WHEN inChangePercentAmount = 0
                   THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
              WHEN vbRetailId IN (341640, 310854, 310855) -- ���� + ��� + �����
                   THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                            * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
              ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                       * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
         END) < 0
     THEN
         RAISE EXCEPTION '������.� ������ ������ ����, ��������� ������������ ��� <%> <%>'
                        , CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                    THEN vbAmount_byWeightTare_goods
                               WHEN inIsBarCode = TRUE AND zc_Measure_Kg() = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure())
                                AND vbAmount_byPack <> 0
                                    THEN vbAmount_byPack
                               ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6
                          END
                        , CASE -- !!!������ ��� ������������ �����!!!
                               WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                    THEN vbAmount_byWeightTare_goods
                               WHEN inIsBarCode = TRUE
                                    THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                               WHEN inChangePercentAmount = 0
                                    THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                               WHEN vbRetailId IN (341640, 310854, 310855) -- ���� + ��� + �����
                                    THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                             * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
                               ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                        * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
                          END
                         ;
     END IF;


     -- ���������
     vbId:= gpInsertUpdate_MovementItem_WeighingPartner (ioId                  := 0
                                                       , inMovementId          := inMovementId
                                                       , inGoodsId             := inGoodsId 
                                                       , inAmount              := CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                                            THEN vbAmount_byWeightTare_goods
                                                                                       WHEN inIsBarCode = TRUE AND zc_Measure_Kg() = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure())
                                                                                        AND vbAmount_byPack <> 0
                                                                                            THEN vbAmount_byPack
                                                                                       ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6
                                                                                  END
                                                       , inAmountPartner       := CASE -- !!!������ ��� ������������ �����!!!
                                                                                       /*WHEN vbRetailId IN (310828) -- �����
                                                                                            THEN CEIL ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6) * 100) / 100
                                                                                       */
                                                                                       WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                                            THEN vbAmount_byWeightTare_goods
                                                                                       WHEN inIsBarCode = TRUE
                                                                                            THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                                                                       WHEN inChangePercentAmount = 0
                                                                                            THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                                                                       WHEN vbRetailId IN (341640, 310854, 310855) -- ���� + ��� + �����
                                                                                            THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                                                                                     * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
                                                                                       ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6)
                                                                                                * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
                                                                                  END
                                                       , inRealWeight          := inRealWeight
                                                       , inChangePercentAmount := CASE WHEN inIsBarCode = TRUE
                                                                                            THEN 0
                                                                                       ELSE inChangePercentAmount
                                                                                  END
                                                       , inCountTare           := inCountTare
                                                       , inWeightTare          := inWeightTare
                                                       , inCountTare1          := inCountTare1
                                                       , inWeightTare1         := inWeightTare1
                                                       , inCountTare2          := inCountTare2
                                                       , inWeightTare2         := inWeightTare2
                                                       , inCountTare3          := inCountTare3
                                                       , inWeightTare3         := inWeightTare3
                                                       , inCountTare4          := inCountTare4
                                                       , inWeightTare4         := inWeightTare4
                                                       , inCountTare5          := inCountTare5
                                                       , inWeightTare5         := inWeightTare5
                                                       , inCountTare6          := inCountTare6
                                                       , inWeightTare6         := inWeightTare6
                                                       , inCountPack           := CASE WHEN inIsBarCode = TRUE AND vbWeightTotal <> 0
                                                                                            THEN vbAmount_byPack / vbWeightTotal
                                                                                       ELSE inCount
                                                                                  END
                                                       , inHeadCount           := inHeadCount
                                                       , inBoxCount            := inBoxCount
                                                       , inBoxNumber           := CASE WHEN vbMovementDescId <> zc_Movement_Sale() THEN 0 ELSE  1 + COALESCE ((SELECT MAX (MovementItemFloat.ValueData) FROM MovementItem INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id AND MovementItemFloat.DescId = zc_MIFloat_BoxNumber() WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE), 0) END
                                                       , inLevelNumber         := 0
                                                       , inPrice               := CASE -- ��� isSticker = TRUE
                                                                                       WHEN inBranchCode > 1000
                                                                                            -- !!!����� � ������!!!
                                                                                            THEN inPrice

                                                                                       -- ���� ��� ������
                                                                                       WHEN inBranchCode BETWEEN 301 AND 310 AND vbPrice_301 > 0 AND vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                            THEN vbPrice_301
                                                                                       -- � ������ ������� - ���� ������� + �����
                                                                                       WHEN vbMovementDescId = zc_Movement_ReturnIn() AND inMovementId_Promo > 0
                                                                                            THEN vbPricePromo
                                                                                       -- ?����� ����� ��� ������ ����� ��� � �������? - �.�. ��� ������� - ���� �� ������
                                                                                       WHEN vbMovementDescId IN (/**/zc_Movement_Sale(), /**/zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                            AND vbPriceListId_Dnepr <> 0
                                                                                            AND COALESCE (inMovementId_Promo, 0) = 0
                                                                                            THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                                                                                                                        , inPriceListId:= vbPriceListId_Dnepr
                                                                                                                                                                        , inGoodsId    := inGoodsId
                                                                                                                                                                        , inGoodsKindId:= inGoodsKindId
                                                                                                                                                                        , inSession    := inSession
                                                                                                                                                                         ) AS tmp), 0)
                                                                                       -- ���� �������
                                                                                       WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                                                            THEN inPrice_Return
                                                                                       WHEN vbMovementDescId = zc_Movement_Sale()
                                                                                            AND vbMovementId_order = 0 -- !!!���� �� �� ������!!!
                                                                                            THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbOperDate_Dnepr    ELSE vbOperDate    END
                                                                                                                                                                        , inPriceListId:= CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                                                                                                                                        , inGoodsId    := inGoodsId
                                                                                                                                                                        , inGoodsKindId:= inGoodsKindId
                                                                                                                                                                        , inSession    := inSession
                                                                                                                                                                         ) AS tmp), 0)
                                                                                       -- ����� �� �����
                                                                                       ELSE inPrice
                                                                                  END
                                                       , inCountForPrice       := CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN inCountForPrice_Return ELSE inCountForPrice END
                                                                                  -- (-)% ������ (+)% �������
                                                       , inChangePercent       := vbChangePercent
                                                       , inPartionGoods        := inPartionGoods
                                                       , inPartionGoodsDate    := NULL
                                                       , inGoodsKindId         := CASE WHEN inBranchCode > 1000
                                                                                            -- !!!����� StickerPack!!!
                                                                                            THEN inGoodsKindId

                                                                                       WHEN (SELECT View_InfoMoney.InfoMoneyDestinationId
                                                                                             FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                                                            ) IN (zc_Enum_InfoMoneyDestination_20500() -- ������������� + ��������� ����
                                                                                                , zc_Enum_InfoMoneyDestination_20600() -- ������������� + ������ ���������
                                                                                                 )
                                                                                            THEN 0
                                                                                       ELSE inGoodsKindId
                                                                                  END
                                                       , inPriceListId         := CASE WHEN inBranchCode > 1000
                                                                                            -- !!!����� GoodsKindId - �� StickerProperty!!!
                                                                                            THEN inPriceListId

                                                                                       WHEN vbPriceListId_Dnepr <> 0
                                                                                            THEN vbPriceListId_Dnepr
                                                                                       ELSE inPriceListId
                                                                                  END
                                                         
                                                       , inBoxId               := vbBoxId
                                                       , inMovementId_Promo    := COALESCE (inMovementId_Promo, 0)
                                                       , inIsBarCode           := CASE WHEN inSession = '5' THEN TRUE ELSE inIsBarCode END
                                                       , inSession             := inSession
                                                        );

     --
     vbTotalSumm:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_TotalSumm());


     -- �������� ��-�� <�������� ����/����� ������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), vbId, vbOperDate_StartBegin);
     -- �������� ��-�� <�������� ����/����� ����������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), vbId, CLOCK_TIMESTAMP());


-- !!! �������� !!!
IF inSession = '5' AND 1=0 AND inBranchCode < 1000 THEN
    RAISE EXCEPTION 'Admin - Test = OK  Amount = <%> Price = <%>'
                  , (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = vbId)
                  , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId AND MIF.DescId = zc_MIFloat_Price())
                   ;
    -- RAISE EXCEPTION '��������� �������� ����� 3 ���.';
END IF;

     -- ���������
     RETURN QUERY
       SELECT vbId, vbTotalSumm;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.15                                        *
 10.05.15                                        * all
 13.10.14                                        * all
 13.03.14         *
*/

-- ����
-- SELECT * FROM gpInsert_Scale_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
