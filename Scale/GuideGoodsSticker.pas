unit GuideGoodsSticker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit,cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid, dsdAddOn, Vcl.ActnList, dsdAction
 ,UtilScale,DataModul, frxClass, frxPreview, frxDBSet, cxSplitter, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel,
  cxCheckBox;

type
  TGuideGoodsStickerForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    infoPanelPriceList: TPanel;
    rgPriceList: TRadioGroup;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    DS: TDataSource;
    infoPanelGoods: TPanel;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsWieghtValue: TGroupBox;
    PanelGoodsWieghtValue: TPanel;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbSave: TSpeedButton;
    infoPanelGoodsKind: TPanel;
    rgGoodsKind: TRadioGroup;
    gbGoodsKindCode: TGroupBox;
    EditGoodsKindCode: TEdit;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbWeightValue: TGroupBox;
    EditWeightValue: TcxCurrencyEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    GoodsKindName: TcxGridDBColumn;
    MeasureName: TcxGridDBColumn;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    actSave: TAction;
    Amount_Weighing: TcxGridDBColumn;
    GoodsKindName_complete: TcxGridDBColumn;
    PreviewPanel: TPanel;
    frxPreview: TfrxPreview;
    PrintHeaderCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    frxDBDHeader: TfrxDBDataset;
    cxSplitter1: TcxSplitter;
    cxSplitter2: TcxSplitter;
    GoodsKindCode: TcxGridDBColumn;
    StickerSkinName: TcxGridDBColumn;
    StickerFileName: TcxGridDBColumn;
    FReport: TfrxReport;
    TradeMarkName_goods: TcxGridDBColumn;
    GoodsName_original: TcxGridDBColumn;
    StickerSortName: TcxGridDBColumn;
    PanelSticker: TPanel;
    cbStartEnd: TcxCheckBox;
    cxLabel1: TcxLabel;
    deDateStart: TcxDateEdit;
    cbTare: TcxCheckBox;
    cbGoodsName: TcxCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeExit(Sender: TObject);
    procedure EditGoodsNameExit(Sender: TObject);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditPriceListCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure EditPriceListCodeChange(Sender: TObject);
    procedure rgPriceListClick(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure EditTareCountEnter(Sender: TObject);
    procedure rgGoodsKindClick(Sender: TObject);
    procedure EditGoodsKindCodeChange(Sender: TObject);
    procedure EditGoodsKindCodeExit(Sender: TObject);
    procedure EditGoodsKindCodeKeyPress(Sender: TObject; var Key: Char);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure EditWeightValueExit(Sender: TObject);
    procedure EditWeightValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    //FReport : TfrxReport;
    fCloseOK : Boolean;
    fModeSave : Boolean;
    fStartWrite : Boolean;
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;
    fEnterGoodsKindCode:Boolean;

    fStickerPropertyId : Integer;
    fStickerFileName : String;
    fStartShowReport : Boolean;

    GoodsCode_FilterValue:String;
    GoodsName_FilterValue:String;

    procedure CancelCxFilter;
    function Checked: boolean;
    procedure InitializeStickerPack(StickerPackGroupId:Integer);
    procedure InitializePrinterSticker;
    procedure pShowReport;
  public
    //GoodsWeight:Double;
    function Execute (execParamsMovement : TParams; isModeSave : Boolean) : Boolean;
  end;

var
  GuideGoodsStickerForm: TGuideGoodsStickerForm;

implementation
{$R *.dfm}
uses dmMainScale, Main, DialogWeight, DialogStringValue,FormStorage;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.pShowReport;
begin
     if fStartShowReport = TRUE then exit;
     //
     try
     fStartShowReport:= TRUE;
     //
     if fStickerPropertyId = CDS.FieldByName('Id').asInteger
     then exit;
     fStickerPropertyId:= CDS.FieldByName('Id').asInteger;
     //
     if CDS.FieldByName('StickerFileName').asString = ''
     then begin
              //Application.ProcessMessages;
              //Sleep(10);
              //Application.ProcessMessages;
              //
              fStickerFileName:='';
              FReport.Clear;
              fReport.PrepareReport;
              fReport.ShowPreparedReport;
              frxPreview.RefreshReport;
              //
              //Application.ProcessMessages;
              //Sleep(10);
              //Application.ProcessMessages;
          end
     else begin
              //Application.ProcessMessages;
              //Sleep(10);
              //Application.ProcessMessages;
              //
              spSelectPrint.ParamByName('inObjectId').Value:=CDS.FieldByName('Id').asInteger;
              spSelectPrint.Execute;
              //
              if fStickerFileName <> CDS.FieldByName('StickerFileName').asString then
              begin
                    FReport.Clear;
                    StickerFile_Array[GetArrayStickerFileList_Index_byName(StickerFile_Array,CDS.FieldByName('StickerFileName').asString)].Report.Position := 0;
                    FReport.LoadFromStream(StickerFile_Array[GetArrayStickerFileList_Index_byName(StickerFile_Array,CDS.FieldByName('StickerFileName').asString)].Report);
                    //
                    fStickerFileName:= CDS.FieldByName('StickerFileName').asString;
              end;

              //fReport.DataSet:=frxDBDHeader;
              //fReport.DataSetName:='frxDBDHeader';
              //fReport.Preview:=nil;
              //fReport.Preview:=frxPreview;
              //fReport.PreviewOptions.modal := false;
              fReport.PrepareReport;
              //fReport.PreviewOptions.Zoom:=1.5;
              //fReport.PreviewOptions.ZoomMode:=zmPageWidth;
              //FReport.PreviewOptions.Maximized := true;
              fReport.ShowPreparedReport;
              //
              //Application.ProcessMessages;
              //Sleep(10);
              //Application.ProcessMessages;
         end;

     finally
     fStartShowReport:= FALSE;
     end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
function TGuideGoodsStickerForm.Execute (execParamsMovement : TParams; isModeSave : Boolean) : Boolean;
begin
     fStickerPropertyId:=-1;
     fStickerFileName:='';
     //
     fModeSave:= isModeSave;
     fCloseOK:=false;

     fEnterGoodsCode:=false;
     fEnterGoodsName:=false;
     fEnterGoodsKindCode:=false;

     CancelCxFilter;
     fStartWrite:=true;

     if execParamsMovement.ParamByName('OrderExternalId').AsInteger<>0 then
     with spSelect do
     begin
       // �������� - �������� ������ �� ������
       Self.Caption:='������ �������� �� ��������� '+execParamsMovement.ParamByName('OrderExternalName_master').asString;
       if isModeSave = FALSE then Self.Caption:= '��� ����������: ' + Self.Caption;
       Params.ParamByName('inOrderExternalId').Value:= execParamsMovement.ParamByName('OrderExternalId').AsInteger;
       Params.ParamByName('inMovementId').Value     := execParamsMovement.ParamByName('MovementId').AsInteger;
       Params.ParamByName('inGoodsCode').Value      := 0;
       Params.ParamByName('inGoodsName').Value      := '';
       Execute;
     end
     else if isModeSave = FALSE then Self.Caption:= '��� ���������� - �������� ��������'
     else Self.Caption:= '������ ��������';
     ;

    // �������� ��� � ����� - �������� ��� ����� ���������
    PanelGoodsWieghtValue.Caption:=FloatToStr(ParamsMI.ParamByName('RealWeight_Get').AsFloat);


    //���� ���� ������������
    if 1=0 // ParamsMI.ParamByName('GoodsId').AsInteger<>0
    then begin
    end
    else begin
              EditGoodsCode.Text:='';
              EditGoodsName.Text:='';
              EditGoodsKindCode.Text:='';
              EditWeightValue.Text:='2';

              CDS.Filter:='';
              CDS.Filtered:=false;
              if ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
              then CDS.Filtered:=true;
              ActiveControl:=EditGoodsCode;
    end;

     Application.ProcessMessages;
     fStartWrite:=false;

     result:=ShowModal=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.InitializeStickerPack(StickerPackGroupId:Integer);
var i:Integer;
begin
     EditGoodsKindCode.Text:='';
     with rgGoodsKind do
     begin
          Items.Clear;
          i:=0;
          if StickerPackGroupId = 0
          then begin Items.Add('(1) ���'); ItemIndex:=0;EditGoodsKindCode.Text:='1';end
          else
              for i:=0 to Length(StickerPack_Array)-1 do
                 if StickerPack_Array[i].Number = StickerPackGroupId
                 then Items.Add('('+IntToStr(StickerPack_Array[i].Code)+') '+ StickerPack_Array[i].Name);

          if i<10 then Columns:=1 else Columns:=2;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.InitializePrinterSticker;
var i:Integer;
begin
     with rgPriceList do
     begin
          Items.Clear;
          if Length(PrinterSticker_Array)>0
          then
              for i:=0 to Length(PrinterSticker_Array)-1 do
               if PrinterSticker_Array[i].Name <> ''
               then Items.Add('('+IntToStr(PrinterSticker_Array[i].Code)+') '+ PrinterSticker_Array[i].Name);

          if Items.Count = 0 then Items.Add('(1) �� ���������');
          ItemIndex:=0;
          //EditPriceListCode.Text:='1';
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
var findTareCode:Integer;
begin
    if Key=13 then
    begin
      if (ActiveControl=EditGoodsCode) then EditGoodsCodeExit(EditGoodsCode);

      if (ActiveControl=EditWeightValue)
      then if rgGoodsKind.Items.Count > 1  then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditPriceListCode
      else if (ActiveControl=EditGoodsCode)
           then if (Length(trim(EditGoodsCode.Text))>0)
                then ActiveControl:=EditWeightValue
                else ActiveControl:=EditGoodsName

           else if (ActiveControl=EditGoodsName)and((Length(trim(EditGoodsName.Text))>0))
                then ActiveControl:=EditWeightValue

                else if (ActiveControl=EditGoodsName)
                     then ActiveControl:=EditGoodsCode
                     else if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
                          then actChoiceExecute(cxDBGrid)

      else if ActiveControl=EditGoodsKindCode then ActiveControl:=EditPriceListCode
           else if ActiveControl=EditPriceListCode then actSaveExecute(Self);
    end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
           then actExitExecute(Self)
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('��� ������ ������ �������� ���������� ������ ������.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('������ ��������.�������� ������ �������� ������.');exit;end
                     else begin fCloseOK:= true; actExitExecute(Self); end;
                end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
var
   GoodsKindCode:Integer;
begin
     if rgGoodsKind.Items.Count=1
     then GoodsKindCode:=0
     else try GoodsKindCode:=StrToInt(EditGoodsKindCode.Text) except GoodsKindCode:=0;end;
     //
     //
     if fEnterGoodsCode
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true
       else Accept:=false

     else
         if (fEnterGoodsKindCode)and(trim(GoodsCode_FilterValue)<>'')
         then
             if  (GoodsCode_FilterValue = DataSet.FieldByName('GoodsCode').AsString)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true
             else Accept:=false
         ;
     //
     if fEnterGoodsName
     then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
        and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
       then Accept:=true
       else Accept:=false

     else
         if (fEnterGoodsKindCode)and(trim(GoodsName_FilterValue)<>'')
         then
             if  (pos(AnsiUpperCase(GoodsName_FilterValue),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
              and((GoodsKindCode=0)or(GoodsKindCode=DataSet.FieldByName('GoodsKindCode').AsInteger))
             then Accept:=true
             else Accept:=false
         ;

     //
     if (trim(EditGoodsCode.Text) = '') and (trim(EditGoodsName.Text) = '')
     then Accept:=true;

end;
{------------------------------------------------------------------------------}
function TGuideGoodsStickerForm.Checked: boolean; //�������� ����������� ����� � Edit
var WeightReal_check:Double;
begin
     Result:=(CDS.RecordCount=1)
          and(rgGoodsKind.ItemIndex>=0)
          and(rgPriceList.ItemIndex>=0)
          and(ParamsMI.ParamByName('RealWeight').AsFloat>=1)
          ;
     //
     if fModeSave = FALSE then
     begin
          Result:= false;
          ShowMessage ('������.���� ������� � ������ <������ ��������>.');
          exit;
     end;
     //
     if not Result
     then ActiveControl:=EditGoodsCode
     else
     with ParamsMI do begin
        ParamByName('GoodsId').AsInteger:=CDS.FieldByName('GoodsId').AsInteger;
        if rgGoodsKind.Items.Count > 1
        then ParamByName('GoodsKindId').AsInteger:= StickerPack_Array[GetArrayList_gpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,rgGoodsKind.ItemIndex)].Id
        else ParamByName('GoodsKindId').AsInteger:= 0;

        ParamByName('MovementId_Promo').AsInteger:=0;

        ParamByName('Price').AsFloat:=0;
        ParamByName('Price_Return').AsFloat:=0;
        ParamByName('CountForPrice').AsFloat:= 0;
        ParamByName('CountForPrice_Return').AsFloat:= 0;

        // ���������� ����
        ParamByName('CountTare').AsFloat:=0;
        // ��� 1-�� ����
        ParamByName('WeightTare').AsFloat:=0;
        // % ������ ��� ���-��
        ParamByName('ChangePercentAmount').AsFloat:=0;

       //�������� - ���������� (�����) � ������ ����
       Result:=(ParamByName('RealWeight').AsFloat-ParamByName('CountTare').AsFloat*ParamByName('WeightTare').AsFloat)>0;
       if not Result then
       begin
            ShowMessage('������.���������� �� ������� ���� �� ����� ���� ������ 0.');
            exit;
       end;

     end;
     //
     //Save MI
     if Result = TRUE then
     begin
          //���� �� ��, �������� ������������ - �.�. ��� ����� �� ��� � ���
          if 1=0 // (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg) and (SettingMain.BranchCode <> 301)
          then begin
          end;
          //���������� MovementItem
          Result:=DMMainScaleForm.gpInsert_Scale_MI(ParamsMovement,ParamsMI);
          if not Result then ShowMessage('Error.not Result');
          Result:=true;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
      begin
           CDS.Filtered:=false;
           if trim (EditGoodsCode.Text) <> ''
           then CDS.Filtered:=true
           else CDS.Filtered:=true;//!!!
           //
           //Application.ProcessMessages;
           //pShowReport;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      CDS.Filtered:=false;
      if 1=1 // ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
      then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsCodeExit(Sender: TObject);
var Code_begin:Integer;
begin
     if fStartWrite=true then exit;

     try Code_begin:=StrToInt(EditGoodsCode.Text) except Code_begin:=0;end;

     //
     if (CDS.Filtered=false) and (Length(trim(EditGoodsCode.Text))>0)
     then begin fEnterGoodsCode:=true;CDS.Filtered:=true;end;


     if CDS.RecordCount=0
     then begin fEnterGoodsCode:=false;
                GoodsCode_FilterValue:=EditGoodsCode.Text;
                GoodsName_FilterValue:='';
          end
     else begin fEnterGoodsCode:=false;
                GoodsCode_FilterValue:=EditGoodsCode.Text;
                GoodsName_FilterValue:='';
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';

          GoodsCode_FilterValue:=EditGoodsCode.Text;
          GoodsName_FilterValue:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsNameChange(Sender: TObject);
var Code_begin:String;
begin
     if fEnterGoodsName then
     begin
           Code_begin:= CDS.FieldByName('GoodsCode').AsString;
           CDS.Filtered:=false;
           if trim(EditGoodsName.Text)<>''
           then CDS.Filtered:=true
           else CDS.Filtered:=true;//!!!
           //
           if Code_begin <> '' then CDS.Locate('GoodsCode',Code_begin,[loCaseInsensitive,loPartialKey]);
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsNameEnter(Sender: TObject);
var Code_begin:String;
begin
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  CDS.Filtered:=false;
  if 1=1 //ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
  then CDS.Filtered:=true;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsNameExit(Sender: TObject);
var Code_begin:Integer;
begin
     if fStartWrite=true then exit;

     {Code_begin:=CDS.FieldByName('GoodsCode').AsInteger;
     //
     if (GoodsWeight<0.0001)//and(not((GoodsCode>=_CodeStartGoods_onEnterWeight)and(GoodsCode<=_CodeEndGoods_onEnterWeight)))
     then ActiveControl:=EditGoodsCode;
     else
        if (Code_begin<=0)and(CDS.RecordCount<=1) then ActiveControl:=EditGoodsName
        else if (Code_begin>0)and(CDS.RecordCount=1) then EditGoodsCode.Text:=IntToStr(Code_begin);}

     if (CDS.Filtered=false)and(Length(trim(EditGoodsName.Text))>0)
     then begin fEnterGoodsName:=true;CDS.Filtered:=true;end;

     if CDS.RecordCount=0
     then if 1=1 //ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
          then begin fEnterGoodsName:=false;
                     GoodsCode_FilterValue:='';
                     GoodsName_FilterValue:=EditGoodsName.Text;
               end
          else ActiveControl:=EditGoodsName
     else begin fEnterGoodsName:=false;
                GoodsCode_FilterValue:='';
                GoodsName_FilterValue:=EditGoodsName.Text;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';

          GoodsCode_FilterValue:='';
          GoodsName_FilterValue:=EditGoodsName.Text;
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditWeightValueExit(Sender: TObject);
begin
     //if (CDS.FieldByName('MeasureId').AsInteger = zc_Measure_Kg) and (SettingMain.BranchCode <> 301)
     //then exit;

     try StrToFloat(EditWeightValue.Text)
     except ActiveControl:=EditWeightValue;
            exit;
     end;
     if StrToFloat(EditWeightValue.Text)<=0
     then ActiveControl:=EditWeightValue
     else try ParamsMI.ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text);
          except ParamsMI.ParamByName('RealWeight').AsFloat:=0;end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditWeightValueKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then if rgGoodsKind.Items.Count>1 then ActiveControl:=EditGoodsKindCode else ActiveControl:=EditPriceListCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsKindCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     if (fStartWrite=true) then exit;

     if rgGoodsKind.Items.Count>1
     then begin
         if trim(EditGoodsKindCode.Text)<>''
         then try Code_begin:=StrToInt(EditGoodsKindCode.Text) except Code_begin:=-1;end else Code_begin:=-1;

         if (Code_begin<=0)
         then rgGoodsKind.ItemIndex:=-1
         else rgGoodsKind.ItemIndex:=GetArrayList_lpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,Code_begin);
     end
     else EditGoodsKindCode.Text:='1';

    if 1=1 // ParamsMovement.ParamByName('OrderExternalId').asInteger<>0
    then begin CDS.Filtered:=false;CDS.Filtered:=true;end;

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsKindCodeExit(Sender: TObject);
var GoodsKindId_check:Integer;
begin
      if (fStartWrite=true)or(ActiveControl=EditGoodsCode)or(ActiveControl=EditGoodsName)
       or(ActiveControl=cxDBGrid)or(ActiveControl=rgGoodsKind)or(ActiveControl.Name='')
      then exit;
//Focused
      if (rgGoodsKind.ItemIndex=-1)and (rgGoodsKind.Items.Count>1)
      then begin ShowMessage('������.�� ���������� �������� <��� ���� ��������>.');
                 ActiveControl:=EditGoodsKindCode;
           end
      else
        if CDS.RecordCount<>1
        then if (rgGoodsKind.Items.Count>1)
               //and (ParamsMovement.ParamByName('OrderExternalId').asInteger<>0)
             then begin
                       ShowMessage('������.�� ���������� �������� <��� ���� ��������>.');
                       ActiveControl:=EditGoodsKindCode;
                  end
             else begin
                       ShowMessage('������.�� ������ <��� ������>.');
                       ActiveControl:=EditGoodsCode;
                  end
        else if ParamsMI.ParamByName('RealWeight').AsFloat<=1
             then
                  if 1=1//(CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or (SettingMain.BranchCode = 301)
                  then begin ShowMessage('������.�� ���������� �������� <���� ����������>.');ActiveControl:=EditWeightValue;end
                  else begin ShowMessage('������.�� ���������� �������� <��� �� �����>.');ActiveControl:=EditGoodsCode;end;

      //
      {if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
       // and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
       and (CDS.FieldByName('GoodsKindName').AsString <> '')
       and (rgGoodsKind.Items.Count > 1)
      then begin
                GoodsKindId_check:= StickerPack_Array[GetArrayList_gpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,rgGoodsKind.ItemIndex)].Id;
                if System.Pos(',' + IntToStr(GoodsKindId_check) + ',', ',' + CDS.FieldByName('GoodsKindId_list').AsString + ',') = 0
                then
                begin
                     ShowMessage('������.�������� <��� ��������> ����� ���� ������ �����: <' + CDS.FieldByName('GoodsKindName').AsString + '>.');
                     ActiveControl:=EditGoodsKindCode;
                end;
      end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditGoodsKindCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if rgGoodsKind.Items.Count=1 then exit;
     //
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;

          if (rgGoodsKind.ItemIndex = rgGoodsKind.Items.Count-1)or(rgGoodsKind.ItemIndex = -1)
          then findIndex:=GetArrayList_gpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,-1)
          else findIndex:=1+GetArrayList_gpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,rgGoodsKind.ItemIndex);
          //
          EditGoodsKindCode.Text:=IntToStr(StickerPack_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;

     fEnterGoodsKindCode:=1=1;//ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.rgGoodsKindClick(Sender: TObject);
var findIndex:Integer;
    fStartWrite_old:Boolean;
begin
    if rgGoodsKind.Items.Count=1 then exit;
    //
    findIndex:=GetArrayList_gpIndex_GoodsKind(StickerPack_Array,lStickerPackGroupId,rgGoodsKind.ItemIndex);
    fStartWrite_old:= fStartWrite;
    fStartWrite:=true;
    EditGoodsKindCode.Text:=IntToStr(StickerPack_Array[findIndex].Code);
    if ActiveControl <> cxDBGrid then ActiveControl:=EditGoodsKindCode;
    fStartWrite:=fStartWrite_old;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditTareCountEnter(Sender: TObject);
var Key:Word;
begin
      TEdit(Sender).SelectAll;
      Key:=13;
      //
      //if (ActiveControl=EditTareCount)and(GBUpak.Visible)
      //then begin
      //          PanelUpak.Caption:=GetStringValue('select zf_MyRound0(zf_CalcDivisionNoRound('+FormatToFloatServer(GoodsWeight)+',GoodsProperty_Detail.Ves_onUpakovka))as RetV from dba.GoodsProperty join dba.KindPackage on KindPackage.KindPackageCode = '+trim(EditKindPackageCode.Text)+' join dba.GoodsProperty_Detail on GoodsProperty_Detail.GoodsPropertyId=GoodsProperty.Id and GoodsProperty_Detail.KindPackageID=KindPackage.Id where GoodsProperty.GoodsCode = '+trim(EditGoodsCode.Text));
      //end;
      //
      if (ActiveControl=EditGoodsKindCode)
      then begin
           if rgGoodsKind.Items.Count=1 then begin ActiveControl:=EditPriceListCode;exit;end;
           //
           ActiveControl:=EditGoodsKindCode;
           //
           if (CDS.RecordCount=1)
             //and (ParamsMovement.ParamByName('OrderExternalId').AsInteger<>0)
           then begin
                     fEnterGoodsKindCode:=true;
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
                     //ActiveControl:=EditTareCount;
           end;
           //
           {if   (ParamsMovement.ParamByName('OrderExternalId').AsInteger = 0)
            //and (ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_ReturnIn)
            and (CDS.FieldByName('GoodsKindCode_max').AsInteger <> 0)
            and (fStartWrite = false)
            and (rgGoodsKind.ItemIndex = -1)
           then begin
                     EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode_max').AsString;
                     TEdit(Sender).SelectAll;
           end;}
            //
           exit;
      end;

      if (ActiveControl=EditGoodsKindCode)and(rgGoodsKind.ItemIndex>=0)and(rgGoodsKind.Items.Count=1)then begin rgGoodsKind.ItemIndex:=0;FormKeyDown(Sender,Key,[]);exit;end;
      if (ActiveControl=EditPriceListCode)and(rgPriceList.ItemIndex>=0)and(rgPriceList.Items.Count=1)then begin FormKeyDown(Sender,Key,[]);exit;end;
      //
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditPriceListCodeChange(Sender: TObject);
var Code_begin:Integer;
begin
     try Code_begin:=StrToInt(EditPriceListCode.Text) except Code_begin:=-1;end;
     if (Code_begin<0)
     then rgPriceList.ItemIndex:=-1
     else rgPriceList.ItemIndex:= GetArrayList_Index_byCode(PrinterSticker_Array,Code_begin);

end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditPriceListCodeExit(Sender: TObject);
begin
     if fStartWrite=true then exit;
     if rgPriceList.ItemIndex=-1 then ActiveControl:=EditPriceListCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.EditPriceListCodeKeyPress(Sender: TObject;var Key: Char);
var findIndex:Integer;
begin
     if Key=' ' then Key:=#0;
     if Key='+' then
     begin
          Key:=#0;
          //
          if (rgPriceList.ItemIndex = rgPriceList.Items.Count-1)or(rgPriceList.ItemIndex = -1)
          then findIndex:=0
          else findIndex:=1+rgPriceList.ItemIndex;
          //
          EditPriceListCode.Text:=IntToStr(PrinterSticker_Array[findIndex].Code);
          TEdit(Sender).SelectAll;
     end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.rgPriceListClick(Sender: TObject);
begin
    EditPriceListCode.Text:=IntToStr(PrinterSticker_Array[rgPriceList.ItemIndex].Code);
    ActiveControl:=EditPriceListCode
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.DSDataChange(Sender: TObject; Field: TField);
begin
     with ParamsMI do begin
        if CDS.RecordCount=1 then
         if 1=1//(CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or (SettingMain.BranchCode = 301)
         then try ParamByName('RealWeight').AsFloat:=StrToFloat(EditWeightValue.Text); except ParamByName('RealWeight').AsFloat:=0;end
         else ParamByName('RealWeight').AsFloat:=ParamByName('RealWeight_Get').AsFloat
        else
            ParamByName('RealWeight').AsFloat:=0;
     end;
     //
     Application.ProcessMessages;
     pShowReport;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.DBGridDrawColumnCell(Sender: TObject;const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
{     if (AnsiUpperCase(Column.Field.FieldName)=AnsiUpperCase('Amount_diff'))
       and((CDS.FieldByName('Amount_diff').AsFloat>0)or(CDS.FieldByName('isTax_diff').AsBoolean = true))
     then
     with (Sender as TDBGrid).Canvas do
     begin
          if CDS.FieldByName('isTax_diff').AsBoolean = true then Font.Color:=clBlue;
          if CDS.FieldByName('Amount_diff').AsFloat > 0 then Font.Color:=clRed;

          FillRect(Rect);
          if (Column.Alignment=taLeftJustify)or(Rect.Left>=Rect.Right - LengTh(Column.Field.Text))
          then TextOut(Rect.Left+2, Rect.Top+2, Column.Field.Text)
          else TextOut(Rect.Right - TextWidth(Column.Field.Text) - 2, Rect.Top+2 , Column.Field.Text);
     end;}
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.actRefreshExecute(Sender: TObject);
var GoodsCode:String;
begin
    with spSelect do begin
        GoodsCode:= DataSet.FieldByName('GoodsCode').AsString;
        Execute;
        if GoodsCode <> '' then
          DataSet.Locate('GoodsCode',GoodsCode,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.actChoiceExecute(Sender: TObject);
begin
     if CDS.FieldByName('GoodsCode').AsString <> '0'
     then begin EditGoodsCode.Text:=CDS.FieldByName('GoodsCode').AsString;
                fEnterGoodsCode:= true;
                fEnterGoodsName:= false;
                if SettingMain.BranchCode = 301
                then EditGoodsCodeChange(EditGoodsCode); // EditGoodsCodeExit(EditGoodsCode);
          end
     else if (SettingMain.BranchCode = 301)
          then begin
                EditGoodsName.Text:=CDS.FieldByName('GoodsName').AsString;
                fEnterGoodsCode:= false;
                fEnterGoodsName:= true;
                EditGoodsNameChange(EditGoodsName) // EditGoodsNameExit(EditGoodsName);
          end;

     if (ParamsMovement.ParamByName('OrderExternalId').asInteger=0)
     then if (SettingMain.BranchCode <> 301) then EditGoodsCodeChange(EditGoodsCode) else
     else begin
               fEnterGoodsKindCode:=true;
               if rgGoodsKind.Items.Count>1
               then EditGoodsKindCode.Text:=CDS.FieldByName('GoodsKindCode').AsString;
               EditGoodsKindCodeChange(EditGoodsKindCode);
          end;
     //
     if 1=1//(CDS.FieldByName('MeasureId').AsInteger <> zc_Measure_Kg) or (SettingMain.BranchCode = 301)
     then ActiveControl:=EditWeightValue
     else if 1=1 //(ParamsMovement.ParamByName('OrderExternalId').asInteger=0)and(rgGoodsKind.Items.Count>1)
          then ActiveControl:=EditGoodsKindCode
          else ActiveControl:=EditPriceListCode;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.actExitExecute(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.actSaveExecute(Sender: TObject);
begin
     if Checked then begin fCloseOK:=true; Close; ModalResult:= mrOK; end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
     CanClose:=false;
           if (fModeSave = false) or (GetArrayList_Value_byName(Default_Array,'isCheckDelete') = AnsiUpperCase('FALSE'))
             or ((ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Sale)
              and(ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_SendOnPrice)
                )
             or (fCloseOK = true)
           then CanClose:=true
           else with DialogStringValueForm do
                begin
                     if not Execute (false, true) then begin ShowMessage ('��� ������ ����������� ���������� ������ ������.'); exit; end;
                     //
                     if DMMainScaleForm.gpGet_Scale_PSW_delete (StringValueEdit.Text) <> ''
                     then begin ShowMessage ('������ ��������.�������� ����������� ������.');exit;end
                     else CanClose:=true;
                end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.FormCreate(Sender: TObject);
var i:Integer;
begin
  fStartWrite:=true;
  //
  fStickerPropertyId:=-1;
  fStickerFileName:='';
  fStartShowReport:=false;
  //FReport:= TfrxReport.Create(nil);
  //FReport.Preview:=frxPreview;
  //

  //���������
  InitializeStickerPack(lStickerPackGroupId);
  //��������
  InitializePrinterSticker;

  //��� ���� (������ �����)
  //***gbTareWeightEnter.Visible:=GetArrayList_Value_byName(Default_Array,'isTareWeightEnter')=AnsiUpperCase('TRUE');
  //��� ����
  {***for i := 0 to Length(TareWeight_Array)-1 do
    if TareWeight_Array[i].Number>=1000
    then rgTareWeight.Items.Add('('+IntToStr(0)+') '+ TareWeight_Array[i].Name)
    else rgTareWeight.Items.Add('('+IntToStr(TareWeight_Array[i].Code)+') '+ TareWeight_Array[i].Name);***}
  //������ �� ����
  {***for i := 0 to Length(ChangePercentAmount_Array)-1 do
    rgChangePercentAmount.Items.Add('('+IntToStr(ChangePercentAmount_Array[i].Code)+') '+ ChangePercentAmount_Array[i].Name);
  rgChangePercentAmount.Columns:=Length(ChangePercentAmount_Array);***}

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_Sticker';
       OutputType:=otDataSet;
       Params.AddParam('inIsGoodsComplete', ftBoolean, ptInput, SettingMain.isGoodsComplete);
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsMovement.ParamByName('OperDate').AsDateTime);
       if Self.Tag < 0
       then Params.AddParam('inMovementId', ftInteger, ptInput, Self.Tag)
       else Params.AddParam('inMovementId', ftInteger, ptInput, 0);
       Params.AddParam('inOrderExternalId', ftInteger, ptInput, 0);
       Params.AddParam('inPriceListId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsName', ftString, ptInput, '');
       Params.AddParam('inBranchCode', ftInteger, ptInput, SettingMain.BranchCode);
       Execute;
  end;
end;
{------------------------------------------------------------------------------}
procedure TGuideGoodsStickerForm.FormDestroy(Sender: TObject);
begin
  if Assigned (ParamsMI) then begin ParamsMI.Free;ParamsMI:=nil;end;
  if Assigned (ParamsMovement) then begin ParamsMovement.Free;ParamsMovement:=nil;end;
end;
{------------------------------------------------------------------------------}
end.
