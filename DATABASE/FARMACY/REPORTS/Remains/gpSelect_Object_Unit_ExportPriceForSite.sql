-- Function: gpSelect_Object_Unit_ExportPriceForSite()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_ExportPriceForSite(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_ExportPriceForSite(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, RegNumber Integer, SerialNumber Integer, Name TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
   WITH
     tmpUnit AS                   (
       SELECT 183292 AS UnitId, 22185 AS RegNumber, 32490 AS SerialNumber
       UNION ALL
       SELECT 11152911, 773188, 33622
       UNION ALL
       SELECT 10779386, 775167, 33618
       UNION ALL
       SELECT 6608396, 796362, 36914
       UNION ALL
       SELECT 7117700, 798936, 33626
       UNION ALL
       SELECT 3457773, 788672, 36925
       UNION ALL
       SELECT 4135547, 792954, 33614
       UNION ALL
       SELECT 5120968, 795446, 36916
       UNION ALL
       SELECT 6741875, 798358, 36926
       UNION ALL
       SELECT 377605, 786013, 33620
       UNION ALL
       SELECT 377610, 784147, 33625
       UNION ALL
       SELECT 377613, 784248, 33627
       UNION ALL
       SELECT 494882, 791206, 36911
       UNION ALL
       SELECT 6128298, 797650, 33615
--       UNION ALL
--       SELECT 5062867, 795560, 36928),
--       UNION ALL
--       SELECT 5062903, 796840, 36929)
       UNION ALL
       SELECT 472116, 782888, 36917
       UNION ALL
       SELECT 1781716, 787665, 36912
       UNION ALL
       SELECT 6309262, 797779, 33621
       UNION ALL
       SELECT 377595, 771627, 33617
       UNION ALL
       SELECT 377574, 36487, 33623
       UNION ALL
       SELECT 377594, 764007, 33624
       UNION ALL
       SELECT 375626, 778684, 36915
       UNION ALL
       SELECT 394426, 781248, 36910
       UNION ALL
       SELECT 1529734, 787205, 36923
       UNION ALL
--       SELECT 183288, 778646, 36921
--       UNION ALL
       SELECT 183291, 759756, 36920
       UNION ALL
       SELECT 375627, 783978, 36922
       UNION ALL
       SELECT 183289, 2502, 36918
       UNION ALL
       SELECT 183290, 46305, 36919
       UNION ALL
       SELECT 2886778, 798006, 36927
       UNION ALL
       SELECT 5778622, 796682, 36930
       UNION ALL
       SELECT 377606, 785724, 33616
       UNION ALL
       SELECT 4103485, 792876, 36924
       UNION ALL
--       SELECT 7433764, 799909, 33619
--       UNION ALL
       SELECT 8156016, 800582, 36930
       UNION ALL
       SELECT 13311246, 800691, 37131
       UNION ALL
       SELECT 8698426, 801564, 37297
       UNION ALL
       SELECT 12812109, 801508, 37298
       UNION ALL
       SELECT 9771036, 803761, 38258
       UNION ALL
       SELECT 9951517, 804177, 38555
       UNION ALL
       SELECT 11300059, 0, 39791
       UNION ALL
       SELECT 8393158, 0, 40078
       UNION ALL
       SELECT 11769526, 0, 40453
       UNION ALL
       SELECT 12607257, 0, 41083
       UNION ALL
       SELECT 13338606, 0, 41556)

       SELECT
             Object_Unit_View.Id
           , tmpUnit.RegNumber
           , tmpUnit.SerialNumber
           , REPLACE(Object_Unit_View.Name, '/', '-')::TVarChar
       FROM tmpUnit AS tmpUnit
         INNER JOIN Object_Unit_View AS Object_Unit_View ON Object_Unit_View.Id = tmpUnit.UnitId;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 18.02.19        *
 19.07.18        *
 07.06.18        *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForSite ('3')
