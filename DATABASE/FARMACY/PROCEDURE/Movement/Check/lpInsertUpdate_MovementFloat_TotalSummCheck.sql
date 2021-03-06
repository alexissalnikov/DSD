-- Function: lpInsertUpdate_MovementFloat_TotalSummCheck (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSummCheck (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbTotalCountCheck TFloat;
  DECLARE vbTotalSummCheck TFloat;
  DECLARE vbTotalSummChangePercent TFloat;
  DECLARE vbRoundingTo10 Boolean;
  DECLARE vbRoundingDown Boolean;
BEGIN
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    vbRoundingTo10 := False;
    vbRoundingDown := False;

    SELECT
      MB_RoundingTo10.ValueData
    INTO
      vbRoundingTo10
    FROM MovementBoolean AS MB_RoundingTo10
    WHERE MB_RoundingTo10.MovementId = inMovementId
      AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10();

    SELECT
      MB_RoundingDown.ValueData
    INTO
      vbRoundingDown
    FROM MovementBoolean AS MB_RoundingDown
    WHERE MB_RoundingDown.MovementId = inMovementId
      AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown();

    SELECT SUM(COALESCE(MovementItem.Amount,0)),
           CASE WHEN COALESCE (vbRoundingDown, False) = True
             THEN SUM(TRUNC(COALESCE (MovementItem.Amount, 0) * COALESCE(MovementItemFloat_Price.ValueData,0), 1)::NUMERIC (16, 2))
             ELSE CASE WHEN COALESCE (vbRoundingTo10, False) = True
             THEN SUM(((COALESCE(MovementItem.Amount,0)*COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 1))::NUMERIC (16, 2))
             ELSE SUM((COALESCE(MovementItem.Amount,0)*COALESCE(MovementItemFloat_Price.ValueData,0))::NUMERIC (16, 2)) END END,
           SUM(COALESCE(MIFloat_SummChangePercent.ValueData,0)::NUMERIC (16, 4))
    INTO
        vbTotalCountCheck,
        vbTotalSummCheck,
        vbTotalSummChangePercent
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price()
        LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                    ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                   AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
    WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master() AND MovementItem.isErased = false;


    -- Сохранили свойство <Итого количество>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCountCheck);
    -- Сохранили свойство <Итого Сумма>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSummCheck);
    -- Сохранили свойство <Итого Сумма скидки>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChangePercent(), inMovementId, vbTotalSummChangePercent);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSummCheck (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.   Шаблий О.В.
 06.06.19                                                                       *
 02.04.19                                                                       *
 11.04.17         *
 20.07.15                                                         *
*/
