unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Data.DB,
  Bde.DBTables, Vcl.Mask, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdDB, Datasnap.DBClient, dxSkinsCore,
  dxSkinsDefaultPainters
 ,SysScalesLib_TLB;

type
  TMainForm = class(TForm)
    GridPanel: TPanel;
    DBGrid: TDBGrid;
    ButtonPanel: TPanel;
    ButtonDeleteItem: TSpeedButton;
    ButtonExit: TSpeedButton;
    ButtonRefresh: TSpeedButton;
    ButtonRefreshZakaz: TSpeedButton;
    ButtonChangeNumberTare: TSpeedButton;
    ButtonChangeNumberLevel: TSpeedButton;
    ButtonExportToMail: TSpeedButton;
    ButtonChangeMember: TSpeedButton;
    ButtonExportToEDI: TSpeedButton;
    infoPanelTotalSumm: TPanel;
    GBTotalSummGoods_Weight: TGroupBox;
    PanelTotalSummGoods_Weight: TPanel;
    TotalSummTare_Weight: TGroupBox;
    PanelTotalSummTare_Weight: TPanel;
    GBTotalSummGoods_Weight_Discount: TGroupBox;
    PanelTotalSummGoods_Weight_Discount: TPanel;
    gbTotalSumm: TGroupBox;
    PanelTotalSumm: TPanel;
    PanelZakaz: TPanel;
    GroupBox1: TGroupBox;
    DiffZakazSalePanel: TPanel;
    GroupBox2: TGroupBox;
    ZakazCountPanel: TPanel;
    GroupBox3: TGroupBox;
    ZakazChangePanel: TPanel;
    GroupBox4: TGroupBox;
    calcZakazCountPanel: TPanel;
    GroupBox5: TGroupBox;
    SaleCountPanel: TPanel;
    GroupBox6: TGroupBox;
    TotalDiffZakazSalePanel: TPanel;
    GroupBox7: TGroupBox;
    TotalZakazCountPanel: TPanel;
    PanelSaveItem: TPanel;
    CodeInfoPanel: TPanel;
    EnterGoodsCodeScanerPanel: TPanel;
    EnterGoodsCodeScanerLabel: TLabel;
    EnterGoodsCodeScanerEdit: TEdit;
    EnterWeightPanel: TPanel;
    EnterWeightLabel: TLabel;
    EnterWeightEdit: TEdit;
    gbOperDate: TGroupBox;
    infoPanel_Scale: TPanel;
    ScaleLabel: TLabel;
    PanelWeight_Scale: TPanel;
    PanelInfoItem: TPanel;
    PanelProduction_Goods: TPanel;
    LabelProduction_Goods: TLabel;
    GBProduction_GoodsCode: TGroupBox;
    PanelProduction_GoodsCode: TPanel;
    EditProduction_GoodsCode: TEdit;
    GBProduction_Goods_Weight: TGroupBox;
    PanelProduction_Goods_Weight: TPanel;
    GBProduction_GoodsName: TGroupBox;
    PanelProduction_GoodsName: TPanel;
    PanelTare_Goods: TPanel;
    LabelTare_Goods: TLabel;
    GBTare_GoodsCode: TGroupBox;
    PanelTare_GoodsCode: TPanel;
    GBTare_Goods_Weight: TGroupBox;
    PanelTare_Goods_Weight: TPanel;
    GBTare_GoodsName: TGroupBox;
    PanelTare_GoodsName: TPanel;
    gbTare_Goods_Count: TGroupBox;
    PanelTare_Goods_Count: TPanel;
    PanelSpace1: TPanel;
    PanelSpace2: TPanel;
    infoPanelTotalWeight: TPanel;
    GBTotalWeight: TGroupBox;
    PanelTotalWeight: TPanel;
    GBDiscountWeight: TGroupBox;
    PanelDiscountWeight: TPanel;
    infoPanel_mastre: TPanel;
    PanelMessage: TPanel;
    PanelMovementDesc: TPanel;
    infoPanel: TPanel;
    infoPanelPartner: TPanel;
    LabelPartner: TLabel;
    PanelPartner: TPanel;
    infoPanelPriceList: TPanel;
    PriceListNameLabel: TLabel;
    PanelPriceList: TPanel;
    infoPanelOrderExternal: TPanel;
    LabelOrderExternal: TLabel;
    PanelOrderExternal: TPanel;
    PopupMenu: TPopupMenu;
    miPrintZakazMinus: TMenuItem;
    miPrintZakazAll: TMenuItem;
    miLine11: TMenuItem;
    miPrintBill_byInvNumber: TMenuItem;
    miPrintBill_andNaliog_byInvNumber: TMenuItem;
    miPrintBillTotal_byClient: TMenuItem;
    miPrintBillTotal_byFozzi: TMenuItem;
    miLine12: TMenuItem;
    miPrintSchet_byInvNumber: TMenuItem;
    miPrintBillTransport_byInvNumber: TMenuItem;
    miPrintBillTransportNew_byInvNumber: TMenuItem;
    miPrintBillKachestvo_byInvNumber: TMenuItem;
    miPrintBillNumberTare_byInvNumber: TMenuItem;
    miPrintBillNotice_byInvNumber: TMenuItem;
    miLine13: TMenuItem;
    miPrintSaleAll: TMenuItem;
    miPrint_Report_byTare: TMenuItem;
    miPrint_Report_byMemberProduction: TMenuItem;
    miLine14: TMenuItem;
    miScaleIni_DB: TMenuItem;
    miScaleIni_BI: TMenuItem;
    miScaleIni_Zeus: TMenuItem;
    miScaleIni_BI_R: TMenuItem;
    miLine15: TMenuItem;
    miScaleRun_DB: TMenuItem;
    miScaleRun_BI: TMenuItem;
    miScaleRun_Zeus: TMenuItem;
    miScaleRun_BI_R: TMenuItem;
    OperDateEdit: TcxDateEdit;
    spSelect: TdsdStoredProc;
    DS: TDataSource;
    CDS: TClientDataSet;
    infoPanelContract: TPanel;
    LabelContract: TLabel;
    PanelContract: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ButtonNewGetParamsClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure ButtonRefreshZakazClick(Sender: TObject);
    procedure PanelWeight_ScaleDblClick(Sender: TObject);
  private
    Scale_BI: TCasBI;
    Scale_DB: TCasDB;

    function GetParams_MovementDesc:Boolean;
    function GetParams_Goods:Boolean;
    procedure Initialize_Scale;
    function fGetScale_CurrentWeight:Double;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;


