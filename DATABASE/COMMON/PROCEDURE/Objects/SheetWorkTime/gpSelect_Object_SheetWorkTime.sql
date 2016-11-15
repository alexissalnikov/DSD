-- Function: gpSelect_Object_SheetWorkTime()

DROP FUNCTION IF EXISTS gpSelect_Object_SheetWorkTime(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SheetWorkTime(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DayKindId Integer, DayKindCode Integer, DayKindName TVarChar
             , StartTime Time, WorkTime Time, DayOffPeriodDate TDateTime
             , Comment TVarChar, DayOffPeriod TVarChar, DayOffWeek TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_SheetWorkTime());

     RETURN QUERY 
     SELECT 
           Object_SheetWorkTime.Id              AS Id 
         , Object_SheetWorkTime.ObjectCode      AS Code
         , Object_SheetWorkTime.ValueData       AS Name
         
         , Object_DayKind.Id                    AS DayKindId
         , Object_DayKind.ObjectCode            AS DayKindCode
         , Object_DayKind.ValueData             AS DayKindName
       
         , ObjectDate_Start.ValueData        :: Time      AS StartTime
         , ObjectDate_Work.ValueData         :: Time      AS WorkTime
         , ObjectDate_DayOffPeriod.ValueData :: TDateTime AS DayOffPeriodDate
         
         , ObjectString_Comment.ValueData       AS Comment
         , ObjectString_DayOffPeriod.ValueData  AS DayOffPeriod                                                                                                       
         , ObjectString_DayOffWeek.ValueData    AS DayOffWeek

         , Object_SheetWorkTime.isErased        AS isErased
         
     FROM Object AS Object_SheetWorkTime
  
          LEFT JOIN ObjectDate AS ObjectDate_Start
                               ON ObjectDate_Start.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_Start.DescId = zc_ObjectDate_SheetWorkTime_Start()

          LEFT JOIN ObjectDate AS ObjectDate_Work
                               ON ObjectDate_Work.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_Work.DescId = zc_ObjectDate_SheetWorkTime_Work()

          LEFT JOIN ObjectDate AS ObjectDate_DayOffPeriod
                               ON ObjectDate_DayOffPeriod.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectDate_DayOffPeriod.DescId = zc_ObjectDate_SheetWorkTime_DayOffPeriod()
          
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_SheetWorkTime_Comment()

          LEFT JOIN ObjectString AS ObjectString_DayOffPeriod
                                 ON ObjectString_DayOffPeriod.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_DayOffPeriod.DescId = zc_ObjectString_SheetWorkTime_DayOffPeriod()

          LEFT JOIN ObjectString AS ObjectString_DayOffWeek
                                 ON ObjectString_DayOffWeek.ObjectId = Object_SheetWorkTime.Id
                                AND ObjectString_DayOffWeek.DescId = zc_ObjectString_SheetWorkTime_DayOffWeek()

          LEFT JOIN ObjectLink AS ObjectLink_SheetWorkTime_DayKind
                               ON ObjectLink_SheetWorkTime_DayKind.ObjectId = Object_SheetWorkTime.Id
                              AND ObjectLink_SheetWorkTime_DayKind.DescId = zc_ObjectLink_SheetWorkTime_DayKind()
          LEFT JOIN Object AS Object_DayKind ON Object_DayKind.Id = ObjectLink_SheetWorkTime_DayKind.ChildObjectId          

     WHERE Object_SheetWorkTime.DescId = zc_Object_SheetWorkTime()
     ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_SheetWorkTime(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.11.16         *   
*/

-- ����
-- SELECT * FROM gpSelect_Object_SheetWorkTime (zfCalc_UserAdmin())
