--
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result (
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inIsPromo        Boolean,   --�������� ������ �����
    IN inIsTender       Boolean,   --�������� ������ �������
    IN inUnitId         Integer,   --������������� 
    IN inRetailId       Integer,   --������������� 
    IN inMovementId     Integer,   --�������� �����
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     MovementId           Integer   --�� ��������� �����
    ,InvNumber            Integer   --� ��������� �����
    ,UnitName             TVarChar  --�����
    ,PersonalTradeName    TVarChar  --������������� ������������� ������������� ������
    ,PersonalName         TVarChar  --������������� ������������� �������������� ������	
    ,DateStartSale        TDateTime --���� �������� �� ��������� �����
    ,DeteFinalSale        TDateTime --���� �������� �� ��������� �����
    ,DateStartPromo       TDateTime --���� ���������� �����
    ,DateFinalPromo       TDateTime --���� ���������� �����
    ,MonthPromo           TDateTime --����� �����
    ,RetailName           TBlob     --����, � ������� �������� �����
    ,AreaName             TBlob     --������
    ,GoodsName            TVarChar  --�������
    ,GoodsCode            Integer   --��� �������
    ,MeasureName          TVarChar  --������� ���������
    ,TradeMarkName        TVarChar  --�������� �����
    ,GoodsKindName          TVarChar --������������ ������� <��� ������>
    ,GoodsKindCompleteName  TVarChar --������������ ������� <��� ������(����������)>
    
    ,GoodsWeight          TFloat    --���
    ,AmountPlanMin        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMinWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMax        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMaxWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    
    ,AmountReal           TFloat    --����� ������ � ����������� ������, ��
    ,AmountRealWeight     TFloat    --����� ������ � ����������� ������, �� ���
    ,AmountOut            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight      TFloat    --���-�� ���������� (����) ���
    ,AmountIn             TFloat    --���-�� ������� (����)
    ,AmountInWeight       TFloat    --���-�� ������� (����) ���
    ,AmountSale           TFloat    --������� �� ���� ������ �������� �� ��������� ���� �� ������� ��������
    ,AmountSaleWeight     TFloat    --������� �� ���� ������ �������� �� ��������� ���� �� ������� ��������, � ��
    
    ,PersentResult        TFloat    --���������, % ((������� � ���.������/������� � ����� ���.-1)*100)

    ,Discount             TBlob     --������, %
    ,MainDiscount         TFloat    --����� ������ ��� ����������, %  (�������� �������)
    ,PriceWithVAT         TFloat    --����������� ��������� ���� � ������ ���, ���
    ,Price                TFloat    -- * ���� ������������ � ���, ���
    ,CostPromo            TFloat    -- * ��������� �������
    ,PriceSale            TFloat    -- * ���� �� �����/������ ��� ����������
    ,PriceIn1             TFloat    --������������� ����,  �� ��
    ,Profit_Virt          TFloat    --����������� �������������� ������� �� ���������� ������
    ,SummReal             TFloat    --�� (���) �� ��������� ������ �� ���� ������������
    ,SummPromo            TFloat    --�� (���) ��������� ������ �� ��������� �����
    ,ContractCondition    TFloat    -- ����� ����, %
    ,Profit               TFloat    --
    ,Comment              TVarChar  --����������
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
    WITH 
    tmpMovement AS (SELECT DISTINCT Movement_Promo.*
                    FROM Movement_Promo_View AS Movement_Promo
                    
                         LEFT JOIN Movement AS Movement_PromoPartner 
                                             ON Movement_PromoPartner.ParentId = Movement_Promo.Id
                                            AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                            AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                          LEFT JOIN MovementItem AS MI_PromoPartner
                                                 ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                               AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                              AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                    
                    WHERE (Movement_Promo.Id = inMovementId OR inMovementId = 0)
                      AND (Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                            OR inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale)
                      AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
                      AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                      AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
                          OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
                          OR (inIsPromo = FALSE AND inIsTender = FALSE)
                          )
                    )
  , tmpMI AS (SELECT MI_PromoGoods.*
                   , (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))             :: TFloat  AS AmountSale       -- ������� - ������� 
                   , (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight -- ������� - ������� 
                   , (COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff
                   , MIFloat_PriceIn1.ValueData                                                                 :: TFloat  AS PriceIn1               --������������� ����,  �� ��
              FROM tmpMovement AS Movement_Promo
                   LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                          ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                         AND MI_PromoGoods.IsErASed = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                               ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                              AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
              )
                    
        SELECT
            Movement_Promo.Id                --�� ��������� �����
          , Movement_Promo.InvNumber          -- * � ��������� �����
          , Movement_Promo.UnitName           --�����
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          , Movement_Promo.PersonalName       --* ������������� ������������� �������������� ������	
          , Movement_Promo.StartSale          --*���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --*���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo         --*���� ������ �����
          , Movement_Promo.EndPromo           --*���� ��������� �����
          , Movement_Promo.MonthPromo         --* ����� �����

          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM Movement AS Movement_PromoPartner
                          INNER JOIN MovementItem AS MI_PromoPartner
                                                  ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                 AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                 AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                          
                          LEFT OUTER JOIN MovementString AS MovementString_Retail
                                                         ON MovementString_Retail.MovementId = Movement_PromoPartner.Id
                                                        AND MovementString_Retail.DescId = zc_MovementString_Retail()
                                                        AND MovementString_Retail.ValueData <> ''
                                      
                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
                    , (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          INNER JOIN Object ON Object.Id = MLO_Partner.ObjectId
                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                        ))                                                       :: TBlob AS RetailName    -- * �������� ����
            --------------------------------------
          , (SELECT STRING_AGG (DISTINCT Object_Area.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                      ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                     AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                INNER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )                                                                    :: TBlob AS AreaName      -- * ������
            
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName
          
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MI_PromoGoods.AmountPlanMin       --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          
          , MI_PromoGoods.AmountReal          --����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountRealWeight    --����� ������ � ����������� ������, �� ���

          , MI_PromoGoods.AmountOut           --���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight     --���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn            --���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight      --���-�� ������� (����) ���
          , MI_PromoGoods.AmountSale          -- ������� - ������� 
          , MI_PromoGoods.AmountSaleWeight    -- ������� - ������� 
          
          , CAST (CASE WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) = 0 AND MI_PromoGoods.AmountSaleWeight > 0
                            THEN 100
                       WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) <> 0
                            THEN (MI_PromoGoods.AmountSaleWeight / MI_PromoGoods.AmountRealWeight - 1) *100
                       WHEN MI_PromoGoods.AmountSaleWeight < 0
                            THEN -100
                       ELSE 0
                  END AS NUMERIC (16, 0))     :: TFloat AS PersentResult
          
          , (CASE WHEN MI_PromoGoods.Amount <> 0
                       THEN zfConvert_FloatToString (MI_PromoGoods.Amount)
                  ELSE (SELECT STRING_AGG (zfConvert_FloatToString (MovementItem_PromoCondition.Amount)
                                 ||' - ' || MovementItem_PromoCondition.ConditionPromoName
                                        , '; ' ) 
                       FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition
                       WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                         AND MovementItem_PromoCondition.IsErased   = FALSE
                         AND MovementItem_PromoCondition.Amount     <> 0
                       )
             END) :: TBlob   AS Discount
                 
          , 0                                 :: TFloat AS MainDiscount
                 
          , MI_PromoGoods.PriceWithVAT        :: TFloat
          , MI_PromoGoods.Price               :: TFloat
          , Movement_Promo.CostPromo          :: TFloat
          , MI_PromoGoods.PriceSale           :: TFloat    

          , MI_PromoGoods.PriceIn1            --������������� ����,  �� ��
          , (MI_PromoGoods.Price_Diff * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))    :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * COALESCE (MI_PromoGoods.AmountRealWeight, 0))         :: TFloat AS SummReal
          , (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) ) :: TFloat AS SummPromo
          , 0                                                                            :: TFloat    AS ContractCondition      -- ����� ����, %
          
          , CASE WHEN COALESCE (MI_PromoGoods.PriceIn1, 0) <> 0 AND COALESCE (MI_PromoGoods.AmountSaleWeight, 0) <> 0
                 THEN (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                    - (COALESCE (MI_PromoGoods.PriceIn1, 0) 
                       + 0
                       + (( (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))  * 0 /*ContractCondition*/ ) / COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                       ) * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) 
                 ELSE 0
            END                               :: TFloat    AS Profit
          , ''                                :: TVarChar  AS Comment                -- ����������
        FROM tmpMovement AS Movement_Promo
             LEFT JOIN tmpMI AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 30.11.17         *
 08.08.17         *
*/

-- ����
-- SELECT * FROM gpSelect_Report_Promo_Result (inStartDate:= '21.09.2017', inEndDate:= '21.09.2017', inIsPromo:= TRUE, inIsTender:= FALSE, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inSession:= zfCalc_UserAdmin());
