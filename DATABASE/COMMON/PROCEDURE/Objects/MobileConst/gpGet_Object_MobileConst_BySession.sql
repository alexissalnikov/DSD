-- Function: gpGet_Object_MobileConst_BySession

DROP FUNCTION IF EXISTS gpGet_Object_MobileConst_BySession (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MobileConst_BySession (
    IN inSession TVarChar
)
RETURNS TABLE (MobileVersion     TVarChar  -- ������ ���������� ����������. ������: "1.0.3.625"
             , MobileAPKFileName TVarChar  -- �������� ".apk" ����� ���������� ����������
             , OperDateDiff      Integer   -- �� ������� ���� ����� ��������� ��� ������� � ������ �����
             , ReturnDayCount    Integer   -- ������� ���� ����������� �������� �� ������ �����
             , CriticalOverDays  Integer   -- ���������� ���� ���������, ����� �������� ������������ ������ ����������
             , CriticalDebtSum   TFloat    -- ����� �����, ����� �������� ������������ ������ ����������
             , UserId            Integer   -- ����� �������� ��� ���������� ���������� � �������������
             , UserName          TVarChar
              )
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPublicId Integer;
  DECLARE vbPrivateId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� �� ����� ��������
      SELECT Object_MobileConst.Id
      INTO vbPublicId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = 0
        AND Object_MobileConst.ValueData = zc_Enum_MobileConst_Public();
      
      -- �������� �� ������� ��������
      SELECT Object_MobileConst.Id
      INTO vbPrivateId
      FROM Object AS Object_MobileConst
      WHERE Object_MobileConst.DescId = zc_Object_MobileConst()
        AND Object_MobileConst.ObjectCode = vbUserId
        AND Object_MobileConst.ValueData = zc_Enum_MobileConst_Private();
      
      -- ���������
      RETURN QUERY
        SELECT COALESCE (mcPrivate.MobileVersion,     mcPublic.MobileVersion)::TVarChar     AS MobileVersion
             , COALESCE (mcPrivate.MobileAPKFileName, mcPublic.MobileAPKFileName)::TVarChar AS MobileAPKFileName
             , COALESCE (mcPrivate.OperDateDiff,      mcPublic.OperDateDiff)::Integer       AS OperDateDiff
             , COALESCE (mcPrivate.ReturnDayCount,    mcPublic.ReturnDayCount)::Integer     AS ReturnDayCount
             , COALESCE (mcPrivate.CriticalOverDays,  mcPublic.CriticalOverDays)::Integer   AS CriticalOverDays
             , COALESCE (mcPrivate.CriticalDebtSum,   mcPublic.CriticalDebtSum)::TFloat     AS CriticalDebtSum
             , COALESCE (mcPrivate.UserId,            mcPublic.UserId)::Integer             AS UserId
             , COALESCE (mcPrivate.UserName,          mcPublic.UserName)::TVarChar          AS UserName
        FROM lpGet_Object_MobileConst (inId:= vbPublicId) AS mcPublic
             LEFT JOIN lpGet_Object_MobileConst (inId:= vbPrivateId) AS mcPrivate ON 1 = 1
        ;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.
 19.07.17                                                       *
*/

-- ����
-- SELECT * FROM gpGet_Object_MobileConst_BySession (inSession:= zfCalc_UserAdmin());
