-- Function: lpInsertUpdate_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalService (Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalService(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inisMain              Boolean   , -- �������� ����� ������
   OUT outAmount             TFloat    , -- ***����� (�������)
   OUT outAmountToPay        TFloat    , -- ***����� � ������� (����)
   OUT outAmountCash         TFloat    , -- ***����� � ������� �� �����
   OUT outSummTransport      TFloat    , -- ***����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
   OUT outSummTransportAdd   TFloat    , -- ***����� ��������������� (�������)
   OUT outSummTransportAddLong TFloat  , -- ***����� ������������ (�������, ���� ���������������)
   OUT outSummTransportTaxi  TFloat    , -- ***����� �� ����� (�������)
   OUT outSummPhone          TFloat    , -- ***����� ���.����� (���������)
    IN inSummService         TFloat    , -- ����� ���������
    IN inSummCardRecalc      TFloat    , -- ����� �� �������� (��) ��� �������������
    IN inSummMinus           TFloat    , -- ����� ���������
    IN inSummAdd             TFloat    , -- ����� ������

    IN inSummHoliday         TFloat    , -- ����� ���������    
    IN inSummSocialIn        TFloat    , -- ����� ��� ������� (�� ��������)
    IN inSummSocialAdd       TFloat    , -- ����� ��� ������� (���. ��������)
    IN inSummChild           TFloat    , -- ����� �������� (���������)
    
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inMemberId            Integer   , -- ��� ���� (���� ��������� ��������)
    IN inPersonalServiceListId   Integer   , -- ��������� ����������
    IN inUserId              Integer     -- ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbAccessKeyId Integer;

   DECLARE vbServiceDateId Integer;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.� ��������� �� ��������� �������� <���������>.';
     END IF;
     -- ��������
     IF COALESCE (inPersonalId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <��� (���������)>.';
     END IF;
     -- ��������
     IF COALESCE (inInfoMoneyId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�� ������>.';
     END IF;
     -- ��������
     IF COALESCE (inUnitId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <�������������>.';
     END IF;
     -- ��������
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� <���������>.';
     END IF;


     -- !!!�����!!!
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey ((SELECT ObjectLink_User_Member.ObjectId
                                      FROM ObjectLink
                                           INNER JOIN ObjectLink AS ObjectLink_User_Member ON ObjectLink_User_Member.ChildObjectId = ObjectLink.ChildObjectId
                                                                                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                       WHERE ObjectLink.DescId = zc_ObjectLink_PersonalServiceList_Member()
                                         AND ObjectLink.ObjectId = (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList())
                                       LIMIT 1
                                     )
                                   , zc_Enum_Process_InsertUpdate_Movement_PersonalService()
                                    );
     -- !!!�����!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Id = inMovementId;

     -- �����
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));
     -- �����
     SELECT -- ����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)
            SUM (CASE WHEN MIContainer.MovementDescId = zc_Movement_Income() THEN MIContainer.Amount ELSE 0 END) AS SummTransport
            -- ����� ��������������� (�������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Add()     THEN MIContainer.Amount ELSE 0 END) AS SummTransportAdd
            -- ����� ������������ (�������, ���� ���������������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_AddLong() THEN MIContainer.Amount ELSE 0 END) AS SummTransportAddLong
            -- ����� �� ����� (�������)
          , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_Transport_Taxi()    THEN MIContainer.Amount ELSE 0 END) AS SummTransportTaxi
            -- ����� ���.����� (���������)
          , 0 AS SummPhone
            INTO outSummTransport, outSummTransportAdd, outSummTransportAddLong, outSummTransportTaxi, outSummPhone
     FROM ContainerLinkObject AS CLO_ServiceDate
          INNER JOIN ContainerLinkObject AS CLO_Personal
                                         ON CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Personal.DescId = zc_ContainerLinkObject_Personal()
                                        AND CLO_Personal.ObjectId = inPersonalId
          INNER JOIN ContainerLinkObject AS CLO_Position
                                         ON CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Position.DescId = zc_ContainerLinkObject_Position()
                                        AND CLO_Position.ObjectId = inPositionId
          INNER JOIN ContainerLinkObject AS CLO_Unit
                                         ON CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                        AND CLO_Unit.ObjectId = inUnitId
          INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                         ON CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                                        AND CLO_InfoMoney.ObjectId = inInfoMoneyId
          INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                         ON CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                                        AND CLO_PersonalServiceList.DescId = zc_ContainerLinkObject_PersonalServiceList()
          INNER JOIN MovementLinkObject AS MLO
                                        ON MLO.MovementId = inMovementId
                                       AND MLO.ObjectId = CLO_PersonalServiceList.ObjectId
                                       AND MLO.DescId = zc_MovementLinkObject_PersonalServiceList()
          INNER JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = CLO_Personal.ContainerId
                                                         -- AND MIContainer.MovementDescId = zc_Movement_Income()
     WHERE CLO_ServiceDate.ObjectId = vbServiceDateId
       AND CLO_ServiceDate.DescId = zc_ContainerLinkObject_ServiceDate();


     -- ������������ ����� (�������)
     outAmount:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) + COALESCE (inSummAdd, 0) + COALESCE (inSummHoliday, 0); -- - COALESCE (inSummSocialIn, 0);
     -- ������������ ����� � �������
     outAmountToPay:= COALESCE (inSummService, 0) - COALESCE (inSummMinus, 0) + COALESCE (inSummAdd, 0) + COALESCE (inSummSocialAdd, 0) + COALESCE (inSummHoliday, 0)
                    - COALESCE (outSummTransport, 0) + COALESCE (outSummTransportAdd, 0) + COALESCE (outSummTransportAddLong, 0) + COALESCE (outSummTransportTaxi, 0)
                    - COALESCE (outSummPhone, 0)
                     ;
     -- ������������ ����� � ������� �� �����
     outAmountCash:= outAmountToPay - COALESCE (inSummChild, 0); -- - COALESCE (inSummCard, 0) 

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, outAmount, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummToPay(), ioId, outAmountToPay);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummService(), ioId, inSummService);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummCardRecalc(), ioId, inSummCardRecalc);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMinus(), ioId, inSummMinus);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummAdd (), ioId, inSummAdd );
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummHoliday (), ioId, inSummHoliday );
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialIn(), ioId, inSummSocialIn);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummSocialAdd(), ioId, inSummSocialAdd);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Main(), ioId, inisMain);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChild(), ioId, inSummChild);

     -- ��������� �������� <����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransport(), ioId, COALESCE (outSummTransport, 0));
     -- ��������� �������� <����� ��������������� (�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAdd(), ioId, COALESCE (outSummTransportAdd, 0));
     -- ��������� �������� <����� ������������ (�������, ���� ���������������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportAddLong(), ioId, COALESCE (outSummTransportAddLong, 0));
     -- ��������� �������� <����� �� ����� (�������)>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummTransportTaxi(), ioId, COALESCE (outSummTransportTaxi, 0));
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPhone(), ioId, COALESCE (outSummPhone, 0));

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_InfoMoney(), ioId, inInfoMoneyId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Member(), ioId, inMemberId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.04.16         * inSummHoliday
 07.05.15         * add PersonalServiceList
 02.10.14                                        * del inSummCard
 01.10.14         * add redmine 30.09
 14.09.14                                        * add out...
 11.09.14         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItem_PersonalService (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
