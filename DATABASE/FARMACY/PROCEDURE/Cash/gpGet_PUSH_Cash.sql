-- Function: gpGet_PUSH_Cash(TVarChar)

DROP FUNCTION IF EXISTS gpGet_PUSH_Cash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PUSH_Cash(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Text TBlob,
               FormName TVarChar, Button TVarChar, Params TVarChar, TypeParams TVarChar, ValueParams TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbEmployeeShow Boolean;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    CREATE TEMP TABLE _PUSH (Id  Integer
                           , Text TBlob
                           , FormName TVarChar
                           , Button TVarChar
                           , Params TVarChar
                           , TypeParams TVarChar
                           , ValueParams TVarChar) ON COMMIT DROP;

     -- ������� ������������
    IF vbRetailId = 4 AND
       EXISTS(SELECT COALESCE (ObjectBoolean_NotSchedule.ValueData, False)
              FROM Object AS Object_User
                   LEFT JOIN ObjectLink AS ObjectLink_User_Member
                          ON ObjectLink_User_Member.ObjectId = Object_User.Id
                         AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_NotSchedule
                                           ON ObjectBoolean_NotSchedule.ObjectId = ObjectLink_User_Member.ChildObjectId
                                          AND ObjectBoolean_NotSchedule.DescId = zc_ObjectBoolean_Member_NotSchedule()
              WHERE Object_User.Id = vbUserId
                AND COALESCE (ObjectBoolean_NotSchedule.ValueData, False) = False)
    THEN
      vbEmployeeShow := True;
      IF EXISTS(SELECT 1 FROM Movement
                WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                AND Movement.DescId = zc_Movement_EmployeeSchedule())
      THEN

        SELECT Movement.ID
        INTO vbMovementID
        FROM Movement
        WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
          AND Movement.DescId = zc_Movement_EmployeeSchedule();

        IF EXISTS(SELECT 1 FROM MovementItem AS MIMaster
                         INNER JOIN MovementItem AS MIChild
                                                 ON MIChild.MovementId = vbMovementID
                                                AND MIChild.DescId = zc_MI_Child()
                                                AND MIChild.ParentId = MIMaster.ID
                                                AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer
                         LEFT JOIN MovementItemDate AS MIDate_Start
                                                     ON MIDate_Start.MovementItemId = MIChild.Id
                                                    AND MIDate_Start.DescId = zc_MIDate_Start()

                         LEFT JOIN MovementItemDate AS MIDate_End
                                                    ON MIDate_End.MovementItemId = MIChild.Id
                                                   AND MIDate_End.DescId = zc_MIDate_End()

                         LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                       ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                      AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()
                  WHERE MIMaster.MovementId = vbMovementID
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId
                    AND (COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE
                     OR MIBoolean_ServiceExit.ValueData IS NOT NULL AND MIDate_End.ValueData IS NOT NULL))
           OR
           EXISTS(SELECT 1 
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = MIMaster.MovementId
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1

                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                                                  AND MIDate_End.ValueData > date_trunc('day', CURRENT_DATE)


                  WHERE MIMaster.MovementId = (SELECT Movement.ID
                                               FROM Movement
                                               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - interval '1 day')
                                                 AND Movement.DescId = zc_Movement_EmployeeSchedule() )
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId)                  
        THEN
          vbEmployeeShow := False;
        END IF;
      END IF;

     IF vbEmployeeShow = True AND vbRetailId = 4
     THEN
        INSERT INTO _PUSH (Id, Text) VALUES (1, '��������� �������, �� �������� ������� ��������� ������� ������� ������� � ����� � ������ (Ctrl+T), ������ �� ������������� ������� ������ (����� �������� � ����� 30 ���)');
     END IF;
   END IF;

   -- ����������� �� �������� ����� � ����������
   IF vbUnitId in (9951517, 375627, 183289)
     AND date_part('HOUR',  CURRENT_TIME)::Integer = 17
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 30
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 50
   THEN
      INSERT INTO _PUSH (Id, Text) VALUES (2, '� ����� �������� ��� ��������� ����������� ��������, ��������� �� ����� � ����������! �� �������� ������  ��������� ����� ������ ��������������!"');
   END IF;

   -- ����������� �� ������������ �� ����� ���������
   IF EXISTS(SELECT 1 FROM Object AS Object_Unit

               INNER JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                        ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                                       AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()
                                      AND ObjectBoolean_DividePartionDate.ValueData = True

               INNER JOIN ObjectLink AS ObjectLink_Unit_UnitOverdue
                                     ON ObjectLink_Unit_UnitOverdue.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_UnitOverdue.DescId = zc_ObjectLink_Unit_UnitOverdue()
                                    AND COALESCE (ObjectLink_Unit_UnitOverdue.ChildObjectId, 0) <> 0

            WHERE Object_Unit.ID = vbUnitId)
   THEN
     -- ����������� �� ������������ �� ����� ��������� � �������
     IF date_part('DOW',     CURRENT_DATE)::Integer = 5
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 16
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
       INSERT INTO _PUSH (Id, Text) VALUES (3, '�������, ����������� ���, ��� �� ������� �� ����� �� ����� 4 ��������� (���������) ����� ������� ����������� �� ����������� ����� "�����", ���� ���� �������������, ������������ ������ �����!');
     END IF;

     -- ����������� �� ������������ �� ����� ��������� �� �������������
     IF date_part('DOW',     CURRENT_DATE)::Integer = 1
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 16
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
        IF EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                       INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = vbUnitId
                       INNER JOIN MovementItemContainer AS MIC 
                                                        ON MIC.Movementid = Movement.id
                  WHERE Movement.DescId = zc_Movement_Send()
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()) OR
           EXISTS(SELECT 1
                  FROM Container

                       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                              AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                  WHERE Container.DescId = zc_Container_CountPartionDate()
                    AND Container.WhereObjectId = vbUnitId
                    AND Container.Amount > 0
                    AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE + interval '1 day'
                    AND  COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
        THEN
          INSERT INTO _PUSH (Id, Text) VALUES (4, '�������, ����������� ���, ��� ������ �� ����� �� ����� 4 ��������� (���������) ����� ������� ����������� �� ����������� ����� "�����"!!!');
        END IF;
     END IF;

     -- ����������� �� ������������ �� ����� ��������� �� ���������
     IF date_part('DOW',     CURRENT_DATE)::Integer = 2
       AND date_part('HOUR',    CURRENT_TIME)::Integer = 11
       AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
       AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
     THEN
        IF EXISTS(SELECT 1
                  FROM Movement

                       INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                     ON MovementLinkObject_PartionDateKind.MovementId =  Movement.Id
                                                    AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
                                                    AND MovementLinkObject_PartionDateKind.ObjectId = zc_Enum_PartionDateKind_0()

                       INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                    AND MovementLinkObject_From.ObjectId = vbUnitId
                       INNER JOIN MovementItemContainer AS MIC
                                                        ON MIC.Movementid = Movement.id
                  WHERE Movement.DescId = zc_Movement_Send()
                    AND Movement.StatusId = zc_Enum_Status_UnComplete()) OR
           EXISTS(SELECT 1
                  FROM Container

                       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = Container.ObjectId

                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                       LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                            ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                           AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                       LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                               ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId
                                              AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()

                  WHERE Container.DescId = zc_Container_CountPartionDate()
                    AND Container.WhereObjectId = vbUnitId
                    AND Container.Amount > 0
                    AND ObjectDate_ExpirationDate.ValueData <= CURRENT_DATE
                    AND  COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, FALSE) = FALSE)
        THEN
          INSERT INTO _PUSH (Id, Text) VALUES (4, '�������, ������� ����� ������������ ����������� �� ����������� ����� "�����", �� ������� ��������� "����������� ���� "�����" ������ ����������� - �������,168"');
        END IF;
     END IF;
   END IF;

   -- ����������� �� ��� �������� "������ ����������� ���"
   IF EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData  = TRUE
                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                               AND MovementLinkObject_From.ObjectId = vbUnitId
             WHERE Movement.DescId   = zc_Movement_Send()
               AND Movement.OperDate = CURRENT_DATE
               AND Movement.StatusId = zc_Enum_Status_Erased()
            )
      AND (DATE_PART('HOUR',    CURRENT_TIME)::Integer <= 12
        OR (DATE_PART('HOUR',    CURRENT_TIME)::Integer > 12
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer >= 00
        AND DATE_PART('MINUTE',  CURRENT_TIME)::Integer <= 16
           ))
      AND vbUnitId NOT IN (
--                         183289 -- 2;"��_2 ��_��.���������� (������� ��������)_111 ��������_5";f;
                           183290 -- 3;"�� 3, ��.��������� 13 (������ N1, ������ ��)";f;
                         , 183291 -- 4;"��_4 ��_��������_6� ��������_4";f;
                         , 394426 -- 25;"������_2 �_�_�������� (����������)_5�";f;
--                       , 494882 -- 30;"������_3 ��_���������� ���������_73�";f;
--                       , 1781716 -- 34;"������_2 ��_��������_9_(����-2)";f;
--                       , 6309262 -- 57;"������_3 ��_�������_1";f;
--                       , 8393158 -- 69;"������_3 ���_��������_10";f;
                         , 8698426 -- 70;"��_1 ��.������_22";f;
                         , 9771036 -- 74;"������_4 ��.������_17";f;
--                       , 10779386 -- 82;"������ 3 ��.�.���������� ��� 1 (����-4)";f;
                         , 11300059 -- 85;"�� 1 ��.�. ���� 141� (Medical Plaza)";f;
--                       , 11769526 -- 87;"������ 3 ��.���������� 1";f;
                         , 12607257 -- 88;"������ 4 ��.���� 14"
                          )
   THEN
      IF (SELECT COUNT(*)
          FROM  Movement
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData = True
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()) = 1
      THEN
        INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
          SELECT 6, '�������, ������� ���� ������������ ����������� �� ��� �� ���, ������������ � �������� � "������������"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'������� ������� ����� ������� �� 12:00!' ELSE '' END,
                    'TSendForm', '����������� ���', 'Id,inOperDate', 'ftInteger,ftDateTime',
                    Movement.ID::TVarChar||','||CURRENT_DATE::TVarChar
          FROM  Movement
                INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                           ON MovementBoolean_SUN.MovementId = Movement.Id
                                          AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                          AND MovementBoolean_SUN.ValueData = True
                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                            AND MovementLinkObject_From.ObjectId = vbUnitId
          WHERE Movement.DescId = zc_Movement_Send()
            AND Movement.OperDate = CURRENT_DATE
            AND Movement.StatusId = zc_Enum_Status_Erased()
          LIMIT 1;
      ELSE
        INSERT INTO _PUSH (Id, Text, FormName, Button, Params, TypeParams, ValueParams)
        VALUES (6, '�������, ������� ���� ������������ ����������� �� ��� �� ���, ������������ � �������� � "������������"!'||
                    CASE WHEN date_part('DOW',     CURRENT_DATE)::Integer <= 5
                          AND date_part('HOUR',    CURRENT_TIME)::Integer < 12
                         THEN Chr(13)||Chr(13)||'������� ������� ����� ������� �� 12:00!' ELSE '' END,
                   'TSendCashJournalSunForm', '������ ����������� ���', 'isSUNAll', 'ftBoolean', 'False');
      END IF;
   END IF;

     -- �������, ��������, �� ��� ������� ����������� �� ���!. ����� ����������
   IF EXISTS(SELECT 1
             FROM  Movement
                   INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                              ON MovementBoolean_SUN.MovementId = Movement.Id
                                             AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                             AND MovementBoolean_SUN.ValueData = True
                   INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                              ON MovementBoolean_Sent.MovementId = Movement.Id
                                             AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                             AND MovementBoolean_Sent.ValueData = True
                   LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                              ON MovementBoolean_Received.MovementId = Movement.Id
                                             AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                   INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                 ON MovementLinkObject_To.MovementId = Movement.Id
                                                AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                AND MovementLinkObject_To.ObjectId = vbUnitId
                   INNER JOIN MovementDate AS MovementDate_Sent
                                           ON MovementDate_Sent.MovementId = Movement.Id
                                          AND MovementDate_Sent.DescId = zc_MovementDate_Sent()
                                          AND MovementDate_Sent.ValueData >= CURRENT_TIMESTAMP - INTERVAL '20 MIN'
             WHERE Movement.DescId = zc_Movement_Send()
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND COALESCE (MovementBoolean_Received.ValueData, False) = False)
   THEN
     INSERT INTO _PUSH (Id, Text) VALUES (7, '�������, ��������, �� ��� ������� ����������� �� ���!');
   END IF;

     -- �������, ��������, �� ��� ������� ����������� �� ���!. � 16:00
   IF date_part('HOUR',    CURRENT_TIME)::Integer = 16
     AND date_part('MINUTE',  CURRENT_TIME)::Integer >= 00
     AND date_part('MINUTE',  CURRENT_TIME)::Integer <= 20
   THEN
      IF EXISTS(SELECT 1
                FROM  Movement
                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                 ON MovementBoolean_SUN.MovementId = Movement.Id
                                                AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                AND MovementBoolean_SUN.ValueData = True
                      INNER JOIN MovementBoolean AS MovementBoolean_Sent
                                                 ON MovementBoolean_Sent.MovementId = Movement.Id
                                                AND MovementBoolean_Sent.DescId = zc_MovementBoolean_Sent()
                                                AND MovementBoolean_Sent.ValueData = True
                      LEFT JOIN MovementBoolean AS MovementBoolean_Received
                                                ON MovementBoolean_Received.MovementId = Movement.Id
                                               AND MovementBoolean_Received.DescId = zc_MovementBoolean_Received()
                                               AND MovementBoolean_Received.ValueData = False
                      INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                    ON MovementLinkObject_To.MovementId = Movement.Id
                                                   AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                   AND MovementLinkObject_To.ObjectId = vbUnitId
                WHERE Movement.DescId = zc_Movement_Send()
                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                  AND COALESCE (MovementBoolean_Received.ValueData, False) = False)
      THEN
        INSERT INTO _PUSH (Id, Text) VALUES (8, '�������, ��������, �� ��� ������� ����������� �� ���!');
      END IF;
   END IF;

   -- PUSH �����������
   WITH tmpMovementItemUnit AS (SELECT DISTINCT Movement.Id AS MovementId
                                FROM Movement

                                    INNER JOIN MovementItem
                                           ON MovementItem.MovementId = Movement.Id
                                          AND MovementItem.DescId = zc_MI_Child()
                                          AND MovementItem.IsErased = False

                                    LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                                                           ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                                                          AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()

                                WHERE Movement.OperDate <= CURRENT_TIMESTAMP
                                  AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))
                                  AND Movement.DescId = zc_Movement_PUSH()
                                  AND Movement.StatusId = zc_Enum_Status_Complete())

   INSERT INTO _PUSH (Id, Text)
   SELECT
          Movement.Id                              AS ID
        , MovementBlob_Message.ValueData           AS Message

   FROM Movement

        LEFT JOIN MovementDate AS MovementDate_DateEndPUSH
                               ON MovementDate_DateEndPUSH.MovementId = Movement.Id
                              AND MovementDate_DateEndPUSH.DescId = zc_MovementDate_DateEndPUSH()

        LEFT JOIN MovementFloat AS MovementFloat_Replays
                                ON MovementFloat_Replays.MovementId = Movement.Id
                               AND MovementFloat_Replays.DescId = zc_MovementFloat_Replays()

        LEFT JOIN MovementBlob AS MovementBlob_Message
                               ON MovementBlob_Message.MovementId = Movement.Id
                              AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

        LEFT JOIN MovementBoolean AS MovementBoolean_Daily
                                  ON MovementBoolean_Daily.MovementId = Movement.Id
                                 AND MovementBoolean_Daily.DescId = zc_MovementBoolean_PUSHDaily()

        LEFT JOIN MovementItem AS MovementItem_Child
                               ON MovementItem_Child.MovementId = Movement.Id
                              AND MovementItem_Child.DescId = zc_MI_Child()
                              AND MovementItem_Child.ObjectId = vbUnitId

        LEFT JOIN tmpMovementItemUnit AS MovementItemUnit
                                      ON MovementItemUnit.MovementId = Movement.Id

   WHERE Movement.OperDate <= CURRENT_TIMESTAMP
     AND make_time(date_part('hour', Movement.OperDate)::integer, date_part('minute', Movement.OperDate)::integer, date_part('second', Movement.OperDate)::integer) <= CURRENT_TIME
     AND CURRENT_TIMESTAMP < COALESCE(MovementDate_DateEndPUSH.ValueData, date_trunc('day', Movement.OperDate + INTERVAL '1 DAY'))
     AND Movement.DescId = zc_Movement_PUSH()
     AND Movement.StatusId = zc_Enum_Status_Complete()
     AND (COALESCE(MovementItemUnit.MovementId, 0) = 0 OR COALESCE(MovementItem_Child.ObjectId, 0) = vbUnitId)
     AND (COALESCE (MovementBoolean_Daily.ValueData, FALSE) = FALSE
          AND COALESCE(MovementFloat_Replays.ValueData, 1) >
              COALESCE ((SELECT SUM(MovementItem.Amount)
                         FROM MovementItem
                         WHERE MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.ObjectId = vbUserId), 0)
          OR
          COALESCE (MovementBoolean_Daily.ValueData, FALSE) = TRUE
          AND COALESCE(MovementFloat_Replays.ValueData, 1) >
              COALESCE ((SELECT SUM(MovementItem.Amount)
                         FROM MovementItem

                              LEFT JOIN MovementItemDate AS MID_Viewed
                                     ON MID_Viewed.MovementItemId = MovementItem.Id
                                    AND MID_Viewed.DescId = zc_MIDate_Viewed()

                         WHERE MovementItem.MovementId = Movement.Id
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.ObjectId = vbUserId
                           AND MID_Viewed.ValueData >= CURRENT_DATE
                           AND MID_Viewed.ValueData < CURRENT_DATE + INTERVAL '1 DAY'), 0));


   RETURN QUERY
     SELECT _PUSH.Id                     AS Id
          , _PUSH.Text                   AS Text
          , _PUSH.FormName               AS FormName
          , _PUSH.Button                 AS Button
          , _PUSH.Params                 AS Params
          , _PUSH.TypeParams             AS TypeParams
          , _PUSH.ValueParams            AS ValueParams
     FROM _PUSH;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.09.19                                                       *
 05.08.19                                                       *
 25.07.19                                                       *
 11.05.19                                                       *
 13.03.18                                                       *
 04.03.18                                                       *

*/

-- ����
-- SELECT * FROM gpGet_PUSH_Cash('3')
