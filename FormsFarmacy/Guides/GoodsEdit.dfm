﻿inherited GoodsEditForm: TGoodsEditForm
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
  ClientHeight = 457
  ClientWidth = 351
  ExplicitWidth = 357
  ExplicitHeight = 486
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 413
    TabOrder = 11
    ExplicitTop = 413
  end
  inherited bbCancel: TcxButton
    Top = 413
    TabOrder = 12
    ExplicitTop = 413
  end
  object edName: TcxTextEdit [2]
    Left = 9
    Top = 60
    TabOrder = 1
    Width = 332
  end
  object cxLabel1: TcxLabel [3]
    Left = 9
    Top = 43
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxLabel2: TcxLabel [4]
    Left = 9
    Top = 80
    Caption = #1043#1088#1091#1087#1087#1072' '#1088#1086#1076#1080#1090#1077#1083#1100
  end
  object ceCode: TcxCurrencyEdit [5]
    Left = 9
    Top = 22
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 0
    Width = 162
  end
  object Код: TcxLabel [6]
    Left = 9
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceParentGroup: TcxButtonEdit [7]
    Left = 9
    Top = 99
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
    Top = 120
    Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103':'
  end
  object ceMeasure: TcxButtonEdit [9]
    Left = 128
    Top = 137
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
    Left = 226
    Top = 120
    Caption = #1042#1080#1076' '#1053#1044#1057':'
  end
  object ceNDSKind: TcxButtonEdit [11]
    Left = 227
    Top = 137
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
    Top = 137
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 3
    Width = 109
  end
  object cxLabel3: TcxLabel [13]
    Left = 9
    Top = 120
    Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100':'
  end
  object cxLabel5: TcxLabel [14]
    Left = 128
    Top = 157
    Caption = #1062#1077#1085#1072' '#1057#1055':'
  end
  object ceReferPrice: TcxCurrencyEdit [15]
    Left = 124
    Top = 174
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 7
    Width = 92
  end
  object cxLabel7: TcxLabel [16]
    Left = 9
    Top = 157
    Caption = #1050#1086#1076' '#1057#1055':'
  end
  object ceReferCode: TcxCurrencyEdit [17]
    Left = 9
    Top = 174
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 6
    Width = 109
  end
  object cbIsClose: TcxCheckBox [18]
    Left = 250
    Top = 211
    Caption = #1047#1072#1082#1088#1099#1090
    TabOrder = 8
    Width = 76
  end
  object cxLabel8: TcxLabel [19]
    Left = 9
    Top = 194
    Caption = '% '#1085#1072#1094#1077#1085#1082#1080
  end
  object cePercentMarkup: TcxCurrencyEdit [20]
    Left = 9
    Top = 213
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 10
    Width = 109
  end
  object cbIsTop: TcxCheckBox [21]
    Left = 250
    Top = 170
    Caption = #1058#1054#1055
    TabOrder = 9
    Width = 76
  end
  object cxLabel9: TcxLabel [22]
    Left = 128
    Top = 194
    Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
  end
  object ceSalePrice: TcxCurrencyEdit [23]
    Left = 128
    Top = 213
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.00'
    TabOrder = 23
    Width = 92
  end
  object cbIsFirst: TcxCheckBox [24]
    Left = 9
    Top = 234
    Caption = '1-'#1074#1099#1073#1086#1088
    Properties.ReadOnly = True
    TabOrder = 24
    Width = 96
  end
  object cbIsSecond: TcxCheckBox [25]
    Left = 128
    Top = 234
    Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
    Properties.ReadOnly = True
    TabOrder = 25
    Width = 139
  end
  object cxLabel10: TcxLabel [26]
    Left = 185
    Top = 5
    Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
  end
  object ceMorionCode: TcxCurrencyEdit [27]
    Left = 183
    Top = 22
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 27
    Width = 158
  end
  object cxLabel11: TcxLabel [28]
    Left = 9
    Top = 288
    Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
  end
  object ceBarCode: TcxTextEdit [29]
    Left = 9
    Top = 306
    TabOrder = 29
    Width = 332
  end
  object edNameUkr: TcxTextEdit [30]
    Left = 8
    Top = 344
    TabOrder = 30
    Width = 332
  end
  object cxLabel12: TcxLabel [31]
    Left = 8
    Top = 326
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1082#1088#1072#1080#1085#1089#1082#1086#1077
  end
  object cxLabel13: TcxLabel [32]
    Left = 8
    Top = 363
    Caption = #1050#1086#1076' '#1059#1050#1058#1047#1069#1044
  end
  object ceExchange: TcxButtonEdit [33]
    Left = 248
    Top = 380
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 33
    Width = 92
  end
  object cxLabel14: TcxLabel [34]
    Left = 248
    Top = 363
    Caption = #1054#1076':'
  end
  object ceCodeUKTZED: TcxTextEdit [35]
    Left = 9
    Top = 380
    TabOrder = 35
    Width = 212
  end
  object ceGoodsAnalog: TcxButtonEdit [36]
    Left = 9
    Top = 268
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 36
    Width = 332
  end
  object cxLabel15: TcxLabel [37]
    Left = 9
    Top = 250
    Caption = #1040#1085#1072#1083#1086#1075' '#1090#1086#1074#1072#1088#1072
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReferCode'
        Value = Null
        Component = ceReferCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReferPrice'
        Value = Null
        Component = ceReferPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = ceSalePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClose'
        Value = Null
        Component = cbIsClose
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTOP'
        Value = Null
        Component = cbIsTop
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentMarkup'
        Value = Null
        Component = cePercentMarkup
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMorionCode'
        Value = 0
        Component = ceMorionCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBarCode'
        Value = Null
        Component = ceBarCode
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNameUkr'
        Value = Null
        Component = edNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeUKTZED'
        Value = Null
        Component = ceCodeUKTZED
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExchangeId'
        Value = Null
        Component = dsdExchangeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsAnalogId'
        Value = Null
        Component = GuidesGoodsAnalog
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = edMinimumLot
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReferCode'
        Value = Null
        Component = ceReferCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReferPrice'
        Value = Null
        Component = ceReferPrice
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = Null
        Component = ceSalePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClose'
        Value = Null
        Component = cbIsClose
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTop'
        Value = Null
        Component = cbIsTop
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = cePercentMarkup
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsFirst'
        Value = Null
        Component = cbIsFirst
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsSecond'
        Value = Null
        Component = cbIsSecond
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = ceMorionCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = ceBarCode
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NameUkr'
        Value = Null
        Component = edNameUkr
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CodeUKTZED'
        Value = Null
        Component = ceCodeUKTZED
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExchangeId'
        Value = Null
        Component = dsdExchangeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExchangeName'
        Value = Null
        Component = dsdExchangeGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsAnalogId'
        Value = Null
        Component = GuidesGoodsAnalog
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsAnalogName'
        Value = Null
        Component = GuidesGoodsAnalog
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 233
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceParentGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 98
  end
  object dsdMeasureGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceMeasure
    FormNameParam.Value = 'TMeasureForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMeasureForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdMeasureGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 169
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceNDSKind
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 296
    Top = 137
  end
  object dsdExchangeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceExchange
    FormNameParam.Value = 'TExchangeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TExchangeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdExchangeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdExchangeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 369
  end
  object GuidesGoodsAnalog: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceGoodsAnalog
    FormNameParam.Value = 'TGoodsAnalogForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsAnalogForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoodsAnalog
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoodsAnalog
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 258
  end
end
