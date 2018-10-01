-- Function: gpInsertUpdate_Movement_UnnamedEnterprises()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_UnnamedEnterprises (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TFloat, TVarChar, TFloat, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_UnnamedEnterprises(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inUnitId                Integer    , -- �� ���� (�������������)
    IN inClientsByBankId       Integer    , -- ���� (����������)
    IN inComment               TVarChar   , -- ����������
    IN inAmountAccount         TFloat     , -- ����� � �����
    IN inAccountNumber         TVarChar   , -- ����� �����
    IN inAmountPayment         TFloat     , -- ����� ������
    IN inDatePayment           TDateTime  , -- ���� ������
   OUT outDatePayment          TDateTime  , -- ���� ������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    vbUserId := inSession;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_UnnamedEnterprises (ioId          := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := inOperDate
                                        , inUnitId          := inUnitId
                                        , inClientsByBankId := inClientsByBankId
                                        , inComment         := inComment
                                        , inAmountAccount   := inAmountAccount
                                        , inAccountNumber   := inAccountNumber
                                        , inAmountPayment   := inAmountPayment
                                        , inDatePayment     := inDatePayment
                                        , inUserId          := vbUserId
                                        );
    IF EXISTS(SELECT 1 FROM MovementDate
              WHERE MovementId = ioId
                AND DescId = zc_MovementDate_DatePayment())
    THEN
        SELECT ValueData
        INTO outDatePayment
        FROM MovementDate
        WHERE MovementId = ioId
          AND DescId = zc_MovementDate_DatePayment();
    ELSE
        outDatePayment := Null::TDateTime;
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 30.09.18         *
*/