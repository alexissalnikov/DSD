-- Function: gpInsertUpdate_MovementItem_GoodsAccount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_GoodsAccount (Integer, Integer, Integer, Integer, Boolean, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_GoodsAccount(
 INOUT ioId                     Integer   , -- ���� ������� <������� ���������>
    IN inMovementId             Integer   , -- ���� ������� <��������>
    IN inPartionId              Integer   , -- ������
    IN inSaleMI_Id              Integer   , -- ������ �������� �������/�������
   OUT outLineNum               Integer   , -- � �.�. 
   OUT outIsLine                TVarChar  , -- � �.�.    
    IN inIsPay                  Boolean   , -- �������� � �������
    IN inAmount                 TFloat    , -- ����������
   OUT outTotalPay              TFloat    , --
    IN inComment                TVarChar  , -- ����������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPartionMI_Id Integer;
   DECLARE vbGoodsId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_GoodsAccount());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������� ������ �������� �������/��������
     vbPartionMI_Id := lpInsertFind_Object_PartionMI (inSaleMI_Id);


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inSaleMI_Id, 0) = 0 AND  vbUserId <> zc_User_Sybase() THEN
        RAISE EXCEPTION '������.�� ��������� ������� �������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF inAmount < 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���-��>.';
     END IF;
     -- �������� - ���������� vbPartionMI_Id
     IF EXISTS (SELECT 1 FROM MovementItem AS MI INNER JOIN MovementItemLinkObject AS MILO ON MILO.MovementItemId = MI.Id AND MILO.DescId = zc_MILinkObject_PartionMI() AND MILO.ObjectId = vbPartionMI_Id WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION '������.� ��������� ��� ���� ����� <% %> �.<%>.������������ ���������.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


     -- ������ �� ������ : GoodsId
     vbGoodsId:= (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);


     -- ���������
     ioId:= lpInsertUpdate_MovementItem_GoodsAccount (ioId                 := ioId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := vbGoodsId
                                                    , inPartionId          := COALESCE (inPartionId, 0)
                                                    , inPartionMI_Id       := COALESCE (vbPartionMI_Id, 0)
                                                    , inAmount             := inAmount
                                                    , inComment            := COALESCE (inComment,'') :: TVarChar
                                                    , inUserId             := vbUserId
                                                     );

     -- ��������� ����� ������ ��� �����
     IF inIsPay = TRUE THEN
         -- ��������� ������
        /*     PERFORM lpInsertUpdate_MI_GoodsAccount_Child  (ioId             := COALESCE (_tmpMI.Id,0)
                                                      , inMovementId         := inMovementId
                                                      , inParentId           := inParentId
                                                      , inCashId             := COALESCE (_tmpCash.CashId, _tmpMI.CashId)
                                                      , inCurrencyId         := COALESCE (_tmpCash.CurrencyId, _tmpMI.CurrencyId)
                                                      , inCashId_Exc         := Null
                                                      , inAmount             := COALESCE (_tmpCash.Amount,0)
                                                      , inCurrencyValue      := COALESCE (_tmpCash.CurrencyValue,1)
                                                      , inParValue           := COALESCE (_tmpCash.ParValue,0)
                                                      , inUserId             := vbUserId
                                                       )
              FROM _tmpCash
 */

         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     ELSE
         outTotalPay := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()), 0);
     END IF;


    -- � �.�. ������
    SELECT CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN tmp.LineNum ELSE NULL END :: Integer  AS LineNum
         , CASE WHEN tmp.isErased = FALSE AND tmp.Amount > 0 THEN '*'         ELSE '_'  END :: TVarChar AS isLine
           INTO outLineNum, outIsLine
    FROM (SELECT MI_Master.Id
               , ROW_NUMBER() OVER (ORDER BY CASE WHEN MI_Master.isErased = FALSE AND MI_Master.Amount > 0 THEN 0 ELSE 1 END ASC, MI_Master.Id ASC) AS LineNum
               , MI_Master.Amount
               , MI_Master.isErased
          FROM MovementItem AS MI_Master
          WHERE MI_Master.MovementId = inMovementId
            AND MI_Master.DescId     = zc_MI_Master()
         ) AS tmp
    WHERE tmp.Id = ioId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.03.18         *
 18.05.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_GoodsAccount (ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');
