-- Function: lpComplete_Movement_ReturnIn_CreateTemp ()

DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn_CreateTemp ();

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn_CreateTemp()
RETURNS VOID
AS
$BODY$
BEGIN
     -- ������� - ��������
     PERFORM lpComplete_Movement_All_CreateTemp();

     -- ������� - �������� ������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpPay (MovementItemId Integer, ParentId Integer
                              , ObjectId Integer, ObjectDescId Integer, CurrencyId Integer
                              , AccountId Integer, ContainerId Integer, ContainerId_Currency Integer
                              , OperSumm TFloat, OperSumm_Currency TFloat
                              , ObjectId_from Integer
                              , AccountId_from Integer, ContainerId_from Integer
                              , OperSumm_from TFloat
                               ) ON COMMIT DROP;

     -- ������� - �������� �� ����������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem_SummClient (MovementItemId Integer, ContainerId_Summ Integer, ContainerId_Summ_20102 Integer, ContainerId_Goods Integer, AccountId Integer, AccountId_20102 Integer
                                          , InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                          , GoodsId Integer, PartionId Integer, GoodsSizeId Integer, PartionId_MI Integer
                                          , OperCount TFloat, OperSumm TFloat, OperSumm_ToPay TFloat, TotalPay TFloat
                                          , OperCount_sale TFloat, OperSumm_sale TFloat, OperSummPriceList_sale TFloat
                                          , ContainerId_ProfitLoss_10501 TFloat, ContainerId_ProfitLoss_10601 TFloat
                                           ) ON COMMIT DROP;

     -- ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer
                               , ContainerId_Summ Integer, ContainerId_Goods Integer
                               , GoodsId Integer, PartionId Integer, PartionId_MI, GoodsSizeId Integer
                               , OperCount TFloat, OperPrice TFloat, CountForPrice TFloat, OperSumm TFloat, OperSumm_Currency TFloat
                               , OperSumm_ToPay TFloat, OperSummPriceList TFloat, TotalChangePercent TFloat, TotalPay TFloat, TotalToPay TFloat
                               , AccountId Integer, InfoMoneyGroupId Integer, InfoMoneyDestinationId Integer, InfoMoneyId Integer
                                ) ON COMMIT DROP;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.06.17                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_ReturnIn_CreateTemp ()
