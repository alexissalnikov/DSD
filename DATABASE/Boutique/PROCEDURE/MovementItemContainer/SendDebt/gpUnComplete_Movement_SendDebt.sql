-- Function: gpUnComplete_Movement_SendDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SendDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SendDebt(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_SendDebt());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.01.14         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_SendDebt (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
