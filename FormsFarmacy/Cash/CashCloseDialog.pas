unit CashCloseDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.StdCtrls, cxButtons, cxGroupBox, cxRadioGroup, cxLabel,
  cxTextEdit, cxCurrencyEdit, Vcl.ActnList, dsdAction, cxClasses,
  cxPropertiesStore, dsdAddOn, CashInterface, AncestorBase, dsdDB, dxSkinsCore,
  dxSkinsDefaultPainters;

type
  TCashCloseDialogForm = class(TAncestorDialogForm)
    cxGroupBox1: TcxGroupBox;
    edSalerCash: TcxCurrencyEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    lblTotalSumma: TcxLabel;
    lblSdacha: TcxLabel;
    rgPaidType: TcxRadioGroup;
    cxGroupBox2: TcxGroupBox;
    edSalerCashAdd: TcxCurrencyEdit;
    procedure edSalerCashPropertiesChange(Sender: TObject);
    procedure ParentFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSummaTotal: Currency;
    FPaidTypeTemp : integer;
    FSalerCash: Currency;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CashCloseDialogForm: TCashCloseDialogForm;
function CashCloseDialogExecute(ASummaTotal: Currency; Var ASalerCash, ASalerCashAdd: Currency; var APaidType: TPaidType):Boolean;

implementation

{$R *.dfm}

uses DataModul, Math;

function CashCloseDialogExecute(ASummaTotal: Currency; Var ASalerCash, ASalerCashAdd: Currency; var APaidType: TPaidType):Boolean;
Begin
  if NOT assigned(CashCloseDialogForm) then
    CashCloseDialogForm := TCashCloseDialogForm.Create(Application);
  With CashCloseDialogForm do
  Begin
    try
      FSummaTotal := ASummaTotal;
      FPaidTypeTemp := -1;
      lblTotalSumma.Caption := FormatCurr('0.00',ASummaTotal);
      edSalerCash.Value := ASummaTotal;
      rgPaidType.ItemIndex := Integer(APaidType);
      ActiveControl := edSalerCash;
      edSalerCash.SelectAll;
      Result := ShowModal = mrOK;
      if Result then
      Begin
        ASalerCash := edSalerCash.Value;
        if TPaidType(rgPaidType.ItemIndex) = ptCardAdd then
          ASalerCashAdd := ASummaTotal - edSalerCash.Value
        else ASalerCashAdd := 0;
        APaidType := TPaidType(rgPaidType.ItemIndex);
      End;
    Except ON E: Exception DO
      MessageDlg(E.Message,mtError,[mbOk],0);
    end;
  End;
End;

procedure TCashCloseDialogForm.edSalerCashPropertiesChange(Sender: TObject);
var
  tmpVal: Currency;
begin
  if FPaidTypeTemp <> rgPaidType.ItemIndex then
  begin
    cxGroupBox2.Visible := rgPaidType.ItemIndex = 2;
    edSalerCash.Value := FSummaTotal;
    edSalerCash.Properties.ReadOnly := rgPaidType.ItemIndex = 1;
    edSalerCashAdd.Text := '';
    if rgPaidType.ItemIndex = 0 then
      cxGroupBox1.Caption := '����� �� ����������'
    else cxGroupBox1.Caption := '����� �� ���������� �� �����';
    FPaidTypeTemp := rgPaidType.ItemIndex;
  end;

  if (RoundTo(FSalerCash - edSalerCash.Value, -2) <> 0) and (rgPaidType.ItemIndex = 2) then
  begin
    if FSummaTotal > edSalerCash.Value then
      edSalerCashAdd.Value := FSummaTotal - edSalerCash.Value
    else edSalerCashAdd.Text := '';
  end;

  FSalerCash := edSalerCash.Value;
  tmpVal := edSalerCash.Value + edSalerCashAdd.Value;
  bbOk.Enabled := ((tmpVal - FSummaTotal)>=0) and
    ((rgPaidType.ItemIndex <> 2) or (RoundTo(edSalerCash.Value - FSummaTotal, -2) < 0));
  if FSummaTotal <= tmpVal then
    lblSdacha.Caption := FormatCurr('0.00',tmpVal - FSummaTotal)
  else
    lblSdacha.Caption := '���';
end;

procedure TCashCloseDialogForm.ParentFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DIVIDE then
    rgPaidType.ItemIndex := 0
  else
  if Key = VK_MULTIPLY then
  begin
    if rgPaidType.ItemIndex <> 1 then
      rgPaidType.ItemIndex := 1
    else rgPaidType.ItemIndex := 2;
  end;
end;

end.
