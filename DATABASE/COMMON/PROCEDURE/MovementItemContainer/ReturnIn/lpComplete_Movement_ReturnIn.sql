-- Function: lpComplete_Movement_ReturnIn (Integer, Integer, Boolean)

-- DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpComplete_Movement_ReturnIn (Integer, TDateTime, Integer, Boolean);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ReturnIn(
    IN inMovementId        Integer               , -- ���� ���������
    IN inStartDateSale     TDateTime             , --
   OUT outMessageText      Text                  ,
    IN inUserId            Integer               , -- ������������
    IN inIsLastComplete    Boolean  DEFAULT False  -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
)
RETURNS Text
AS
$BODY$
  DECLARE vbIsHistoryCost Boolean; -- ����� �������� �/� ��� ����� ������������

  DECLARE vbContainerId_Analyzer Integer;
  DECLARE vbContainerId_Analyzer_PartnerTo Integer;
  DECLARE vbWhereObjectId_Analyzer Integer;
  DECLARE vbObjectExtId_Analyzer Integer;
  DECLARE vbAccountId_GoodsTransit Integer;

  DECLARE vbMovementDescId Integer;
  DECLARE vbMovementId_parent Integer;

  DECLARE vbOperSumm_PriceList_byItem TFloat;
  DECLARE vbOperSumm_PriceList TFloat;
  DECLARE vbOperSumm_Partner_byItem TFloat;
  DECLARE vbOperSumm_Partner TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent_byItem TFloat;
  DECLARE vbOperSumm_Partner_ChangePercent TFloat;

  DECLARE vbPriceWithVAT_PriceList Boolean;
  DECLARE vbVATPercent_PriceList TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;

  DECLARE vbOperDate TDateTime;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbJuridicalId_From Integer;
  DECLARE vbIsCorporate_From Boolean;
  DECLARE vbInfoMoneyId_CorporateFrom Integer;
  DECLARE vbPartnerId_From Integer;
  DECLARE vbMemberId_From Integer;
  DECLARE vbInfoMoneyDestinationId_From Integer;
  DECLARE vbInfoMoneyId_From Integer;

  DECLARE vbUnitId_To Integer;
  DECLARE vbMemberId_To Integer;
  DECLARE vbBranchId_To Integer;
  DECLARE vbAccountDirectionId_To Integer;
  DECLARE vbIsPartionDate_Unit Boolean;
  DECLARE vbUnitId_HistoryCost Integer;

  DECLARE vbJuridicalId_To Integer;
  DECLARE vbPartnerId_To Integer;
  DECLARE vbPaidKindId_To Integer;
  DECLARE vbContractId_To Integer;
  DECLARE vbInfoMoneyDestinationId_To Integer;
  DECLARE vbInfoMoneyId_To Integer;

  DECLARE vbPaidKindId Integer;
  DECLARE vbContractId Integer;
  DECLARE vbJuridicalId_Basis_To Integer;
  DECLARE vbBusinessId_To Integer;

  DECLARE curContainer refcursor;
  DECLARE vbContainerId_Goods Integer;
  DECLARE vbContainerId_Summ_Alternative Integer;
  DECLARE vbContainerDescId Integer;
  DECLARE vbContainerObjectId Integer;

  DECLARE vbIsPartionDoc_Branch Boolean;

