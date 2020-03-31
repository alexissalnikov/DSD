-- Function: lpGet_MovementItem_WagesAE_TotalSum()

DROP FUNCTION IF EXISTS lpGet_MovementItem_WagesAE_TotalSum(Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_WagesAE_TotalSum(
    IN inMovementItemId      Integer   , -- ���� ������� <������� ���������>
    IN inUserId              Integer     -- ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbSumma1    TFloat;
   DECLARE vbSumma2    TFloat;
   DECLARE vbOperDate TDateTime;
BEGIN

    -- �������� ����������
    IF COALESCE (inMovementItemId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �������������� ������� �� ���������.';
    END IF;

    -- �������� ����������
    IF NOT EXISTS(SELECT 1
                  FROM MovementItem
                       INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                                          AND Movement.DescId = zc_Movement_Wages()
                  WHERE MovementItem.ID = inMovementItemId
                    AND MovementItem.DescId = zc_MI_Sign())
    THEN
        RAISE EXCEPTION '������. �������� �� ������.';
    END IF;

    SELECT Movement.OperDate
    INTO vbOperDate
    FROM MovementItem
         INNER JOIN Movement ON Movement.ID = MovementItem.MovementID
                            AND Movement.DescId = zc_Movement_Wages()
    WHERE MovementItem.ID = inMovementItemId
      AND MovementItem.DescId = zc_MI_Sign();

    vbSumma1 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                          FROM MovementItemFloat AS MIFloat_SummaSUN1
                          WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                            AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaCleaning(), zc_MIFloat_SummaSP(), zc_MIFloat_SummaOther(),
                                                             zc_MIFloat_ValidationResults(), zc_MIFloat_SummaSUN1())), 0);

    IF vbOperDate >= '01.05.2020'
    THEN
      vbSumma2 := COALESCE((SELECT SUM(MIFloat_SummaSUN1.ValueData)
                            FROM MovementItemFloat AS MIFloat_SummaSUN1
                            WHERE MIFloat_SummaSUN1.MovementItemId = inMovementItemId
                              AND MIFloat_SummaSUN1.DescId in (zc_MIFloat_SummaTechnicalRediscount(), zc_MIFloat_SummaFullCharge())));

    ELSE
      vbSumma2 := 0;
    END IF;

    -- ���������
    RETURN vbSumma1 + vbSumma2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.02.20                                                        *
*/

-- ����
-- SELECT * FROM lpGet_MovementItem_WagesAE_TotalSum (inMovementItemId := 323828220, inUserId := 3)
