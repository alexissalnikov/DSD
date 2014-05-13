-- Function: gpReport_GoodsMI_TransferDebt ()

DROP FUNCTION IF EXISTS gpReport_GoodsMI_TransferDebt (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsMI_TransferDebt (
    IN inStartDate    TDateTime ,  
    IN inEndDate      TDateTime ,
    IN inDescId       Integer   , -- zc_Movement_TransferDebtOut() or zc_Movement_TransferDebtIn()
    IN inJuridicalId  Integer   , 
    IN inInfoMoneyId  Integer   , -- �������������� ������  
    IN inPaidKindId   Integer   , --
    IN inGoodsGroupId Integer   ,
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS TABLE (GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsCode Integer, GoodsName TVarChar, GoodsKindName TVarChar, MeasureName TVarChar
             , Amount_Weight TFloat, Amount_Sh TFloat
             , SummPartner TFloat
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             )   
AS
$BODY$
BEGIN
    -- ����������� �� �������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0
    THEN
        INSERT INTO _tmpGoods (GoodsId)
           SELECT GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object.Id FROM Object WHERE DescId = zc_Object_Goods();
    END IF;


    -- ���������
    RETURN QUERY
    WITH tmpOperationGroup AS
                (SELECT tmpReportContainerSumm.InfoMoneyId       
                      , tmpReportContainerSumm.GoodsId   
                      , tmpReportContainerSumm.GoodsKindId
                      , (tmpReportContainerSumm.Amount) AS Amount
                      , (tmpReportContainerSumm.SummPartner) AS SummPartner
                 FROM (SELECT tmpReportContainer.InfoMoneyId
                            , MovementItem.ObjectId AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , SUM (MovementItem.Amount) AS Amount
                            , SUM (MIReport.Amount) AS SummPartner
                       FROM (SELECT ContainerLinkObject_InfoMoney.ObjectId AS InfoMoneyId
                                  , ReportContainerLink.ReportContainerId
                             FROM (SELECT zc_Enum_Account_110401() AS Id
                                        , CASE WHEN inDescId = zc_Movement_TransferDebtOut() THEN zc_Enum_AccountKind_Passive() ELSE zc_Enum_AccountKind_Active() END AS AccountKindId
                                        , CASE WHEN inDescId = zc_Movement_TransferDebtOut() THEN zc_Enum_AccountKind_Active() ELSE zc_Enum_AccountKind_Passive() END AS AccountKindId_child
                                  ) AS tmpAccount
                                  INNER JOIN Container ON Container.ObjectId = tmpAccount.Id
                                                      AND Container.DescId = zc_Container_Summ()
                                  INNER JOIN ReportContainerLink ON ReportContainerLink.ContainerId = Container.Id
                                                                AND ReportContainerLink.AccountKindId = tmpAccount.AccountKindId
                                  INNER JOIN ReportContainerLink AS ReportContainerLink_child ON ReportContainerLink_child.ReportContainerId = ReportContainerLink.ReportContainerId
                                                                                             AND ReportContainerLink_child.AccountKindId = tmpAccount.AccountKindId_child
                                  INNER JOIN ContainerLinkObject AS ContainerLO_Juridical
                                                                 ON ContainerLO_Juridical.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()
                                                                AND (ContainerLO_Juridical.ObjectId = inJuridicalId OR COALESCE (inJuridicalId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_InfoMoney
                                                                 ON ContainerLinkObject_InfoMoney.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLinkObject_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                                                AND (ContainerLinkObject_InfoMoney.ObjectId = inInfoMoneyId OR COALESCE (inInfoMoneyId, 0) = 0)
                                  INNER JOIN ContainerLinkObject AS ContainerLinkObject_PaidKind
                                                                 ON ContainerLinkObject_PaidKind.ContainerId = ReportContainerLink_child.ContainerId
                                                                AND ContainerLinkObject_PaidKind.DescId = zc_ContainerLinkObject_PaidKind()
                                                                AND (ContainerLinkObject_PaidKind.ObjectId = inPaidKindId OR COALESCE (inPaidKindId, 0) = 0)
                             ) AS tmpReportContainer
                             INNER JOIN MovementItemReport AS MIReport ON MIReport.ReportContainerId = tmpReportContainer.ReportContainerId
                                                                      AND MIReport.OperDate BETWEEN inStartDate AND inEndDate
                             INNER JOIN Movement ON Movement.Id = MIReport.MovementId
                                                AND Movement.DescId = inDescId
                             INNER JOIN MovementItem ON MovementItem.Id = MIReport.MovementItemId
                                                    AND MovementItem.DescId = zc_MI_Master()
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
           
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                       ON MovementBoolean_PriceWithVAT.MovementId =  MIReport.MovementId
                                                      AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                             LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                     ON MovementFloat_VATPercent.MovementId =  MIReport.MovementId
                                                    AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MIReport.MovementItemId
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                       GROUP BY tmpReportContainer.InfoMoneyId
                              , MovementItem.ObjectId
                              , MILinkObject_GoodsKind.ObjectId
                      ) AS tmpReportContainerSumm
                 WHERE tmpReportContainerSumm.Amount <> 0
                    OR tmpReportContainerSumm.SummPartner <> 0
                )

    SELECT Object_GoodsGroup.ValueData            AS GoodsGroupName 
         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , Object_GoodsKind.ValueData             AS GoodsKindName
         , Object_Measure.ValueData               AS MeasureName

         , (tmpOperationGroup.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS Amount_Weight
         , (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpOperationGroup.Amount ELSE 0 END) :: TFloat                                AS Amount_Sh

         , tmpOperationGroup.SummPartner :: TFloat                    AS SummPartner

         , View_InfoMoney.InfoMoneyGroupName              AS InfoMoneyGroupName
         , View_InfoMoney.InfoMoneyDestinationName        AS InfoMoneyDestinationName
         , View_InfoMoney.InfoMoneyCode                   AS InfoMoneyCode
         , View_InfoMoney.InfoMoneyName                   AS InfoMoneyName

     FROM tmpOperationGroup
          LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpOperationGroup.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpOperationGroup.GoodsKindId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                 ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
          LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                               AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmpOperationGroup.InfoMoneyId
   ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_GoodsMI_TransferDebt (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.14                                        *
*/

-- ����
-- SELECT SUM (Amount_Weight), SUM (SummPartner) FROM gpReport_GoodsMI_TransferDebt (inStartDate:= '01.01.2014', inEndDate:= '01.01.2014', inDescId:= zc_Movement_TransferDebtOut(), inJuridicalId:= 0, inInfoMoneyId:= 0, inPaidKindId:= 0, inGoodsGroupId:= 0, inSession:= zfCalc_UserAdmin());
