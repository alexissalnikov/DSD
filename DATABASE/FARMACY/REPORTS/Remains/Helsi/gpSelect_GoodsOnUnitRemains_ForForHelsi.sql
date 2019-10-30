-- Function: gpSelect_GoodsOnUnitRemains_ForForHelsi

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnitRemains_ForForHelsi (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnitRemains_ForForHelsi(
    IN inUnitId  Integer,  -- Подразделение
    IN inSession TVarChar  -- сессия пользователя
)
RETURNS TABLE (UnitCode   Integer
             , GoodsCode  Integer
             , Amount     TFloat
             , Price      TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    RETURN QUERY
    WITH
     tmpContainer AS
                   (SELECT Container.ObjectId
                         , Container.Id
                         , Container.Amount
                    FROM
                        Container
                    WHERE Container.DescId        = zc_Container_Count()
                      AND Container.WhereObjectId = inUnitId
                      AND Container.Amount        <> 0
                   )
   , Remains AS (SELECT Container.ObjectId
                      , SUM (Container.Amount)  AS Amount
                 FROM tmpContainer AS Container
                      LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotUploadSites
                                              ON ObjectBoolean_isNotUploadSites.ObjectId = Container.ObjectId
                                             AND ObjectBoolean_isNotUploadSites.DescId   = zc_ObjectBoolean_Goods_isNotUploadSites()

                 WHERE COALESCE (ObjectBoolean_isNotUploadSites.ValueData, FALSE) = FALSE
                 GROUP BY Container.ObjectId
                 HAVING SUM (Container.Amount) > 0
                 )

   -- выбираем отложенные Чеки (как в кассе колонка VIP)
   , tmpMovementChek AS (SELECT Movement.Id
                         FROM MovementBoolean AS MovementBoolean_Deferred
                              INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                         WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                           AND MovementBoolean_Deferred.ValueData = TRUE
                        UNION
                         SELECT Movement.Id
                         FROM MovementString AS MovementString_CommentError
                              INNER JOIN Movement ON Movement.Id     = MovementString_CommentError.MovementId
                                                 AND Movement.DescId = zc_Movement_Check()
                                                 AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND MovementLinkObject_Unit.ObjectId = inUnitId
                        WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                          AND MovementString_CommentError.ValueData <> ''
                        )
       , tmpReserve AS (SELECT MovementItem.ObjectId             AS GoodsId
                         , SUM (MovementItem.Amount)::TFloat AS ReserveAmount
                    FROM tmpMovementChek
                         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovementChek.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                    GROUP BY MovementItem.ObjectId
                    )
      ,  tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId          AS Id
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                           )

      , tmpPrice_View AS (SELECT tmpPrice.GoodsId
                               , ROUND(Price_Value.ValueData,2)::TFloat AS Price
                          FROM tmpPrice
                               LEFT JOIN ObjectFloat AS Price_Value
                                                     ON Price_Value.ObjectId = tmpPrice.Id
                                                    AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                          )

    SELECT Object_Unit.ObjectCode                                                   AS UnitCode
         ,  Object_Goods.ObjectCode                                                 AS GoodsCode
         , (Remains.Amount - coalesce(Reserve_Goods.ReserveAmount, 0))::TFloat      AS Amount
         , Object_Price.Price                                                       AS Price

    FROM Remains

         INNER JOIN Object AS Object_Goods ON Object_Goods.Id = Remains.ObjectId

         LEFT OUTER JOIN tmpPrice_View AS Object_Price ON Object_Price.GoodsId = Remains.ObjectId

         LEFT OUTER JOIN tmpReserve AS Reserve_Goods ON Reserve_Goods.GoodsId = Remains.ObjectId

         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = inUnitId
    WHERE (Remains.Amount - COALESCE (Reserve_Goods.ReserveAmount, 0)) > 0
    ORDER BY Object_Goods.ID;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnitRemains_ForForHelsi (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.10.19                                                                                      *
*/

-- тест
--
SELECT * FROM gpSelect_GoodsOnUnitRemains_ForForHelsi (inUnitId := 183292, inSession:= '3');
