object Report_GoodsMI_InternalDialogForm: TReport_GoodsMI_InternalDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1086' '#1090#1086#1074#1072#1088#1072#1084'>'
  ClientHeight = 224
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 98
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 272
    Top = 184
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 121
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 11
    Top = 27
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object edGoodsGroup: TcxButtonEdit
    Left = 8
    Top = 139
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 200
  end
  object edFrom: TcxButtonEdit
    Left = 11
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 200
  end
  object cxLabel3: TcxLabel
    Left = 11
    Top = 67
    Caption = #1054#1090' '#1082#1086#1075#1086':'
  end
  object cxLabel1: TcxLabel
    Left = 9
    Top = 117
    Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1086#1074':'
  end
  object cxLabel6: TcxLabel
    Left = 11
    Top = 7
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 121
    Top = 7
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel4: TcxLabel
    Left = 232
    Top = 64
    Caption = #1050#1086#1084#1091':'
  end
  object edTo: TcxButtonEdit
    Left = 232
    Top = 87
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 200
  end
  object edPaidKind: TcxButtonEdit
    Left = 232
    Top = 137
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 200
  end
  object cxLabel2: TcxLabel
    Left = 233
    Top = 117
    Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
  end
  object cxLabel5: TcxLabel
    Left = 233
    Top = 7
    Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090':'
  end
  object edPriceList: TcxButtonEdit
    Left = 232
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 200
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 80
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 32
    Top = 176
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 400
    Top = 180
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 200
    Top = 176
  end
  object GuidesGoodsGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 96
    Top = 120
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 128
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 112
    Top = 72
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TStoragePlace_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TStoragePlace_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 320
    Top = 72
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 8
  end
end
