unit Report_GoodsMI_OrderExternal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn, ChoicePeriod,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  dsdGuides, cxButtonEdit, cxCurrencyEdit, Vcl.Menus, cxCheckBox;

type
  TReport_GoodsMI_OrderExternalForm = class(TAncestorReportForm)
    clTradeMarkName: TcxGridDBColumn;
    clGoodsGroupName: TcxGridDBColumn;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clSale_Summ: TcxGridDBColumn;
    clSale_Amount_Weight: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    edGoodsGroup: TcxButtonEdit;
    GoodsGroupGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    clSale_Amount_Sh: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clPartnerName: TcxGridDBColumn;
    clReturn_Amount_Sh: TcxGridDBColumn;
    clReturn_Amount_Weight: TcxGridDBColumn;
    clReturn_Summ: TcxGridDBColumn;
    clGoodsKindName: TcxGridDBColumn;
    clSale_AmountPartner_Weight: TcxGridDBColumn;
    clSale_AmountPartner_Sh: TcxGridDBColumn;
    clReturn_AmountPartner_Weight: TcxGridDBColumn;
    clReturn_AmountPartner_Sh: TcxGridDBColumn;
    clReturnPercent: TcxGridDBColumn;
    clGoodsGroupNameFull: TcxGridDBColumn;
    clMeasureName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    clRetailName: TcxGridDBColumn;
    clOKPO: TcxGridDBColumn;
    actPrint_byJuridical: TdsdPrintAction;
    bbPrint_byJuridical: TdxBarButton;
    cxLabel13: TcxLabel;
    edRouteSorting: TcxButtonEdit;
    cxLabel7: TcxLabel;
    edRoute: TcxButtonEdit;
    GuidesRouteSorting: TdsdGuides;
    GuidesRoute: TdsdGuides;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    GuidesFrom: TdsdGuides;
    edTo: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edByDoc: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TReport_GoodsMI_OrderExternalForm);

end.
