-- Function: gpReport_KPU()

DROP FUNCTION IF EXISTS gpReport_KPU (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_KPU(
    IN inStartDate     TDateTime , -- Дата в месяце
    IN inRecount       Boolean ,   -- Пересчитать данные
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  ID                 Integer,
  UserID             Integer,
  UserCode           Integer,
  UserName           TVarChar,

  PositionName       TVarChar,
  DateIn             TDateTime,

  UnitID             Integer,
  UnitCode           Integer,
  UnitName           TVarChar,

  KPU                TFloat,

  FactOfManDays      Integer,
  TotalExecutionLine TFloat,
  AmountTheFineTab   TFloat,
  BonusAmountTab     TFloat,
  MarkRatio          Integer,

  PrevAverageCheck   TFloat,
  AverageCheck       TFloat,
  AverageCheckRatio  TFloat,

  PrevNumberChecks   TFloat,
  NumberChecks       TFloat,
  NumberChecksRatio  TFloat,

  LateTimeRatio      Integer,

  FinancPlan         TFloat,
  FinancPlanFact     TFloat,
  FinancPlanRatio    Integer,

  ExamPercentage     TFloat,
  NumberAttempts     Integer,
  ExamResult         TVarChar,
  IT_ExamRatio       Integer,

  ComplaintsRatio    Integer,
  ComplaintsNote     TVarChar,

  DirectorRatio      Integer,
  DirectorNote       TVarChar,

  YuriIT             Integer,
  OlegIT             Integer,
  MaximIT            Integer,
  CollegeITRatio     Integer,
  CollegeITNote      TVarChar,

  VIPDepartRatio     Integer,
  VIPDepartRatioNote TVarChar,

  Romanova           Integer,
  Golovko            Integer,
  ControlRGRatio     Integer,
  ControlRGNote      TVarChar,

  Color_Calc         Integer,
  Color_Calc_Font    Integer,

  MainJuridicalID    Integer,
  MainJuridicalName  TVarChar

)
AS
$BODY$
   DECLARE vbDateStart TDateTime;
   DECLARE vbEndDate TDateTime;
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());


  vbDateStart := date_trunc('month', inStartDate);
  vbEndDate := date_trunc('month', inStartDate) + Interval '1 MONTH';

  IF vbDateStart >= date_trunc('month', CURRENT_DATE)
  THEN
     RAISE EXCEPTION 'Ошибка. Запускать отчет можно толькуо после окончания месяца.';
  END IF;

  IF vbDateStart < ('01.12.2018')::TDateTime
  THEN
     RAISE EXCEPTION 'Ошибка. Запускать отчет можно датой не ранее 01.12.2018.';
  END IF;

  IF (inRecount = True) OR NOT EXISTS(SELECT 1 FROM Movement WHERE OperDate = vbDateStart AND DescId = zc_Movement_KPU())
  THEN

    CREATE TEMP TABLE tmpCheck (
            ID                 Integer,
            OperDate           TDateTime,
            UserID             Integer,
            TotalSumm          TFloat
      ) ON COMMIT DROP;

    WITH tmpMovementID AS (SELECT MovementDate_Insert.MovementID
                                , MovementDate_Insert.ValueData   AS OperDate
                           FROM MovementDate as MovementDate_Insert
                           WHERE MovementDate_Insert.ValueData >= vbDateStart - INTERVAL '1 month'
                             AND MovementDate_Insert.ValueData < vbEndDate
                             AND MovementDate_Insert.DescId = zc_MovementDate_Insert())

    INSERT INTO tmpCheck
    SELECT tmpMovementID.MovementID
         , tmpMovementID.OperDate
         , MovementLinkObject_Insert.ObjectId                   AS UserId
         , MovementFloat_TotalSumm.ValueData                    AS TotalSumm
    FROM tmpMovementID

         INNER JOIN Movement ON Movement.ID = tmpMovementID.MovementID
                AND Movement.DescId = zc_Movement_Check()
                AND Movement.StatusId = zc_Enum_Status_Complete()

         INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                       ON MovementLinkObject_Insert.MovementId = Movement.Id
                                      AND MovementLinkObject_Insert.DescId = zc_movementlinkobject_insert()

         INNER JOIN  MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm();
    ANALYSE tmpCheck;

    CREATE TEMP TABLE tmpImplementationPlan (
            UserID             Integer,
            UserName           TVarChar,

            UnitID             Integer,
            UnitName           TVarChar,

            FactOfManDays      Integer,
            TotalExecutionLine TFloat,
            AmountTheFineTab   TFloat,
            BonusAmountTab     TFloat,

            PrevAverageCheck   TFloat,
            AverageCheck       TFloat,

            PrevNumberChecks   TFloat,
            NumberChecks       TFloat,

            FinancPlan         TFloat,
            FinancPlanFact     TFloat,

            LateTimePenalty    Integer
      ) ON COMMIT DROP;

    WITH tmpPersonal AS (SELECT
                             ROW_NUMBER() OVER (PARTITION BY MemberId ORDER BY IsErased) AS Ord
                           , Object_Personal_View.MemberId
                           , Object_Personal_View.PositionId
                        FROM Object_Personal_View)

    INSERT INTO tmpImplementationPlan
    SELECT
            T.UserID
          , T.UserName
          , T.UnitID
          , T.UnitName
          , T.FactOfManDays
          , T.TotalExecutionLine
          , T.AmountTheFineTab
          , T.BonusAmountTab
          , Null
          , Null
          , Null
          , Null
          , Null
    FROM gpReport_ImplementationPlanEmployeeAll (vbDateStart, inSession) AS T

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = T.UserID
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                            AND tmpPersonal.Ord = 1

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           AND ObjectLink_Unit_Juridical.ObjectId = T.UnitID

    WHERE COALESCE(tmpPersonal.PositionId, 0) <> 1690028 AND T.UserID <> 6406669
      AND COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) <> 5062797;


      -- Средний чек за прошлый месяц
    UPDATE tmpImplementationPlan SET PrevAverageCheck = ROUND(T1.Average *
      CASE date_part('month', vbDateStart - INTERVAL '1 month')
           WHEN 1 THEN 0.98
           WHEN 2 THEN 1.07
           WHEN 3 THEN 1.07
           WHEN 4 THEN 0.99
           WHEN 5 THEN 0.94
           WHEN 6 THEN 0.96
           WHEN 7 THEN 1.01
           WHEN 8 THEN 0.99
           WHEN 9 THEN 1.07
           WHEN 10 THEN 1.09
           WHEN 11 THEN 1.06
           WHEN 12 THEN 1.04 END, 2)
    FROM (SELECT
                 Movement.UserId                       AS UserId
               , SUM(Movement.TotalSumm) / Count(*)    AS Average
      FROM tmpCheck AS Movement
      WHERE Movement.OperDate >= vbDateStart - INTERVAL '1 month'
        AND Movement.OperDate < vbDateStart
      GROUP BY Movement.UserId) AS T1
    WHERE tmpImplementationPlan.UserId = T1.UserId;

      -- Средний чек за текущий месяц
    UPDATE tmpImplementationPlan SET AverageCheck = ROUND(T1.Average, 2)
    FROM (SELECT
                 Movement.UserId                       AS UserId
               , SUM(Movement.TotalSumm) / Count(*)    AS Average
      FROM tmpCheck AS Movement
      WHERE Movement.OperDate >= vbDateStart
        AND Movement.OperDate < vbEndDate
      GROUP BY Movement.UserId) AS T1
    WHERE tmpImplementationPlan.UserId = T1.UserId;

      -- Количество чеков за прошлый месяц
    UPDATE tmpImplementationPlan SET PrevNumberChecks = ROUND(T1.Average *
      CASE date_part('month', vbDateStart - INTERVAL '1 month')
           WHEN 1 THEN 0.98
           WHEN 2 THEN 1.07
           WHEN 3 THEN 1.07
           WHEN 4 THEN 0.99
           WHEN 5 THEN 0.94
           WHEN 6 THEN 0.96
           WHEN 7 THEN 1.01
           WHEN 8 THEN 0.99
           WHEN 9 THEN 1.07
           WHEN 10 THEN 1.09
           WHEN 11 THEN 1.06
           WHEN 12 THEN 1.04 END, 0)
    FROM (SELECT
                 Movement.UserId                 AS UserId
               , Count(*)                        AS Average
      FROM tmpCheck AS Movement
      WHERE Movement.OperDate >= vbDateStart - INTERVAL '1 month'
        AND Movement.OperDate < vbDateStart
      GROUP BY Movement.UserId) AS T1
    WHERE tmpImplementationPlan.UserId = T1.UserId;

      -- Количество чеков за текущий месяц
    UPDATE tmpImplementationPlan SET NumberChecks = ROUND(T1.Average, 2)
    FROM (SELECT
                 Movement.UserId     AS UserId
               , Count(*)            AS Average
      FROM tmpCheck AS Movement
      WHERE Movement.OperDate >= vbDateStart
        AND Movement.OperDate < vbEndDate
      GROUP BY Movement.UserId) AS T1
    WHERE tmpImplementationPlan.UserId = T1.UserId;

      -- Финансовый план
    UPDATE tmpImplementationPlan SET FinancPlan = ROUND(T1.PlanAmount, 2)
    FROM (SELECT
                                 Object_ReportSoldParams.UnitId                 AS UnitId,
                                 Object_ReportSoldParams.PlanAmount             AS PlanAmount
                          FROM
                               Object_ReportSoldParams_View AS Object_ReportSoldParams
                          WHERE Object_ReportSoldParams.PlanDate >= vbDateStart
                            AND Object_ReportSoldParams.PlanDate < vbEndDate) AS T1
    WHERE tmpImplementationPlan.UnitID = T1.UnitID;

      -- Финансовый план факт
    UPDATE tmpImplementationPlan SET FinancPlanFact = ROUND(T1.FactAmount, 2)
    FROM (SELECT
                                 MovementCheck.UnitId                           AS UnitID,
                                 SUM(TotalSumm)                                 AS FactAmount
                          FROM
                               Movement_Check_View AS MovementCheck
                          WHERE MovementCheck.OperDate >= vbDateStart
                            AND MovementCheck.OperDate < vbEndDate
                            AND MovementCheck.StatusId = zc_Enum_Status_Complete()
                          GROUP BY  MovementCheck.UnitID) AS T1
    WHERE tmpImplementationPlan.UnitID = T1.UnitID;


      -- Штраф за опоздания
    CREATE TEMP TABLE tmpCurrOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', vbDateStart), DATE_TRUNC ('MONTH', vbDateStart) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

    UPDATE tmpImplementationPlan SET LateTimePenalty = T1.Penalty
    FROM (
       WITH tmpEmployeeSchedule AS (SELECT tmpImplementationPlan.UserID
              , tmpCurrOperDate.OperDate::TDateTime
              , DateIn.Value
              , Min(EmployeeWorkLog.DateLogIn)::TDateTime AS DateStart
              , DateIn.TimeIn
              , ((date_part('hour', Min(EmployeeWorkLog.DateLogIn)) - date_part('hour', COALESCE(DateIn.TimeIn, '8:00'::Time))) * 60 +
                date_part('minute', Min(EmployeeWorkLog.DateLogIn)) - date_part('minute', COALESCE(DateIn.TimeIn, '8:00'::Time)))::Integer AS MinutePenalty
         FROM tmpCurrOperDate
              INNER JOIN tmpImplementationPlan ON 1 = 1
              LEFT JOIN gpSelect_MovementItem_EmployeeSchedule_KPU(vbDateStart, inSession) AS DateIn
                                                                                           ON DateIn.UserID = tmpImplementationPlan.UserID
                                                                                          AND DateIn.Date = tmpCurrOperDate.OperDate
              LEFT JOIN EmployeeWorkLog ON EmployeeWorkLog.UserId = tmpImplementationPlan.UserID
                                       AND EmployeeWorkLog.DateLogIn >= tmpCurrOperDate.OperDate
                                       AND EmployeeWorkLog.DateLogIn < tmpCurrOperDate.OperDate + INTERVAL '1 DAY'
         GROUP BY tmpImplementationPlan.UserID
                , tmpCurrOperDate.OperDate
                , DateIn.Value
                , DateIn.TimeIn)

       SELECT tmpEmployeeSchedule.UserID
            , SUM(CASE WHEN COALESCE(tmpEmployeeSchedule.Value, 'В') <> 'В' AND tmpEmployeeSchedule.DateStart IS NULL THEN - 3
                       ELSE CASE WHEN tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty <= 5 THEN - 1
                       ELSE CASE WHEN tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty <= 15 THEN - 2
                       ELSE CASE WHEN tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty > 15 THEN - 3
                       END END END END)::Integer                                                    AS Penalty

       FROM tmpEmployeeSchedule
       GROUP BY tmpEmployeeSchedule.UserID) AS T1
    WHERE tmpImplementationPlan.UserId = T1.UserId;


       -- Получаем Movement
    IF EXISTS(SELECT Movement.ID FROM Movement WHERE Movement.OperDate = vbDateStart AND Movement.DescId = zc_Movement_KPU())
    THEN
      SELECT Movement.ID
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = vbDateStart
        AND Movement.DescId = zc_Movement_KPU();
    ELSE
      vbMovementID := 0;
      vbMovementID := lpInsertUpdate_Movement (vbMovementID, zc_Movement_KPU(), Null, vbDateStart, NULL);
    END IF;

      -- Создаем MovementItem
    IF EXISTS(SELECT tmpImplementationPlan.UserID
              FROM tmpImplementationPlan
                   LEFT OUTER JOIN MovementItem ON tmpImplementationPlan.UserID = MovementItem.ObjectId
                                               AND MovementItem.MovementID = vbMovementID
              WHERE MovementItem.ID IS NULL)
    THEN
      PERFORM lpInsertUpdate_MovementItem (0, zc_MI_Master(), tmpImplementationPlan.UserID, vbMovementID, 30, NULL)
      FROM tmpImplementationPlan
           LEFT OUTER JOIN MovementItem ON tmpImplementationPlan.UserID = MovementItem.ObjectId
                                       AND MovementItem.MovementID = vbMovementID
      WHERE MovementItem.ID IS NULL;
    END IF;

      -- Сохраняем результат
    PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Unit(),  MovementItem.Id, tmpImplementationPlan.UnitID),
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_FactOfManDays(), MovementItem.Id, tmpImplementationPlan.FactOfManDays),
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalExecutionLine(), MovementItem.Id, tmpImplementationPlan.TotalExecutionLine),
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountTheFineTab(), MovementItem.Id, tmpImplementationPlan.AmountTheFineTab),
            lpInsertUpdate_MovementItemFloat (zc_MIFloat_BonusAmountTab(), MovementItem.Id, tmpImplementationPlan.BonusAmountTab),
            CASE WHEN tmpImplementationPlan.PrevAverageCheck is not Null OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_PrevAverageCheck()) THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevAverageCheck(), MovementItem.Id, COALESCE (tmpImplementationPlan.PrevAverageCheck, 0)) END,
            CASE WHEN tmpImplementationPlan.AverageCheck is not Null  OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_AverageCheck())THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_AverageCheck(), MovementItem.Id, COALESCE (tmpImplementationPlan.AverageCheck, 0)) END,
            CASE WHEN tmpImplementationPlan.PrevNumberChecks is not Null OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_PrevNumberChecks()) THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_PrevNumberChecks(), MovementItem.Id, COALESCE (tmpImplementationPlan.PrevNumberChecks, 0)) END,
            CASE WHEN tmpImplementationPlan.NumberChecks is not Null  OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_NumberChecks())THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_NumberChecks(), MovementItem.Id, COALESCE (tmpImplementationPlan.NumberChecks, 0)) END,
            CASE WHEN tmpImplementationPlan.FinancPlan is not Null  OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_FinancPlan())THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_FinancPlan(), MovementItem.Id, COALESCE (tmpImplementationPlan.FinancPlan, 0)) END,
            CASE WHEN tmpImplementationPlan.FinancPlanFact is not Null  OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_FinancPlanFact())THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_FinancPlanFact(), MovementItem.Id, COALESCE (tmpImplementationPlan.FinancPlanFact, 0)) END,
            CASE WHEN tmpImplementationPlan.LateTimePenalty is not Null  OR
              EXISTS(SELECT 1 FROM MovementItemFloat WHERE MovementItemID = MovementItem.Id AND DescId = zc_MIFloat_LateTimePenalty())THEN
              lpInsertUpdate_MovementItemFloat (zc_MIFloat_LateTimePenalty(), MovementItem.Id, COALESCE (tmpImplementationPlan.LateTimePenalty, 0)) END
    FROM tmpImplementationPlan
         INNER JOIN MovementItem ON tmpImplementationPlan.UserID = MovementItem.ObjectId
                                AND MovementItem.MovementID = vbMovementID;

      -- Подститываем КПУ
    PERFORM lpUpdate_MovementItem_KPU (MovementItem.Id)
    FROM MovementItem
    WHERE MovementItem.MovementID = vbMovementID;
  END IF;


       -- Результат
  RETURN QUERY
   WITH tmpTestingUser AS (SELECT
                             MovementItem.ObjectId                                          AS UserID
                           , MovementItem.Amount                                            AS ExamPercentage
                           , MovementItemFloat.ValueData::Integer                           AS Attempts
                      FROM Movement

                           LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                  AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                      AND MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()

                      WHERE Movement.DescId = zc_Movement_TestingUser()
                        AND Movement.OperDate = vbDateStart),
        tmpPersonal AS (SELECT
                             ROW_NUMBER() OVER (PARTITION BY MemberId ORDER BY IsErased) AS Ord
                           , Object_Personal_View.MemberId
                           , Object_Personal_View.PositionName
                           , Object_Personal_View.DateIn
                        FROM Object_Personal_View)

  SELECT
          MovementItem.Id                             AS ID
        , MovementItem.ObjectId                       AS UserID
        , Object_Member.ObjectCode                    AS UserCode
        , Object_Member.ValueData                     AS UserName

        , tmpPersonal.PositionName
        , tmpPersonal.DateIn

        , Object_Unit.ID                              AS UnitID
        , Object_Unit.ObjectCode                      AS UnitCode
        , Object_Unit.ValueData                       AS UnitName

        , MovementItem.Amount                         AS KPU

        , MIFloat_FactOfManDays.ValueData::Integer    AS FactOfManDays
        , MIFloat_TotalExecutionLine.ValueData        AS TotalExecutionLine
        , MIFloat_AmountTheFineTab.ValueData          AS AmountTheFineTab
        , MIFloat_BonusAmountTab.ValueData            AS BonusAmountTab
        , COALESCE (MIFloat_MarkRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) = 0 AND COALESCE (MIFloat_BonusAmountTab.ValueData, 0) = 0  THEN 0
            ELSE
              CASE WHEN upper(substring(Object_UnitCategory.ValueData, 1, 2)) = 'АП'
              THEN
                CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 80 THEN 2
                ELSE
                  CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 50 AND
                            COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 1
                  ELSE
                    CASE WHEN MIFloat_TotalExecutionLine.ValueData < 50 AND
                              COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 0
                    ELSE
                      -1
                    END
                  END
                END
              ELSE
                CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 90 THEN 2
                ELSE
                  CASE WHEN MIFloat_TotalExecutionLine.ValueData >= 60 AND
                            COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 1
                  ELSE
                    CASE WHEN MIFloat_TotalExecutionLine.ValueData < 60 AND
                              COALESCE (MIFloat_AmountTheFineTab.ValueData, 0) <= COALESCE (MIFloat_BonusAmountTab.ValueData, 0) THEN 0
                    ELSE
                      -1
                    END
                  END
                END
              END
            END)::Integer

        , MIFloat_PrevAverageCheck.ValueData          AS PrevAverageCheck
        , MIFloat_AverageCheck.ValueData              AS AverageCheck
        , COALESCE (MIFloat_AverageCheckRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_AverageCheck.ValueData, 0) / COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) - 1) * 100, 1)
            END)::TFloat                              AS AverageCheckRatio

        , MIFloat_PrevNumberChecks.ValueData          AS PrevNumberChecks
        , MIFloat_NumberChecks.ValueData              AS NumberChecks
        , COALESCE (MIFloat_NumberChecksRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_NumberChecks.ValueData, 0) / COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) - 1) * 100, 1)
            END)::TFloat                              AS NumberChecksRatio


        , COALESCE (MIFloat_LateTimeRatio.ValueData,
          MIFloat_LateTimePenalty.ValueData, 0)::Integer AS LateTimeRatio

        , MIFloat_FinancPlan.ValueData::TFloat        AS FinancPlan
        , MIFloat_FinancPlanFact.ValueData::TFloat    AS FinancPlanFact
        , COALESCE (MIFloat_FinancPlanRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_FinancPlan.ValueData, 0) = 0 or COALESCE (MIFloat_FinancPlanFact.ValueData, 0) = 0
            THEN 0 ELSE CASE WHEN MIFloat_FinancPlan.ValueData <= MIFloat_FinancPlanFact.ValueData THEN 1 ELSE -1 END
            END)::Integer                             AS FinancPlanRatio

        , TestingUser.ExamPercentage                  AS ExamPercentage
        , TestingUser.Attempts                        AS NumberAttempts
        , CASE WHEN COALESCE (TestingUser.Attempts, 0) = 0
          THEN NULL ELSE
          CASE WHEN TestingUser.ExamPercentage >= 85
          THEN 'Сдан' ELSE 'Не сдан' END END::TVarChar       AS ExamResult
        , COALESCE (MIFloat_IT_ExamRatio.ValueData::Integer,
          CASE WHEN COALESCE (TestingUser.Attempts, 0) = 0
          THEN NULL ELSE
          CASE WHEN TestingUser.ExamPercentage >= 85
          THEN 4 - TestingUser.Attempts ELSE Null END END)   AS IT_ExamRatio

        , MIFloat_ComplaintsRatio.ValueData::Integer  AS ComplaintsRatio
        , MIString_ComplaintsNote.ValueData           AS ComplaintsNote

        , MIFloat_DirectorRatio.ValueData::Integer    AS DirectorRatio
        , MIString_DirectorNote.ValueData             AS DirectorNote

        , MIFloat_YuriIT.ValueData::Integer           AS YuriIT
        , MIFloat_OlegIT.ValueData::Integer           AS OlegIT
        , MIFloat_MaximIT.ValueData::Integer          AS MaximIT
        , MIFloat_CollegeITRatio.ValueData::Integer   AS CollegeITRatio
        , MIString_CollegeITNote.ValueData            AS CollegeITNote

        , MIFloat_VIPDepartRatio.ValueData::Integer   AS VIPDepartRatio
        , MIString_VIPDepartRatioNote.ValueData       AS VIPDepartRatioNote

        , MIFloat_Romanova.ValueData::Integer         AS Romanova
        , MIFloat_Golovko.ValueData::Integer          AS Golovko
        , MIFloat_ControlRGRatio.ValueData::Integer   AS ControlRGRatio
        , MIString_ControlRGNote.ValueData            AS ControlRGNote

        , CASE WHEN ObjectLink_Unit_Juridical.ChildObjectId IN (5062797, 7433752, 4103479, 7433753)
          THEN  zc_Color_Aqua()
          ELSE CASE WHEN MovementItem.Amount < 20 THEN zc_Color_Warning_Red()
          ELSE CASE WHEN MovementItem.Amount <= 30 THEN zc_Color_Yelow()
          ELSE zc_Color_Lime() END END END AS Color_Calc