implementation
{$R *.dfm}
uses DMMainScale, UtilScale, UtilConst, DialogMovementDesc, GuideGoods,UtilPrint;
//------------------------------------------------------------------------------------------------
function TMainForm.GetParams_MovementDesc:Boolean;
begin
     Result:=DialogMovementDescForm.Execute;
     if Result then
     with ParamsMovement do
     begin
          PanelMovementDesc.Caption:=ParamByName('MovementDescName_master').asString;
          PanelPriceList.Caption:=ParamByName('PriceListName').asString;

          if ParamByName('calcPartnerId').AsInteger<>0
          then PanelPartner.Caption:='  ('+IntToStr(ParamByName('calcPartnerCode').asInteger)+') '+ParamByName('calcPartnerName').asString
          else PanelPartner.Caption:='';

          if ParamByName('ContractId').AsInteger<>0
          then PanelContract.Caption:='  ('+ParamByName('ContractCode').asString+')'
                                     +' � '+ParamByName('ContractNumber').asString
                                     +' '+ParamByName('ContractTagName').asString
                                     //+'  ('+ParamByName('PaidKindName').asString+')'
          else PanelContract.Caption:='';

          if ParamByName('OrderExternalId').AsInteger<>0
          then PanelOrderExternal.Caption:='  '+ParamByName('OrderExternalName_master').asString
          else PanelOrderExternal.Caption:='';
     end;
end;
{------------------------------------------------------------------------}
function TMainForm.GetParams_Goods:Boolean;
var GoodsWeight_two,GoodsWeight_set:Double;
    calcClientId:Integer;
