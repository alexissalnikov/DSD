-- Function: gpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inFullInvent          Boolean   , -- ������ ��������������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUserUnitId Integer;
   DECLARE vbOldUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());
     
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
     THEN
     
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
        
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
        END IF;     
        
        IF COALESCE (ioId, 0) <> 0
        THEN

          SELECT 
            MLO_Unit.ObjectId 
          INTO
            vbOldUnitId
          FROM Movement
               INNER JOIN MovementLinkObject AS MLO_Unit
                                             ON MLO_Unit.MovementId = Movement.Id
                                            AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
          WHERE Movement.Id = ioId;

          IF COALESCE (vbOldUnitId, 0) <> COALESCE (inUnitId, 0)
          THEN
            RAISE EXCEPTION '������. ��������� ������������� ���������..';                       
          END IF;
        END IF;
        
        IF COALESCE (inUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION '������. �� ��������� �������������..';             
        END IF;     

        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
        THEN 
          RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
        
     END IF;     

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_IlliquidUnit (ioId               := ioId
                                              , inInvNumber        := inInvNumber
                                              , inOperDate         := inOperDate
                                              , inUnitId           := inUnitId
                                              , inFullInvent       := inFullInvent
                                              , inComment          := inComment
                                              , inUserId           := vbUserId
                                               );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.12.19                                                       *
*/