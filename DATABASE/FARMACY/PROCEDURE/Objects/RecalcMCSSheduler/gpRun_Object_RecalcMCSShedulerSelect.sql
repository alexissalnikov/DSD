-- Function: gpRun_Object_RecalcMCSShedulerSelect()

DROP FUNCTION IF EXISTS gpRun_Object_RecalcMCSShedulerSelect(TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RecalcMCSShedulerSelect(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
  DECLARE vbHolidays Boolean;
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());
  vbUserId:= inSession;
   
  IF NOT EXISTS(SELECT ObjectBoolean.ValueData FROM ObjectBoolean 
                             WHERE ObjectBoolean.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()
                               AND ObjectBoolean.ValueData = TRUE)
  THEN
    RAISE EXCEPTION '������. �� �������� �� ������ �������������.';
  END IF;
   
  IF EXISTS(SELECT
                 TRUE       AS Holidays
            FROM
                Object AS Object_RecalcMCSSheduler

                 INNER JOIN ObjectDate AS ObjectDate_BeginHolidays
                                       ON ObjectDate_BeginHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_BeginHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_BeginHolidays()
                 INNER JOIN ObjectDate AS ObjectDate_EndHolidays
                                       ON ObjectDate_EndHolidays.ObjectId = Object_RecalcMCSSheduler.Id
                                      AND ObjectDate_EndHolidays.DescId = zc_ObjectFloat_RecalcMCSSheduler_EndHolidays()
            WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
               AND ObjectDate_BeginHolidays.ValueData <= ObjectDate_EndHolidays.ValueData
               AND ObjectDate_BeginHolidays.ValueData <= current_date
               AND current_date <= ObjectDate_EndHolidays.ValueData
            ORDER BY ID LIMIT 1)
  THEN
    vbHolidays := TRUE;
  ELSE
    vbHolidays := FALSE;
  END IF;


    -- �� ����� ��� ���������� ��������
  PERFORM  gpRecalcMCS(inUnitId := ObjectLink_Unit_Juridical_Run.ObjectId,
                       inPeriod := ObjectFloat_Period.ValueData::Integer,
                       inDay := ObjectFloat_Day.ValueData::Integer,
                       inSession := COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession)),
           lpInsertUpdate_ObjectDate(zc_ObjectFloat_RecalcMCSSheduler_DateRun(), Object_RecalcMCSSheduler.Id, clock_timestamp()),
           lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_UserRun(), Object_RecalcMCSSheduler.Id, vbUserId)
  FROM Object AS Object_RecalcMCSSheduler

           INNER JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                    ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                   AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

           INNER JOIN ObjectBoolean AS ObjectBoolean_SelectRun
                                   ON ObjectBoolean_SelectRun.ObjectId = Object_RecalcMCSSheduler.Id
                                  AND ObjectBoolean_SelectRun.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()
                                  AND ObjectBoolean_SelectRun.ValueData = TRUE
                                  
           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()

           INNER JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RecalcMCSSheduler_User()

           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail_Run
                                 ON ObjectLink_Juridical_Retail_Run.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                                AND ObjectLink_Juridical_Retail_Run.DescId = zc_ObjectLink_Juridical_Retail()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical_Run
                                 ON ObjectLink_Unit_Juridical_Run.ChildObjectId = ObjectLink_Juridical_Retail_Run.ObjectId
                                AND ObjectLink_Unit_Juridical_Run.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Unit_Run
                            ON Object_Unit_Run.Id = ObjectLink_Unit_Juridical_Run.ObjectId

           INNER JOIN ObjectLink AS ObjectLink_Unit_Parent_Run
                                 ON ObjectLink_Unit_Parent_Run.ObjectId = ObjectLink_Unit_Juridical_Run.ObjectId
                                AND ObjectLink_Unit_Parent_Run.DescId = zc_ObjectLink_Unit_Parent()

           INNER JOIN ObjectBoolean AS ObjectBoolean_Unit_AutoMCS
                                    ON ObjectBoolean_Unit_AutoMCS.ObjectId = ObjectLink_Unit_Juridical_Run.ObjectId
                                   AND ObjectBoolean_Unit_AutoMCS.DescId = zc_ObjectBoolean_Unit_AutoMCS()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                   ON ObjectBoolean_PharmacyItem.ObjectId = ObjectLink_Unit_Juridical_Run.ObjectId
                                  AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

           LEFT JOIN ObjectFloat AS ObjectFloat_Period
                                 ON ObjectFloat_Period.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Period.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                                THEN zc_ObjectFloat_Unit_Period()
                                                                ELSE
                                                                  CASE to_char(clock_timestamp(), 'ID')::Integer
                                                                  WHEN 1 THEN zc_ObjectFloat_Unit_Period1()
                                                                  WHEN 2 THEN zc_ObjectFloat_Unit_Period2()
                                                                  WHEN 3 THEN zc_ObjectFloat_Unit_Period3()
                                                                  WHEN 4 THEN zc_ObjectFloat_Unit_Period4()
                                                                  WHEN 5 THEN zc_ObjectFloat_Unit_Period5()
                                                                  WHEN 6 THEN zc_ObjectFloat_Unit_Period6()
                                                                  WHEN 7 THEN zc_ObjectFloat_Unit_Period7() END END

           LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                 ON ObjectFloat_Day.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Day.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                             THEN zc_ObjectFloat_Unit_Day()
                                                             ELSE
                                                               CASE to_char(clock_timestamp(), 'ID')::Integer
                                                               WHEN 1 THEN zc_ObjectFloat_Unit_Day1()
                                                               WHEN 2 THEN zc_ObjectFloat_Unit_Day2()
                                                               WHEN 3 THEN zc_ObjectFloat_Unit_Day3()
                                                               WHEN 4 THEN zc_ObjectFloat_Unit_Day4()
                                                               WHEN 5 THEN zc_ObjectFloat_Unit_Day5()
                                                               WHEN 6 THEN zc_ObjectFloat_Unit_Day6()
                                                               WHEN 7 THEN zc_ObjectFloat_Unit_Day7() END END

  WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
    AND Object_RecalcMCSSheduler.isErased = FALSE
    AND COALESCE (ObjectFloat_Period.ValueData::Integer, 0) <> 0
    AND COALESCE (ObjectFloat_Day.ValueData::Integer, 0) <> 0
    AND COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE) = TRUE
    AND Object_Unit_Run.isErased = FALSE
    AND COALESCE(ObjectLink_Unit_Parent_Run.ChildObjectId, 0) <> 0
    AND COALESCE (ObjectBoolean_Unit_AutoMCS.ValueData, FALSE) = TRUE
    AND ObjectLink_Unit_Juridical_Run.ObjectId not in 
                                             (SELECT Object_Unit.Id
                                              FROM Object AS Object_RecalcMCSSheduler
                                                   LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                                         ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()
                                                   LEFT JOIN Object AS Object_Unit
                                                                     ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                                                           ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                                                          AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

                                              WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
                                                AND Object_RecalcMCSSheduler.isErased = False
                                                AND COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE) = False);


    -- �� ��������� ������� 
  PERFORM  gpRecalcMCS(inUnitId := ObjectLink_Unit.ChildObjectId,
                       inPeriod := ObjectFloat_Period.ValueData::Integer,
                       inDay := ObjectFloat_Day.ValueData::Integer,
                       inSession := COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession)),
           lpInsertUpdate_ObjectDate(zc_ObjectFloat_RecalcMCSSheduler_DateRun(), Object_RecalcMCSSheduler.Id, clock_timestamp()),
           lpInsertUpdate_ObjectLink(zc_ObjectLink_RecalcMCSSheduler_UserRun(), Object_RecalcMCSSheduler.Id, vbUserId)
  FROM Object AS Object_RecalcMCSSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RecalcMCSSheduler_Unit()

           INNER JOIN ObjectBoolean AS ObjectBoolean_Unit_AutoMCS
                                    ON ObjectBoolean_Unit_AutoMCS.ObjectId = ObjectLink_Unit.ChildObjectId
                                   AND ObjectBoolean_Unit_AutoMCS.DescId = zc_ObjectBoolean_Unit_AutoMCS()

           INNER JOIN ObjectBoolean AS ObjectBoolean_SelectRun
                                   ON ObjectBoolean_SelectRun.ObjectId = Object_RecalcMCSSheduler.Id
                                  AND ObjectBoolean_SelectRun.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()
                                  AND ObjectBoolean_SelectRun.ValueData = TRUE

           LEFT JOIN ObjectBoolean AS ObjectBoolean_AllRetail
                                   ON ObjectBoolean_AllRetail.ObjectId = Object_RecalcMCSSheduler.Id
                                  AND ObjectBoolean_AllRetail.DescId = zc_ObjectBoolean_RecalcMCSSheduler_AllRetail()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_PharmacyItem
                                   ON ObjectBoolean_PharmacyItem.ObjectId = ObjectLink_Unit.ChildObjectId
                                  AND ObjectBoolean_PharmacyItem.DescId = zc_ObjectBoolean_Unit_PharmacyItem()

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RecalcMCSSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RecalcMCSSheduler_User()

           LEFT JOIN ObjectFloat AS ObjectFloat_Period
                                 ON ObjectFloat_Period.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Period.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                                THEN zc_ObjectFloat_Unit_Period()
                                                                ELSE
                                                                  CASE to_char(clock_timestamp(), 'ID')::Integer
                                                                  WHEN 1 THEN zc_ObjectFloat_Unit_Period1()
                                                                  WHEN 2 THEN zc_ObjectFloat_Unit_Period2()
                                                                  WHEN 3 THEN zc_ObjectFloat_Unit_Period3()
                                                                  WHEN 4 THEN zc_ObjectFloat_Unit_Period4()
                                                                  WHEN 5 THEN zc_ObjectFloat_Unit_Period5()
                                                                  WHEN 6 THEN zc_ObjectFloat_Unit_Period6()
                                                                  WHEN 7 THEN zc_ObjectFloat_Unit_Period7() END END

           LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                 ON ObjectFloat_Day.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectFloat_Day.DescId = CASE WHEN COALESCE(ObjectBoolean_PharmacyItem.ValueData, False) = FALSE AND vbHolidays
                                                             THEN zc_ObjectFloat_Unit_Day()
                                                             ELSE
                                                               CASE to_char(clock_timestamp(), 'ID')::Integer
                                                               WHEN 1 THEN zc_ObjectFloat_Unit_Day1()
                                                               WHEN 2 THEN zc_ObjectFloat_Unit_Day2()
                                                               WHEN 3 THEN zc_ObjectFloat_Unit_Day3()
                                                               WHEN 4 THEN zc_ObjectFloat_Unit_Day4()
                                                               WHEN 5 THEN zc_ObjectFloat_Unit_Day5()
                                                               WHEN 6 THEN zc_ObjectFloat_Unit_Day6()
                                                               WHEN 7 THEN zc_ObjectFloat_Unit_Day7() END END

  WHERE Object_RecalcMCSSheduler.DescId = zc_Object_RecalcMCSSheduler()
    AND Object_RecalcMCSSheduler.isErased = FALSE
    AND COALESCE (ObjectFloat_Period.ValueData::Integer, 0) <> 0
    AND COALESCE (ObjectFloat_Day.ValueData::Integer, 0) <> 0
    AND COALESCE (ObjectBoolean_Unit_AutoMCS.ValueData, FALSE) = TRUE
    AND COALESCE (ObjectBoolean_AllRetail.ValueData, FALSE) = False;
    
  PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_RecalcMCSSheduler_SelectRun(), ObjectBoolean.ObjectId, False)
  FROM ObjectBoolean 
  WHERE ObjectBoolean.DescId = zc_ObjectBoolean_RecalcMCSSheduler_SelectRun()
    AND ObjectBoolean.ValueData = TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RecalcMCSSheduler(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 23.12.18        *
*/

-- ����
-- SELECT * FROM gpRun_Object_RecalcMCSSheduler ('3')