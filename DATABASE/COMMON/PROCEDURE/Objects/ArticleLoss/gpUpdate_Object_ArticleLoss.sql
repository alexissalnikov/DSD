-- Function: gpUpdate_Object_ArticleLoss()

DROP FUNCTION IF EXISTS gpUpdate_Object_ArticleLoss (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ArticleLoss(
    IN inId                       Integer   ,     -- ���� ������� <������ ��������>  
    IN inBusinessId               Integer   ,     -- ������
    IN inComment                  TVarChar  ,     -- ���������� 
    IN inSession                  TVarChar        -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ArticleLoss());
   --vbUserId := inSession;

   -- ��������� ����� � <������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ArticleLoss_Business(), inId, inBusinessId);
   -- ��������� c�������� � <����������>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ArticleLoss_Comment(), inId, inComment);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 27.07.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_ArticleLoss(inId:=null, inBusinessId:=0, inComment:= '', inSession:='2')