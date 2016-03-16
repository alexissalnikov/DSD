-- Function: lpInsertUpdate_Movement_QualityNumber (Integer, Integer, Integer, TDateTime, TDateTime, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_QualityNumber (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_QualityNumber(
 INOUT ioId                         Integer   , -- ���� ������� <��������>
    IN inInvNumber                  TVarChar  , -- ����� ���������
    IN inOperDate                   TDateTime , -- ���� ���������
    IN inQualityNumber              TVarChar  , --
    IN inCertificateNumber          TVarChar  , --
    IN inOperDateCertificate        TDateTime , --
    IN inCertificateSeries          TVarChar  , --
    IN inCertificateSeriesNumber    TVarChar  , --
    IN inUserId                     Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
   
     -- 1. ����������� ��������
     IF ioId > 0
     THEN
         PERFORM lpUnComplete_Movement (inMovementId := ioId
                                      , inUserId     := inUserId);
     END IF;


      -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_QualityNumber(), inInvNumber, inOperDate, NULL, vbAccessKeyId
                                     );

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateCertificate(), ioId, inOperDateCertificate);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateNumber(), ioId, inCertificateNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeries(), ioId, inCertificateSeries);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CertificateSeriesNumber(), ioId, inCertificateSeriesNumber);
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_QualityNumber(), ioId, inQualityNumber);


     -- �������� �������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := ioId
                                , inDescId     := zc_Movement_QualityNumber()
                                , inUserId     := inUserId
                                 );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.03.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Movement_QualityNumber (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
