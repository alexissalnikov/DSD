program ProjectTest;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  dbCreateStructureTest in '..\SOURCE\STRUCTURE\dbCreateStructureTest.pas',
  dbCreateViewTest in '..\SOURCE\View\dbCreateViewTest.pas',
  dbMetadataTest in '..\SOURCE\Metadata\dbMetadataTest.pas',
  dbProcedureTest in '..\SOURCE\dbProcedureTest.pas',
  dbEnumTest in '..\SOURCE\dbEnumTest.pas',
  AuthenticationTest in '..\SOURCE\AuthenticationTest.pas',
  CommonObjectProcedureTest in '..\SOURCE\Objects\CommonObjectProcedureTest.pas',
  dbObjectTest in '..\SOURCE\dbObjectTest.pas',
  UnitsTest in '..\SOURCE\Objects\All\UnitsTest.pas',
  CommonMovementProcedureTest in '..\SOURCE\Movement\CommonMovementProcedureTest.pas',
  dbMovementTest in '..\SOURCE\Movement\dbMovementTest.pas',
  LoadFormTest in '..\SOURCE\LoadFormTest.pas',
  Forms,
  CommonContainerProcedureTest in '..\SOURCE\Container\CommonContainerProcedureTest.pas',
  CommonMovementItemProcedureTest in '..\SOURCE\MovementItem\CommonMovementItemProcedureTest.pas',
  CommonMovementItemContainerProcedureTest in '..\SOURCE\MovementItemContainer\CommonMovementItemContainerProcedureTest.pas',
  CommonObjectHistoryProcedureTest in '..\SOURCE\ObjectHistory\CommonObjectHistoryProcedureTest.pas',
  CommonProtocolProcedureTest in '..\SOURCE\Protocol\CommonProtocolProcedureTest.pas',
  CommonFunctionTest in '..\SOURCE\Function\CommonFunctionTest.pas',
  CommonReportsProcedureTest in '..\SOURCE\Reports\CommonReportsProcedureTest.pas',
  DataModul in '..\..\SOURCE\DataModul.pas' {dmMain: TDataModule},
  Authentication in '..\..\SOURCE\Authentication.pas',
  Storage in '..\..\SOURCE\Storage.pas',
  zLibUtil in '..\SOURCE\zLibUtil.pas',
  UtilConst in '..\..\SOURCE\UtilConst.pas',
  UtilConvert in '..\..\SOURCE\UtilConvert.pas',
  CommonData in '..\..\SOURCE\CommonData.pas',
  dsdGuides in '..\..\SOURCE\COMPONENT\dsdGuides.pas',
  FormStorage in '..\..\SOURCE\FormStorage.pas',
  GoodsKindEdit in '..\..\Forms\GoodsKindEdit.pas' {GoodsKindEditForm},
  GoodsPropertyEdit in '..\..\Forms\GoodsPropertyEdit.pas' {GoodsPropertyEditForm},
  GoodsProperty in '..\..\Forms\GoodsProperty.pas' {GoodsPropertyForm},
  CurrencyEdit in '..\..\Forms\CurrencyEdit.pas' {CurencyEditForm},
  GoodsGroupEdit in '..\..\Forms\GoodsGroupEdit.pas' {GoodsGroupEditForm},
  PriceListEdit in '..\..\Forms\PriceListEdit.pas' {PriceListEditForm},
  PriceList in '..\..\Forms\PriceList.pas' {PriceListForm},
  ParentForm in '..\..\SOURCE\ParentForm.pas' {ParentForm},
  dsdAction in '..\..\SOURCE\COMPONENT\dsdAction.pas',
  GoodsKind in '..\..\Forms\GoodsKind.pas' {GoodsKindForm},
  Bank in '..\..\Forms\Bank.pas' {CurrencyForm},
  GoodsGroup in '..\..\Forms\GoodsGroup.pas' {GoodsGroupForm},
  JuridicalGroup in '..\..\Forms\JuridicalGroup.pas' {JuridicalGroupForm},
  PartnerEdit in '..\..\Forms\PartnerEdit.pas' {PartnerEditForm},
  GoodsEdit in '..\..\Forms\GoodsEdit.pas' {GoodsEditForm},
  GoodsTree in '..\..\Forms\GoodsTree.pas' {GoodsTreeForm},
  UnitEdit in '..\..\Forms\UnitEdit.pas' {UnitEditForm},
  MeasureEdit in '..\..\Forms\MeasureEdit.pas' {MeasureEditForm},
  Status in '..\..\Forms\Status.pas' {StatusForm},
  Partner in '..\..\Forms\Partner.pas' {PartnerForm},
  CashEdit in '..\..\Forms\CashEdit.pas' {CashEditForm},
  Cash in '..\..\Forms\Cash.pas' {CashForm},
  Currency in '..\..\Forms\Currency.pas' {CurrencyForm},
  BankEdit in '..\..\Forms\BankEdit.pas' {BankEditForm},
  BranchEdit in '..\..\Forms\BranchEdit.pas' {BranchEditForm},
  Branch in '..\..\Forms\Branch.pas' {BranchForm},
  PriceListGoodsItem in '..\..\Forms\PriceListGoodsItem.pas' {PriceListGoodsItemForm},
  GoodsPropertyValue in '..\..\Forms\GoodsPropertyValue.pas' {GoodsPropertyValueForm},
  ContractKindEdit in '..\..\Forms\ContractKindEdit.pas' {ContractKindEditForm},
  ContractKind in '..\..\Forms\ContractKind.pas' {ContractKindForm},
  GoodsPropertyValueEdit in '..\..\Forms\GoodsPropertyValueEdit.pas' {GoodsPropertyValueEditForm},
  BankAccount in '..\..\Forms\BankAccount.pas' {BankAccountForm},
  BankAccountEdit in '..\..\Forms\BankAccountEdit.pas' {BankAccountEditForm},
  BusinessEdit in '..\..\Forms\BusinessEdit.pas' {BusinessEditForm},
  Business in '..\..\Forms\Business.pas' {BusinessForm},
  JuridicalEdit in '..\..\Forms\JuridicalEdit.pas' {JuridicalEditForm},
  Juridical in '..\..\Forms\Juridical.pas' {JuridicalForm},
  dsdDB in '..\..\SOURCE\COMPONENT\dsdDB.pas',
  UnitTree in '..\..\Forms\UnitTree.pas' {UnitTreeForm},
  dbMovementItemTest in '..\SOURCE\dbMovementItemTest.pas',
  Income in '..\..\Forms\Document\Income.pas' {IncomeForm},
  IncomeJournal in '..\..\Forms\Document\IncomeJournal.pas' {ParentForm2},
  dsdAddOn in '..\..\SOURCE\COMPONENT\dsdAddOn.pas',
  dbMovementCompleteTest in '..\SOURCE\dbMovementCompleteTest.pas',
  Report_Balance in '..\..\Forms\Report\Report_Balance.pas' {Report_BalanceForm},
  LoadReportTest in '..\SOURCE\LoadReportTest.pas',
  PriceListItemTest in '..\SOURCE\ObjectHistory\All\PriceListItemTest.pas',
  InfoMoneyGroup in '..\..\Forms\InfoMoneyGroup.pas' {InfoMoneyGroupForm},
  InfoMoneyGroupEdit in '..\..\Forms\InfoMoneyGroupEdit.pas' {InfoMoneyGroupEditForm},
  InfoMoneyDestination in '..\..\Forms\InfoMoneyDestination.pas' {InfoMoneyDestinationForm},
  InfoMoneyDestinationEdit in '..\..\Forms\InfoMoneyDestinationEdit.pas' {InfoMoneyDestinationEditForm},
  InfoMoney in '..\..\Forms\InfoMoney.pas' {InfoMoneyForm},
  InfoMoneyEdit in '..\..\Forms\InfoMoneyEdit.pas' {InfoMoneyEditForm},
  AccountGroup in '..\..\Forms\AccountGroup.pas' {AccountGroupForm},
  AccountGroupEdit in '..\..\Forms\AccountGroupEdit.pas' {AccountGroupEditForm},
  AccountDirection in '..\..\Forms\AccountDirection.pas' {AccountDirectionForm},
  AccountDirectionEdit in '..\..\Forms\AccountDirectionEdit.pas' {AccountDirectionEditForm},
  ProfitLossGroup in '..\..\Forms\ProfitLossGroup.pas' {ProfitLossGroupForm},
  ProfitLossGroupEdit in '..\..\Forms\ProfitLossGroupEdit.pas' {ProfitLossGroupEditForm},
  Account in '..\..\Forms\Account.pas' {AccountForm},
  AccountEdit in '..\..\Forms\AccountEdit.pas' {AccountEditForm},
  ProfitLoss in '..\..\Forms\ProfitLoss.pas' {ProfitLossForm},
  ProfitLossDirection in '..\..\Forms\ProfitLossDirection.pas' {ProfitLossDirectionForm},
  ProfitLossDirectionEdit in '..\..\Forms\ProfitLossDirectionEdit.pas' {ProfitLossDirectionEditForm},
  ProfitLossEdit in '..\..\Forms\ProfitLossEdit.pas' {ProfitLossEditForm},
  dbTest in '..\SOURCE\dbTest.pas',
  TradeMark in '..\..\Forms\TradeMark.pas' {TradeMarkForm},
  TradeMarkEdit in '..\..\Forms\TradeMarkEdit.pas' {TradeMarkEditForm},
  Asset in '..\..\Forms\Asset.pas' {AssetForm},
  Route in '..\..\Forms\Route.pas' {RouteForm},
  RouteEdit in '..\..\Forms\RouteEdit.pas' {RouteEditForm},
  RouteSorting in '..\..\Forms\RouteSorting.pas' {RouteSortingForm},
  RouteSortingEdit in '..\..\Forms\RouteSortingEdit.pas' {RouteSortingEditForm},
  Member in '..\..\Forms\Member.pas' {MemberForm},
  MemberEdit in '..\..\Forms\MemberEdit.pas' {MemberEditForm},
  CarModel in '..\..\Forms\CarModel.pas' {CarModelForm},
  CarModelEdit in '..\..\Forms\CarModelEdit.pas' {CarModelEditForm},
  Car in '..\..\Forms\Car.pas' {CarForm},
  CarEdit in '..\..\Forms\CarEdit.pas' {CarEditForm},
  Position in '..\..\Forms\Position.pas' {PositionForm},
  PositionEdit in '..\..\Forms\PositionEdit.pas' {PositionEditForm},
  AssetEdit in '..\..\Forms\AssetEdit.pas' {AssetEditForm},
  Personal in '..\..\Forms\Personal.pas' {PersonalForm},
  PersonalEdit in '..\..\Forms\PersonalEdit.pas' {PersonalEditForm},
  SendJournal in '..\..\Forms\Document\SendJournal.pas' {SendJournalForm},
  Send in '..\..\Forms\Document\Send.pas' {SendForm},
  SaleJournal in '..\..\Forms\Document\SaleJournal.pas' {SaleJournalForm},
  Sale in '..\..\Forms\Document\Sale.pas' {SaleForm},
  ReturnOutJournal in '..\..\Forms\Document\ReturnOutJournal.pas' {ReturnOutJournalForm},
  ReturnOut in '..\..\Forms\Document\ReturnOut.pas' {ReturnOutForm},
  JuridicalGroupEdit in '..\..\Forms\JuridicalGroupEdit.pas' {JuridicalGroupEditForm},
  JuridicalTest in '..\SOURCE\Objects\All\JuridicalTest.pas',
  SendOnPriceJournal in '..\..\Forms\Document\SendOnPriceJournal.pas' {SendOnPriceJournalForm},
  SendOnPrice in '..\..\Forms\Document\SendOnPrice.pas' {SendOnPriceForm},
  ReturnInJournal in '..\..\Forms\Document\ReturnInJournal.pas' {ReturnInJournalForm},
  ReturnIn in '..\..\Forms\Document\ReturnIn.pas' {ReturnInForm},
  LossJournal in '..\..\Forms\Document\LossJournal.pas' {LossJournalForm},
  Loss in '..\..\Forms\Document\Loss.pas' {LossForm},
  InventoryJournal in '..\..\Forms\Document\InventoryJournal.pas' {InventoryJournalForm},
  Inventory in '..\..\Forms\Document\Inventory.pas' {InventoryForm},
  ProductionSeparateJournal in '..\..\Forms\Document\ProductionSeparateJournal.pas' {ProductionSeparateJournalForm},
  ProductionUnionJournal in '..\..\Forms\Document\ProductionUnionJournal.pas' {ProductionUnionJournalForm},
  Report_ProfitLoss in '..\..\Forms\Report\Report_ProfitLoss.pas' {Report_ProfitLossForm},
  Report_HistoryCost in '..\..\Forms\Report\Report_HistoryCost.pas' {Report_HistoryCostForm},
  ProductionUnion in '..\..\Forms\Document\ProductionUnion.pas' {ProductionUnionForm},
  ProductionSeparate in '..\..\Forms\Document\ProductionSeparate.pas' {ProductionSeparateForm},
  Contract in '..\..\Forms\Contract.pas' {ContractForm},
  ContractEdit in '..\..\Forms\ContractEdit.pas' {ContractEditForm},
  Measure in '..\..\Forms\Measure.pas' {MeasureForm},
  PriceListItem in '..\..\Forms\PriceListItem.pas' {PriceListItemForm},
  ComponentActionTest in '..\SOURCE\Component\ComponentActionTest.pas',
  ComponentDBTest in '..\SOURCE\Component\ComponentDBTest.pas',
  CashOperationTest in '..\SOURCE\Movement\All\CashOperationTest.pas',
  ZakazExternalJournal in '..\..\Forms\Document\ZakazExternalJournal.pas' {ZakazExternalJournalForm},
  ZakazExternal in '..\..\Forms\Document\ZakazExternal.pas' {ZakazExternalForm},
  ZakazInternalJournal in '..\..\Forms\Document\ZakazInternalJournal.pas' {ZakazInternalJournalForm},
  ZakazInternal in '..\..\Forms\Document\ZakazInternal.pas' {ZakazInternalForm},
  CommonObjectCostProcedureTest in '..\SOURCE\ObjectCost\CommonObjectCostProcedureTest.pas',
  BankStatementTest in '..\SOURCE\Movement\All\BankStatementTest.pas',
  BankAccountMovementTest in '..\SOURCE\Movement\All\BankAccountMovementTest.pas',
  ServiceTest in '..\SOURCE\Movement\All\ServiceTest.pas',
  PersonalServiceTest in '..\SOURCE\Movement\All\PersonalServiceTest.pas',
  PersonalReportTest in '..\SOURCE\Movement\All\PersonalReportTest.pas',
  BankStatementItemTest in '..\SOURCE\Movement\All\BankStatementItemTest.pas',
  AccountTest in '..\SOURCE\Objects\All\AccountTest.pas',
  CashTest in '..\SOURCE\Objects\All\CashTest.pas',
  InfoMoneyTest in '..\SOURCE\Objects\All\InfoMoneyTest.pas',
  TransportTest in '..\SOURCE\Movement\All\TransportTest.pas',
  PersonalServiceEdit in '..\..\Forms\PersonalServiceEdit.pas' {PersonalServiceEditForm},
  PersonalService in '..\..\Forms\PersonalService.pas' {PersonalServiceForm},
  Service in '..\..\Forms\Service.pas' {ServiceForm},
  ServiceEdit in '..\..\Forms\ServiceEdit.pas' {ServiceEditForm},
  Goods in '..\..\Forms\Goods.pas' {GoodsForm},
  Units in '..\..\Forms\Units.pas' {UnitForm},
  JuridicalTree in '..\..\Forms\JuridicalTree.pas' {JuridicalTreeForm},
  BankAccountTest in '..\SOURCE\Objects\All\BankAccountTest.pas',
  BusinessTest in '..\SOURCE\Objects\All\BusinessTest.pas',
  CommonMovementItemReportProcedureTest in '..\SOURCE\MovementItemReport\CommonMovementItemReportProcedureTest.pas',
  TradeMarkTest in '..\SOURCE\Objects\All\TradeMarkTest.pas',
  ChoicePeriod in '..\..\SOURCE\COMPONENT\ChoicePeriod.pas' {PeriodChoiceForm},
  Report_MotionGoodsDialog in '..\..\Forms\Report\Report_MotionGoodsDialog.pas' {Report_MotionGoodsDialogForm},
  Report_MotionGoods in '..\..\Forms\Report\Report_MotionGoods.pas' {Report_MotionGoodsForm},
  ActionTest in '..\SOURCE\Objects\All\ActionTest.pas',
  MainForm in '..\..\SOURCE\MainForm.pas' {MainForm},
  Role in '..\..\Forms\Role.pas' {RoleForm},
  RoleEdit in '..\..\Forms\RoleEdit.pas' {RoleEditForm},
  Action in '..\..\Forms\Action.pas' {ActionForm},
  User in '..\..\Forms\User.pas' {UserForm},
  UserEdit in '..\..\Forms\UserEdit.pas' {UserEditForm},
  Process in '..\..\Forms\Process.pas' {ProcessForm},
  ComponentAddOnTest in '..\SOURCE\Component\ComponentAddOnTest.pas',
  DefaultsTest in '..\SOURCE\Defaults\DefaultsTest.pas',
  Transport in '..\..\Forms\Document\Transport.pas' {TransportForm},
  TransportJournal in '..\..\Forms\Document\TransportJournal.pas' {TransportJournalForm},
  FuelEdit in '..\..\Forms\FuelEdit.pas' {FuelEditForm},
  RateFuelKindEdit in '..\..\Forms\RateFuelKindEdit.pas' {RateFuelKindEditForm},
  RateFuelKind in '..\..\Forms\RateFuelKind.pas' {RateFuelKindForm},
  Fuel in '..\..\Forms\Fuel.pas' {FuelForm},
  RoleTest in '..\SOURCE\Objects\All\RoleTest.pas',
  Defaults in '..\..\SOURCE\COMPONENT\Defaults.pas',
  IncomeFuel in '..\..\Forms\Document\IncomeFuel.pas' {IncomeFuelForm},
  IncomeFuelJournal in '..\..\Forms\Document\IncomeFuelJournal.pas' {IncomeFuelJournalForm},
  Freight in '..\..\Forms\Freight.pas' {FreightForm},
  FreightEdit in '..\..\Forms\FreightEdit.pas' {FreightEditForm},
  RouteKind in '..\..\Forms\RouteKind.pas' {RouteKindForm},
  RouteKindEdit in '..\..\Forms\RouteKindEdit.pas' {RouteKindEditForm},
  RateFuel in '..\..\Forms\RateFuel.pas' {RateFuelForm},
  PersonalGroup in '..\..\Forms\PersonalGroup.pas' {PersonalGroupForm},
  PersonalGroupEdit in '..\..\Forms\PersonalGroupEdit.pas' {PersonalGroupEditForm},
  PersonalSendCash in '..\..\Forms\Document\PersonalSendCash.pas' {PersonalSendCashForm},
  PersonalSendCashJournal in '..\..\Forms\Document\PersonalSendCashJournal.pas' {PersonalSendCashJournalForm},
  PersonalSendCashTest in '..\SOURCE\Movement\All\PersonalSendCashTest.pas' {$R *.RES},
  WorkTimeKind in '..\..\Forms\WorkTimeKind.pas' {WorkTimeKindForm},
  SheetWorkTimeTest in '..\SOURCE\Movement\All\SheetWorkTimeTest.pas',
  Report_Fuel in '..\..\Forms\Report\Report_Fuel.pas' {Report_FuelForm},
  Report_Transport in '..\..\Forms\Report\Report_Transport.pas' {Report_TransportForm},
  CrossAddOnViewTestForm in '..\SOURCE\Component\CrossAddOnViewTestForm.pas' {CrossAddOnViewTest},
  Report_Account in '..\..\Forms\Report\Report_Account.pas' {Report_AccountForm},
  MessagesUnit in '..\..\SOURCE\MessagesUnit.pas' {MessagesForm},
  ObjectFrom_byIncomeFuel in '..\..\Forms\ObjectFrom_byIncomeFuel.pas' {From_byIncomeFuelForm},
  CardFuel in '..\..\Forms\CardFuel.pas' {CardFuelForm},
  TicketFuel in '..\..\Forms\TicketFuel.pas' {TicketFuelForm},
  TicketFuelEdit in '..\..\Forms\TicketFuelEdit.pas' {TicketFuelEditForm},
  CardFuelEdit in '..\..\Forms\CardFuelEdit.pas' {CardFuelEditForm},
  SheetWorkTime in '..\..\Forms\Document\SheetWorkTime.pas' {SheetWorkTimeForm},
  SheetWorkTimeJournal in '..\..\Forms\Document\SheetWorkTimeJournal.pas' {SheetWorkTimeJournalForm},
  PositionLevel in '..\..\Forms\PositionLevel.pas' {PositionLevelForm},
  PositionLevelEdit in '..\..\Forms\PositionLevelEdit.pas' {PositionLevelEditForm},
  StaffListData in '..\..\Forms\StaffListData.pas' {StaffListDataForm},
  StaffListEdit in '..\..\Forms\StaffListEdit.pas' {StaffListEditForm},
  PersonalTest in '..\SOURCE\Objects\All\PersonalTest.pas',
  SheetWorkTimeMovementItemTest in '..\SOURCE\MovementItem\All\SheetWorkTimeMovementItemTest.pas',
  ModelService in '..\..\Forms\ModelService.pas' {ModelServiceForm},
  ModelServiceKind in '..\..\Forms\ModelServiceKind.pas' {ModelServiceKindForm},
  SelectKind in '..\..\Forms\SelectKind.pas' {SelectKindForm},
  UpdaterTest in '..\SOURCE\Component\UpdaterTest.pas',
  AboutBoxUnit in '..\..\SOURCE\AboutBoxUnit.pas' {AboutBox},
  UnilWin in '..\..\SOURCE\UnilWin.pas',
  ModelServiceEdit in '..\..\Forms\ModelServiceEdit.pas' {ModelServiceEditForm: TParentForm},
  Object_StoragePlace in '..\..\Forms\Object_StoragePlace.pas' {Object_StoragePlace: TParentForm},
  Report_TransportHoursWork in '..\..\Forms\Report\Report_TransportHoursWork.pas' {Report_TransportHoursWorkForm: TParentForm},
  StaffListChoice in '..\..\Forms\StaffListChoice.pas' {StaffListChoiceForm: TParentForm},
  AncestorEnum in '..\..\Forms\Ancestor\AncestorEnum.pas' {AncestorEnumForm: TParentForm},
  StaffList in '..\..\Forms\StaffList.pas' {StaffListForm: TParentForm},
  StaffListSummKind in '..\..\Forms\StaffListSummKind.pas' {StaffListSummKindForm: TParentForm},
  PaidKind in '..\..\Forms\Kind\PaidKind.pas' {PaidKindForm: TParentForm},
  AncestorBase in '..\..\Forms\Ancestor\AncestorBase.pas' {AncestorBaseForm: TParentForm},
  AncestorDialog in '..\..\Forms\Ancestor\AncestorDialog.pas' {AncestorDialogForm: TParentForm},
  AncestorEditDialog in '..\..\Forms\Ancestor\AncestorEditDialog.pas' {AncestorEditDialogForm: TParentForm},
  AncestorData in '..\..\Forms\Ancestor\AncestorData.pas' {AncestorDataForm: TParentForm},
  AncestorReport in '..\..\Forms\Ancestor\AncestorReport.pas' {AncestorReportForm: TParentForm},
  Protocol in '..\..\Forms\System\Protocol.pas' {ProtocolForm: TParentForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TAncestorDataForm, AncestorDataForm);
  Application.CreateForm(TAncestorReportForm, AncestorReportForm);
  Application.CreateForm(TProtocolForm, ProtocolForm);
  Application.Run;
  DUnitTestRunner.RunRegisteredTests;
end.

