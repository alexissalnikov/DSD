-- Function: gpInsertUpdate_MovementItem_IncomeAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_IncomeAsset (Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_IncomeAsset(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inAssetId             Integer   , -- ��� ��
 INOUT ioAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inMIId_Invoice        TFloat    , -- ������� ��������� C���
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
 INOUT ioInvNumber_Asset      TVarChar  , -- 
 INOUT ioInvNumber_Asset_save TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_IncomeAsset());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_IncomeAsset (ioId                 := ioId
                                                   , inMovementId         := inMovementId
                                                   , inGoodsId            := inGoodsId
                                                   , inUnitId             := inUnitId
                                                   , inAssetId            := inAssetId
                                                   , inAmount             := ioAmount
                                                   , inPrice              := inPrice
                                                   , inCountForPrice      := ioCountForPrice
                                                   , inMIId_Invoice       := inMIId_Invoice
                                                   , inUserId             := vbUserId
                                                    );


     -- ��������� �������� ����������� <�������� ��������>
     IF ioInvNumber_Asset <> ioInvNumber_Asset_save AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         -- �������� ������������ ��� �������� <����������� �����> 
         PERFORM lpCheckUnique_ObjectString_ValueData (inGoodsId, zc_ObjectString_Asset_InvNumber(), ioInvNumber_Asset);
         -- ���������
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Asset_InvNumber(), inGoodsId, ioInvNumber_Asset);
         -- ��������� ��������
         PERFORM lpInsert_ObjectProtocol (inGoodsId, vbUserId);
     ELSEIF NOT EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Asset())
     THEN
         ioInvNumber_Asset:= '';
     END IF;
     -- ��������������
     ioInvNumber_Asset_save:= ioInvNumber_Asset;


     -- ��������� ����� �� ��������, ��� �����
     outAmountSumm := CASE WHEN ioCountForPrice > 0
                                THEN CAST (ioAmount * inPrice / ioCountForPrice AS NUMERIC (16, 2))
                           ELSE CAST (ioAmount * inPrice AS NUMERIC (16, 2))
                      END;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.08.16         * add AssetId
 06.08.16         *
 29.07.16         *
*/

-- ����
-- 