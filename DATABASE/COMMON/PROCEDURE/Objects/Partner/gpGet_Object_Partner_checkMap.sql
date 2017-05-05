-- Function: gpGet_Object_Partner_checkMap()

DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_Partner_checkMap (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Partner_checkMap(
    IN inJuridicalId       Integer  , 
    IN inRetailId          Integer  , 
    IN inPersonalId        Integer  , 
    IN inPersonalTradeId   Integer  , 
    IN inRouteId           Integer  , 
    IN inRouteId_30201     Integer  , 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

   -- ������������ 
   IF COALESCE (inJuridicalId, 0) = 0 AND
      COALESCE (inRetailId, 0) = 0 AND 
      COALESCE (inPersonalId, 0) = 0 AND 
      COALESCE (inPersonalTradeId, 0) = 0 AND 
      COALESCE (inRouteId, 0) = 0 AND 
      COALESCE (inRouteId_30201, 0) = 0 THEN
     -- RAISE EXCEPTION '������. ������ �� ����� Google �������� ����� ���������� <%> ������������.���������� ���������� <�������� ����> ��� <����������� ����> ��� <��� ��������� (��)>.', (SELECT COUNT() FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
     RAISE EXCEPTION '������. ������ �� ����� Google �������� ����� ���������� <%> ������������.���������� ���������� ����������� � ������ <����������� ����> ��� <�������� ����> ��� <��� ��������� (�����������)> ��� <��� ��������� (��)> ��� <�������> ��� <������� (����.�����)>', (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Partner()) :: Integer;
   END IF;
   
   -- ������ ���   
   RETURN inJuridicalId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.05.17         *
 04.05.17                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Partner_checkMap (0, zfCalc_UserAdmin())
