-- Function: gpReport_GoodsBalance()

DROP FUNCTION IF EXISTS gpReport_GoodsBalance (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_GoodsBalance(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inAccountGroupId     Integer,    --
    IN inUnitGroupId        Integer,    -- ������ ������������� �� ����� ���� ����� ���� � ��������������
    IN inLocationId         Integer,    --
    IN inGoodsGroupId       Integer,    -- ������ ������
    IN inGoodsId            Integer,    -- �����
    IN inIsInfoMoney        Boolean,    --
    IN inSession            TVarChar   -- ������������
)
RETURNS TABLE (AccountGroupName TVarChar, AccountDirectionName TVarChar
             , AccountId Integer, AccountCode Integer, AccountName TVarChar, AccountName_All TVarChar
             , LocationDescName TVarChar, LocationId Integer, LocationCode Integer, LocationName TVarChar
             , CarCode Integer, CarName TVarChar
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsKindId Integer, GoodsKindName TVarChar, MeasureName TVarChar
             , Weight TFloat
             , PartionGoodsId Integer, PartionGoodsName TVarChar, AssetToName TVarChar

             , CountReal    TFloat      -- ������� �������
             , CountReal_sh TFloat      -- ������� �������
             , CountReal_Weight TFloat  -- ������� �������

             , CountStart TFloat
             , CountStart_sh TFloat
             , CountStart_Weight TFloat
             , CountEnd TFloat
             , CountEnd_sh TFloat
             , CountEnd_Weight TFloat
             
             , SummStart TFloat
             , SummEnd TFloat

             , PriceListStart TFloat
             , PriceListEnd TFloat
          
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , InfoMoneyId_Detail Integer, InfoMoneyCode_Detail Integer, InfoMoneyGroupName_Detail TVarChar, InfoMoneyDestinationName_Detail TVarChar, InfoMoneyName_Detail TVarChar, InfoMoneyName_all_Detail TVarChar

             , LineNum Integer

             , CountIn TFloat
             , CountIn_sh TFloat
             , CountIn_Weight TFloat
             , CountOut TFloat
             , CountOut_sh TFloat
             , CountOut_Weight TFloat
             , CountIn_calc TFloat
             , CountIn_sh_calc TFloat
             , CountIn_Weight_calc TFloat
             , CountOut_calc TFloat
             , CountOut_sh_calc TFloat
             , CountOut_Weight_calc TFloat
             , CountEnd_calc TFloat
             , CountEnd_sh_calc TFloat
             , CountEnd_Weight_calc TFloat

             , ColorB_GreenL Integer, ColorB_Yelow Integer, ColorB_Cyan Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_MotionGoods());
    vbUserId:= lpGetUserBySession (inSession);
   
 -- !!!����� ��� ����� �������!!!
    inAccountGroupId:= COALESCE (inAccountGroupId, 0);

    -- !!!�������� ��������� ��� �������!!!
    IF 0 < (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 GROUP BY BranchId)
    THEN
        inAccountGroupId:= zc_Enum_AccountGroup_20000(); -- ������
        inIsInfoMoney:= FALSE;
    END IF;


    -- ������� -
    CREATE TEMP TABLE _tmpListContainer (LocationId Integer, ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, GoodsId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpContainer (ContainerDescId Integer, ContainerId_count Integer, ContainerId_begin Integer, LocationId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsId Integer, AssetToId Integer, AccountId Integer, AccountGroupId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpLocation (LocationId Integer, DescId Integer, ContainerDescId Integer) ON COMMIT DROP;

    -- ������ ������������� ��� ������������� ��� ����� ����� (��, ����)
    IF inUnitGroupId <> 0
    THEN
        INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
           SELECT lfSelect_Object_Unit_byGroup.UnitId AS LocationId
                , zc_ContainerLinkObject_Unit()       AS DescId
                , tmpDesc.ContainerDescId
           FROM lfSelect_Object_Unit_byGroup (inUnitGroupId) AS lfSelect_Object_Unit_byGroup
                LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId /*UNION SELECT zc_Container_Summ() AS ContainerDescId*/) AS tmpDesc ON 1 = 1
          ;
    ELSE
        IF inLocationId <> 0
        THEN
            INSERT INTO _tmpLocation (LocationId, DescId, ContainerDescId)
               SELECT Object.Id AS LocationId
                    , CASE WHEN Object.DescId = zc_Object_Unit() THEN zc_ContainerLinkObject_Unit() 
                           WHEN Object.DescId = zc_Object_Car() THEN zc_ContainerLinkObject_Car() 
                           WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                      END AS DescId
                    , tmpDesc.ContainerDescId
               FROM Object
                    LEFT JOIN (SELECT zc_Container_Count() AS ContainerDescId /*UNION SELECT zc_Container_Summ() AS ContainerDescId*/) AS tmpDesc ON 1 = 1
               WHERE Object.Id = inLocationId;
        ELSE
            WITH tmpBranch AS (SELECT TRUE AS Value WHERE 1 = 0 AND NOT EXISTS (SELECT BranchId FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0))
            INSERT INTO _tmpLocation (LocationId)
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Unit()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Member()
              UNION ALL
               SELECT Id FROM Object INNER JOIN tmpBranch ON tmpBranch.Value = TRUE WHERE DescId = zc_Object_Car();
        END IF;
    END IF;
    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpLocation;


    -- ������ ������� ��� ����� ��� ��� ������ �� ��������
    IF inGoodsGroupId <> 0
    THEN
        WITH tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup)
           , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId = inAccountGroupId)

        INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
           SELECT _tmpLocation.LocationId
                , _tmpLocation.ContainerDescId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN ContainerLinkObject.ContainerId
                       ELSE COALESCE (Container.ParentId, 0)
                  END AS ContainerId_count
                , ContainerLinkObject.ContainerId AS ContainerId_begin
                , tmpGoods.GoodsId
                , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN COALESCE (CLO_Account.ObjectId, 0)
                       ELSE COALESCE (Container.ObjectId, 0)
                  END AS AccountId
                , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                            THEN zc_Enum_AccountGroup_110000() -- �������
                       ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                  END AS AccountGroupId
                , Container.Amount
           FROM _tmpLocation
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                              AND ContainerLinkObject.DescId = _tmpLocation.DescId
                LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                          AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                          AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                LEFT JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                   AND Container.DescId = _tmpLocation.ContainerDescId
                INNER JOIN tmpGoods ON tmpGoods.GoodsId = CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN Container.ObjectId ELSE CLO_Goods.ObjectId END
                LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                            AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                            AND _tmpLocation.ContainerDescId = zc_Container_Count()
           WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
              OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                        OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
                                                                         ))
              OR inAccountGroupId = 0
          ;
    ELSE IF inGoodsId <> 0
         THEN
             WITH tmpContainer AS (SELECT CLO_Goods.ContainerId FROM ContainerLinkObject AS CLO_Goods WHERE CLO_Goods.ObjectId = inGoodsId AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                 UNION
                                   SELECT Container.Id FROM Container WHERE Container.ObjectId = inGoodsId AND Container.DescId = zc_Container_Count()
                                  )
                , tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId IN (inAccountGroupId, zc_Enum_AccountGroup_60000())) -- ������� ������� ��������

             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN tmpContainer.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , tmpContainer.ContainerId AS ContainerId_begin
                     , inGoodsId AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN zc_Enum_AccountGroup_110000() -- �������
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                FROM tmpContainer
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = tmpContainer.ContainerId
                     INNER JOIN _tmpLocation ON _tmpLocation.LocationId = ContainerLinkObject.ObjectId
                                            AND _tmpLocation.DescId = ContainerLinkObject.DescId
                     INNER JOIN Container ON Container.Id = tmpContainer.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountGroupId = inAccountGroupId)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
                                                                              ))
                   OR inAccountGroupId = 0
               ;
         ELSE
             WITH tmpAccount AS (SELECT View_Account.AccountGroupId, View_Account.AccountId FROM Object_Account_View AS View_Account WHERE View_Account.AccountGroupId = inAccountGroupId)

             INSERT INTO _tmpListContainer (LocationId, ContainerDescId, ContainerId_count, ContainerId_begin, GoodsId, AccountId, AccountGroupId, Amount)
                SELECT _tmpLocation.LocationId
                     , _tmpLocation.ContainerDescId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN ContainerLinkObject.ContainerId
                            ELSE COALESCE (Container.ParentId, 0)
                       END AS ContainerId_count
                     , ContainerLinkObject.ContainerId AS ContainerId_begin
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count() THEN COALESCE (Container.ObjectId, 0) ELSE COALESCE (CLO_Goods.ObjectId, 0) END AS GoodsId
                     , CASE WHEN _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN COALESCE (CLO_Account.ObjectId, 0)
                            ELSE COALESCE (Container.ObjectId, 0)
                       END AS AccountId
                     , CASE WHEN CLO_Account.ObjectId > 0 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                                 THEN zc_Enum_AccountGroup_110000() -- �������
                            ELSE COALESCE (tmpAccount.AccountGroupId, 0)
                       END AS AccountGroupId
                     , Container.Amount
                FROM _tmpLocation
                     INNER JOIN ContainerLinkObject ON ContainerLinkObject.ObjectId = _tmpLocation.LocationId
                                                   AND ContainerLinkObject.DescId = _tmpLocation.DescId
                     INNER JOIN Container ON Container.Id = ContainerLinkObject.ContainerId
                                         AND Container.DescId = _tmpLocation.ContainerDescId
                     LEFT JOIN tmpAccount ON tmpAccount.AccountId = Container.ObjectId
                     LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = ContainerLinkObject.ContainerId
                                                               AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
                                                               AND _tmpLocation.ContainerDescId = zc_Container_Summ()
                     LEFT JOIN ContainerLinkObject AS CLO_Account ON CLO_Account.ContainerId = Container.Id
                                                                 AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                                                                 AND _tmpLocation.ContainerDescId = zc_Container_Count()
                WHERE (_tmpLocation.ContainerDescId = zc_Container_Summ() AND tmpAccount.AccountId > 0)
                   OR (_tmpLocation.ContainerDescId = zc_Container_Count() AND ((CLO_Account.ContainerId > 0 AND inAccountGroupId = zc_Enum_AccountGroup_110000()) -- �������
                                                                             OR (CLO_Account.ContainerId IS NULL AND inAccountGroupId <> zc_Enum_AccountGroup_110000()) -- �������
                                                                              ))
                   OR inAccountGroupId = 0
               ;
         END IF;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpListContainer;

    -- �������� ����� <����> ��� zc_Container_Count
    UPDATE _tmpListContainer SET AccountId = _tmpListContainer_summ.AccountId
                               , AccountGroupId = _tmpListContainer_summ.AccountGroupId
    FROM _tmpListContainer AS _tmpListContainer_summ
    WHERE _tmpListContainer.ContainerId_count = _tmpListContainer_summ.ContainerId_count
      AND _tmpListContainer.ContainerDescId = zc_Container_Count()
      AND _tmpListContainer_summ.ContainerDescId = zc_Container_Summ()
      AND _tmpListContainer.AccountId = 0
      AND _tmpListContainer_summ.AccountGroupId <> zc_Enum_AccountGroup_110000() -- �������
   ;

    -- ��� ContainerId
    INSERT INTO _tmpContainer (ContainerDescId, ContainerId_count, ContainerId_begin, LocationId, GoodsId, GoodsKindId, PartionGoodsId, AssetToId, AccountId, AccountGroupId, Amount)
       SELECT _tmpListContainer.ContainerDescId
            , _tmpListContainer.ContainerId_count
            , _tmpListContainer.ContainerId_begin
            , _tmpListContainer.LocationId
            , _tmpListContainer.GoodsId
            , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
            , COALESCE (CLO_PartionGoods.ObjectId, 0) AS PartionGoodsId
            , COALESCE (CLO_AssetTo.ObjectId, 0) AS AssetToId
            , _tmpListContainer.AccountId
            , _tmpListContainer.AccountGroupId
            , _tmpListContainer.Amount
       FROM _tmpListContainer
            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpListContainer.ContainerId_begin
                                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
            LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpListContainer.ContainerId_begin
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
            LEFT JOIN ContainerLinkObject AS CLO_AssetTo ON CLO_AssetTo.ContainerId = _tmpListContainer.ContainerId_begin
                                                        AND CLO_AssetTo.DescId = zc_ContainerLinkObject_AssetTo()
       ;

    -- ���������
    RETURN QUERY
          WITH tmpMIContainer AS (SELECT _tmpContainer.ContainerDescId
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_count ELSE 0 END AS ContainerId_count
                                       , CASE WHEN inIsInfoMoney = TRUE THEN _tmpContainer.ContainerId_begin ELSE 0 END AS ContainerId_begin
                                       , _tmpContainer.LocationId
                                       , _tmpContainer.GoodsId
                                       , _tmpContainer.GoodsKindId
                                       , _tmpContainer.PartionGoodsId
                                       , _tmpContainer.AssetToId
                                       , _tmpContainer.AccountId
                                       , _tmpContainer.AccountGroupId

                                       , _tmpContainer.Amount AS AmountReal

                                       , _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS RemainsStart
                                       , _tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) AS RemainsEnd

                                       , SUM (CASE WHEN MIContainer.isActive = TRUE  AND MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END) AS AmountIn
                                       , SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.OperDate <= inEndDate THEN -1 * MIContainer.Amount ELSE 0 END) AS AmountOut

                                  FROM _tmpContainer
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = _tmpContainer.ContainerId_begin
                                                                                     AND MIContainer.OperDate >= inStartDate
                                  GROUP BY _tmpContainer.ContainerDescId
                                         , _tmpContainer.ContainerId_count
                                         , _tmpContainer.ContainerId_begin
                                         , _tmpContainer.LocationId
                                         , _tmpContainer.GoodsId
                                         , _tmpContainer.GoodsKindId
                                         , _tmpContainer.PartionGoodsId
                                         , _tmpContainer.AssetToId
                                         , _tmpContainer.AccountId
                                         , _tmpContainer.AccountGroupId
                                         , _tmpContainer.Amount
                                  HAVING _tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                      OR _tmpContainer.Amount - COALESCE (SUM (CASE WHEN MIContainer.OperDate > inEndDate THEN MIContainer.Amount ELSE 0 END), 0) <> 0
                                      OR SUM (CASE WHEN MIContainer.isActive = TRUE  AND MIContainer.OperDate <= inEndDate THEN MIContainer.Amount ELSE 0 END) <> 0
                                      OR SUM (CASE WHEN MIContainer.isActive = FALSE AND MIContainer.OperDate <= inEndDate THEN -1 * MIContainer.Amount ELSE 0 END) <> 0
                                      OR _tmpContainer.Amount <> 0
                                 )

