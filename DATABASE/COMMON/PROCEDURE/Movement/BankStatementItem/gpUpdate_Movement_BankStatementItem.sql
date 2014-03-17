-- Function: gpInsertUpdate_Movement_BankStatementItem()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem(Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inJuridicalId         Integer   , -- ��� 
    IN inInfoMoneyId         Integer   , -- �������������� ������ 
    IN inContractId          Integer   , -- �������  
    IN inUnitId              Integer   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankStatementItem());

      
     IF inJuridicalId = 0 THEN
        inJuridicalId := NULL;
     END IF; 
     IF inInfoMoneyId = 0 THEN
        inInfoMoneyId := NULL;
     END IF; 
     IF inContractId = 0 THEN
        inContractId := NULL;
     END IF; 
     IF inUnitId = 0 THEN
        inUnitId := NULL;
     END IF; 

     -- �������� ��������� ��������
     IF NOT EXISTS (SELECT InfoMoneyId FROM Object_InfoMoney_View WHERE InfoMoneyId = inInfoMoneyId AND InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21500() -- ���������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40100() -- ������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40200() -- ������ �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40300() -- ���������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40400() -- �������� �� ��������
                                                                                                                                 -- , zc_Enum_InfoMoneyDestination_40500() -- �����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40600() -- ��������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40700() -- ����
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40800() -- ���������� ������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_40900() -- ���������� ������

                                                                                                                                 , zc_Enum_InfoMoneyDestination_50100() -- ��������� ������� �� ��
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50200() -- ��������� �������
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50300() -- ��������� ������� (������)
                                                                                                                                 , zc_Enum_InfoMoneyDestination_50400() -- ������ � ������
                                                                                                                                 ))
        -- AND EXISTS (SELECT Id FROM gpGet_Movement_BankStatementItem (inMovementId:= ioId, inSession:= inSession) WHERE ContractId = inContractId)
        AND NOT EXISTS (SELECT ContractId FROM Object_Contract_View WHERE ContractId = inContractId AND InfoMoneyId = inInfoMoneyId)
        AND inContractId > 0
     THEN
         RAISE EXCEPTION '������.�������� �������� ��� <�� ������ ����������>.';
     END IF;


     -- ��������� ����� � <��. ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, inJuridicalId);
     -- ��������� ����� � <�������������� ������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);     
     -- ��������� ����� � <�������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.03.14                                        * add �������� ��������� ��������
 03.12.13                        *
 13.08.13          *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_BankStatementItem (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFileName:= 'xxx', inBankAccountId:= 1, inSession:= '2')
