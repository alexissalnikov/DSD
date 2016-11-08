-- Function: gpReport_UserProtocol (TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_UserProtocol (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_UserProtocol(
    IN inStartDate   TDateTime , -- 
    IN inEndDate     TDateTime , --
    IN inBranchId    Integer , --
    IN inUnitId      Integer , --
    IN inUserId      Integer , --
    IN inisDay       Boolean , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (UserId Integer, UserCode Integer, UserName TVarChar, isErased Boolean
             , MemberName TVarChar
             , PositionName TVarChar
             , UnitName TVarChar
             , BranchName TVarChar
             , OperDate TDateTime
             , OperDate_Entry TDateTime
             , OperDate_Exit TDateTime
             , OperDate_Start TDateTime
             , OperDate_End TDateTime
             , Mov_Count TFloat             
             , MI_Count TFloat
             , Color_Calc Integer

              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- ���������
   RETURN QUERY 
    WITH 
    tmpPersonal AS (SELECT View_Personal.MemberId
                          , MAX (View_Personal.UnitId) AS UnitId
                          , MAX (View_Personal.PositionId) AS PositionId
                    FROM Object_Personal_View AS View_Personal
                    WHERE View_Personal.isErased = FALSE
                    GROUP BY View_Personal.MemberId
                    )

  , tmpUser AS (SELECT Object_User.Id AS UserId
                     , Object_User.ObjectCode AS UserCode
                     , Object_User.ValueData  AS UserName
                     , Object_User.isErased
                     , tmpPersonal.MemberId 
                     , ObjectLink_Unit_Branch.ChildObjectId AS BranchId
                     , tmpPersonal.UnitId
                     , tmpPersonal.PositionId
                FROM Object AS Object_User
                      LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                      LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                      LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                             ON ObjectLink_Unit_Branch.ObjectId = tmpPersonal.UnitId
                            AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                WHERE Object_User.DescId = zc_Object_User()
                  AND (Object_User.Id = inUserId OR inUserId =0)  
                  AND (ObjectLink_Unit_Branch.ChildObjectId = inBranchId OR inBranchId = 0) 
                  AND (tmpPersonal.UnitId = inUnitId OR inUnitId = 0) 
                )
  -- ���������� ������� ���
  , tmpData AS (SELECT generate_series(inStartDate, inEndDate, '1 day'::interval) as OperDate
                WHERE inisDay = TRUE
               UNION 
                SELECT inStartDate as OperDate
                WHERE inisDay = FALSE)
  -- ���������� ����� ����������� � ������ �� ���������
  , tmpLoginProtocol AS (SELECT LoginProtocol.UserId
                              , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',LoginProtocol.OperDate) ELSE inStartDate END AS OperDate
                              , MIN (CASE CAST(replace(replace(CAST (XPATH ('/XML/Field[3]/@FieldValue', LoginProtocol.ProtocolData :: XML) AS TEXT) , '}', ''), '{', '') AS tvarchar)
                                          WHEN CAST('�����������' AS tvarchar) THEN (LoginProtocol.OperDate) 
                                          WHEN CAST('�����������(�����������)' AS tvarchar) THEN (LoginProtocol.OperDate) 
                                     END)  AS OperDate_Entry
                              , MAX (CASE replace(replace(CAST (XPATH ('/XML/Field[3]/@FieldValue', LoginProtocol.ProtocolData :: XML) AS TEXT) , '}', ''), '{', '') 
                                          WHEN CAST('�����' AS tvarchar) THEN (LoginProtocol.OperDate) 
                                          WHEN CAST('��������' AS tvarchar) THEN (LoginProtocol.OperDate) 
                                     END)  AS OperDate_Exit 
                          FROM LoginProtocol
                               INNER JOIN tmpUser ON tmpUser.UserId = LoginProtocol.UserId
                          WHERE DATE_TRUNC ('DAY', LoginProtocol.operDate) BETWEEN inStartDate AND inEndDate
                          GROUP BY LoginProtocol.UserId
                                 , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',LoginProtocol.operDate) ELSE inStartDate END
                         ) 
  -- ������ �� ��������� ���������
  , tmpMov_Protocol AS (SELECT MovementProtocol.UserId
                             , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',MovementProtocol.operDate) ELSE inStartDate END AS OperDate
                             , MovementProtocol.OperDate AS OperDate_Protocol
                             , MovementProtocol.MovementId AS Id
                        FROM MovementProtocol
                             INNER JOIN tmpUser ON tmpUser.UserId = MovementProtocol.UserId
                        WHERE DATE_TRUNC ('DAY',MovementProtocol.operDate) between inStartDate AND inEndDate
                           ) 
  -- ������ �� ��������� ����� ���������
  , tmpMI_Protocol AS (SELECT MovementItemProtocol.UserId
                            , CASE WHEN inisDay = TRUE THEN DATE_TRUNC ('DAY',MovementItemProtocol.operDate) ELSE inStartDate END AS OperDate
                            , MovementItemProtocol.OperDate AS OperDate_Protocol
                            , MovementItemProtocol.MovementItemId AS Id
                       FROM MovementItemProtocol
                            INNER JOIN tmpUser ON tmpUser.UserId = MovementItemProtocol.UserId
                       WHERE DATE_TRUNC ('DAY',MovementItemProtocol.operDate) between inStartDate AND inEndDate
                           ) 

  -- ������� ����� ������� ��������, ����� ���������� ��������
  , tmpTimeMotion AS (SELECT tmp.UserId, tmp.OperDate, min(tmp.OperDate_Protocol) AS OperDate_Start, max(tmp.OperDate_Protocol) AS OperDate_End
                      FROM (SELECT *
                            FROM tmpMov_Protocol
                           UNION 
                            SELECT *
                            FROM tmpMI_Protocol) as tmp 
                      WHERE inisDay = TRUE
                      GROUP BY tmp.UserId, tmp.OperDate
                      )
 
     SELECT tmpUser.UserId
          , tmpUser.UserCode
          , tmpUser.UserName
          , tmpUser.isErased
          , Object_Member.ValueData           AS MemberName 
          , Object_Position.ValueData         AS PositionName 
          , Object_Unit.ValueData             AS UnitName
          , Object_Branch.ValueData           AS BranchName
 
          , tmpData.OperDate                ::TDateTime
          , tmpLoginProtocol.OperDate_Entry ::TDateTime                         -- ����� �����
          , tmpLoginProtocol.OperDate_Exit  ::TDateTime                         -- ����� ������
          , tmpTimeMotion.OperDate_Start    ::TDateTime                         -- ����� ������� ��������
          , tmpTimeMotion.OperDate_End      ::TDateTime                         -- ����� ���������� ��������
          , COALESCE (tmpMov.Mov_Count,0)   ::TFloat     AS Mov_Count           -- ���-�� ���������� 
          , COALESCE (tmpMI.MI_Count,0)     ::TFloat     AS MI_Count            -- ���-�� ���������

          , CASE WHEN CAST (tmpLoginProtocol.OperDate_Exit AS TDateTime) > CURRENT_TIMESTAMP - interval '10 minute'
                 THEN zc_Color_Red()
                 ELSE zc_Color_Black()
            END                                          AS Color_Calc          -- ������������ ������� ���� ������� ��� ��������
     FROM tmpData-- ON 1=1
          LEFT JOIN tmpLoginProtocol ON tmpLoginProtocol.OperDate = tmpData.OperDate
                                   -- AND tmpLoginProtocol.UserId = tmpUser.UserId
          LEFT JOIN tmpUser ON tmpUser.UserId =  tmpLoginProtocol.UserId 
          LEFT JOIN (SELECT tmpMov_Protocol.UserId 
                          , tmpMov_Protocol.OperDate
                          , Count(DISTINCT tmpMov_Protocol.Id) AS Mov_Count
                     FROM tmpMov_Protocol
                     GROUP BY tmpMov_Protocol.UserId 
                            , tmpMov_Protocol.OperDate
                     ) AS tmpMov ON tmpMov.OperDate = tmpData.OperDate
                                AND tmpMov.UserId   = tmpUser.UserId
          LEFT JOIN (SELECT tmpMI_Protocol.UserId 
                          , tmpMI_Protocol.OperDate
                          , Count(DISTINCT tmpMI_Protocol.Id) AS MI_Count
                     FROM tmpMI_Protocol
                     GROUP BY tmpMI_Protocol.UserId 
                            , tmpMI_Protocol.OperDate
                     ) AS tmpMI ON tmpMI.OperDate = tmpData.OperDate
                               AND tmpMI.UserId   = tmpUser.UserId
          LEFT JOIN tmpTimeMotion ON tmpTimeMotion.OperDate = tmpData.OperDate
                                 AND tmpTimeMotion.UserId = tmpUser.UserId
                                
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpUser.MemberId
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpUser.PositionId
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUser.UnitId
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmpUser.BranchId
     WHERE COALESCE (tmpLoginProtocol.OperDate_Entry , zc_DateStart() ) <> zc_DateStart() 
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.11.16         *
*/
-- ����
 --select * from gpReport_UserProtocol(inStartDate := ('07.11.2016')::TDateTime , inEndDate := ('07.11.2016')::TDateTime , inBranchId := 0 , inUnitId := 0 , inUserId := 76913 , inisDay := 'True' ,  inSession := '5');
