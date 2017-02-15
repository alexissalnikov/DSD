
CREATE OR REPLACE FUNCTION zc_Object_Account() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Account'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Account', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Account');

CREATE OR REPLACE FUNCTION zc_Object_AccountDirection() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountDirection', '��������� ����� (�����)' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountDirection');

CREATE OR REPLACE FUNCTION zc_Object_AccountGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountGroup', '������ ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountGroup');

CREATE OR REPLACE FUNCTION zc_Object_AccountKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_AccountKind', '���� ������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_AccountKind');

CREATE OR REPLACE FUNCTION zc_Object_Action() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Action'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Action', '������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Action');

CREATE OR REPLACE FUNCTION zc_Object_Form() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Form'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Form', '����� ����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Form');


CREATE OR REPLACE FUNCTION zc_Object_GlobalConst() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_GlobalConst', '���������� ��������� ��� ������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_GlobalConst');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLink() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLink', '����� �������� ��� ��������, ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLink');

CREATE OR REPLACE FUNCTION zc_Object_ImportExportLinkType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportExportLinkType', '����� �������� ��� ��������, ��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportExportLinkType');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroup', '������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup');

CREATE OR REPLACE FUNCTION zc_Object_ImportGroupItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportGroupItems', '�������� ������ �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportGroupItems');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettings', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettings');

CREATE OR REPLACE FUNCTION zc_Object_ImportSettingsItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportSettingsItems', '��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportSettingsItems');

CREATE OR REPLACE FUNCTION zc_Object_ImportType() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportType'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportType', '���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportType');

CREATE OR REPLACE FUNCTION zc_Object_ImportTypeItems() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_ImportTypeItems', '�������� ���� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_ImportTypeItems');


CREATE OR REPLACE FUNCTION zc_Object_Measure() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Measure'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Measure', '������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Measure');


CREATE OR REPLACE FUNCTION zc_Object_Process() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Process'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Process', '��������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Process');

CREATE OR REPLACE FUNCTION zc_Object_Program() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Program'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Program', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Program');


CREATE OR REPLACE FUNCTION zc_Object_Role() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Role'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Role', '����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Role');

CREATE OR REPLACE FUNCTION zc_Object_RoleAction() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleAction', '����� ���� � ������� ������ ������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleAction');

CREATE OR REPLACE FUNCTION zc_Object_RoleProcessAccess() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleProcessAccess', '����� ����� � ��������� �������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleProcessAccess');

CREATE OR REPLACE FUNCTION zc_Object_RoleRight() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_RoleRight', '��������� ���� �� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_RoleRight');


CREATE OR REPLACE FUNCTION zc_object_User() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_object_User'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_object_User', '������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_object_User');

CREATE OR REPLACE FUNCTION zc_Object_UserRole() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserRole'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserRole', '����� ������������� � �����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserRole');

CREATE OR REPLACE FUNCTION zc_Object_UserFormSettings() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_UserFormSettings', '���������������� ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_UserFormSettings');


CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_Member() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Member'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Member', '���������� ����' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Member');

CREATE OR REPLACE FUNCTION zc_Object_Position() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Position'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Position', '���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Position');

CREATE OR REPLACE FUNCTION zc_Object_Personal() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Personal'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Personal', '����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Personal');

CREATE OR REPLACE FUNCTION zc_Object_PositionLevel() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PositionLevel', '������ ���������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PositionLevel');

CREATE OR REPLACE FUNCTION zc_Object_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_Unit', '�������������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Unit');

CREATE OR REPLACE FUNCTION zc_Object_Branch() RETURNS integer AS $BODY$BEGIN  RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_Branch'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc(Code, ItemName)
SELECT 'zc_Object_Branch', '�������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_Branch');

CREATE OR REPLACE FUNCTION zc_Object_PersonalGroup() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO ObjectDesc (Code, ItemName)
  SELECT 'zc_Object_PersonalGroup', '����������� �����������' WHERE NOT EXISTS (SELECT * FROM ObjectDesc WHERE Code = 'zc_Object_PersonalGroup');



/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �. �.
 
*/
