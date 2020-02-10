inherited ReestrTransportGoodsStartMovementForm: TReestrTransportGoodsStartMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1077#1077#1089#1090#1088' '#1058#1058#1053' ('#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')>'
  ClientHeight = 404
  ClientWidth = 937
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 953
  ExplicitHeight = 442
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 937
    Height = 321
    ExplicitTop = 83
    ExplicitWidth = 937
    ExplicitHeight = 321
    ClientRectBottom = 321
    ClientRectRight = 937
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 937
      ExplicitHeight = 297
      inherited cxGrid: TcxGrid
        Top = 67
        Width = 937
        Height = 230
        ExplicitTop = 67
        ExplicitWidth = 937
        ExplicitHeight = 230
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountKg
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ToName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountKg
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object BarCode_TTN: TcxGridDBColumn [1]
            Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
            DataBinding.FieldName = 'BarCode_TTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReestrKindName: TcxGridDBColumn [2]
            Caption = #1042#1080#1079#1072' '#1074' '#1058#1058#1053
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object StatusCode_TTN: TcxGridDBColumn [3]
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode_TTN'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_TTN: TcxGridDBColumn [4]
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate_TTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumber_TTN: TcxGridDBColumn [5]
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber_TTN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumberMark: TcxGridDBColumn [6]
            Caption = #8470' '#1087#1083#1086#1084#1073#1080' ('#1079#1072' '#1085#1072#1103#1074#1085#1086#1089#1090#1110')'
            DataBinding.FieldName = 'InvNumberMark'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object OKPO_To: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_To'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object JuridicalName_To: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object TotalCountKg: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Checked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1080#1079#1072' '#1042#1099#1074#1077#1079#1077#1085#1086' '#1089#1086' '#1089#1082#1083#1072#1076#1072' '#1080#1083#1080' '#1057#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object MemberCode_driver: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1060#1048#1054' ('#1074'./'#1101'.)'
            DataBinding.FieldName = 'MemberCode_driver'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object MemberName_driver: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
            DataBinding.FieldName = 'MemberName_driver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object PositionName_driver: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
            DataBinding.FieldName = 'PositionName_driver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object UnitName_driver: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1074#1086#1076#1080#1090#1077#1083#1100'/'#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
            DataBinding.FieldName = 'UnitName_driver'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object UnitName_Personal: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'  ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
            DataBinding.FieldName = 'UnitName_Personal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1089#1086#1090#1088#1091#1076#1085#1080#1082' ('#1058#1055')'
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object UnitName_PersonalTrade: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1058#1055')'
            DataBinding.FieldName = 'UnitName_PersonalTrade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 937
        Height = 59
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          Navigator.Buttons.Append.Visible = False
          DataController.DataSource = DataSource
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.SummaryGroups = <>
          FilterRow.ApplyChanges = fracDelayed
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object BarCode: TcxGridDBColumn
            Caption = #1057#1082#1072#1085#1080#1088#1091#1077#1090#1089#1103' <'#1058#1058#1053'> '#1080#1083#1080' '#1074#1074#1086#1076' '#8470
            DataBinding.FieldName = 'BarCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actTTNChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 180
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 59
        Width = 937
        Height = 8
        HotZoneClassName = 'TcxSimpleStyle'
        HotZone.Visible = False
        AlignSplitter = salTop
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 937
    Height = 57
    TabOrder = 3
    ExplicitWidth = 937
    ExplicitHeight = 57
    inherited edInvNumber: TcxTextEdit
      Left = 165
      Top = 22
      ExplicitLeft = 165
      ExplicitTop = 22
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 165
      Top = 4
      ExplicitLeft = 165
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 244
      Top = 22
      EditValue = 42663d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 244
      ExplicitTop = 22
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel2: TcxLabel
      Left = 245
      Top = 4
      ExplicitLeft = 245
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 10
      Top = 4
      ExplicitLeft = 10
      ExplicitTop = 4
    end
    inherited ceStatus: TcxButtonEdit
      Left = 10
      Top = 22
      ExplicitLeft = 10
      ExplicitTop = 22
      ExplicitWidth = 148
      ExplicitHeight = 22
      Width = 148
    end
    object cxLabel5: TcxLabel
      Left = 330
      Top = 4
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
    end
    object edInsertName: TcxButtonEdit
      Left = 330
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 209
    end
    object cxLabel18: TcxLabel
      Left = 544
      Top = 4
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1091#1087#1077#1088#1074#1072#1081#1079#1077#1088')'
    end
    object cePersonal: TcxButtonEdit
      Left = 544
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 197
    end
  end
  object cxLabel19: TcxLabel [2]
    Left = 746
    Top = 4
    Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1090#1086#1088#1075#1086#1074#1099#1081')'
  end
  object cePersonalTrade: TcxButtonEdit [3]
    Left = 746
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 195
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 499
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 23
    Top = 279
    object actPrintGroupPersonal: TdsdPrintAction [0]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintGroupPersonal
      StoredProcList = <
        item
          StoredProc = spSelectPrintGroupPersonal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1056#1077#1077#1089#1090#1088#1072' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PersonalName_Group;FromName;OperDatePartner'
        end>
      Params = <
        item
          Name = 'Id'
          Value = 0
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = 'TRUE'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrReturn'
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1056#1077#1077#1089#1090#1088#1072' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
      ReportNameParam.Value = 'PrintMovement_ReestrReturn'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actRefreshStart: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelectBarCode
      StoredProcList = <
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    object macPrintPeriodGroupPersonal: TMultiAction [3]
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_Print
        end
        item
          Action = actPrintPeriodGroupPersonal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1074#1080#1079#1086#1081' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1074#1080#1079#1086#1081' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 19
    end
    object actPrintPeriodGroupPersonal: TdsdPrintAction [5]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintPeriodGroupPersonal
      StoredProcList = <
        item
          StoredProc = spSelectPrintPeriodGroupPersonal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'PersonalName_Group;FromName;OperDatePartner'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42705d
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42705d
          Component = FormParams
          ComponentItem = 'InEndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsShowAllPrint'
          Value = False
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = 'TRUE'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrReturnStartPeriod'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ReportNameParam.Value = 'PrintMovement_ReestrReturnStartPeriod'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actMISetUnErased: TdsdUpdateErased
      ShortCut = 0
    end
    object actUpdateDataSet: TdsdUpdateDataSet [11]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelectBarCode
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProc = nil
      StoredProcList = <
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      Category = 'Print'
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = 'FALSE'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrReturn'
      ReportNameParam.Name = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1056#1077#1077#1089#1090#1088#1072' '#1074#1086#1079#1074#1088#1072#1090#1086#1074
      ReportNameParam.Value = 'PrintMovement_ReestrReturn'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object macPrintPeriod: TMultiAction [18]
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_Print
        end
        item
          Action = actPrintPeriod
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1074#1080#1079#1086#1081' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1074#1080#1079#1086#1081' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      ImageIndex = 16
    end
    object actGoodsKindChoice: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Sale'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actTTNChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ReturnJournalChoice'
      FormName = 'TTransportGoodsJournalForm'
      FormNameParam.Value = 'TTransportGoodsJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'BarCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macMISetErased: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actMISetErased
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091'? '
      InfoAfterExecute = #1042#1080#1079#1072' '#1086#1090#1084#1077#1085#1077#1085#1072
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1091#1102' '#1074#1080#1079#1091
      ImageIndex = 2
    end
    object actDialog_Print: TExecuteDialog
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actDialog_Print'
      ImageIndex = 16
      FormName = 'TReestrPrintDialogForm'
      FormNameParam.Value = 'TReestrPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'IsShowAll'
          Value = True
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReestrKindName'
          Value = #1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = 42705d
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42705d
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object ExternalDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      ImageIndex = 24
      FormName = 'TReestrStartDialogForm'
      FormNameParam.Value = 'TReestrStartDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'CarId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'CarName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DriverId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'DriverName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 24
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateMov: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExternalDialog
        end
        item
          Action = actUpdate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1042#1086#1076#1080#1090#1077#1083#1103'/'#1069#1082#1089#1087#1077#1076#1080#1090#1086#1088#1072'/'#1040#1074#1090#1086
      ImageIndex = 43
    end
    object actPrintPeriod: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintPeriod
      StoredProcList = <
        item
          StoredProc = spSelectPrintPeriod
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 0
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'InEndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsShowAllPrint'
          Value = False
          Component = FormParams
          ComponentItem = 'IsShowAllPrint'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = 'FALSE'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReestrReturnStartPeriod'
      ReportNameParam.Name = #1056#1077#1077#1089#1090#1088' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ReportNameParam.Value = 'PrintMovement_ReestrReturnStartPeriod'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 328
  end
  inherited MasterCDS: TClientDataSet
    Left = 80
    Top = 328
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_ReestrTransportGoods'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 288
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 279
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
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
          ItemName = 'bbPrintPeriod'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintGroupPersonal'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintPeriodGroupPersonal'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbInsertUpdateMovement: TdxBarButton
      Action = actUpdateDataSet
    end
    inherited bbErased: TdxBarButton
      Action = macMISetErased
    end
    object bbExecuteDialog: TdxBarButton
      Action = macUpdateMov
      Category = 0
    end
    object bbPrintPeriod: TdxBarButton
      Action = macPrintPeriod
      Category = 0
    end
    object bbPrintGroupPersonal: TdxBarButton
      Action = actPrintGroupPersonal
      Category = 0
    end
    object bbPrintPeriodGroupPersonal: TdxBarButton
      Action = macPrintPeriodGroupPersonal
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1058#1055' - '#1042#1057#1045' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1089' '#1074#1080#1079#1086#1081' <'#1055#1086#1083#1091#1095#1077#1085#1086' '#1086#1090' '#1082#1083#1080#1077#1085#1090#1072'>'
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 646
    Top = 273
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 280
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = 0
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'operdate'
        Value = 0c
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 42663d
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 42705d
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42705d
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsShowAllPrint'
        Value = False
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 336
  end
  inherited StatusGuides: TdsdGuides
    Left = 88
    Top = 0
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ReestrReturn'
    Left = 48
    Top = 0
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReestrTransportGoods'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'InEndDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 320
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ReestrReturn'
    Params = <
      item
        Name = 'ioId'
        Value = 0
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    Left = 274
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    Left = 296
    Top = 256
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 496
    Top = 105
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 600
    Top = 224
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetErased'
    Left = 414
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Send_SetUnErased'
    Left = 510
    Top = 320
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_ReestrTransportGoodsStart'
    Params = <
      item
        Name = 'ioMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 208
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStorageId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StorageId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
    Top = 328
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 532
    Top = 228
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrTransportGoods_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 879
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 64
    Top = 203
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 224
    Top = 115
  end
  object spSelectBarCode: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Reestr_BarCode'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inMovementId_Transport'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 96
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
        Action = actUpdateDataSet
      end>
    ActionItemList = <
      item
        Action = actUpdateDataSet
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
        Column = BarCode
      end>
    SummaryItemList = <>
    Left = 598
    Top = 105
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 716
    Top = 222
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 684
    Top = 217
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end
      item
      end>
    Left = 416
    Top = 96
  end
  object spSelectPrintPeriod: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrTransportGoodsStartPeriod_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42667d
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42667d
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = 'false'
        Component = FormParams
        ComponentItem = 'IsShowAllPrint'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 863
    Top = 264
  end
  object InsertGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInsertName
    Key = '0'
    FormNameParam.Value = 'TMemberPosition_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberPosition_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = InsertGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InsertGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPositionId'
        Value = 81178
        MultiSelectSeparator = ','
      end>
    Left = 434
    Top = 14
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonal
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 5
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePersonalTrade
    FormNameParam.Value = 'TPersonal_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 5
  end
  object spSelectPrintGroupPersonal: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrTransportGoods_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = 0
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 807
    Top = 216
  end
  object spSelectPrintPeriodGroupPersonal: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReestrTransportGoodsStartPeriod_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42705d
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42705d
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'IsShowAllPrint'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = '0'
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = '0'
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 791
    Top = 288
  end
end