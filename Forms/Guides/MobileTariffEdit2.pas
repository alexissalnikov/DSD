unit MobileTariffEdit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, cxCurrencyEdit, cxCheckBox,
  Data.DB, Datasnap.DBClient, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, ParentForm, dsdGuides,
  dsdDB, dsdAction, cxButtonEdit, dsdAddOn, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCalendar, cxGroupBox, dxSkinsCore, dxSkinsDefaultPainters;

type
  TMobileTariffEdit2Form = class(TParentForm)
    edTariffName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    dsdFormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdFormClose: TdsdFormClose;
    lblCode: TcxLabel;
    ceCode: TcxCurrencyEdit;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    edComments: TcxTextEdit;
    cxLabel21: TcxLabel;
    cxGroupBox1: TcxGroupBox;
    ceMinuteCost: TcxCurrencyEdit;
    ceSMSCost: TcxCurrencyEdit;
    ceInetCost: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxGroupBox2: TcxGroupBox;
    cxLabel2: TcxLabel;
    ceMonthly: TcxCurrencyEdit;
    cxLabel15: TcxLabel;
    cePocketMinutes: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    cePocketSMS: TcxCurrencyEdit;
    cxLabel17: TcxLabel;
    cePocketInet: TcxCurrencyEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

initialization
  RegisterClass(TMobileTariffEdit2Form);
end.
