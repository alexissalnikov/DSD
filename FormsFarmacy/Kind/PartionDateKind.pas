unit PartionDateKind;

interface

uses
  cxPC, AncestorEnum, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, cxCheckBox,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdAddOn,
  dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient, dsdAction,
  System.Classes, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, Vcl.Controls, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, Vcl.Menus, cxCurrencyEdit;

type
  TPartionDateKindForm = class(TAncestorEnumForm)
    spUpdateObject: TdsdStoredProc;
    AmountMonth: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TPartionDateKindForm);

end.
