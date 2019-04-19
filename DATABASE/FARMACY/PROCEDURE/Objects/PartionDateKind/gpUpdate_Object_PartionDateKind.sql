-- Function: gpInsertUpdate_Object_PartionDateKind (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_PartionDateKind (Integer, Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_PartionDateKind(
    IN inId            Integer   ,    -- ���� ������� <>
    IN inCode          Integer   ,    -- ��� ������� <>
    IN inName          TVarChar  ,    -- ��������
    IN inMonth         TFloat    ,    -- ���-�� �������
    IN inSession       TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_PartionDateKind());

   -- ��������� <������>
   PERFORM lpInsertUpdate_Object (inId, zc_Object_PartionDateKind(), inCode, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PartionDateKind_Month(), inId, inMonth);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.04.19         * 
*/

-- ����
--