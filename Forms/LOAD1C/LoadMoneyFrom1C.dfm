inherited LoadMoneyFrom1CForm: TLoadMoneyFrom1CForm
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1082#1072#1089#1089#1099' '#1080#1079' 1'#1057
  ClientHeight = 416
  ClientWidth = 958
  ExplicitWidth = 974
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 958
    Height = 359
    TabOrder = 3
    ExplicitTop = 57
    ExplicitWidth = 958
    ExplicitHeight = 359
    ClientRectBottom = 359
    ClientRectRight = 958
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 958
      ExplicitHeight = 359
      inherited cxGrid: TcxGrid
        Width = 958
        Height = 359
        ExplicitWidth = 958
        ExplicitHeight = 359
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSummIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSummOut
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSummIn
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSummOut
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'InvNumber'
            Options.Editing = False
            Width = 60
          end
          object colBranch: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colSummIn: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1076#1077#1085#1077#1075
            DataBinding.FieldName = 'SummaIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colSummOut: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1076#1077#1085#1077#1075
            DataBinding.FieldName = 'SummaOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1082'. 1'#1057
            DataBinding.FieldName = 'ClientCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colClientName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' 1'#1057
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colClientFindName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1085#1072#1081#1076#1077#1085')'
            DataBinding.FieldName = 'ClientFindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clContractStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colContract: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContactNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 958
    ExplicitWidth = 958
    inherited deStart: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    object edBranch: TcxButtonEdit
      Left = 467
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 177
    end
    object cxLabel3: TcxLabel
      Left = 421
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BranchGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = nil
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
    end
    object actMoveToDoc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMoveMoney
      StoredProcList = <
        item
          StoredProc = spMoveMoney
        end>
      Caption = #1055#1077#1088#1077#1085#1086#1089#1080#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1087#1088#1086#1076#1072#1078#1080
    end
    object actTrancateTable: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spDelete1CLoad
      StoredProcList = <
        item
          StoredProc = spDelete1CLoad
        end>
      Caption = 'actTrancateTable'
    end
    object actMoney1CLoadAction: TMoney1CLoadAction
      Category = 'DSDLib'
      MoveParams = <>
      Branch.Value = ''
      Branch.Component = BranchGuides
      Branch.ComponentItem = 'Key'
      Branch.ParamType = ptInput
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object actLoad1C: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actTrancateTable
        end
        item
          Action = actMoney1CLoadAction
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' 1'#1057
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1080#1079' 1'#1057
      ImageIndex = 50
    end
    object actMoveDoc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actRefresh
        end
        item
          Action = actBeforeMove
        end
        item
          Action = actMoveAllDoc
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' ?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 30
    end
    object actMoveAllDoc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMoveToDoc
        end>
      View = cxGridDBTableView
      Caption = 'actMoveAllDoc'
    end
    object actBeforeMove: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spCheckLoad
      StoredProcList = <
        item
          StoredProc = spCheckLoad
        end
        item
          StoredProc = spErased
        end>
      Caption = 'actBeforeMove'
    end
  end
  inherited MasterDS: TDataSource
    Left = 136
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Left = 104
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_1CMoneyLoad'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 208
    Top = 336
  end
  inherited BarManager: TdxBarManager
    Left = 216
    Top = 280
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoad1c'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMoveSale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbLoad1c: TdxBarButton [3]
      Action = actLoad1C
      Category = 0
    end
    object bbMoveSale: TdxBarButton [4]
      Action = actMoveDoc
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 184
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = BranchGuides
      end>
    Left = 248
    Top = 8
  end
  object spMoveMoney: TdsdStoredProc
    StoredProcName = 'gpLoadMoneyFrom1C'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 320
    Top = 264
  end
  object spDelete1CLoad: TdsdStoredProc
    StoredProcName = 'gpDelete_1CMoney'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 288
    Top = 112
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranchForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranchForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 576
    Top = 16
  end
  object spErased: TdsdStoredProc
    StoredProcName = 'gpErasedMoneyFrom1C'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 376
    Top = 168
  end
  object spCheckLoad: TdsdStoredProc
    StoredProcName = 'gpCheckLoadMoneyFrom1C'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 296
    Top = 216
  end
end
