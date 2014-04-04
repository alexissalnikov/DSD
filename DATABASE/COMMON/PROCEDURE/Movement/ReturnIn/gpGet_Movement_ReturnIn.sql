-- Function: gpGet_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumberPartner TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar, Checked Boolean
             , OperDatePartner TDateTime
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractName TVarChar
             , PriceListId Integer, PriceListName TVarChar
             , DocumentTaxKindId Integer, DocumentTaxKindName TVarChar
             )
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_returnin_seq') AS TVarChar) AS InvNumber
             , ''::TVarChar AS InvNumberPartner
             , inOperDate						        AS OperDate
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , CAST (False as Boolean)                  AS Checked
             , inOperDate				      		    AS OperDatePartner
             , CAST (False as Boolean)                  AS PriceWithVAT
             , CAST (TaxPercent_View.Percent as TFloat) AS VATPercent
             , CAST (0 as TFloat)                       AS ChangePercent
             , CAST (0 as TFloat)                       AS TotalCount
             , CAST (0 as TFloat)                       AS TotalSummMVAT
             , CAST (0 as TFloat)                       AS TotalSummPVAT
             , CAST (0 as TFloat)                       AS TotalSumm
             , 0                     				    AS FromId
             , CAST ('' as TVarChar) 			        AS FromName
             , 0                     				    AS ToId
             , CAST ('' as TVarChar) 				    AS ToName
             , 0                     				    AS PaidKindId
             , CAST ('' as TVarChar) 				    AS PaidKindName
             , 0                     				    AS ContractId
             , CAST ('' as TVarChar) 				    AS ContractName
             , CAST (0  as INTEGER)                     AS PriceListId
             , CAST ('' as TVarChar) 				    AS PriceListName
             , 0                     				    AS DocumentTaxKindId
             , CAST ('' as TVarChar) 				    AS DocumentTaxKindName


          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
          LEFT JOIN TaxPercent_View ON inOperDate BETWEEN TaxPercent_View.StartDate AND TaxPercent_View.EndDate;
     ELSE

     RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , Movement.OperDate
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName
           , MovementBoolean_Checked.ValueData      AS Checked
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , MovementFloat_TotalSummMVAT.ValueData  AS TotalSummMVAT
           , MovementFloat_TotalSummPVAT.ValueData  AS TotalSummPVAT
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm
           , Object_From.Id                    	    AS FromId
           , Object_From.ValueData             	    AS FromName
           , Object_To.Id                      	    AS ToId
           , Object_To.ValueData               	    AS ToName
           , Object_PaidKind.Id                	    AS PaidKindId
           , Object_PaidKind.ValueData         	    AS PaidKindName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractName
           , Object_PriceList.id                    AS PriceListId
           , Object_PriceList.valuedata             AS PriceListName
           , Object_TaxKind.Id                	    AS DocumentTaxKindId
           , Object_TaxKind.ValueData         	    AS DocumentTaxKindName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
           
            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                   ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                  AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
            
            LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                      ON MovementBoolean_Checked.MovementId =  Movement.Id
                                     AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                    ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPVAT
                                    ON MovementFloat_TotalSummPVAT.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummPVAT.DescId = zc_MovementFloat_TotalSummPVAT()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MovementLinkObject_Contract.ObjectId

--add Tax
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                         ON MovementLinkObject_DocumentTaxKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()

            LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = MovementLinkObject_DocumentTaxKind.ObjectId

         LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                              ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()


-- PriceList Partner

         LEFT JOIN ObjectDate AS ObjectDate_PartnerStartPromo
                              ON ObjectDate_PartnerStartPromo.ObjectId = Object_From.Id
                             AND ObjectDate_PartnerStartPromo.DescId = zc_ObjectDate_Partner_StartPromo()

         LEFT JOIN ObjectDate AS ObjectDate_PartnerEndPromo
                              ON ObjectDate_PartnerEndPromo.ObjectId = Object_From.Id
                             AND ObjectDate_PartnerEndPromo.DescId = zc_ObjectDate_Partner_EndPromo()

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceListPromo
                              ON ObjectLink_Partner_PriceListPromo.ObjectId = Object_From.Id
                             AND ObjectLink_Partner_PriceListPromo.DescId = zc_ObjectLink_Partner_PriceListPromo()
                             AND Movement.operdate BETWEEN ObjectDate_PartnerStartPromo.valuedata AND ObjectDate_PartnerEndPromo.valuedata

         LEFT JOIN ObjectLink AS ObjectLink_Partner_PriceList
                              ON ObjectLink_Partner_PriceList.ObjectId = Object_From.Id
                             AND ObjectLink_Partner_PriceList.DescId = zc_ObjectLink_Partner_PriceList()
                             AND ObjectLink_Partner_PriceListPromo.ObjectId IS NULL
-- PriceList Juridical
         LEFT JOIN ObjectDate AS ObjectDate_JuridicalStartPromo
                              ON ObjectDate_JuridicalStartPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectDate_JuridicalStartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()

         LEFT JOIN ObjectDate AS ObjectDate_JuridicalEndPromo
                              ON ObjectDate_JuridicalEndPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectDate_JuridicalEndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()


         LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                              ON ObjectLink_Juridical_PriceListPromo.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
                             AND (ObjectLink_Partner_PriceListPromo.ChildObjectId IS NULL OR ObjectLink_Partner_PriceList.ChildObjectId IS NULL)-- ����� � �� ���������
                             AND Movement.operdate BETWEEN ObjectDate_JuridicalStartPromo.valuedata AND ObjectDate_JuridicalEndPromo.valuedata

         LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                              ON ObjectLink_Juridical_PriceList.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
                             AND ObjectLink_Juridical_PriceListPromo.ObjectId IS NULL

         LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = COALESCE (COALESCE (COALESCE (COALESCE (ObjectLink_Partner_PriceListPromo.ChildObjectId, ObjectLink_Partner_PriceList.ChildObjectId),ObjectLink_Juridical_PriceListPromo.ChildObjectId),ObjectLink_Juridical_PriceList.ChildObjectId),zc_PriceList_Basis())



         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ReturnIn();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ReturnIn (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.     ������ �.�.
 02.04.14                         * add InvNumberPartner
 13.02.14                                                            * add PriceList
 10.02.14                                                            * add TaxKind
 09.02.14                                        * add Object_Contract_InvNumber_View
 27.01.14                                                          * -Car -Driver +Checked +id=0
 17.07.13         *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 1, inSession:= '2')