, tmpMIContainer_all AS
       (SELECT  tmpMIContainer.GoodsId
              , tmpMIContainer.GoodsKindId
              , tmpMIContainer.PartionGoodsId

              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountIn ELSE 0 END) AS CountIn
              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountOut   ELSE 0 END) AS CountOut

              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.AmountReal ELSE 0 END) AS CountReal

              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.RemainsStart ELSE 0 END) AS CountStart
              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Count() THEN tmpMIContainer.RemainsEnd   ELSE 0 END) AS CountEnd
     
              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer.RemainsStart ELSE 0 END) AS SummStart
              , SUM (CASE WHEN tmpMIContainer.ContainerDescId = zc_Container_Summ() THEN tmpMIContainer.RemainsEnd   ELSE 0 END) AS SummEnd
          
         FROM tmpMIContainer
         GROUP BY tmpMIContainer.GoodsId
                , tmpMIContainer.GoodsKindId
                , tmpMIContainer.PartionGoodsId
         )

         , tmpPriceStart AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inStartDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )
         , tmpPriceEnd AS (SELECT lfObjectHistory_PriceListItem.GoodsId
                                , (lfObjectHistory_PriceListItem.ValuePrice * 1.2) :: TFloat AS Price
                           FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= inEndDate) AS lfObjectHistory_PriceListItem
                           WHERE lfObjectHistory_PriceListItem.ValuePrice <> 0
                          )   

       , tmpMovement_all AS (SELECT MovementItem.ObjectId                                AS GoodsId
                                  , COALESCE (MovementString_PartionGoods.ValueData, '') AS PartionGoodsName
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)        AS GoodsKindId
                                  , SUM (CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()   AND MovementItem.DescId = zc_MI_Child()  THEN MovementItem.Amount Else 0 END) AS CountIn_calc
                                  , SUM (CASE WHEN MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From() AND MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount Else 0 END) AS CountOut_calc
                             FROM Movement 
                                  LEFT JOIN MovementString AS MovementString_PartionGoods
                                                           ON MovementString_PartionGoods.MovementId =  Movement.Id
                                                          AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.isErased = FALSE
                                                    
                                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                             WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                               AND Movement.DescId   = zc_Movement_ProductionSeparate()
                               AND Movement.StatusId = zc_Enum_Status_UnComplete()
                               AND MovementLinkObject_Unit.ObjectId IN (SELECT _tmpLocation.LocationId FROM _tmpLocation)

                             GROUP BY MovementItem.ObjectId
                                    , COALESCE (MovementString_PartionGoods.ValueData, '')
                                    , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                             )
                         
         , tmpResult AS (SELECT tmpAll.GoodsId
                              , tmpAll.GoodsKindId
                              , tmpAll.PartionGoodsName

                              , SUM (tmpAll.CountIn_calc)  AS CountIn_calc
                              , SUM (tmpAll.CountOut_calc) AS CountOut_calc

                              , SUM (tmpAll.CountIn)  AS CountIn
                              , SUM (tmpAll.CountOut) AS CountOut

                              , SUM (tmpAll.CountReal) AS CountReal

                              , SUM (tmpAll.CountStart) AS CountStart
                              , SUM (tmpAll.CountEnd)   AS CountEnd
     
                              , SUM (tmpAll.SummStart) AS SummStart
                              , SUM (tmpAll.SummEnd)   AS SummEnd

                              , SUM (tmpAll.CountStart + tmpAll.CountIn + tmpAll.CountIn_calc - tmpAll.CountOut - tmpAll.CountOut_calc) AS CountEnd_calc

                         FROM (SELECT tmpMovement_all.GoodsId
                                    , tmpMovement_all.GoodsKindId
                                    , CASE WHEN ObjectBoolean_PartionCount.ValueData = TRUE THEN zfFormat_PartionGoods (tmpMovement_all.PartionGoodsName) ELSE '' END AS PartionGoodsName

                                    , (tmpMovement_all.CountIn_calc)  AS  CountIn_calc
                                    , (tmpMovement_all.CountOut_calc) AS  CountOut_calc

                                    , 0 AS CountIn
                                    , 0 AS CountOut

                                    , 0 AS CountReal
                                    , 0 AS CountStart
                                    , 0 AS CountEnd
                                    , 0 AS SummStart
                                    , 0 AS SummEnd

                               FROM tmpMovement_all
                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                                            ON ObjectBoolean_PartionCount.ObjectId = tmpMovement_all.GoodsId
                                                           AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                              UNION ALL
                               SELECT tmpMIContainer_all.GoodsId
                                    , tmpMIContainer_all.GoodsKindId
                                    , COALESCE (Object_PartionGoods.ValueData, '') AS PartionGoodsName

                                    , 0 AS CountIn_calc
                                    , 0 AS CountOut_calc

                                    , tmpMIContainer_all.CountIn
                                    , tmpMIContainer_all.CountOut

                                    , tmpMIContainer_all.CountReal
                                    , tmpMIContainer_all.CountStart
                                    , tmpMIContainer_all.CountEnd

                                    , tmpMIContainer_all.SummStart
                                    , tmpMIContainer_all.SummEnd

                               FROM tmpMIContainer_all
                                    LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = tmpMIContainer_all.PartionGoodsId
                              ) AS tmpAll

                        GROUP BY tmpAll.GoodsId
                               , tmpAll.GoodsKindId
                               , tmpAll.PartionGoodsName
                        )


     SELECT View_Account.AccountGroupName, View_Account.AccountDirectionName
        , View_Account.AccountId, View_Account.AccountCode, View_Account.AccountName, View_Account.AccountName_all
        , ObjectDesc.ItemName            AS LocationDescName
        , CAST (COALESCE(Object_Location.Id, 0) AS Integer)             AS LocationId
        , Object_Location.ObjectCode     AS LocationCode
        , CAST (COALESCE(Object_Location.ValueData,'') AS TVarChar)     AS LocationName
        , Object_Car.ObjectCode          AS CarCode
        , Object_Car.ValueData           AS CarName
        , Object_GoodsGroup.ValueData    AS GoodsGroupName
        , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
        , CAST (COALESCE(Object_Goods.Id, 0) AS Integer)                 AS GoodsId
        , Object_Goods.ObjectCode        AS GoodsCode
        , CAST (COALESCE(Object_Goods.ValueData, '') AS TVarChar)        AS GoodsName
        , CAST (COALESCE(Object_GoodsKind.Id, 0) AS Integer)             AS GoodsKindId
        , CAST (COALESCE(Object_GoodsKind.ValueData, '') AS TVarChar)    AS GoodsKindName
        , Object_Measure.ValueData       AS MeasureName
        , ObjectFloat_Weight.ValueData   AS Weight
        , 0                                      AS PartionGoodsId
        , tmpResult.PartionGoodsName :: TVarChar  AS PartionGoodsName
        , Object_AssetTo.ValueData       AS AssetToName

        , tmpResult.CountReal :: TFloat AS CountReal
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountReal ELSE 0 END :: TFloat AS CountReal_sh
        , (tmpResult.CountReal * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountReal_Weight

        , tmpResult.CountStart :: TFloat AS CountStart
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountStart ELSE 0 END :: TFloat AS CountStart_sh
        , (tmpResult.CountStart * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountStart_Weight

        , tmpResult.CountEnd  :: TFloat AS CountEnd
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountEnd ELSE 0 END :: TFloat AS CountEnd_sh
        , (tmpResult.CountEnd * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountEnd_Weight
    
        , tmpResult.SummStart :: TFloat AS SummStart
        , tmpResult.SummEnd   :: TFloat AS SummEnd
    
        , tmpPriceStart.Price AS PriceListStart
        , tmpPriceEnd.Price   AS PriceListEnd

        , View_InfoMoney.InfoMoneyId
        , View_InfoMoney.InfoMoneyCode
        , View_InfoMoney.InfoMoneyGroupName
        , View_InfoMoney.InfoMoneyDestinationName
        , View_InfoMoney.InfoMoneyName
        , View_InfoMoney.InfoMoneyName_all

        , View_InfoMoneyDetail.InfoMoneyId              AS InfoMoneyId_Detail
        , View_InfoMoneyDetail.InfoMoneyCode            AS InfoMoneyCode_Detail
        , View_InfoMoneyDetail.InfoMoneyGroupName       AS InfoMoneyGroupName_Detail
        , View_InfoMoneyDetail.InfoMoneyDestinationName AS InfoMoneyDestinationName_Detail
        , View_InfoMoneyDetail.InfoMoneyName            AS InfoMoneyName_Detail
        , View_InfoMoneyDetail.InfoMoneyName_all        AS InfoMoneyName_all_Detail

        , CAST (row_number() OVER () AS INTEGER)        AS LineNum

        , tmpResult.CountIn ::TFloat  AS CountIn
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountIn ELSE 0 END :: TFloat AS CountIn_sh
        , (tmpResult.CountIn * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_Weight

        , tmpResult.CountOut ::TFloat AS CountOut
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountOut ELSE 0 END :: TFloat AS CountOut_sh
        , (tmpResult.CountOut * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_Weight

        , tmpResult.CountIn_calc ::TFloat  AS CountIn_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountIn_calc ELSE 0 END :: TFloat AS CountIn_sh_calc
        , (tmpResult.CountIn_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountIn_Weight_calc

        , tmpResult.CountOut_calc ::TFloat AS CountOut_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountOut_calc ELSE 0 END :: TFloat AS CountOut_sh_calc
        , (tmpResult.CountOut_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountOut_Weight_calc

        , tmpResult.CountEnd_calc :: TFloat AS CountEnd_calc
        , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpResult.CountEnd_calc ELSE 0 END :: TFloat AS CountEnd_sh_calc
        , (tmpResult.CountEnd_calc * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) :: TFloat AS CountEnd_Weight_calc

        , zc_Color_GreenL() :: Integer AS ColorB_GreenL
        , zc_Color_Yelow()  :: Integer AS ColorB_Yelow
        , zc_Color_Cyan()   :: Integer AS ColorB_Cyan

      FROM tmpResult
        LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                      ON CLO_InfoMoney.ContainerId = NULL
                                     AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = CLO_InfoMoney.ObjectId

        LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail
                                      ON CLO_InfoMoneyDetail.ContainerId = NULL
                                     AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
        LEFT JOIN Object_InfoMoney_View AS View_InfoMoneyDetail ON View_InfoMoneyDetail.InfoMoneyId = CLO_InfoMoneyDetail.ObjectId

        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsId
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpResult.GoodsKindId
        LEFT JOIN Object AS Object_Location_find ON Object_Location_find.Id = NULL
        LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Location_find.DescId
        LEFT JOIN ObjectLink AS ObjectLink_Car_Unit ON ObjectLink_Car_Unit.ObjectId = NULL
                                                   AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
        LEFT JOIN Object AS Object_Location ON Object_Location.Id = NULL
        LEFT JOIN Object AS Object_Car ON Object_Car.Id = NULL

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
        LEFT JOIN ObjectFloat AS ObjectFloat_Weight ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                             AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

        LEFT JOIN Object AS Object_AssetTo ON Object_AssetTo.Id = NULL

        LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = NULL

        LEFT JOIN tmpPriceStart ON tmpPriceStart.GoodsId = tmpResult.GoodsId
        LEFT JOIN tmpPriceEnd ON tmpPriceEnd.GoodsId = tmpResult.GoodsId


        WHERE tmpResult.CountReal <> 0
           OR tmpResult.CountStart <> 0
           OR tmpResult.CountEnd <> 0
           OR tmpResult.CountEnd_calc <> 0
           OR tmpResult.CountIn <> 0
           OR tmpResult.CountOut <> 0
           OR tmpResult.CountIn_calc <> 0
           OR tmpResult.CountOut_calc <> 0
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.07.15         *
 02.05.15         * 
*/

-- ����
-- SELECT * from gpReport_GoodsBalance (inStartDate:= '01.07.2015', inEndDate:= '01.07.2015', inAccountGroupId:= 0, inUnitGroupId := 8459 , inLocationId := 0 , inGoodsGroupId := 1860 , inGoodsId := 0 , inIsInfoMoney:= TRUE, inSession := '5');
