inherited Report_MemberForm: TReport_MemberForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091'>'
  ClientHeight = 555
  ClientWidth = 1020
  ExplicitLeft = -38
  ExplicitWidth = 1036
  ExplicitHeight = 590
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1020
    Height = 472
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1020
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 472
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 472
        ExplicitWidth = 1020
        ExplicitHeight = 472
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = MoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = ReportSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AccountSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SendSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = MoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = ReportSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AccountSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SendSumm
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object CarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 181
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object StartAmount: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'StartAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountD: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'StartAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountK: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'StartAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MoneySumm: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' (+)'#1087#1088#1080#1093' (-)'#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'MoneySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ReportSumm: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076#1099' ('#1072#1074#1072#1085#1089'. '#1086#1090#1095'.)'
            DataBinding.FieldName = 'ReportSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object AccountSumm: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1099' '#1089' '#1102#1088'.'#1083#1080#1094#1086#1084
            DataBinding.FieldName = 'AccountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SendSumm: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' (+)'#1087#1088#1080#1093' (-)'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'SendSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object DebetSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object KreditSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EndAmount: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'EndAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountD: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'EndAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountK: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'EndAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.MaxLength = 0
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    Height = 57
    ExplicitWidth = 1020
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 60
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 60
    end
    inherited deEnd: TcxDateEdit
      Left = 60
      Top = 30
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 60
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 13
      Caption = #1044#1072#1090#1072' '#1089' :'
      ExplicitLeft = 13
      ExplicitWidth = 45
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 31
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
      ExplicitLeft = 6
      ExplicitTop = 31
      ExplicitWidth = 52
    end
    object cxLabel3: TcxLabel
      Left = 365
      Top = 6
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object ceInfoMoneyGroup: TcxButtonEdit
      Left = 365
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 160
    end
    object ceInfoMoneyDestination: TcxButtonEdit
      Left = 531
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 160
    end
    object cxLabel4: TcxLabel
      Left = 531
      Top = 6
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077':'
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 697
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 160
    end
    object cxLabel5: TcxLabel
      Left = 697
      Top = 6
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103':'
    end
    object cxLabel6: TcxLabel
      Left = 151
      Top = 6
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edAccount: TcxButtonEdit
      Left = 151
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 208
    end
    object ceBranch: TcxButtonEdit
      Left = 863
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 160
    end
    object cxLabel7: TcxLabel
      Left = 863
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 35
    Top = 328
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesAccount
        Properties.Strings = (
          'Key'
          'TextValue')
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
        Component = GuidesInfoMoneyDestination
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoneyGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesInfoMoney
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 327
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGetDescSets
      StoredProcList = <
        item
          StoredProc = spGetDescSets
        end
        item
          StoredProc = spSelect
        end>
    end
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091'>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091
      ReportNameParam.DataType = ftString
    end
    object dsdPrintRealAction: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1087#1086#1076#1086#1090#1095#1077#1090#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ReportNameParam.DataType = ftString
    end
    object PersonalReportJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'PersonalReportJournal'
      FormName = 'TPersonalReportJournalForm'
      FormNameParam.Value = 'TPersonalReportJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountId'
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'MemberName'
    Top = 184
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Member'
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
        Name = 'inAccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyGroupId'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 184
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintReal'
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
    object bbPrint: TdxBarButton
      Action = dsdPrintAction
      Category = 0
      Visible = ivNever
    end
    object bbPrintReal: TdxBarButton
      Action = dsdPrintRealAction
      Category = 0
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = MoneySumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = ReportSumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = AccountSumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = SendSumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = DebetSumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end
      item
        Column = KreditSumm
        Action = PersonalReportJournal
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 88
    Top = 16
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesAccount
      end
      item
        Component = GuidesInfoMoneyGroup
      end
      item
        Component = GuidesInfoMoneyDestination
      end
      item
        Component = GuidesInfoMoney
      end
      item
        Component = GuidesBranch
      end>
    Top = 228
  end
  object GuidesInfoMoneyGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyGroup
    FormNameParam.Value = 'TInfoMoneyGroup_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyGroup_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Member'
        DataType = ftString
      end>
    Left = 416
    Top = 45
  end
  object GuidesInfoMoneyDestination: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestination_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyDestination_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoneyDestination
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Member'
        DataType = ftString
      end>
    Left = 584
    Top = 53
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Member'
        DataType = ftString
      end>
    Left = 752
    Top = 45
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValueAll'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Member'
        DataType = ftString
      end>
    Left = 312
    Top = 48
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
      end>
    PackSize = 1
    Left = 296
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SaleDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'OtherDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        DataType = ftString
      end>
    Left = 240
    Top = 232
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 912
    Top = 53
  end
end
