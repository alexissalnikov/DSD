-- Function: gpUpdate_MI_PersonalService_CardSecond()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_CardSecond (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_CardSecond(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbServiceDateId Integer;
   DECLARE vbPersonalServiceListId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE(inMovementId,0) = 0
     THEN
         RAISE EXCEPTION '������. �������� �� ��������';
     END IF;
 
     -- ���������� <����� ����������>
     vbServiceDateId:= lpInsertFind_Object_ServiceDate (inOperDate:= (SELECT MovementDate.ValueData FROM MovementDate WHERE MovementDate.MovementId = inMovementId AND MovementDate.DescId = zc_MIDate_ServiceDate()));

     -- ���������� <���������> - ��� � ������� ������ ���� �����������
     vbPersonalServiceListId := (SELECT MLO_PersonalServiceList.ObjectId 
                                 FROM MovementLinkObject AS MLO_PersonalServiceList
                                 WHERE MLO_PersonalServiceList.MovementId = inMovementId
                                   AND MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList());

     -- ����� ������ - MovementItem
     CREATE TEMP TABLE _tmpMI (MovementItemId Integer, PersonalId Integer, UnitId Integer, PositionId Integer, InfoMoneyId Integer, PersonalServiceListId Integer, SummCardSecondRecalc TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpMI (MovementItemId, PersonalId, UnitId, PositionId, InfoMoneyId, PersonalServiceListId, SummCardSecondRecalc)
           WITH -- ��� ���������� �� vbPersonalServiceListId - �� ��� � ����� ������������� ����
                tmpPersonal AS (SELECT ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId AS PersonalId
                                     , ObjectLink_Personal_Unit.ChildObjectId                     AS UnitId
                                     , ObjectLink_Personal_Position.ChildObjectId                 AS PositionId
                                     , zc_Enum_InfoMoney_60101()                                  AS InfoMoneyId  -- 60101 ���������� �����
                                     , ObjectLink_Personal_PersonalServiceList.ChildObjectId      AS PersonalServiceListId
                                FROM ObjectLink AS ObjectLink_Personal_PersonalServiceListCardSecond
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                          ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                         AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                          ON ObjectLink_Personal_Unit.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                         AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                     LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                          ON ObjectLink_Personal_PersonalServiceList.ObjectId = ObjectLink_Personal_PersonalServiceListCardSecond.ObjectId
                                                         AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                WHERE ObjectLink_Personal_PersonalServiceListCardSecond.ChildObjectId = vbPersonalServiceListId
                                  AND ObjectLink_Personal_PersonalServiceListCardSecond.DescId        = zc_ObjectLink_Personal_PersonalServiceListCardSecond()
                                )
                                
                -- ������� ��������
              , tmpMI AS (SELECT MovementItem.Id                                        AS MovementItemId
                               , MovementItem.ObjectId                                  AS PersonalId
                               , MILinkObject_Unit.ObjectId                             AS UnitId
                               , MILinkObject_Position.ObjectId                         AS PositionId
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Unit.ObjectId, MILinkObject_Position.ObjectId ORDER BY MovementItem.Id ASC) AS Ord
                          FROM MovementItem
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                                                ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Position.DescId         = zc_MILinkObject_Position()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
         -- ����� ����������� - ������������ MovementItemId, ������ ������ ����
       , tmpListPersonal AS (SELECT tmpMI.MovementItemId                                  AS MovementItemId
                                  , COALESCE (tmpPersonal.PersonalId,  tmpMI.PersonalId)  AS PersonalId
                                  , COALESCE (tmpPersonal.UnitId,      tmpMI.UnitId)      AS UnitId
                                  , COALESCE (tmpPersonal.PositionId,  tmpMI.PositionId)  AS PositionId
                                    -- ���� ����� ����� - ������ ��� ������ �������
                                  , tmpPersonal.InfoMoneyId                               AS InfoMoneyId
                                    -- ���� ����� ����� - ������ ��� ������ �������
                                  , tmpPersonal.PersonalServiceListId                     AS PersonalServiceListId
                             FROM tmpMI
                                  FULL JOIN tmpPersonal ON tmpPersonal.PersonalId = tmpMI.PersonalId
                                                       AND tmpPersonal.PositionId = tmpMI.PositionId
                                                       AND tmpPersonal.UnitId     = tmpMI.UnitId
                                                       AND tmpMI.Ord              = 1
                                  
                            )
         -- ������ Container - ��� ������ � ��������� - ������� ��� ���������
       , tmpContainer AS (SELECT CLO_ServiceDate.ContainerId
                               , tmpMI.PersonalId
                               , tmpMI.UnitId
                               , tmpMI.PositionId
                               , tmpMI.InfoMoneyId
                          FROM tmpListPersonal AS tmpMI
                               INNER JOIN ContainerLinkObject AS CLO_ServiceDate
                                                              ON CLO_ServiceDate.ObjectId = vbServiceDateId
                                                             AND CLO_ServiceDate.DescId   = zc_ContainerLinkObject_ServiceDate()
                               INNER JOIN ContainerLinkObject AS CLO_Personal
                                                              ON CLO_Personal.ObjectId    = tmpMI.PersonalId
                                                             AND CLO_Personal.DescId      = zc_ContainerLinkObject_Personal()
                                                             AND CLO_Personal.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_InfoMoney
                                                              ON CLO_InfoMoney.ObjectId    = tmpMI.InfoMoneyId
                                                             AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()
                                                             AND CLO_InfoMoney.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_Unit
                                                              ON CLO_Unit.ObjectId    = tmpMI.UnitId
                                                             AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                             AND CLO_Unit.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_Position
                                                              ON CLO_Position.ObjectId    = tmpMI.PositionId
                                                             AND CLO_Position.DescId      = zc_ContainerLinkObject_Position()
                                                             AND CLO_Position.ContainerId = CLO_ServiceDate.ContainerId
                               INNER JOIN ContainerLinkObject AS CLO_PersonalServiceList
                                                              ON CLO_PersonalServiceList.ObjectId    = tmpMI.PersonalServiceListId
                                                             AND CLO_PersonalServiceList.DescId      = zc_ContainerLinkObject_PersonalServiceList()
                                                             AND CLO_PersonalServiceList.ContainerId = CLO_ServiceDate.ContainerId
                         )
       -- ������ �������� - ������� ��� ��������� (�������)
     , tmpMIContainer AS (SELECT SUM (COALESCE (MIContainer.Amount, 0))  AS Amount
                               , tmpContainer.PersonalId
                               , tmpContainer.UnitId
                               , tmpContainer.PositionId
                               , tmpContainer.InfoMoneyId
                          FROM tmpContainer
                               INNER JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                               AND MIContainer.DescId      = zc_MIContainer_Summ()
                          GROUP BY tmpContainer.PersonalId
                                 , tmpContainer.UnitId
                                 , tmpContainer.PositionId
                                 , tmpContainer.InfoMoneyId
                         )
            -- ���������
            SELECT tmpListPersonal.MovementItemId
                 , tmpListPersonal.PersonalId
                 , tmpListPersonal.UnitId
                 , tmpListPersonal.PositionId
                 , tmpListPersonal.InfoMoneyId
                 , tmpListPersonal.PersonalServiceListId
                 , -1 * COALESCE (tmpMIContainer.Amount, 0) AS SummCardSecondRecalc -- �.�. � ��������� ���� � �������
            FROM tmpListPersonal
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PersonalId  = tmpListPersonal.PersonalId
                                         AND tmpMIContainer.UnitId      = tmpListPersonal.UnitId
                                         AND tmpMIContainer.PositionId  = tmpListPersonal.PositionId
                                         AND tmpMIContainer.InfoMoneyId = tmpListPersonal.InfoMoneyId
            WHERE tmpListPersonal.MovementItemId > 0 
               OR tmpMIContainer.Amount          < 0 -- !!! �.�. ���� ���� ���� �� ��
          ;
 
     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItem_PersonalService (ioId                 := _tmpMI.MovementItemId
                                                        , inMovementId         := inMovementId
                                                        , inPersonalId         := _tmpMI.PersonalId
                                                        , inIsMain             := COALESCE (ObjectBoolean_Main.ValueData, FALSE)
                                                        , inSummService        := 0
                                                        , inSummCardRecalc     := 0
                                                        , inSummCardSecondRecalc:= _tmpMI.SummCardSecondRecalc
                                                        , inSummCardSecondCash := 0
                                                        , inSummNalogRecalc    := 0
                                                        , inSummMinus          := 0
                                                        , inSummAdd            := 0
                                                        , inSummHoliday        := 0
                                                        , inSummSocialIn       := 0
                                                        , inSummSocialAdd      := 0
                                                        , inSummChildRecalc    := 0
                                                        , inSummMinusExtRecalc := 0
                                                        , inComment            := ''
                                                        , inInfoMoneyId        := _tmpMI.InfoMoneyId
                                                        , inUnitId             := _tmpMI.UnitId
                                                        , inPositionId         := _tmpMI.PositionId
                                                        , inMemberId           := NULL
                                                        , inPersonalServiceListId := _tmpMI.PersonalServiceListId
                                                        , inUserId             := vbUserId
                                                         )
     FROM _tmpMI
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                  ON ObjectBoolean_Main.ObjectId = _tmpMI.PersonalId
                                 AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main()
     ;
     

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.06.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_PersonalService_CardSecond (inMovementId :=0, inSession :='3':: TVarChar)