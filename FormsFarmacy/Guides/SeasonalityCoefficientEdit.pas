unit SeasonalityCoefficientEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxPropertiesStore,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxLabel, cxTextEdit, Vcl.ActnList,
  Vcl.StdActns, ParentForm, dsdDB, dsdAction, cxCurrencyEdit, dsdAddOn,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox, cxMaskEdit, Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit,
  cxCalendar;

type
  TSeasonalityCoefficientEditForm = class(TParentForm)
    edName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    ActionList: TActionList;
    spInsertUpdate: TdsdStoredProc;
    FormParams: TdsdFormParams;
    spGet: TdsdStoredProc;
    dsdDataSetRefresh: TdsdDataSetRefresh;
    dsdInsertUpdateGuides: TdsdInsertUpdateGuides;
    dsdFormClose: TdsdFormClose;
    cxLabel2: TcxLabel;
    edCode: TcxCurrencyEdit;
    cxPropertiesStore: TcxPropertiesStore;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    ceKoeff1: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    ceKoeff2: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ceKoeff3: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    ceKoeff4: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    ceKoeff5: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceKoeff6: TcxCurrencyEdit;
    cxLabel8: TcxLabel;
    ceKoeff7: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    ceKoeff8: TcxCurrencyEdit;
    cxLabel10: TcxLabel;
    ceKoeff9: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ceKoeff10: TcxCurrencyEdit;
    cxLabel12: TcxLabel;
    ceKoeff11: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceKoeff12: TcxCurrencyEdit;
    cxLabel14: TcxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSeasonalityCoefficientEditForm);

end.
