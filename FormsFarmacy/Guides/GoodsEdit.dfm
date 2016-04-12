﻿inherited GoodsEditForm: TGoodsEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 376
  ClientWidth = 351
  ExplicitWidth = 357
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 341
    TabOrder = 11
    ExplicitTop = 341
  end
  inherited bbCancel: TcxButton
    Top = 341
    TabOrder = 12
    ExplicitTop = 341
  end
  object edName: TcxTextEdit [2]
    Left = 9
    Top = 80
    TabOrder = 1
    Width = 332
  end
  object cxLabel1: TcxLabel [3]
    Left = 9
    Top = 57
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxLabel2: TcxLabel [4]
    Left = 9
    Top = 104
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 7
    Top = 28
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 0
    Width = 334
  end
  object Код: TcxLabel [6]
    Left = 9
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit [7]
    Left = 9
    Top = 125
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 2
    Width = 332
  end
  object cxLabel4: TcxLabel [8]
    Left = 128
    Top = 153
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103':'
  end
  object ceMeasure: TcxButtonEdit [9]
    Left = 128
    Top = 176
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 4
    Width = 92
  end
  object cxLabel6: TcxLabel [10]
    Left = 227
    Top = 153
    Caption = #1042#1080#1076' '#1053#1044#1057':'
  end
  object ceNDSKind: TcxButtonEdit [11]
    Left = 227
    Top = 176
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 5
    Width = 114
  end
  object edMinimumLot: TcxCurrencyEdit [12]
    Left = 9
    Top = 176
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 109
  end
  object cxLabel3: TcxLabel [13]
    Left = 9
    Top = 153
    Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100':'
  end
  object cxLabel5: TcxLabel [14]
    Left = 128
    Top = 203
    Caption = #1062#1077#1085#1072' '#1057#1055':'
  end
  object ceReferPrice: TcxCurrencyEdit [15]
    Left = 128
    Top = 226
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 92
  end
  object cxLabel7: TcxLabel [16]
    Left = 9
    Top = 203
    Caption = #1050#1086#1076' '#1057#1055':'
  end
  object ceReferCode: TcxCurrencyEdit [17]
    Left = 9
    Top = 226
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 109
  end
  object cbIsClose: TcxCheckBox [18]
    Left = 250
    Top = 273
    Caption = #1047#1072#1082#1088#1099#1090
    TabOrder = 8
    Width = 76
  end
  object cxLabel8: TcxLabel [19]
    Left = 9
    Top = 250
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080
  end
  object cePercentMarkup: TcxCurrencyEdit [20]
    Left = 9
    Top = 273
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 10
    Width = 109
  end
  object cbIsTop: TcxCheckBox [21]
    Left = 250
    Top = 226
    Caption = #1058#1054#1055
    TabOrder = 9
    Width = 76
  end
  object cxLabel9: TcxLabel [22]
    Left = 128
    Top = 250
    Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
  end
  object ceSalePrice: TcxCurrencyEdit [23]
    Left = 128
    Top = 273
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 23
    Width = 92
  end
  object cbIsFirst: TcxCheckBox [24]
    Left = 9
    Top = 305
    Caption = '1-'#1074#1099#1073#1086#1088
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 96
  end
  object cbIsSecond: TcxCheckBox [25]
    Left = 128
    Top = 305
    Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 139
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 155
    Top = 50
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 104
    Top = 50
  end
  inherited ActionList: TActionList
    Left = 207
    Top = 57
  end
  inherited FormParams: TdsdFormParams
    Left = 248
    Top = 66
  end
  inherited spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Goods'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inReferCode'
        Value = Null
        Component = ceReferCode
        ParamType = ptInput
      end
      item
        Name = 'inReferPrice'
        Value = Null
        Component = ceReferPrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ceSalePrice
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inIsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inTOP'
        Value = Null
        Component = cbIsTop
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = cePercentMarkup
        ParamType = ptInput
      end>
    Left = 208
    Top = 0
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
      end
      item
        Name = 'ReferCode'
        Value = Null
        Component = ceReferCode
      end
      item
        Name = 'ReferPrice'
        Value = Null
        Component = ceReferPrice
      end
      item
        Name = 'Price'
        Value = Null
        Component = ceSalePrice
        DataType = ftFloat
      end
      item
        Name = 'isClose'
        Value = Null
        Component = cbIsClose
      end
      item
        Name = 'isTop'
        Value = Null
        Component = cbIsTop
        DataType = ftBoolean
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = cePercentMarkup
        DataType = ftFloat
      end
      item
        Name = 'IsFirst'
        Value = Null
        Component = cbIsFirst
        DataType = ftBoolean
      end
      item
        Name = 'IsSecond'
        Value = Null
        Component = cbIsSecond
        DataType = ftBoolean
      end>
    Left = 288
    Top = 233
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 208
    Top = 114
  end
  object dsdMeasureGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 56
    Top = 169
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceNDSKind
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 232
    Top = 169
  end
end
