-- Function: gpGet_EmployeeSchedule_Ban_Cash(TVarChar)

DROP FUNCTION IF EXISTS gpGet_EmployeeSchedule_Ban_Cash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_EmployeeSchedule_Ban_Cash(
   OUT outBanCash    BOOLEAN, 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS BOOLEAN
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
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
    

    IF  EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
       OR vbRetailId <> 4
    THEN
      outBanCash := False;
      RETURN;
    ELSE
      outBanCash := True;
    END IF;

     -- ������� ������������
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
                       INNER JOIN MovementItemDate AS MIDate_Start
                                                   ON MIDate_Start.MovementItemId = MIChild.Id
                                                  AND MIDate_Start.DescId = zc_MIDate_Start()
                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                WHERE MIMaster.MovementId = vbMovementID
                  AND MIMaster.DescId = zc_MI_Master()
                  AND MIMaster.ObjectId = vbUserId) OR
        EXISTS(SELECT 1 FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = vbMovementID
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1
                       INNER JOIN MovementItemDate AS MIDate_Start
                                                   ON MIDate_Start.MovementItemId = MIChild.Id
                                                  AND MIDate_Start.DescId = zc_MIDate_Start()
                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                                                  AND MIDate_End.ValueData > CURRENT_DATE
                WHERE MIMaster.MovementId = vbMovementID
                  AND MIMaster.DescId = zc_MI_Master()
                  AND MIMaster.ObjectId = vbUserId)
      THEN
        outBanCash := False;
      END IF;
    ELSE 
      outBanCash := False;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.09.19                                                       *
*/

-- ����
-- SELECT * FROM gpGet_EmployeeSchedule_Ban_Cash('3')