/*        , CASE WHEN COALESCE (MIFloat_NumberChecksRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_NumberChecks.ValueData, 0) / COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) - 1) * 100, 1)
            END) <> 0 THEN
            CASE WHEN ABS((COALESCE (MIFloat_AverageCheckRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_AverageCheck.ValueData, 0) / COALESCE (MIFloat_PrevAverageCheck.ValueData, 0) - 1) * 100, 1)
            END) - COALESCE (MIFloat_NumberChecksRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_NumberChecks.ValueData, 0) / COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) - 1) * 100, 1)
            END)) / COALESCE (MIFloat_NumberChecksRatio.ValueData,
            CASE WHEN COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) = 0
            THEN 0 ELSE ROUND((COALESCE (MIFloat_NumberChecks.ValueData, 0) / COALESCE (MIFloat_PrevNumberChecks.ValueData, 0) - 1) * 100, 1)
            END) * 100) <= CASE WHEN ObjectLink_Unit_Juridical.ChildObjectId IN (5062797, 7433752, 4103479, 7433753) THEN 3 ELSE 1 END
            THEN zc_Color_Black() ELSE zc_Color_Blue() END
            ELSE zc_Color_Black() END AS Color_Calc_Font
*/
        , zc_Color_Black() AS Color_Calc_Font
        , Object_MainJuridical.ID                  AS MainJuridicalName
        , Object_MainJuridical.ValueData           AS MainJuridicalName

  FROM Movement

       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                              AND MovementItem.DescId = zc_MI_Master()

       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                            ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id
                           AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
       LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                            ON ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                           AND ObjectLink_Unit_Juridical.ObjectId = MILinkObject_Unit.ObjectId
       LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectid

       LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectid
                            AND tmpPersonal.Ord = 1

       LEFT JOIN MovementItemFloat AS MIFloat_FactOfManDays
                                   ON MIFloat_FactOfManDays.MovementItemId = MovementItem.Id
                                  AND MIFloat_FactOfManDays.DescId = zc_MIFloat_FactOfManDays()

       LEFT JOIN MovementItemFloat AS MIFloat_TotalExecutionLine
                                   ON MIFloat_TotalExecutionLine.MovementItemId = MovementItem.Id
                                  AND MIFloat_TotalExecutionLine.DescId = zc_MIFloat_TotalExecutionLine()

       LEFT JOIN MovementItemFloat AS MIFloat_AmountTheFineTab
                                   ON MIFloat_AmountTheFineTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountTheFineTab.DescId = zc_MIFloat_AmountTheFineTab()

       LEFT JOIN MovementItemFloat AS MIFloat_BonusAmountTab
                                   ON MIFloat_BonusAmountTab.MovementItemId = MovementItem.Id
                                  AND MIFloat_BonusAmountTab.DescId = zc_MIFloat_BonusAmountTab()

       LEFT JOIN MovementItemFloat AS MIFloat_MarkRatio
                                   ON MIFloat_MarkRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_MarkRatio.DescId = zc_MIFloat_MarkRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevAverageCheck
                                   ON MIFloat_PrevAverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevAverageCheck.DescId = zc_MIFloat_PrevAverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheck
                                   ON MIFloat_AverageCheck.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheck.DescId = zc_MIFloat_AverageCheck()

       LEFT JOIN MovementItemFloat AS MIFloat_AverageCheckRatio
                                   ON MIFloat_AverageCheckRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_AverageCheckRatio.DescId = zc_MIFloat_AverageCheckRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_PrevNumberChecks
                                   ON MIFloat_PrevNumberChecks.MovementItemId = MovementItem.Id
                                  AND MIFloat_PrevNumberChecks.DescId = zc_MIFloat_PrevNumberChecks()

       LEFT JOIN MovementItemFloat AS MIFloat_NumberChecks
                                   ON MIFloat_NumberChecks.MovementItemId = MovementItem.Id
                                  AND MIFloat_NumberChecks.DescId = zc_MIFloat_NumberChecks()

       LEFT JOIN MovementItemFloat AS MIFloat_NumberChecksRatio
                                   ON MIFloat_NumberChecksRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_NumberChecksRatio.DescId = zc_MIFloat_NumberChecksRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimePenalty
                                   ON MIFloat_LateTimePenalty.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimePenalty.DescId = zc_MIFloat_LateTimePenalty()

       LEFT JOIN MovementItemFloat AS MIFloat_LateTimeRatio
                                   ON MIFloat_LateTimeRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_LateTimeRatio.DescId = zc_MIFloat_LateTimeRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlan
                                   ON MIFloat_FinancPlan.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlan.DescId = zc_MIFloat_FinancPlan()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanFact
                                   ON MIFloat_FinancPlanFact.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanFact.DescId = zc_MIFloat_FinancPlanFact()

       LEFT JOIN MovementItemFloat AS MIFloat_FinancPlanRatio
                                   ON MIFloat_FinancPlanRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_FinancPlanRatio.DescId = zc_MIFloat_FinancPlanRatio()

       LEFT JOIN tmpTestingUser AS TestingUser
                                ON TestingUser.UserId = MovementItem.ObjectId

       LEFT JOIN MovementItemFloat AS MIFloat_IT_ExamRatio
                                   ON MIFloat_IT_ExamRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_IT_ExamRatio.DescId = zc_MIFloat_IT_ExamRatio()

       LEFT JOIN MovementItemFloat AS MIFloat_ComplaintsRatio
                                   ON MIFloat_ComplaintsRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ComplaintsRatio.DescId = zc_MIFloat_ComplaintsRatio()

       LEFT JOIN MovementItemString AS MIString_ComplaintsNote
                                    ON MIString_ComplaintsNote.MovementItemId = MovementItem.Id
                                   AND MIString_ComplaintsNote.DescId = zc_MIString_ComplaintsNote()

       LEFT JOIN MovementItemFloat AS MIFloat_DirectorRatio
                                   ON MIFloat_DirectorRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_DirectorRatio.DescId = zc_MIFloat_DirectorRatio()

       LEFT JOIN MovementItemString AS MIString_DirectorNote
                                    ON MIString_DirectorNote.MovementItemId = MovementItem.Id
                                   AND MIString_DirectorNote.DescId = zc_MIString_DirectorNote()

       LEFT JOIN MovementItemFloat AS MIFloat_YuriIT
                                   ON MIFloat_YuriIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_YuriIT.DescId = zc_MIFloat_YuriIT()

       LEFT JOIN MovementItemFloat AS MIFloat_OlegIT
                                   ON MIFloat_OlegIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_OlegIT.DescId = zc_MIFloat_OlegIT()

       LEFT JOIN MovementItemFloat AS MIFloat_MaximIT
                                   ON MIFloat_MaximIT.MovementItemId = MovementItem.Id
                                  AND MIFloat_MaximIT.DescId = zc_MIFloat_MaximIT()

       LEFT JOIN MovementItemFloat AS MIFloat_CollegeITRatio
                                   ON MIFloat_CollegeITRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_CollegeITRatio.DescId = zc_MIFloat_CollegeITRatio()

       LEFT JOIN MovementItemString AS MIString_CollegeITNote
                                    ON MIString_CollegeITNote.MovementItemId = MovementItem.Id
                                   AND MIString_CollegeITNote.DescId = zc_MIString_CollegeITNote()

       LEFT JOIN MovementItemFloat AS MIFloat_VIPDepartRatio
                                   ON MIFloat_VIPDepartRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_VIPDepartRatio.DescId = zc_MIFloat_VIPDepartRatio()

       LEFT JOIN MovementItemString AS MIString_VIPDepartRatioNote
                                    ON MIString_VIPDepartRatioNote.MovementItemId = MovementItem.Id
                                   AND MIString_VIPDepartRatioNote.DescId = zc_MIString_VIPDepartRatioNote()

       LEFT JOIN MovementItemFloat AS MIFloat_Romanova
                                   ON MIFloat_Romanova.MovementItemId = MovementItem.Id
                                  AND MIFloat_Romanova.DescId = zc_MIFloat_Romanova()

       LEFT JOIN MovementItemFloat AS MIFloat_Golovko
                                   ON MIFloat_Golovko.MovementItemId = MovementItem.Id
                                  AND MIFloat_Golovko.DescId = zc_MIFloat_Golovko()

       LEFT JOIN MovementItemFloat AS MIFloat_ControlRGRatio
                                   ON MIFloat_ControlRGRatio.MovementItemId = MovementItem.Id
                                  AND MIFloat_ControlRGRatio.DescId = zc_MIFloat_ControlRGRatio()

       LEFT JOIN MovementItemString AS MIString_ControlRGNote
                                    ON MIString_ControlRGNote.MovementItemId = MovementItem.Id
                                   AND MIString_ControlRGNote.DescId = zc_MIString_ControlRGNote()

  WHERE Movement.OperDate = vbDateStart
    AND Movement.DescId = zc_Movement_KPU()
    AND COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) <> 5062797
  ORDER BY Object_Member.ValueData;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 01.10.19         *
 25.06.19         *
 28.01.19         *
 09.01.19         *
 25.11.18         *
 13.11.18         *
 12.11.18         *
 05.11.18         *
 15.10.18         *
 03.10.18         *
*/

-- тест
-- select * from gpReport_KPU(inStartDate := ('01.09.2019')::TDateTime ,  inRecount := True, inSession := '3');