BEGIN
     -- !!!��������!!!
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= inMovementId);


     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������������� ContainerId
     DELETE FROM _tmpList_Alternative;
     -- !!!�����������!!! �������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItemSumm;
     -- !!!�����������!!! �������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


     -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId = zc_Enum_Role_Admin())
     THEN IF inIsLastComplete = FALSE
     -- !!! ����� ��� ��� ���������, ������� ��� ��������!!!
     -- !!! OR 301310 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
     -- !!! ����� ��� ��� ������, ������� ��� ��������!!!
     -- !!! OR 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = inUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId)
          THEN vbIsHistoryCost:= TRUE;
          ELSE vbIsHistoryCost:= FALSE;
          END IF;
          vbIsHistoryCost:= TRUE;
     ELSE
         -- !!! ��� ��������� ���� ����� �������� �/�!!!
         IF 0 < (SELECT 1 FROM Object_RoleAccessKeyGuide_View AS View_RoleAccessKeyGuide WHERE View_RoleAccessKeyGuide.UserId = inUserId AND View_RoleAccessKeyGuide.BranchId <> 0 GROUP BY View_RoleAccessKeyGuide.BranchId LIMIT 1)
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (428382)) -- ��������� �����
           OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS View_UserRole WHERE View_UserRole.UserId = inUserId AND View_UserRole.RoleId IN (97837)) -- ��������� �����
         THEN vbIsHistoryCost:= FALSE;
         ELSE vbIsHistoryCost:= TRUE;
         END IF;
     END IF;


     -- ��� ��������� ����� ���
     SELECT lfObject_PriceList.PriceWithVAT, lfObject_PriceList.VATPercent
            INTO vbPriceWithVAT_PriceList, vbVATPercent_PriceList
     FROM lfGet_Object_PriceList (zc_PriceList_Basis()) AS lfObject_PriceList;


     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� ��� ��������� � ��� ������������ �������� � ���������
     SELECT CASE WHEN EXTRACT (MONTH FROM Movement.OperDate) < EXTRACT (MONTH FROM CURRENT_DATE)
                  AND EXTRACT (MONTH FROM CURRENT_DATE) = EXTRACT (MONTH FROM CURRENT_DATE - INTERVAL '7 DAY')
                      THEN TRUE
                 ELSE vbIsHistoryCost
            END AS isHistoryCost -- !!!��� ��� ������!!!
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE) AS PriceWithVAT
          , COALESCE (MovementFloat_VATPercent.ValueData, 0) AS VATPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE)            AS isDiscountPrice_juridical

          , Movement.DescId                                                      AS MovementDescId
          , COALESCE (Movement.ParentId, 0)                                      AS MovementId_parent
          , Movement.OperDate                                                    AS OperDate -- COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) AS OperDatePartner

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_isCorporate.ValueData, FALSE)
            END AS IsCorporate_From

          , CASE WHEN Constant_InfoMoney_isCorporate_View.InfoMoneyId IS NOT NULL
                      THEN ObjectLink_Juridical_InfoMoney.ChildObjectId
                 ELSE 0
            END AS InfoMoneyId_CorporateFrom

          , COALESCE (CASE WHEN Object_From.DescId = zc_Object_Partner() THEN Object_From.Id ELSE 0 END, 0) AS PartnerId_From
          , 0 AS MemberId_From -- COALESCE (CASE WHEN Object_From.DescId = zc_Object_Member() THEN Object_From.Id WHEN Object_From.DescId = zc_Object_Personal() THEN ObjectLink_PersonalFrom_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_From

            -- �� ������ ���������� �����: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
          , COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_From -- COALESCE (ObjectLink_Contract_InfoMoney.ChildObjectId, COALESCE (ObjectLink_Juridical_InfoMoney.ChildObjectId, 0)) AS InfoMoneyId_From

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN Object_To.Id ELSE 0 END, 0) AS UnitId_To
          , 0 AS MemberId_To -- COALESCE (CASE WHEN Object_To.DescId = zc_Object_Member() THEN Object_To.Id WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_PersonalTo_Member.ChildObjectId ELSE 0 END, 0) AS MemberId_To
          , COALESCE (CASE WHEN ObjectLink_Partner_Branch.ChildObjectId <> 0
                                THEN ObjectLink_Partner_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Unit()
                                THEN ObjectLink_UnitTo_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Partner()
                                THEN ObjectLink_PartnerTo_Branch.ChildObjectId

                           WHEN Object_To.DescId = zc_Object_Personal()
                                THEN ObjectLink_UnitPersonalTo_Branch.ChildObjectId
                           ELSE 0
                      END, 0) AS BranchId_To
          , CASE WHEN MovementLinkObject_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm() AND COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate) >= '01.05.2015'
                      THEN COALESCE (ObjectBoolean_PartionDoc.ValueData, FALSE)
                 ELSE FALSE
            END AS isPartionDoc_Branch
          , COALESCE (ObjectLink_UnitTo_AccountDirection.ChildObjectId, 0) AS AccountDirectionId_To -- ��������� ������ - ����������� !!!����� ������ ��� �������������!!!
          , COALESCE (ObjectBoolean_PartionDate.ValueData, FALSE) AS isPartionDate_Unit
          , COALESCE (ObjectLink_UnitTo_HistoryCost.ChildObjectId, 0) AS UnitId_HistoryCost

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_PartnerTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Partner() THEN Object_To.Id ELSE 0 END, 0) AS PartnerId_To
          , COALESCE (MovementLinkObject_PaidKindTo.ObjectId, 0) AS PaidKindId_To
          , COALESCE (MovementLinkObject_ContractTo.ObjectId, 0) AS ContractId_To
            -- �� ������ ���������� �����: ������ �� ��������
          , COALESCE (ObjectLink_ContractTo_InfoMoney.ChildObjectId, 0) AS InfoMoneyId_To

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0) AS PaidKindId
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId

          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Juridical.ChildObjectId WHEN Object_To.DescId = zc_Object_Partner() THEN ObjectLink_ContractTo_JuridicalBasis.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Juridical.ChildObjectId ELSE 0 END, 0) AS JuridicalId_Basis_To
          , COALESCE (CASE WHEN Object_To.DescId = zc_Object_Unit() THEN ObjectLink_UnitTo_Business.ChildObjectId WHEN Object_To.DescId = zc_Object_Personal() THEN ObjectLink_UnitPersonalTo_Business.ChildObjectId ELSE 0 END, 0) AS BusinessId_To

            INTO vbIsHistoryCost, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice
               , vbMovementDescId, vbMovementId_parent, vbOperDate, vbOperDatePartner
               , vbJuridicalId_From, vbIsCorporate_From, vbInfoMoneyId_CorporateFrom, vbPartnerId_From , vbMemberId_From, vbInfoMoneyId_From
               , vbUnitId_To, vbMemberId_To, vbBranchId_To, vbIsPartionDoc_Branch, vbAccountDirectionId_To, vbIsPartionDate_Unit, vbUnitId_HistoryCost
               , vbJuridicalId_To, vbPartnerId_To, vbPaidKindId_To, vbContractId_To, vbInfoMoneyId_To
               , vbPaidKindId, vbContractId
               , vbJuridicalId_Basis_To, vbBusinessId_To
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                   ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                  AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
          LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
          LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                 ON MovementFloat_ChangePercent.MovementId = Movement.Id
                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Branch
                               ON ObjectLink_UnitTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_AccountDirection
                               ON ObjectLink_UnitTo_AccountDirection.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDoc
                                  ON ObjectBoolean_PartionDoc.ObjectId = ObjectLink_UnitTo_Branch.ChildObjectId
                                 AND ObjectBoolean_PartionDoc.DescId = zc_ObjectBoolean_Branch_PartionDoc()
          LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                  ON ObjectBoolean_PartionDate.ObjectId = MovementLinkObject_To.ObjectId
                                 AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
                                 AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Juridical
                               ON ObjectLink_UnitTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_Business
                               ON ObjectLink_UnitTo_Business.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_To.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_UnitTo_HistoryCost
                               ON ObjectLink_UnitTo_HistoryCost.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_UnitTo_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()

          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Member
                               ON ObjectLink_PersonalTo_Member.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_PersonalTo_Unit
                               ON ObjectLink_PersonalTo_Unit.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PersonalTo_Unit.DescId = zc_ObjectLink_Personal_Unit()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Branch
                               ON ObjectLink_UnitPersonalTo_Branch.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Branch.DescId = zc_ObjectLink_Unit_Branch()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Juridical
                               ON ObjectLink_UnitPersonalTo_Juridical.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                              AND Object_To.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_UnitPersonalTo_Business
                               ON ObjectLink_UnitPersonalTo_Business.ObjectId = ObjectLink_PersonalTo_Unit.ChildObjectId
                              AND ObjectLink_UnitPersonalTo_Business.DescId = zc_ObjectLink_Unit_Business()
                              AND Object_To.DescId = zc_Object_Personal()

          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Juridical
                               ON ObjectLink_PartnerTo_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PartnerTo_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_To.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_PartnerTo_Branch
                               ON ObjectLink_PartnerTo_Branch.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_PartnerTo_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!�� ������!!!
                              AND Object_To.DescId = zc_Object_Partner()
                              AND 1 = 0 -- ����� ��� ��� ��� ������

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalFrom_Member
                               ON ObjectLink_PersonalFrom_Member.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_PersonalFrom_Member.DescId = zc_ObjectLink_Personal_Member()
                              AND Object_From.DescId = zc_Object_Personal()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                              AND Object_From.DescId = zc_Object_Partner()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Branch
                               ON ObjectLink_Partner_Branch.ObjectId = MovementLinkObject_From.ObjectId
                              AND ObjectLink_Partner_Branch.DescId = zc_ObjectLink_Unit_Branch() -- !!!�� ������!!!
                              AND Object_From.DescId = zc_Object_Partner()
                              AND 1 = 0 -- ����� ��� ��� ��� ������
          LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                  ON ObjectBoolean_isCorporate.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                               ON ObjectLink_Juridical_InfoMoney.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
          LEFT JOIN Constant_InfoMoney_isCorporate_View ON Constant_InfoMoney_isCorporate_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                  ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                 AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKindTo
                                       ON MovementLinkObject_PaidKindTo.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKindTo.DescId = zc_MovementLinkObject_PaidKindTo()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ContractTo
                                       ON MovementLinkObject_ContractTo.MovementId = Movement.Id
                                      AND MovementLinkObject_ContractTo.DescId = zc_MovementLinkObject_ContractTo()
          LEFT JOIN ObjectLink AS ObjectLink_ContractTo_InfoMoney
                               ON ObjectLink_ContractTo_InfoMoney.ObjectId = MovementLinkObject_ContractTo.ObjectId
                              AND ObjectLink_ContractTo_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()
          LEFT JOIN ObjectLink AS ObjectLink_ContractTo_JuridicalBasis
                               ON ObjectLink_ContractTo_JuridicalBasis.ObjectId = MovementLinkObject_ContractTo.ObjectId
                              AND ObjectLink_ContractTo_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                       ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                      AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectLink AS ObjectLink_Contract_InfoMoney
                               ON ObjectLink_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                              AND ObjectLink_Contract_InfoMoney.DescId = zc_ObjectLink_Contract_InfoMoney()

     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- ��������
     IF (vbOperDate <> vbOperDatePartner) AND (vbPartnerId_To <> 0)
     THEN
         RAISE EXCEPTION '������.�������� <����(�����)> ������ ��������������� �������� <���� ��������� � ����������>.';
     END IF;


     -- ������������ �������������� ����������, �������� ����� ��� ��� ������������ �������� � ��������� (��� ����������)
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_From FROM lfGet_Object_InfoMoney (vbInfoMoneyId_From) AS View_InfoMoney;
     SELECT View_InfoMoney.InfoMoneyDestinationId INTO vbInfoMoneyDestinationId_To FROM lfGet_Object_InfoMoney (vbInfoMoneyId_To) AS View_InfoMoney;

     -- !!!���� ��� ������� ��� "�������� ������������", ����� ��� "������� ������"
     IF COALESCE (vbBranchId_To, 0) = 0
        /*vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_30100() -- ���������
                                        , zc_Enum_InfoMoneyDestination_30200() -- ������ �����
                                         )
        AND vbBranchId_To = 0*/
     THEN
         vbBranchId_To:= zc_Branch_Basis();
     END IF;


     IF vbOperDatePartner < '01.08.2016' OR vbPaidKindId = zc_Enum_PaidKind_SecondForm()
        OR NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE)
     THEN
         -- !!!�����������!!!
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), MovementItem.Id
                                                 , CASE WHEN vbOperDatePartner < '01.08.2016'
                                                             THEN vbExtraChargesPercent - vbDiscountPercent
                                                        WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbOperDate < zc_isReturnInNAL_bySale()
                                                             THEN vbExtraChargesPercent - vbDiscountPercent
                                                        WHEN 1=1 AND MIFloat_PromoMovement.ValueData > 0
                                                             THEN COALESCE (MIFloat_ChangePercent.ValueData, 0)
                                                        ELSE vbExtraChargesPercent - vbDiscountPercent
                                                   END
                                                  )
         FROM MovementItem
              LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                          ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
              LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Master();
     END IF;


     -- ��������� ������� - �������������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItem (MovementItemId
                         , ContainerId_Goods, ContainerId_GoodsPartner, ContainerId_GoodsTransit, GoodsId, GoodsKindId, AssetId, PartionGoods, PartionGoodsDate, ChangePercent, isChangePrice
                         , OperCount, OperCount_Partner, tmpOperSumm_PriceList, OperSumm_PriceList, tmpOperSumm_Partner, tmpOperSumm_Partner_original, OperSumm_Partner, OperSumm_Partner_ChangePercent
                         , ContainerId_ProfitLoss_10700
                         , ContainerId_Partner, AccountId_Partner, InfoMoneyDestinationId, InfoMoneyId
                         , BusinessId_To
                         , isPartionCount, isPartionSumm, isTareReturning
                         , PartionGoodsId, PartionMovementId
                         , PriceListPrice, Price, Price_original, CountForPrice)
    WITH tmpMI_all AS
             (SELECT (MovementItem.Id) AS MovementItemId
                   , MovementItem.ObjectId AS GoodsId
                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId

                   , SUM (MovementItem.Amount) AS OperCount
                   , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner
                   , COALESCE (MIFloat_Price.ValueData, 0)         AS Price_original
                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                   , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                   , COALESCE (MIFloat_MovementId.ValueData, 0) :: Integer AS MovementId_Partion

                   , COALESCE (MILinkObject_Asset.ObjectId, 0)              AS AssetId
                   , COALESCE (MIString_PartionGoods.ValueData, '')         AS PartionGoods
                   , COALESCE (MIDate_PartionGoods.ValueData, zc_DateEnd()) AS PartionGoodsDate

              FROM MovementItem

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                   LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                               ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                              AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                               ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()

                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                    ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()

                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                             AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId     = zc_MI_Master()
                AND MovementItem.isErased   = FALSE
                AND vbMovementDescId        = zc_Movement_ReturnIn()
              GROUP BY MovementItem.Id
                     , MovementItem.ObjectId
                     , MILinkObject_GoodsKind.ObjectId
                     , MIFloat_Price.ValueData
                     , MIFloat_CountForPrice.ValueData
                     , MIFloat_ChangePercent.ValueData
                     , MIFloat_MovementId.ValueData
                     , MILinkObject_Asset.ObjectId
                     , MIString_PartionGoods.ValueData
                     , MIDate_PartionGoods.ValueData
             )
  , tmpChangePrice AS (SELECT TRUE AS isChangePrice
                       FROM tmpMI_all
                       WHERE (vbIsDiscountPrice = TRUE                    -- � �� ���� ���� �����
                           OR tmpMI_all.ChangePercent = 0                 -- � ����� ���� ������, �� ���� ���� ���� ������� �� ������� = 0%
                           OR vbPaidKindId = zc_Enum_PaidKind_FirstForm() -- ��� ��
                             )
                         AND (vbDiscountPercent <> 0 OR vbExtraChargesPercent <> 0)
                       LIMIT 1
                      )
     , tmpPL_Basis AS (-- ���� �� ������ ��������, ��� ��������
                       SELECT DISTINCT
                              tmpMI_all.GoodsId
                            , ObjectLink_PriceListItem_GoodsKind.ChildObjectId AS GoodsKindId
                            , COALESCE (ObjectHistoryFloat_PriceListItem_Value.ValueData, 0) AS PriceListPrice
                       FROM tmpMI_all
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_Goods
                                                  ON ObjectLink_PriceListItem_Goods.ChildObjectId = tmpMI_all.GoodsId
                                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                            INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                  ON ObjectLink_PriceListItem_PriceList.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                 AND ObjectLink_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis()
                                                 AND ObjectLink_PriceListItem_PriceList.DescId = zc_ObjectLink_PriceListItem_PriceList()
                            LEFT JOIN ObjectLink AS ObjectLink_PriceListItem_GoodsKind
                                                 ON ObjectLink_PriceListItem_GoodsKind.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                AND ObjectLink_PriceListItem_GoodsKind.DescId   = zc_ObjectLink_PriceListItem_GoodsKind()
                            LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                    ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_Goods.ObjectId
                                                   AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                   AND vbOperDatePartner >= ObjectHistory_PriceListItem.StartDate AND vbOperDatePartner < ObjectHistory_PriceListItem.EndDate
                            LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                         ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                        AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                      )
               , tmpMI_child AS (SELECT MovementItem.ParentId       AS ParentId
                                      , MAX (Movement_Tax.OperDate) AS OperDate_tax
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                  ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                      LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MIFloat_MovementId.ValueData :: Integer
                                      LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                     ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                                                    AND MovementLinkMovement_Tax.DescId     = zc_MovementLinkMovement_Master()
                                      LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId     = zc_MI_Child()
                                   AND MovementItem.isErased   = FALSE
                                   AND MovementItem.Amount     <> 0
                                 GROUP BY MovementItem.ParentId
                                )
           , tmpMI AS (SELECT tmpMI_all.MovementItemId
                            , tmpMI_all.GoodsId
                            , tmpMI_all.GoodsKindId
                            , tmpMI_all.AssetId
                            , tmpMI_all.PartionGoods
                            , tmpMI_all.PartionGoodsDate
                            , tmpMI_all.ChangePercent
                            , COALESCE (tmpChangePrice.isChangePrice, FALSE) AS isChangePrice

                            , tmpMI_all.OperCount
                            , tmpMI_all.OperCount_Partner
                            , CASE WHEN tmpChangePrice.isChangePrice = TRUE -- !!!��� ��� "������" �� ���������, ��� �� - ������ ���������!!!
                                        THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child.OperDate_tax, vbOperDatePartner)
                                                                 , inChangePercent:= tmpMI_all.ChangePercent
                                                                 , inPrice        := tmpMI_all.Price_original
                                                                 , inIsWithVAT    := vbPriceWithVAT
                                                                  )
                                   ELSE tmpMI_all.Price_original
                              END AS Price
                            , tmpMI_all.Price_original
                            , tmpMI_all.CountForPrice

                            , tmpMI_all.MovementId_Partion

                       FROM tmpMI_all
                            LEFT JOIN tmpChangePrice ON tmpChangePrice.isChangePrice = TRUE
                            LEFT JOIN tmpMI_child ON tmpMI_child.ParentId = tmpMI_all.MovementItemId
                      )
        -- ���������
        SELECT
              _tmp.MovementItemId
            , 0 AS ContainerId_Goods
            , 0 AS ContainerId_GoodsPartner
            , 0 AS ContainerId_GoodsTransit -- ���� - ���-�� �������
            , _tmp.GoodsId
            , _tmp.GoodsKindId
            , _tmp.AssetId
            , _tmp.PartionGoods
            , _tmp.PartionGoodsDate
            , _tmp.ChangePercent
            , _tmp.isChangePrice

              -- ���������� � �������
            , _tmp.OperCount
              -- ���������� � �����������
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN _tmp.OperCount
                   ELSE _tmp.OperCount_Partner
              END AS OperCount_Partner

              -- ������������� (� ����� ���-��) ����� �����-����� �� ����������� !!!��� ������!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_PriceList
              -- �������� ����� �����-����� �� ����������� !!! ��� ������ !!!
            , CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                      THEN _tmp.tmpOperSumm_PriceList
                   WHEN vbVATPercent_PriceList > 0
                      -- ���� ���� ��� ���, ����� �������� ����� � ���
                      THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmp.tmpOperSumm_PriceList AS NUMERIC (16, 2))
              END AS OperSumm_PriceList

              -- ������������� ����� �� ����������� !!!����� ��� ������(�.�. ������ ���� ����)!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner
              -- ������������� (� ����� ���-��) ����� �� ����������� !!!��� ������!!! - � ����������� �� 2-� ������
            , _tmp.tmpOperSumm_Partner_original

              -- �������� ����� �� ����������� !!!��� ������!!!
            , CASE WHEN vbPriceWithVAT = TRUE  OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                      THEN _tmp.tmpOperSumm_Partner_original
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� �������� ����� � ���
                      THEN CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
              END AS OperSumm_Partner -- !!!���������!!!

              -- �������� ����� �� �����������
            , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                                ELSE _tmp.tmpOperSumm_Partner
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN _tmp.isChangePrice = FALSE AND _tmp.ChangePercent <> 0 THEN CAST ( (1 + _tmp.ChangePercent / 100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                -- WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2))
                           END
                   WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                      THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmp.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp.tmpOperSumm_Partner) AS NUMERIC (16, 2))
                           END
              END AS OperSumm_Partner_ChangePercent

              -- ���� - ������� (���� - ����� ���������)
            , 0 AS ContainerId_ProfitLoss_10700

              -- ���� - ���� �����������
            , 0 AS ContainerId_Partner
              -- ����(�����������) �����������
            , 0 AS AccountId_Partner
              -- �������������� ����������
            , _tmp.InfoMoneyDestinationId
              -- ������ ����������
            , _tmp.InfoMoneyId

              -- �������� ������ !!!����������!!! �� ������ ��� ������������/����������
            , CASE WHEN _tmp.BusinessId_To = 0 THEN vbBusinessId_To ELSE _tmp.BusinessId_To END AS BusinessId_To

            , _tmp.isPartionCount
            , _tmp.isPartionSumm

              -- ���������� �� ��� ���� (���� ��, ������������� �������� �� �������)
            , CASE WHEN _tmp.Price = 0
                    AND _tmp.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                        THEN TRUE
                   ELSE FALSE
              END AS isTareReturning

              -- ������ ������, ���������� �����
            , 0 AS PartionGoodsId
              -- ������ ��������, ���������� �����
            , CASE WHEN vbIsPartionDoc_Branch = TRUE
                        THEN lpInsertFind_Object_PartionMovement (_tmp.MovementId_Partion, NULL)
                   ELSE 0
              END AS PartionMovementId

            , _tmp.PriceListPrice
            , _tmp.Price
            , _tmp.Price_original
            , _tmp.CountForPrice

        FROM
             (SELECT
                    tmpMI.MovementItemId

                  , tmpMI.GoodsId
                  , CASE WHEN View_InfoMoney.InfoMoneyId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- ���� + ������� ��������� + ������ ������ �����
                              THEN tmpMI.GoodsKindId
                         WHEN View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
                              THEN tmpMI.GoodsKindId
                         ELSE 0
                    END AS GoodsKindId
                  , tmpMI.AssetId
                  , tmpMI.PartionGoods
                  , tmpMI.PartionGoodsDate
                  , tmpMI.ChangePercent
                  , tmpMI.isChangePrice

                  , COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS PriceListPrice
                  , tmpMI.Price
                  , tmpMI.Price_original
                  , tmpMI.CountForPrice
                    -- ���������� ��� ������
                  , tmpMI.OperCount
                    -- ���������� � �����������
                  , tmpMI.OperCount_Partner

                    -- ������������� ����� �����-����� �� ����������� - � ����������� �� 2-� ������
                  , COALESCE (CAST (tmpMI.OperCount_Partner * COALESCE (tmpPL_Basis_kind.PriceListPrice, tmpPL_Basis.PriceListPrice, 0) AS NUMERIC (16, 2)), 0) AS tmpOperSumm_PriceList
                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������ + ������ ������ � ���� (!!!���� ����!!!)
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner
                    -- ������������� ����� �� ����������� - � ����������� �� 2-� ������ + !!!��!!! ������ ������ � ����
                  , CASE WHEN tmpMI.CountForPrice <> 0 THEN CAST (tmpMI.OperCount_Partner * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_Partner * tmpMI.Price_original AS NUMERIC (16, 2))
                    END AS tmpOperSumm_Partner_original

                    -- �������������� ����������
                  , COALESCE (View_InfoMoney.InfoMoneyDestinationId, 0) AS InfoMoneyDestinationId
                    -- ������ ����������
                  , COALESCE (View_InfoMoney.InfoMoneyId, 0) AS InfoMoneyId

                    -- ������ �� ������
                  , COALESCE (ObjectLink_Goods_Business.ChildObjectId, 0) AS BusinessId_To

                  , COALESCE (ObjectBoolean_PartionCount.ValueData, FALSE)      AS isPartionCount
                  , COALESCE (ObjectBoolean_PartionSumm.ValueData, FALSE)       AS isPartionSumm

                    --
                  , tmpMI.MovementId_Partion

              FROM tmpMI

                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionCount
                                           ON ObjectBoolean_PartionCount.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionCount.DescId = zc_ObjectBoolean_Goods_PartionCount()
                   LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionSumm
                                           ON ObjectBoolean_PartionSumm.ObjectId = tmpMI.GoodsId
                                          AND ObjectBoolean_PartionSumm.DescId = zc_ObjectBoolean_Goods_PartionSumm()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Business
                                        ON ObjectLink_Goods_Business.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_Business.DescId = zc_ObjectLink_Goods_Business()
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                        ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                       AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                   -- ����������� ���� 2 ���� �� ���� � ���
                   LEFT JOIN tmpPL_Basis AS tmpPL_Basis_kind
                                         ON tmpPL_Basis_kind.GoodsId                   = tmpMI.GoodsId
                                        AND COALESCE (tmpPL_Basis_kind.GoodsKindId, 0) = COALESCE (tmpMI.GoodsKindId, 0)
                   LEFT JOIN tmpPL_Basis ON tmpPL_Basis.GoodsId     = tmpMI.GoodsId
                                        AND tmpPL_Basis.GoodsKindId IS NULL
             ) AS _tmp;

     -- !!!���� ���������� - ���� �� ������ � ����!!!
     vbIsChangePrice:= (SELECT _tmpItem.isChangePrice FROM _tmpItem LIMIT 1);

     -- ��������
     IF COALESCE (vbContractId, 0) = 0 AND (EXISTS (SELECT _tmpItem.isTareReturning FROM _tmpItem WHERE _tmpItem.isTareReturning = FALSE)
                                         -- OR !!! ��� !!!
                                           )
     THEN
         RAISE EXCEPTION '������.� ��������� �� ����������� �������� <�������>.���������� ����������.';
     END IF;
     -- �������� ��� ������ �������������
     IF inUserId <> zc_Enum_Process_Auto_PrimeCost() AND inUserId <> 5
        AND TRUE = (SELECT MovementBoolean.ValueData FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.DescId = zc_MovementBoolean_List())
        AND EXISTS (SELECT 1 FROM _tmpItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                               ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                                              AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                   WHERE COALESCE (MIFloat_MovementId.ValueData, 0) = 0)
     THEN
         RAISE EXCEPTION '������.� ��������� ���������� ������� <�������� � �����. � (��/���)>, �� �� � ���� ��������� ��������� <��������� � (�������)>.';
     END IF;


     -- !!!������ ����� ����� - � ��������� � ��������!!!
     IF zc_isReturnIn_bySale() = TRUE -- OR inUserId = 5
        -- !!!��� ���� ����������� - �����!!! + zc_Enum_Process_Auto_PrimeCost
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
                        WHERE UserId = inUserId
                          AND RoleId IN (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Role() AND Object.ObjectCode IN (3004, 4004, 5004, 6004, 7004, 8004, 8014, 9004))
                       )
        AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
        AND inUserId <> zc_Enum_Process_Auto_ReturnIn()
        AND inUserId <> 5
     THEN
         -- �������� ������
         outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                        , inUserId        := inUserId
                                                         );
         -- ��������� �������� <������>
         PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Error(), inMovementId, CASE WHEN outMessageText <> '' OR vbPaidKindId = zc_Enum_PaidKind_SecondForm() THEN TRUE ELSE FALSE END);

         -- !!!����� ���� ������!!!
         IF outMessageText <> '' AND outMessageText <> '-1' THEN RETURN; END IF;

         -- !!!� ����� ������� - ��� ����� ����� ���������!!!
         IF outMessageText = '-1' THEN outMessageText:= '�����.� ������������ <' || lfGet_Object_ValueData (inUserId) || '> ��� ���� ����������� �������� ��������� <������� �� ����������> � ��������� <�������>.'; END IF;

     END IF;


     -- !!! ������ �� ��� ������ �������� ��� ParentId ��������!!!
     IF inUserId NOT IN (5, zc_Enum_Process_Auto_PrimeCost()) AND vbMovementId_parent = 0 AND NOT EXISTS (SELECT OperCount FROM _tmpItem WHERE OperCount <> 0 LIMIT 1)
        AND NOT EXISTS (SELECT MovementBoolean.MovementId FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.ValueData = TRUE AND MovementBoolean.DescId = zc_MovementBoolean_isPartner())
     THEN
         RAISE EXCEPTION '������.%� ��������� �� ����������� �������� <��������� � (������� �������� �����������)>.%���������� ����������.', CHR(13), CHR(13);
     ELSE
         IF inUserId NOT IN (zc_Enum_Process_Auto_PrimeCost()) AND vbMovementId_parent = 0 AND NOT EXISTS (SELECT 1
                                                                                                           FROM MovementItem
                                                                                                                INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                                                                                             ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                                                                                            AND MIFloat_MovementId.DescId = zc_MIFloat_MovementId()
                                                                                                                                            AND MIFloat_MovementId.ValueData > 0
                                                                                                           WHERE MovementItem.MovementId = inMovementId
                                                                                                             AND MovementItem.DescId     = zc_MI_Master()
                                                                                                             AND MovementItem.isErased   = FALSE
                                                                                                          )

            AND EXISTS (SELECT MovementBoolean.MovementId FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.ValueData = TRUE AND MovementBoolean.DescId = zc_MovementBoolean_isPartner())
         THEN
             RAISE EXCEPTION '������.%� ��������� � ��������� "��� ��������" �� ����������� �������� <��������� � (�������)>.%���������� ����������.', CHR(13), CHR(13);
     END IF;
     END IF;
     IF vbMovementId_parent = inMovementId
     THEN
         RAISE EXCEPTION '������.%����������� ������ �������� <��������� � (������� �������� �����������)>.%�������� �������� � ������� ��������� <���-�� (�����)>.%���������� ����������.', CHR(13), CHR(13), CHR(13);
     END IF;
     IF vbMovementId_parent <> 0 AND inUserId <> zc_Enum_Process_Auto_PrimeCost()
     THEN
         -- �������� ����
         IF vbOperDate <> (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_parent)
         THEN RAISE EXCEPTION '������.%�������� <���� (�����)> ������ ��������������� �������� <%>%�� ��������� <��������� � (������� �������� �����������)>.%���������� ����������.', CHR(13), DATE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_parent)), CHR(13), CHR(13);
         END IF;
         -- �������� "�� ����"
         IF vbPartnerId_From <> COALESCE ((SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From WHERE MLO_From.MovementId = vbMovementId_parent AND MLO_From.DescId = zc_MovementLinkObject_From()), 0)
         THEN RAISE EXCEPTION '������.%�������� <�� ����> ������ ��������������� �������� <%>%�� ��������� <��������� � (������� �������� �����������)>.%���������� ����������.', CHR(13), lfGet_Object_ValueData ((SELECT MLO_From.ObjectId FROM MovementLinkObject AS MLO_From WHERE MLO_From.MovementId = vbMovementId_parent AND MLO_From.DescId = zc_MovementLinkObject_From())), CHR(13), CHR(13);
         END IF;
         -- �������� "����"
         IF vbUnitId_To <> COALESCE ((SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = vbMovementId_parent AND MLO_To.DescId = zc_MovementLinkObject_To()), 0)
         THEN RAISE EXCEPTION '������.%�������� <����> ������ ��������������� �������� <%>%�� ��������� <��������� � (������� �������� �����������)>.%���������� ����������.', CHR(13), lfGet_Object_ValueData ((SELECT MLO_To.ObjectId FROM MovementLinkObject AS MLO_To WHERE MLO_To.MovementId = vbMovementId_parent AND MLO_To.DescId = zc_MovementLinkObject_To())), CHR(13), CHR(13);
         END IF;
     END IF;


     -- !!!
     -- IF NOT EXISTS (SELECT MovementItemId FROM _tmpItem) THEN RETURN; END IF;


     -- ������� ����
     SELECT -- ������ �������� ����� �����-����� �� �����������
            CASE WHEN vbPriceWithVAT_PriceList OR vbVATPercent_PriceList = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                    THEN _tmpItem.tmpOperSumm_PriceList
                 WHEN vbVATPercent_PriceList > 0
                    -- ���� ���� ��� ���, ����� �������� ����� � ���
                    THEN CAST ( (1 + vbVATPercent_PriceList / 100) * _tmpItem.tmpOperSumm_PriceList AS NUMERIC (16, 2))
            END AS OperSumm_PriceList

          , -- ������ �������� ����� �� ����������� !!!��� ������!!!
            CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ������ �� ������
                    THEN _tmpItem.tmpOperSumm_Partner_original
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� �������� ����� � ���
                    THEN CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner_original AS NUMERIC (16, 2))
            END AS OperSumm_Partner

            -- ������ �������� ����� �� �����������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                              ELSE _tmpItem.tmpOperSumm_Partner
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent/100) * (CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * _tmpItem.tmpOperSumm_Partner AS NUMERIC (16, 2))
                         END
            END
            INTO vbOperSumm_PriceList, vbOperSumm_Partner, vbOperSumm_Partner_ChangePercent
     FROM (SELECT SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_PriceList ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.PriceListPrice AS NUMERIC (16, 2)) END) AS tmpOperSumm_PriceList
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner
                , SUM (CASE WHEN vbOperDatePartner < '01.07.2014' THEN _tmpItem.tmpOperSumm_Partner_original -- ��� �������� �� ������� ������ �������� (���� ���� �� �����������)
                            WHEN _tmpItem.CountForPrice <> 0 THEN CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original / _tmpItem.CountForPrice AS NUMERIC (16, 2))
                                                             ELSE CAST (_tmpItem.OperCount_Partner * _tmpItem.Price_original AS NUMERIC (16, 2))
                        END) AS tmpOperSumm_Partner_original
           FROM (SELECT _tmpItem.PriceListPrice
                      , _tmpItem.Price
                      , _tmpItem.Price_original
                      , _tmpItem.CountForPrice
                      , SUM (_tmpItem.tmpOperSumm_PriceList) AS tmpOperSumm_PriceList
                      , SUM (_tmpItem.OperCount_Partner) AS OperCount_Partner
                      , SUM (_tmpItem.tmpOperSumm_Partner) AS tmpOperSumm_Partner
                      , SUM (_tmpItem.tmpOperSumm_Partner_original) AS tmpOperSumm_Partner_original
                 FROM _tmpItem
                 GROUP BY _tmpItem.PriceListPrice
                        , _tmpItem.Price
                        , _tmpItem.Price_original
                        , _tmpItem.CountForPrice
                        , _tmpItem.GoodsId
                        , _tmpItem.GoodsKindId
                ) AS _tmpItem
          ) AS _tmpItem
     ;

     -- ������ �������� ���� �� ����������� (�� ���������)
     SELECT SUM (_tmpItem.OperSumm_PriceList), SUM (_tmpItem.OperSumm_Partner), SUM (_tmpItem.OperSumm_Partner_ChangePercent) INTO vbOperSumm_PriceList_byItem, vbOperSumm_Partner_byItem, vbOperSumm_Partner_ChangePercent_byItem FROM _tmpItem;

     -- ���� �� ����� ��� �������� ����� �����-����� �� �����������
     IF COALESCE (vbOperSumm_PriceList, 0) <> COALESCE (vbOperSumm_PriceList_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_PriceList = _tmpItem.OperSumm_PriceList - (vbOperSumm_PriceList_byItem - vbOperSumm_PriceList)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_PriceList IN (SELECT MAX (_tmpItem.OperSumm_PriceList) FROM _tmpItem)
                                          );
     END IF;
     -- ���� �� ����� ��� �������� ����� �� ����������� !!!��� ������!!!
     IF COALESCE (vbOperSumm_Partner, 0) <> COALESCE (vbOperSumm_Partner_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner = _tmpItem.OperSumm_Partner - (vbOperSumm_Partner_byItem - vbOperSumm_Partner)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner IN (SELECT MAX (_tmpItem.OperSumm_Partner) FROM _tmpItem)
                                          );
     END IF;
     -- ���� �� ����� ��� �������� ����� �� �����������
     IF COALESCE (vbOperSumm_Partner_ChangePercent, 0) <> COALESCE (vbOperSumm_Partner_ChangePercent_byItem, 0)
     THEN
         -- �� ������� ������������ ����� ������� ����� (������������ ����� ���������� �������� < 0, �� ��� ������ �� ������������)
         UPDATE _tmpItem SET OperSumm_Partner_ChangePercent = _tmpItem.OperSumm_Partner_ChangePercent - (vbOperSumm_Partner_ChangePercent_byItem - vbOperSumm_Partner_ChangePercent)
         WHERE _tmpItem.MovementItemId IN (SELECT MAX (_tmpItem.MovementItemId) FROM _tmpItem WHERE _tmpItem.OperSumm_Partner_ChangePercent IN (SELECT MAX (_tmpItem.OperSumm_Partner_ChangePercent) FROM _tmpItem)
                                          );
     END IF;


     -- ����������� ������ ������, ���� ���� ...
     UPDATE _tmpItem SET PartionGoodsId = CASE WHEN vbAccountDirectionId_To = zc_Enum_AccountDirection_20200() -- ������ + �� �������
                                                AND vbOperDate >= zc_DateStart_PartionGoods()
                                                AND (_tmpItem.isPartionCount OR _tmpItem.isPartionSumm)
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoods)

                                               WHEN vbIsPartionDate_Unit = TRUE
                                                AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN lpInsertFind_Object_PartionGoods (_tmpItem.PartionGoodsDate)
                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                   THEN 0

                                               WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
                                                 OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
                                                   THEN lpInsertFind_Object_PartionGoods (inUnitId_Partion:= NULL
                                                                                        , inGoodsId       := NULL
                                                                                        , inStorageId     := NULL
                                                                                        , inInvNumber     := NULL
                                                                                        , inOperDate      := NULL
                                                                                        , inPrice         := NULL
                                                                                         )
                                               ELSE lpInsertFind_Object_PartionGoods ('')
                                          END
     WHERE _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- �������� ����� + ������ �����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20200() -- ������������� + ������ ���
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20300() -- ������������� + ����
        OR _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
     ;


     -- ����������� ������ ���� ������� �� ����������� -> �����������
     INSERT INTO _tmpItemPartnerTo (MovementItemId, ContainerId_Partner, AccountId_Partner, ContainerId_ProfitLoss_10700, ContainerId_ProfitLoss_10800, OperSumm_Partner)
        SELECT MovementItemId
             , 0 AS ContainerId_Partner
             , 0 AS AccountId_Partner
             , 0 AS ContainerId_ProfitLoss_10700
             , 0 AS ContainerId_ProfitLoss_10800
             , OperSumm_PriceList AS OperSumm_Partner
        FROM _tmpItem
        WHERE vbPartnerId_To <> 0
    ;


     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
     -- !!! �� � ������ - �������� !!!
     -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


     -- 3.0.1. ������������ ����(�����������) ��� �������� �� ���� ���������� !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerTo SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- ��������
                                             , inAccountDirectionId     := zc_Enum_AccountDirection_30100() -- ����������
                                             , inInfoMoneyDestinationId := vbInfoMoneyDestinationId_To
                                             , inInfoMoneyId            := NULL
                                             , inUserId                 := inUserId
                                              ) AS AccountId
           WHERE EXISTS (SELECT _tmpItemPartnerTo.AccountId_Partner FROM _tmpItemPartnerTo)
          ) AS _tmpItem_byAccount
     ;

     -- 3.0.2. ������������ ContainerId ��� �������� �� ���� ���������� !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerTo SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM _tmpItem
          INNER JOIN (SELECT -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                             lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                   , inParentId          := NULL
                                                   , inObjectId          := (SELECT AccountId_Partner FROM _tmpItemPartnerTo GROUP BY AccountId_Partner)
                                                   , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                   , inBusinessId        := tmp.BusinessId_To
                                                   , inObjectCostDescId  := NULL
                                                   , inObjectCostId      := NULL
                                                   , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                   , inObjectId_1        := vbJuridicalId_To
                                                   , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                   , inObjectId_2        := vbContractId_To
                                                   , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                   , inObjectId_3        := vbInfoMoneyId_To
                                                   , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                   , inObjectId_4        := vbPaidKindId_To
                                                   , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                   , inObjectId_5        := 0 -- !!!��� ������!!!
                                                   , inDescId_6          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                   , inObjectId_6        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN vbPartnerId_To ELSE NULL END
                                                   , inDescId_7          := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                   , inObjectId_7        := CASE WHEN vbPaidKindId_To = zc_Enum_PaidKind_SecondForm() THEN vbBranchId_To ELSE NULL END
                                                   , inDescId_8          := NULL -- zc_ContainerLinkObject_Currency()
                                                   , inObjectId_8        := NULL -- vbCurrencyPartnerId
                                                    ) AS ContainerId
                           , tmp.BusinessId_To
                      FROM (SELECT _tmpItem.BusinessId_To
                            FROM _tmpItem
                            WHERE EXISTS (SELECT _tmpItemPartnerTo.AccountId_Partner FROM _tmpItemPartnerTo)
                            GROUP BY _tmpItem.BusinessId_To
                           ) AS tmp
                    ) AS _tmpItem_byInfoMoney ON _tmpItem_byInfoMoney.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
     ;


     -- 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET AccountId_Partner = _tmpItem_byAccount.AccountId
     FROM (SELECT CASE WHEN vbIsCorporate_From = TRUE
                            THEN _tmpItem_group.AccountId_Corporate
                       ELSE lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_30000() -- ��������
                                                       , inAccountDirectionId     := _tmpItem_group.AccountDirectionId
                                                       , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                       , inInfoMoneyId            := NULL
                                                       , inUserId                 := inUserId
                                                        )
                   END AS AccountId
                , _tmpItem_group.InfoMoneyDestinationId
           FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                  THEN zc_Enum_AccountDirection_30500() -- ���.���� (����������� ����)
                             WHEN vbIsCorporate_From = TRUE
                                  THEN zc_Enum_AccountDirection_30200() -- ���� ��������
                             WHEN vbInfoMoneyDestinationId_From IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                  , zc_Enum_InfoMoneyDestination_20700()  -- ������
                                                                  , zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                  , zc_Enum_InfoMoneyDestination_30100()  -- ���������
                                                                  , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                  THEN zc_Enum_AccountDirection_30100() -- ����������
                             WHEN _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                    , zc_Enum_InfoMoneyDestination_20700()  -- ������
                                                                    , zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                    , zc_Enum_InfoMoneyDestination_30100()  -- ���������
                                                                    , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                  THEN zc_Enum_AccountDirection_30100() -- ����������
                         -- ELSE zc_Enum_AccountDirection_30400() -- ������ ��������
                            ELSE zc_Enum_AccountDirection_30100() -- ����������
                        END AS AccountDirectionId

                      , CASE WHEN vbIsCorporate_From = TRUE
                                   THEN vbInfoMoneyDestinationId_From -- zc_Enum_InfoMoneyDestination_30100() -- ���������
                             WHEN vbInfoMoneyDestinationId_From <> 0
                                  THEN vbInfoMoneyDestinationId_From -- ��: ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.isTareReturning = TRUE -- !!!���������� ����!!!
                                  THEN zc_Enum_InfoMoneyDestination_30100() -- ���������
                             ELSE _tmpItem.InfoMoneyDestinationId -- ����� ����� �� ������
                        END AS InfoMoneyDestinationId_calc

                      , _tmpItem.InfoMoneyDestinationId
                      , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30201() -- ����
                             WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30202() -- ����
                             WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30203() -- �����
                             WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30204() -- �������
                             WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                  THEN zc_Enum_Account_30205() -- �������-���������
                        END AS AccountId_Corporate

                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!������ ������������, �.�. ���� AccountId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.InfoMoneyDestinationId, _tmpItem.isTareReturning
                ) AS _tmpItem_group
          ) AS _tmpItem_byAccount
      WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byAccount.InfoMoneyDestinationId;


     -- 3.2. ������������ ContainerId ��� �������� �� ���� ���������� ��� ���.���� (����������� ����)
     UPDATE _tmpItem SET ContainerId_Partner = _tmpItem_byInfoMoney.ContainerId
     FROM (SELECT CASE WHEN vbMemberId_From <> 0
                                 -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)���.���� (����������� ����) 2)NULL 3)NULL 4)������ ����������
                            THEN lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                       , inParentId          := NULL
                                                       , inObjectId          := _tmpItem_group.AccountId_Partner
                                                       , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                       , inBusinessId        := _tmpItem_group.BusinessId_To
                                                       , inObjectCostDescId  := NULL
                                                       , inObjectCostId      := NULL
                                                       , inDescId_1          := zc_ContainerLinkObject_Member()
                                                       , inObjectId_1        := vbMemberId_From
                                                       , inDescId_2          := zc_ContainerLinkObject_InfoMoney()
                                                       , inObjectId_2        := _tmpItem_group.InfoMoneyId_calc
                                                       , inDescId_3          := zc_ContainerLinkObject_Branch()
                                                       , inObjectId_3        := vbBranchId_To -- ���� ��������� ������ �� ������� ������
                                                       , inDescId_4          := zc_ContainerLinkObject_Car()
                                                       , inObjectId_4        := 0 -- ��� ���.���� (����������� ����) !!!������ ����� ��������� ��������� ������ �������� = 0!!!
                                                        )
                            -- 0.1.)���� 0.2.)������� �� ���� 0.3.)������ 1)����������� ���� 2)���� ���� ������ 3)�������� 4)������ ����������
                       ELSE lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                                  , inParentId          := NULL
                                                  , inObjectId          := _tmpItem_group.AccountId_Partner
                                                  , inJuridicalId_basis := vbJuridicalId_Basis_To
                                                  , inBusinessId        := _tmpItem_group.BusinessId_To
                                                  , inObjectCostDescId  := NULL
                                                  , inObjectCostId      := NULL
                                                  , inDescId_1          := zc_ContainerLinkObject_Juridical()
                                                  , inObjectId_1        := vbJuridicalId_From
                                                  , inDescId_2          := zc_ContainerLinkObject_Contract()
                                                  , inObjectId_2        := vbContractId
                                                  , inDescId_3          := zc_ContainerLinkObject_InfoMoney()
                                                  , inObjectId_3        := _tmpItem_group.InfoMoneyId_calc
                                                  , inDescId_4          := zc_ContainerLinkObject_PaidKind()
                                                  , inObjectId_4        := vbPaidKindId
                                                  , inDescId_5          := zc_ContainerLinkObject_PartionMovement()
                                                  , inObjectId_5        := _tmpItem_group.PartionMovementId
                                                  , inDescId_6          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Partner() ELSE NULL END
                                                  , inObjectId_6        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbPartnerId_From ELSE NULL END
                                                  , inDescId_7          := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN zc_ContainerLinkObject_Branch() ELSE NULL END
                                                  , inObjectId_7        := CASE WHEN vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbIsCorporate_From = FALSE THEN vbBranchId_To ELSE NULL END
                                                  , inDescId_8          := NULL -- ...zc_ContainerLinkObject_Currency()
                                                  , inObjectId_8        := NULL -- ...vbCurrencyPartnerId
                                                   )
                  END AS ContainerId
                , _tmpItem_group.InfoMoneyId
                , _tmpItem_group.PartionMovementId
           FROM (SELECT _tmpItem.AccountId_Partner
                      , _tmpItem.InfoMoneyId
                      , _tmpItem.BusinessId_To
                      , _tmpItem.PartionMovementId
                      , CASE WHEN vbInfoMoneyId_From <> 0
                                  THEN vbInfoMoneyId_From -- ��: ������ �� �������� -- ������ �� �������� -- � ������ ����: � ������ ������� - �� ��������, �� ������ - �� ������ !!!(���� ���� ��������)!!!, ����� ����� ���������� ��� ������� ������
                             WHEN _tmpItem.InfoMoneyId = zc_Enum_InfoMoney_20901 () -- 20901; "����"
                                  THEN zc_Enum_InfoMoney_30101 () -- 30101; "������� ���������"
                             ELSE _tmpItem.InfoMoneyId -- ����� ����� �� ������
                        END AS InfoMoneyId_calc
                 FROM _tmpItem
                 -- WHERE _tmpItem.OperSumm_Partner_ChangePercent <> 0 !!!������ ������������, �.�. ���� ContainerId � ��������� ��� ������!!!
                 GROUP BY _tmpItem.AccountId_Partner
                        , _tmpItem.InfoMoneyId
                        , _tmpItem.BusinessId_To
                        , _tmpItem.PartionMovementId
                ) AS _tmpItem_group
          ) AS _tmpItem_byInfoMoney
     WHERE _tmpItem.InfoMoneyId = _tmpItem_byInfoMoney.InfoMoneyId
       AND _tmpItem.PartionMovementId = _tmpItem_byInfoMoney.PartionMovementId
     ;

     -- 3.3. !!!����� ����� - ���������� ����� vbContainerId_Analyzer ��� ����!!!, ���� �� �� ���� - ����� ������
     vbContainerId_Analyzer:= (SELECT ContainerId_Partner FROM _tmpItem GROUP BY ContainerId_Partner);
     -- ����������
     vbContainerId_Analyzer_PartnerTo:= (SELECT ContainerId_Partner FROM _tmpItemPartnerTo GROUP BY ContainerId_Partner);
     -- ����������
     vbWhereObjectId_Analyzer:= CASE WHEN vbUnitId_To <> 0 THEN vbUnitId_To WHEN vbMemberId_To <> 0 THEN vbMemberId_To WHEN vbPartnerId_To <> 0 THEN vbPartnerId_To END;
     -- ����������
     vbObjectExtId_Analyzer:= CASE WHEN vbPartnerId_From <> 0 THEN vbPartnerId_From WHEN vbMemberId_From <> 0 THEN vbMemberId_From END;
     -- ����������
     vbAccountId_GoodsTransit:= CASE WHEN vbOperDate <> vbOperDatePartner AND vbMemberId_From = 0 AND vbMemberId_To = 0 THEN zc_Enum_Account_110111() ELSE 0 END;


     -- 1.1.1. ������������ ContainerId_GoodsPartner ��� !!!�� ������������!!! �������� �� ��������������� ����� - ����� ���������� ��� ���.����
     UPDATE _tmpItem SET ContainerId_GoodsPartner = -- 0)����� 1)����������
                                                    -- 0)����� 1)���.����
                                                    lpInsertFind_Container (inContainerDescId   := zc_Container_Count()
                                                                          , inParentId          := NULL
                                                                          , inObjectId          := _tmpItem.GoodsId
                                                                          , inJuridicalId_basis := NULL
                                                                          , inBusinessId        := NULL
                                                                          , inObjectCostDescId  := NULL
                                                                          , inObjectCostId      := NULL
                                                                          , inDescId_1          := CASE WHEN vbMemberId_From <> 0 THEN zc_ContainerLinkObject_Member() ELSE zc_ContainerLinkObject_Partner() END
                                                                          , inObjectId_1        := CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbPartnerId_From END
                                                                          , inDescId_2          := zc_ContainerLinkObject_Branch()
                                                                          , inObjectId_2        := vbBranchId_To
                                                                          , inDescId_3          := zc_ContainerLinkObject_PaidKind()
                                                                          , inObjectId_3        := vbPaidKindId
                                                                           )
     WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
       AND vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
    ;

     -- 1.1.2. ����������� !!!�� ������������!!! �������� ��� ��������������� ����� - ����� ���������� ��� ���.����
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, MovementItemId
            , ContainerId_GoodsPartner
            , 0                                       AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_TareReturning()      AS AnalyzerId               -- ���� ���������
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer        -- �����
            , CASE WHEN vbMemberId_From <> 0 THEN vbMemberId_From ELSE vbPartnerId_From END AS WhereObjectId_Analyzer -- ���������� ��� ���.����
            , 0                                       AS ContainerId_Analyzer     -- !!!���!!!
            , 0                                       AS ObjectIntId_Analyzer     -- !!!���!!!
            , vbWhereObjectId_Analyzer                AS ObjectExtId_Analyzer     -- ������������� ���...
            , ContainerId_GoodsPartner                AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0                                       AS ParentId
            , -1 * OperCount                          AS Amount
            , vbOperDatePartner                       AS OperDate                 -- �.�. �� "���� ����������"
            , FALSE                                   AS isActive
       FROM _tmpItem
       WHERE _tmpItem.isTareReturning = TRUE AND _tmpItem.OperCount <> 0
         AND vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
      ;


     -- 1.2.0. ������������ ContainerId_Goods ��� ��������������� ����� - !!!���� ������� �� ����������� -> �����������!!!
     UPDATE _tmpItemPartnerTo SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDatePartner
                                                                                         , inUnitId                 := NULL -- !!!������������� ���!!!
                                                                                         , inCarId                  := NULL
                                                                                         , inMemberId               := NULL
                                                                                         , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                         , inGoodsId                := _tmpItem.GoodsId
                                                                                         , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                         , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                         , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                         , inAssetId                := _tmpItem.AssetId
                                                                                         , inBranchId               := NULL
                                                                                         , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                          )
     FROM _tmpItem
     WHERE _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
    ;

     -- 1.2.1.1. ������������ ContainerId_Goods ��� ��������������� ����� + ...
     UPDATE _tmpItem SET ContainerId_Goods = lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                , ContainerId_GoodsTransit = CASE WHEN vbAccountId_GoodsTransit <> 0
                                        THEN lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_To
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := vbAccountId_GoodsTransit -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                        ELSE 0 END
                       , ContainerId_Goods_Alternative = CASE WHEN vbUnitId_HistoryCost IN (0, vbUnitId_To) -- ���� 0 ��� ��� � ����
                                                                   THEN 0
                                        ELSE lpInsertUpdate_ContainerCount_Goods (inOperDate               := vbOperDate
                                                                                , inUnitId                 := vbUnitId_HistoryCost -- !!!�� �������������� �������������!!!
                                                                                , inCarId                  := NULL
                                                                                , inMemberId               := vbMemberId_To
                                                                                , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                , inGoodsId                := _tmpItem.GoodsId
                                                                                , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                , inIsPartionCount         := _tmpItem.isPartionCount
                                                                                , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                , inAssetId                := _tmpItem.AssetId
                                                                                , inBranchId               := vbBranchId_To -- ��� ��������� ����� ��� �������
                                                                                , inAccountId              := NULL -- ��� ��������� ����� ��� "����� � ����"
                                                                                 )
                                                        END
                         -- ������������ ���� !!!���� "�����������" ������� �������� �������!!!, �.�. ������� �� ������� �� ����� ������ (���� ����� ���������)
                       , AccountId_SummIn_60000 = CASE WHEN vbUnitId_HistoryCost <> vbUnitId_To -- ���� ������� �� ���������� ��� � ����
                                                         OR vbBranchId_To = zc_Branch_Basis()   -- !!!���!!! ��� "�������" ������
                                                            THEN 0
                                                       ELSE -- ���� ������� ���������� ��� � ����
                                                            lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_20000() -- ������
                                                                                       , inAccountDirectionId     := vbAccountDirectionId_To
                                                                                       , inInfoMoneyDestinationId := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                                          ELSE _tmpItem.InfoMoneyDestinationId
                                                                                                                     END
                                                                                       , inInfoMoneyId            := NULL
                                                                                       , inUserId                 := inUserId
                                                                                        )
                                                    END
                        -- ������������ ���� !!!���� "�����������" ������� �������� �������!!!, �.�. ������� �� ������� �� ����� ������ (���� ����� ���������)
                      , AccountId_SummOut_60000 = CASE WHEN vbUnitId_HistoryCost <> vbUnitId_To -- ���� ������� �� ���������� ��� � ����
                                                         OR vbBranchId_To = zc_Branch_Basis()   -- !!!���!!! ��� "�������" ������
                                                            THEN 0
                                                       ELSE -- ���� ������� ���������� ��� � ����
                                                            lpInsertFind_Object_Account (inAccountGroupId         := zc_Enum_AccountGroup_60000() -- ������� ������� ��������
                                                                                       , inAccountDirectionId     := zc_Enum_AccountDirection_60200() -- ������� ������� �������� + �� ��������
                                                                                       , inInfoMoneyDestinationId := CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                                                                                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                                                                                                          ELSE _tmpItem.InfoMoneyDestinationId
                                                                                                                     END
                                                                                       , inInfoMoneyId            := NULL
                                                                                       , inUserId                 := inUserId
                                                                                        )
                                                    END
     WHERE vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
    ;

     -- 1.2.1.2. ������������ ContainerId ��� �������� !!!���� "�����������" ������� �������� �������!!!, �.�. ������� �� ������� �� ����� ������ (���� ����� ���������)
     UPDATE _tmpItem SET ContainerId_SummIn_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                      , inUnitId                 := vbUnitId_To
                                                                                      , inCarId                  := NULL
                                                                                      , inMemberId               := vbMemberId_To
                                                                                      , inBranchId               := vbBranchId_To
                                                                                      , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                      , inBusinessId             := _tmpItem.BusinessId_To
                                                                                      , inAccountId              := _tmpItem.AccountId_SummIn_60000
                                                                                      , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                      , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                      , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                                                      , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                      , inGoodsId                := _tmpItem.GoodsId
                                                                                      , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                      , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                      , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                      , inAssetId                := _tmpItem.AssetId
                                                                                       )
                      , ContainerId_SummOut_60000 = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                      , inUnitId                 := vbUnitId_To
                                                                                      , inCarId                  := NULL
                                                                                      , inMemberId               := vbMemberId_To
                                                                                      , inBranchId               := vbBranchId_To
                                                                                      , inJuridicalId_basis      := vbJuridicalId_Basis_To
                                                                                      , inBusinessId             := _tmpItem.BusinessId_To
                                                                                      , inAccountId              := _tmpItem.AccountId_SummOut_60000
                                                                                      , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                      , inInfoMoneyId            := _tmpItem.InfoMoneyId
                                                                                      , inInfoMoneyId_Detail     := zc_Enum_InfoMoney_80401() -- ������� �������� �������
                                                                                      , inContainerId_Goods      := _tmpItem.ContainerId_Goods
                                                                                      , inGoodsId                := _tmpItem.GoodsId
                                                                                      , inGoodsKindId            := _tmpItem.GoodsKindId
                                                                                      , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                      , inPartionGoodsId         := _tmpItem.PartionGoodsId
                                                                                      , inAssetId                := _tmpItem.AssetId
                                                                                       )
     WHERE _tmpItem.AccountId_SummIn_60000 <> 0
        OR _tmpItem.AccountId_SummOut_60000 <> 0
    ;

     -- 1.2.2. ����������� �������� ��� ��������������� ����� (�������)
        WITH tmpMIContainer AS
            (SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_ReturnInCount_10800() END AS AnalyzerId -- ���-��, �������, �� ����������
                  , 0 AS ParentId
                  , OperCount_Partner AS Amount
                  , TRUE              AS isActive
             FROM _tmpItem
             -- ����� �.�. ���� ���� �������� ������ ���� (!!!��� �������!!!)
             -- WHERE OperCount_Partner <> 0
             WHERE vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
            UNION ALL
             SELECT MovementItemId
                  , ContainerId_Goods
                  , ContainerId_GoodsTransit
                  , GoodsId, GoodsKindId
                  , CASE WHEN isTareReturning = TRUE THEN 0 ELSE zc_Enum_AnalyzerId_ReturnInCount_40200() END AS AnalyzerId -- ���-��, �������, ������� � ����
                  , 0 AS ParentId
                  , (OperCount - OperCount_Partner) AS Amount
                  , TRUE                            AS isActive
             FROM _tmpItem
             WHERE (OperCount - OperCount_Partner) <> 0 -- !!!������� �� �����!!!
               AND vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
            )
     -- ��������: AnalyzerId <> 0 ������, ContainerId_Analyzer <> 0 ����� �������� � ������ ����������, ����� "�����������" (�.�. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Goods
            , 0                                       AS AccountId              -- ��� �����
            , tmpMIContainer.AnalyzerId               AS AnalyzerId             -- !!!��������� ���� ������!!! (���� ���� ����� �������, ��� ����� ��� ������)
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- ���� ��� �������, ����� � ���������� �� vbOperDate �� �������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer   -- ���� ��� �������, ����� � ���������� �� vbOperDate ������� 2 ���� � + � -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer   -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer   -- ���������� / ���.����
            , tmpMIContainer.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- �.�. �� "���� �����"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_GoodsTransit
            , vbAccountId_GoodsTransit                AS AccountId                -- ���� ���� (�.�. � ������� ������������ "�������")
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ��� "�����������")
            , tmpMIContainer.GoodsId                  AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- �.�. � ���������� ������� "��������" �� vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- �.�. � ���������� ������� "��������" �� vbOperDatePartner + �� vbOperDate ������� 2 ���� � + � -
            , tmpMIContainer.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , tmpMIContainer.ContainerId_GoodsTransit AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "�����������" � �������� ������
            , tmpOperDate.OperDate -- !!!��� �������� �� ������ ����!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT tmpMIContainer.isActive ELSE tmpMIContainer.isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN tmpMIContainer ON vbAccountId_GoodsTransit <> 0
     UNION ALL
       -- ��� ������� �������� - !!!���� ������� �� ����������� -> �����������!!!
       SELECT 0, zc_MIContainer_Count() AS DescId, vbMovementDescId, inMovementId, _tmpItemPartnerTo.MovementItemId
            , _tmpItemPartnerTo.ContainerId_Goods
            , 0                                        AS AccountId                -- ��� �����
            , zc_Enum_AnalyzerId_ReturnInCount_10800() AS AnalyzerId               -- !!!��������� ���� ������!!! ���-��, �������, �� ����������
            , _tmpItem.GoodsId                         AS ObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = FALSE THEN vbPartnerId_To ELSE vbPartnerId_From END AS WhereObjectId_Analyzer
            , CASE WHEN tmpIsActive.isActive = FALSE THEN vbContainerId_Analyzer_PartnerTo ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                     AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItemPartnerTo.ContainerId_Goods      AS ContainerIntId_Analyzer  -- ��������� "�����" - ��� �� �����
            , 0 AS ParentId
            , _tmpItem.OperCount_Partner * CASE WHEN tmpIsActive.isActive = TRUE THEN 1 ELSE -1 END AS Amount
            , vbOperDatePartner -- �.�. �� "���� ����������"
            , tmpIsActive.isActive
       FROM (SELECT TRUE AS isActive UNION SELECT FALSE AS isActive) AS tmpIsActive
            INNER JOIN _tmpItem ON _tmpItem.OperCount_Partner <> 0  -- !!!������� �� �����!!!
            INNER JOIN _tmpItemPartnerTo ON _tmpItemPartnerTo.MovementItemId = _tmpItem.MovementItemId
      ;


     -- 1.2.3. ������ !!!���������� ���� �� ����������!!!, ������� �������
     DELETE FROM _tmpItem WHERE _tmpItem.isTareReturning = TRUE;


     -- 1.2.2.
     OPEN curContainer FOR SELECT ContainerId_Goods, Container_Summ.Id AS ContainerId_Summ_Alternative, Container_Summ.DescId AS ContainerDescId, Container_Summ.ObjectId AS ContainerObjectId
                           FROM _tmpItem
                                INNER JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods_Alternative
                                                                      AND Container_Summ.DescId = zc_Container_Summ()
                           WHERE ContainerId_Goods_Alternative <> 0
                             AND InfoMoneyDestinationId        <> zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                             AND vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
     ;
     -- ������ ����� �� �������
     LOOP
          -- ������
          FETCH curContainer INTO vbContainerId_Goods, vbContainerId_Summ_Alternative, vbContainerDescId, vbContainerObjectId;
          -- ���� ������ ���, �� �� �������
          IF NOT FOUND THEN
             EXIT;
          END IF;
          --
          WITH tmpJuridical_basis AS (SELECT ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId = zc_ContainerLinkObject_JuridicalBasis())
             , tmpBusiness AS (SELECT ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId = zc_ContainerLinkObject_Business())
             , tmpAll AS (SELECT DescId, ObjectId FROM ContainerLinkObject WHERE ContainerId = vbContainerId_Summ_Alternative AND DescId NOT IN (zc_ContainerLinkObject_JuridicalBasis(), zc_ContainerLinkObject_Business()))
             , tmpDesc1 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll)
             , tmpObject1 AS (SELECT ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc1))
             , tmpDesc2 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc1))
             , tmpObject2 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc2))
             , tmpDesc3 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc2))
             , tmpObject3 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc3))
             , tmpDesc4 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc3))
             , tmpObject4 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc4))
             , tmpDesc5 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc4))
             , tmpObject5 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc5))
             , tmpDesc6 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc5))
             , tmpObject6 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc6))
             , tmpDesc7 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc6))
             , tmpObject7 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc7))
             , tmpDesc8 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc7))
             , tmpObject8 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc8))
             , tmpDesc9 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc8))
             , tmpObject9 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc9))
             , tmpDesc10 AS (SELECT MIN (tmpAll.DescId) AS DescId FROM tmpAll WHERE tmpAll.DescId > (SELECT DescId FROM tmpDesc9))
             , tmpObject10 AS (SELECT MIN (ObjectId) AS ObjectId FROM tmpAll WHERE DescId = (SELECT DescId FROM tmpDesc10))
          --
          INSERT INTO _tmpList_Alternative (ContainerId_Goods, ContainerId_Summ_Alternative, ContainerId_Summ)
             SELECT vbContainerId_Goods, vbContainerId_Summ_Alternative
                         , lpInsertFind_Container (inContainerDescId   := vbContainerDescId
                                                 , inParentId          := vbContainerId_Goods
                                                 , inObjectId          := vbContainerObjectId
                                                 , inJuridicalId_basis := (SELECT ObjectId FROM tmpJuridical_basis)
                                                 , inBusinessId        := (SELECT ObjectId FROM tmpBusiness)
                                                 , inObjectCostDescId  := NULL
                                                 , inObjectCostId      := NULL
                                                 , inDescId_1   := (SELECT DescId FROM tmpDesc1)
                                                 , inObjectId_1 := CASE WHEN (SELECT DescId FROM tmpDesc1) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject1) END
                                                 , inDescId_2   := (SELECT DescId FROM tmpDesc2)
                                                 , inObjectId_2 := CASE WHEN (SELECT DescId FROM tmpDesc2) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject2) END
                                                 , inDescId_3   := (SELECT DescId FROM tmpDesc3)
                                                 , inObjectId_3 := CASE WHEN (SELECT DescId FROM tmpDesc3) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject3) END
                                                 , inDescId_4   := (SELECT DescId FROM tmpDesc4)
                                                 , inObjectId_4 := CASE WHEN (SELECT DescId FROM tmpDesc4) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject4) END
                                                 , inDescId_5   := (SELECT DescId FROM tmpDesc5)
                                                 , inObjectId_5 := CASE WHEN (SELECT DescId FROM tmpDesc5) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject5) END
                                                 , inDescId_6   := (SELECT DescId FROM tmpDesc6)
                                                 , inObjectId_6 := CASE WHEN (SELECT DescId FROM tmpDesc6) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject6) END
                                                 , inDescId_7   := (SELECT DescId FROM tmpDesc7)
                                                 , inObjectId_7 := CASE WHEN (SELECT DescId FROM tmpDesc7) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject7) END
                                                 , inDescId_8   := (SELECT DescId FROM tmpDesc8)
                                                 , inObjectId_8 := CASE WHEN (SELECT DescId FROM tmpDesc8) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject8) END
                                                 , inDescId_9   := (SELECT DescId FROM tmpDesc9)
                                                 , inObjectId_9 := CASE WHEN (SELECT DescId FROM tmpDesc9) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject9) END
                                                 , inDescId_10  := (SELECT DescId FROM tmpDesc10)
                                                 , inObjectId_10:= CASE WHEN (SELECT DescId FROM tmpDesc10) = zc_ContainerLinkObject_Unit() THEN vbUnitId_To ELSE (SELECT ObjectId FROM tmpObject10) END
                                                  );
     END LOOP; -- ����� ����� �� �������
     CLOSE curContainer; -- ������� ������


     -- 1.3.1.1. ����� ����������: ��������� ������� - �������� �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     INSERT INTO _tmpItemSumm (MovementItemId, ContainerId_ProfitLoss_40208, ContainerId_ProfitLoss_10800, ContainerId, AccountId, ContainerId_Transit, OperSumm, OperSumm_Partner)
        SELECT
              _tmpItem.MovementItemId
            , 0 AS ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�1 - �/�2)
            , 0 AS ContainerId_ProfitLoss_10800 -- ���� - ������� (���� - ������������� ��������� : �/�2)
            , COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (_tmpList_Alternative.ContainerId_Summ, COALESCE (Container_Summ.Id, 0))) AS ContainerId
            , COALESCE (lfContainerSumm_20901.AccountId, COALESCE (Container_Summ_Alternative.ObjectId, COALESCE (Container_Summ.ObjectId, 0))) AS AccountId
            , 0 AS ContainerId_Transit -- ���� �������, ��������� �����
              -- �/�1 - ��� ����������: ������ �� �������
            , SUM (CAST (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) AS OperSumm
              -- �/�2 - ��� ����������: �����������
            , SUM (CAST (_tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) AS NUMERIC (16,4))) AS OperSumm_Partner
        FROM _tmpItem
             -- ��� ������� ��� ����
             LEFT JOIN lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901()) AS lfContainerSumm_20901
                                                                                  ON lfContainerSumm_20901.GoodsId           = _tmpItem.GoodsId
                                                                                 AND lfContainerSumm_20901.JuridicalId_basis = vbJuridicalId_Basis_To
                                                                                 -- AND lfContainerSumm_20901.BusinessId        = _tmpItem.BusinessId_To -- !!!���� �� ������� � ���������� �� �������!!!
                                                                                 AND _tmpItem.InfoMoneyDestinationId         = zc_Enum_InfoMoneyDestination_20500() -- 20500; "��������� ����"
                                                                                 AND _tmpItem.isTareReturning                = FALSE
             -- ��� ������� ��� ���������
             LEFT JOIN _tmpList_Alternative ON _tmpList_Alternative.ContainerId_Goods = _tmpItem.ContainerId_Goods
             LEFT JOIN Container AS Container_Summ_Alternative ON Container_Summ_Alternative.Id = _tmpList_Alternative.ContainerId_Summ_Alternative
             LEFT JOIN Container AS Container_Summ ON Container_Summ.ParentId = _tmpItem.ContainerId_Goods
                                                  AND Container_Summ.DescId = zc_Container_Summ()
                                                  AND Container_Summ_Alternative.Id IS NULL
             /*JOIN ContainerObjectCost AS ContainerObjectCost_Basis
                                      ON ContainerObjectCost_Basis.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, Container_Summ.Id)
                                     AND ContainerObjectCost_Basis.ObjectCostDescId = zc_ObjectCost_Basis()*/
             LEFT JOIN HistoryCost ON HistoryCost.ContainerId = COALESCE (lfContainerSumm_20901.ContainerId, COALESCE (Container_Summ_Alternative.Id, Container_Summ.Id)) -- HistoryCost.ObjectCostId = ContainerObjectCost_Basis.ObjectCostId
                                  AND vbOperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
        WHERE zc_isHistoryCost() = TRUE -- !!!���� ����� ��������!!!
          AND vbIsHistoryCost= TRUE -- !!! ������ ��� ������ ����� �������� �/� (������� ��� ��������� ����������)!!!
          AND (_tmpItem.OperCount * COALESCE (HistoryCost.Price, 0) <> 0                -- ����� ���� !!!�� �����!!!
            OR _tmpItem.OperCount_Partner * COALESCE (HistoryCost.Price, 0) <> 0)       -- ����� ���� !!!�� �����!!!
          AND vbPartnerId_To = 0 -- !!!���� �� ������� �� ����������� -> �����������!!!
          AND AccountId_SummIn_60000  = 0 -- !!!���� �� "�����������" ������� �������� �������!!!
          AND AccountId_SummOut_60000 = 0 -- !!!���� �� "�����������" ������� �������� �������!!!
          AND (vbUnitId_HistoryCost <> vbUnitId_To  -- !!!�!!! ���� ������� �� ���������� ��� � ����
            OR vbBranchId_To <> zc_Branch_Basis()   -- !!!���!!! ��� �� "�������" ������
              )
        GROUP BY _tmpItem.MovementItemId
               , Container_Summ.Id
               , Container_Summ.ObjectId
               , _tmpList_Alternative.ContainerId_Summ
               , Container_Summ_Alternative.ObjectId
               , lfContainerSumm_20901.ContainerId
               , lfContainerSumm_20901.AccountId;

     -- 1.3.1.2. ������������ ContainerId - �������
     UPDATE _tmpItemSumm SET ContainerId_Transit = lpInsertUpdate_ContainerSumm_Goods (inOperDate               := vbOperDate
                                                                                     , inUnitId                 := CLO_Unit.ObjectId
                                                                                     , inCarId                  := CLO_Car.ObjectId
                                                                                     , inMemberId               := CLO_Member.ObjectId
                                                                                     , inBranchId               := vbBranchId_To -- ��� ��������� ����� ��� �������
                                                                                     , inJuridicalId_basis      := CLO_JuridicalBasis.ObjectId
                                                                                     , inBusinessId             := CLO_Business.ObjectId
                                                                                     , inAccountId              := vbAccountId_GoodsTransit
                                                                                     , inInfoMoneyDestinationId := _tmpItem.InfoMoneyDestinationId
                                                                                     , inInfoMoneyId            := CLO_InfoMoney.ObjectId
                                                                                     , inInfoMoneyId_Detail     := CLO_InfoMoneyDetail.ObjectId
                                                                                     , inContainerId_Goods      := _tmpItem.ContainerId_GoodsTransit
                                                                                     , inGoodsId                := CLO_Goods.ObjectId
                                                                                     , inGoodsKindId            := CLO_GoodsKind.ObjectId
                                                                                     , inIsPartionSumm          := _tmpItem.isPartionSumm
                                                                                     , inPartionGoodsId         := CLO_PartionGoods.ObjectId
                                                                                     , inAssetId                := CLO_Asset.ObjectId
                                                                                      )
     FROM (SELECT _tmpItemSumm.MovementItemId, _tmpItemSumm.ContainerId FROM _tmpItemSumm) AS _tmpItemSumm_find
          INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm_find.MovementItemId
          LEFT JOIN ContainerLinkObject AS CLO_JuridicalBasis ON CLO_JuridicalBasis.ContainerId = _tmpItemSumm_find.ContainerId
                                                             AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
          LEFT JOIN ContainerLinkObject AS CLO_Business ON CLO_Business.ContainerId = _tmpItemSumm_find.ContainerId
                                                       AND CLO_Business.DescId = zc_ContainerLinkObject_Business()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoney ON CLO_InfoMoney.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
          LEFT JOIN ContainerLinkObject AS CLO_InfoMoneyDetail ON CLO_InfoMoneyDetail.ContainerId = _tmpItemSumm_find.ContainerId
                                                              AND CLO_InfoMoneyDetail.DescId = zc_ContainerLinkObject_InfoMoneyDetail()
          LEFT JOIN ContainerLinkObject AS CLO_Goods ON CLO_Goods.ContainerId = _tmpItemSumm_find.ContainerId
                                                    AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()
          LEFT JOIN ContainerLinkObject AS CLO_GoodsKind ON CLO_GoodsKind.ContainerId = _tmpItemSumm_find.ContainerId
                                                        AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
          LEFT JOIN ContainerLinkObject AS CLO_PartionGoods ON CLO_PartionGoods.ContainerId = _tmpItemSumm_find.ContainerId
                                                           AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
          LEFT JOIN ContainerLinkObject AS CLO_Asset ON CLO_Asset.ContainerId = _tmpItemSumm_find.ContainerId
                                                    AND CLO_Asset.DescId = zc_ContainerLinkObject_AssetTo()
          LEFT JOIN ContainerLinkObject AS CLO_Unit ON CLO_Unit.ContainerId = _tmpItemSumm_find.ContainerId
                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
          LEFT JOIN ContainerLinkObject AS CLO_Car ON CLO_Car.ContainerId = _tmpItemSumm_find.ContainerId
                                                  AND CLO_Car.DescId = zc_ContainerLinkObject_Car()
          LEFT JOIN ContainerLinkObject AS CLO_Member ON CLO_Member.ContainerId = _tmpItemSumm_find.ContainerId
                                                     AND CLO_Member.DescId = zc_ContainerLinkObject_Member()
     WHERE _tmpItemSumm.MovementItemId = _tmpItemSumm_find.MovementItemId
       AND _tmpItemSumm.ContainerId    = _tmpItemSumm_find.ContainerId
       AND vbAccountId_GoodsTransit <> 0
    ;

     -- 1.3.2. ����������� �������� ��� ��������� ����� (c/c �������) + !!!���� MovementItemId!!!
        WITH tmpMIContainer AS
            (SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_ReturnInSumm_10800() AS AnalyzerId -- ����� �/�, �������, �� ����������
                  , 0 AS ParentId
                  , _tmpItemSumm.OperSumm_Partner AS Amount
                  , TRUE                          AS isActive
             FROM _tmpItemSumm
             WHERE _tmpItemSumm.OperSumm_Partner <> 0 -- !!!������� �� �����!!!
            UNION ALL
             SELECT _tmpItemSumm.MovementItemId
                  , _tmpItemSumm.AccountId
                  , _tmpItemSumm.ContainerId
                  , _tmpItemSumm.ContainerId_Transit
                  , zc_Enum_AnalyzerId_ReturnInSumm_40200() AS AnalyzerId -- ����� �/�, �������, ������� � ����
                  , 0 AS ParentId
                  , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS Amount
                  , TRUE                                                    AS isActive
             FROM _tmpItemSumm
             WHERE (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner <> 0) -- !!!������� �� �����!!!
            )
     -- ��������: AnalyzerId <> 0 ������, ContainerId_Analyzer <> 0 ����� �������� � ������ ����������, ����� "�����������" (�.�. AccountId <> 0, AnalyzerId <> 0, ContainerId_Analyzer = 0)
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId
            , tmpMIContainer.AccountId                AS AccountId                -- ���� ���� ������
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ���� ����� �������, ��� ����� ��� ������)
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- ���� ��� �������, ����� � ���������� �� vbOperDate �� �������
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- ���� ��� �������, ����� � ���������� �� vbOperDate ������� 2 ���� � + � -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem.ContainerId_Goods              AS ContainerIntId_Analyzer  -- ��������� "�����"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount
            , vbOperDate -- �.�. �� "���� �����"
            , tmpMIContainer.isActive
       FROM tmpMIContainer
            INNER JOIN _tmpItem ON _tmpItem.MovementItemId = tmpMIContainer.MovementItemId

     UNION ALL
       -- ��� ��� �������� ��� ����� �������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, tmpMIContainer.MovementItemId
            , tmpMIContainer.ContainerId_Transit
            , vbAccountId_GoodsTransit                AS AccountId                -- ���� ���� (�.�. � ������� ������������ "�������") + �� ����� �� ��� � �������� ���-��
            , tmpMIContainer.AnalyzerId               AS AnalyzerId               -- !!!��������� ���� ������!!! (���� ��� "�����������")
            , _tmpItem.GoodsId                        AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer
            -- , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN 0 ELSE vbContainerId_Analyzer END AS ContainerId_Analyzer -- �.�. � ���������� ������� "��������" �� vbOperDatePartner
            , vbContainerId_Analyzer                  AS ContainerId_Analyzer     -- �.�. � ���������� ������� "��������" �� vbOperDatePartner + �� vbOperDate ������� 2 ���� � + � -
            , _tmpItem.GoodsKindId                    AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem.ContainerId_GoodsTransit       AS ContainerIntId_Analyzer  -- ��������� "�����"
            , tmpMIContainer.ParentId
            , tmpMIContainer.Amount * CASE WHEN tmpOperDate.OperDate = vbOperDate THEN -1 ELSE 1 END AS Amount -- "�����������" � �������� ������
            , tmpOperDate.OperDate -- !!!��� �������� �� ������ ����!!!
            , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN NOT isActive ELSE isActive END AS isActive
       FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate
            INNER JOIN _tmpItem ON vbAccountId_GoodsTransit <> 0
            INNER JOIN tmpMIContainer ON tmpMIContainer.MovementItemId = _tmpItem.MovementItemId

     UNION ALL
       -- ��� ��������� �������� - !!!������� �������� �������!!! �� ����� ������ zc_PriceList_Basis
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem.MovementItemId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.ContainerId_SummIn_60000 ELSE _tmpItem.ContainerId_SummOut_60000 END AS ContainerId
            , CASE WHEN tmp.mySign > 0 THEN _tmpItem.AccountId_SummIn_60000   ELSE _tmpItem.AccountId_SummOut_60000   END AS AccountId  -- ���� ���� ������
            , zc_Enum_AnalyzerId_ReturnInSumm_10800()  AS AnalyzerId               -- ����� �/�, �������, �� ���������� -- !!!��������� ���� ������!!! (��� ����� ��� ������)
            , _tmpItem.GoodsId                         AS ObjectId_Analyzer
            , vbWhereObjectId_Analyzer                 AS WhereObjectId_Analyzer
            , vbContainerId_Analyzer                   AS ContainerId_Analyzer
            , _tmpItem.GoodsKindId                     AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                   AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem.ContainerId_Goods               AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                        AS ParentId
            , tmp.mySign * _tmpItem.OperSumm_PriceList AS Amount
            , vbOperDate                               AS OperDate -- �.�. �� "���� �����"
            , tmp.isActive                             AS isActive
       FROM (SELECT 1 AS mySign, TRUE AS isActive UNION SELECT -1 AS mySign, FALSE AS isActive) AS tmp
             INNER JOIN _tmpItem ON AccountId_SummIn_60000 <> 0 OR AccountId_SummOut_60000 <> 0
      ;


     -- 2.0. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemPartnerTo SET ContainerId_ProfitLoss_10700 = _tmpItem_byDestination.ContainerId_ProfitLoss_10700 -- ���� - ������� (���� - ����� ���������)
                                , ContainerId_ProfitLoss_10800 = _tmpItem_byDestination.ContainerId_ProfitLoss_10800 -- ���� - ������� (���� - ������������� ���������)
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ���������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_PriceList
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10700
                  -- ��� ����� ������������� ���������
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10800
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- ���������� ProfitLossId_PriceList - ��� ����� ����� ���������
                        CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10702() -- ����� ��������� + ����
                             ELSE zc_Enum_ProfitLoss_10701() -- ����� ��������� + ���������
                        END AS ProfitLossId_PriceList

                        -- ���������� ProfitLossId_Partner - ��� ����� ������������� ���������
                      , CASE WHEN _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10802() -- ������������� ��������� + ����
                             ELSE zc_Enum_ProfitLoss_10801() -- ������������� ��������� + ���������
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , CASE WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                             FROM _tmpItemPartnerTo
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_To
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItemPartnerTo.MovementItemId = _tmpItem.MovementItemId;


     -- 2.1. ������� ���������� ��� �������� - �������
     UPDATE _tmpItemSumm SET ContainerId_ProfitLoss_40208 = _tmpItem_byDestination.ContainerId_ProfitLoss_40208 -- ���� - ������� (���� - ������� � ���� : �/�1 - �/�2)
                           , ContainerId_ProfitLoss_10800 = _tmpItem_byDestination.ContainerId_ProfitLoss_10800 -- ���� - ������� (���� - ������������� ��������� : �/�2)
     FROM _tmpItem
          JOIN
          (SELECT -- ��� ����� ������� � ���� : �/�1 - �/�2
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_CountChange
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_40208
                  -- ��� ����� ������������� ��������� : �/�2
                , lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10800
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- ���������� ProfitLossId_CountChange - ��� ����� ������� � ���� : �/�1 - �/�2
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� + ������� � ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_40208() -- ���������� �������� + ������� � ����

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_CountChange

                        -- ���������� ProfitLossId_Partner - ��� ����� ������������� ��������� : �/�2
                      , CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10802() -- ������������� ��������� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10801() -- ������������� ��������� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner

                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                              END AS ProfitLossGroupId

                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossDirection_10800() -- ��������� �������� ������������ + ������������� ���������
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70110() -- �������������� ������� + �������� �� ����� ��������
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossDirection_10800() -- ��������� �������� ������������ + ������������� ���������
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!������!!! �������������� ������� + ���.���� (���������� ������)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- �������������� ������� + ������
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70111() -- �������� �� ����� �������� + ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70112() -- �������� �� ����� �������� + �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������-���������
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItemSumm
                                  JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_To
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                              , _tmpItem.ProfitLossId_Corporate
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination ON _tmpItem_byDestination.InfoMoneyDestinationId = _tmpItem.InfoMoneyDestinationId
                                     AND _tmpItem_byDestination.BusinessId_To = _tmpItem.BusinessId_To
     WHERE _tmpItemSumm.MovementItemId = _tmpItem.MovementItemId;

     -- 2.2. ����������� �������� - ������� (�������������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0 AS ParentId
            , -1 * _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "���� ����������"
            , FALSE
       FROM -- �������� �� ������� � ���� : �/�1 - �/�2
            (SELECT _tmpItemSumm.ContainerId_ProfitLoss_40208 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_40200()       AS AnalyzerId -- ����� �/�, �������, ������� � ����
                  , SUM (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_40208, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- �������� �� ������������� ��������� : �/�2
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods                AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId -- ����� �/�, �������, �� ����������
                  , SUM (_tmpItemSumm.OperSumm_Partner)       AS OperSumm
             FROM _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId

            -- !!!���� ������� �� ����������� -> �����������!!!
            UNION ALL
             -- �������� �� ������������� ���������� : �� ����
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId --  ����� �/�, �������, � ����������
                  , 1 * SUM (_tmpItemSumm.OperSumm_Partner)   AS OperSumm
             FROM _tmpItemPartnerTo AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- �������� �� ������������� ���������� : ����
             SELECT _tmpItemSumm.ContainerId_ProfitLoss_10800 AS ContainerId_ProfitLoss
                  , _tmpItemSumm.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                          AS GoodsId
                  , _tmpItem.GoodsKindId                      AS GoodsKindId
                  , 0                                         AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10800()       AS AnalyzerId --  ����� �/�, �������, � ����������
                  , -1 * SUM (_tmpItemSumm.OperSumm_Partner)  AS OperSumm
             FROM _tmpItemPartnerTo AS _tmpItemSumm
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemSumm.MovementItemId
             GROUP BY _tmpItemSumm.ContainerId_ProfitLoss_10800, _tmpItemSumm.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!������� �� �����!!!
       ;


     -- 3.3. ����������� �������� - ���� ���������� ��� ���.���� (����������� ����) + !!!�������� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       -- ��� ������� ��������
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, _tmpItem_group.MovementItemId
            , _tmpItem_group.ContainerId_Partner
            , CASE WHEN tmpTransit.AccountId > 0 THEN tmpTransit.AccountId ELSE _tmpItem_group.AccountId_Partner END AS AccountId -- ���� ���� ������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
             , vbWhereObjectId_Analyzer               AS WhereObjectId_Analyzer   -- ������������ ���...
            , _tmpItem_group.ContainerId_Partner      AS ContainerId_Analyzer     -- ��� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0                                       AS ParentId
            , _tmpItem_group.OperSumm * CASE WHEN tmpTransit.AccountId = zc_Enum_AnalyzerId_SummIn_110101() THEN 1 ELSE -1 END AS Amount
            , tmpTransit.OperDate                     AS OperDate                 -- �.�. �� "������������" ����
            , tmpTransit.isActive                     AS isActive                 -- FALSE ����� ������, ��������� ������� �� ����
       FROM (SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10700() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_PriceList) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
             -- HAVING SUM (_tmpItem.OperSumm_Partner) <> 0
           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10200() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             HAVING SUM (_tmpItem.OperSumm_Partner - _tmpItem.OperSumm_PriceList) <> 0 -- !!!����� ����������!!!

           UNION ALL
             SELECT _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
                  , zc_Enum_AnalyzerId_ReturnInSumm_10300() AS AnalyzerId
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
                  , FALSE AS isActive
             FROM _tmpItem
             GROUP BY _tmpItem.MovementItemId, _tmpItem.ContainerId_Partner, _tmpItem.AccountId_Partner, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             HAVING SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) <> 0 -- !!!����� ����������!!!

           -- !!!���� ������� �� ����������� -> �����������!!!
           UNION ALL
             SELECT _tmpItemPartnerTo.MovementItemId, _tmpItemPartnerTo.ContainerId_Partner, _tmpItemPartnerTo.AccountId_Partner, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId, zc_Enum_AnalyzerId_ReturnInSumm_10700() AS AnalyzerId
                  , -1 * SUM (_tmpItemPartnerTo.OperSumm_Partner) AS OperSumm
                  , TRUE AS isActive
             FROM _tmpItemPartnerTo
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
             GROUP BY _tmpItemPartnerTo.MovementItemId, _tmpItemPartnerTo.ContainerId_Partner, _tmpItemPartnerTo.AccountId_Partner, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
             -- !!!������ ������������, �.�. �� ���� ��������� �������� ������!!!
             -- HAVING SUM (_tmpItemPartnerTo.OperSumm_Partner) <> 0

            ) AS _tmpItem_group
            LEFT JOIN (SELECT -1                                  AS AccountId, FALSE AS isActive, CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, FALSE AS isActive, vbOperDate        AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummIn_110101()  AS AccountId, TRUE  AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
             UNION ALL SELECT zc_Enum_AnalyzerId_SummOut_110101() AS AccountId, TRUE  AS isActive, vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpTransit ON tmpTransit.AccountId <> 0
     ;


     -- 4.1.1. ������� ���������� ��� �������� - ������� (����� ���������)
     UPDATE _tmpItem SET ContainerId_ProfitLoss_10700 = _tmpItem_byDestination.ContainerId_ProfitLoss_10700
     FROM (SELECT -- ��� ����� ���������
                  lpInsertFind_Container (inContainerDescId   := zc_Container_Summ()
                                        , inParentId          := NULL
                                        , inObjectId          := zc_Enum_Account_100301 () -- ������� �������� �������
                                        , inJuridicalId_basis := vbJuridicalId_Basis_To
                                        , inBusinessId        := _tmpItem_byProfitLoss.BusinessId_To
                                        , inObjectCostDescId  := NULL
                                        , inObjectCostId      := NULL
                                        , inDescId_1          := zc_ContainerLinkObject_ProfitLoss()
                                        , inObjectId_1        := _tmpItem_byProfitLoss.ProfitLossId_Partner
                                        , inDescId_2          := zc_ContainerLinkObject_Branch()
                                        , inObjectId_2        := vbBranchId_To
                                         ) AS ContainerId_ProfitLoss_10700
                , _tmpItem_byProfitLoss.InfoMoneyDestinationId
                , _tmpItem_byProfitLoss.BusinessId_To
           FROM (SELECT -- ���������� ProfitLossId_Partner - ��� ����� ���������
                        CASE WHEN vbIsCorporate_From = TRUE
                              AND _tmpItem_group.ProfitLossGroupId <> zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.ProfitLossId_Corporate > 0
                                  THEN _tmpItem_group.ProfitLossId_Corporate

                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                              AND _tmpItem_group.InfoMoneyDestinationId_calc = zc_Enum_InfoMoneyDestination_20900() -- ����
                                  THEN zc_Enum_ProfitLoss_10702() -- ����� ��������� + ����
                             WHEN _tmpItem_group.ProfitLossGroupId = zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                  THEN zc_Enum_ProfitLoss_10701() -- ����� ��������� + ���������

                             ELSE lpInsertFind_Object_ProfitLoss (inProfitLossGroupId      := _tmpItem_group.ProfitLossGroupId
                                                                , inProfitLossDirectionId  := _tmpItem_group.ProfitLossDirectionId
                                                                , inInfoMoneyDestinationId := _tmpItem_group.InfoMoneyDestinationId_calc
                                                                , inInfoMoneyId            := NULL
                                                                , inUserId                 := inUserId
                                                                 )
                        END AS ProfitLossId_Partner
                      , _tmpItem_group.InfoMoneyDestinationId
                      , _tmpItem_group.BusinessId_To
                 FROM (SELECT -- ����� !!!����!!! ��� � ��� �/� (�� �� �/� ������ ����� �.�. ����� ���� ��� �/�=0)
                              CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossGroup_10000() -- ��������� �������� ������������
                                   ELSE zc_Enum_ProfitLossGroup_70000() -- �������������� �������
                              END AS ProfitLossGroupId

                              -- ����� !!!������!!! (� THEN) ��� ��� �/�
                            , CASE WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900()  -- ����
                                                                          , zc_Enum_InfoMoneyDestination_30100()) -- ���������
                                        THEN zc_Enum_ProfitLossDirection_10700() -- ��������� �������� ������������ + ����� ���������
                                   WHEN vbIsCorporate_From = TRUE
                                        THEN zc_Enum_ProfitLossDirection_70110() -- �������������� ������� + �������� �� ����� ��������
                                   WHEN vbMemberId_From = 0
                                    AND _tmpItem.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100()  -- ������ �����
                                                                          , zc_Enum_InfoMoneyDestination_30200()) -- ������ �����
                                        THEN zc_Enum_ProfitLossDirection_10700() -- ��������� �������� ������������ + ����� ���������
                                   WHEN vbMemberId_From <> 0
                                        THEN zc_Enum_ProfitLossDirection_70300() -- !!!������!!! �������������� ������� + ���������� (���������, �����)
                                   ELSE zc_Enum_ProfitLossDirection_70200() -- �������������� ������� + ������
                              END AS ProfitLossDirectionId

                            , _tmpItem.InfoMoneyDestinationId_calc
                            , _tmpItem.InfoMoneyDestinationId
                            , _tmpItem.BusinessId_To
                            , _tmpItem.ProfitLossId_Corporate
                       FROM (SELECT  _tmpItem.InfoMoneyDestinationId
                                   , _tmpItem.BusinessId_To
                                   , _tmpItem.GoodsKindId
                                   , CASE WHEN (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ����
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + ���������
                                            OR (_tmpItem.GoodsKindId = zc_GoodsKind_WorkProgress() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + ������ �����
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900()) -- ������ + �� ������������ AND ����
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100()) -- ������ + �� ������������ AND ������ + ���������
                                            OR (vbAccountDirectionId_To = zc_Enum_AccountDirection_20400() AND _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200()) -- ������ + �� ������������ AND ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_21300() -- ������������� + ������������� ������������
                                          WHEN _tmpItem.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- ������ + ������ �����
                                               THEN zc_Enum_InfoMoneyDestination_30100() -- ������ + ���������
                                          ELSE _tmpItem.InfoMoneyDestinationId
                                     END AS InfoMoneyDestinationId_calc
                                   , CASE WHEN zc_Enum_InfoMoney_20801() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- ����
                                          WHEN zc_Enum_InfoMoney_20901() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70111() -- �������� �� ����� �������� + ����
                                          WHEN zc_Enum_InfoMoney_21001() = vbInfoMoneyId_CorporateFrom
                                               THEN zc_Enum_ProfitLoss_70112() -- �������� �� ����� �������� + �����
                                          WHEN zc_Enum_InfoMoney_21101() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������
                                          WHEN zc_Enum_InfoMoney_21151() = vbInfoMoneyId_CorporateFrom
                                               THEN NULL -- �������-���������
                                     END AS ProfitLossId_Corporate
                             FROM _tmpItem
                             -- !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
                             -- WHERE _tmpItem.OperSumm_Partner <> 0 OR _tmpItem.OperSumm_Partner_ChangePercent <> 0
                             GROUP BY _tmpItem.InfoMoneyDestinationId
                                    , _tmpItem.BusinessId_To
                                    , _tmpItem.GoodsKindId
                            ) AS _tmpItem
                       GROUP BY _tmpItem.InfoMoneyDestinationId_calc
                              , _tmpItem.InfoMoneyDestinationId
                              , _tmpItem.BusinessId_To
                              , _tmpItem.ProfitLossId_Corporate
                      ) AS _tmpItem_group
                ) AS _tmpItem_byProfitLoss
          ) AS _tmpItem_byDestination
     WHERE _tmpItem.InfoMoneyDestinationId = _tmpItem_byDestination.InfoMoneyDestinationId
       AND _tmpItem.BusinessId_To = _tmpItem_byDestination.BusinessId_To;

     -- 4.1.2. ����������� �������� - ������� (����� ���������) + !!!��� MovementItemId!!! + !!!�������� GoodsId + GoodsKindId!!!
     INSERT INTO _tmpMIContainer_insert (Id, DescId, MovementDescId, MovementId, MovementItemId, ContainerId
                                       , AccountId, AnalyzerId, ObjectId_Analyzer, WhereObjectId_Analyzer, ContainerId_Analyzer, ObjectIntId_Analyzer, ObjectExtId_Analyzer, ContainerIntId_Analyzer
                                       , ParentId, Amount, OperDate, isActive)
       SELECT 0, zc_MIContainer_Summ() AS DescId, vbMovementDescId, inMovementId, 0 AS MovementItemId, _tmpItem_group.ContainerId_ProfitLoss
            , zc_Enum_Account_100301 ()               AS AccountId                -- ������� �������� �������
            , _tmpItem_group.AnalyzerId               AS AnalyzerId               -- ���������, �� �������� = 0
            , _tmpItem_group.GoodsId                  AS ObjectId_Analyzer        -- �����
            , vbWhereObjectId_Analyzer                AS WhereObjectId_Analyzer   -- ������������ ���...
            , 0                                       AS ContainerId_Analyzer     -- � ���� �� �����
            , _tmpItem_group.GoodsKindId              AS ObjectIntId_Analyzer     -- ��� ������
            , vbObjectExtId_Analyzer                  AS ObjectExtId_Analyzer     -- ���������� / ���.����
            , _tmpItem_group.ContainerId_Goods        AS ContainerIntId_Analyzer  -- ��������� "�����"
            , 0 AS ParentId
            , _tmpItem_group.OperSumm
            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "���� ����������"
            , FALSE
       FROM  -- ����� ���������
            (SELECT _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10700()   AS AnalyzerId -- �����, �������, �� ����������
                  , SUM (_tmpItem.OperSumm_Partner)       AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10700, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            UNION ALL
             -- ����� ���������
             SELECT _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItem.ContainerId_Goods            AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10300()   AS AnalyzerId -- �����, �������, ������ ��������������
                  , SUM (_tmpItem.OperSumm_Partner_ChangePercent - _tmpItem.OperSumm_Partner) AS OperSumm
             FROM _tmpItem
             GROUP BY _tmpItem.ContainerId_ProfitLoss_10700, _tmpItem.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            -- !!!���� ������� �� ����������� -> �����������!!!
            UNION ALL
             -- ����� ��������� ����
             SELECT _tmpItemPartnerTo.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                  , _tmpItemPartnerTo.ContainerId_Goods   AS ContainerId_Goods
                  , _tmpItem.GoodsId                      AS GoodsId
                  , _tmpItem.GoodsKindId                  AS GoodsKindId
                  , 0                                     AS AnalyzerId -- zc_Enum_AnalyzerId_ReturnInSumm_10700()   AS AnalyzerId -- �����, �������, �� ����������
                  , -1 * SUM (_tmpItemPartnerTo.OperSumm_Partner) AS OperSumm
             FROM _tmpItemPartnerTo
                  INNER JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItemPartnerTo.MovementItemId
             GROUP BY _tmpItemPartnerTo.ContainerId_ProfitLoss_10700, _tmpItemPartnerTo.ContainerId_Goods, _tmpItem.GoodsId, _tmpItem.GoodsKindId
            ) AS _tmpItem_group
       WHERE _tmpItem_group.OperSumm <> 0 -- !!!����������� - ������ �������� �� �����������!!!
       ;


     -- !!!�������� ��� ������ ������ �� �����!!!
     IF 1=0 THEN
     -- !!!�� ������ �������� ��� ������!!!
     IF vbIsHistoryCost = TRUE THEN


     -- 5.1.1. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������������� ��������-������ ������� � ����))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId   ELSE _tmpCalc_all.AccountId_Transit   END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId_ProfitLoss END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.AccountId_Transit   ELSE _tmpCalc_all.AccountId_ProfitLoss   END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_Transit           AS ContainerId_Transit
                                       , vbAccountId_GoodsTransit                   AS AccountId_Transit
                                       , _tmpItemSumm.ContainerId_ProfitLoss_40208  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- ������� �������� �������
                                       , (_tmpItemSumm.OperSumm - _tmpItemSumm.OperSumm_Partner) AS OperSumm -- !!!����>0, ������ "�����", �.�. �� ���������� ���� ������ ��� ������ �� �����!!!
                                                                                                             -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!����������, �.�. ������� �� �����!!!
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;
     -- 5.1.2. ����������� �������� ��� ������ (�����: �����(�/�) <-> ����(������������� ��������))
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := zc_Enum_AccountKind_All()
                                                                                                             , inContainerId_1      := _tmpItem.ContainerId_Partner
                                                                                                             , inAccountId_1        := _tmpItem.AccountId_Partner
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN -1 * _tmpCalc.OperSumm > 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId
                , _tmpCalc.MovementItemId
                , _tmpCalc.OperDate
           FROM  -- ��� �������
                (SELECT _tmpCalc_all.MovementItemId
                      , tmpOperDate.OperDate
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.ContainerId ELSE _tmpCalc_all.ContainerId_Transit END AS ContainerId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate THEN _tmpCalc_all.AccountId   ELSE _tmpCalc_all.AccountId_Transit   END AS AccountId
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.ContainerId_Transit ELSE _tmpCalc_all.ContainerId_ProfitLoss END AS ContainerId_ProfitLoss
                      , CASE WHEN tmpOperDate.OperDate = vbOperDate AND vbAccountId_GoodsTransit <> 0 THEN _tmpCalc_all.AccountId_Transit   ELSE _tmpCalc_all.AccountId_ProfitLoss   END AS AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate WHERE vbAccountId_GoodsTransit <> 0
                      ) AS tmpOperDate
                      INNER JOIN (SELECT _tmpItemSumm.MovementItemId
                                       , _tmpItemSumm.ContainerId
                                       , _tmpItemSumm.AccountId
                                       , _tmpItemSumm.ContainerId_Transit           AS ContainerId_Transit
                                       , vbAccountId_GoodsTransit                   AS AccountId_Transit
                                       , _tmpItemSumm.ContainerId_ProfitLoss_10800  AS ContainerId_ProfitLoss
                                       , zc_Enum_Account_100301 ()                  AS AccountId_ProfitLoss -- ������� �������� �������
                                       , (_tmpItemSumm.OperSumm_Partner)            AS OperSumm -- !!!�� ���� >0, ������ "�����"!!!
                                                                                                -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                                  FROM _tmpItemSumm
                                 ) AS _tmpCalc_all ON _tmpCalc_all.OperSumm <> 0 -- !!!����������, �.�. ������� �� �����!!!

                UNION ALL
                 -- !!!���� "�����������" ������� �������� �������!!!, �.�. ������� �� ������� �� ����� ������ (���� ����� ���������)
                 SELECT _tmpItem.MovementItemId
                      , vbOperDate                         AS OperDate
                      , _tmpItem.ContainerId_SummIn_60000  AS ContainerId
                      , _tmpItem.AccountId_SummIn_60000    AS AccountId
                      , _tmpItem.ContainerId_SummOut_60000 AS ContainerId_ProfitLoss -- !!!������� ��� �� ProfitLoss!!!
                      , _tmpItem.AccountId_SummOut_60000   AS AccountId_ProfitLoss   -- !!!������� ��� �� ProfitLoss!!!
                      , _tmpItem.OperSumm_PriceList
                 FROM _tmpItem
                 WHERE _tmpItem.OperSumm_PriceList <> 0 -- !!!����������, �.�. ������� �� �����!!!
                   AND (_tmpItem.AccountId_SummIn_60000 <> 0 OR _tmpItem.AccountId_SummOut_60000 <> 0)

                /*-- !!!���� ������� �� ����������� -> �����������!!!
                UNION ALL
                 SELECT ...
                 FROM _tmpItemPartnerTo
                 WHERE _tmpItemPartnerTo.OperSumm_Partner <> 0 -- !!!����������, �.�. ������� �� �����!!!
                */
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN _tmpItem ON _tmpItem.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     -- 5.2.1. ����������� �������� ��� ������ (�����: ��.���� <-> ����(����� ��������)) !!!����� ����� ����� �� �/�, � ���� ��� ��� ����� �������������� � ��� inAccountId_1 �� ����������!!!
     PERFORM lpInsertUpdate_MovementItemReport (inMovementDescId     := vbMovementDescId
                                              , inMovementId         := inMovementId
                                              , inMovementItemId     := _tmpItem_byProfitLoss.MovementItemId
                                              , inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                              , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                              , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                              , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                              , inReportContainerId  := lpInsertFind_ReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                    , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                    , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                    , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                     )
                                              , inChildReportContainerId := lpInsertFind_ChildReportContainer (inActiveContainerId  := _tmpItem_byProfitLoss.ActiveContainerId
                                                                                                             , inPassiveContainerId := _tmpItem_byProfitLoss.PassiveContainerId
                                                                                                             , inActiveAccountId    := _tmpItem_byProfitLoss.ActiveAccountId
                                                                                                             , inPassiveAccountId   := _tmpItem_byProfitLoss.PassiveAccountId
                                                                                                             , inAccountKindId_1    := CASE WHEN vbPartnerId_To <> 0 THEN NULL ELSE zc_Enum_AccountKind_All() END
                                                                                                             , inContainerId_1      := CASE WHEN vbPartnerId_To <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.ContainerId, _tmpItem_byProfitLoss.ContainerId_Goods) END
                                                                                                             , inAccountId_1        := CASE WHEN vbPartnerId_To <> 0 THEN NULL ELSE COALESCE (_tmpItemSumm_group.AccountId, zc_Enum_Account_100301 ()) END -- 100301; "������� �������� �������"
                                                                                                     )
                                              , inAmount   := _tmpItem_byProfitLoss.OperSumm
                                              , inOperDate := _tmpItem_byProfitLoss.OperDate
                                               )
     FROM (SELECT ABS (_tmpCalc.OperSumm) AS OperSumm
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId_ProfitLoss ELSE _tmpCalc.ContainerId            END AS ActiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.ContainerId            ELSE _tmpCalc.ContainerId_ProfitLoss END AS PassiveContainerId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId_ProfitLoss   ELSE _tmpCalc.AccountId              END AS ActiveAccountId
                , CASE WHEN _tmpCalc.OperSumm >= 0 THEN _tmpCalc.AccountId              ELSE _tmpCalc.AccountId_ProfitLoss   END AS PassiveAccountId -- 100301; "������� �������� �������"
                , _tmpCalc.MovementItemId
                , _tmpCalc.ContainerId_Goods
                , _tmpCalc.OperDate
           FROM (SELECT _tmpCalc_all.MovementItemId
                      , _tmpCalc_all.ContainerId_Goods
                      , _tmpCalc_all.OperDate
                      , _tmpCalc_all.ContainerId
                      , _tmpCalc_all.AccountId
                      , _tmpCalc_all.ContainerId_ProfitLoss
                      , _tmpCalc_all.AccountId_ProfitLoss
                      , _tmpCalc_all.OperSumm
                 FROM (SELECT _tmpItem.MovementItemId
                            , CASE WHEN vbAccountId_GoodsTransit <> 0 THEN vbOperDatePartner ELSE vbOperDate END AS OperDate -- �.�. �� "���� ����������"
                            , _tmpItem.ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301()              AS AccountId_ProfitLoss   -- ������� �������� �������
                            , _tmpItem.OperSumm_Partner_ChangePercent AS OperSumm -- !!!����, ������ "������"!!!
                                                                                  -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                       FROM _tmpItem
                      UNION ALL
                       -- !!!���� ������� �� ����������� -> �����������!!!
                       SELECT _tmpItem.MovementItemId
                            , vbOperDatePartner AS OperDate -- �.�. �� "���� ����������"
                            , NULL AS ContainerId_Goods
                            , _tmpItem.ContainerId_Partner AS ContainerId
                            , _tmpItem.AccountId_Partner   AS AccountId
                            , _tmpItem.ContainerId_ProfitLoss_10700 AS ContainerId_ProfitLoss
                            , zc_Enum_Account_100301 ()             AS AccountId_ProfitLoss   -- ������� �������� �������
                            , -1 * _tmpItem.OperSumm_Partner AS OperSumm -- !!!�����, ������ "�����"!!!
                                                                         -- �.�. ������: Active=ContainerId_ProfitLoss � �����: Passive=ContainerId_ProfitLoss
                       FROM _tmpItemPartnerTo AS _tmpItem
                      ) AS _tmpCalc_all
                      -- LEFT JOIN (SELECT vbOperDate AS OperDate UNION SELECT vbOperDatePartner AS OperDate) AS tmpOperDate ON tmpOperDate.OperDate = vbOperDate
                      --                                                                                                    OR  (tmpOperDate.OperDate = vbOperDatePartner
                      --                                                                                                     AND COALESCE (_tmpCalc_all.AccountId_Transit, 0) <> 0)
                 -- !!!����������, �.�. ������� �� �����!!!
                 -- WHERE _tmpCalc_all.OperSumm <> 0 -- !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
                ) AS _tmpCalc
          ) AS _tmpItem_byProfitLoss
          LEFT JOIN (SELECT _tmpItemSumm.MovementItemId
                          , _tmp_byContainer.ContainerId
                          , MAX (_tmpItemSumm.AccountId) AS AccountId
                     FROM _tmpItemSumm
                          JOIN (SELECT _tmpItemSumm.MovementItemId, MAX  (_tmpItemSumm.ContainerId) AS ContainerId FROM _tmpItemSumm GROUP BY _tmpItemSumm.MovementItemId
                               ) AS _tmp_byContainer ON _tmp_byContainer.MovementItemId = _tmpItemSumm.MovementItemId
                     GROUP BY _tmpItemSumm.MovementItemId
                            , _tmp_byContainer.ContainerId
                    ) AS _tmpItemSumm_group ON _tmpItemSumm_group.MovementItemId = _tmpItem_byProfitLoss.MovementItemId
     ;

     END IF; -- if vbIsHistoryCost = TRUE -- !!!�� ������ �������� ��� ������!!!
     END IF; -- if 1=0 -- !!!�������� ��� ������ ������ �� �����!!!


     /*-- �����, �.�. ��-�� ������� ������ � ����
     DELETE FROM MovementItemLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementItemId IN (SELECT MovementItemId FROM _tmpItem);
     DELETE FROM MovementLinkObject WHERE DescId = zc_MILinkObject_Branch() AND MovementId = inMovementId;*/
     -- !!!6.0.1. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Branch(), _tmpItem.MovementItemId, vbBranchId_To)
     FROM _tmpItem;
     -- !!!6.0.2. ����������� �������� ����� � <������> � ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, vbBranchId_To);
     -- !!!6.0.3. ����������� �������� � ��������� ��������� �� ������ ��� ��������!!!
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Business(), _tmpItem.MovementItemId, _tmpItem.BusinessId_To)
     FROM _tmpItem;
     -- !!!6.0.4. ����������� �������� <zc_MIFloat_Summ - �����> + <zc_MIFloat_SummPriceList - ����� �� ������>!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), _tmpItem.MovementItemId, _tmpItem.OperSumm_Partner)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPriceList(), _tmpItem.MovementItemId, _tmpItem.OperSumm_PriceList)
     FROM _tmpItem;


     -- !!!6.0.5. �������������� zc_MI_Master � zc_MI_Child!!!
     UPDATE MovementItem SET ObjectId = tmp.ObjectId
                           , isErased = tmp.isErased
     FROM (SELECT MI_Master.Id, MI_Master.ObjectId, MI_Master.isErased FROM MovementItem AS MI_Master WHERE MI_Master.MovementId = inMovementId AND MI_Master.DescId = zc_MI_Master()
          ) AS tmp
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = tmp.Id
       AND (MovementItem.ObjectId  <> tmp.ObjectId
         OR MovementItem.isErased  <> tmp.isErased)
      ;

     -- 6.0.6. ����������� - ���������� �� "������ ��������� �� ����������"
     PERFORM lpUpdate_Movement_ReturnIn_MemberExp (inMovementId := inMovementId
                                                 , inUserId     := inUserId
                                                  );

     -- 6.1. ����� - ����������� ��������� ��������
     PERFORM lpInsertUpdate_MovementItemContainer_byTable ();

     -- 6.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ReturnIn()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.12.19         * add GoodsKindId � �����
 18.12.14                                        * all
 08.11.14                                        * add _tmpList_Alternative
 07.09.14                                        * add zc_ContainerLinkObject_Branch to vbPartnerId_From
 05.09.14                                        * add zc_ContainerLinkObject_Branch to ���.���� (����������� ����)
 02.09.14                                        * add vbIsHistoryCost
 23.08.14                                        * add vbPartnerId_From
 17.08.14                                        * add MovementDescId
 12.08.14                                        * add inBranchId :=
 12.08.14                                        * add !!!����������� ����������!!!
 22.07.14                                        * add ...Price
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 04.05.14                                        * rem zc_Enum_AccountDirection_30400
 30.04.14                                        * set lp
 16.04.14                                        * err vbInfoMoneyDestinationId_To on 3.1. ������������ ����(�����������) ��� �������� �� ���� ���������� ��� ���.���� (���������, �����)
 08.04.14                                        * add Constant_InfoMoney_isCorporate_View
 08.04.14                                        * ��������� �������� ��� vbIsCorporate_From
 08.04.14                                        * add !!!������ ������������, �.�. �������� ��� ������ ����� ������ ������!!!
 05.04.14                                        * add !!!��� �����������!!! : _tmp1___ and _tmp2___
 25.03.14                                        * ������� - !!!��� �����������!!!
 18.03.14                                        * add zc_Enum_InfoMoneyDestination_30200
 01.02.14                                        *
*/

/*
     UPDATE MovementItem SET ObjectId = tmp.ObjectId
                           , isErased = tmp.isErased
     FROM (SELECT MI_Child.Id, MI_Master.ObjectId, MI_Master.isErased
           FROM Movement
                inner JOIN MovementItem AS MI_Child
                                        ON MI_Child.MovementId = Movement .Id
                                       AND MI_Child.DescId = zc_MI_Child()
                inner JOIN MovementItem AS MI_Master ON MI_Master.Id = MI_Child.ParentId
                                                   and (MI_Master.ObjectId <> MI_Child.ObjectId
                                                     or MI_Master.isErased <> MI_Child.isErased)
           where Movement .DescId = zc_Movement_ReturnIn()
          ) AS tmp
     WHERE MovementItem.Id   = tmp.Id
*/
-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnIn (inMovementId:= 602578, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
