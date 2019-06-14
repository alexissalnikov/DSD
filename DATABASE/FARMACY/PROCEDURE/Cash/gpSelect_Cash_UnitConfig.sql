-- Function: gpSelect_Cash_UnitConfig()

DROP FUNCTION IF EXISTS gpSelect_Cash_UnitConfig (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Cash_UnitConfig (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UnitConfig (
    IN inCashRegister   TVarChar,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (id Integer, Code Integer, Name TVarChar,
               ParentName TVarChar,
               TaxUnitNight Boolean, TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime,
               TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime,
               isSP Boolean, DateSP TDateTime, StartTimeSP TDateTime, EndTimeSP TDateTime,
               FtpDir TVarChar, DividePartionDate Boolean,
               Helsi_IdSP Integer, Helsi_Id TVarChar, Helsi_be TVarChar, Helsi_ClientId TVarChar, 
               Helsi_ClientSecret TVarChar, Helsi_IntegrationClient TVarChar
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbCashRegisterId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;


   if EXISTS(SELECT Object_CashRegister.Id
             FROM Object AS Object_CashRegister
             WHERE Object_CashRegister.DescId = zc_Object_CashRegister()
               AND Object_CashRegister.ValueData = inCashRegister)
   THEN
     SELECT Object_CashRegister.Id
     INTO vbCashRegisterId
     FROM Object AS Object_CashRegister
     WHERE Object_CashRegister.DescId = zc_Object_CashRegister()
       AND Object_CashRegister.ValueData = inCashRegister;
   ELSE
     vbCashRegisterId := 0;
   END IF;

   RETURN QUERY
   WITH tmpTaxUnitNight AS (SELECT  ObjectLink_TaxUnit_Unit.ChildObjectId               AS UnitId
                            FROM ObjectLink AS ObjectLink_TaxUnit_Unit

                                 LEFT JOIN Object AS Object_TaxUnit
                                                  ON Object_TaxUnit.Id = ObjectLink_TaxUnit_Unit.ObjectId
                                                 AND COALESCE (Object_TaxUnit.isErased, False) = False

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                       ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()


                            WHERE ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
                              AND Object_TaxUnit.isErased = False
                              AND COALESCE(ObjectFloat_Value.ValueData, 0) <> 0)


   SELECT
         Object_Unit.Id                                      AS Id
       , Object_Unit.ObjectCode                              AS Code
       , Object_Unit.ValueData                               AS Name

       , Object_Parent.ValueData                             AS ParentName

       , COALESCE (tmpTaxUnitNight.UnitId, 0) <> 0
         AND COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00'
         AND COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00'                 AS TaxUnitNight

       , CASE WHEN COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitStart.ValueData ELSE Null END ::TDateTime  AS TaxUnitStartDate
       , CASE WHEN COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitEnd.ValueData ELSE Null END ::TDateTime  AS TaxUnitEndDate

       , COALESCE (ObjectDate_TimePUSHFinal1.ValueData, ('01.01.2019 21:00')::TDateTime) AS TimePUSHFinal1
       , ObjectDate_TimePUSHFinal2.ValueData                                             AS TimePUSHFinal2

       , COALESCE (ObjectBoolean_SP.ValueData, FALSE)  :: Boolean   AS isSP
       , ObjectDate_SP.ValueData                       :: TDateTime AS DateSP
       , CASE WHEN COALESCE (ObjectDate_StartSP.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartSP.ValueData ELSE Null END :: TDateTime AS StartTimeSP
       , CASE WHEN COALESCE (ObjectDate_EndSP.ValueData ::Time,'00:00')   <> '00:00' THEN ObjectDate_EndSP.ValueData ELSE Null END   :: TDateTime AS EndTimeSP
       , CASE WHEN Object_Parent.ID IN (7433754, 4103484, 10127251) 
         THEN 'Franchise' 
         ELSE '' END::TVarChar                               AS FtpDir

      , COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)  :: Boolean   AS DividePartionDate

         
      , CASE WHEN COALESCE (ObjectBoolean_RedeemByHandSP.ValueData, FALSE) = FALSE THEN Object_Helsi_IdSP.Id
        ELSE NULL::Integer END                               AS Helsi_IdSP
       , Object_Helsi_Id.ValueData                           AS Helsi_Id
       , Object_Helsi_be.ValueData                           AS Helsi_be
       , Object_Helsi_ClientId.ValueData                     AS Helsi_ClientId
       , Object_Helsi_ClientSecret.ValueData                 AS Helsi_ClientSecret
       , Object_Helsi_IntegrationClient.ValueData            AS Helsi_IntegrationClient

   FROM Object AS Object_Unit

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitStart
                             ON ObjectDate_TaxUnitStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitStart.DescId = zc_ObjectDate_Unit_TaxUnitStart()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitEnd
                             ON ObjectDate_TaxUnitEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitEnd.DescId = zc_ObjectDate_Unit_TaxUnitEnd()

        LEFT JOIN tmpTaxUnitNight ON tmpTaxUnitNight.UnitID = Object_Unit.Id

        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal1
                              ON ObjectDate_TimePUSHFinal1.ObjectId = vbCashRegisterId
                             AND ObjectDate_TimePUSHFinal1.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal1()

        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal2
                              ON ObjectDate_TimePUSHFinal2.ObjectId = vbCashRegisterId
                             AND ObjectDate_TimePUSHFinal2.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal2()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SP 
                                ON ObjectBoolean_SP.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SP.DescId = zc_ObjectBoolean_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_SP
                             ON ObjectDate_SP.ObjectId = Object_Unit.Id
                            AND ObjectDate_SP.DescId = zc_ObjectDate_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_StartSP
                             ON ObjectDate_StartSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartSP.DescId = zc_ObjectDate_Unit_StartSP()

        LEFT JOIN ObjectDate AS ObjectDate_EndSP
                             ON ObjectDate_EndSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndSP.DescId = zc_ObjectDate_Unit_EndSP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()

        LEFT JOIN Object AS Object_Helsi_IdSP ON Object_Helsi_IdSP.DescId = zc_Object_SPKind()
                                             AND Object_Helsi_IdSP.ObjectCode  = 1
        LEFT JOIN Object AS Object_Helsi_Id ON Object_Helsi_Id.Id = zc_Enum_Helsi_Id()
        LEFT JOIN Object AS Object_Helsi_be ON Object_Helsi_be.Id = zc_Enum_Helsi_be()
        LEFT JOIN Object AS Object_Helsi_ClientId ON Object_Helsi_ClientId.Id = zc_Enum_Helsi_ClientId()
        LEFT JOIN Object AS Object_Helsi_ClientSecret ON Object_Helsi_ClientSecret.Id = zc_Enum_Helsi_ClientSecret()
        LEFT JOIN Object AS Object_Helsi_IntegrationClient ON Object_Helsi_IntegrationClient.Id = zc_Enum_Helsi_IntegrationClient()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RedeemByHandSP
                                ON ObjectBoolean_RedeemByHandSP.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RedeemByHandSP.DescId = zc_ObjectBoolean_Unit_RedeemByHandSP()

   WHERE Object_Unit.Id = vbUnitId
   --LIMIT 1
   ;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 14.06.19                                                       *
 21.04.19                                                       *
 05.04.19                                                       *
 22.03.19                                                       *
 20.02.19                                                       *

*/

-- ����
-- SELECT * FROM gpSelect_Cash_UnitConfig('3000497773', '308120')