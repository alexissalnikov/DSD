inherited Unit_ObjectForm: TUnit_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 477
  ClientWidth = 1158
  ExplicitWidth = 1174
  ExplicitHeight = 515
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1158
    Height = 451
    ExplicitWidth = 1158
    ExplicitHeight = 451
    ClientRectBottom = 451
    ClientRectRight = 1158
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1158
      ExplicitHeight = 451
      inherited cxGrid: TcxGrid
        Width = 1158
        Height = 451
        ExplicitWidth = 1158
        ExplicitHeight = 451
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsSelection.MultiSelect = True
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn
            Caption = #1050#1054#1044' '#1089#1074#1103#1079#1080' '#1076#1083#1103' '#1057#1072#1081#1090#1072
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object ParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089
            DataBinding.FieldName = 'Address'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085
            DataBinding.FieldName = 'Phone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ProvinceCityName: TcxGridDBColumn
            Caption = #1056#1072#1081#1086#1085
            DataBinding.FieldName = 'ProvinceCityName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenAreaForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object DriverName: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'DriverName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1086#1076#1080#1090#1077#1083#1100' '#1076#1083#1103' '#1088#1072#1079#1074#1086#1079#1082#1080' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 103
          end
          object TaxService: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080
            DataBinding.FieldName = 'TaxService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object TaxServiceNigth: TcxGridDBColumn
            Caption = '% '#1086#1090' '#1074#1099#1088#1091#1095#1082#1080' '#1085#1086#1095#1100
            DataBinding.FieldName = 'TaxServiceNigth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object KoeffInSUN: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1073#1072#1083#1072#1085#1089#1072' '#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'KoeffInSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' >= '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072', '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1077#1084' '#1087#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 57
          end
          object KoeffOutSUN: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1073#1072#1083#1072#1085#1089#1072' '#1088#1072#1089#1093#1086#1076'/'#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'KoeffOutSUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1083#1080' >= '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1072', '#1086#1075#1088#1072#1085#1080#1095#1080#1074#1072#1077#1084' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 56
          end
          object KoeffInSUN_v3: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1057#1047#1055
            DataBinding.FieldName = 'KoeffInSUN_v3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072' '#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103' - '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1087#1088#1080#1093#1086#1076
            Options.Editing = False
            Width = 57
          end
          object KoeffOutSUN_v3: TcxGridDBColumn
            Caption = #1050#1086#1101#1092'. '#1057#1047#1054
            DataBinding.FieldName = 'KoeffOutSUN_v3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072' '#1086#1090#1087#1088#1072#1074#1080#1090#1077#1083#1103' - '#1086#1087#1088#1077#1076#1077#1083#1103#1077#1090#1089#1103' '#1088#1072#1089#1093#1086#1076
            Options.Editing = False
            Width = 56
          end
          object isSUN: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isSUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V.2)'
            DataBinding.FieldName = 'isSUN_v2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1074#1077#1088#1089#1080#1103' 2'
            Options.Editing = False
            Width = 70
          end
          object isSUN_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1087#1088#1080#1077#1084') (V.1)'
            DataBinding.FieldName = 'isSUN_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.1)'
            DataBinding.FieldName = 'isSUN_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1087#1088#1080#1077#1084') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v2_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1086#1090#1087#1088#1072#1074#1082#1072') (V.2)'
            DataBinding.FieldName = 'isSUN_v2_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_v3_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1087#1088#1080#1077#1084')'
            DataBinding.FieldName = 'isSUN_v3_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v3: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053
            DataBinding.FieldName = 'isSUN_v3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089
            Options.Editing = False
            Width = 70
          end
          object isSUN_v3_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'  ('#1086#1090#1087#1088#1072#1074#1082#1072')'
            DataBinding.FieldName = 'isSUN_v3_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' - '#1069#1082#1089#1087#1088#1077#1089#1089' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
            DataBinding.FieldName = 'isSUN_v4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4_in: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1087#1088#1080#1077#1084')'
            DataBinding.FieldName = 'isSUN_v4_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object isSUN_v4_out: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048'  ('#1086#1090#1087#1088#1072#1074#1082#1072')'
            DataBinding.FieldName = 'isSUN_v4_out'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072
            Options.Editing = False
            Width = 70
          end
          object isSUN_NotSold: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' (V.1)'
            DataBinding.FieldName = 'isSUN_NotSold'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053
            Options.Editing = False
            Width = 95
          end
          object ListDaySUN: TcxGridDBColumn
            Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
            DataBinding.FieldName = 'ListDaySUN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1082#1072#1082#1080#1084' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
            Options.Editing = False
            Width = 85
          end
          object ListDaySUN_pi: TcxGridDBColumn
            Caption = #1044#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1087#1077#1088#1077#1084#1077#1097'.'#1080#1079#1083#1080#1096#1082#1086#1074
            DataBinding.FieldName = 'ListDaySUN_pi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086' '#1082#1072#1082#1080#1084' '#1076#1085#1103#1084' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1087#1077#1088#1077#1084#1077#1097'.'#1080#1079#1083#1080#1096#1082#1086#1074
            Options.Editing = False
            Width = 85
          end
          object SunIncome: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1076#1085'. '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082'. '#1057#1059#1053') (V.1)'
            DataBinding.FieldName = 'SunIncome'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'. ('#1073#1083#1086#1082#1080#1088#1091#1077#1084' '#1057#1059#1053')'
            Options.Editing = False
            Width = 85
          end
          object isRepriceAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1086#1094#1077#1085#1082#1072
            DataBinding.FieldName = 'isRepriceAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
            Options.Editing = False
            Width = 70
          end
          object isOver: TcxGridDBColumn
            Caption = #1040#1074#1090#1086' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'isOver'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1080
            Options.Editing = False
            Width = 88
          end
          object isGoodsCategory: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099
            DataBinding.FieldName = 'isGoodsCategory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090#1080#1084#1077#1085#1090#1085#1086#1081' '#1084#1072#1090#1088#1080#1094#1099
            Options.Editing = False
            Width = 70
          end
          object isTopNo: TcxGridDBColumn
            Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055
            DataBinding.FieldName = 'isTopNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' '#1076#1083#1103' '#1072#1087#1090#1077#1082#1080
            Options.Editing = False
            Width = 70
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object isUploadBadm: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1041#1040#1044#1052
            DataBinding.FieldName = 'isUploadBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052
            Options.Editing = False
            Width = 89
          end
          object Num_byReportBadm: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'. ('#1041#1072#1044#1052')'
            DataBinding.FieldName = 'Num_byReportBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object isMarginCategory: TcxGridDBColumn
            Caption = #1060#1086#1088#1084'. '#1074' '#1087#1088#1086#1089#1084'. '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'isMarginCategory'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 115
          end
          object isReport: TcxGridDBColumn
            Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
            Options.Editing = False
            Width = 72
          end
          object CreateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CreateDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object CloseDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1088'. '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'CloseDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UserManagerName: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'UserManagerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUserForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088')'
            DataBinding.FieldName = 'EMail_Member'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object Phone_Member: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088')'
            DataBinding.FieldName = 'Phone_Member'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object UserManager2Name: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 2'
            DataBinding.FieldName = 'UserManager2Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser2Form
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object Member2Name: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088' 2'
            DataBinding.FieldName = 'Member2Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser2Form
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member2: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088' 2)'
            DataBinding.FieldName = 'EMail_Member2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object Phone_Member2: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088' 2)'
            DataBinding.FieldName = 'Phone_Member2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object UserManager3Name: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088' 3'
            DataBinding.FieldName = 'UserManager3Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser3Form
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object Member3Name: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1052#1077#1085#1077#1076#1078#1077#1088' 3'
            DataBinding.FieldName = 'Member3Name'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actOpenUser3Form
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EMail_Member3: TcxGridDBColumn
            Caption = 'E-Mail ('#1084#1077#1085#1077#1076#1078#1077#1088' 3)'
            DataBinding.FieldName = 'EMail_Member3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object Phone_Member3: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1084#1077#1085#1077#1076#1078#1077#1088' 3)'
            DataBinding.FieldName = 'Phone_Member3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object UnitRePriceName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085'. '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094'.'
            DataBinding.FieldName = 'UnitRePriceName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceUnit
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076'. '#1076#1083#1103' '#1091#1088#1072#1074#1085#1080#1074#1072#1085#1080#1103' '#1094#1077#1085' '#1074' '#1072#1074#1090#1086#1087#1077#1088#1077#1086#1094#1077#1085#1082#1077
            Width = 95
          end
          object PartnerMedicalName: TcxGridDBColumn
            Caption = #1052#1077#1076'. '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1082#1084#1091' 1303'
            DataBinding.FieldName = 'PartnerMedicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isSP: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            DataBinding.FieldName = 'isSP'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 89
          end
          object DateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            DataBinding.FieldName = 'DateSP'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090#1091
            Options.Editing = False
            Width = 85
          end
          object isNotCashMCS: TcxGridDBColumn
            Caption = #1041#1083#1086#1082'. '#1053#1058#1047' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            DataBinding.FieldName = 'isNotCashMCS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object isNotCashListDiff: TcxGridDBColumn
            Caption = #1041#1083#1086#1082'.  '#1083#1080#1089#1090#1099' '#1086#1090#1082#1072#1079#1086#1074
            DataBinding.FieldName = 'isNotCashListDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object TimeWork: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1088#1072#1073#1086#1090#1099
            DataBinding.FieldName = 'TimeWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object isTechnicalRediscount: TcxGridDBColumn
            Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1080' '#1055#1057' '
            DataBinding.FieldName = 'isTechnicalRediscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object isAlertRecounting: TcxGridDBColumn
            Caption = #1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084
            DataBinding.FieldName = 'isAlertRecounting'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object macUpdate_ListDaySUN_pi: TMultiAction [2]
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDListDaySUN_pi
      ActionList = <
        item
          Action = actExecUpdate_ListDaySUN_pi
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1040#1087#1090#1077#1082'?'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053'2-'#1055#1048
      ImageIndex = 42
    end
    object actExecUpdate_ListDaySUN_pi: TdsdExecStoredProc [3]
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ListDaySUN_pi
      StoredProcList = <
        item
          StoredProc = spUpdate_ListDaySUN_pi
        end>
      Caption = 'actExecUpdate_ListDaySUN'
    end
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'KeyList'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValuelist'
          Value = Null
          Component = cxGridDBTableView
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
    object actProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateisTopNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isTopNo
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isTopNo
        end>
      Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' ('#1044#1072' / '#1053#1077#1090')'
      Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1058#1054#1055' ('#1044#1072' / '#1053#1077#1090')'
      ImageIndex = 78
    end
    object actUpdateisReport: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isReport
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isReport
        end>
      Caption = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      Hint = #1059#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1086#1090#1095#1077#1090#1077
      ImageIndex = 38
    end
    object actUpdate_Unit_isSUN_v4_out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_out
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_out
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v4_in: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4_in
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4_in
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdate_Unit_isSUN_v4: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v4
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v4
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053'2-'#1055#1048' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 73
    end
    object actUpdateisMarginCategory: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isMarginCategory
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isMarginCategory
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1087#1088#1086#1089#1084#1086#1090#1088#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1081' '#1085#1072#1094#1077#1085#1082#1080
      ImageIndex = 77
    end
    object actUpdateisUploadBadm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isUploadBadm
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isUploadBadm
        end>
      Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1041#1040#1044#1052
      Hint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052' '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
    object actUpdate_Unit_isSUN_v3_out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_out
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_out
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1086#1090#1087#1088#1072#1074#1082#1072' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v3_in: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3_in
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3_in
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' - '#1090#1086#1083#1100#1082#1086' '#1087#1088#1080#1077#1084' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v3: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v3
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v3
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 71
    end
    object actUpdate_Unit_isSUN_v2: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 47
    end
    object actUpdate_Unit_isSUN_in: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_in
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_in
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 48
    end
    object actUpdate_Unit_isSUN_out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_out
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_out
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072') ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 49
    end
    object actUpdate_Unit_isSUN_NotSold: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_NotSold
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_NotSold
        end>
      Caption = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1054#1090#1082#1083#1102#1095#1077#1085#1072' '#1084#1086#1076#1077#1083#1100' "'#1073#1077#1079' '#1087#1088#1086#1076#1072#1078'" '#1076#1083#1103' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 68
    end
    object actUpdate_Unit_isSUN_v2_in: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_in
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_in
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 69
    end
    object actUpdate_Unit_isSUN_v2_out: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN_v2_out
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN_v2_out
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' '#1074#1077#1088#1089#1080#1103' 2) ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 70
    end
    object actUpdate_Unit_isSUN: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isSUN
        end>
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 50
    end
    object actUpdateisOver: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072'/'#1053#1077#1090
    end
    object actUpdateGoodsCategory_No: TdsdExecStoredProc
      Category = 'GoodsCategory'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsCategory_No
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsCategory_No
        end>
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
    end
    object actUpdateGoodsCategory_Yes: TdsdExecStoredProc
      Category = 'GoodsCategory'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_GoodsCategory_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_GoodsCategory_Yes
        end>
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
    end
    object spUpdateisOverNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_No
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_No
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1053#1077#1090
    end
    object spUpdateisOverYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_isOver_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_isOver_Yes
        end>
      Caption = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
      Hint = #1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1044#1072
    end
    object actOpenUser2Form: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager2Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager2Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Member2Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdateisGoodsCategoryNo: TMultiAction
      Category = 'GoodsCategory'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsCategory_No
        end>
      View = cxGridDBTableView
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1053#1077#1090
      ImageIndex = 58
    end
    object macUpdateisGoodsCategoryYes: TMultiAction
      Category = 'GoodsCategory'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateGoodsCategory_Yes
        end>
      View = cxGridDBTableView
      Caption = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      Hint = #1044#1083#1103' '#1040#1089#1089#1086#1088#1090'. '#1084#1072#1090#1088#1080#1094#1099' - '#1044#1072
      ImageIndex = 52
    end
    object macUpdateisOverNo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1053#1077#1090
      ImageIndex = 58
    end
    object actOpenUser3Form: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager3Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManager3Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Member3Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdateisOverYes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUpdateisOverYes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1040#1074#1090#1086#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' - '#1044#1072
      ImageIndex = 52
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actOpenAreaForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TAreaForm'
      FormName = 'TAreaForm'
      FormNameParam.Value = 'TAreaForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AreaName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitRePriceId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitRePriceName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object ExecuteDialogKoeffSUNv3: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 26
      FormName = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.Value = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeffInSUN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KoeffInSUN_v3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffOutSUN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'KoeffOutSUN_v3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormName'
          Value = #1044#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffInSUNText'
          Value = #1050#1086#1101#1092'. '#1057#1047#1055
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffOutSUNText'
          Value = #1050#1086#1101#1092'. '#1057#1047#1054
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actOpenUserForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TUserForm'
      FormName = 'TUserForm'
      FormNameParam.Value = 'TUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UserManagerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateKoeffSUNv3: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_KoeffSUNv3
      StoredProcList = <
        item
          StoredProc = spUpdate_KoeffSUNv3
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateKoeffSUNv3: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogKoeffSUNv3
        end
        item
          Action = actUpdateKoeffSUNv3
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1089#1091#1090#1086#1095#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      ImageIndex = 43
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_Params
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    object dsdSetUnErased: TdsdUpdateErased
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object ExecuteDialogKoeffSUN: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 26
      FormName = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.Value = 'TUnit_KoeffSUN_EditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inKoeffInSUN'
          Value = 42261d
          Component = MasterCDS
          ComponentItem = 'KoeffInSUN'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'inKoeffOutSUN'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'KoeffOutSUN'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormName'
          Value = #1044#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffInSUNText'
          Value = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1087#1088#1080#1093'.'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'KoeffOutSUNText'
          Value = #1050#1086#1101#1092'. '#1073#1072#1083'. '#1088#1072#1089#1093'.'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actEDListDaySUN_pi: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDListDaySUN'
      FormName = 'TListDaySUNDialogForm'
      FormNameParam.Value = 'TListDaySUNDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ListDaySUN'
          Value = ''
          Component = FormParams
          ComponentItem = 'ListDaySUN_pi'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateKoeffSUN: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_KoeffSUN
      StoredProcList = <
        item
          StoredProc = spUpdate_KoeffSUN
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macUpdateKoeffSUN: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogKoeffSUN
        end
        item
          Action = actUpdateKoeffSUN
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
      ImageIndex = 43
    end
    object actUpdate_Unit_TechnicalRediscount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_TechnicalRediscount
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_TechnicalRediscount
        end>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      ImageIndex = 79
    end
    object actUpdate_ListDaySUN: TMultiAction
      Category = 'ListDaySUN'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actEDListDaySUN
      ActionList = <
        item
          Action = actExecUpdate_ListDaySUN
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1085#1080' '#1085#1077#1076#1077#1083#1080' '#1087#1086' '#1057#1059#1053
      ImageIndex = 35
    end
    object actExecUpdate_ListDaySUN: TdsdExecStoredProc
      Category = 'ListDaySUN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ListDaySUN
      StoredProcList = <
        item
          StoredProc = spUpdate_ListDaySUN
        end>
      Caption = 'actExecUpdate_ListDaySUN'
    end
    object actEDListDaySUN: TExecuteDialog
      Category = 'ListDaySUN'
      MoveParams = <>
      Caption = 'actEDListDaySUN'
      FormName = 'TListDaySUNDialogForm'
      FormNameParam.Value = 'TListDaySUNDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ListDaySUN'
          Value = Null
          Component = FormParams
          ComponentItem = 'ListDaySUN'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Unit_AlertRecounting: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Unit_AlertRecounting
      StoredProcList = <
        item
          StoredProc = spUpdate_Unit_AlertRecounting
        end>
      Caption = ' '#1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084' '
      Hint = ' '#1054#1087#1086#1074#1077#1097#1077#1085#1080#1077' '#1087#1077#1088#1077#1076' '#1087#1077#1088#1077#1091#1095#1077#1090#1086#1084' '
      ImageIndex = 53
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    Params = <
      item
        Name = 'inisShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
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
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOver'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverList'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisOverNoList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisUploadBadm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbisMarginCategory'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisGoodsCategoryYes'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisGoodsCategoryNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_out'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_NotSold'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v2_out'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v3_out'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_in'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Unit_isSUN_v4_out'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateKoeffSUN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateKoeffSUNv3'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisReport'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ListDaySUN_pi'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisTopNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
    object bbProtocolOpenForm: TdxBarButton
      Action = actProtocolOpenForm
      Category = 0
    end
    object bbUpdateisOver: TdxBarButton
      Action = actUpdateisOver
      Category = 0
      ImageIndex = 72
    end
    object bbUpdateisOverList: TdxBarButton
      Action = macUpdateisOverYes
      Category = 0
    end
    object bbUpdateisOverNoList: TdxBarButton
      Action = macUpdateisOverNo
      Category = 0
    end
    object bbUpdateisUploadBadm: TdxBarButton
      Action = actUpdateisUploadBadm
      Category = 0
    end
    object bbisMarginCategory: TdxBarButton
      Action = actUpdateisMarginCategory
      Category = 0
    end
    object bbUpdateisReport: TdxBarButton
      Action = actUpdateisReport
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbUpdateisGoodsCategoryYes: TdxBarButton
      Action = macUpdateisGoodsCategoryYes
      Category = 0
    end
    object bbUpdateisGoodsCategoryNo: TdxBarButton
      Action = macUpdateisGoodsCategoryNo
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = dsdSetErased
      Category = 0
      ImageIndex = 2
    end
    object dxBarButton2: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
      ImageIndex = 8
    end
    object bbUpdate_Unit_isSUN: TdxBarButton
      Action = actUpdate_Unit_isSUN
      Category = 0
    end
    object bbUpdateisTopNo: TdxBarButton
      Action = actUpdateisTopNo
      Category = 0
    end
    object bbUpdateKoeffSUN: TdxBarButton
      Action = macUpdateKoeffSUN
      Category = 0
    end
    object bbUpdate_Unit_isSUN_in: TdxBarButton
      Action = actUpdate_Unit_isSUN_in
      Category = 0
    end
    object bbUpdate_Unit_isSUN_out: TdxBarButton
      Action = actUpdate_Unit_isSUN_out
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2: TdxBarButton
      Action = actUpdate_Unit_isSUN_v2
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' (V.2) ('#1044#1072'/'#1053#1077#1090')'
      Category = 0
    end
    object bbUpdate_Unit_isSUN_NotSold: TdxBarButton
      Action = actUpdate_Unit_isSUN_NotSold
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_in: TdxBarButton
      Action = actUpdate_Unit_isSUN_v2_in
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1055#1088#1080#1077#1084' V.2) ('#1044#1072'/'#1053#1077#1090')'
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v2_out: TdxBarButton
      Action = actUpdate_Unit_isSUN_v2_out
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1057#1059#1053' ('#1054#1090#1087#1088#1072#1074#1082#1072' V.2) ('#1044#1072'/'#1053#1077#1090')'
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_Unit_TechnicalRediscount
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3: TdxBarButton
      Action = actUpdate_Unit_isSUN_v3
      Category = 0
    end
    object bbUpdateKoeffSUNv3: TdxBarButton
      Action = macUpdateKoeffSUNv3
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_in: TdxBarButton
      Action = actUpdate_Unit_isSUN_v3_in
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v3_out: TdxBarButton
      Action = actUpdate_Unit_isSUN_v3_out
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUpdate_ListDaySUN
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdate_Unit_AlertRecounting
      Category = 0
    end
    object bbUpdate_ListDaySUN_pi: TdxBarButton
      Action = macUpdate_ListDaySUN_pi
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4: TdxBarButton
      Action = actUpdate_Unit_isSUN_v4
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_in: TdxBarButton
      Action = actUpdate_Unit_isSUN_v4_in
      Category = 0
    end
    object bbUpdate_Unit_isSUN_v4_out: TdxBarButton
      Action = actUpdate_Unit_isSUN_v4_out
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 136
    Top = 184
  end
  object spUpdate_Unit_isOver: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 99
  end
  object spUpdate_Unit_isOver_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 163
  end
  object spUpdate_Unit_isOver_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isOver'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOver'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisOver'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOver'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 219
  end
  object spUpdate_Unit_isUploadBadm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isUploadBadm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 131
  end
  object spUpdate_Unit_isMarginCategory: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isMarginCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisMarginCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMarginCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 203
  end
  object spUpdate_Unit_isReport: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isReport'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisReport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isReport'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 267
  end
  object spUpdate_Unit_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCreateDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CreateDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCloseDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'CloseDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManagerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManagerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager2Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManager2Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserManager3Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserManager3Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AreaId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitRePriceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitRePriceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 123
  end
  object spUpdate_GoodsCategory_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isGoodsCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsCategory'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisGoodsCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 179
  end
  object spUpdate_GoodsCategory_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isGoodsCategory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGoodsCategory'
        Value = 'FALSE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisGoodsCategory'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isGoodsCategory'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 235
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit_IsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 192
  end
  object spUpdate_Unit_isSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 291
  end
  object spUpdate_Unit_isTopNo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isTopNo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTopNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTopNo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTopNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTopNo'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 632
    Top = 339
  end
  object spUpdate_KoeffSUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_KoeffSUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffInSUN'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'KoeffInSUN'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'KoeffOutSUN'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 320
  end
  object spUpdate_Unit_isSUN_v2: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 315
  end
  object spUpdate_Unit_isSUN_in: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_in'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_in'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_in'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 331
  end
  object spUpdate_Unit_isSUN_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_out'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_out'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 379
  end
  object spUpdate_Unit_isSUN_NotSold: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_NotSold'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_NotSold'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_NotSold'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_NotSold'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_NotSold'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 347
  end
  object spUpdate_Unit_isSUN_v2_in: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_in'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 363
  end
  object spUpdate_Unit_isSUN_v2_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_out'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v2_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v2_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 403
  end
  object spUpdate_Unit_TechnicalRediscount: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_TechnicalRediscount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTechnicalRediscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTechnicalRediscount'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTechnicalRediscount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTechnicalRediscount'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 411
  end
  object spUpdate_Unit_isSUN_v3: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 307
  end
  object spUpdate_KoeffSUNv3: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_KoeffSUN_v3'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffInSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffInSUN_v3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffOutSUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'KoeffOutSUN_v3'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 376
  end
  object spUpdate_Unit_isSUN_v3_in: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_in'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 936
    Top = 283
  end
  object spUpdate_Unit_isSUN_v3_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_out'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v3_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v3_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 928
    Top = 331
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ListDaySUN'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 146
  end
  object spUpdate_ListDaySUN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ListDaySUN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN'
        Value = Null
        Component = FormParams
        ComponentItem = 'ListDaySUN'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 387
  end
  object spUpdate_Unit_AlertRecounting: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_AlertRecounting'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAlertRecounting'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAlertRecounting'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAlertRecounting'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAlertRecounting'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 403
  end
  object spUpdate_ListDaySUN_pi: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_ListDaySUN_pi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inListDaySUN_pi'
        Value = ''
        Component = FormParams
        ComponentItem = 'ListDaySUN_pi'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 848
    Top = 395
  end
  object spUpdate_Unit_isSUN_v4: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 179
  end
  object spUpdate_Unit_isSUN_v4_in: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_in'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_in'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_in'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1080
    Top = 235
  end
  object spUpdate_Unit_isSUN_v4_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_isSUN_v2'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_out'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisSun_v2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSun_v4_out'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = 'zc_ObjectBoolean_Unit_SUN_v4_out'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1072
    Top = 299
  end
end
