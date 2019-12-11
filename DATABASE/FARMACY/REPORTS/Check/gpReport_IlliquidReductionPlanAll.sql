-- Function: gpReport_IlliquidReductionPlanAll()

DROP FUNCTION IF EXISTS gpReport_IlliquidReductionPlanAll (TDateTime, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_IlliquidReductionPlanAll(
    IN inStartDate      TDateTime , -- Дата в месяце
    IN inNotSalePastDay Integer ,   -- Дата в месяце
    IN inProcGoods      TFloat ,    -- Дата в месяце
    IN inProcUnit       TFloat ,    -- Дата в месяце
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId           Integer   --
             , UserCode         Integer   --
             , UserName         TVarChar  --
             , UnitName         TVarChar  --
             , AmountStart      Integer   -- Без продаж  на начало
             , AmountSale       Integer   -- Продано
             , ProcSale         TFloat    -- % продаж
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

    IF inNotSalePastDay < 60
    THEN
         RAISE EXCEPTION 'Ошибка. Количество дней без продаж должно быть не менее 60.';       
    END IF;

      -- Мовементы по сотрудникам
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            OperDate           TDateTime,
            UnitID             Integer,
            UserID             Integer

      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , date_trunc('day', MovementDate_Insert.ValueData) AS OperDate
         , MovementLinkObject_Unit.ObjectId                 AS UnitId
         , MovementLinkObject_Insert.ObjectId               AS UserID
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId = MovementLinkObject_Insert.ObjectId 
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          INNER JOIN  ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()    
                                AND ObjectLink_Member_Position.ChildObjectId = 1672498                                   

          INNER JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE /*MovementDate_Insert.ValueData >= vbDateStart
      AND MovementDate_Insert.ValueData < vbDateEnd*/
          Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

--raise notice 'Value 02: %', timeofday();

      -- Добовляем отборы
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                    AS ID
         , date_trunc('day', Movement.OperDate)           AS OperDate
         , MovementLinkObject_Unit.ObjectId               AS UnitId
         , MovementLinkObject_UserConfirmedKind.ObjectId  AS UserID
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                        ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                       AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()
                                       
          INNER JOIN ObjectLink AS ObjectLink_User_Member
                                ON ObjectLink_User_Member.ObjectId =  MovementLinkObject_UserConfirmedKind.ObjectId
                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

          INNER JOIN  ObjectLink AS ObjectLink_Member_Position
                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()    
                                AND ObjectLink_Member_Position.ChildObjectId = 1672498                                   

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_Insert.ObjectId IS NULL
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

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
            Remains         TFloat
      ) ON COMMIT DROP;

    WITH tmpContainer AS (SELECT AnalysisContainer.UnitID         AS UnitID
                               , AnalysisContainer.GoodsID        AS GoodsID
                               , SUM(AnalysisContainer.Saldo)     AS Saldo
                          FROM AnalysisContainer
                          GROUP BY AnalysisContainer.UnitID, AnalysisContainer.GoodsID
                         )
       , tmpMovementItemContainer AS (SELECT AnalysisContainerItem.UnitID                                 AS UnitID
                                           , AnalysisContainerItem.GoodsID                                AS GoodsID
                                           , SUM(AnalysisContainerItem.Saldo)                             AS SaldoIn
                                           , SUM(CASE WHEN AnalysisContainerItem.OperDate >= vbDateStart
                                                      THEN AnalysisContainerItem.Saldo END)               AS Saldo
                                           , SUM(CASE WHEN AnalysisContainerItem.OperDate < vbDateStart
                                                      THEN AnalysisContainerItem.AmountCheck END)         AS Check
                                      FROM AnalysisContainerItem
                                      WHERE AnalysisContainerItem.OperDate >= vbDateStart - (inNotSalePastDay||' DAY')::INTERVAL 
                                      GROUP BY AnalysisContainerItem.UnitID, AnalysisContainerItem.GoodsID)
       , tmpRemains AS (SELECT Container.UnitID
                             , Container.GoodsID
                             , Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0) AS Remains
                        FROM tmpContainer AS Container
                             LEFT JOIN tmpMovementItemContainer AS MovementItemContainer
                                                                ON MovementItemContainer.UnitID = Container.UnitID
                                                               AND MovementItemContainer.GoodsID = Container.GoodsID
                        WHERE (Container.Saldo - COALESCE(MovementItemContainer.Saldo, 0)) > 0
                          AND (Container.Saldo - COALESCE(MovementItemContainer.SaldoIn, 0)) > 0
                          AND COALESCE(MovementItemContainer.Check, 0) = 0)

    INSERT INTO tmpGoods
    SELECT
           Container.UnitID          AS UnitId
         , Container.GoodsID         AS GoodsId
         , Container.Remains::TFloat AS Remains
    FROM tmpRemains AS Container;

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

--raise notice 'Value 03: %', (SELECT count(*) FROM tmpImplementation WHERE tmpImplementation.UserID = 3998962);
--raise notice 'Value 06: %', timeofday();

    RETURN QUERY
    WITH tmpNoSales AS (SELECT tmpGoods.UnitId
                             , count(*) AS CountCheck
                        FROM tmpGoods
                        GROUP BY tmpGoods.UnitId)
       , tmpUserSalesOk AS (SELECT tmpUnitUser.UserId
                                 , count(*) AS CountCheck
                            FROM tmpUnitUser

                                 LEFT JOIN tmpGoods ON tmpGoods.UnitId = tmpUnitUser.UnitID

                                 LEFT JOIN tmpImplementation ON tmpImplementation.UserId = tmpUnitUser.UserId
                                                            AND tmpImplementation.GoodsId = tmpGoods.GoodsId

                            WHERE tmpImplementation.Amount >= 1
                              AND (tmpImplementation.Amount::TFloat / tmpGoods.Remains::TFloat)::TFloat >= (inProcGoods / 100.0)
                            GROUP BY tmpUnitUser.UserId)

    SELECT
           Object_User.ID                      AS UserId
         , Object_User.ObjectCode              AS UserCode
         , Object_User.ValueData               AS UserName
         , Object_Unit.ValueData               AS UnitName
         , tmpNoSales.CountCheck::Integer      AS AmountStart
         , tmpUserSalesOk.CountCheck::Integer  AS AmountSale
         , CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END ::TFloat AS ProcSale
         , CASE WHEN CASE WHEN COALESCE(tmpNoSales.CountCheck, 0) = 0 THEN 0
                          ELSE COALESCE(tmpUserSalesOk.CountCheck, 0)::TFloat / tmpNoSales.CountCheck::TFloat * 100.0 END < inProcUnit
                THEN 16440317 ELSE zc_Color_GreenL() END AS Color_calc
    FROM tmpUnitUser

         INNER JOIN Object AS Object_User ON Object_User.ID = tmpUnitUser.UserID

         INNER JOIN Object AS Object_Unit ON Object_Unit.ID = tmpUnitUser.UnitID

         LEFT JOIN tmpNoSales ON tmpNoSales.UnitId = tmpUnitUser.UnitID

         LEFT JOIN tmpUserSalesOk ON tmpUserSalesOk.UserId = tmpUnitUser.UserId
    ;

--raise notice 'Value 07: %', timeofday();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.10.19         *
*/

-- тест select * from gpReport_IlliquidReductionPlanAll(inStartDate := ('27.11.2019')::TDateTime ,  inSession := '3');