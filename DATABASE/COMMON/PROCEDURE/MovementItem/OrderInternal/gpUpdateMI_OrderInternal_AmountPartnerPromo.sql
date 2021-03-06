-- Function: gpUpdateMI_OrderInternal_AmountPartnerPromo()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountPartnerPromo (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountPartnerPromo(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


      -- ������� -
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat, AmountPartnerNext TFloat, AmountPartnerPromo TFloat, AmountPartnerNextPromo TFloat, AmountPartnerPrior TFloat, AmountPartnerPriorPromo TFloat) ON COMMIT DROP;
     --
     INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, AmountPartner, AmountPartnerNext, AmountPartnerPromo, AmountPartnerNextPromo, AmountPartnerPrior, AmountPartnerPriorPromo)
                                 WITH -- ��������� - ������ ���� + ����������
                                      tmpUnit AS (SELECT UnitId FROM lfSelect_Object_Unit_byGroup (8457) AS lfSelect_Object_Unit_byGroup)
                                      -- ��������� - ������ ��
                                    , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                   FROM Object_InfoMoney_View
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                              ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                             AND ObjectLink_Goods_InfoMoney.DescId        = zc_ObjectLink_Goods_InfoMoney()
                                                   WHERE Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- ����
                                                                                             , zc_Enum_InfoMoney_30101() -- ������� ���������
                                                                                             , zc_Enum_InfoMoney_30201() -- ������ �����
                                                                                              )
                                                  )
                    , tmpOrder_all AS (SELECT MovementItem.ObjectId                                                    AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis())         AS GoodsKindId
                                              -- ����� ���������� ��� �����, ������� + ������
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartner
                                              -- ����� ���������� ������ �����, ������� + ������
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerPromo

                                              -- "������������" ����� ���������� ��� �����, ������
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND MovementDate_OperDatePartner.ValueData > inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNext
                                              -- "������������" ����� ���������� ������ �����, ������
                                            , SUM (CASE WHEN Movement.OperDate >= inOperDate AND MovementDate_OperDatePartner.ValueData > inOperDate AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountPartnerNextPromo
                                            
                                              -- ����� ���������� ��� �����, �������� - �����
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPrior
                                              -- ����� ���������� ������ �����, �������� - �����
                                            , SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                         AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END) AS AmountPartnerPriorPromo
                                       FROM Movement
                                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                         AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_To.ObjectId

                                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                                   AND MovementItem.isErased   = FALSE
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                            LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                                                        ON MIFloat_PromoMovementId.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                       WHERE Movement.OperDate BETWEEN (inOperDate - INTERVAL '3 DAY') AND inOperDate + INTERVAL '0 DAY'
                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                         AND Movement.DescId   = zc_Movement_OrderExternal()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                       GROUP BY MovementItem.ObjectId
                                              , MILinkObject_GoodsKind.ObjectId
                                       HAVING SUM (CASE WHEN Movement.OperDate = inOperDate THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                                           OR SUM (CASE WHEN Movement.OperDate < inOperDate
                                                         AND MovementDate_OperDatePartner.ValueData >= inOperDate
                                                             THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                                        ELSE 0
                                                   END)  <> 0
                                       )
                        , tmpOrder AS (SELECT tmpOrder_all.GoodsId
                                            , tmpOrder_all.GoodsKindId
                                            , tmpOrder_all.AmountPartner
                                            , tmpOrder_all.AmountPartnerNext
                                            , tmpOrder_all.AmountPartnerPromo
                                            , tmpOrder_all.AmountPartnerNextPromo
                                            , tmpOrder_all.AmountPartnerPrior
                                            , tmpOrder_all.AmountPartnerPriorPromo
                                       FROM tmpOrder_all
                                            INNER JOIN tmpGoods ON tmpGoods.GoodsId = tmpOrder_all.GoodsId
                                       )
                     , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                      , MovementItem.ObjectId                         AS GoodsId
                                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                      , MovementItem.Amount
                                      , COALESCE (MIFloat_ContainerId.ValueData, 0)   AS ContainerId
                                 FROM MovementItem 
                                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                      AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                  ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_ContainerId.DescId         = zc_MIFloat_ContainerId()
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                )
       -- ���������
       SELECT tmp.MovementItemId
             , COALESCE (tmp.GoodsId,tmpOrder.GoodsId)          AS GoodsId
             , COALESCE (tmp.GoodsKindId, tmpOrder.GoodsKindId) AS GoodsKindId
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartner, 0)             END AS AmountPartner
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerNext, 0)         END AS AmountPartnerNext
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPromo, 0)        END AS AmountPartnerPromo
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerNextPromo, 0)    END AS AmountPartnerNextPromo
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPrior, 0)        END AS AmountPartnerPrior
             , CASE WHEN tmp.ContainerId > 0 THEN 0 ELSE COALESCE (tmpOrder.AmountPartnerPriorPromo, 0)   END AS AmountPartnerPriorPromo
       FROM tmpOrder
            FULL JOIN tmpMI AS tmp ON tmp.GoodsId     = tmpOrder.GoodsId
                                 AND tmp.GoodsKindId = tmpOrder.GoodsKindId
      ;

       -- ���������
       PERFORM lpUpdate_MI_OrderInternal_Property (ioId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId

                                                 , inAmount_Param       := tmpAll.AmountPartner      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_Param       := zc_MIFloat_AmountPartner()
                                                 , inAmount_ParamOrder  := tmpAll.AmountPartnerPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamOrder  := zc_MIFloat_AmountPartnerPromo()

                                                 , inAmount_ParamSecond := tmpAll.AmountPartnerPrior      -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamSecond := zc_MIFloat_AmountPartnerPrior()
                                                 , inAmount_ParamAdd    := tmpAll.AmountPartnerPriorPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamAdd    := zc_MIFloat_AmountPartnerPriorPromo()


                                                 , inAmount_ParamNext        := tmpAll.AmountPartnerNext -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNext        := zc_MIFloat_AmountPartnerNext()
                                                 , inAmount_ParamNextPromo   := tmpAll.AmountPartnerNextPromo -- * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END
                                                 , inDescId_ParamNextPromo   := zc_MIFloat_AmountPartnerNextPromo()

                                                 , inIsPack             := NULL
                                                 , inUserId             := vbUserId
                                                  )
       FROM tmpAll
            /*LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpAll.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpAll.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()*/
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.15                                        * ������, �������� �����������
 19.06.15                                        *
 14.02.15         *
*/

-- ����
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountPartnerPromo (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= zfCalc_UserAdmin())
