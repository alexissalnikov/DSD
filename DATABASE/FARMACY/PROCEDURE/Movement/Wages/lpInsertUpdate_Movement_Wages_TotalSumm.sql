-- Function: lpInsertUpdate_Movement_Wages_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Wages_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Wages_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
BEGIN

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
    END IF;

    UPDATE MovementItem set Amount = T1.Amount
    FROM (SELECT MovementItem.ParentID
               , SUM(MovementItem.Amount) AS Amount
          FROM MovementItem
          WHERE MovementItem.MovementId = inMovementId 
            AND MovementItem.DescId = zc_MI_Child() 
            AND MovementItem.isErased = False
          GROUP BY MovementItem.ParentID) AS T1
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE
      AND MovementItem.ID = T1.ParentID;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Movement_Wages_TotalSumm (Integer) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.19                                                        *
*/

-- SELECT * FROM lpInsertUpdate_Movement_Wages_TotalSumm (15414488)
