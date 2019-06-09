 -- Function: lpInsertUpdate_MovementItemLinkContainer ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItemLinkContainer (Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkContainer(
    IN inMovementItemId    Integer  , -- ���� ������ ���������
   OUT outMessageText      Text     ,
    IN inUserId            Integer    -- ������������
)
RETURNS Text
AS
$BODY$
   DECLARE vbMovementId        Integer; -- ���� ���������
   DECLARE vbStatusId          Integer ;
   DECLARE vbGoodsID           Integer ;
   DECLARE vbPartionDateKindID Integer ; -- ��� ����/�� ����
   DECLARE vbAmount            TFloat ;
   DECLARE vbUnitId            Integer;

   DECLARE vbMonth_0           TFloat;
   DECLARE vbMonth_1           TFloat;
   DECLARE vbMonth_6           TFloat;

   DECLARE vbDate0             TDateTime;
   DECLARE vbDate180           TDateTime;
   DECLARE vbDate30            TDateTime;

   DECLARE vbRemains           refcursor;
   DECLARE vbContainerId       Integer;
   DECLARE vbContainerAmount   TFloat;
   DECLARE vbMovChildId        Integer;
BEGIN

  outMessageText := '';

  -- ��������� ������� �� ���������
  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION '�������� �� ��������';
  END IF;

  SELECT Movement.Id, Movement.StatusId, MovementLinkObject_Unit.ObjectId,
         MovementItem.ObjectId, MI_PartionDateKind.ObjectId, MovementItem.Amount
  INTO vbMovementId, vbStatusId, vbUnitId,
         vbGoodsID, vbPartionDateKindID, vbAmount
  FROM MovementItem

       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = Movement.Id
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

       LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                        ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                       AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()

  WHERE MovementItem.ID = inMovementItemId;

  -- �������� - �����������/��������� ��������� �������� ������
  IF vbStatusId <> zc_Enum_Status_UnComplete()
  THEN
      RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
  END IF;

  IF COALESCE (vbPartionDateKindID, 0) = 0
  THEN
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId)
    THEN
      UPDATE MovementItem SET isErased = True, Amount = 0
      WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId;
    END IF;

    RETURN;
  END IF;

  IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId)
  THEN
    UPDATE MovementItem SET ObjectId = vbGoodsID WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                                   AND MovementItem.ParentId = inMovementItemId AND MovementItem.ObjectId <> vbGoodsID;
    IF (SELECT SUM(MovementItem.Amount)  FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                                             AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = FALSE) = vbAmount
    THEN
      RETURN;
    END IF;

    UPDATE MovementItem SET ObjectId = vbGoodsID, isErased = TRUE, Amount = 0
    WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemId;
  END IF;


  -- �������� �������� �� ����������� ��� ���������� �� ������
  vbMonth_0 := (SELECT ObjectFloat_Month.ValueData
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                           ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
  vbMonth_1 := (SELECT ObjectFloat_Month.ValueData
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                           ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
  vbMonth_6 := (SELECT ObjectFloat_Month.ValueData
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                           ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

  -- ���� + 6 �������, + 1 �����
  vbDate180 := CURRENT_DATE + (vbMonth_6||' MONTH' ) ::INTERVAL;
  vbDate30  := CURRENT_DATE + (vbMonth_1||' MONTH' ) ::INTERVAL;
  vbDate0   := CURRENT_DATE + (vbMonth_0||' MONTH' ) ::INTERVAL;




  OPEN vbRemains FOR
  WITH  -- ������� �� ������
       tmpPDContainer AS (SELECT Container.Id, Container.Amount
                          FROM Container
                          WHERE Container.DescId = zc_Container_CountPartionDate()
                            AND Container.WhereObjectId = vbUnitId
                            AND Container.ObjectId = vbGoodsID
                            AND Container.Amount <> 0)
     , tmpPDCLO AS (SELECT CLO.*
                  FROM ContainerlinkObject AS CLO
                  WHERE CLO.ContainerId IN (SELECT DISTINCT tmpPDContainer.Id FROM tmpPDContainer)
                    AND CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                 )
     , tmpPDObject AS (SELECT Object.* FROM Object WHERE Object.Id IN (SELECT DISTINCT tmpPDCLO.ObjectId FROM tmpPDCLO))

     , tmpPDMIDate AS (SELECT MovementItemDate.*
                     FROM MovementItemDate
                     WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpPDObject.ObjectCode FROM tmpPDObject)
                       AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                    )
     , tmpPDMIIncomeFind AS (SELECT MIFloat_MovementItem.MovementItemId        AS MovementItemId
                                  , MIFloat_MovementItem.ValueData::Integer    AS ID
                             FROM MovementItemFloat AS MIFloat_MovementItem
                             WHERE MIFloat_MovementItem.MovementItemId IN (SELECT DISTINCT tmpPDObject.ObjectCode FROM tmpPDObject)
                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId())
     , tmpPDMIDateFind AS (SELECT MovementItemDate.*
                           FROM MovementItemDate
                           WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpPDMIIncomeFind.ID FROM tmpPDMIIncomeFind)
                             AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                          )

     , tmpPDExpirationDate AS (SELECT tmpPDCLO.ContainerId, COALESCE(MIDate_ExpirationDateFind.ValueData, MIDate_ExpirationDate.ValueData) AS ExpirationDate
                               FROM tmpPDCLO
                                    LEFT JOIN tmpPDObject ON tmpPDObject.Id = tmpPDCLO.ObjectId
                                    LEFT JOIN tmpPDMIDate AS MIDate_ExpirationDate
                                                          ON MIDate_ExpirationDate.MovementItemId = tmpPDObject.ObjectCode
                                    LEFT JOIN tmpPDMIIncomeFind ON tmpPDMIIncomeFind.MovementItemId = tmpPDObject.ObjectCode
                                    LEFT JOIN tmpPDMIDateFind AS MIDate_ExpirationDateFind
                                                          ON MIDate_ExpirationDateFind.MovementItemId = tmpPDMIIncomeFind.Id
                              )
     , tmpPDGoodsRemains AS (SELECT Container.Id
                                  , Object_PartionDateKind.Id                                         AS PartionDateKindId
                                  , Container.Amount                                                  AS Amount
                                  , tmpPDExpirationDate.ExpirationDate::TDateTime                     AS MinExpirationDate
                             FROM tmpPDContainer AS Container

                                  LEFT JOIN tmpPDExpirationDate ON tmpPDExpirationDate.Containerid = Container.Id

                                  LEFT OUTER JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id =
                                       CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate0 THEN zc_Enum_PartionDateKind_0() ELSE       -- ����������
                                       CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate30 THEN zc_Enum_PartionDateKind_1() ELSE      -- ������ 1 ������
                                       CASE WHEN tmpPDExpirationDate.ExpirationDate <= vbDate180 THEN zc_Enum_PartionDateKind_6() ELSE     -- ������ 6 ������
                                       NULL END END END
                            )

  , tmpMov AS (
      SELECT Movement.Id
      FROM Movement
           INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        AND MovementLinkObject_Unit.ObjectId = vbUnitId
      WHERE Movement.DescId = zc_Movement_Check()
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
     )
, RESERVE
  AS
  (
      SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
           , Sum(MovementItemChild.Amount)::TFloat       AS Amount
      FROM tmpMov
                   INNER JOIN MovementItem AS MovementItemMaster
                                           ON MovementItemMaster.MovementId = tmpMov.Id
                                          AND MovementItemMaster.DescId     = zc_MI_Master()
                                          AND MovementItemMaster.isErased   = FALSE

                   INNER JOIN MovementItem AS MovementItemChild
                                           ON MovementItemChild.MovementId = tmpMov.Id
                                          AND MovementItemChild.ParentId = MovementItemMaster.Id
                                          AND MovementItemChild.DescId     = zc_MI_Child()
                                          AND MovementItemChild.Amount     > 0
                                          AND MovementItemChild.isErased   = FALSE

                   LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                               ON MIFloat_ContainerId.MovementItemId = MovementItemChild.Id
                                              AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
      GROUP BY MIFloat_ContainerId.ValueData
  )

  SELECT
         tmpPDGoodsRemains.ID
       , tmpPDGoodsRemains.Amount - COALESCE (RESERVE.Amount, 0) AS Amount
  FROM tmpPDGoodsRemains
       LEFT OUTER JOIN RESERVE ON RESERVE.ContainerId = tmpPDGoodsRemains.ID
  WHERE tmpPDGoodsRemains.PartionDateKindId = vbPartionDateKindId
    AND tmpPDGoodsRemains.Amount - COALESCE (RESERVE.Amount, 0) > 0
  ORDER BY tmpPDGoodsRemains.MinExpirationDate;

  LOOP
    FETCH vbRemains INTO vbContainerId, vbContainerAmount;
    IF NOT FOUND THEN EXIT; END IF;

    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                                           AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = TRUE)
    THEN
      SELECT Min(MovementItem.ID)
      INTO vbMovChildId
      FROM MovementItem WHERE MovementItem.MovementId = vbMovementId AND MovementItem.DescID = zc_MI_Child()
                          AND MovementItem.ParentId = inMovementItemId AND MovementItem.isErased = TRUE;
    ELSE
      INSERT INTO MovementItem (MovementId, DescID, ObjectId, ParentId, isErased, Amount)
      VALUES (vbMovementId, zc_MI_Child(), vbGoodsID, inMovementItemId, FALSE, 0)
      RETURNING Id INTO vbMovChildId;
    END IF;

    UPDATE MovementItem SET ObjectId = vbGoodsID, isErased = FALSE, Amount = CASE WHEN vbAmount > vbContainerAmount THEN vbContainerAmount ELSE vbAmount END
    WHERE ID = vbMovChildId;

    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContainerId(), vbMovChildId, vbContainerId);

    vbAmount := vbAmount - CASE WHEN vbAmount > vbContainerAmount THEN vbContainerAmount ELSE vbAmount END;

    IF vbAmount = 0 THEN EXIT; END IF;
  END LOOP;
  CLOSE vbRemains;

  IF vbAmount > 0
  THEN
    outMessageText:= '������.������ ��� � ������� ��� ������������ � ������ �� �����: ' || (SELECT OBJECT.ValueData FROM OBJECT WHERE ID = vbPartionDateKindId) ||
      ' ����� ' || (SELECT OBJECT.ValueData FROM OBJECT WHERE ID = vbGoodsID) || ' ��������� ' || zfConvert_FloatToString (vbAmount);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ������ �.�.
 03.06.19                                                                   *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := 129246402, inUserId := 3)
-- SELECT * FROM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := 129246398, inUserId := 3)

