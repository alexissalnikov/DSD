-- Function: gpReport_IlliquidReductionPlanAll()

DROP FUNCTION IF EXISTS gpReport_IlliquidReductionPlanAll (TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IlliquidReductionPlanAll(
    IN inStartDate      TDateTime , -- Дата в месяце
    IN inProcGoods      TFloat ,    -- % продажи для вып.
    IN inProcUnit       TFloat ,    -- % вып. по аптеке.
    IN inPenalty        TFloat ,    -- Штраф за 1% невыполнения
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId           Integer   --
             , UserCode         Integer   --
             , UserName         TVarChar  --
             , UnitName         TVarChar  --
             , AmountAll        Integer   -- Товаров без продаж
             , AmountStart      Integer   -- Без продаж  на начало
             , AmountSale       Integer   -- Продано
             , ProcSale         TFloat    -- % продаж
             , SummaPenalty     TFloat    -- Сумма штрафа
             , Color_Calc       Integer   --
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');

--raise notice 'Value 01: %', timeofday();

    IF NOT EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                  WHERE Movement.OperDate >= vbDateStart
                    AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                    AND Movement.DescId = zc_Movement_IlliquidUnit()
                    AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
       RAISE EXCEPTION 'Зафиксированные неликвиды по подразделениям не найдены.';
    END IF;

      -- Мовементы по сотрудникам
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            UnitID             Integer,
            UserID             Integer

      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    WITH tmpMovementAll AS (SELECT Movement.ID
                            FROM Movement
                            WHERE Movement.OperDate >= vbDateStart
                              AND Movement.OperDate < vbDateEnd
                              AND Movement.DescId = zc_Movement_Check()
                              AND Movement.StatusId = zc_Enum_Status_Complete()),
         tmpMovement AS (SELECT
                                Movement.ID                                                                                 AS ID
                              , MovementLinkObject_Unit.ObjectId                                                            AS UnitId
                              , COALESCE(MovementLinkObject_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId) AS UserID
                         FROM tmpMovementAll AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                             ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                                LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                                             ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                                            AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()),
         tmpUser AS (SELECT ObjectLink_User_Member.ObjectId AS UserID
                     FROM ObjectLink AS ObjectLink_User_Member

                          INNER JOIN  ObjectLink AS ObjectLink_Member_Position
                                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                                AND ObjectLink_Member_Position.ChildObjectId = 1672498
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()),
         tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitID
                     FROM ObjectLink AS ObjectLink_Juridical_Retail

                          INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                ON ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                               AND ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId

                     WHERE ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                       AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                       AND ObjectLink_Juridical_Retail.ChildObjectId = 4)

    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , Movement.UnitId                                  AS UnitId
         , Movement.UserID                                  AS UserID
    FROM tmpMovement AS Movement

          INNER JOIN tmpUnit ON tmpUnit.UnitID = Movement.UnitId

          INNER JOIN tmpUser ON tmpUser.UserID = Movement.UserID;

    ANALYSE tmpMovement;

--raise notice 'Value 03: %', timeofday();

      -- Подразделение + сотрудники
    CREATE TEMP TABLE tmpUnitUser (
            UnitID         Integer,
            UserID         TFloat
      ) ON COMMIT DROP;

    WITH tmpCount AS (SELECT tmpMovement.UnitId
                           , tmpMovement.UserId
                           , count(*) AS CountCheck
                      FROM tmpMovement
                      GROUP BY tmpMovement.UnitId, tmpMovement.UserId)
       , tmpCountOrd AS (SELECT tmpCount.UnitId
                              , tmpCount.UserId
                              , ROW_NUMBER() OVER (PARTITION BY tmpCount.UserId ORDER BY tmpCount.CountCheck DESC) AS Ord
                         FROM tmpCount)

    INSERT INTO tmpUnitUser
    SELECT tmpCountOrd.UnitId
         , tmpCountOrd.UserId
    FROM tmpCountOrd
    WHERE tmpCountOrd.Ord = 1;

--raise notice 'Value 04: %', timeofday();

      -- Товары без продаж
    CREATE TEMP TABLE tmpGoods (
            UnitID         Integer,
            GoodsID         Integer,
            Remains         TFloat,
            RemainsOut      TFloat
      ) ON COMMIT DROP;


    -- Заполняем остаток на конец периода
    IF vbDateEnd > CURRENT_DATE
    THEN
      WITH
           tmpGoods AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitID
                             , MovementItem.ObjectId            AS GoodsID
                             , MovementItem.Amount              AS Amount
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                          AND Movement.DescId = zc_Movement_IlliquidUnit()
                          AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpUnit AS (SELECT DISTINCT tmpGoods.UnitID
                        FROM tmpGoods)
         , tmpContainer AS (SELECT Container.WhereObjectId   AS UnitID
                                 , Container.ObjectId        AS GoodsID
                                 , SUM(Container.Amount)     AS Saldo
                            FROM Container
                                 INNER JOIN tmpUnit ON tmpUnit.UnitID = Container.WhereObjectId
/*                                 INNER JOIN tmpGoods ON tmpGoods.UnitID = Container.WhereObjectId
                                                    AND tmpGoods.GoodsID = Container.ObjectId
*/                            WHERE Container.Amount <> 0
                            GROUP BY Container.WhereObjectId, Container.ObjectId
                           )
         , tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId                AS UnitID
                             , Movement.ID                                        AS ID
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                             INNER JOIN tmpUnit ON tmpUnit.UnitID = MovementLinkObject_Unit.ObjectId

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateEnd
                          AND Movement.DescId = zc_Movement_Check()
                          AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpCheck AS (SELECT Movement.UnitId                                    AS UnitID
                             , MovementItem.ObjectID                              AS GoodsID
                             , SUM(MovementItem.Amount)                           AS Amount
                        FROM tmpMovement AS Movement

                             INNER JOIN MovementItem AS MovementItem
                                                     ON MovementItem.MovementId = Movement.ID
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.DescId     = zc_MI_Master()

                        GROUP BY Movement.UnitId, MovementItem.ObjectID)
         , tmpRemains AS (SELECT Container.UnitID
                               , Container.GoodsID
                               , Container.Saldo                                  AS SaldoOut
                               , COALESCE(tmpCheck.Amount, 0)                     AS CheckAmount
                          FROM tmpContainer AS Container
                               LEFT JOIN tmpCheck AS tmpCheck
                                                  ON tmpCheck.UnitID = Container.UnitID
                                                 AND tmpCheck.GoodsID = Container.GoodsID)


      INSERT INTO tmpGoods (UnitID, GoodsID, Remains, RemainsOut)
      SELECT
             tmpGoods.UnitID               AS UnitID
           , tmpGoods.GoodsID              AS Goods
           , tmpGoods.Amount               AS SaldoOut
           , CASE WHEN CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END <= 0
             THEN 0
             ELSE CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END END
      FROM tmpGoods
           LEFT JOIN tmpRemains AS Container
                                ON tmpGoods.GoodsId = Container.GoodsId
                               AND tmpGoods.UnitID = Container.UnitID;
    ELSE
      WITH
           tmpGoods AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitID
                             , MovementItem.ObjectId            AS GoodsID
                             , MovementItem.Amount              AS Amount
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateStart + INTERVAL '1 MONTH'
                          AND Movement.DescId = zc_Movement_IlliquidUnit()
                          AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpUnit AS (SELECT DISTINCT tmpGoods.UnitID
                        FROM tmpGoods)
         , tmpContainer AS (SELECT AnalysisContainer.UnitID         AS UnitID
                                 , AnalysisContainer.GoodsID        AS GoodsID
                                 , SUM(AnalysisContainer.Saldo)     AS Saldo
                            FROM AnalysisContainer
                                 INNER JOIN tmpUnit ON tmpUnit.UnitID = AnalysisContainer.UnitID
                                 INNER JOIN tmpGoods ON tmpGoods.UnitID = AnalysisContainer.UnitID
                                                    AND tmpGoods.GoodsID = AnalysisContainer.GoodsID
                            GROUP BY AnalysisContainer.UnitID, AnalysisContainer.GoodsID
                           )
         , tmpMovementItemContainer AS (SELECT AnalysisContainerItem.UnitID                                 AS UnitID
                                             , AnalysisContainerItem.GoodsID                                AS GoodsID
                                             , SUM(AnalysisContainerItem.Saldo)                             AS Saldo
                                        FROM AnalysisContainerItem
                                             INNER JOIN tmpUnit ON tmpUnit.UnitID = AnalysisContainerItem.UnitID
                                             INNER JOIN tmpGoods ON tmpGoods.UnitID = AnalysisContainerItem.UnitID
                                                                AND tmpGoods.GoodsID = AnalysisContainerItem.GoodsID
                                        WHERE AnalysisContainerItem.OperDate >= vbDateEnd
                                        GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsID)
         , tmpMovement AS (SELECT MovementLinkObject_Unit.ObjectId                AS UnitID
                             , Movement.ID                                        AS ID
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                             INNER JOIN tmpUnit ON tmpUnit.UnitID = MovementLinkObject_Unit.ObjectId

                        WHERE Movement.OperDate >= vbDateStart
                          AND Movement.OperDate < vbDateEnd
                          AND Movement.DescId = zc_Movement_Check()
                          AND Movement.StatusId = zc_Enum_Status_Complete())
         , tmpCheck AS (SELECT Movement.UnitId                                    AS UnitID
                             , MovementItem.ObjectID                              AS GoodsID
                             , SUM(MovementItem.Amount)                           AS Amount
                        FROM tmpMovement AS Movement

                             INNER JOIN MovementItem AS MovementItem
                                                     ON MovementItem.MovementId = Movement.ID
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.DescId     = zc_MI_Master()

                        GROUP BY Movement.UnitId, MovementItem.ObjectID)
         , tmpRemains AS (SELECT Container.UnitID
                               , Container.GoodsID
                               , Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0) AS SaldoOut
                               , COALESCE(tmpCheck.Amount, 0)                               AS CheckAmount
                          FROM tmpContainer AS Container
                               LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                  ON MovementItemContainer.UnitID = Container.UnitID
                                                                 AND MovementItemContainer.GoodsID = Container.GoodsID
                               LEFT JOIN tmpCheck AS tmpCheck
                                                  ON tmpCheck.UnitID = Container.UnitID
                                                 AND tmpCheck.GoodsID = Container.GoodsID)


      INSERT INTO tmpGoods (UnitID, GoodsID, Remains, RemainsOut)
      SELECT
             tmpGoods.UnitID               AS UnitID
           , tmpGoods.GoodsID              AS Goods
           , tmpGoods.Amount               AS SaldoOut
           , CASE WHEN CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END <= 0
             THEN 0
             ELSE CASE WHEN Container.SaldoOut < tmpGoods.Amount - Container.CheckAmount THEN Container.SaldoOut ELSE tmpGoods.Amount - Container.CheckAmount END END
      FROM tmpGoods
           LEFT JOIN tmpRemains AS Container
                                ON tmpGoods.GoodsId = Container.GoodsId
                               AND tmpGoods.UnitID = Container.UnitID;
    END IF;

    ANALYSE tmpGoods;

