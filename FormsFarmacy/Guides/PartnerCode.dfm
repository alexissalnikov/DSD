inherited PartnerCodeForm: TPartnerCodeForm
  Caption = #1050#1086#1076#1099' '#1089#1090#1099#1082#1086#1074#1082#1080' '#1090#1086#1074#1072#1088#1086#1074
  ClientWidth = 421
  ExplicitWidth = 437
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 421
    ExplicitWidth = 421
    ClientRectRight = 421
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 421
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 421
        ExplicitWidth = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object lCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object lName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 319
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_PartnerCode'
  end
  inherited BarManager: TdxBarManager
    Top = 8
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
