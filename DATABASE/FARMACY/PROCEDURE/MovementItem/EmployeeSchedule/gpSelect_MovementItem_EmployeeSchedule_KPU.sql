-- Function: gpSelect_MovementItem_EmployeeSchedule_KPU()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_EmployeeSchedule_KPU(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_EmployeeSchedule_KPU(
    IN inDate        TDateTime    ,
    IN inSession     TVarChar    -- ������ ������������
)
  RETURNS TABLE (UserID Integer,
                 Date TDateTime,
                 Value TVarChar,
                 TimeIn Time
               )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     vbOperDate:= DATE_TRUNC ('MONTH', inDate);

     IF EXISTS (SELECT ID FROM Movement WHERE DescId = zc_Movement_EmployeeSchedule() AND OperDate = vbOperDate)
     THEN
       SELECT ID INTO vbMovementId FROM Movement WHERE DescId = zc_Movement_EmployeeSchedule() AND OperDate = vbOperDate;
     ELSE
       vbMovementId := Null;
     END IF;

     IF COALESCE (vbMovementId, 0) = 0
     THEN
        RAISE EXCEPTION '������. �� ������ ������ ������ ����������� �� <%>.', vbOperDate;
     END IF;


     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     IF vbOperDate < '01.09.2019'
     THEN

       RETURN QUERY
       WITH tmpEmployeeSchedule AS (SELECT
           MovementItem.ObjectId                                                    AS UserID,
           tmpOperDate.OperDate::TDateTime                                          AS Date,
           lpDecodeValueDay(date_part('DAY', tmpOperDate.OperDate)::Integer , MIString_ComingValueDay.ValueData)  AS Value
         FROM tmpOperDate

              LEFT JOIN MovementItem ON MovementItem.MovementID = vbMovementId
                                    AND MovementItem.IsErased = FALSE
                                    AND MovementItem.DescId = zc_MI_Master()

              LEFT JOIN MovementItemString AS MIString_ComingValueDay
                                           ON MIString_ComingValueDay.DescId = zc_MIString_ComingValueDay()
                                          AND MIString_ComingValueDay.MovementItemId = MovementItem.Id)

       SELECT tmpEmployeeSchedule.UserID,
              tmpEmployeeSchedule.Date,
              tmpEmployeeSchedule.Value,
              CASE WHEN tmpEmployeeSchedule.Value is Null OR tmpEmployeeSchedule.Value = '�' THEN '8:00'::Time
              ELSE tmpEmployeeSchedule.Value::TIME END AS TimeIn
       FROM tmpEmployeeSchedule;
     ELSE

       RETURN QUERY
       SELECT MIMaster.ObjectID                       AS UserID,
              tmpOperDate.OperDate::TDateTime         AS Date,
              CASE WHEN MIDate_Start.ValueData IS NOT NULL
                THEN TO_CHAR(MIDate_Start.ValueData, 'HH24:mi')  ELSE '�' END::TVarChar   AS Value,
              MIDate_Start.ValueData::Time            AS TimeIn
       FROM tmpOperDate

            LEFT JOIN MovementItem AS MIMaster
                                   ON MIMaster.MovementID = vbMovementId
                                  AND MIMaster.IsErased = FALSE
                                  AND MIMaster.DescId = zc_MI_Master()

            LEFT JOIN MovementItem AS MIChild
                                   ON MIChild.MovementID = vbMovementId
                                  AND MIChild.ParentID = MIMaster.ID
                                  AND MIChild.Amount = date_part('DAY',  tmpOperDate.OperDate)
                                  AND MIChild.IsErased = FALSE
                                  AND MIChild.DescId = zc_MI_Child()

            LEFT JOIN MovementItemDate AS MIDate_Start
                                       ON MIDate_Start.MovementItemId = MIChild.Id
                                      AND MIDate_Start.DescId = zc_MIDate_Start();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_EmployeeSchedule_KPU (TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 01.10.19                                                       *
 11.01.19                                                       *
 09.01.19                                                       *
*/

-- ����
-- select * from gpSelect_MovementItem_EmployeeSchedule_KPU(inDate:= '01.09.2019', inSession := '4183126');