unit dbObjectTest;

interface
uses Classes, TestFramework, Authentication, Db, XMLIntf, dsdDB, dbTest;

type

  TObjectTest = class
  private
    FspInsertUpdate: string;
    FspSelect: string;
    FspGet: string;
    // ������ ����������� Id
    FInsertedIdList: TStringList;
  protected
    FdsdStoredProc: TdsdStoredProc;
    FParams: TdsdParams;
    property spGet: string read FspGet write FspGet;
    property spSelect: string read FspSelect write FspSelect;
    property spInsertUpdate: string read FspInsertUpdate write FspInsertUpdate;
    function InsertUpdate(dsdParams: TdsdParams): Integer;
    function InsertDefault: integer; virtual; abstract;
    procedure SetDataSetParam; virtual;
    procedure DeleteObject(Id: Integer);
  public
    function GetDefault: integer;
    function GetDataSet: TDataSet; virtual;
    function GetRecord(Id: integer): TDataSet;
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); virtual;
    constructor Create; virtual;
    destructor Destoy;
  end;

  TdbObjectTest = class (TdbTest)
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ��� ������������
    procedure TearDown; override;

    function GetRecordCount(ObjectTest: TObjectTest): integer;

  published
    procedure Bank_Test;
    procedure BankAccount_Test;
    procedure Branch_Test;
    procedure Business_Test;
    procedure Cash_Test;
    procedure CarModel_Test;
    procedure Car_Test;
    procedure Contract_Test;
    procedure ContractKind_Test;
    procedure Goods_Test;
    procedure GoodsGroup_Test;
    procedure GoodsKind_Test;
    procedure GoodsProperty_Test;
    procedure GoodsPropertyValue_Test;
    procedure JuridicalGroup_Test;
    procedure Juridical_Test;
    procedure Measure_Test;
    procedure PaidKind_Test;
    procedure Partner_Test;
    procedure PriceList_Test;
    procedure Route_Test;
    procedure RouteSorting_Test;
    procedure User_Test;
    procedure AccountGroup_Test;
    procedure AccountDirection_Test;
    procedure Account_Test;
    procedure ProfitLossGroup_Test;
    procedure ProfitLossDirection_Test;
    procedure ProfitLoss_Test;
    procedure InfoMoneyGroup_Test;
    procedure InfoMoneyDestination_Test;
    procedure InfoMoney_Test;
    procedure Member_Test;
    procedure Position_Test;
    procedure Personal_Test;
    procedure AssetGroup_Test;
    procedure Asset_Test;
    procedure ReceiptCost_Test;
    procedure ReceiptChild_Test;
    procedure Receipt_Test;
   end;

  TBankTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateBank(const Id, Code: Integer; Name: string; MFO: string; JuridicalId: integer): integer;
    constructor Create; override;
  end;

  TCashTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateCash(const Id, Code : integer; CashName: string; CurrencyId: Integer;
                                     BranchId, PaidKindId: integer): integer;
    constructor Create; override;
  end;

  TContractTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContract(const Id: integer; InvNumber, Comment: string): integer;
    constructor Create; override;
  end;

  TCurrencyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    constructor Create; override;
  end;

  TGoodsTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoods(Id, Code: Integer; Name: String;
                               GoodsGroupId, MeasureId, TradeMarkId,ItemInfoMoneyId: Integer; Weight: Double): integer;
    constructor Create; override;
  end;

  TGoodsPropertyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsProperty(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TGoodsPropertyValueTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateGoodsPropertyValue(const Id: Integer; Name: string;
        Amount: double; BarCode, Article, BarCodeGLN, ArticleGLN: string;
        GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TPartnerTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdatePartner(const Id: integer; Code: Integer;
        Name, GLNCode: string; JuridicalId, RouteId, RouteSortingId: integer): integer;
    constructor Create; override;
  end;

  TJuridicalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // ��������� ������ � ��� �����������
   procedure Delete(Id: Integer); override;
   function InsertUpdateJuridical(const Id: integer; Code: Integer;
        Name, GLNCode: string; isCorporate: boolean; JuridicalGroupId, GoodsPropertyId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;

  TJuridicalGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateJuridicalGroup(const Id, Code: Integer; Name: string; JuridicalGroupId: integer): integer;
    constructor Create; override;
  end;

  TPriceListTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceList(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TRouteTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRoute(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TRouteSortingTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRouteSorting(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TPaidKindTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePaidKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TContractKindTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContractKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TBusinessTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBusiness(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TBranchTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   // ��������� ������ � ��� �����������
   procedure Delete(Id: Integer); override;
   function InsertUpdateBranch(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TGoodsGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

  TGoodsKindTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsKind(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TMeasureTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateMeasure(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TBankAccountTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
     // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateBankAccount(Id, Code: Integer; Name: String;
                            JuridicalId, BankId, CurrencyId: Integer): integer;
    constructor Create; override;
  end;

  TCarModelTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateCarModel(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TCarTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateCar(const Id, Code : integer; Name, RegistrationCertificateId: string; CarModelId: Integer): integer;
    constructor Create; override;
  end;

  TUserTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
    constructor Create; override;
  end;

  TAccountGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TAccountDirectionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountDirection(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TAccountTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateAccount(const Id, Code : integer; Name: string; AccountGroupId: Integer;
                                     AccountDirectionId, InfoMoneyDestinationId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;

  TProfitLossGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TProfitLossDirectionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossDirection(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TProfitLossTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateProfitLoss(const Id, Code : integer; Name: string; ProfitLossGroupId: Integer;
                                     ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;

  TInfoMoneyGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TInfoMoneyDestinationTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyDestination(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TInfoMoneyTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateInfoMoney(const Id, Code : integer; Name: string; InfoMoneyGroupId: Integer;
                                     InfoMoneyDestinationId: integer): integer;
    constructor Create; override;
  end;

  TMemberTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateMember(const Id, Code : integer; Name, INN: string): integer;
    constructor Create; override;
  end;

  TPositionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdatePosition(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

  TPersonalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // ��������� ������ � ��� �����������
   procedure Delete(Id: Integer); override;
   function InsertUpdatePersonal(const Id: integer; Code: Integer; Name: string;
    MemberId, PositionId, UnitId, JuridicalId, BusinessId: integer; DateIn,DateOut: TDateTime): integer;
    constructor Create; override;
  end;

  TAssetGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateAssetGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

  TAssetTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    // ��������� ������ � ��� �����������
    procedure Delete(Id: Integer); override;
    function InsertUpdateAsset(const Id, Code : integer; Name, InvNumber: string; AssetGroupId: Integer): integer;
    constructor Create; override;
  end;

  TReceiptCostTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateReceiptCost(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

  TReceiptChildTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // ��������� ������ � ��� �����������
   procedure Delete(Id: Integer); override;
   function InsertUpdateReceiptChild(const Id: integer; Value: Double; Weight, TaxExit: boolean;
                                     StartDate, EndDate: TDateTime; Comment: string;
                                     ReceiptId, GoodsId, GoodsKindId: integer): integer;
    constructor Create; override;
  end;

  TReceiptTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // ��������� ������ � ��� �����������
   procedure Delete(Id: Integer); override;
   function InsertUpdateReceipt(const Id: integer; Name, Code, Comment: string;
                                Value, ValueCost, TaxExit, PartionValue, PartionCount, WeightPackage: Double;
                                StartDate, EndDate: TDateTime;
                                Main: boolean;
                                GoodsId, GoodsKindId, GoodsKindCompleteId, ReceiptCostId, ReceiptKindId: integer): integer;
    constructor Create; override;
  end;

 implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, ZLibEx, zLibUtil,

     UnitsTest;


{ TObjectTest }

constructor TObjectTest.Create;
begin
  FdsdStoredProc := TdsdStoredProc.Create(nil);
  FParams := TdsdParams.Create(TdsdParam);
  FInsertedIdList := TStringList.Create;
end;

procedure TObjectTest.DeleteObject(Id: Integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Object OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Object>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

procedure TObjectTest.Delete;
begin
  // ����� �� ��������� ������� ������ ����������� � ������ ����� ������
  DeleteObject(Id);
end;

destructor TObjectTest.Destoy;
var i: integer;
begin
  FdsdStoredProc.Free;
  // ������� �����������, �� �� ��������� � ������ ����� ���������.
//  for i := 0 to FInsertedIdList. do

end;

function TObjectTest.GetDataSet: TDataSet;
begin
  with FdsdStoredProc do begin
    if (DataSets.Count = 0) or not Assigned(DataSets[0].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspSelect;
    OutputType := otDataSet;
    FParams.Clear;
    SetDataSetParam;
    Params.Assign(FParams);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.GetDefault: integer;
begin
  if GetDataSet.RecordCount > 0 then
     result := GetDataSet.FieldByName('Id').AsInteger
  else
     result := InsertDefault;
end;

function TObjectTest.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.InsertUpdate(dsdParams: TdsdParams): Integer;
begin
  with FdsdStoredProc do begin
    StoredProcName := FspInsertUpdate;
    OutputType := otResult;
    Params.Assign(dsdParams);
    Execute;
    Result := StrToInt(ParamByName('ioId').Value);
  end;
end;

procedure TObjectTest.SetDataSetParam;
begin
  FdsdStoredProc.Params.Clear;
end;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbObjectTest.Cash_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCashTest;
begin
  ObjectTest := TCashTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = '������� �����'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

    // ������� ������ ����
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;
{------------------------------------------------------------------------------}
function TdbObjectTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin
  Result := ObjectTest.GetDataSet.RecordCount;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.GoodsPropertyValue_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsPropertyValueTest;
begin
  ObjectTest := TGoodsPropertyValueTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'GoodsPropertyValue'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Goods_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsTest;
begin
  ObjectTest := TGoodsTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.User_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUserTest;
begin
  ObjectTest := TUserTest.Create;
  // ������� ������ �������������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'UserName'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
    // �������� �� �������������
    try
      ObjectTest.InsertUpdateUser(0, 'UserName', 'Login', 'Password');
      Check(false, '��� ��������� �� ������ InsertUpdate_Object_User Id=0');
    except

    end;
    // ��������� ������������

    // ������� ������ �������������
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), '���������� ������� �� ����������');
  finally
    ObjectTest.Delete(Id);
  end;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.TearDown;
begin
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', '�����', gc_User);
end;
{------------------------------------------------------------------------------}

{ TCurrencyTest }

constructor TCurrencyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Currency';
  spSelect := 'gpSelect_Object_Currency';
  spGet := 'gpGet_Object_Currency';
end;

function TCurrencyTest.InsertDefault: integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('inCurrencyCode', ftInteger, ptInput, 920);
  FParams.AddParam('inCurrencyName', ftString, ptInput, 'GRN');
  FParams.AddParam('inFullName', ftString, ptInput, '������');
  result := InsertUpdate(FParams);
end;

{ TUserTest }

constructor TUserTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_User';
  spSelect := 'gpSelect_Object_User';
  spGet := 'gpGet_Object_User';
end;

function TUserTest.InsertDefault: integer;
begin
  result := InsertUpdateUser(0, 'UserName', 'Login', 'Password');
end;

function TUserTest.InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inUserName', ftString, ptInput, UserName);
  FParams.AddParam('inLogin', ftString, ptInput, Login);
  FParams.AddParam('inPassword', ftString, ptInput, Password);
  result := InsertUpdate(FParams);
end;

{ TCashTest }

constructor TCashTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_Cash';
  spSelect := 'gpSelect_Object_Cash';
  spGet := 'gpGet_Object_Cash';
end;

procedure TCashTest.Delete(Id: Integer);
begin
  inherited;
  with TCurrencyTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
  with TBranchTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
  with TPaidKindTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
end;

function TCashTest.InsertDefault: integer;
var CurrencyId, BranchId, PaidKindId: Integer;
begin
  with TCurrencyTest.Create do
  try
    CurrencyId := GetDefault
  finally
    Free;
  end;
  with TBranchTest.Create do
  try
    BranchId := GetDefault
  finally
    Free;
  end;
  with TPaidKindTest.Create do
  try
    PaidKindId := GetDefault
  finally
    Free;
  end;
  result := InsertUpdateCash(0, 3, '������� �����', CurrencyId, BranchId, PaidKindId);
end;

function TCashTest.InsertUpdateCash(const Id, Code: integer; CashName: string;
  CurrencyId, BranchId, PaidKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inCashName', ftString, ptInput, CashName);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
  result := InsertUpdate(FParams);
end;


{ TJuridicalGroupTest }
constructor TJuridicalGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_JuridicalGroup';
  spSelect := 'gpSelect_Object_JuridicalGroup';
  spGet := 'gpGet_Object_JuridicalGroup';
end;

function TJuridicalGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateJuridicalGroup(0, 1, '������ �� ��� 1', 0);
end;

function TJuridicalGroupTest.InsertUpdateJuridicalGroup(const Id, Code: Integer;
  Name: string; JuridicalGroupId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  result := InsertUpdate(FParams);
end;

{ TGoodsPropertyTest }

constructor TGoodsPropertyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsProperty';
  spSelect := 'gpSelect_Object_GoodsProperty';
  spGet := 'gpGet_Object_GoodsProperty';
end;

function TGoodsPropertyTest.InsertDefault: integer;
begin
  result := InsertUpdateGoodsProperty(0, 1, '������������� ������� �������');
end;

function TGoodsPropertyTest.InsertUpdateGoodsProperty(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

  {TRouteTest }
constructor TRouteTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Route';
  spSelect := 'gpSelect_Object_Route';
  spGet := 'gpGet_Object_Route';
end;

function TRouteTest.InsertDefault: integer;
begin
  result := InsertUpdateRoute(0, 1, '�������');
end;

function TRouteTest.InsertUpdateRoute(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

  {TRouteSortingTest }
constructor TRouteSortingTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_RouteSorting';
  spSelect := 'gpSelect_Object_RouteSorting';
  spGet := 'gpGet_Object_RouteSorting';
end;

function TRouteSortingTest.InsertDefault: integer;
begin
  result := InsertUpdateRouteSorting(0, 1, '���������� ���������');
end;

function TRouteSortingTest.InsertUpdateRouteSorting(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

    {TBankTest }
 constructor TBankTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Bank';
  spSelect := 'gpSelect_Object_Bank';
  spGet := 'gpGet_Object_Bank';
end;

procedure TBankTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TBankTest.InsertDefault: integer;
var
  JuridicalId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  result := InsertUpdateBank(0, -1, '����', '���', JuridicalId)
end;

function TBankTest.InsertUpdateBank;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMFO', ftString, ptInput, MFO);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  result := InsertUpdate(FParams);
end;

    { TPartnerTest }
 constructor TPartnerTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Partner';
  spSelect := 'gpSelect_Object_Partner';
  spGet := 'gpGet_Object_Partner';
end;

procedure TPartnerTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TRouteTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TRouteSortingTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TPartnerTest.InsertDefault: integer;
var
  JuridicalId, RouteId, RouteSortingId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  RouteId := TRouteTest.Create.GetDefault;
  RouteSortingId := TRouteSortingTest.Create.GetDefault;
  result := InsertUpdatePartner(0, -1, '�����������', 'GLNCode', JuridicalId, RouteId, RouteSortingId);
end;

function TPartnerTest.InsertUpdatePartner;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);
  result := InsertUpdate(FParams);
end;

    { TJuridicalTest }
 constructor TJuridicalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Juridical';
  spSelect := 'gpSelect_Object_Juridical';
  spGet := 'gpGet_Object_Juridical';
end;

procedure TJuridicalTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TGoodsPropertyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TInfoMoneyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TJuridicalTest.InsertDefault: integer;
var
  JuridicalGroupId, GoodsPropertyId, InfoMoneyId: Integer;
begin
  JuridicalGroupId := TJuridicalGroupTest.Create.GetDefault;
  GoodsPropertyId := TGoodsPropertyTest.Create.GetDefault;
  InfoMoneyId:= TInfoMoneyTest.Create.GetDefault;;
  result := InsertUpdateJuridical(0, -1, '��. ����', 'GLNCode', true, JuridicalGroupId, GoodsPropertyId, InfoMoneyId)
end;

function TJuridicalTest.InsertUpdateJuridical;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('isCorporate', ftBoolean, ptInput, isCorporate);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

{ TDataBaseUsersObjectTest }

procedure TdbObjectTest.JuridicalGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalGroupTest;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TJuridicalGroupTest.Create;
  // ������� ������ ��������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateJuridicalGroup(Id, 1, '������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateJuridicalGroup(0, 2, '������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateJuridicalGroup(Id, 1, '������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateJuridicalGroup(0, 3, '������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateJuridicalGroup(Id, 1, '������ 1', Id3);
          Check(false, '��� ��������� �� ������');
        except

        end;
        Check((GetRecordCount(ObjectTest) = RecordCount + 3), '���������� ������� �� ����������');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Juridical_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalTest;
begin
  ObjectTest := TJuridicalTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('GLNCode').AsString = 'GLNCode'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.PriceList_Test;
begin

end;

procedure TdbObjectTest.Bank_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBankTest;
begin
  ObjectTest := TBankTest.Create;
  // ��������� ���������� Get ��� 0 ������
  ObjectTest.GetRecord(0);
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Contract_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContractTest;
begin
  ObjectTest := TContractTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �� ����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('InvNumber').AsString = '123456'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Route_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRouteTest;
begin
  ObjectTest := TRouteTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.RouteSorting_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRouteSortingTest;
begin
  ObjectTest := TRouteSortingTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �� ����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���������� ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '���������� ���������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Partner_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPartnerTest;
begin
  ObjectTest := TPartnerTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �����������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �����������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('GLNCode').AsString = 'GLNCode'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TContractTest }
 constructor TContractTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Contract';
  spSelect := 'gpSelect_Object_Contract';
  spGet := 'gpGet_Object_Contract';
end;

function TContractTest.InsertDefault: integer;
begin
  result := InsertUpdateContract(0, '123456', 'comment');
end;

function TContractTest.InsertUpdateContract(const Id: integer; InvNumber,
  Comment: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
  result := InsertUpdate(FParams);
end;


{ TGoodsTest }

constructor TGoodsTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Goods';
  spSelect := 'gpSelect_Object_Goods';
  spGet := 'gpGet_Object_Goods';
end;

function TGoodsTest.InsertDefault: integer;
begin
  result := InsertUpdateGoods(0, -1, '����� 1', 0, 0, 0, 0, 1.0)
end;

function TGoodsTest.InsertUpdateGoods(Id, Code: Integer; Name: String;
  GoodsGroupId, MeasureId, TradeMarkId, ItemInfoMoneyId: Integer; Weight: Double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGoodsGroupId', ftInteger, ptInput, GoodsGroupId);
  FParams.AddParam('inMeasureId', ftInteger, ptInput, MeasureId);
  FParams.AddParam('inTradeMarkId', ftInteger, ptInput, TradeMarkId);
  FParams.AddParam('inItemInfoMoneyId', ftInteger, ptInput, ItemInfoMoneyId);
  FParams.AddParam('inWeight', ftFloat, ptInput, Weight);
  result := InsertUpdate(FParams);
end;

{ TGoodsPropertyValueTest }
constructor TGoodsPropertyValueTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsPropertyValue';
  spSelect := 'gpSelect_Object_GoodsPropertyValue';
  spGet := 'gpGet_Object_GoodsPropertyValue';
end;

procedure TGoodsPropertyValueTest.Delete(Id: Integer);
begin
  inherited;
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TGoodsPropertyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TGoodsPropertyValueTest.InsertDefault: integer;
var
  GoodsPropertyId, GoodsId, GoodsKindId: Integer;
begin
  GoodsId := TGoodsTest.Create.GetDefault;
  GoodsPropertyId := TGoodsPropertyTest.Create.GetDefault;
  GoodsKindId := 0;
  result := InsertUpdateGoodsPropertyValue(0, 'GoodsPropertyValue', 10,
         'BarCode', 'Article', 'BarCodeGLN', 'ArticleGLN',
         GoodsPropertyId, GoodsId, GoodsKindId)
end;

function TGoodsPropertyValueTest.InsertUpdateGoodsPropertyValue(
  const Id: Integer; Name: string; Amount: double; BarCode, Article, BarCodeGLN,
  ArticleGLN: string; GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inBarCode', ftString, ptInput, BarCode);
  FParams.AddParam('inArticle', ftString, ptInput, Article);
  FParams.AddParam('inBarCodeGLN', ftString, ptInput, BarCodeGLN);
  FParams.AddParam('inArticleGLN', ftString, ptInput, ArticleGLN);

  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);

  result := InsertUpdate(FParams);
end;

{ TPriceListTest }

constructor TPriceListTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PriceList';
  spSelect := 'gpSelect_Object_PriceList';
  spGet := 'gpGet_Object_PriceList';
end;

function TPriceListTest.InsertDefault: integer;
begin
  result := InsertUpdatePriceList(0, 1, '�����-����');
end;

function TPriceListTest.InsertUpdatePriceList(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

{TPaidKindTest}
constructor TPaidKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PaidKind';
  spSelect := 'gpSelect_Object_PaidKind';
  spGet := 'gpGet_Object_PaidKind';
end;

function TPaidKindTest.InsertDefault: integer;
begin
  result := InsertUpdatePaidKind(0, 3, '��� ����� ������');
end;

function TPaidKindTest.InsertUpdatePaidKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.PaidKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPaidKindTest;
begin
  ObjectTest := TPaidKindTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ���� ����� ������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���� ����� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��� ����� ������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TContractKindTest}
constructor TContractKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ContractKind';
  spSelect := 'gpSelect_Object_ContractKind';
  spGet := 'gpGet_Object_ContractKind';
end;

function TContractKindTest.InsertDefault: integer;
begin
  result := InsertUpdateContractKind(0, 1, '��� ��������');
end;

function TContractKindTest.InsertUpdateContractKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ContractKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContractKindTest;
begin
  ObjectTest := TContractKindTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ���� ��������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���� ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��� ��������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TBusinessTest}
constructor TBusinessTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Business';
  spSelect := 'gpSelect_Object_Business';
  spGet := 'gpGet_Object_Business';
end;

function TBusinessTest.InsertDefault: integer;
begin
  result := InsertUpdateBusiness(0, 1, '������');
end;

function TBusinessTest.InsertUpdateBusiness;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Business_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBusinessTest;
begin
  ObjectTest := TBusinessTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TBranchTest}
 constructor TBranchTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Branch';
  spSelect := 'gpSelect_Object_Branch';
  spGet := 'gpGet_Object_Branch';
end;

procedure TBranchTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
end;

function TBranchTest.InsertDefault: integer;
begin
  result := InsertUpdateBranch(0, 1, '������');
  //FInsertedId := result;
end;

function TBranchTest.InsertUpdateBranch;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Branch_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBranchTest;
begin
  ObjectTest := TBranchTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TGoodsGroupTest}
constructor TGoodsGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsGroup';
  spSelect := 'gpSelect_Object_GoodsGroup';
  spGet := 'gpGet_Object_GoodsGroup';
end;

function TGoodsGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateGoodsGroup(0, 1, '������ ������', ParentId);
end;

function TGoodsGroupTest.InsertUpdateGoodsGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.GoodsGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsGroupTest;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TGoodsGroupTest.Create;
  // ������� ������ ��������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateGoodsGroup(0, 2, '������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateGoodsGroup(0, 3, '������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateGoodsGroup(Id, 1, '������ 1', Id3);
          Check(false, '��� ��������� �� ������');
        except

        end;
        Check((GetRecordCount(ObjectTest) = RecordCount + 3), '���������� ������� �� ����������');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TGoodsKindTest}
constructor TGoodsKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsKind';
  spSelect := 'gpSelect_Object_GoodsKind';
  spGet := 'gpGet_Object_GoodsKind';
end;

function TGoodsKindTest.InsertDefault: integer;
begin
  result := InsertUpdateGoodsKind(0, 1, '��� ������');
end;

function TGoodsKindTest.InsertUpdateGoodsKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.GoodsKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsKindTest;
begin
  ObjectTest := TGoodsKindTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ���� ������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��� ������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TMeasureTest}
constructor TMeasureTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Measure';
  spSelect := 'gpSelect_Object_Measure';
  spGet := 'gpGet_Object_Measure';
end;

function TMeasureTest.InsertDefault: integer;
begin
  result := InsertUpdateMeasure(0, 1, '������� ���������');
end;

function TMeasureTest.InsertUpdateMeasure;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Measure_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMeasureTest;
begin
  ObjectTest := TMeasureTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������� ���������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������� ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������� ���������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TGoodsPropertyTest}
procedure TdbObjectTest.GoodsProperty_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsPropertyTest;
begin
  ObjectTest := TGoodsPropertyTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������������� ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������������� ������� �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������������� ������� �������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;


 {TBankAccountTest}
 constructor TBankAccountTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_BankAccount';
  spSelect := 'gpSelect_Object_BankAccount';
  spGet := 'gpGet_Object_BankAccount';
end;

procedure TBankAccountTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TBankTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TCurrencyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
end;

function TBankAccountTest.InsertDefault: integer;
var
  JuridicalId, BankId, CurrencyId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  BankId:= TBankTest.Create.GetDefault;
  CurrencyId:= TCurrencyTest.Create.GetDefault;

  result := InsertUpdateBankAccount(0, -1, '��������� ����', JuridicalId, BankId, CurrencyId);
end;

function TBankAccountTest.InsertUpdateBankAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.BankAccount_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBankAccountTest;
begin
  ObjectTest := TBankAccountTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� ����'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TCarModelTest}
constructor TCarModelTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_CarModel';
  spSelect := 'gpSelect_Object_CarModel';
  spGet := 'gpGet_Object_CarModel';
end;

function TCarModelTest.InsertDefault: integer;
begin
  result := InsertUpdateCarModel(0, 1, '����� ����������');
end;

function TCarModelTest.InsertUpdateCarModel;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.CarModel_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCarModelTest;
begin
  ObjectTest := TCarModelTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ����� ����������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������� ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����� ����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TCarTest}
 constructor TCarTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Car';
  spSelect := 'gpSelect_Object_Car';
  spGet := 'gpGet_Object_Car';
end;

procedure TCarTest.Delete(Id: Integer);
begin
  inherited;
  with TCarModelTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
 end;

function TCarTest.InsertDefault: integer;
var
  CarModelId: Integer;
begin
  CarModelId := TCarModelTest.Create.GetDefault;
  result := InsertUpdateCar(0, 1, '����������', '�� ��', CarModelId);
end;

function TCarTest.InsertUpdateCar;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('RegistrationCertificateId', ftString, ptInput, RegistrationCertificateId);
  FParams.AddParam('inCarModelId', ftInteger, ptInput, CarModelId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Car_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCarTest;
begin
  ObjectTest := TCarTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ����������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � �������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TAccountGroupTest }
constructor TAccountGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountGroup';
  spSelect := 'gpSelect_Object_AccountGroup';
  spGet := 'gpGet_Object_AccountGroup';
end;

function TAccountGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateAccountGroup(0, 4, '������ �������������� ������ 1');
end;

function TAccountGroupTest.InsertUpdateAccountGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AccountGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountGroupTest;
begin
  ObjectTest := TAccountGroupTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������ �������������� ������ 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TAccountDirectionTest }
constructor TAccountDirectionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountDirection';
  spSelect := 'gpSelect_Object_AccountDirection';
  spGet := 'gpGet_Object_AccountDirection';
end;

function TAccountDirectionTest.InsertDefault: integer;
begin
  result := InsertUpdateAccountDirection(0, 4, '��������� �������������� ������ 1');
end;

function TAccountDirectionTest.InsertUpdateAccountDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AccountDirection_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountDirectionTest;
begin
  ObjectTest := TAccountDirectionTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� �������������� ������ 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAccountTest}
 constructor TAccountTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Account';
  spSelect := 'gpSelect_Object_Account';
  spGet := 'gpGet_Object_Account';
end;

procedure TAccountTest.Delete(Id: Integer);
begin
  inherited;
  with TAccountGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TAccountDirectionTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;

 end;

function TAccountTest.InsertDefault: integer;
var
  AccountGroupId: Integer;
  AccountDirectionId: Integer;
 // InfoMoneyDestinationId: Integer;
 // InfoMoneyId: Integer;
begin
  AccountGroupId := TAccountGroupTest.Create.GetDefault;
  AccountDirectionId:= TAccountDirectionTest.Create.GetDefault;;
  result := InsertUpdateAccount(0, -3, 'Test - �������������� ���� 1', AccountGroupId, AccountDirectionId, 1,1);
end;

function TAccountTest.InsertUpdateAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inAccountGroupId', ftInteger, ptInput, AccountGroupId);
  FParams.AddParam('inAccountDirectionId', ftInteger, ptInput, AccountDirectionId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  //FParams.AddParam('inAccountKindId', ftInteger, ptInput, AccountKindId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Account_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountTest;
begin
  ObjectTest := TAccountTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ��������������� �����
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���.�����
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Test - �������������� ���� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TProfitLossGroupTest }
constructor TProfitLossGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossGroup';
  spSelect := 'gpSelect_Object_ProfitLossGroup';
  spGet := 'gpGet_Object_ProfitLossGroup';
end;

function TProfitLossGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossGroup(0, 4, '������ ������ ������ � �������� � ������� 1');
end;

function TProfitLossGroupTest.InsertUpdateProfitLossGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLossGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossGroupTest;
begin
  ObjectTest := TProfitLossGroupTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������ ������ ������ � �������� � ������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TProfitLossDirectionTest }
constructor TProfitLossDirectionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossDirection';
  spSelect := 'gpSelect_Object_ProfitLossDirection';
  spGet := 'gpGet_Object_ProfitLossDirection';
end;

function TProfitLossDirectionTest.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossDirection(0, 1, '��������� ������ ������ � �������� � ������� - ����������� 1');
end;

function TProfitLossDirectionTest.InsertUpdateProfitLossDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLossDirection_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossDirectionTest;
begin
  ObjectTest := TProfitLossDirectionTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� ������ ������ � �������� � ������� - ����������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{TProfitLossTest}
 constructor TProfitLossTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLoss';
  spSelect := 'gpSelect_Object_ProfitLoss';
  spGet := 'gpGet_Object_ProfitLoss';
end;

procedure TProfitLossTest.Delete(Id: Integer);
begin
  inherited;
  with TProfitLossGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TProfitLossDirectionTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;

 end;

function TProfitLossTest.InsertDefault: integer;
var
  ProfitLossGroupId: Integer;
  ProfitLossDirectionId: Integer;
 // InfoMoneyDestinationId: Integer;
 // InfoMoneyId: Integer;
begin
  ProfitLossGroupId := TProfitLossGroupTest.Create.GetDefault;
  ProfitLossDirectionId:= TProfitLossDirectionTest.Create.GetDefault;;
  result := InsertUpdateProfitLoss(0, 3, '�������������� ���� 1', ProfitLossGroupId, ProfitLossDirectionId, 1, 1);
end;

function TProfitLossTest.InsertUpdateProfitLoss;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inProfitLossGroupId', ftInteger, ptInput, ProfitLossGroupId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLoss_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossTest;
begin
  ObjectTest := TProfitLossTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������������� ���� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TInfoMoneyGroupTest }
constructor TInfoMoneyGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyGroup';
  spSelect := 'gpSelect_Object_InfoMoneyGroup';
  spGet := 'gpGet_Object_InfoMoneyGroup';
end;

function TInfoMoneyGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyGroup(0, 4, '������ �������������� �������� 1');
end;

function TInfoMoneyGroupTest.InsertUpdateInfoMoneyGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoneyGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyGroupTest;
begin
  ObjectTest := TInfoMoneyGroupTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������ �������������� �������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TInfoMoneyDestinationTest }
constructor TInfoMoneyDestinationTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyDestination';
  spSelect := 'gpSelect_Object_InfoMoneyDestination';
  spGet := 'gpGet_Object_InfoMoneyDestination';
end;

function TInfoMoneyDestinationTest.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyDestination(0, 1, '�������������� ��������� - ����������');
end;

function TInfoMoneyDestinationTest.InsertUpdateInfoMoneyDestination(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoneyDestination_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyDestinationTest;
begin
  ObjectTest := TInfoMoneyDestinationTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������ ���.������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������������� ��������� - ����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TInfoMoneyTest}
 constructor TInfoMoneyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoney';
  spSelect := 'gpSelect_Object_InfoMoney';
  spGet := 'gpGet_Object_InfoMoney';
end;

procedure TInfoMoneyTest.Delete(Id: Integer);
begin
  inherited;
  with TInfoMoneyGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TInfoMoneyDestinationTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;

 end;

function TInfoMoneyTest.InsertDefault: integer;
var
  InfoMoneyGroupId: Integer;
  InfoMoneyDestinationId: Integer;
begin
  InfoMoneyGroupId := TInfoMoneyGroupTest.Create.GetDefault;
  InfoMoneyDestinationId:= TInfoMoneyDestinationTest.Create.GetDefault;;
  result := InsertUpdateInfoMoney(0, 3, '�������������� ��������� 1', InfoMoneyGroupId, InfoMoneyDestinationId);
end;

function TInfoMoneyTest.InsertUpdateInfoMoney;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInfoMoneyGroupId', ftInteger, ptInput, InfoMoneyGroupId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);

  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoney_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyTest;
begin
  ObjectTest := TInfoMoneyTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������������� ��������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TMemberTest }
constructor TMemberTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Member';
  spSelect := 'gpSelect_Object_Member';
  spGet := 'gpGet_Object_Member';
end;

function TMemberTest.InsertDefault: integer;
begin
  result := InsertUpdateMember(0, 1, '���������� ����','123');
end;

function TMemberTest.InsertUpdateMember(const Id, Code: Integer;
  Name, INN : string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inINN', ftString, ptInput, INN);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Member_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMemberTest;
begin
  ObjectTest := TMemberTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '���������� ����'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 { TPositionTest }
constructor TPositionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Position';
  spSelect := 'gpSelect_Object_Position';
  spGet := 'gpGet_Object_Position';
end;

function TPositionTest.InsertDefault: integer;
begin
  result := InsertUpdatePosition(0, 1, '���������');
end;

function TPositionTest.InsertUpdatePosition(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Position_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPositionTest;
begin
  ObjectTest := TPositionTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� ������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '���������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TPersonalTest}
 constructor TPersonalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Personal';
  spSelect := 'gpSelect_Object_Personal';
  spGet := 'gpGet_Object_Personal';
end;

procedure TPersonalTest.Delete(Id: Integer);
begin
  inherited;
  with TMemberTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TPositionTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
    {with TUnitTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;}
    with TJuridicalTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
    with TBusinessTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;

 end;

function TPersonalTest.InsertDefault: integer;
var
  MemberId: Integer;
  PositionId: Integer;
  UnitId: Integer;
  JuridicalId: Integer;
  BusinessId: Integer;
begin
  MemberId := TMemberTest.Create.GetDefault;
  PositionId := TPositionTest.Create.GetDefault;
  UnitId := TUnit.Create.GetDefault;
  JuridicalId := TJuridicalTest.Create.GetDefault;
  BusinessId := TBusinessTest.Create.GetDefault;
  result := InsertUpdatePersonal(0, 3, '���������', MemberId, PositionId, UnitId, JuridicalId, BusinessId, Date,Date);
end;

function TPersonalTest.InsertUpdatePersonal;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inDateIn', ftDateTime, ptInput, DateIn);
  FParams.AddParam('inDateOut', ftDateTime, ptInput, DateOut);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Personal_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPersonalTest;
begin
  ObjectTest := TPersonalTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '���������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetGroupTest}
constructor TAssetGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AssetGroup';
  spSelect := 'gpSelect_Object_AssetGroup';
  spGet := 'gpGet_Object_AssetGroup';
end;

function TAssetGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateAssetGroup(0, 1, '������ �������� �������', ParentId);
end;

function TAssetGroupTest.InsertUpdateAssetGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AssetGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TAssetGroupTest;
begin
 // ��� ���� ������ ��������� ������������ ������ � �������.
 // � ������ ������������.
  ObjectTest := TAssetGroupTest.Create;
  // ������� ������ ��������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
 // ��������� ������ 1
  Id := ObjectTest.InsertDefault;
  try
    // ������ ������ ������ �� ���� � ��������� ������
    try
      ObjectTest.InsertUpdateAssetGroup(Id, 1, '������ 1', Id);
      Check(false, '��� ��������� �� ������');
    except

    end;
    // ��������� ��� ������ 2
    // ������ � ������ 2 ������ �� ������ 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, 2, '������ 2', Id);
    try
      // ������ ������ ������ � ������ 1 �� ������ 2 � ��������� ������
      try
        ObjectTest.InsertUpdateAssetGroup(Id, 1, '������ 1', Id2);
        Check(false, '��� ��������� �� ������');
      except

      end;
      // ��������� ��� ������ 3
      // ������ � ������ 3 ������ �� ������ 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, 3, '������ 3', Id2);
      try
        // ������ 2 ��� ������ �� ������ 1
        // ������ � ������ 1 ������ �� ������ 3 � ��������� ������
        try
          ObjectTest.InsertUpdateAssetGroup(Id, 1, '������ 1', Id3);
          Check(false, '��� ��������� �� ������');
        except

        end;
        Check((GetRecordCount(ObjectTest) = RecordCount + 3), '���������� ������� �� ����������');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetTest}
constructor TAssetTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Asset';
  spSelect := 'gpSelect_Object_Asset';
  spGet := 'gpGet_Object_Asset';
end;

procedure TAssetTest.Delete(Id: Integer);
begin
  inherited;
  with TAssetGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
 end;

function TAssetTest.InsertDefault: integer;
var
  AssetGroupId: Integer;
begin
  AssetGroupId := TAssetGroupTest.Create.GetDefault;
  result := InsertUpdateAsset(0, -1, '�������� ��������', '��2323', AssetGroupId);
end;

function TAssetTest.InsertUpdateAsset;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inAssetGroupId', ftInteger, ptInput, AssetGroupId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Asset_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAssetTest;
begin
  ObjectTest := TAssetTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '�������� ��������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TReceiptCostTest}
constructor TReceiptCostTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptCost';
  spSelect := 'gpSelect_Object_ReceiptCost';
  spGet := 'gpGet_Object_ReceiptCost';
end;

function TReceiptCostTest.InsertDefault: integer;
begin
   result := InsertUpdateReceiptCost(0, -1, '������� � ����������');
end;

function TReceiptCostTest.InsertUpdateReceiptCost;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptCost_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptCostTest;
begin
  ObjectTest := TReceiptCostTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // ������� �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '������� � ����������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TReceiptChildTest}
 constructor TReceiptChildTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptChild';
  spSelect := 'gpSelect_Object_ReceiptChild';
  spGet := 'gpGet_Object_ReceiptChild';
end;

procedure TReceiptChildTest.Delete(Id: Integer);
begin
  inherited;
 { with TReceiptTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;  }
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TGoodsKindTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
end;

function TReceiptChildTest.InsertDefault: integer;
var
  //ReceipId: Integer;
  GoodsId, GoodsKindId: Integer;
begin
  //ReceipId := TReceipTest.Create.GetDefault;
  GoodsId:= TGoodsTest.Create.GetDefault;
  GoodsKindId:= TGoodsKindTest.Create.GetDefault;

  result := InsertUpdateReceiptChild(0, 123,true, true, date, date, '������������ �������� - ��������', 2, GoodsId, GoodsKindId);
end;

function TReceiptChildTest.InsertUpdateReceiptChild;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('Weight', ftBoolean, ptInput, Weight);
  FParams.AddParam('TaxExit', ftBoolean, ptInput, TaxExit);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('inReceiptId', ftInteger, ptInput, ReceiptId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptChild_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptChildTest;
begin
  ObjectTest := TReceiptChildTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ������������ ��������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Comment').AsString = '������������ �������� - ��������'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


 {TReceiptTest}
 constructor TReceiptTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Receipt';
  spSelect := 'gpSelect_Object_Receipt';
  spGet := 'gpGet_Object_Receipt';
end;

procedure TReceiptTest.Delete(Id: Integer);
begin
  inherited;
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TGoodsKindTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  {with TGoodsKindCompleteTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;}
  with TReceiptCostTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  {with TReceiptKindTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;}
end;

function TReceiptTest.InsertDefault: integer;
var
  //ReceipId: Integer;
  GoodsId, GoodsKindId, ReceiptCostId: Integer;
begin
  ReceiptCostId := TReceiptCostTest.Create.GetDefault;
  GoodsId:= TGoodsTest.Create.GetDefault;
  GoodsKindId:= TGoodsKindTest.Create.GetDefault;

  result := InsertUpdateReceipt(0, '��������� 1', '123', '���������', 1, 2, 80, 2, 1,1 , date, date, true, GoodsId, GoodsKindId, 1, ReceiptCostId, 1);
end;

function TReceiptTest.InsertUpdateReceipt;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Name', ftString, ptInput, Name);
  FParams.AddParam('Code', ftString, ptInput, Code);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('ValueCost', ftFloat, ptInput, ValueCost);
  FParams.AddParam('TaxExit', ftFloat, ptInput, TaxExit);
  FParams.AddParam('PartionValue', ftFloat, ptInput, PartionValue);
  FParams.AddParam('PartionCount', ftFloat, ptInput, PartionCount);
  FParams.AddParam('WeightPackage', ftFloat, ptInput, WeightPackage);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Main', ftBoolean, ptInput, Main);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inGoodsKindCompleteId', ftInteger, ptInput, GoodsKindCompleteId);
  FParams.AddParam('inReceiptCostId', ftInteger, ptInput, ReceiptCostId);
  FParams.AddParam('inReceiptKindId', ftInteger, ptInput, ReceiptKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Receipt_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptTest;
begin
  ObjectTest := TReceiptTest.Create;
  // ������� ������
  RecordCount := GetRecordCount(ObjectTest);
  // �������
  Id := ObjectTest.InsertDefault;
  try
    // ��������� ������ � ���������
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = '��������� 1'), '�� �������� ������ Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('�������', TdbObjectTest.Suite);

end.
