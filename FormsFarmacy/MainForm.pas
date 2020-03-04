unit MainForm;

interface

uses AncestorMain, dsdAction, frxExportXML, frxExportXLS, frxClass,
  frxExportRTF, Data.DB, Datasnap.DBClient, dsdDB, dsdAddOn,
  Vcl.ActnList, System.Classes, Vcl.StdActns, dxBar, cxClasses,
  DataModul, dxSkinsCore, dxSkinsDefaultPainters, DateUtils,
  cxLocalization, Vcl.Menus, cxPropertiesStore, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  Vcl.Controls, cxLabel, frxBarcode, dxSkinsdxBarPainter, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxTextEdit, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, Vcl.ExtCtrls;

type
  TMainForm = class(TAncestorMainForm)
    actMeasure: TdsdOpenForm;
    actJuridicalGroup: TdsdOpenForm;
    actGoodsProperty: TdsdOpenForm;
    actJuridical: TdsdOpenForm;
    actBusiness: TdsdOpenForm;
    actPartner: TdsdOpenForm;
    actIncome: TdsdOpenForm;
    actPaidKind: TdsdOpenForm;
    actContractKind: TdsdOpenForm;
    actUnitGroup: TdsdOpenForm;
    actUnit: TdsdOpenForm;
    actGoodsGroup: TdsdOpenForm;
    actGoodsMain: TdsdOpenForm;
    actGoodsKind: TdsdOpenForm;
    actBank: TdsdOpenForm;
    actBankAccount: TdsdOpenForm;
    actCash: TdsdOpenForm;
    actCurrency: TdsdOpenForm;
    actBalance: TdsdOpenForm;
    actPriceListLoad: TdsdOpenForm;
    actContract: TdsdOpenForm;
    actOrderExternal: TdsdOpenForm;
    actOrderInternal: TdsdOpenForm;
    actPriceList: TdsdOpenForm;
    actNDSKind: TdsdOpenForm;
    actRetail: TdsdOpenForm;
    actUser: TdsdOpenForm;
    actRole: TdsdOpenForm;
    actMovementLoad: TdsdOpenForm;
    actAdditionalGoods: TdsdOpenForm;
    actTestFormOpen: TdsdOpenForm;
    actSetDefault: TdsdOpenForm;
    actGoods: TdsdOpenForm;
    actGoodsPartnerCode: TdsdOpenForm;
    actGoodsPartnerCodeMaster: TdsdOpenForm;
    actPriceGroupSettings: TdsdOpenForm;
    actJuridicalSettings: TdsdOpenForm;
    actSaveData: TAction;
    actContactPerson: TdsdOpenForm;
    actJuridicalSettingsPriceList: TdsdOpenForm;
    actSearchGoods: TdsdOpenForm;
    actReportGoodsOrder: TdsdOpenForm;
    actOrderKind: TdsdOpenForm;
    actOrderInternalLite: TdsdOpenForm;
    miCommon: TMenuItem;
    miAdditionalGoods: TMenuItem;
    N1: TMenuItem;
    miGoodsPartnerCode: TMenuItem;
    miGoodsPartnerCodeMaster: TMenuItem;
    N4: TMenuItem;
    miUnit: TMenuItem;
    miJuridical: TMenuItem;
    N5: TMenuItem;
    miContract: TMenuItem;
    miContactPerson: TMenuItem;
    miLoad: TMenuItem;
    miImportGroup: TMenuItem;
    miMovementLoad: TMenuItem;
    miPriceListLoad: TMenuItem;
    miReports: TMenuItem;
    miBalance: TMenuItem;
    miReportGoodsOrder: TMenuItem;
    miSearchGoods: TMenuItem;
    miGoodsCommon: TMenuItem;
    miUser: TMenuItem;
    N6: TMenuItem;
    miRole: TMenuItem;
    miSetDefault: TMenuItem;
    N7: TMenuItem;
    miSaveData: TMenuItem;
    miPriceGroupSettings: TMenuItem;
    miJuridicalSettings: TMenuItem;
    N8: TMenuItem;
    miMeasure: TMenuItem;
    miNDSKind: TMenuItem;
    miRetail: TMenuItem;
    miOrderKind: TMenuItem;
    miImportType: TMenuItem;
    N9: TMenuItem;
    miImportSettings: TMenuItem;
    miImportExportLink: TMenuItem;
    N10: TMenuItem;
    miTest: TMenuItem;
    miDocuments: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    actReturnType: TdsdOpenForm;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    actLossDebt: TdsdOpenForm;
    N35: TMenuItem;
    N36: TMenuItem;
    N32: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    miReport_JuridicalSold: TMenuItem;
    miReport_JuridicalCollation: TMenuItem;
    actSendOnPrice: TdsdOpenForm;
    N42: TMenuItem;
    N43: TMenuItem;
    actMarginCategory: TdsdOpenForm;
    actMarginCategoryItem: TdsdOpenForm;
    actMarginCategoryReport: TdsdOpenForm;
    actMarginCategoryLink: TdsdOpenForm;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    actIncomePharmacy: TdsdOpenForm;
    N48: TMenuItem;
    actCheck: TdsdOpenForm;
    N49: TMenuItem;
    actCashRegister: TdsdOpenForm;
    N50: TMenuItem;
    actReport_GoodRemains: TdsdOpenForm;
    miReport_GoodRemains: TMenuItem;
    actPrice: TdsdOpenForm;
    N52: TMenuItem;
    actAlternativeGroup: TdsdOpenForm;
    N53: TMenuItem;
    miReprice: TMenuItem;
    actPaidType: TdsdOpenForm;
    N54: TMenuItem;
    actInventoryJournal: TdsdOpenForm;
    N55: TMenuItem;
    actLossJournal: TdsdOpenForm;
    N56: TMenuItem;
    actSendJournal: TdsdOpenForm;
    N57: TMenuItem;
    actCreateOrderFromMCS: TdsdOpenForm;
    N58: TMenuItem;
    actReportMovementCheckForm: TdsdOpenForm;
    miReportMovementCheckForm: TMenuItem;
    actReport_GoodsPartionMoveForm: TdsdOpenForm;
    miReport_GoodsPartionMoveForm: TMenuItem;
    actReport_GoodsPartionHistoryForm: TdsdOpenForm;
    miReport_GoodsPartionHistoryForm: TMenuItem;
    actReportSoldParamsFormOpen: TdsdOpenForm;
    N62: TMenuItem;
    actReport_SoldForm: TdsdOpenForm;
    miReport_SoldForm: TMenuItem;
    actReport_Sold_DayForm: TdsdOpenForm;
    miReport_Sold_DayForm: TMenuItem;
    actReport_Sold_DayUserForm: TdsdOpenForm;
    miReport_Sold_DayUserForm: TMenuItem;
    actSaleJournal: TdsdOpenForm;
    N66: TMenuItem;
    actReport_Movement_ByPartionGoodsForm: TdsdOpenForm;
    mniReport_Movement_ByPartionGoodsForm: TMenuItem;
    actPaymentJournal: TdsdOpenForm;
    N67: TMenuItem;
    actReasonDifferences: TdsdOpenForm;
    N68: TMenuItem;
    actReport_UploadBaDMForm: TdsdOpenForm;
    N69: TMenuItem;
    miReport_UploadBaDMForm: TMenuItem;
    actReport_UploadOptimaForm: TdsdOpenForm;
    miReport_UploadOptimaForm: TMenuItem;
    actRepriceJournal: TdsdOpenForm;
    N72: TMenuItem;
    actChangeIncomePaymentJournal: TdsdOpenForm;
    N73: TMenuItem;
    actForms: TdsdOpenForm;
    N74: TMenuItem;
    miPersonal: TMenuItem;
    actEducation: TdsdOpenForm;
    N75: TMenuItem;
    actPersonalGroup: TdsdOpenForm;
    actCalendar: TdsdOpenForm;
    actPosition: TdsdOpenForm;
    actPersonal: TdsdOpenForm;
    N76: TMenuItem;
    N77: TMenuItem;
    N78: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    actMember: TdsdOpenForm;
    N81: TMenuItem;
    actWorkTimeKind: TdsdOpenForm;
    N82: TMenuItem;
    actSheetWorkTime: TdsdOpenForm;
    N83: TMenuItem;
    actReport_LiquidForm: TdsdOpenForm;
    miReport_LiquidForm: TMenuItem;
    actReportMovementIncomeForm: TdsdOpenForm;
    miReportMovementIncomeForm: TMenuItem;
    actReport_Wage: TdsdOpenForm;
    N86: TMenuItem;
    N87: TMenuItem;
    actGoodsAll: TdsdOpenForm;
    N88: TMenuItem;
    N89: TMenuItem;
    actGoodsAllRetail: TdsdOpenForm;
    actGoodsAllJuridical: TdsdOpenForm;
    N90: TMenuItem;
    N91: TMenuItem;
    actEmailSettings: TdsdOpenForm;
    N92: TMenuItem;
    N93: TMenuItem;
    actEmailTools: TdsdOpenForm;
    actEmailKind: TdsdOpenForm;
    N94: TMenuItem;
    N95: TMenuItem;
    actPriceOnDate: TdsdOpenForm;
    N96: TMenuItem;
    actReport_ProfitForm: TdsdOpenForm;
    miReport_ProfitForm: TMenuItem;
    actReport_PriceInterventionForm: TdsdOpenForm;
    miReport_PriceInterventionForm: TMenuItem;
    N40: TMenuItem;
    actReportMovementCheckFarmForm: TdsdOpenForm;
    miReportMovementCheckFarmForm: TMenuItem;
    actReportMovementIncomeFarmForm: TdsdOpenForm;
    N51: TMenuItem;
    actReport_PriceIntervention2: TdsdOpenForm;
    N59: TMenuItem;
    actChoiceGoodsFromRemains: TdsdOpenForm;
    N60: TMenuItem;
    actGoodsOnUnit_ForSite: TdsdOpenForm;
    N61: TMenuItem;
    actReportMovementCheckMiddleForm: TdsdOpenForm;
    N63: TMenuItem;
    actMaker: TdsdOpenForm;
    N64: TMenuItem;
    actPromo: TdsdOpenForm;
    N65: TMenuItem;
    actReport_RemainsOverGoods: TdsdOpenForm;
    miReport_RemainsOverGoods: TMenuItem;
    actUnitForFarmacyCash: TdsdOpenForm;
    FarmacyCash1: TMenuItem;
    actEmail: TdsdOpenForm;
    N71: TMenuItem;
    actOver: TdsdOpenForm;
    N84: TMenuItem;
    actRoleUnion: TdsdOpenForm;
    N85: TMenuItem;
    actColor: TdsdOpenForm;
    N97: TMenuItem;
    actOverSettings: TdsdOpenForm;
    miOverSettings: TMenuItem;
    actDiscountCard: TdsdOpenForm;
    actBarCode: TdsdOpenForm;
    actDiscountExternal: TdsdOpenForm;
    N99: TMenuItem;
    N100: TMenuItem;
    N101: TMenuItem;
    miDiscountExternal: TMenuItem;
    N103: TMenuItem;
    actConfirmedKind: TdsdOpenForm;
    N98: TMenuItem;
    actDiscountExternalTools: TdsdOpenForm;
    miDiscountExternalTools: TMenuItem;
    actPriceGroupSettingsTOP: TdsdOpenForm;
    N102: TMenuItem;
    actReport_MovementCheckUnLiquid: TdsdOpenForm;
    N104: TMenuItem;
    actReport_Payment_Plan: TdsdOpenForm;
    N105: TMenuItem;
    actReport_MovementCheckErrorForm: TdsdOpenForm;
    N106: TMenuItem;
    actOrderShedule: TdsdOpenForm;
    N107: TMenuItem;
    actReport_MovementIncome_Promo: TdsdOpenForm;
    N108: TMenuItem;
    actReport_MovementCheck_Promo: TdsdOpenForm;
    N109: TMenuItem;
    actReport_CheckPromo: TdsdOpenForm;
    N110: TMenuItem;
    N111: TMenuItem;
    actKindOutSP: TdsdOpenForm;
    N112: TMenuItem;
    actBrandSP: TdsdOpenForm;
    actIntenalSP: TdsdOpenForm;
    N113: TMenuItem;
    N114: TMenuItem;
    actGoodsSP: TdsdOpenForm;
    N115: TMenuItem;
    actReport_CheckSP: TdsdOpenForm;
    N117: TMenuItem;
    N118: TMenuItem;
    N119: TMenuItem;
    actPartnerMedical: TdsdOpenForm;
    N120: TMenuItem;
    actConditionsKeep: TdsdOpenForm;
    N121: TMenuItem;
    actReportPromoParams: TdsdOpenForm;
    N122: TMenuItem;
    actReport_MinPrice_onGoods: TdsdOpenForm;
    N123: TMenuItem;
    actReport_Badm: TdsdOpenForm;
    N126: TMenuItem;
    actUnit_byReportBadm: TdsdOpenForm;
    N125: TMenuItem;
    actMarginCategory_Cross: TdsdOpenForm;
    N127: TMenuItem;
    actMarginCategory_Total: TdsdOpenForm;
    actPromoUnit: TdsdOpenForm;
    N128: TMenuItem;
    actReport_MovementCheck_Cross: TdsdOpenForm;
    miReport_MovementCheck_Cross: TMenuItem;
    actReport_MovementCheckFarm_Cross: TdsdOpenForm;
    miReport_MovementCheckFarm_Cross: TMenuItem;
    actReport_SaleSP: TdsdOpenForm;
    N13031: TMenuItem;
    actMedicSP: TdsdOpenForm;
    actMemberSP: TdsdOpenForm;
    N41: TMenuItem;
    N129: TMenuItem;
    actReport_RemainsOverGoods_To: TdsdOpenForm;
    N130: TMenuItem;
    N131: TMenuItem;
    N132: TMenuItem;
    N133: TMenuItem;
    actInvoice: TdsdOpenForm;
    N70: TMenuItem;
    N134: TMenuItem;
    N135: TMenuItem;
    actReport_CheckPromoFarm: TdsdOpenForm;
    N136: TMenuItem;
    actReport_MovementPriceList_Cross: TdsdOpenForm;
    N137: TMenuItem;
    N138: TMenuItem;
    actDiscountExternalJuridical: TdsdOpenForm;
    miDiscountExternalJuridical: TMenuItem;
    actSPKind: TdsdOpenForm;
    N139: TMenuItem;
    actMemberIncomeCheck: TdsdOpenForm;
    N140: TMenuItem;
    actGoodsBarCodeLoad: TdsdOpenForm;
    N141: TMenuItem;
    actGoods_BarCode: TdsdOpenForm;
    N142: TMenuItem;
    actReportMovementCheckLight: TdsdOpenForm;
    N143: TMenuItem;
    actReport_GoodsRemainsLight: TdsdOpenForm;
    N144: TMenuItem;
    miExportSalesForSupp: TMenuItem;
    actProvinceCity: TdsdOpenForm;
    N145: TMenuItem;
    actReport_Check_Assortment: TdsdOpenForm;
    N146: TMenuItem;
    actReport_OverOrder: TdsdOpenForm;
    N147: TMenuItem;
    N148: TMenuItem;
    actReport_Check_Rating: TdsdOpenForm;
    N124: TMenuItem;
    actReportMovementCheckGrowthAndFalling: TdsdOpenForm;
    miReportMovementCheckGrowthAndFalling: TMenuItem;
    actUnit_Object: TdsdOpenForm;
    N149: TMenuItem;
    actArea: TdsdOpenForm;
    N150: TMenuItem;
    actJuridicalArea: TdsdOpenForm;
    N151: TMenuItem;
    actUnit_JuridicalArea: TdsdOpenForm;
    N152: TMenuItem;
    actReport_CheckMiddle_Detail: TdsdOpenForm;
    N153: TMenuItem;
    actReport_GoodsRemains_AnotherRetail: TdsdOpenForm;
    ID1: TMenuItem;
    actPersonalList: TdsdOpenForm;
    actExportSalesForSuppClick: TAction;
    actMarginCategory_Movement: TdsdOpenForm;
    N154: TMenuItem;
    N155: TMenuItem;
    actReport_Check_UKTZED: TdsdOpenForm;
    N156: TMenuItem;
    actPromoCode: TdsdOpenForm;
    N157: TMenuItem;
    N158: TMenuItem;
    N159: TMenuItem;
    actPromoCodeMovement: TdsdOpenForm;
    N160: TMenuItem;
    N161: TMenuItem;
    actFiscal: TdsdOpenForm;
    miFiscal: TMenuItem;
    N162: TMenuItem;
    actReport_GoodsRemainsCurrent: TdsdOpenForm;
    miReport_GoodsRemainsCurrent: TMenuItem;
    actGoodsRetail: TdsdOpenForm;
    miGoodsRetail: TMenuItem;
    actGoods_NDS_diff: TdsdOpenForm;
    miGoods_NDS_diff: TMenuItem;
    N2: TMenuItem;
    actReport_Analysis_Remains_Selling: TAction;
    actReportMovementCheckFLForm: TdsdOpenForm;
    miReportMovementCheckFLForm: TMenuItem;
    actReport_ImplementationPlanEmployee: TAction;
    N3: TMenuItem;
    actReport_IncomeConsumptionBalance: TAction;
    N116: TMenuItem;
    actReport_ImplementationPlanEmployeeAll: TdsdOpenForm;
    N163: TMenuItem;
    actGoodsSPJournal: TdsdOpenForm;
    miGoodsSPJournal: TMenuItem;
    actReport_Liquidity: TdsdOpenForm;
    N164: TMenuItem;
    actPriceChangeOnDate: TdsdOpenForm;
    actPriceChange: TdsdOpenForm;
    N165: TMenuItem;
    miPriceChange: TMenuItem;
    miPriceChangeOnDate: TMenuItem;
    miRepriceChange: TMenuItem;
    actRepriceChangeJournal: TdsdOpenForm;
    miRepriceChangeJournal: TMenuItem;
    actReport_Check_PriceChange: TdsdOpenForm;
    miReport_Check_PriceChange: TMenuItem;
    actMarginCategoryJournal2: TdsdOpenForm;
    miMarginCategoryJournal2: TMenuItem;
    N166: TMenuItem;
    actReport_TestingUser: TdsdOpenForm;
    N167: TMenuItem;
    actListDiff: TdsdOpenForm;
    N168: TMenuItem;
    actPriceListLoad_Add: TdsdOpenForm;
    miPriceListLoad_Add: TMenuItem;
    N170: TMenuItem;
    actClientsByBank: TdsdOpenForm;
    N169: TMenuItem;
    actUnnamedEnterprises: TdsdOpenForm;
    N171: TMenuItem;
    actReport_IncomeSample: TdsdOpenForm;
    miReport_IncomeSample: TMenuItem;
    actReport_KPU: TdsdOpenForm;
    N172: TMenuItem;
    actReport_Check_GoodsPriceChange: TdsdOpenForm;
    miReport_Check_GoodsPriceChange: TMenuItem;
    actLog_CashRemains: TdsdOpenForm;
    GUID1: TMenuItem;
    actRepriceUnitSheduler: TdsdOpenForm;
    N173: TMenuItem;
    actCheckNoCashRegister: TdsdOpenForm;
    N174: TMenuItem;
    actReportUnLiquid_Movement: TdsdOpenForm;
    N175: TMenuItem;
    actCheckUnComplete: TdsdOpenForm;
    N176: TMenuItem;
    actEmployeeSchedule: TdsdOpenForm;
    N177: TMenuItem;
    actDiffKind: TdsdOpenForm;
    miDiffKind: TMenuItem;
    actUnit_MCS: TdsdOpenForm;
    miUnit_MCS: TMenuItem;
    actReport_Movement_ListDiff: TdsdOpenForm;
    miReport_Movement_ListDiff: TMenuItem;
    actRecalcMCSSheduler: TdsdOpenForm;
    N178: TMenuItem;
    actReturnInJournal: TdsdOpenForm;
    miReturnInJournal: TMenuItem;
    actGlobalConst: TdsdOpenForm;
    miGlobalConst: TMenuItem;
    actGoodsCategory: TdsdOpenForm;
    miGoodsCategory: TMenuItem;
    N179: TMenuItem;
    actReportRogersMovementCheck: TdsdOpenForm;
    actRepriceRogersJournal: TdsdOpenForm;
    N180: TMenuItem;
    N181: TMenuItem;
    actBankPOSTerminal: TdsdOpenForm;
    POS1: TMenuItem;
    actTaxUnit: TdsdOpenForm;
    miTaxUnit: TMenuItem;
    actUnitBankPOSTerminal: TdsdOpenForm;
    POS2: TMenuItem;
    actJackdawsChecks: TdsdOpenForm;
    actJackdawsChecks1: TMenuItem;
    actPUSH: TdsdOpenForm;
    actPUSH1: TMenuItem;
    actSendPartionDate: TdsdOpenForm;
    miSendPartionDate: TMenuItem;
    actGoodsInventory: TdsdOpenForm;
    N182: TMenuItem;
    actCreditLimitDistributor: TdsdOpenForm;
    N183: TMenuItem;
    actOrderInternalPromo: TdsdOpenForm;
    miOrderInternalPromo: TMenuItem;
    actPartionDateKind: TdsdOpenForm;
    N184: TMenuItem;
    actRetailCostCredit: TdsdOpenForm;
    miRetailCostCredit: TMenuItem;
    actReturnOutPharmacy: TdsdOpenForm;
    miReturnOutPharmacy: TMenuItem;
    actReport_GoodsPartionDate: TdsdOpenForm;
    miReport_GoodsPartionDate: TMenuItem;
    actReport_CheckPartionDate: TdsdOpenForm;
    miReport_CheckPartionDate: TMenuItem;
    actSendMenegerJournal: TdsdOpenForm;
    N185: TMenuItem;
    actReport_GoodsNotSalePast: TdsdOpenForm;
    actReportGoodsNotSalePast1: TMenuItem;
    acttReport_GoodsPartionDate_Promo: TdsdOpenForm;
    N186: TMenuItem;
    actReport_GoodsPartionDate5: TdsdOpenForm;
    N510: TMenuItem;
    actReport_Movement_Send_RemainsSun: TdsdOpenForm;
    miReport_Movement_Send_RemainsSun: TMenuItem;
    actMCS_Lite: TdsdOpenForm;
    miMCS_Lite: TMenuItem;
    actReport_PriceProtocol: TdsdOpenForm;
    miReport_PriceProtocol: TMenuItem;
    actDriver: TdsdOpenForm;
    N187: TMenuItem;
    actUnitLincDriver: TdsdOpenForm;
    N188: TMenuItem;
    actReport_BalanceGoodsSUN: TdsdOpenForm;
    N189: TMenuItem;
    actWages: TdsdOpenForm;
    N190: TMenuItem;
    actReport_CheckSendSUN_InOut: TdsdOpenForm;
    miReport_CheckSendSUN_InOut: TMenuItem;
    actPayrollType: TdsdOpenForm;
    N191: TMenuItem;
    actReport_CheckSUN: TdsdOpenForm;
    miReport_CheckSUN: TMenuItem;
    actGoodsAll_Tab: TdsdOpenForm;
    actGoodsAllRetail_Tab: TdsdOpenForm;
    miGoodsAll_Tab: TMenuItem;
    miGoodsAllRetail_Tab: TMenuItem;
    N192: TMenuItem;
    actReport_DiscountExternal: TdsdOpenForm;
    N193: TMenuItem;
    actGoodsMainTab_Error: TdsdOpenForm;
    miGoodsMainTab_Error: TMenuItem;
    actReport_Profitability: TdsdOpenForm;
    N194: TMenuItem;
    actLoyaltyJournal: TdsdOpenForm;
    N195: TMenuItem;
    actGoodsRetailTab_Error: TdsdOpenForm;
    miGoodsRetailTab_Error: TMenuItem;
    N196: TMenuItem;
    actReport_Send_RemainsSun_over: TdsdOpenForm;
    miReport_GoodsSendSUN_over: TMenuItem;
    actMarginCategory_All: TdsdOpenForm;
    miMarginCategory_All: TMenuItem;
    actGoodsReprice: TdsdOpenForm;
    miGoodsReprice: TMenuItem;
    DSGetInfo: TDataSource;
    CDSGetInfo: TClientDataSet;
    spGetInfo: TdsdStoredProc;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colText: TcxGridDBColumn;
    colData: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    actRefresh: TdsdExecStoredProc;
    actCashSettings: TdsdOpenForm;
    N197: TMenuItem;
    actReport_GoodsPartionDate0: TdsdOpenForm;
    N198: TMenuItem;
    actReport_Movement_ReturnOut: TdsdOpenForm;
    miReport_Movement_ReturnOut: TMenuItem;
    N199: TMenuItem;
    N200: TMenuItem;
    actReport_IlliquidReductionPlanAll: TdsdOpenForm;
    N201: TMenuItem;
    miReprice_test: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    actPercentageOverdueSUN: TdsdOpenForm;
    N204: TMenuItem;
    TimerPUSH: TTimer;
    spGet_PUSH_Farmacy: TdsdStoredProc;
    PUSHDS: TClientDataSet;
    actPermanentDiscount: TdsdOpenForm;
    N205: TMenuItem;
    actReport_PromoDoctors: TdsdOpenForm;
    actReport_PromoEntrances: TdsdOpenForm;
    N206: TMenuItem;
    N207: TMenuItem;
    actIlliquidUnitJournal: TdsdOpenForm;
    N208: TMenuItem;
    N209: TMenuItem;
    actLoyaltySaveMoneyJournal: TdsdOpenForm;
    N210: TMenuItem;
    actReport_IlliquidReductionPlanUser: TdsdOpenForm;
    N211: TMenuItem;
    N212: TMenuItem;
    actBuyer: TdsdOpenForm;
    N213: TMenuItem;
    actReport_StockTiming_RemainderForm: TdsdOpenForm;
    N214: TMenuItem;
    actReport_InventoryErrorRemains: TdsdOpenForm;
    N215: TMenuItem;
    actPlanIventory: TdsdOpenForm;
    miPlanIventory: TMenuItem;
    actReport_SendSUNLoss: TdsdOpenForm;
    actReport_SendSUNDelay: TdsdOpenForm;
    N216: TMenuItem;
    N217: TMenuItem;
    N218: TMenuItem;
    actReport_GoodsSendSUN: TdsdOpenForm;
    miReport_GoodsSendSUN: TMenuItem;
    actReport_SUNSaleDates: TdsdOpenForm;
    N219: TMenuItem;
    actTechnicalRediscount: TdsdOpenForm;
    N220: TMenuItem;
    actTechnicalRediscountCashier: TdsdOpenForm;
    N221: TMenuItem;
    actReport_SendSUN_SUNv2: TdsdOpenForm;
    miReport_SendSUN_SUNv2: TMenuItem;
    actReport_JuridicalRemains: TdsdOpenForm;
    miReport_JuridicalRemains: TMenuItem;
    actReport_Movement_Send_RemainsSunOut: TdsdOpenForm;
    N222: TMenuItem;
    actHelsiUser: TdsdOpenForm;
    N223: TMenuItem;
    actReport_JuridicalSales: TdsdOpenForm;
    N224: TMenuItem;
    miReport_JuridicalSales: TMenuItem;
    actReport_EntryGoodsMovement: TdsdOpenForm;
    N225: TMenuItem;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MenuItem70: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem79: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    MenuItem95: TMenuItem;
    MenuItem96: TMenuItem;
    MenuItem97: TMenuItem;
    MenuItem98: TMenuItem;
    MenuItem99: TMenuItem;
    MenuItem100: TMenuItem;
    MenuItem101: TMenuItem;
    MenuItem102: TMenuItem;
    MenuItem103: TMenuItem;
    MenuItem104: TMenuItem;
    MenuItem105: TMenuItem;
    MenuItem106: TMenuItem;
    MenuItem107: TMenuItem;
    MenuItem108: TMenuItem;
    MenuItem109: TMenuItem;
    MenuItem110: TMenuItem;
    MenuItem111: TMenuItem;
    MenuItem112: TMenuItem;
    MenuItem113: TMenuItem;
    MenuItem114: TMenuItem;
    MenuItem115: TMenuItem;
    MenuItem116: TMenuItem;
    MenuItem117: TMenuItem;
    MenuItem118: TMenuItem;
    MenuItem119: TMenuItem;
    MenuItem120: TMenuItem;
    MenuItem121: TMenuItem;
    MenuItem122: TMenuItem;
    MenuItem123: TMenuItem;
    MenuItem124: TMenuItem;
    MenuItem125: TMenuItem;
    MenuItem126: TMenuItem;
    MenuItem127: TMenuItem;
    MenuItem128: TMenuItem;
    MenuItem129: TMenuItem;
    MenuItem130: TMenuItem;
    MenuItem131: TMenuItem;
    MenuItem132: TMenuItem;
    MenuItem133: TMenuItem;
    MenuItem134: TMenuItem;
    MenuItem135: TMenuItem;
    MenuItem136: TMenuItem;
    MenuItem137: TMenuItem;
    MenuItem138: TMenuItem;
    MenuItem139: TMenuItem;
    MenuItem140: TMenuItem;
    MenuItem141: TMenuItem;
    MenuItem142: TMenuItem;
    MenuItem143: TMenuItem;
    MenuItem144: TMenuItem;
    MenuItem145: TMenuItem;
    MenuItem146: TMenuItem;
    MenuItem147: TMenuItem;
    MenuItem148: TMenuItem;
    MenuItem149: TMenuItem;
    MenuItem150: TMenuItem;
    MenuItem151: TMenuItem;
    MenuItem152: TMenuItem;
    MenuItem153: TMenuItem;
    MenuItem154: TMenuItem;
    MenuItem155: TMenuItem;
    MenuItem156: TMenuItem;
    MenuItem157: TMenuItem;
    MenuItem158: TMenuItem;
    MenuItem159: TMenuItem;
    MenuItem160: TMenuItem;
    MenuItem161: TMenuItem;
    MenuItem162: TMenuItem;
    MenuItem163: TMenuItem;
    MenuItem164: TMenuItem;
    MenuItem165: TMenuItem;
    MenuItem166: TMenuItem;
    MenuItem167: TMenuItem;
    MenuItem168: TMenuItem;
    MenuItem169: TMenuItem;
    MenuItem170: TMenuItem;
    MenuItem171: TMenuItem;
    MenuItem172: TMenuItem;
    MenuItem173: TMenuItem;
    MenuItem174: TMenuItem;
    MenuItem175: TMenuItem;
    MenuItem176: TMenuItem;
    MenuItem177: TMenuItem;
    MenuItem178: TMenuItem;
    MenuItem179: TMenuItem;
    MenuItem180: TMenuItem;
    MenuItem181: TMenuItem;
    MenuItem182: TMenuItem;
    MenuItem183: TMenuItem;
    MenuItem184: TMenuItem;
    MenuItem185: TMenuItem;
    MenuItem186: TMenuItem;
    MenuItem187: TMenuItem;
    MenuItem188: TMenuItem;
    MenuItem189: TMenuItem;
    MenuItem190: TMenuItem;
    MenuItem191: TMenuItem;
    MenuItem192: TMenuItem;
    MenuItem193: TMenuItem;
    MenuItem194: TMenuItem;
    MenuItem195: TMenuItem;
    MenuItem196: TMenuItem;
    MenuItem197: TMenuItem;
    MenuItem198: TMenuItem;
    MenuItem199: TMenuItem;
    MenuItem200: TMenuItem;
    MenuItem201: TMenuItem;
    MenuItem202: TMenuItem;
    MenuItem203: TMenuItem;
    MenuItem204: TMenuItem;
    MenuItem205: TMenuItem;
    MenuItem206: TMenuItem;
    MenuItem207: TMenuItem;
    MenuItem208: TMenuItem;
    MenuItem209: TMenuItem;
    MenuItem210: TMenuItem;
    MenuItem211: TMenuItem;
    MenuItem212: TMenuItem;
    MenuItem213: TMenuItem;
    MenuItem214: TMenuItem;
    MenuItem215: TMenuItem;
    MenuItem216: TMenuItem;
    MenuItem217: TMenuItem;
    MenuItem218: TMenuItem;
    MenuItem219: TMenuItem;
    MenuItem220: TMenuItem;
    MenuItem221: TMenuItem;
    MenuItem222: TMenuItem;
    MenuItem223: TMenuItem;
    MenuItem224: TMenuItem;
    MenuItem225: TMenuItem;
    MenuItem226: TMenuItem;
    MenuItem227: TMenuItem;
    MenuItem228: TMenuItem;
    MenuItem229: TMenuItem;
    MenuItem230: TMenuItem;
    MenuItem231: TMenuItem;
    MenuItem232: TMenuItem;
    MenuItem233: TMenuItem;
    MenuItem234: TMenuItem;
    MenuItem235: TMenuItem;
    MenuItem236: TMenuItem;
    MenuItem237: TMenuItem;
    MenuItem238: TMenuItem;
    MenuItem239: TMenuItem;
    MenuItem240: TMenuItem;
    MenuItem241: TMenuItem;
    MenuItem242: TMenuItem;
    MenuItem243: TMenuItem;
    MenuItem244: TMenuItem;
    MenuItem245: TMenuItem;
    MenuItem246: TMenuItem;
    MenuItem247: TMenuItem;
    MenuItem248: TMenuItem;
    MenuItem249: TMenuItem;
    MenuItem250: TMenuItem;
    MenuItem251: TMenuItem;
    MenuItem252: TMenuItem;
    MenuItem253: TMenuItem;
    MenuItem254: TMenuItem;
    MenuItem255: TMenuItem;
    MenuItem256: TMenuItem;
    MenuItem257: TMenuItem;
    MenuItem258: TMenuItem;
    MenuItem259: TMenuItem;
    MenuItem260: TMenuItem;
    MenuItem261: TMenuItem;
    MenuItem262: TMenuItem;
    MenuItem263: TMenuItem;
    MenuItem264: TMenuItem;
    MenuItem265: TMenuItem;
    MenuItem266: TMenuItem;
    MenuItem267: TMenuItem;
    MenuItem268: TMenuItem;
    MenuItem269: TMenuItem;
    MenuItem270: TMenuItem;
    MenuItem271: TMenuItem;
    MenuItem272: TMenuItem;
    MenuItem273: TMenuItem;
    MenuItem274: TMenuItem;
    MenuItem275: TMenuItem;
    MenuItem276: TMenuItem;
    MenuItem277: TMenuItem;
    MenuItem278: TMenuItem;
    MenuItem279: TMenuItem;
    MenuItem280: TMenuItem;
    MenuItem281: TMenuItem;
    MenuItem282: TMenuItem;
    MenuItem283: TMenuItem;
    MenuItem284: TMenuItem;
    MenuItem285: TMenuItem;
    MenuItem286: TMenuItem;
    MenuItem287: TMenuItem;
    MenuItem288: TMenuItem;
    MenuItem289: TMenuItem;
    MenuItem290: TMenuItem;
    MenuItem291: TMenuItem;
    MenuItem292: TMenuItem;
    MenuItem293: TMenuItem;
    MenuItem294: TMenuItem;
    MenuItem295: TMenuItem;
    MenuItem296: TMenuItem;
    MenuItem297: TMenuItem;
    MenuItem298: TMenuItem;
    MenuItem299: TMenuItem;
    MenuItem300: TMenuItem;
    MenuItem301: TMenuItem;
    MenuItem302: TMenuItem;
    MenuItem303: TMenuItem;
    MenuItem304: TMenuItem;
    MenuItem305: TMenuItem;
    MenuItem306: TMenuItem;
    MenuItem307: TMenuItem;
    MenuItem308: TMenuItem;
    MenuItem309: TMenuItem;
    MenuItem310: TMenuItem;
    MenuItem311: TMenuItem;
    MenuItem312: TMenuItem;
    MenuItem313: TMenuItem;
    MenuItem314: TMenuItem;
    MenuItem315: TMenuItem;
    MenuItem316: TMenuItem;
    MenuItem317: TMenuItem;
    MenuItem318: TMenuItem;
    MenuItem319: TMenuItem;
    MenuItem320: TMenuItem;
    MenuItem321: TMenuItem;
    MenuItem322: TMenuItem;
    MenuItem323: TMenuItem;
    MenuItem324: TMenuItem;
    MenuItem325: TMenuItem;
    MenuItem326: TMenuItem;
    MenuItem327: TMenuItem;
    MenuItem328: TMenuItem;
    MenuItem329: TMenuItem;
    MenuItem330: TMenuItem;
    MenuItem331: TMenuItem;
    MenuItem332: TMenuItem;
    MenuItem333: TMenuItem;
    MenuItem334: TMenuItem;
    MenuItem335: TMenuItem;
    MenuItem336: TMenuItem;
    MenuItem337: TMenuItem;
    MenuItem338: TMenuItem;
    MenuItem339: TMenuItem;
    MenuItem340: TMenuItem;
    MenuItem341: TMenuItem;
    MenuItem342: TMenuItem;
    MenuItem343: TMenuItem;
    MenuItem344: TMenuItem;
    MenuItem345: TMenuItem;
    MenuItem346: TMenuItem;
    MenuItem347: TMenuItem;
    MenuItem348: TMenuItem;
    MenuItem349: TMenuItem;
    MenuItem350: TMenuItem;
    MenuItem351: TMenuItem;
    MenuItem352: TMenuItem;
    MenuItem353: TMenuItem;
    MenuItem354: TMenuItem;
    MenuItem355: TMenuItem;
    MenuItem356: TMenuItem;
    MenuItem357: TMenuItem;
    procedure actSaveDataExecute(Sender: TObject);

    procedure miRepriceClick(Sender: TObject);
    procedure actExportSalesForSuppClickExecute(Sender: TObject);
    procedure actReport_Analysis_Remains_SellingExecute(Sender: TObject);
    procedure actReport_ImplementationPlanEmployeeExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actReport_IncomeConsumptionBalanceExecute(Sender: TObject);
    procedure miRepriceChangeClick(Sender: TObject);
    procedure miReprice_testClick(Sender: TObject);
    procedure TimerPUSHTimer(Sender: TObject);
  private
    { Private declarations }
    FLoadPUSH: Integer;
  public
    { Public declarations }
  end;

