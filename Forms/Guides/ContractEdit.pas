unit ContractEdit;

interface

uses
  DataModul, AncestorEditDialog, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer, cxEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, Data.DB, cxDBData, cxButtonEdit, dxBar, Datasnap.DBClient,
  dsdGuides, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxGridCustomView, cxGrid, Vcl.ExtCtrls,
  cxCurrencyEdit, cxDropDownEdit, cxCalendar, cxMaskEdit, cxLabel, Vcl.Controls,
  cxTextEdit, dsdDB, dsdAction, System.Classes, Vcl.ActnList, cxPropertiesStore,
  dsdAddOn, Vcl.StdCtrls, cxButtons, cxInplaceContainer, cxVGrid, cxDBVGrid,
  Document, dxBarExtItems, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox, cxImageComboBox,
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
  TContractEditForm = class(TAncestorEditDialogForm)
    edInvNumber: TcxTextEdit;
    LbInvNumber: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel5: TcxLabel;
    edContractKind: TcxButtonEdit;
    edJuridical: TcxButtonEdit;
    edSigningDate: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    edStartDate: TcxDateEdit;
    edEndDate: TcxDateEdit;
    cxLabel6: TcxLabel;
    cxLabel9: TcxLabel;
    edInfoMoney: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    InfoMoneyGuides: TdsdGuides;
    ContractKindGuides: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    cxLabel10: TcxLabel;
    cxLabel11: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    edInvNumberArchive: TcxTextEdit;
    cxLabel7: TcxLabel;
    edPersonal: TcxButtonEdit;
    PersonalGuides: TdsdGuides;
    cxLabel8: TcxLabel;
    edAreaContract: TcxButtonEdit;
    AreaContractGuides: TdsdGuides;
    cxLabel13: TcxLabel;
    edContractArticle: TcxButtonEdit;
    ContractArticleGuides: TdsdGuides;
    cxLabel14: TcxLabel;
    edContractStateKind: TcxButtonEdit;
    ContractStateKindGuides: TdsdGuides;
    PaidKindGuides: TdsdGuides;
    ContractConditionDS: TDataSource;
    ContractConditionCDS: TClientDataSet;
    spInsertUpdateContractCondition: TdsdStoredProc;
    spSelectContractCondition: TdsdStoredProc;
    Panel: TPanel;
    cxGridContractCondition: TcxGrid;
    cxGridDBTableViewContractCondition: TcxGridDBTableView;
    ContractConditionKindName: TcxGridDBColumn;
    Value: TcxGridDBColumn;
    isErased: TcxGridDBColumn;
    cxGridContractConditionLevel: TcxGridLevel;
    dxBarDockControl1: TdxBarDockControl;
    BarManager: TdxBarManager;
    BarManagerBar1: TdxBar;
    BarManagerBar2: TdxBar;
    dxBarDockControl2: TdxBarDockControl;
    cxDBVerticalGrid: TcxDBVerticalGrid;
    spDocumentSelect: TdsdStoredProc;
    DocumentDS: TDataSource;
    DocumentCDS: TClientDataSet;
    Document: TDocument;
    spInsertDocument: TdsdStoredProc;
    spGetDocument: TdsdStoredProc;
    colFileName: TcxDBEditorRow;
    actInsertDocument: TdsdExecStoredProc;
    bbAddDocument: TdxBarButton;
    DocumentRefresh: TdsdDataSetRefresh;
    bbRefreshDoc: TdxBarButton;
    bbStatic: TdxBarStatic;
    DocumentOpenAction: TDocumentOpenAction;
    bbOpenDocument: TdxBarButton;
    bbInsertCondition: TdxBarButton;
    MultiActionInsertDocument: TMultiAction;
    MultiActionInsertContractCondition: TMultiAction;
    bbConditionRefresh: TdxBarButton;
    spInserUpdateContract: TdsdExecStoredProc;
    cxLabel15: TcxLabel;
    edMainJuridical: TcxButtonEdit;
    MainJuridicalGuides: TdsdGuides;
    actSetErasedContractCondition: TdsdUpdateErased;
    bbSetErasedContractCondition: TdxBarButton;
    spErasedUnErasedCondition: TdsdStoredProc;
    actSetUnErasedContractCondition: TdsdUpdateErased;
    bbSetUnerasedCondition: TdxBarButton;
    DBViewAddOnCondition: TdsdDBViewAddOn;
    actDeleteDocument: TdsdExecStoredProc;
    spDeleteDocument: TdsdStoredProc;
    bbDeleteDocument: TdxBarButton;
    spGetStateKindUnSigned: TdsdStoredProc;
    spGetStateKindSigned: TdsdStoredProc;
    spGetStateKindClose: TdsdStoredProc;
    actGetStateKindUnSigned: TdsdExecStoredProc;
    actGetStateKindSigned: TdsdExecStoredProc;
    actGetStateKindClose: TdsdExecStoredProc;
    spGetStateKind_Partner: TdsdStoredProc;
    actGetStateKindPartner: TdsdExecStoredProc;
    BonusKindName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    BonusKindChoiceForm: TOpenChoiceForm;
    cxLabel16: TcxLabel;
    edBankId: TcxButtonEdit;
    BankGuides: TdsdGuides;
    edBankAccountExternal: TcxTextEdit;
    cxLabel17: TcxLabel;
    InfoMoneyName: TcxGridDBColumn;
    InfoMoneyChoiceForm: TOpenChoiceForm;
    cbisDefault: TcxCheckBox;
    ceisStandart: TcxCheckBox;
    cxLabel18: TcxLabel;
    cxLabel19: TcxLabel;
    edPersonalTrade: TcxButtonEdit;
    PersonalTradeGuides: TdsdGuides;
    edPersonalCollation: TcxButtonEdit;
    PersonalCollationGuides: TdsdGuides;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    edContractTag: TcxButtonEdit;
    ceBankAccount: TcxButtonEdit;
    BankAccountGuides: TdsdGuides;
    ContractTagGuides: TdsdGuides;
    ceisPersonal: TcxCheckBox;
    ceIsUnique: TcxCheckBox;
    cxLabel22: TcxLabel;
    edGLNCode: TcxTextEdit;
    cxLabel23: TcxLabel;
    edJuridicalDocument: TcxButtonEdit;
    JuridicalDocumentGuides: TdsdGuides;
    cxLabel24: TcxLabel;
    cePriceList: TcxButtonEdit;
    dsdPriceListGuides: TdsdGuides;
    cxLabel25: TcxLabel;
    cePriceListPromo: TcxButtonEdit;
    cxLabel26: TcxLabel;
    edStartPromo: TcxDateEdit;
    cxLabel27: TcxLabel;
    edEndPromo: TcxDateEdit;
    dsdPriceListPromoGuides: TdsdGuides;
    cxLabel28: TcxLabel;
    ceGoodsProperty: TcxButtonEdit;
    GoodsPropertyGuides: TdsdGuides;
    edTerm: TcxCurrencyEdit;
    cxLabel29: TcxLabel;
    cxLabel30: TcxLabel;
    edContractTermKind: TcxButtonEdit;
    ContractTermKindGuides: TdsdGuides;
    cxLabel31: TcxLabel;
    edPersonalSigning: TcxButtonEdit;
    PersonalSigningGuides: TdsdGuides;
    ContractSendName: TcxGridDBColumn;
    actContractSendChoiceForm: TOpenChoiceForm;
    cxLabel32: TcxLabel;
    ceCurrency: TcxButtonEdit;
    CurrencyGuides: TdsdGuides;
    edDayTaxSummary: TcxCurrencyEdit;
    cxLabel33: TcxLabel;
    cxLabel34: TcxLabel;
    edJuridicalInvoice: TcxButtonEdit;
    JuridicalInvoiceGuides: TdsdGuides;
    cxLabel35: TcxLabel;
    edPartnerCode: TcxTextEdit;
    cbisDefaultOut: TcxCheckBox;
    cxLabel36: TcxLabel;
    edBankAccountPartner: TcxTextEdit;
    colStartDate: TcxGridDBColumn;
    colEndDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TContractEditForm);

end.
