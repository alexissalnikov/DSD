-- Function: gpSetErased_Movement_ReturnIn (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ReturnIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ReturnIn());
    vbUserId:= lpGetUserBySession (inSession);


    -- ���.������ ���������
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
     -- �������� - ���� - ��� User - �������
     IF lpCheckUnitByUser((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To()), inSession);
        AND (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId) < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR')
     THEN
         RAISE EXCEPTION '������.��������� ������ �������� ������ � <%>', zfConvert_DateToString (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '14 HOUR'));
     END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- ����������� "��������" ����� �� ��������� ������ ������� / ��������
    PERFORM lpUpdate_MI_Partion_Total_byMovement (inMovementId);

    -- ���� ��� ������ ��������
    IF vbStatusId = zc_Enum_Status_Complete() 
    THEN 
         -- �������� �������� ����� �� ����������
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 23.07.17         *
 14.05.17         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_ReturnIn (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
