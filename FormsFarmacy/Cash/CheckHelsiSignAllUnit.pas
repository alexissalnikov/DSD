unit CheckHelsiSignAllUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction, System.DateUtils,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters, Data.DB,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxDBData, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Datasnap.DBClient, cxGridLevel, cxGridCustomView, cxGrid, cxCurrencyEdit,
  Vcl.ComCtrls, cxCheckBox, cxBlobEdit, dxSkinsdxBarPainter, dxBarExtItems,
  dxBar, dxCore, cxDateUtils, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog, cxDropDownEdit,
  cxGridBandedTableView, cxGridDBBandedTableView, cxLabel, cxCalendar,
  System.Actions;

type
  TCheckHelsiSignAllUnitForm = class(TAncestorBaseForm)
    BarManager: TdxBarManager;
    Bar: TdxBar;
    bbRefresh: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    bbGridToExcel: TdxBarButton;
    bbOpen: TdxBarButton;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxCheckHelsiSignAllUnitGrid: TcxGrid;
    cxCheckHelsiSignAllUnitGridDBBandedTableView1: TcxGridDBBandedTableView;
    colInvNumber: TcxGridDBBandedColumn;
    colGoodsCode: TcxGridDBBandedColumn;
    colGoodsName: TcxGridDBBandedColumn;
    colTotalSumm: TcxGridDBBandedColumn;
    colAmount: TcxGridDBBandedColumn;
    colPrice: TcxGridDBBandedColumn;
    colSumm: TcxGridDBBandedColumn;
    colBonusAmountTab: TcxGridDBBandedColumn;
    colColor_calc: TcxGridDBBandedColumn;
    cxCheckHelsiSignAllUnitGridLevel1: TcxGridLevel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    ExecuteDialog: TExecuteDialog;
    dxBarButton1: TdxBarButton;
    dsdStoredProc: TdsdStoredProc;
    actOpen: TMultiAction;
    colInvNumberSP: TcxGridDBBandedColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    actLoadState: TAction;
    dxBarButton2: TdxBarButton;
    actLoadStateCurr: TAction;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    colOrd: TcxGridDBBandedColumn;
    colParentName: TcxGridDBBandedColumn;
    colUnitName: TcxGridDBBandedColumn;
    procedure ParentFormCreate(Sender: TObject);
    procedure ParentFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actLoadStateExecute(Sender: TObject);
    procedure actLoadStateCurrExecute(Sender: TObject);
  private
    { Private declarations }
  public
  end;

implementation

{$R *.dfm}

uses Helsi, MainCash2, Math;



procedure TCheckHelsiSignAllUnitForm.actLoadStateCurrExecute(Sender: TObject);
  var cState : string; nColor : Integer;
begin
  if ClientDataSet.IsEmpty then Exit;

  if GetHelsiReceiptState(ClientDataSet.FieldByName('InvNumberSP').AsString,  cState) then
  else if GetHelsiReceiptState(ClientDataSet.FieldByName('InvNumberSP').AsString,  cState) then
  else cState := '��. ���������';
  nColor := clFuchsia;

  if cState = 'ACTIVE' then
  begin
    cState := '�� �������';
    nColor := clRed;
  end else if cState = 'EXPIRED' then
  begin
    cState := '���������';
    nColor := clRed;
  end else if cState = 'COMPLETED' then
  begin
    cState := '�������';
    nColor := clWindow;
  end else if cState <> '��. ���������' then
  begin
    cState := '�����. ������';
  end;

  ClientDataSet.Edit;
  ClientDataSet.FieldByName('State').AsString := cState;
  ClientDataSet.FieldByName('Color_calc').AsInteger := nColor;
  ClientDataSet.Post;
end;

procedure TCheckHelsiSignAllUnitForm.actLoadStateExecute(Sender: TObject);
  var cState : string;
begin
  try
    ClientDataSet.DisableControls;
    ClientDataSet.First;
    while not ClientDataSet.Eof do
    begin
      actLoadStateCurrExecute(Sender);
      ClientDataSet.Next;
    end;
  finally
    ClientDataSet.First;
    ClientDataSet.EnableControls;
  end;

end;

procedure TCheckHelsiSignAllUnitForm.ParentFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  UserSettingsStorageAddOn.SaveUserSettings;
end;

procedure TCheckHelsiSignAllUnitForm.ParentFormCreate(Sender: TObject);
begin
  FormClassName := Self.ClassName;
  UserSettingsStorageAddOn.LoadUserSettings;
  deStart.Date := Date;
  actOpen.Execute;
end;

End.