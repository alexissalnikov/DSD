-- Function: gpInsert_Object_wms_USER(TVarChar)
-- 4.3	���������� ������������ <add_user>

DROP FUNCTION IF EXISTS gpInsert_Object_wms_USER (VarChar(255));
DROP FUNCTION IF EXISTS gpInsert_Object_wms_USER (VarChar(255), VarChar(255));

CREATE OR REPLACE FUNCTION gpInsert_Object_wms_USER(
    IN inGUID          VarChar(255),      -- 
    IN inSession       VarChar(255)       -- ������ ������������
)
-- RETURNS TABLE (GUID TVarChar, ProcName TVarChar, TagName TVarChar, RowNum Integer, ActionName TVarChar, RowData Text, ObjectId Integer, GroupId Integer)
RETURNS VOID
AS
$BODY$
   DECLARE vbProcName   TVarChar;
   DECLARE vbTagName    TVarChar;
   DECLARE vbActionName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Insert_Object_wms_SKU());

     --
     vbProcName:= 'gpInsert_Object_wms_USER';
     --
     vbTagName:= 'add_user';
     --
     vbActionName:= 'set';


     -- ��������
     IF TRIM (COALESCE (inGUID, '')) = ''
     THEN
         RAISE EXCEPTION 'Error inGUID = <%>', inGUID;
     ELSEIF inGUID = '1'
     THEN
         -- ������� ������� ������
         DELETE FROM Object_WMS WHERE Object_WMS.GUID = inGUID; -- AND Object_WMS.ProcName = vbProcName;
     END IF;


     -- ���������
     -- RETURN QUERY
     -- ��������� - ������������ ����� ������ - �������� XML
     INSERT INTO Object_WMS (GUID, ProcName, TagName, ActionName, RowNum, RowData, ObjectId, GroupId)
        WITH tmpMember AS (SELECT Object_Member.DescId, Object_Member.Id AS id, Object_Member.ValueData AS fio
                           FROM Object AS Object_Member
                                INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ChildObjectId = Object_Member.Id
                                                     AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                                INNER JOIN Object AS Object_User
                                                  ON Object_User.Id = ObjectLink_User_Member.ObjectId
                                                 AND Object_User.isErased = FALSE
                                                 AND Object_User.Id IN (SELECT ObjectLink_UserRole_View.UserId
                                                                        FROM ObjectLink_UserRole_View
                                                                        WHERE ObjectLink_UserRole_View.RoleId IN (428386 -- ������������ ����� �� �����
                                                                                                                , 428382 -- ��������� �����
                                                                                                                 )
                                                                       )
                           WHERE Object_Member.DescId   = zc_Object_Member()
                             AND Object_Member.isErased = FALSE
                          )
        -- ���������
        SELECT inGUID, tmp.ProcName, tmp.TagName, vbActionName, tmp.RowNum, tmp.RowData, tmp.ObjectId, tmp.GroupId
        FROM
             (SELECT vbProcName   AS ProcName
                   , vbTagName    AS TagName
                   , (ROW_NUMBER() OVER (ORDER BY tmpData.id) :: Integer) AS RowNum
                     -- XML
                   , ('<' || vbTagName
                          ||' action="' || vbActionName                     ||'"' -- ???
                              ||' id="' || tmpData.id           :: TVarChar ||'"' -- ���������� id ����������
                             ||' fio="' || zfCalc_Text_replace (zfCalc_Text_replace (tmpData.fio, CHR(39), '`'), '"', '`') ||'"' -- ��� ����������
                                        ||'></' || vbTagName || '>'
                     ):: Text AS RowData
                     -- Id
                   , tmpData.id AS ObjectId
                   , 0          AS GroupId

              FROM tmpMember AS tmpData
             ) AS tmp
     -- WHERE tmp.RowNum BETWEEN 1 AND 10
        ORDER BY 4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
              ������� �.�.   ������ �.�.   ���������� �.�.
 10.08.19                                       *
*/
-- select * FROM Object_WMS WHERE RowData ILIKE '%sync_id=1%
-- select * FROM Object_WMS WHERE GUID = '1' ORDER BY Id
-- ����
-- SELECT * FROM gpInsert_Object_wms_USER ('1', zfCalc_UserAdmin())
