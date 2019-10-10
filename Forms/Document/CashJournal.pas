unit CashJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxCheckBox, cxImageComboBox, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit, dsdGuides,
  cxButtonEdit;

type
  TCashJournalForm = class(TAncestorJournalForm)
    AmountOut: TcxGridDBColumn;
    InfoMoneyCode: TcxGridDBColumn;
    InfoMoneyGroupName: TcxGridDBColumn;
    InfoMoneyDestinationName: TcxGridDBColumn;
    Comment: TcxGridDBColumn;
    ContractInvNumber: TcxGridDBColumn;
    MoneyPlaceCode: TcxGridDBColumn;
    ceCash: TcxButtonEdit;
    cxLabel3: TcxLabel;
    GuidesCash: TdsdGuides;
    InfoMoneyName_all: TcxGridDBColumn;
    MemberName: TcxGridDBColumn;
    PositionName: TcxGridDBColumn;
    ItemName: TcxGridDBColumn;
    OKPO: TcxGridDBColumn;
    AmountCurrency: TcxGridDBColumn;
    AmountSumm: TcxGridDBColumn;
    CurrencyName: TcxGridDBColumn;
    CurrencyPartnerValue: TcxGridDBColumn;
    ParPartnerValue: TcxGridDBColumn;
    CurrencyValue: TcxGridDBColumn;
    ParValue: TcxGridDBColumn;
    isLoad: TcxGridDBColumn;
    actReport_Cash: TdsdOpenForm;
    bbReport_Cash: TdxBarButton;
    UnitCode: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    PersonalServiceListCode: TcxGridDBColumn;
    PartionMovementName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    cxLabel15: TcxLabel;
    ceCurrency: TcxButtonEdit;
    GuidesCurrency: TdsdGuides;
    actUpdateDataSet: TdsdUpdateDataSet;
    actInvoiceJournalDetailChoiceForm: TOpenChoiceForm;
    spUpdate_Invoice: TdsdStoredProc;
    cxLabel27: TcxLabel;
    edJuridicalBasis: TcxButtonEdit;
    GuidesJuridicalBasis: TdsdGuides;
    spGet_UserJuridicalBasis: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName_Mobile: TcxGridDBColumn;
    PositionName_Mobile: TcxGridDBColumn;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    actPrint_byElements: TdsdPrintAction;
    actPrint_byElements_byComments: TdsdPrintAction;
    bbPrint_byElements: TdxBarButton;
    bbPrint_byElements_byComments: TdxBarButton;
    actPrint_byComments: TdsdPrintAction;
    bbPrint_byComments: TdxBarButton;
    actPrint_byService: TdsdPrintAction;
    bbPrint_byService: TdxBarButton;
    CurrencyValue_calc: TcxGridDBColumn;
    CurrencyValue_mi_calc: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCashJournalForm);

end.
