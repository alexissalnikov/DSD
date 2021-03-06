unit PUSHMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMemo;

type
  TPUSHMessageForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    Memo: TcxMemo;
    pn2: TPanel;
    pn1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ShowPUSHMessage(AMessage : string; DlgType: TMsgDlgType = mtInformation) : boolean;

implementation

{$R *.dfm}

procedure TPUSHMessageForm.FormCreate(Sender: TObject);
begin
  Memo.Style.Font.Size := Memo.Style.Font.Size + 4;
end;

procedure TPUSHMessageForm.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then ModalResult := mrOk;
end;

function ShowPUSHMessage(AMessage : string; DlgType: TMsgDlgType = mtInformation) : boolean;
  var PUSHMessageForm : TPUSHMessageForm;
begin
  PUSHMessageForm := TPUSHMessageForm.Create(Screen.ActiveControl);
  try
    PUSHMessageForm.Memo.Lines.Text := AMessage;
    case DlgType of
      mtWarning : PUSHMessageForm.Caption := '��������������';
      mtError : begin
                  PUSHMessageForm.Caption := '������';
                  PUSHMessageForm.Memo.Style.TextColor := clRed;
                end;
      mtInformation : PUSHMessageForm.Caption := '���������';
      mtConfirmation : PUSHMessageForm.Caption := '�������������';
    end;
    Result := PUSHMessageForm.ShowModal = mrOk;
  finally
    PUSHMessageForm.Free;
  end;
end;

end.
