-- Function: gpUpdate_Status_ReturnIn()

DROP FUNCTION IF EXISTS gpUpdate_Status_ReturnIn (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ReturnIn(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ReturnIn (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_ReturnIn (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ReturnIn (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.01.19         *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_ReturnIn (ioId:= 0, inSession:= zfCalc_UserAdmin())