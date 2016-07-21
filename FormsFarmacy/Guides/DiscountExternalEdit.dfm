﻿object DiscountExternalEditForm: TDiscountExternalEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100'  <'#1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')>'
  ClientHeight = 418
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 51
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1077#1082#1090#1072
  end
  object cxButton1: TcxButton
    Left = 90
    Top = 367
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 240
    Top = 367
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 5
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 40
    Top = 147
    Caption = #1057#1077#1088#1074#1080#1089
  end
  object ceService: TcxTextEdit
    Left = 40
    Top = 167
    TabOrder = 7
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 98
    Caption = 'URL'
  end
  object ceURL: TcxTextEdit
    Left = 40
    Top = 120
    TabOrder = 9
    Width = 296
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 195
    Caption = #1055#1086#1088#1090
  end
  object cePort: TcxTextEdit
    Left = 40
    Top = 215
    TabOrder = 11
    Width = 296
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 251
    Caption = #1051#1086#1075#1080#1085
  end
  object ceUserName: TcxTextEdit
    Left = 40
    Top = 271
    TabOrder = 13
    Width = 296
  end
  object cxLabel6: TcxLabel
    Left = 40
    Top = 307
    Caption = #1055#1072#1088#1086#1083#1100
  end
  object cePassword: TcxTextEdit
    Left = 40
    Top = 327
    TabOrder = 15
    Width = 296
  end
  object ActionList: TActionList
    Left = 272
    Top = 20
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_DiscountExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
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
        Name = 'inURL'
        Value = Null
        Component = ceURL
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inService'
        Value = ''
        Component = ceService
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPort'
        Value = Null
        Component = cePort
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserName'
        Value = Null
        Component = ceUserName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassword'
        Value = Null
        Component = cePassword
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 120
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 72
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_DiscountExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
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
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'URL'
        Value = ''
        Component = ceURL
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Service'
        Value = ''
        Component = ceService
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        Component = cePort
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = ceUserName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = cePassword
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 160
    Top = 23
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 328
    Top = 64
  end
end
