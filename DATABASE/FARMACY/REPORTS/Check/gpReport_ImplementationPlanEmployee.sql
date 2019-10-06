-- Function: gpReport_ImplementationPlanEmployee()

DROP FUNCTION IF EXISTS gpReport_ImplementationPlanEmployee (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ImplementationPlanEmployee(
    IN inMemberID      Integer,    -- Сотрудни
    IN inStartDate     TDateTime , -- Дата в месяце
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE cur4 refcursor;
   DECLARE cur5 refcursor;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbQueryText Text;
   DECLARE curUnit CURSOR FOR SELECT UnitID FROM tmpImplementation GROUP BY UnitCategoryId, UnitID ORDER BY UnitCategoryId, UnitID;
   DECLARE vbUnitID Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');

    IF COALESCE(inMemberID, 0) = 0
    THEN

      vbUserId := lpGetUserBySession (inSession);
    ELSE
    
      IF EXISTS(SELECT ObjectLink_User_Member.ObjectId
                FROM ObjectLink AS ObjectLink_User_Member
                WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                  AND ObjectLink_User_Member.ObjectId = lpGetUserBySession (inSession)
                  AND ObjectLink_User_Member.ChildObjectId = inMemberID)
      THEN
        SELECT ObjectLink_User_Member.ObjectId
        INTO vbUserId
        FROM ObjectLink AS ObjectLink_User_Member
        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
          AND ObjectLink_User_Member.ObjectId = lpGetUserBySession (inSession)
          AND ObjectLink_User_Member.ChildObjectId = inMemberID;      
      ELSE
        IF (SELECT COUNT(*)
            FROM ObjectLink AS ObjectLink_User_Member
            WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
              AND ObjectLink_User_Member.ChildObjectId = inMemberID) = 1
        THEN
          SELECT ObjectLink_User_Member.ObjectId
          INTO vbUserId
          FROM ObjectLink AS ObjectLink_User_Member
          WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            AND ObjectLink_User_Member.ChildObjectId = inMemberID;
        ELSE
          SELECT ObjectLink_User_Member.ObjectId
          INTO vbUserId
          FROM ObjectLink AS ObjectLink_User_Member 
               INNER JOIN Log_CashRemains ON Log_CashRemains.UserId = ObjectLink_User_Member.ObjectId
                                         AND Log_CashRemains.DateStart >= vbDateStart
                                         AND Log_CashRemains.DateStart < vbDateEnd
          WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            AND ObjectLink_User_Member.ChildObjectId = inMemberID
          LIMIT 1;

          IF vbUserId IS NULL
          THEN
            SELECT MAX(ObjectLink_User_Member.ObjectId)
            INTO vbUserId
            FROM ObjectLink AS ObjectLink_User_Member
            WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
              AND ObjectLink_User_Member.ChildObjectId = inMemberID;

          END IF;
        END IF;
      END IF;
    END IF;


    IF (vbUserId <> lpGetUserBySession (inSession)) AND
       NOT EXISTS (SELECT 1
             FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                      JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                      ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                     AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
               AND Object_UserRole_User.ChildObjectId = lpGetUserBySession (inSession)) AND
       NOT EXISTS (SELECT 1
                 FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                      JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                      ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                     AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                      JOIN ObjectLink AS RoleRight_Role -- Связь роли с объектом процессы ролей
                                      ON RoleRight_Role.ChildObjectId = Object_UserRole_Role.ChildObjectId
                                     AND RoleRight_Role.DescId = zc_ObjectLink_RoleRight_Role()
                      JOIN ObjectLink AS RoleRight_Process -- Связь процесса с объектом процессы ролей
                                      ON RoleRight_Process.ObjectId = RoleRight_Role.ObjectId
                                     AND RoleRight_Process.DescId = zc_ObjectLink_RoleRight_Process()
                                     AND RoleRight_Process.ChildObjectId = zc_Enum_Process_InsertUpdate_Object_Member()
                 WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User()
                   AND Object_UserRole_User.ChildObjectId = lpGetUserBySession (inSession))
    THEN
         RAISE EXCEPTION 'Отчет можно запускать только свой.';
    END IF;


      -- Мовементы по сотруднику
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            OperDate           TDateTime,
            UnitID             Integer,
            ConfirmedKind      Boolean

      ) ON COMMIT DROP;

       -- Добовляем простые продажи
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , date_trunc('day', MovementDate_Insert.ValueData) AS OperDate
         , MovementLinkObject_Unit.ObjectId                 AS UnitId
         , False                                            AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

          INNER JOIN MovementDate AS MovementDate_Insert
                                  ON MovementDate_Insert.MovementId = Movement.Id
                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

    WHERE MovementDate_Insert.ValueData >= vbDateStart
      AND MovementDate_Insert.ValueData < vbDateEnd
      AND MovementLinkObject_Insert.ObjectId = vbUserId
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

      -- Добовляем отборы
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                           AS ID
         , date_trunc('day', Movement.OperDate)  AS OperDate
         , MovementLinkObject_Unit.ObjectId      AS UnitId
         , True                                  AS ConfirmedKind
    FROM Movement

          INNER JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                        ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                       AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                       AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.OperDate >= vbDateStart
      AND Movement.OperDate < vbDateEnd
      AND MovementLinkObject_UserConfirmedKind.ObjectId = vbUserId
      AND MovementLinkObject_Insert.ObjectId IS NULL
      AND Movement.DescId = zc_Movement_Check()
      AND Movement.StatusId = zc_Enum_Status_Complete();

    ANALYSE tmpMovement;
    
    IF COALESCE(inMemberID, 0) = 0
    THEN

      IF NOT EXISTS(SELECT * FROM tmpMovement)
      THEN
           RAISE EXCEPTION 'По вам ненайдены чеки.';
      END IF;
    ELSE

      IF NOT EXISTS(SELECT * FROM tmpMovement)
      THEN
           RAISE EXCEPTION 'По сотруднику не найдены чеки.';
      END IF;
    END IF;


    CREATE TEMP TABLE tmpImplementation (
             UnitCategoryId Integer,
             UnitCategoryName TVarChar,
             ObjectId Integer,
             UnitID Integer,
             UnitName TVarChar,
             GroupName TVarChar,
             GoodsId Integer,
             GoodsCode Integer,
             GoodsName TVarChar,
             Amount TFloat,
             Price TFloat,

             AmountPlan TFloat,
             AmountPlanMax TFloat
      ) ON COMMIT DROP;

      -- Заполняем данные по продажам
    INSERT INTO tmpImplementation
      WITH tmpImplementation AS (SELECT
             tmpMovement.UnitID                                    AS ObjectId
           , ObjectLink_Main.ChildObjectId                         AS GoodsMainId
           , Sum(MovementItem.Amount)::TFloat                      AS Amount
           , ROUND(Sum(COALESCE (MIFloat_Price.ValueData, 0)::TFloat *
             MovementItem.Amount) / Sum(MovementItem.Amount), 2)::TFloat AS Price
    FROM tmpMovement 
          INNER JOIN Movement ON Movement.ID = tmpMovement.MovementID

          INNER JOIN MovementItem AS MovementItem
                                  ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.isErased   = FALSE
                                 AND MovementItem.DescId     = zc_MI_Master()

          LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = MovementItem.ObjectId
                              AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
          LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                              AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()              

          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()

    GROUP BY tmpMovement.UnitID
           , ObjectLink_Main.ChildObjectId
    HAVING Sum(MovementItem.Amount)::TFloat > 0)

    SELECT
           Object_UnitCategory.ObjectCode                        AS UnitCategoryId
         , Object_UnitCategory.ValueData                         AS UnitCategoryName
         , ObjectLink_Unit_Category.ObjectId                     AS ObjectId
         , Object_Unit.ObjectCode                                AS UnitID
         , Object_Unit.ValueData                                 AS UnitName
         , Object_Goods.GoodsGroupName                           AS GroupName
         , MI_PromoUnit.ObjectId                                 AS GoodsId
         , Object_Goods.GoodsCodeInt                             AS GoodsCode
         , Object_Goods.GoodsName                                AS GoodsName
         , COALESCE(Implementation.Amount, 0)::TFloat            AS Amount
         , COALESCE(Implementation.Price,
           ROUND(MIFloat_Price.ValueData, 2))::TFloat            AS Price
         , MI_PromoUnit.Amount                                   AS AmountPlan
         , MIFloat_AmountPlanMax.ValueData::TFloat               AS AmountPlanMax
     FROM Movement AS Movement_PromoUnit

              LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                           ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                          AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
              LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = MovementLinkObject_UnitCategory.ObjectId

              LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                             ON ObjectLink_Unit_Category.ChildObjectId = MovementLinkObject_UnitCategory.ObjectId
                            AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
              LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit_Category.ObjectId

              LEFT JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                    AND MI_PromoUnit.DescId = zc_MI_Master()
                                    AND MI_PromoUnit.isErased = FALSE

              LEFT JOIN Object_Goods_View AS Object_Goods ON Object_Goods.Id = MI_PromoUnit.ObjectId
              
              LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = MI_PromoUnit.ObjectId
                                  AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
              LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                  AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()              

              LEFT JOIN MovementItemFloat AS MIFloat_Price  ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()

              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                          ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                         AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

              LEFT JOIN tmpImplementation AS Implementation ON  Implementation.ObjectId = ObjectLink_Unit_Category.ObjectId
                                         AND Implementation.GoodsMainId = ObjectLink_Main.ChildObjectId 

     WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
       AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
       AND Movement_PromoUnit.OperDate >= vbDateStart
       AND Movement_PromoUnit.OperDate < vbDateEnd
       AND ObjectLink_Unit_Category.ObjectId in (SELECT DISTINCT Movement.UnitId FROM tmpMovement AS Movement)
     ORDER BY Object_Unit.ObjectCode, Object_Goods.GoodsCodeInt;

       -- Вывод результата
     OPEN cur1 FOR SELECT DISTINCT
             UnitCategoryId,
             UnitCategoryName,
             UnitID,
             UnitName FROM tmpImplementation
             ORDER BY UnitCategoryId, UnitID;
     RETURN NEXT cur1;

     CREATE TEMP TABLE tmpResult (
             GroupName TVarChar,
             GoodsCode Integer,
             GoodsName TVarChar,
             Consider TVarChar
      ) ON COMMIT DROP;

     INSERT INTO tmpResult (GroupName, GoodsCode, GoodsName)
     SELECT DISTINCT
               GroupName,
               GoodsCode,
               GoodsName
             FROM tmpImplementation
             WHERE AmountPlanMax > 0
             ORDER BY GroupName, GoodsCode;

      OPEN curUnit;
      LOOP
          FETCH curUnit INTO vbUnitID;
          IF NOT FOUND THEN EXIT; END IF;

          vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Price' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN Amount' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN AmountPlan' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN AmountPlanAward' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
          EXECUTE vbQueryText;

          vbQueryText := 'UPDATE tmpResult set Price' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T1.T_Price, 0)' ||
            ', Amount' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T1.T_Amount, 0)' ||
            ', AmountPlan' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_AmountPlan, 0)' ||
            ', AmountPlanAward' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_AmountPlanMax, 0)' ||
            ' FROM (SELECT
               GoodsCode AS GoodsID,
               tmpImplementation.Price AS T_Price,
               tmpImplementation.Amount AS T_Amount,
               tmpImplementation.AmountPlan AS T_AmountPlan,
               tmpImplementation.AmountPlanMax AS T_AmountPlanMax
             FROM tmpImplementation
             WHERE tmpImplementation.UnitID = ' || COALESCE (vbUnitID, 0)::Text || ') AS T1
             WHERE GoodsCode = T1.GoodsID';
          EXECUTE vbQueryText;

      END LOOP;
      CLOSE curUnit;

     OPEN cur2 FOR SELECT * FROM tmpResult ORDER BY GroupName, GoodsCode LIMIT 1;
     RETURN NEXT cur2;

     OPEN cur3 FOR SELECT
            Object_UnitCategory.Id                       AS UnitCategoryId
          , Object_UnitCategory.ObjectCode               AS UnitCategoryCode
          , Object_UnitCategory.ValueData                AS UnitCategoryName
          , ObjectFloat_PenaltyNonMinPlan.ValueData      AS PenaltyNonMinPlan
          , ObjectFloat_PremiumImplPlan.ValueData        AS PremiumImplPlan
          , ObjectFloat_MinLineByLineImplPlan.ValueData  AS MinLineByLineImplPlan
       FROM Object AS Object_UnitCategory

           LEFT JOIN ObjectFloat AS ObjectFloat_PenaltyNonMinPlan
                                 ON ObjectFloat_PenaltyNonMinPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PenaltyNonMinPlan.DescId = zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_PremiumImplPlan
                                 ON ObjectFloat_PremiumImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PremiumImplPlan.DescId = zc_ObjectFloat_UnitCategory_PremiumImplPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_MinLineByLineImplPlan
                                 ON ObjectFloat_MinLineByLineImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_MinLineByLineImplPlan.DescId = zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan()

       WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
         AND Object_UnitCategory.isErased = False
         AND Object_UnitCategory.ObjectCode IN (SELECT DISTINCT UnitCategoryId FROM tmpImplementation WHERE AmountPlanMax > 0)
       ORDER BY Object_UnitCategory.ObjectCode;
     RETURN NEXT cur3;

     OPEN cur4 FOR  WITH
       tmpUnitDate AS (SELECT
                 Movement.UnitId                              AS ObjectId
               , Movement.OperDate                            AS OperDate
               , Count(*)                                     AS CountCheck
         FROM tmpMovement as Movement

         WHERE  Movement.ConfirmedKind = False
         GROUP BY Movement.UnitId, Movement.OperDate),
       tmpFactOfManDaysActual AS (SELECT
               ObjectId                                              AS ObjectId
             , COUNT(*)::Integer                                     AS FactOfManDays
         FROM tmpUnitDate
         WHERE CountCheck >= 5
         GROUP BY ObjectId),
       tmpFactOfManDays AS (SELECT
               ObjectId                                              AS ObjectId
             , FactOfManDays                                         AS FactOfManDays
/*             , CASE WHEN (SELECT ObjectId FROM tmpFactOfManDaysActual ORDER BY FactOfManDays DESC LIMIT 1) = ObjectId
                    THEN (SELECT SUM(FactOfManDays) FROM tmpFactOfManDaysActual)
                    ELSE FactOfManDays END::INTEGER                           AS FactOfManDays */
         FROM tmpFactOfManDaysActual)

       SELECT
            Object_Unit.Id                                       AS UnitId
          , Object_Unit.ObjectCode                               AS UnitCode
          , Object_Unit.ValueData                                AS UnitName
          , Object_UnitCategory.ObjectCode                       AS UnitCategoryId
          , ObjectFloat_NormOfManDays.ValueData::Integer         AS NormOfManDays
          , FactOfManDays_Unit.FactOfManDays                     AS FactOfManDays
          , CASE WHEN ObjectFloat_NormOfManDays.ValueData::Integer = 0 THEN 0.0 ELSE
            CASE WHEN FactOfManDays_Unit.FactOfManDays >= ObjectFloat_NormOfManDays.ValueData THEN 100.0 ELSE
            ROUND(1.0 * FactOfManDays_Unit.FactOfManDays /
            ObjectFloat_NormOfManDays.ValueData * 100.0, 2) END END  AS PercentAttendance
       FROM Object AS Object_Unit

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                               ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

           LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_NormOfManDays
                                 ON ObjectFloat_NormOfManDays.ObjectId = Object_Unit.Id
                                AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()

           LEFT JOIN tmpFactOfManDays AS FactOfManDays_Unit
                                      ON FactOfManDays_Unit.ObjectId = Object_Unit.Id

       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.isErased = False
         AND Object_Unit.ObjectCode IN (SELECT DISTINCT UnitID FROM tmpImplementation WHERE AmountPlanMax > 0)
       ORDER BY Object_UnitCategory.ObjectCode, Object_Unit.ObjectCode;
     RETURN NEXT cur4;


     OPEN cur5 FOR SELECT * FROM tmpResult ORDER BY GroupName, GoodsCode;
     RETURN NEXT cur5;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 22.10.18         *
 19.10.18         *
 17.10.18         *
 13.10.18         *
 04.09.18         *
 06.07.18         *
 15.05.18         *
*/

-- тест
-- select * from gpReport_ImplementationPlanEmployee(inMemberId := 8001516 , inStartDate := ('17.09.2019')::TDateTime ,  inSession := '3');