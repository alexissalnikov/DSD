-- Function: gpGet_CheckFarmacyName_byUser()

DROP FUNCTION IF EXISTS gpGet_CheckFarmacyName_byUser (TVarChar, TVarChar);



CREATE OR REPLACE FUNCTION gpGet_CheckFarmacyName_byUser(
    OUT    outIsEnter         Boolean , -- ���������� �� ���� true - ��, false - ��� 
    IN     inUnitName         TVarChar, -- ��� ������ ��� ������� ������ ������������
    IN     inSession          TVarChar  -- ������ ������������
)
RETURNS BOOLEAN
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId_find Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);


    -- ������ ��� ���� ������
    outIsEnter := FALSE;
 
    -- �������� ������
    IF COALESCE (inUnitName, '') = ''
    THEN
        RAISE EXCEPTION '������.�������� ������ �� ����� ���� ������.';
    END IF;

    --                              �
    IF 1 < (SELECT COUNT(*) FROM Object WHERE DescId = zc_Object_Unit() AND LOWER (ValueData) = LOWER (inUnitName) AND isErased = FALSE)
    THEN
         RAISE EXCEPTION '������.�������� <%> ���������� � ���������� �����.', inUnitName;
    ELSE
         -- ����� �� ��������
         vbUnitId_find:= (SELECT Id FROM Object WHERE DescId = zc_Object_Unit() AND LOWER (ValueData) = LOWER (inUnitName) AND isErased = FALSE);
         -- �������� ������
         IF COALESCE (vbUnitId_find, 0) = 0
         THEN
             RAISE EXCEPTION '������.�������� ������ <%> �� �������.', inUnitName;
         ELSE
             -- �������� "�������" �������� �� ��������
             vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
             IF vbUnitKey = '' THEN vbUnitKey := '0'; END IF;   
             vbUnitId := vbUnitKey :: Integer;

             IF vbUnitId <> 0
             THEN

             -- ��������
             IF COALESCE(vbUnitId, 0) = 0 THEN
               RAISE EXCEPTION '������.��� ������������ <%> �� ����������� �������� <�������������>.', lfGet_Object_ValueData (vbUserId);
             END IF;

             -- �������� - !!!���� �� ������ ����������!!!
             IF zfGet_Unit_Retail(vbUnitId) <> zfGet_Unit_Retail(vbUnitId_find) OR lpGet_DefaultValue ('zc_Object_Retail', vbUserId) <> zfGet_Unit_Retail(vbUnitId_find) :: TVarChar
             THEN
               RAISE EXCEPTION '������.������������ <%> ��������������� � ���� <%> � �� ����� �������� � ������� ���� <%>.', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (zfGet_Unit_Retail(vbUnitId)), lfGet_Object_ValueData (zfGet_Unit_Retail(vbUnitId_find));
             END IF;
         

             -- �� ������ ������ ��������� ��� ������� 1 ������
             IF 1 <> (SELECT COUNT (*)
                      FROM DefaultKeys
                           LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                                 AND DefaultValue.UserKeyId     = vbUserId
                      WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit'))
             THEN
                 RAISE EXCEPTION '������.�� ������ ���� ������ � ������������ <%> � ������ <zc_Object_Unit>.���-�� ��������� = <%>.'
                               , lfGet_Object_ValueData (vbUserId)
                               , (SELECT COUNT (*)
                                  FROM DefaultKeys
                                       LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                                             AND DefaultValue.UserKeyId    = vbUserId
                                  WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit'));
             END IF;

             END IF;
             
             -- �������� ������������ - ������
             PERFORM gpInsertUpdate_DefaultValue (ioId           := DefaultValue.Id
                                                , inDefaultKeyId := DefaultKeys.Id
                                                , inUserKey      := vbUserId
                                                , inDefaultValue := vbUnitId_find :: TVarChar
                                                , inSession      := '3'
                                                 )
             FROM DefaultKeys
                  LEFT JOIN DefaultValue ON DefaultValue.DefaultKeyId = DefaultKeys.Id
                                        AND DefaultValue.UserKeyId    = vbUserId
             WHERE LOWER (DefaultKeys.Key) = LOWER ('zc_Object_Unit')
               AND vbUnitId_find <> vbUnitId;
             
          
             -- ������� ��� ��� ������
             outIsEnter := TRUE;
         END IF;
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
 
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.  ��������� �.�.
 10.01.17                                                         *
*/

