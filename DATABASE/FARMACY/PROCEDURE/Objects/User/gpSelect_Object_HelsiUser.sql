-- Function: gpSelect_Object_HelsiUser (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_HelsiUser (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_HelsiUser(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , PositionName TVarChar
             , UnitId Integer, UnitName TVarChar
             , UserName TVarChar
             , UserPassword TVarChar
             , KeyPassword TVarChar
             , PasswordEHels TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send());
   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
   THEN
     RAISE EXCEPTION '�������� ������ ���������� ��������������';
   END IF;

   -- ���������
   RETURN QUERY 
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                             , MAX (View_Personal.PositionId) AS PositionId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                        GROUP BY View_Personal.MemberId
                       )
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , Object_Position.ValueData                  AS PositionName

       , Object_Unit.Id AS UnitId
       , Object_Unit.ValueData AS UnitName

       , ObjectString_UserName.ValueData
       , ObjectString_UserPassword.ValueData
       , ObjectString_KeyPassword.ValueData
       , ObjectString_PasswordEHels.ValueData
       
   FROM Object AS Object_User

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_User_Unit
                ON ObjectLink_User_Unit.ObjectId = Object_User.Id
               AND ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Helsi_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_User_Unit.ChildObjectId

         LEFT JOIN ObjectString AS ObjectString_UserName 
                ON ObjectString_UserName.DescId = zc_ObjectString_User_Helsi_UserName() 
               AND ObjectString_UserName.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_UserPassword
                ON ObjectString_UserPassword.DescId = zc_ObjectString_User_Helsi_UserPassword() 
               AND ObjectString_UserPassword.ObjectId = Object_User.Id
        
         LEFT JOIN ObjectString AS ObjectString_KeyPassword 
                ON ObjectString_KeyPassword.DescId = zc_ObjectString_User_Helsi_KeyPassword() 
               AND ObjectString_KeyPassword.ObjectId = Object_User.Id
              
         LEFT JOIN ObjectString AS ObjectString_PasswordEHels 
                ON ObjectString_PasswordEHels.DescId = zc_ObjectString_User_Helsi_PasswordEHels() 
               AND ObjectString_PasswordEHels.ObjectId = Object_User.Id

   WHERE Object_User.DescId = zc_Object_User()
     AND COALESCE(ObjectString_UserName.ValueData, '') <> '';
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_HelsiUser (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 25.02.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_HelsiUser ('3')
