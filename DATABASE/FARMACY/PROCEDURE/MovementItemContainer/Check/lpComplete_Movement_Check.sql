 -- Function: lpComplete_Movement_Income (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_Check (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Check(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- ������������
)                              
RETURNS Text
AS
$BODY$
   DECLARE vbAccountId Integer;
   DECLARE vbOperSumm_Partner TFloat;
   DECLARE vbOperSumm_Partner_byItem TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbMovementItemId Integer;
   DECLARE vbContainerId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbAmount_remains TFloat;

   DECLARE curRemains refcursor;
   DECLARE curSale refcursor;
BEGIN

     -- ��������� ��������� ������� - ��� ������������ ������ ��� ��������
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMIContainer_insert'))
     THEN
         -- !!!�����������!!! �������� ������� ��������
         DELETE FROM _tmpMIContainer_insert;
         DELETE FROM _tmpMIReport_insert;
     ELSE
         PERFORM lpComplete_Movement_Finance_CreateTemp();
     END IF;

    -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
    DELETE FROM _tmpItem;


    -- ����������
    vbOperDate:= (SELECT OperDate FROM Movement WHERE Id = inMovementId);

    -- ����������
    vbAccountId:= lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- C���� 
                                             , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId);

    -- ����������
    vbUnitId:= (SELECT MovementLinkObject.ObjectId
                FROM MovementLinkObject 
                WHERE MovementLinkObject.MovementId = inMovementId 
                  AND MovementLinkObject.DescId = zc_MovementLinkObject_Unit());

   
/*  
    -- �������� �� ������ ���������. ������ � �����
    INSERT INTO _tmpItem(ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate)   
    SELECT Movement_Income_View.FromId
        , Movement_Income_View.TotalSumm
        , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_70000()
                                     , inAccountDirectionId     := zc_Enum_AccountDirection_70100()
                                     , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200()
                                     , inInfoMoneyId            := NULL
                                     , inUserId                 := inUserId)
        , Movement_Income_View.JuridicalId
        , Movement_Income_View.OperDate
    FROM Movement_Income_View
    WHERE Movement_Income_View.Id =  inMovementId;
    
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_Summ()
      , zc_Movement_Income()  
      , inMovementId
      , lpInsertFind_Container(
                      inContainerDescId   := zc_Container_Summ(), -- DescId �������
                      inParentId          := NULL               , -- ������� Container
                      inObjectId          := _tmpItem.AccountId, -- ������ (���� ��� ����� ��� ...)
                      inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                      inBusinessId        := NULL, -- �������
                      inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                      inObjectCostId      := NULL, -- <������� �/�> - ��������� ��������� ����� 
                      inDescId_1          := zc_ContainerLinkObject_Juridical(), -- DescId ��� 1-�� ���������
                      inObjectId_1        := _tmpItem.ObjectId) 
      , AccountId
      , - OperSumm
      , OperDate
    FROM _tmpItem;
             
    SELECT SUM(OperSumm) INTO vbOperSumm_Partner
    FROM _tmpItem;

    -- ����� �������
    INSERT INTO _tmpMIContainer_insert(DescId, MovementDescId, MovementId, ContainerId, AccountId, Amount, OperDate)
    SELECT 
        zc_Container_SummIncomeMovementPayment()
      , zc_Movement_Income()  
      , inMovementId
      , lpInsertFind_Container(
                  inContainerDescId := zc_Container_SummIncomeMovementPayment(), -- DescId �������
                  inParentId        := NULL               , -- ������� Container
                  inObjectId := lpInsertFind_Object_PartionMovement(inMovementId), -- ������ (���� ��� ����� ��� ...)
                  inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                  inBusinessId := NULL, -- �������
                  inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                  inObjectCostId       := NULL) -- <������� �/�> - ��������� ��������� �����) 
      , null
      , OperSumm
      , OperDate
    FROM _tmpItem;
*/               
/*
    CREATE TEMP TABLE _tmpItem (MovementDescId Integer, OperDate TDateTime, ObjectId Integer, ObjectDescId Integer, OperSumm TFloat, OperSumm_Currency TFloat, OperSumm_Diff TFloat
                               , MovementItemId Integer, ContainerId Integer, ContainerId_Currency Integer, ContainerId_Diff Integer, ProfitLossId_Diff Integer
                               , AccountGroupId Integer, AccountDirectionId Integer, AccountId Integer
                               , ProfitLossGroupId Integer, ProfitLossDirectionId Integer
                               , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                               , BusinessId_Balance Integer, BusinessId_ProfitLoss Integer, JuridicalId_Basis Integer
                               , UnitId Integer, PositionId Integer, BranchId_Balance Integer, BranchId_ProfitLoss Integer, ServiceDateId Integer, ContractId Integer, PaidKindId Integer
                               , AnalyzerId Integer
                               , CurrencyId Integer
                               , IsActive Boolean, IsMaster Boolean
                                ) ON COMMIT DROP;
*/
/*
    DELETE FROM _tmpItem;
    INSERT INTO _tmpItem(MovementDescId, MovementItemId, ObjectId, OperSumm, AccountId, JuridicalId_Basis, OperDate, UnitId)   
    SELECT
        zc_Movement_Income()
      , MovementItem_Income_View.Id
      , MovementItem_Income_View.GoodsId
      , MovementItem_Income_View.Amount
      , lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                   , inAccountDirectionId     := zc_Enum_AccountDirection_20100() -- C���� 
                                   , inInfoMoneyDestinationId := zc_Enum_InfoMoneyDestination_10200() -- �����������
                                   , inInfoMoneyId            := NULL
                                   , inUserId                 := inUserId)
      , Movement_Income_View.JuridicalId
      , Movement_Income_View.OperDate
      , Movement_Income_View.ToId
    FROM MovementItem_Income_View, Movement_Income_View
    WHERE MovementItem_Income_View.MovementId = Movement_Income_View.Id AND Movement_Income_View.Id =  inMovementId;
 */

    -- ������ ����� ���
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_remains'))
    THEN
        DELETE FROM _tmpItem_remains;
    ELSE
        -- ������� - ������ ����� ���
        CREATE TEMP TABLE _tmpItem_remains (GoodsId Integer, ContainerId Integer, Amount TFloat, OperDate TDateTime);
    END IF;

    -- �������������� ��������� �������
    INSERT INTO _tmpItem (MovementItemId, ObjectId, OperSumm)
       SELECT Id, ObjectId, Amount FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.Amount > 0 AND MI.isErased = FALSE;
    -- �������������� ��������� �������
    INSERT INTO _tmpItem_remains (GoodsId, ContainerId, Amount, OperDate)
       SELECT Container.ObjectId AS GoodsId
            , Container.Id       AS ContainerId
            , Container.Amount
            , Movement.OperDate
       FROM (SELECT DISTINCT ObjectId FROM _tmpItem) AS tmp
            INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                AND Container.WhereObjectId = vbUnitId
                                AND Container.ObjectId = tmp.ObjectId
                                AND Container.Amount > 0
            INNER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = Container.Id
                                          AND CLI_MI.descid = zc_ContainerLinkObject_PartionMovementItem()
            INNER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
            INNER JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode
            INNER JOIN Movement ON Movement.Id = MovementItem.MovementId;


    -- �������� ��� � ��� �������
    IF EXISTS (SELECT 1 FROM (SELECT ObjectId AS GoodsId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId) AS tmpFrom LEFT JOIN (SELECT _tmpItem_remains.GoodsId, SUM (Amount) AS Amount FROM _tmpItem_remains GROUP BY _tmpItem_remains.GoodsId) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0))
    THEN
           -- ������ ����/���� ������� :
           outMessageText:= '' || (SELECT STRING_AGG (tmp.Value, '(+)')
                                    FROM (SELECT '(' || COALESCE (Object.ObjectCode, 0) :: TVarChar || ')' || COALESCE (Object.ValueData, '') || ' ���: ' || zfConvert_FloatToString (AmountFrom) || '/' || zfConvert_FloatToString (AmountTo) AS Value
                                          FROM (SELECT tmpFrom.GoodsId, tmpFrom.Amount AS AmountFrom, COALESCE (tmpTo.Amount, 0) AS AmountTo FROM (SELECT ObjectId AS GoodsId, SUM (OperSumm) AS Amount FROM _tmpItem GROUP BY ObjectId) AS tmpFrom LEFT JOIN (SELECT _tmpItem_remains.GoodsId, SUM (Amount) AS Amount FROM _tmpItem_remains GROUP BY _tmpItem_remains.GoodsId) AS tmpTo ON tmpTo.GoodsId = tmpFrom.GoodsId WHERE tmpFrom.Amount > COALESCE (tmpTo.Amount, 0)) AS tmp
                                               LEFT JOIN Object ON Object.Id = tmp.GoodsId
                                         ) AS tmp
                                    )
                         || '';

           -- ��������� ������
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, outMessageText);

           -- ����� ������
           IF inUserId <> 3
           THEN
               -- ������ ������ �� ������
               RETURN;
           END IF;

     END IF;


    -- !!!������ ���� ����� ����������� - ����������� �� ��������!!!
    IF EXISTS (SELECT 1 FROM _tmpItem GROUP BY ObjectId HAVING COUNT (*) > 1)
    THEN
        -- ������1 - �������� �������
        OPEN curSale FOR SELECT MovementItemId, ObjectId, OperSumm AS Amount FROM _tmpItem;
        -- ������ ����� �� �������1 - ��������
        LOOP
                -- ������ �� ��������
                FETCH curSale INTO vbMovementItemId, vbGoodsId, vbAmount;
                -- ���� ������ �����������, ����� �����
                IF NOT FOUND THEN EXIT; END IF;

                -- ������2. - ������� ����� ������� ��� ������������ ��� vbGoodsId
                OPEN curRemains FOR
                   SELECT _tmpItem_remains.ContainerId, _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0)
                   FROM _tmpItem_remains
                        LEFT JOIN (SELECT ContainerId, SUM (_tmpMIContainer_insert.Amount) AS Amount FROM _tmpMIContainer_insert GROUP BY ContainerId
                                  ) AS tmp ON tmp.ContainerId = _tmpItem_remains.ContainerId
                   WHERE _tmpItem_remains.GoodsId = vbGoodsId
                     AND _tmpItem_remains.Amount - COALESCE (tmp.Amount, 0) > 0
                   ORDER BY _tmpItem_remains.OperDate DESC, _tmpItem_remains.ContainerId DESC
                  ;
                -- ������ ����� �� �������2. - �������
                LOOP
                    -- ������ �� ��������
                    FETCH curRemains INTO vbContainerId, vbAmount_remains;
                    -- ���� ������ �����������, ��� ��� ���-�� ������� ����� �����
                    IF NOT FOUND OR vbAmount = 0 THEN EXIT; END IF;

                    --
                    IF vbAmount_remains > vbAmount
                    THEN
                        -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
                           SELECT zc_Container_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount
                                , vbOperDate;
                        -- �������� ���-�� ��� �� ������ �� ������
                        vbAmount:= 0;
                    ELSE
                        -- ���������� � �������� ������ ��� ������, !!!��������� � ����-��������� - �������� ���-��!!!
                        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
                           SELECT zc_Container_Count()
                                , zc_Movement_Check()
                                , inMovementId
                                , vbMovementItemId
                                , vbContainerId
                                , vbAccountId
                                , -1 * vbAmount_remains
                                , vbOperDate;
                        -- ��������� �� ���-�� ������� ����� � ���������� �����
                        vbAmount:= vbAmount - vbAmount_remains;
                    END IF;

                END LOOP; -- ����� ����� �� �������2. - �������
                CLOSE curRemains; -- ������� ������2. - �������

            END LOOP; -- ����� ����� �� �������1 - �������
            CLOSE curSale; -- ������� ������1 - �������

    ELSE
        -- !!!�����!!! - ��������� - �������� ���-��
        INSERT INTO _tmpMIContainer_insert (DescId, MovementDescId, MovementId, MovementItemId, ContainerId, AccountId, Amount, OperDate)
           WITH tmpContainer AS (SELECT MI_Sale.MovementItemId
                                      , MI_Sale.ObjectId        AS GoodsId
                                      , MI_Sale.OperSumm        AS SaleAmount
                                      , Container.Amount        AS ContainerAmount
                                      , Container.ContainerId
                                      , SUM (Container.Amount) OVER (PARTITION BY Container.GoodsId ORDER BY Container.OperDate, Container.ContainerId, MI_Sale.MovementItemId) AS ContainerAmountSUM
                                      , ROW_NUMBER() OVER (PARTITION BY /*MI_Sale.ObjectId*/ MI_Sale.MovementItemId ORDER BY Container.OperDate DESC, Container.ContainerId DESC, MI_Sale.MovementItemId DESC) AS DOrd
                                 FROM _tmpItem AS MI_Sale
                                      INNER JOIN _tmpItem_remains AS Container ON Container.GoodsId = MI_Sale.ObjectId
                                )
           SELECT zc_Container_Count()
                , zc_Movement_Check()
                , inMovementId
                , tmpItem.MovementItemId
                , tmpItem.ContainerId
                , vbAccountId
                , -1 * Amount
                , vbOperDate
              FROM (SELECT ContainerId
                         , MovementItemId
                         , CASE WHEN SaleAmount - ContainerAmountSUM > 0 AND DOrd <> 1
                                     THEN ContainerAmount
                                ELSE SaleAmount - ContainerAmountSUM + ContainerAmount
                           END AS Amount
                    FROM (SELECT * FROM tmpContainer) AS DD
                    WHERE SaleAmount - (ContainerAmountSUM - ContainerAmount) > 0
                   ) AS tmpItem;

    END IF;
    

