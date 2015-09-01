unit GuideMovementTransport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, Vcl.ComCtrls, dxCore,
  cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, cxImageComboBox, dsdAddOn, Vcl.ActnList
 ,DataModul, dsdAction;

type
  TGuideMovementTransportForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    ButtonExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbInvNumber: TGroupBox;
    EditInvNumber: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    Status: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    CarModelName: TcxGridDBColumn;
    InvNumber: TcxGridDBColumn;
    StartRunPlan: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    PersonalDriverName: TcxGridDBColumn;
    RouteName: TcxGridDBColumn;
    UnitForwardingName: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    FormParams: TdsdFormParams;
    IdBarCode: TcxGridDBColumn;
    cbAll: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure EditInvNumberChange(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure deStartPropertiesChange(Sender: TObject);
    procedure deEndPropertiesChange(Sender: TObject);
    procedure cbAllClick(Sender: TObject);
  private
    fStartWrite:Boolean;

    ParamsMovement_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure RefreshDataSet;
  public
    function Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
  end;

var
  GuideMovementTransportForm: TGuideMovementTransportForm;

implementation
{$R *.dfm}
uses dmMainScale,UtilScale,UtilPrint,Main,DialogMovementDesc;
{------------------------------------------------------------------------------}
function TGuideMovementTransportForm.Execute(var execParamsMovement:TParams;isChoice:Boolean): boolean;
begin
     CopyValuesParamsFrom(execParamsMovement,ParamsMovement_local);

     // ���� ����� ��� ������
     {if isChoice = TRUE
     then // ���� ����� ��������� � �� ����, ����� ��������� ����� �� ����
          if TRUE = DMMainScaleForm.gpGet_Scale_Movement(ParamsMovement_local,FALSE,TRUE)//isLast=FALSE,isNext=TRUE
          then begin CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);exit;end;}

     EditInvNumber.Text:='';

     fStartWrite:=true;
     deStart.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     deEnd.Text:=DateToStr(ParamsMovement_local.ParamByName('OperDate').AsDateTime);
     fStartWrite:=false;

     CancelCxFilter;
     RefreshDataSet;
     CDS.Filtered:=false;

     if ParamsMovement_local.ParamByName('TransportId').AsInteger<>0
     then CDS.Locate('Id',ParamsMovement_local.ParamByName('TransportId').AsString,[]);

     ActiveControl:=EditInvNumber;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then
     begin
          CopyValuesParamsFrom(ParamsMovement_local,execParamsMovement);
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.RefreshDataSet;
var StartDate,EndDate:TDateTime;
begin
     try StartDate:=StrToDate(deStart.Text); except if CDS.Active then StartDate:=spSelect.ParamByName('inStartDate').Value else StartDate:=ParamsMovement_local.ParamByName('OperDate').AsDateTime;deStart.Text:=DateToStr(StartDate);end;
     try EndDate:=StrToDate(deEnd.Text); except if CDS.Active then EndDate:=spSelect.ParamByName('inEndDate').Value else EndDate:=ParamsMovement_local.ParamByName('OperDate').AsDateTime;deEnd.Text:=DateToStr(EndDate);end;

     with spSelect do
     begin
          ParamByName('inStartDate').Value:=StartDate;
          ParamByName('inEndDate').Value:=EndDate;
          ParamByName('inBranchCode').Value:=SettingMain.BranchCode;
          if cbAll.Checked
          then ParamByName('inMovementId_order').Value:=0
          else ParamByName('inMovementId_order').Value:=ParamsMovement_local.ParamByName('OrderExternalId').AsInteger;
          ParamByName('inMovementDescId').Value:=ParamsMovement_local.ParamByName('MovementDescId').AsInteger;
          Execute;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.cbAllClick(Sender: TObject);
begin
     RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if ((ActiveControl=cxDBGrid)and(CDS.RecordCount>0))or(CDS.RecordCount=1)
        then actChoiceExecute(Self);
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     if (trim(EditInvNumber.Text)<>'')
     then
       if (pos(AnsiUpperCase(EditInvNumber.Text),AnsiUpperCase(DataSet.FieldByName('InvNumber').AsString))>0)
       then Accept:=true else Accept:=false;
end;
{------------------------------------------------------------------------------}
function TGuideMovementTransportForm.Checked: boolean; //�������� ����������� ����� � Edit
begin
     Result:=(CDS.RecordCount>0)and(CDS.FieldByName('Id').AsInteger>0);
     if Result then
     begin
         ParamsMovement_local.ParamByName('Transport_BarCode').AsString:=CDS.FieldByName('IdBarCode').AsString+CalcBarCode(CDS.FieldByName('IdBarCode').AsString);
     end;
end;

{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.EditInvNumberChange(Sender: TObject);
begin
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPartnerName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           if trim(EditInvNumber.Text)<>'' then Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.deStartPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deStart.Text); except exit;end;
     DecodeDate(StrToDate(deStart.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.deEndPropertiesChange(Sender: TObject);
var  Year, Month, Day, Hour, Min, Sec, MSec: Word;
begin
     if fStartWrite then exit;
     //
     try StrToDate(deEnd.Text); except exit;end;
     DecodeDate(StrToDate(deEnd.Text), Year, Month, Day);
     if (Year>2000)and(LengTh(deStart.Text)>=10) then RefreshDataSet;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.actRefreshExecute(Sender: TObject);
var MovementId:String;
begin
     MovementId:= CDS.FieldByName('Id').AsString;
     RefreshDataSet;
     if MovementId <> '' then
        CDS.Locate('Id',MovementId,[loCaseInsensitive]);
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.FormCreate(Sender: TObject);
begin
  Create_ParamsMovement(ParamsMovement_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_MovementTransport';
       Params.AddParam('inStartDate', ftDateTime, ptInput, 0);
       Params.AddParam('inEndDate', ftDateTime, ptInput,0);
       Params.AddParam('inBranchCode', ftInteger, ptInput,0);
       Params.AddParam('inMovementId_order', ftInteger, ptInput,0);
       Params.AddParam('inMovementDescId', ftInteger, ptInput,0);
       OutputType:=otDataSet;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideMovementTransportForm.FormDestroy(Sender: TObject);
begin
  ParamsMovement_local.Free;
end;
{------------------------------------------------------------------------------}
end.
