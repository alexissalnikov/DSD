-- Function: gpInsertUpdate_Object_MarginCategory(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginCategory(
    IN ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inCode           Integer,       -- �������� <��� ���� ����� ������>
    IN inName           TVarChar,      -- �������� <������������ ���� ����� ������>
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE(Id INTEGER, Code Integer ) AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginCategory());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginCategory());
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginCategory(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginCategory(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginCategory(), Code_max, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

   RETURN 
      QUERY SELECT ioId AS Id, Code_max AS Code;

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MarginCategory (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.04.15                          *

*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginCategory(0, 2,'��','2'); ROLLBACK
