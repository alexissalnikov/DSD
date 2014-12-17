unit ProductionUnionTechEdit;

interface

uses
   AncestorEditDialog, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Vcl.Menus, cxControls, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdGuides, cxDropDownEdit, cxCalendar, cxMaskEdit, cxButtonEdit, cxTextEdit,
  cxCurrencyEdit, Vcl.Controls, cxLabel, dsdDB, dsdAction, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dsdAddOn, Vcl.StdCtrls, cxButtons,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TProductionUnionTechEditForm = class(TAncestorEditDialogForm)
    cxLabel1: TcxLabel;
    ���: TcxLabel;
    ceOperDate: TcxDateEdit;
    ceRealWeight: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    ceRecipe: TcxButtonEdit;
    RecipeGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    GuidesFiller: TGuidesFiller;
    cxLabel10: TcxLabel;
    ceComment: TcxTextEdit;
    cxLabel9: TcxLabel;
    ceDatePartionGoods: TcxDateEdit;
    edInvNumber: TcxTextEdit;
    ceGooodsAndKind: TcxButtonEdit;
    cxLabel12: TcxLabel;
    GooodsAndKindGuides: TdsdGuides;
    cxLabel3: TcxLabel;
    ceCount: TcxCurrencyEdit;
    cxLabel4: TcxLabel;
    ce�uterCount: TcxCurrencyEdit;
    cxLabel11: TcxLabel;
    ce�uterReq: TcxCurrencyEdit;
    cxLabel13: TcxLabel;
    ceAmountReq: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    ceRecipeCode: TcxCurrencyEdit;
    GooodsKindGuides: TdsdGuides;
    ceGooodsKindGuides: TcxButtonEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TProductionUnionTechEditForm);

end.
