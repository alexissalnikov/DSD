unit Unit_Object;

interface

uses
  Winapi.Windows, AncestorEnum, DataModul, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox, dsdAddOn, dsdDB,
  Datasnap.DBClient, dsdAction, System.Classes, Vcl.ActnList, dxBarExtItems,
  dxBar, cxClasses, cxPropertiesStore, cxGridLevel, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGridCustomView, Vcl.Controls, cxGrid,
  cxPCdxBarPopupMenu, Vcl.Menus, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCurrencyEdit, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxButtonEdit, cxCalendar;

type
  TUnit_ObjectForm = class(TAncestorEnumForm)
    JuridicalName: TcxGridDBColumn;
    ParentName: TcxGridDBColumn;
    Id: TcxGridDBColumn;
    actProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    spUpdate_Unit_isOver: TdsdStoredProc;
    isOver: TcxGridDBColumn;
    actUpdateisOver: TdsdExecStoredProc;
    bbUpdateisOver: TdxBarButton;
    spUpdateisOverYes: TdsdExecStoredProc;
    macUpdateisOverYes: TMultiAction;
    bbUpdateisOverList: TdxBarButton;
    spUpdate_Unit_isOver_Yes: TdsdStoredProc;
    spUpdate_Unit_isOver_No: TdsdStoredProc;
    spUpdateisOverNo: TdsdExecStoredProc;
    macUpdateisOverNo: TMultiAction;
    bbUpdateisOverNoList: TdxBarButton;
    isUploadBadm: TcxGridDBColumn;
    spUpdate_Unit_isUploadBadm: TdsdStoredProc;
    actUpdateisUploadBadm: TdsdExecStoredProc;
    bbUpdateisUploadBadm: TdxBarButton;
    isMarginCategory: TcxGridDBColumn;
    spUpdate_Unit_isMarginCategory: TdsdStoredProc;
    actUpdateisMarginCategory: TdsdExecStoredProc;
    bbisMarginCategory: TdxBarButton;
    spUpdate_Unit_isReport: TdsdStoredProc;
    actUpdateisReport: TdsdExecStoredProc;
    bbUpdateisReport: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    Address: TcxGridDBColumn;
    CreateDate: TcxGridDBColumn;
    CloseDate: TcxGridDBColumn;
    UserManagerName: TcxGridDBColumn;
    actOpenUserForm: TOpenChoiceForm;
    spUpdate_Unit_Params: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    AreaName: TcxGridDBColumn;
    actOpenAreaForm: TOpenChoiceForm;
    Phone: TcxGridDBColumn;
    actChoiceUnit: TOpenChoiceForm;
    UnitRePriceName: TcxGridDBColumn;
    PartnerMedicalName: TcxGridDBColumn;
    isGoodsCategory: TcxGridDBColumn;
    spUpdate_GoodsCategory_Yes: TdsdStoredProc;
    spUpdate_GoodsCategory_No: TdsdStoredProc;
    macUpdateisGoodsCategoryNo: TMultiAction;
    macUpdateisGoodsCategoryYes: TMultiAction;
    actUpdateGoodsCategory_No: TdsdExecStoredProc;
    actUpdateGoodsCategory_Yes: TdsdExecStoredProc;
    bbUpdateisGoodsCategoryYes: TdxBarButton;
    bbUpdateisGoodsCategoryNo: TdxBarButton;
    dsdSetErased: TdsdUpdateErased;
    dsdSetUnErased: TdsdUpdateErased;
    spErasedUnErased: TdsdStoredProc;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actOpenUser2Form: TOpenChoiceForm;
    actOpenUser3Form: TOpenChoiceForm;
    spUpdate_Unit_isSUN: TdsdStoredProc;
    actUpdate_Unit_isSUN: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN: TdxBarButton;
    isSUN: TcxGridDBColumn;
    spUpdate_Unit_isTopNo: TdsdStoredProc;
    actUpdateisTopNo: TdsdExecStoredProc;
    bbUpdateisTopNo: TdxBarButton;
    ExecuteDialogKoeffSUN: TExecuteDialog;
    actUpdateKoeffSUN: TdsdDataSetRefresh;
    spUpdate_KoeffSUN: TdsdStoredProc;
    macUpdateKoeffSUN: TMultiAction;
    bbUpdateKoeffSUN: TdxBarButton;
    spUpdate_Unit_isSUN_v2: TdsdStoredProc;
    spUpdate_Unit_isSUN_in: TdsdStoredProc;
    spUpdate_Unit_isSUN_out: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_in: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_out: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_in: TdxBarButton;
    bbUpdate_Unit_isSUN_out: TdxBarButton;
    bbUpdate_Unit_isSUN_v2: TdxBarButton;
    ListDaySUN: TcxGridDBColumn;
    isNotCashMCS: TcxGridDBColumn;
    isNotCashListDiff: TcxGridDBColumn;
    spUpdate_Unit_isSUN_NotSold: TdsdStoredProc;
    actUpdate_Unit_isSUN_NotSold: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_NotSold: TdxBarButton;
    spUpdate_Unit_isSUN_v2_in: TdsdStoredProc;
    spUpdate_Unit_isSUN_v2_out: TdsdStoredProc;
    actUpdate_Unit_isSUN_v2_out: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v2_in: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v2_in: TdxBarButton;
    bbUpdate_Unit_isSUN_v2_out: TdxBarButton;
    TimeWork: TcxGridDBColumn;
    isTechnicalRediscount: TcxGridDBColumn;
    spUpdate_Unit_TechnicalRediscount: TdsdStoredProc;
    actUpdate_Unit_TechnicalRediscount: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    spUpdate_Unit_isSUN_v3: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v3: TdxBarButton;
    macUpdateKoeffSUNv3: TMultiAction;
    ExecuteDialogKoeffSUNv3: TExecuteDialog;
    actUpdateKoeffSUNv3: TdsdDataSetRefresh;
    spUpdate_KoeffSUNv3: TdsdStoredProc;
    bbUpdateKoeffSUNv3: TdxBarButton;
    spUpdate_Unit_isSUN_v3_in: TdsdStoredProc;
    spUpdate_Unit_isSUN_v3_out: TdsdStoredProc;
    actUpdate_Unit_isSUN_v3_out: TdsdExecStoredProc;
    actUpdate_Unit_isSUN_v3_in: TdsdExecStoredProc;
    bbUpdate_Unit_isSUN_v3_in: TdxBarButton;
    bbUpdate_Unit_isSUN_v3_out: TdxBarButton;
    actUpdate_ListDaySUN: TMultiAction;
    actExecUpdate_ListDaySUN: TdsdExecStoredProc;
    actEDListDaySUN: TExecuteDialog;
    FormParams: TdsdFormParams;
    dxBarButton4: TdxBarButton;
    spUpdate_ListDaySUN: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
 initialization
  RegisterClass(TUnit_ObjectForm);
end.
