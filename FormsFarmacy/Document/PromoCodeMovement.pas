unit PromoCodeMovement;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, ExternalLoad, cxCheckBox,
  dsdExportToXLSAction;

type
  TPromoCodeMovementForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edPromoCode: TcxButtonEdit;
    GuidesPromoCode: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    IsChecked: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    spSelectPrint: TdsdStoredProc;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    JuridicalName: TcxGridDBColumn;
    chComment: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    spSelect_MovementItem_PromoCodeChild: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    IsErased: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    edStartPromo: TcxDateEdit;
    cxLabel3: TcxLabel;
    edEndPromo: TcxDateEdit;
    cxLabel6: TcxLabel;
    spErasedMIChild: TdsdStoredProc;
    spUnErasedMIChild: TdsdStoredProc;
    actMISetErasedChild: TdsdUpdateErased;
    actMISetUnErasedChild: TdsdUpdateErased;
    bbMISetErasedChild: TdxBarButton;
    bbMISetUnErasedChild: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    JuridicalChoiceForm: TOpenChoiceForm;
    actDoLoad: TExecuteImportSettingsAction;
    actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc;
    actGetImportSettingId: TdsdExecStoredProc;
    actStartLoad: TMultiAction;
    spInsertUpdate_MovementItem_Promo_Set_Zero: TdsdStoredProc;
    spGetImportSettingId: TdsdStoredProc;
    bbactStartLoad: TdxBarButton;
    cxLabel9: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    InsertRecordChild: TInsertRecord;
    bbInsertRecordChild: TdxBarButton;
    actOpenReportForm: TdsdOpenForm;
    bbOpenReportForm: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    clBayerName: TcxGridDBColumn;
    clIsErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    SignDCS: TClientDataSet;
    SignDS: TDataSource;
    dsdDBViewAddOn2: TdsdDBViewAddOn;
    spSelectPromoCodeSign: TdsdStoredProc;
    clComment: TcxGridDBColumn;
    InsertRecordSign: TInsertRecord;
    bbInsertRecordPartner: TdxBarButton;
    spInsertUpdatePromoCodeSign: TdsdStoredProc;
    dsdUpdateSignDS: TdsdUpdateDataSet;
    spUpErasedMISign: TdsdStoredProc;
    actSetErasedPromoCodeSign: TdsdUpdateErased;
    actSetUnErasedPromoCodeSign: TdsdUpdateErased;
    bbSetErasedPromoPartner: TdxBarButton;
    bbSetUnErasedPromoPartner: TdxBarButton;
    actInsertPromoCodeSign: TdsdExecStoredProc;
    macInsertPromoCodeSign: TMultiAction;
    actRefreshPromoCodeSign: TdsdDataSetRefresh;
    bbInsertPromoCodeSign: TdxBarButton;
    actOpenReportMinPriceForm: TdsdOpenForm;
    bbReportMinPriceForm: TdxBarButton;
    actOpenReporCheck: TdsdOpenForm;
    bbOpenReportMinPrice_All: TdxBarButton;
    cbisElectron: TcxCheckBox;
    cbisOne: TcxCheckBox;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    GuidesUpdate: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    DescName: TcxGridDBColumn;
    spErasedMISign: TdsdStoredProc;
    BayerPhone: TcxGridDBColumn;
    BayerEmail: TcxGridDBColumn;
    InsertName: TcxGridDBColumn;
    UpdateName: TcxGridDBColumn;
    cxSplitter2: TcxSplitter;
    GUID: TcxGridDBColumn;
    spInsertPromoCodeSign: TdsdStoredProc;
    ExecuteDialogPromoCodeSign: TExecuteDialog;
    spInsertUpdateMIGoods_isChecked_Yes: TdsdStoredProc;
    spInsertUpdateMIGoods_isChecked_No: TdsdStoredProc;
    spUpdateGoodsIsCheckedNo: TdsdExecStoredProc;
    macUpdateGoodsIsCheckedNo: TMultiAction;
    spUpdateGoodsIsCheckedYes: TdsdExecStoredProc;
    macUpdateGoodsIsCheckedYes: TMultiAction;
    bbGoodsIsCheckedYes: TdxBarButton;
    bbGoodsIsCheckedNo: TdxBarButton;
    actRefreshPromoCodeGoods: TdsdDataSetRefresh;
    macUpdateGoodsIsCheckedYes_S: TMultiAction;
    macUpdateGoodsIsCheckedNo_S: TMultiAction;
    spUpdateMIChild_Cheked_Yes: TdsdStoredProc;
    spUpdateMIChild_Cheked_No: TdsdStoredProc;
    spUpdatePromoCodeSign_Checked_Yes: TdsdStoredProc;
    spUpdatePromoCodeSign_Checked_No: TdsdStoredProc;
    spUpdateSignIsCheckedNo: TdsdExecStoredProc;
    spUpdateSignIsCheckedYes: TdsdExecStoredProc;
    macUpdateSignIsCheckedYes_S: TMultiAction;
    macUpdateSignIsCheckedNo_S: TMultiAction;
    macUpdateSignIsCheckedYes: TMultiAction;
    macUpdateSignIsCheckedNo: TMultiAction;
    actRefreshPromoCodeChild: TdsdDataSetRefresh;
    spUpdateChildIsCheckedNo: TdsdExecStoredProc;
    spUpdateChildIsCheckedYes: TdsdExecStoredProc;
    macUpdateChildIsCheckedYes_S: TMultiAction;
    macUpdateChildIsCheckedNo_S: TMultiAction;
    macUpdateChildIsCheckedYes: TMultiAction;
    macUpdateChildIsCheckedNo: TMultiAction;
    bbChildIsCheckedNo: TdxBarButton;
    bbChildIsCheckedYes: TdxBarButton;
    bbSignIsCheckedNo: TdxBarButton;
    bbSignIsCheckedYes: TdxBarButton;
    Count_Check: TcxGridDBColumn;
    Invnumber_Check: TcxGridDBColumn;
    OperDate_Check: TcxGridDBColumn;
    UnitName_Check: TcxGridDBColumn;
    JuridicalName_Check: TcxGridDBColumn;
    RetailName_Check: TcxGridDBColumn;
    cbisBuySite: TcxCheckBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    cxSplitter3: TcxSplitter;
    cxGrid3: TcxGrid;
    cxGridDBTableView3: TcxGridDBTableView;
    InfoName: TcxGridDBColumn;
    InfoValue: TcxGridDBColumn;
    cxGridLevel3: TcxGridLevel;
    InfoDS: TDataSource;
    InfoDSD: TClientDataSet;
    spSelectPromoCodeInfo: TdsdStoredProc;
    GoodsisErased: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    actInsertPromoCodepercentSign: TMultiAction;
    dxBarButton1: TdxBarButton;
    ExecutePromoCodeSignPercentDialog: TExecuteDialog;
    spInsertPromoCodePercentSign: TdsdStoredProc;
    ExecSPPromoCodeSignPercent: TdsdExecStoredProc;
    spSelectPrintSticker: TdsdStoredProc;
    actPrintSticker: TdsdExportToXLS;
    ExecSPPrintSticker: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    ExecutePromoCodeSignUnitName: TExecuteDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPromoCodeMovementForm);

end.
