-- Function: gpSelect_MI_Reestr_BarCode()

DROP FUNCTION IF EXISTS gpSelect_MI_Reestr_BarCode (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Reestr_BarCode(
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar
           --, BarCode1 TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 

       SELECT CAST (Null AS TVarChar)  AS BarCode;
           -- , CAST (Null AS TVarChar)  AS BarCode1;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 22.10.16         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_Reestr_BarCode ( inSession:= zfCalc_UserAdmin())
--4323306