var
  MainFormInstance: TMainForm;

implementation

{$R *.dfm}

uses
  UploadUnloadData, Dialogs, Forms, SysUtils, CommonData, IdGlobal, RepriceUnit,  RepriceUnit_test,
  RepriceChangeRetail, ExportSalesForSupp, Report_Analysis_Remains_Selling,
  Report_ImplementationPlanEmployee, Report_IncomeConsumptionBalance, PUSHMessageFarmacy;


procedure TMainForm.actReport_Analysis_Remains_SellingExecute(Sender: TObject);
begin
  with TReport_Analysis_Remains_SellingForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actReport_ImplementationPlanEmployeeExecute(
  Sender: TObject);
begin
  with TReport_ImplementationPlanEmployeeForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actReport_IncomeConsumptionBalanceExecute(Sender: TObject);
begin
  inherited;
  with TReport_IncomeConsumptionBalanceForm.Create(nil) do
  try
     Show;
  finally
  end;
end;

procedure TMainForm.actSaveDataExecute(Sender: TObject);
begin
  with TdmUnloadUploadData.Create(nil) do
     try
       UnloadData;
     finally
       Free;
     end;

  Application.ProcessMessages;
  ShowMessage('���������');
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  inherited;

  actReport_Analysis_Remains_Selling.Visible := actReport_CheckPromo.Visible or (gc_User.Session = '11263040');
  actReport_IncomeConsumptionBalance.Visible := actReport_CheckPromo.Visible;

  if gc_User.Session = '3' then
  begin
    cxGrid.Visible := True;
    actRefresh.Execute;
  end else
  begin
    cxGrid.Visible := False;
    actRefresh.Enabled := False;
    actRefresh.Timer.Enabled := False;
  end;

  FLoadPUSH := 16;
  TimerPUSH.Enabled := True;
