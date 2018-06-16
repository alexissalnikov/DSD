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

   CREATE TEMP TABLE tmpUnit (UnitId Integer, RegNumber Integer, SerialNumber Integer) ON COMMIT DROP;

   INSERT INTO tmpUnit VALUES
       (183292, 22185, 32490),
       (183293, 773188, 33622),
       (183294, 775167, 33618),
       (6608396, 796362, 36914),
       (7117700, 798936, 33626),
       (3457773, 788672, 36925),
       (4135547, 792954, 33614),
       (5120968, 795446, 36916),
       (6741875, 798358, 36926),
       (377605, 786013, 33620),
       (377610, 784147, 33625),
       (377613, 784248, 33627),
       (494882, 791206, 36911),
       (6128298, 797650, 33615),
       (5062867, 795560, 36928),
       (5062903, 796840, 36929),
       (472116, 782888, 36917),
       (1781716, 787665, 36912),
       (6309262, 797779, 33621),
       (377595, 771627, 33617),
       (377574, 36487, 33623),
       (377594, 764007, 33624),
       (375626, 778684, 36915),
       (394426, 781248, 36910),
       (1529734, 787205, 36923),
       (183288, 778646, 36921),
       (183291, 759756, 36920),
       (375627, 783978, 36922),
       (183289, 2502, 36918),
       (183290, 46305, 36919),
       (2886778, 798006, 36927),
       (5778622, 796682, 36930),
       (377606, 785724, 33616),
       (4103485, 792876, 36924),
       (7433764, 799909, 33619);


   RETURN QUERY
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
 07.06.18        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_ExportPriceForSite ('3')