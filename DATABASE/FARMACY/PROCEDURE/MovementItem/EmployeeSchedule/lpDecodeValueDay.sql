-- Function: lpGetEmployeeScheduleDay()

DROP FUNCTION IF EXISTS lpDecodeValueDay(Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpDecodeValueDay(
    IN inId  Integer,       -- ���� ���������
    IN inValue TVarChar
)
  RETURNS TVarChar 
AS
$BODY$
BEGIN
  RETURN(CASE SUBSTRING(inValue, inId, 1)::Integer
                    WHEN 1 THEN '8:00'
                    WHEN 2 THEN '9:00'
                    WHEN 3 THEN '10:00'
                    WHEN 7 THEN '21:00'
                    WHEN 9 THEN '�'
                    ELSE NULL END);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpDecodeValueDay (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.12.18                                                       *
 09.12.18                                                       *
*/

-- ����
-- select * from lpDecodeValueDay(inId := 2, inValue := '0900000000000000000000000000000');