end;

procedure TMainForm.actExportSalesForSuppClickExecute(Sender: TObject);
begin
  TExportSalesForSuppForm.Create(Self).Show;
end;

procedure TMainForm.miRepriceClick(Sender: TObject);
begin
  with TRepriceUnitForm.Create(nil) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.miReprice_testClick(Sender: TObject);
begin
  with TRepriceUnit_testForm.Create(nil) do
  try
     Show;
  finally
     //Free;
  end;
end;

procedure TMainForm.TimerPUSHTimer(Sender: TObject);

  procedure Load_PUSH;
  begin
    if FLoadPUSH > 15 then
    begin
      FLoadPUSH := 0;

      if not gc_User.Local then
      try
        spGet_PUSH_Farmacy.Execute;
        TimerPUSH.Interval := 1000;
      except
      end;
    end else Inc(FLoadPUSH);
  end;

begin
  TimerPUSH.Enabled := False;
  TimerPUSH.Interval := 60 * 1000;

  try
    Load_PUSH;

    if PUSHDS.Active and (PUSHDS.RecordCount > 0) then
    begin
      PUSHDS.First;
      try
        TimerPUSH.Interval := 1000;
        if (Trim(PUSHDS.FieldByName('Text').AsString) <> '') then ShowPUSHMessageFarmacy(PUSHDS.FieldByName('Text').AsString);
      finally
         PUSHDS.Delete;
      end;
    end;
  finally
    TimerPUSH.Enabled := True;
    PUSHDS.Close;
  end;
end;

procedure TMainForm.miRepriceChangeClick(Sender: TObject);
begin
  with TReprice�hangeRetailForm.Create(nil) do
  try
     Show;
  finally
     //Free;
  end;
end;

end.