begin
     if ParamsMovement.ParamByName('MovementDescId').asInteger=0
     then if not GetParams_MovementDesc then exit;

     if GuideGoodsForm.Execute(1, ParamsMovement.ParamByName('OperDate').AsDateTime)
     then begin

     end;
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonNewGetParamsClick(Sender: TObject);
begin
     GetParams_Goods;
end;

//------------------------------------------------------------------------------------------------
procedure TMainForm.ButtonRefreshZakazClick(Sender: TObject);
begin
    PrintSale(StrToInt(EnterGoodsCodeScanerEdit.Text));
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
begin
  //global Initialize
  gpInitialize_Const;
  //global Initialize Array
  Default_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'Default');
  Service_Array:=       DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'Service');

  PriceList_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'PriceList');
  TareCount_Array:=     DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'TareCount');
  TareWeight_Array:=    DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'TareWeight');
  ChangePercent_Array:= DMMainScaleForm.gpSelect_ToolsWeighing_onLevelChild(SettingMain.ScaleNum,'ChangePercent');
  GoodsKind_Array:=     DMMainScaleForm.gpSelect_Scale_GoodsKindWeighing;
  //global Initialize
  Create_ParamsMovement(ParamsMovement);
  //global Initialize
  Scale_DB:=TCasDB.Create(self);
  Scale_BI:=TCasBI.Create(self);
  Initialize_Scale;
  //
  //local Movement Initialize
  ParamsMovement.ParamByName('MovementNumber').AsString:=GetArrayList_Value_byName(Default_Array,'MovementNumber');
  //local Movement Initialize
  OperDateEdit.Text:=DateToStr(gpInitialize_OperDate(ParamsMovement));
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.Initialize_Scale;
begin
     if SettingMain.BI = TRUE
     then
          // !!! SCALE BI !!!
          try
             Scale_BI.Active := 0;
             Scale_BI.CommPort:=SettingMain.ComPort;
             Scale_BI.CommSpeed := 9600;//NEW!!!
             Scale_BI.Active := 1;//NEW!!!
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='BI.Active = OK'
             else ScaleLabel.Caption:='BI.Active = Error';
          except
               ScaleLabel.Caption:='BI.Active = Error-ALL';
          end;

     if SettingMain.DB = TRUE
     then try
             // !!! SCALE DB !!!
             Scale_DB.Active:=0;
             Scale_DB.CommPort:=SettingMain.ComPort;
             Scale_DB.Active := 1;
             //
             if Scale_BI.Active=1
             then ScaleLabel.Caption:='DB.Active = OK'
             else ScaleLabel.Caption:='DB.Active = Error';
          except
             ScaleLabel.Caption:='DB.Active = Error-ALL';
         end;

     //
     PanelWeight_Scale.Caption:='';
end;
procedure TMainForm.PanelWeight_ScaleDblClick(Sender: TObject);
begin
   fGetScale_CurrentWeight;
end;

//------------------------------------------------------------------------------------------------
function TMainForm.fGetScale_CurrentWeight:Double;
begin
     // ��������� ����, ������ ����� ����� ���
     //Initialize_Scale_DB;
     // ���������� ����
     try
        if SettingMain.BI = TRUE
        then Result:=Scale_BI.Weight
             else if SettingMain.DB = TRUE
                  then Result:=Scale_DB.Weight
                  else Result:=0;
     except Result:=0;end;
     // ��������� ����
     // Scale_DB.Active:=0;
     //
//*****
     // if (_Weight_Main<>'')and(_beginUser=1) then Weight:=_Weight_Main;
//     Weight:='0,123456';
     PanelWeight_Scale.Caption:=FloatToStr(Result);
end;
//------------------------------------------------------------------------------------------------
procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     if Key = VK_F2 then GetParams_MovementDesc;
     if Key = VK_SPACE then GetParams_Goods;
     //
     if ShortCut(Key, Shift) = 24659 then
     begin
          gc_isDebugMode := not gc_isDebugMode;
          if gc_isDebugMode
          then ShowMessage('���������� ����� �������')
          else ShowMessage('���� ����� �������');
     end;
end;
{------------------------------------------------------------------------}
procedure TMainForm.ButtonExitClick(Sender: TObject);
begin Close;end;
{------------------------------------------------------------------------}
end.
