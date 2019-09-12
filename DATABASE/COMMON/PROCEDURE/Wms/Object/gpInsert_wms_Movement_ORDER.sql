-- Function: gpInsert_Movement_wms_ORDER(TVarChar)
-- 4.2	����� �� �������� <order>

DROP FUNCTION IF EXISTS gpInsert_wms_Movement_ORDER (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_wms_Movement_ORDER (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_wms_Movement_ORDER(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer, InsertDate TDateTime)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName       TVarChar;
   DECLARE vbTagName        TVarChar;
   DECLARE vbTagName_detail TVarChar;
   DECLARE vbActionName     TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_wms_Movement_ORDER';
     --
     vbTagName       := 'order';
     vbTagName_detail:= 'order_detail';
     --
     vbActionName:= 'set';


     -- ��������
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- ������� ������� ������
         DELETE FROM wms_Message WHERE wms_Message.GUID = inGUID; -- AND wms_Message.ProcName = vbProcName;
     END IF;


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO wms_Message (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId, InsertDate)
        WITH tmpGoods AS (SELECT tmp.sku_id            :: Integer -- ***���������� ��� ������ � �������� ����������� �����������
                               , tmp.sku_code                     -- ����������, ��������-�������� ��� ������ ��� ����������� � �������� ������.
                               , tmp.GoodsId                      -- 
                               , tmp.GoodsKindId                  -- 
                               , tmp.GoodsTypeKindId              -- 
                               , tmp.WeightMin                    -- 
                               , tmp.WeightMax                    -- 
                          FROM lpSelect_wms_Object_SKU() AS tmp
                         )
            -- ���� ����������� ������ ������ ���������
          , tmpPartnerTag AS (SELECT Object.Id AS PartnerTagId
                                -- , zc_Enum_GoodsTypeKind_Nom() AS GoodsTypeKind
                              FROM Object
                              WHERE Object.DescId = zc_Object_PartnerTag()
                                AND Object.Id IN (310821 -- 1;"�������"
                                             -- , 310822 -- 2;"�������� ������";f
                                                , 310823 -- 3;"HoReCa";f
                                                , 310824 -- 4;"�����������";f
                                                , 310825 -- 5;"�������";f
                                            --  , 310826 -- 6;"�������� �������";f
                                            --  , 310827 -- 7;"�������`����";f
                                                 )
                             )
        , tmpMovement_all AS (SELECT Movement.Id                                       AS MovementId
                                   , Movement.OperDate                                 AS OperDate
                                   , Movement.InvNumber                                AS InvNumber
                                   , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDatePartner_sale
                                   , COALESCE (MovementLinkObject_From.ObjectId, 0)    AS FromId
                                   , COALESCE (Object_From.DescId, 0)                  AS DescId_from
                                   , COALESCE (MovementString_Comment.ValueData, '')   AS Comment
                                   , MovementItem.Id                                   AS MovementItemId
                                   , MovementItem.ObjectId                             AS GoodsId
                                   , MILO_GoodsKind.ObjectId                           AS GoodsKindId
                                   , OL_Goods_Measure.ChildObjectId                    AS MeasureId
                                   , MovementItem.Amount + COALESCE (MIF_AmountSecond.ValueData, 0) AS Amount
                                     -- ��������� ��������� -��������� ������ ������ 
                                   , CASE WHEN OL_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                           AND tmpPartnerTag.PartnerTagId > 0
                                               THEN zc_Enum_GoodsTypeKind_Sh()
                                          WHEN tmpPartnerTag.PartnerTagId > 0
                                               THEN zc_Enum_GoodsTypeKind_Nom()
                                          ELSE zc_Enum_GoodsTypeKind_Ves()
                                     END AS GoodsTypeKindId_calc
                                   , tmpPartnerTag.PartnerTagId AS PartnerTagId_find
                                -- , COALESCE (OL_Partner_Juridical.ChildObjectId, 0)  AS JuridicalId
                             FROM Movement
                                  LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                        AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                  LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                                  LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                                                        ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId
                                                       AND ObjectFloat_DocumentDayCount.DescId   = zc_ObjectFloat_Partner_DocumentDayCount()
                                  LEFT JOIN ObjectLink AS OL_Partner_PartnerTag
                                                       ON OL_Partner_PartnerTag.ObjectId = MovementLinkObject_From.ObjectId
                                                      AND OL_Partner_PartnerTag.DescId   = zc_ObjectLink_Partner_PartnerTag()
                                --LEFT JOIN ObjectLink AS OL_Partner_Juridical
                                --                     ON OL_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                --                    AND OL_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                  LEFT JOIN MovementString AS MovementString_Comment
                                                           ON MovementString_Comment.MovementId = Movement.Id
                                                          AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.Amount     > 0
                                                         AND MovementItem.isErased   = FALSE
                                  LEFT JOIN ObjectLink AS OL_Goods_Measure
                                                       ON OL_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                      AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN MovementItemFloat AS MIF_AmountSecond
                                                              ON MIF_AmountSecond.MovementItemId = MovementItem.Id
                                                             AND MIF_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                                  LEFT JOIN tmpPartnerTag ON tmpPartnerTag.PartnerTagId = OL_Partner_PartnerTag.ChildObjectId
                             WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '3 DAY'
                               AND Movement.DescId   = zc_Movement_OrderExternal()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND MovementLinkObject_To.ObjectId = 8459 -- ����� ����������
                            )
          -- ��������� - ���������
        , tmpMovement AS (SELECT DISTINCT
                                 tmpMovement_all.MovementId           AS order_id
                               , tmpMovement_all.OperDatePartner_sale AS date_to_ship
                               , tmpMovement_all.FromId               AS client_id
                               , tmpMovement_all.Comment              AS comments
                                 -- ��� ������: �������� - �; �������� ����� - �; �������� - �;
                               , CASE WHEN 1=1
                                           THEN 'A'
                                 END AS type
                                 -- ������ ��������� ������ (����� ���� ������): ������� - �; ������ - �; ��� ���������� - �;
                               , CASE WHEN tmpMovement_all.DescId_from = zc_Object_Unit()
                                           THEN 'C'
                                      WHEN tmpMovement_all.PartnerTagId_find > 0
                                           THEN 'A'
                                      ELSE 'B'
                                 END AS processing_method
                               , tmpMovement_all.InvNumber
                          FROM tmpMovement_all
                          WHERE tmpMovement_all.Amount > 0
                         )
            -- ����� ��-�� WMS 
          , tmpMI_all AS (SELECT tmpMovement_all.*
                               , COALESCE (tmpGoods_best.sku_code
                                         , COALESCE (tmpGoods_best.sku_code
                                         , COALESCE (tmpGoods_Nom.sku_code
                                         , COALESCE (tmpGoods_Sh.sku_code
                                         , COALESCE (tmpGoods_Ves.sku_code, 0)
                                          )))) AS sku_code
                               , COALESCE (tmpGoods_best.sku_id
                                         , COALESCE (tmpGoods_best.sku_id
                                         , COALESCE (tmpGoods_Nom.sku_id
                                         , COALESCE (tmpGoods_Sh.sku_id
                                         , COALESCE (tmpGoods_Ves.sku_id, 0)
                                          )))) AS sku_id
                                 -- ���������� ������ (��� �������� ���������� ���������� � ��.) 
                               ,  COALESCE (tmpGoods_best.GoodsTypeKindId
                                         , COALESCE (tmpGoods_best.GoodsTypeKindId
                                         , COALESCE (tmpGoods_Nom.GoodsTypeKindId
                                         , COALESCE (tmpGoods_Sh.GoodsTypeKindId
                                         , COALESCE (tmpGoods_Ves.GoodsTypeKindId, 0)
                                          )))) AS GoodsTypeKindId
                               , COALESCE (tmpGoods_best.WeightMin
                                         , COALESCE (tmpGoods_best.WeightMin
                                         , COALESCE (tmpGoods_Nom.WeightMin
                                         , COALESCE (tmpGoods_Sh.WeightMin
                                         , COALESCE (tmpGoods_Ves.WeightMin, 0)
                                          )))) AS WeightMin
                               , COALESCE (tmpGoods_best.WeightMax
                                         , COALESCE (tmpGoods_best.WeightMax
                                         , COALESCE (tmpGoods_Nom.WeightMax
                                         , COALESCE (tmpGoods_Sh.WeightMax
                                         , COALESCE (tmpGoods_Ves.WeightMax, 0)
                                          )))) AS WeightMax
                          FROM tmpMovement_all
                               LEFT JOIN tmpGoods AS tmpGoods_best
                                                  ON tmpGoods_best.GoodsId         = tmpMovement_all.GoodsId
                                                 AND tmpGoods_best.GoodsKindId     = tmpMovement_all.GoodsKindId
                                                 AND tmpGoods_best.GoodsTypeKindId = tmpMovement_all.GoodsTypeKindId_calc
                               LEFT JOIN tmpGoods AS tmpGoods_Nom
                                                  ON tmpGoods_Nom.GoodsId          = tmpMovement_all.GoodsId
                                                 AND tmpGoods_Nom.GoodsKindId      = tmpMovement_all.GoodsKindId
                                                 AND tmpGoods_Nom.GoodsTypeKindId  = zc_Enum_GoodsTypeKind_Nom()
                                                 AND tmpGoods_best.GoodsTypeKindId IS NULL
                               LEFT JOIN tmpGoods AS tmpGoods_Sh
                                                  ON tmpGoods_Sh.GoodsId           = tmpMovement_all.GoodsId
                                                 AND tmpGoods_Sh.GoodsKindId       = tmpMovement_all.GoodsKindId
                                                 AND tmpGoods_Sh.GoodsTypeKindId   = zc_Enum_GoodsTypeKind_Sh()
                                                 AND tmpGoods_best.GoodsTypeKindId IS NULL
                                                 AND tmpGoods_Nom.GoodsTypeKindId  IS NULL
                               LEFT JOIN tmpGoods AS tmpGoods_Ves
                                                  ON tmpGoods_Ves.GoodsId           = tmpMovement_all.GoodsId
                                                 AND tmpGoods_Ves.GoodsKindId       = tmpMovement_all.GoodsKindId
                                                 AND tmpGoods_Ves.GoodsTypeKindId   = zc_Enum_GoodsTypeKind_Ves()
                                                 AND tmpGoods_best.GoodsTypeKindId IS NULL
                                                 AND tmpGoods_Nom.GoodsTypeKindId  IS NULL
                                                 AND tmpGoods_Sh.GoodsTypeKindId   IS NULL
                         )
                -- ��������� - ������
              , tmpMI AS (SELECT tmpMovement.order_id
                               , tmpMovement.date_to_ship
                               , tmpMovement.client_id
                               , tmpMovement.comments
                                 -- ��� ������: �������� - �; �������� ����� - �; �������� - �;
                               , tmpMovement.type
                                 -- ������ ��������� ������ (����� ���� ������): ������� - �; ������ - �; ��� ���������� - �;
                               , tmpMovement.processing_method
                                 --
                               , COALESCE (' �' || tmpMovement.InvNumber
                                        || ' �����: (' || Object_Goods.ObjectCode :: TVarChar || ')'
                                        || zfCalc_Text_replace (zfCalc_Text_replace (Object_Goods.ValueData, CHR(39), '`'), '"', '`')
                                 || ' ' || zfCalc_Text_replace (zfCalc_Text_replace (COALESCE (Object_GoodsKind.ValueData, ''), CHR(39), '`'), '"', '`')
                                         , tmpMI_all.sku_id   :: TVarChar) AS sku_id
                               , COALESCE (' �' || tmpMovement.InvNumber
                                        || ' �����: (' || Object_Goods.ObjectCode :: TVarChar || ')'
                                        || zfCalc_Text_replace (zfCalc_Text_replace (Object_Goods.ValueData, CHR(39), '`'), '"', '`')
                                 || ' ' || zfCalc_Text_replace (zfCalc_Text_replace (COALESCE (Object_GoodsKind.ValueData, ''), CHR(39), '`'), '"', '`')
                                         , tmpMI_all.sku_code :: TVarChar) AS sku_code
                                 -- ���������� WMS
                               , (zfCalc_QTY_toWMS (inGoodsTypeKindId:= tmpMI_all.GoodsTypeKindId
                                                  , inMeasureId      := tmpMI_all.MeasureId
                                                  , inAmount         := tmpMI_all.Amount
                                                  , inRealWeight     := tmpMI_all.Amount * (tmpMI_all.WeightMin + tmpMI_all.WeightMax) / 2
                                                  , inCount          := 0 -- ����� ���������� ������� ��-WMS
                                                  , inWeightMin      := tmpMI_all.WeightMin
                                                  , inWeightMax      := tmpMI_all.WeightMax
                                                   )) AS qty
                               , ROW_NUMBER() OVER (PARTITION BY tmpMI_all.MovementId ORDER BY tmpMI_all.MovementItemId) :: Integer AS line
                               , tmpMI_all.WeightMin
                               , tmpMI_all.WeightMax
                               , tmpMI_all.GoodsId
                               , tmpMI_all.GoodsKindId
                               , tmpMI_all.GoodsTypeKindId
                          FROM tmpMI_all
                               INNER JOIN tmpMovement ON tmpMovement.order_id = tmpMI_all.MovementId
                               LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMI_all.GoodsId
                                                                   AND tmpMI_all.sku_id    = 0
                               LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMI_all.GoodsKindId
                                                                   AND tmpMI_all.sku_id    = 0
                       -- WHERE Object_Goods.Id > 0
                         )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId, CURRENT_TIMESTAMP AS InsertDate
        FROM
             (-- ����� �� ��������
              SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , vbActionName AS ActionName
                     -- ������ 0 ��� ����������, ������� �������������� 1-�� ������� ���������, ����� ������
                   , 0            AS RowNum
                     -- XML
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')    :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                               ||'"' -- ???
                        ||' order_id="' || tmpData.order_id               :: TVarChar ||'"' -- ����� ���������
                       ||' client_id="' || tmpData.client_id              :: TVarChar ||'"' -- ��� ��������� � ����������� �����������.
                            ||' type="' || tmpData.type                               ||'"' -- ��� ������: �������� - �; �������� ����� - �; �������� - �;
               ||' processing_method="' || tmpData.processing_method                  ||'"' -- ������ ��������� ������ (����� ���� ������): ������� - �; ������ - �; ��� ���������� - �;
                    ||' date_to_ship="' || zfConvert_Date_toWMS (tmpData.date_to_ship) ||'"' -- �������������� ���� �������� ������
                 || CASE WHEN TRIM (tmpData.comments) = ''
                    THEN ' comments=""'
                    ELSE  -- ����������� ������� ����� ""
                         ' comments=" ' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.comments, CHR(39), '`'), '"', '`')  ||' "' -- ����������� � ���������
                    END
                                        ||'></' || vbTagName || '>'
                                      --||'>'
                                      --|| tmpMI.RowData
                                      --||'</' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- ObjectId
                   , tmpData.order_id AS ObjectId
                     --
                   , tmpData.order_id AS GroupId
              FROM tmpMovement AS tmpData
                   /*LEFT JOIN (-- ������ ������ �� ��������
                              SELECT tmpMI.order_id
                                     -- XML
                                   , STRING_AGG (('<' || vbTagName_detail
                                       ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')    :: TVarChar ||'"' -- ���������� ������������� ���������
                                        ||' action="' || vbActionName                               ||'"' -- ???
                                      ||' order_id="' || tmpMI.order_id                 :: TVarChar ||'"' -- ����� ���������
                                          ||' line="' || tmpMI.line                     :: TVarChar ||'"' -- ����� ������ �������� ������� ���������
                                        ||' sku_id="' || tmpMI.sku_id                   :: TVarChar ||'"' -- ���������� ������������� ������
                                        ||' status="' || '�'                                          ||'"' -- ��������� �����: �������� (��� ���� ������ ���������) - �; ���������� (��� ���� ������ ���������) - �; ���� (��� ���� ������ ��������� �����) - �;
                                           ||' qty="' || tmpMI.qty                      :: TVarChar ||'"' -- ���������� ������ � ������� �������� ��
                                      ||' comments="' || ''                             :: TVarChar ||'"' -- ����������� � ������ ���������
                                                      ||'></' || vbTagName_detail || '>'
                                     ) :: Text, '') AS RowData
                              FROM tmpMI
                            --WHERE tmpMI.order_id= 14231580
                              GROUP BY tmpMI.order_id
                             ) AS tmpMI ON tmpMI.order_id = tmpData.order_id*/
            --WHERE tmpData.order_id= 14231580

             UNION ALL
              -- ������ ������ �� ��������
              SELECT vbProcName       AS ProcName
                   , vbTagName_detail AS TagName
                   , vbActionName     AS ActionName
                   , ROW_NUMBER() OVER (ORDER BY tmpData.order_id, tmpData.line) :: Integer AS RowNum
                     -- ��� ��� ����� �� ��������
                   , ('<' || vbTagName
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')    :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                               ||'"' -- ???
                        ||' order_id="' || tmpData.order_id               :: TVarChar ||'"' -- ����� ���������
                       ||' client_id="' || tmpData.client_id              :: TVarChar ||'"' -- ��� ��������� � ����������� �����������.
                            ||' type="' || tmpData.type                               ||'"' -- ��� ������: �������� - �; �������� ����� - �; �������� - �;
               ||' processing_method="' || tmpData.processing_method                  ||'"' -- ������ ��������� ������ (����� ���� ������): ������� - �; ������ - �; ��� ���������� - �;
                    ||' date_to_ship="' || zfConvert_Date_toWMS (tmpData.date_to_ship) ||'"' -- �������������� ���� �������� ������
                 || CASE WHEN TRIM (tmpData.comments) = ''
                    THEN ' comments=""'
                    ELSE  -- ����������� ������� ����� ""
                         ' comments=" ' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.comments, CHR(39), '`'), '"', '`')  ||' "' -- ����������� � ���������
                    END
                                        ||'>'
                     -- ������ ������ �� ��������
                   || '<' || vbTagName_detail
                         ||' sync_id="' || NEXTVAL ('wms_sync_id_seq')    :: TVarChar ||'"' -- ���������� ������������� ���������
                          ||' action="' || vbActionName                               ||'"' -- ???
                        ||' order_id="' || tmpData.order_id               :: TVarChar ||'"' -- ����� ���������
                            ||' line="' || tmpData.line                   :: TVarChar ||'"' -- ����� ������ �������� ������� ���������
                          ||' sku_id="' || tmpData.sku_id                 :: TVarChar ||'"' -- ���������� ������������� ������
                          ||' status="' || 'A'                                        ||'"' -- ��������� �����: �������� (��� ���� ������ ���������) - �; ���������� (��� ���� ������ ���������) - �; ���� (��� ���� ������ ��������� �����) - �;
                             ||' qty="' || tmpData.qty                    :: TVarChar ||'"' -- ���������� ������ � ������� �������� ��
                        ||' comments="' || ''                             :: TVarChar ||'"' -- ����������� � ������ ���������
                                        ||'></' || vbTagName_detail || '>'
                                        ||'></' || vbTagName || '>'
                     ) :: Text AS RowData
                     -- Id
                   , tmpData.order_id AS ObjectId
                     --
                   , tmpData.order_id AS GroupId
              FROM tmpMI AS tmpData
            --WHERE tmpData.order_id= 14231580
              ) AS tmp
     -- WHERE tmp.RowNum = 1
     -- WHERE tmp.GroupId = 14227925
     -- WHERE tmp.GroupId = 14231580
     -- WHERE tmp.GroupId = 14228383
     -- WHERE tmp.GroupId = 14231580
        ORDER BY 4
     -- LIMIT 1
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                       *
*/
-- select zfCalc_WordText_Split (RowData, 'sku_id=', 2), * FROM wms_Message WHERE GUID = '1' ORDER BY GroupId, RowNum
-- select * FROM wms_Message WHERE RowData ILIKE '%sync_id=1%
-- select * FROM wms_Message WHERE GUID = '1' ORDER BY GroupId, RowNum
-- ����
-- SELECT * FROM gpInsert_wms_Movement_ORDER ('1', zfCalc_UserAdmin())