--     CREATE TEMP TABLE _tmpMIContainer_insert (Id Integer, DescId Integer, MovementDescId Integer, MovementId Integer, MovementItemId Integer, ContainerId Integer, ParentId Integer
  --                                           , AccountId Integer, AnalyzerId Integer, ObjectId_Analyzer Integer, WhereObjectId_Analyzer Integer, ContainerId_Analyzer Integer
    --                                         , Amount TFloat, OperDate TDateTime, IsActive Boolean) ON COMMIT DROP;

    -- �� � �������-�� �����
 /*   INSERT INTO _tmpMIContainer_insert(AnalyzerId, DescId, MovementDescId, MovementId, MovementItemId, ContainerId, ParentId, AccountId, Amount, OperDate)
         SELECT 
                0
              , zc_Container_Summ()
              , zc_Movement_Income()  
              , inMovementId
              , _tmpItem.MovementItemId
              , lpInsertFind_Container(
                          inContainerDescId := zc_Container_Summ(), -- DescId �������
                          inParentId        := _tmpMIContainer_insert.ContainerId , -- ������� Container
                          inObjectId := _tmpItem.AccountId, -- ������ (���� ��� ����� ��� ...)
                          inJuridicalId_basis := _tmpItem.JuridicalId_Basis, -- ������� ����������� ����
                          inBusinessId := NULL, -- �������
                          inObjectCostDescId  := NULL, -- DescId ��� <������� �/�>
                          inObjectCostId       := NULL,
                          inDescId_1          := zc_ContainerLinkObject_Goods(), -- DescId ��� 1-�� ���������
                          inObjectId_1        := _tmpItem.ObjectId,
                          inDescId_2          := zc_ContainerLinkObject_Unit(), -- DescId ��� 1-�� ���������
                          inObjectId_2        := _tmpItem.UnitId) 
              , nULL
              , _tmpItem.AccountId
              ,  CASE WHEN Movement_Income_View.PriceWithVAT THEN MovementItem_Income_View.AmountSumm
                      ELSE MovementItem_Income_View.AmountSumm * (1 + Movement_Income_View.NDS/100)
                 END::NUMERIC(16, 2)     
              , _tmpItem.OperDate
           FROM _tmpItem 
                JOIN _tmpMIContainer_insert ON _tmpMIContainer_insert.MovementItemId = _tmpItem.MovementItemId
                LEFT JOIN MovementItem_Income_View ON MovementItem_Income_View.Id = _tmpItem.MovementItemId
                LEFT JOIN Movement_Income_View ON Movement_Income_View.Id = MovementItem_Income_View.MovementId;

     
     SELECT SUM(Amount) INTO vbOperSumm_Partner_byItem FROM _tmpMIContainer_insert WHERE AnalyzerId = 0;
 
     IF (vbOperSumm_Partner <> vbOperSumm_Partner_byItem) THEN
        UPDATE _tmpMIContainer_insert SET Amount = Amount - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE MovementItemId IN (SELECT MAX (MovementItemId) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0 
                      AND Amount IN (SELECT MAX (Amount) FROM _tmpMIContainer_insert WHERE AnalyzerId = 0)
                                 );
      END IF;	
   */
     PERFORM lpInsertUpdate_MovementItemContainer_byTable();
    
     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Check()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.02.14                        * 
 05.02.14                        * 
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
--    IN inMovementId        Integer  , -- ���� ���������
--    IN inUserId            Integer    -- ������������
-- SELECT * FROM lpComplete_Movement_Check (inMovementId:= 12671, inUserId:= zfCalc_UserAdmin()::Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM MovementItemContainer WHERE MovementId = 12671