--raise notice 'Value 05: %', timeofday();

    CREATE TEMP TABLE tmpImplementation (
             UserId Integer,
             GoodsId Integer,
             Amount TFloat
      ) ON COMMIT DROP;

    -- Заполняем данные по продажам
    WITH tmpGoodsList AS (SELECT DISTINCT tmpGoods.GoodsId FROM tmpGoods)

    INSERT INTO tmpImplementation
    SELECT tmpMovement.UserId
         , tmpGoodsList.GoodsId                      AS GoodsId
         , Sum(-1 * MIC.Amount)::TFloat              AS Amount
    FROM tmpGoodsList

         INNER JOIN MovementItemContainer AS MIC
                                          ON MIC.ObjectId_Analyzer = tmpGoodsList.GoodsId
                                         AND MIC.OperDate >= vbDateStart
                                         AND MIC.OperDate < vbDateEnd
                                         AND MIC.MovementDescId = zc_Movement_Check()
                                         AND MIC.DescId = zc_MIContainer_Count()

         INNER JOIN tmpMovement ON tmpMovement.MovementId = MIC.MovementId

    GROUP BY tmpMovement.UserId, tmpGoodsList.GoodsId
    HAVING Sum(-1 * MIC.Amount)::TFloat > 0;

--raise notice 'Value 06: %', timeofday();

    RETURN QUERY
    WITH tmpNoSales AS (SELECT tmpUnitUser.UnitId
                             , tmpUnitUser.UserId
                             , COUNT(*)                                                                                              AS CountCheckAll
                             , SUM(CASE WHEN tmpGoods.RemainsOut > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0 THEN 1 ELSE 0 END) AS CountCheck
                        FROM tmpGoods

                             INNER JOIN tmpUnitUser ON tmpGoods.UnitId = tmpUnitUser.UnitID

                             LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                                                        AND tmpImplementation.GoodsId = tmpGoods.GoodsId

                        GROUP BY tmpUnitUser.UnitId, tmpUnitUser.UserId)
       , tmpUserSalesOk AS (SELECT tmpUnitUser.UserId
                                 , count(*) AS CountCheck
                            FROM tmpGoods

                                 LEFT JOIN tmpUnitUser ON tmpGoods.UnitId = tmpUnitUser.UnitID

                                 LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                                                            AND tmpImplementation.GoodsId = tmpGoods.GoodsId

                            WHERE (tmpImplementation.Amount >= 1 OR COALESCE(tmpGoods.RemainsOut, 0) = 0)
                              AND (tmpImplementation.Amount::TFloat / tmpGoods.Remains::TFloat)::TFloat >= (inProcGoods / 100.0)
                              AND (COALESCE(tmpGoods.RemainsOut, 0) > 0 OR COALESCE(tmpImplementation.Amount, 0) > 0)
                            GROUP BY tmpUnitUser.UserId)

    SELECT
           Object_User.ID                      AS UserId
         , Object_User.ObjectCode              AS UserCode
         , Object_User.ValueData               AS UserName
         , Object_Unit.ValueData               AS UnitName
         , tmpNoSales.CountCheckAll::Integer   AS AmountAll
         , tmpNoSales.CountCheck::Integer      AS AmountStart
         , tmpUserSalesOk.CountCheck::Integer  AS AmountSale
         , CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END ::TFloat AS ProcSale
         , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 100
                          ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END < inProcUnit
                THEN ROUND(((inProcUnit - (COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat) * 100) * inPenalty), 2) ELSE 0 END::TFloat AS SummaPenalty
         , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                          ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END < inProcUnit
                THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
    FROM tmpUnitUser

         INNER JOIN Object AS Object_User ON Object_User.ID = tmpUnitUser.UserID

         INNER JOIN Object AS Object_Unit ON Object_Unit.ID = tmpUnitUser.UnitID

         LEFT JOIN tmpNoSales ON tmpNoSales.UnitId = tmpUnitUser.UnitID
                             AND tmpNoSales.UserId = tmpUnitUser.UserId

         LEFT JOIN tmpUserSalesOk ON tmpUserSalesOk.UserId = tmpUnitUser.UserId
    ;

--raise notice 'Value 07: %', timeofday();

  raise notice 'Value 06: %', (select Count(*) from tmpMovement where tmpMovement.UserID = 4036597);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.12.19                                                       *
 18.12.19                                                       *
 27.10.19                                                       *
*/

-- тест select * from gpReport_IlliquidReductionPlanAll(inStartDate := ('27.12.2019')::TDateTime, inPenalty := 500 ,  inProcGoods := 20 , inProcUnit := 10,   inSession := '3');