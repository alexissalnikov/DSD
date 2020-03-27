-- Function: gpSelect_MI_OrderInternalBasis()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternalBasis (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternalBasis(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS SETOF REFCURSOR
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;

   DECLARE vbOperDate TDateTime;
   DECLARE vbDayCount Integer;
   DECLARE vbFromId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������������
     SELECT Movement.OperDate
          , 1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))
          , MovementLinkObject_From.ObjectId
            INTO vbOperDate, vbDayCount, vbFromId
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;


     -- 
     CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer
                                    , ReceiptId Integer
                                    , Amount TFloat, AmountSecond TFloat, AmountRemains TFloat, AmountPartner TFloat, AmountPartnerPrior TFloat, AmountPartnerSecond TFloat, AmountPartnerNext TFloat
                                    , AmountForecast TFloat
                                    , isErased Boolean) ON COMMIT DROP;
     INSERT INTO _tmpMI_master (MovementItemId, GoodsId, GoodsKindId
                              , ReceiptId
                              , Amount, AmountSecond, AmountRemains, AmountPartner, AmountPartnerPrior, AmountPartnerSecond, AmountPartnerNext
                              , AmountForecast
                              , isErased)
        -- ���������
        SELECT MovementItem.Id AS MovementItemId
             , MovementItem.ObjectId AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , COALESCE (MILinkObject_Receipt.ObjectId, 0)   AS ReceiptId

             , MovementItem.Amount                                   AS Amount
             , COALESCE (MIFloat_AmountSecond.ValueData, 0)          AS AmountSecond

             , COALESCE (MIFloat_AmountRemains.ValueData, 0)         AS AmountRemains
             , COALESCE (MIFloat_AmountPartner.ValueData, 0)         AS AmountPartner
             , COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0)    AS AmountPartnerPrior
             , COALESCE (MIFloat_AmountPartnerSecond.ValueData, 0)   AS AmountPartnerSecond
             , COALESCE (MIFloat_AmountPartnerNext.ValueData, 0)     AS AmountPartnerNext
             , COALESCE (MIFloat_AmountForecast.ValueData, 0)        AS AmountForecast

             , MovementItem.isErased                                 AS isErased

        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = tmpIsErased.isErased
             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

             LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                         ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()
             -- ��������� ��� ����� ��� ����. - �� ���� �������� (������ ������� ����� ��� ��) �����
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             -- ��������� ����� ��� ����. (������� ����� ��� �� + ����������)
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                         ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartnerPrior.DescId = zc_MIFloat_AmountPartnerPrior()
             -- ��������� ������� - (����� + ��������)
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerSecond
                                         ON MIFloat_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartnerSecond.DescId = zc_MIFloat_AmountPartnerSecond()
             -- ��������� - ����� ������ �������� (����������)
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerNext
                                         ON MIFloat_AmountPartnerNext.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartnerNext.DescId         = zc_MIFloat_AmountPartnerNext()
             -- ������� �� ������.
             LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                         ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountForecast.DescId = zc_MIFloat_AmountForecast()

             LEFT JOIN MovementItemLinkObject AS MILinkObject_Receipt
                                              ON MILinkObject_Receipt.MovementItemId = MovementItem.Id
                                             AND MILinkObject_Receipt.DescId = zc_MILinkObject_Receipt()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
       ;

       --
       OPEN Cursor1 FOR
       WITH tmpMI_Send AS (-- ������������ �����������
                           SELECT tmpMI.GoodsId                          AS GoodsId
                                , tmpMI.GoodsKindId                      AS GoodsKindId
                                , SUM (tmpMI.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) AS Amount
                           FROM (SELECT MIContainer.ObjectId_Analyzer                  AS GoodsId
                                      , CASE -- !!!�������� �����������!!!
                                             WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                              -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                  THEN 8338 -- �����.
                                             ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                        END AS GoodsKindId
                                      , SUM (MIContainer.Amount)                       AS Amount
                                 FROM MovementItemContainer AS MIContainer
                                 WHERE MIContainer.OperDate   = vbOperDate
                                   AND MIContainer.DescId     = zc_MIContainer_Count()
                                   AND MIContainer.MovementDescId = zc_Movement_Send()
                                   AND MIContainer.WhereObjectId_Analyzer = vbFromId
                                   -- AND MIContainer.isActive = TRUE
                                 GROUP BY MIContainer.ObjectId_Analyzer
                                        , CASE -- !!!�������� �����������!!!
                                               WHEN MIContainer.ObjectExtId_Analyzer = 8445 -- ����� ���������
                                                -- AND COALESCE (MIContainer.ObjectIntId_Analyzer, 0) = 0
                                                    THEN 8338 -- �����.
                                               ELSE 0 -- COALESCE (MIContainer.ObjectIntId_Analyzer, 0)
                                          END
                                ) AS tmpMI
                                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                     ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                    AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                      ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                     AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                            GROUP BY tmpMI.GoodsId
                                   , tmpMI.GoodsKindId
                          )
       SELECT
             tmpMI.MovementItemId :: Integer      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName

           , 0                                    AS ReceiptId_basis
           , Object_Receipt.Id                    AS ReceiptId
           , ObjectString_Receipt_Code.ValueData  AS ReceiptCode
           , Object_Receipt.ValueData             AS ReceiptName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ObjectCode               AS UnitCode
           , Object_Unit.ValueData                AS UnitName

           , tmpMI.Amount           :: TFloat AS Amount           -- ����� �� �����
           , tmpMI.AmountSecond     :: TFloat AS AmountSecond     -- ������� �� �����
           , tmpMI_Send.Amount      :: TFloat AS AmountSend       -- ������ �� "�������"

           , CASE WHEN tmpMI.AmountRemains + COALESCE (tmpMI_Send.Amount, 0) < tmpMI.AmountPartner + tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerSecond THEN tmpMI.AmountPartner + tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerSecond - tmpMI.AmountRemains - COALESCE (tmpMI_Send.Amount, 0) ELSE 0 END :: TFloat AS Amount_calc  -- ��������� �����

           , tmpMI.AmountRemains       :: TFloat  AS AmountRemains       -- ���. �������.
           , tmpMI.AmountPartner       :: TFloat  AS AmountPartner       -- ��������� ��� ����� ��� ����. - �� ���� �������� (������ ������� ����� ��� ��) �����
           , tmpMI.AmountPartnerPrior  :: TFloat  AS AmountPartnerPrior  -- ��������� ����� ��� ����. (������� ����� ��� �� + ����������)
           , (tmpMI.AmountPartner + tmpMI.AmountPartnerPrior + tmpMI.AmountPartnerSecond) :: TFloat AS AmountPartner_all -- ������ ������������ �� ������ �� ������������ (�����)
           , tmpMI.AmountPartnerSecond :: TFloat  AS AmountPartnerSecond -- ��������� ������� - (����� + ��������)
           , tmpMI.AmountPartnerNext   :: TFloat  AS AmountPartnerNext   -- ��������� - ����� ������ �������� (����������)

           , CASE WHEN ABS (tmpMI.AmountForecast) < 1 THEN tmpMI.AmountForecast ELSE CAST (tmpMI.AmountForecast AS NUMERIC (16, 1)) END :: TFloat AS AmountForecast -- ������� �� ����. ������� �� ������������
           , CAST (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END AS NUMERIC (16, 1))                      :: TFloat AS CountForecast  -- ���� 1� (�� ��.)
           , CAST (CASE WHEN (CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END) > 0
                             THEN tmpMI.AmountRemains / CASE WHEN vbDayCount <> 0 THEN tmpMI.AmountForecast / vbDayCount ELSE 0 END
                        WHEN tmpMI.AmountRemains > 0
                             THEN 365
                        ELSE 0
                   END
             AS NUMERIC (16, 1)) :: TFloat AS DayCountForecast -- ���. � ���� (�� ��.)

           , CASE WHEN tmpMI.AmountRemains <= 0
                       THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END :: Integer AS Color_remains
           , zc_Color_Cyan()   :: Integer AS ColorB_DayCountForecast -- $00E2C7C7
           , zc_Color_GreenL() :: Integer AS ColorB_AmountPartner    -- $00B6EAAA
           , zc_Color_Yelow()  :: Integer AS ColorB_AmountPrognoz    -- $008FF8F2 9435378

           , tmpMI.isErased

       FROM _tmpMI_master AS tmpMI
            LEFT JOIN tmpMI_Send ON tmpMI_Send.GoodsId     = tmpMI.GoodsId
                                AND tmpMI_Send.GoodsKindId = tmpMI.GoodsKindId

            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = tmpMI.ReceiptId
            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                  AND ObjectString_Receipt_Code.DescId = zc_ObjectString_Receipt_Code()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_parent
                                 ON ObjectLink_GoodsGroup_parent.ObjectId = ObjectLink_Goods_GoodsGroup.ChildObjectId
                                AND ObjectLink_GoodsGroup_parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = CASE WHEN tmpMI.ReceiptId > 0
                                                                      AND (ObjectLink_Goods_GoodsGroup.ChildObjectId  IN (1942, 5064881) -- ��-�������� + ��-�����
                                                                        OR ObjectLink_GoodsGroup_parent.ChildObjectId IN (1942, 5064881) -- ��-�������� + ��-�����
                                                                          )
                                                                          THEN vbFromId
                                                                     WHEN Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- �������� ����� + ������ �����
                                                                          THEN 8455 -- ����� ������
                                                                     ELSE 8439 -- ������� ������� �����
                                                                END
          ;
       RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MI_OrderInternalBasis (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.06.15                                        *
*/

-- ����
-- SELECT * FROM gpSelect_MI_OrderInternalBasis (inMovementId:= 5609806, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MI_OrderInternalBasis (inMovementId:= 5609806, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
