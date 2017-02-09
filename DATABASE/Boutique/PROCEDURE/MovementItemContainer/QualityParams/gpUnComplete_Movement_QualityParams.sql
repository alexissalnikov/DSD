-- Function: gpUnComplete_Movement_QualityParams (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_QualityParams (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_QualityParams(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_QualityParams());

     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.05.15                                        *
 09.02.15                                                        *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_QualityParams (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
