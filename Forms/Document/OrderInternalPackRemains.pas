unit OrderInternalPackRemains;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxSplitter,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TOrderInternalPackRemainsForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesFrom: TdsdGuides;
    GuidesTo: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    bbPrintTax: TdxBarButton;
    PrintItemsCDS: TClientDataSet;
    bbTax: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrintRemains: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    AmountSecond: TcxGridDBColumn;
    spUpdateAmountRemains: TdsdStoredProc;
    spUpdateAmountPartner: TdsdStoredProc;
    spUpdateAmountForecast: TdsdStoredProc;
    actUpdateAmountRemains: TdsdExecStoredProc;
    MultiAmountRemain: TMultiAction;
    edOperDatePartner: TcxDateEdit;
    cxLabel10: TcxLabel;
    cxLabel18: TcxLabel;
    edDayCount: TcxCurrencyEdit;
    edOperDateStart: TcxDateEdit;
    cxLabel19: TcxLabel;
    cxLabel20: TcxLabel;
    edOperDateEnd: TcxDateEdit;
    Remains: TcxGridDBColumn;
    AmountPartner: TcxGridDBColumn;
    AmountForecast: TcxGridDBColumn;
    AmountForecastOrder: TcxGridDBColumn;
    bbMultiAmountRemain: TdxBarButton;
    actUpdateAmountPartner: TdsdExecStoredProc;
    MultiAmountPartner: TMultiAction;
    actUpdateAmountForecast: TdsdExecStoredProc;
    MultiAmountForecast: TMultiAction;
    actUpdateAmountAll: TMultiAction;
    bbMultiAmountPartner: TdxBarButton;
    bbMultiAmountForecast: TdxBarButton;
    bbUpdateAmountAll: TdxBarButton;
    MeasureName: TcxGridDBColumn;
    ReceiptCode: TcxGridDBColumn;
    ReceiptName: TcxGridDBColumn;
    GoodsGroupNameFull: TcxGridDBColumn;
    CountForecast: TcxGridDBColumn;
    CountForecastOrder: TcxGridDBColumn;
    AmountPartnerPrior: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    DayCountForecast: TcxGridDBColumn;
    DayCountForecastOrder: TcxGridDBColumn;
    GoodsCode_basis: TcxGridDBColumn;
    GoodsName_basis: TcxGridDBColumn;
    MeasureName_basis: TcxGridDBColumn;
    isCheck_basis: TcxGridDBColumn;
    ReceiptCode_basis: TcxGridDBColumn;
    ReceiptName_basis: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    cxGridChild: TcxGrid;
    cxGridDBTableViewChild: TcxGridDBTableView;
    �hGoodsCode: TcxGridDBColumn;
    �hGoodsName: TcxGridDBColumn;
    �hMeasureName: TcxGridDBColumn;
    �hIsErased: TcxGridDBColumn;
    cxGridLevelChild: TcxGridLevel;
    ChildDBViewAddOn: TdsdDBViewAddOn;
    cxBottomSplitter: TcxSplitter;
    �hGoodsKindName: TcxGridDBColumn;
    �hContainerId: TcxGridDBColumn;
    cxLabel16: TcxLabel;
    ceComment: TcxTextEdit;
    tsTotal: TcxTabSheet;
    cxGridChildTotal: TcxGrid;
    cxGridDBTableViewChildTotal: TcxGridDBTableView;
    cxGridLevelChildTotal: TcxGridLevel;
    ChildTotalCDS: TClientDataSet;
    ChildTotalDS: TDataSource;
    ChildTotalDBViewAddOn: TdsdDBViewAddOn;
    chtContainerId: TcxGridDBColumn;
    chtGoodsKindName_pf: TcxGridDBColumn;
    chtGoodsKindCompleteName_pf: TcxGridDBColumn;
    chtPartionDate_pf: TcxGridDBColumn;
    chtRemains_CEH: TcxGridDBColumn;
    chtRemains_CEH_Next: TcxGridDBColumn;
    chtRemains_pack: TcxGridDBColumn;
    chtPartionGoods_start: TcxGridDBColumn;
    chtTermProduction: TcxGridDBColumn;
    Remains_CEH: TcxGridDBColumn;
    Remains_CEH_Next: TcxGridDBColumn;
    Income_CEH: TcxGridDBColumn;
    chtIncome_CEH: TcxGridDBColumn;
    spUpdateMIMasterChildTotal: TdsdStoredProc;
    actUpdateChildTotalDS: TdsdUpdateDataSet;
    mactUpdateAmount_to: TMultiAction;
    mactUpdateAmountGrid_to: TMultiAction;
    actUpdateAmount_to: TdsdExecStoredProc;
    spUpdateAmount_to: TdsdStoredProc;
    actUpdateAmountAll_to: TdsdExecStoredProc;
    spUpdateAmountAll_to: TdsdStoredProc;
    mactUpdateAmountSecond_to: TMultiAction;
    mactUpdateAmountSecondGrid_to: TMultiAction;
    actUpdateAmountSecond_to: TdsdExecStoredProc;
    actUpdateAmountSecondAll_to: TdsdExecStoredProc;
    spUpdateAmountSecond_to: TdsdStoredProc;
    spUpdateAmountSecondAll_to: TdsdStoredProc;
    bbUpdateAmount_to: TdxBarButton;
    bbUpdateAmountSecond_to: TdxBarButton;
    AmountTotal: TcxGridDBColumn;
    chtAmountTotal: TcxGridDBColumn;
    Amount_result: TcxGridDBColumn;
    Amount_result_two: TcxGridDBColumn;
    chAmountPackTotal: TcxGridDBColumn;
    AmountPartnerPriorTotal: TcxGridDBColumn;
    AmountPartnerTotal: TcxGridDBColumn;
    chRemains: TcxGridDBColumn;
    Remains_pack: TcxGridDBColumn;
    Income_PACK_from: TcxGridDBColumn;
    chtId: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    chId: TcxGridDBColumn;
    Num: TcxGridDBColumn;
    chAmountPack_calc: TcxGridDBColumn;
    chAmountSecondPack_calc: TcxGridDBColumn;
    chAmountPackTotal_calc: TcxGridDBColumn;
    mactUpdateAmountSecondCEH_to: TMultiAction;
    mactUpdateAmountSecondCEHGrid_to: TMultiAction;
    actUpdateAmountSecondCEH_to: TdsdExecStoredProc;
    spUpdateAmountSecondCEH_to: TdsdStoredProc;
    bbtUpdateAmountSecondCEH_to: TdxBarButton;
    chtRemains_CEH_err: TcxGridDBColumn;
    chtRemains_err: TcxGridDBColumn;
    chDayCountForecast_calc: TcxGridDBColumn;
    chtDayCountForecast_calc: TcxGridDBColumn;
    chtIncome_PACK_to: TcxGridDBColumn;
    Income_PACK_to: TcxGridDBColumn;
    spUpdateAmountSecond_toPACK: TdsdStoredProc;
    spUpdateAmount_toPACK: TdsdStoredProc;
    actUpdateAmount_toPACK: TdsdExecStoredProc;
    actUpdateAmountSecond_toPACK: TdsdExecStoredProc;
    bbUpdateAmount_toPACK: TdxBarButton;
    bbUpdateAmountSecond_toPACK: TdxBarButton;
    actGridTotalToExcel: TdsdGridToExcel;
    bbGridTotalToExcel: TdxBarButton;
    spSelectPrintRemains: TdsdStoredProc;
    actPrintRemains: TdsdPrintAction;
    Amount_result_pack: TcxGridDBColumn;
    AmountPartnerNextPromo: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TOrderInternalPackRemainsForm);

end.