-- Function: gpSetErased_Movement_byReport (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_byReport(
    IN inMovementId   Integer    , -- ���� ������� <��������>
   OUT outStatusCode  Integer    , --
    IN inSession      TVarChar     -- ������� ������������
)                              
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbDescId   Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������� ��������� ���������
     SELECT Movement.DescId, Movement.OperDate INTO vbDescId, vbOperDate FROM Movement WHERE Movement.Id = inMovementId;
     

     -- �������� - ���� ���������
     PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= vbOperDate, inUserId:= vbUserId);


     -- �������
     PERFORM CASE WHEN vbDescId = zc_Movement_Sale()         THEN gpSetErased_Movement_Sale         (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_ReturnIn()     THEN gpSetErased_Movement_ReturnIn     (inMovementId, inSession)
                  WHEN vbDescId = zc_Movement_GoodsAccount() THEN gpSetErased_Movement_GoodsAccount (inMovementId, inSession)
             END;
     
     -- �������
     outStatusCode := (SELECT Object_Status.ObjectCode  AS StatusCode
                       FROM Movement 
                            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                       WHERE Movement.Id = inMovementId
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.01.18         *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_byReport (inMovementId:= 55, inSession:= '2')
