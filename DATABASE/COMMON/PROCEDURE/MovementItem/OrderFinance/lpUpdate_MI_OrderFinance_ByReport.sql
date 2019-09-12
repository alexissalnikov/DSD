-- Function: lpUpdate_MI_OrderFinance_ByReport()

DROP FUNCTION IF EXISTS lpUpdate_MI_OrderFinance_ByReport (Integer, Integer, Integer, Integer, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_OrderFinance_ByReport(
    IN inId               Integer   , -- ���� ������� <������� ���������>
    IN inMovementId       Integer   ,
    IN inJuridicalId      Integer   ,
    IN inContractId       Integer   ,
    IN inAmountRemains    TFloat    , -- 
    IN inAmountPartner    TFloat    , -- 
    IN inUserId           Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (inId, 0) = 0;

     IF COALESCE (inId, 0) = 0
     THEN 
         -- ��������� <������� ���������>
         inId := lpInsertUpdate_MovementItem (inId, zc_MI_Master(), inJuridicalId, inMovementId, 0, NULL);
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), inId, inContractId);
     END IF;

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(), inId, inAmountRemains);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), inId, inAmountPartner);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), inId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), inId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), inId, inUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), inId, CURRENT_TIMESTAMP);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- !!! ������� ����.!!!
     PERFORM lpInsert_MovementItemProtocol (inId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.07.19         *
*/

-- ����
--