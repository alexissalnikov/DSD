object RepriceUnitForm: TRepriceUnitForm
  Left = 0
  Top = 0
  Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1082#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
  ClientHeight = 594
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 368
    Top = 16
    Width = 81
    Height = 25
    Caption = #1055#1077#1088#1077#1086#1094#1077#1085#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckListBox: TCheckListBox
    Left = 8
    Top = 8
    Width = 297
    Height = 257
    ItemHeight = 13
    TabOrder = 1
  end
  object cePercentDifference: TcxCurrencyEdit
    Left = 328
    Top = 78
    EditValue = 30.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = ',0.'
    TabOrder = 2
    Width = 121
  end
  object cxLabel1: TcxLabel
    Left = 328
    Top = 56
    Caption = '% '#1088#1072#1079#1085#1080#1094#1099' '#1094#1077#1085#1099
  end
  object AllGoodsPriceGrid: TcxGrid
    Left = 0
    Top = 287
    Width = 670
    Height = 307
    Align = alBottom
    TabOrder = 4
    ExplicitWidth = 469
    object AllGoodsPriceGridTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = QueryDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.GroupByBox = False
      object colGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
      end
      object colGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        Width = 303
      end
      object colOldPrice: TcxGridDBColumn
        Caption = #1058#1077#1082#1091#1097#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'LastPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Width = 82
      end
      object colNewPrice: TcxGridDBColumn
        Caption = #1053#1086#1074#1072#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'NewPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00'
        Width = 88
      end
      object colPercent: TcxGridDBColumn
        Caption = '% '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        DataBinding.FieldName = 'Percent'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0'
        Width = 92
      end
    end
    object AllGoodsPriceGridLevel: TcxGridLevel
      GridView = AllGoodsPriceGridTableView
    end
  end
  object Button2: TButton
    Left = 384
    Top = 208
    Width = 75
    Height = 25
    Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
    TabOrder = 5
    OnClick = Button2Click
  end
  object GetUnitsList: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitForReprice'
    DataSet = UnitsCDS
    DataSets = <
      item
        DataSet = UnitsCDS
      end>
    Params = <>
    PackSize = 1
    Left = 184
    Top = 64
  end
  object UnitsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 112
    Top = 56
  end
  object UnitsDS: TDataSource
    DataSet = UnitsCDS
    Left = 112
    Top = 128
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    OnCalcFields = ADOQueryCalcFields
    Parameters = <>
    Left = 120
    Top = 16
    object ADOQueryId: TIntegerField
      FieldName = 'Id'
    end
    object ADOQueryCode: TIntegerField
      FieldName = 'Code'
    end
    object ADOQueryGoodsName: TStringField
      FieldName = 'GoodsName'
    end
    object ADOQueryLastPrice: TFloatField
      FieldName = 'LastPrice'
    end
    object ADOQueryNewPrice: TFloatField
      FieldKind = fkCalculated
      FieldName = 'NewPrice'
      Calculated = True
    end
    object ADOQueryPercent: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Percent'
      Calculated = True
    end
  end
  object ADOConnection: TADOConnection
    KeepConnection = False
    LoginPrompt = False
    Left = 184
    Top = 32
  end
  object spSelectPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'NewPrice'
        Value = Null
        DataType = ftFloat
      end>
    PackSize = 1
    Left = 192
    Top = 120
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 184
  end
  object spInsertUpdate: TADOStoredProc
    Connection = ADOConnection
    ProcedureName = 'dba.InsertUpdateLastPriceList'
    Parameters = <
      item
        Name = '@CategoriesId'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@LastPrice'
        DataType = ftFloat
        Value = Null
      end
      item
        Name = '@GoodsPropertyID'
        DataType = ftInteger
        Value = Null
      end
      item
        Name = '@StartDate'
        DataType = ftDateTime
        Value = Null
      end>
    Left = 280
    Top = 200
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = AllGoodsPriceGridTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 432
    Top = 400
  end
  object spSelect_AllGoodsPrice: TdsdStoredProc
    StoredProcName = 'gpSelect_AllGoodsPrice'
    DataSet = AllGoodsPriceCDS
    DataSets = <
      item
        DataSet = AllGoodsPriceCDS
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 312
    Top = 408
  end
  object AllGoodsPriceCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 200
    Top = 432
  end
  object AllGoodPriceDS: TDataSource
    DataSet = AllGoodsPriceCDS
    Left = 120
    Top = 432
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
      end>
    Left = 192
    Top = 360
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 256
    Top = 312
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 192
    Top = 312
  end
  object ActionList1: TActionList
    Left = 120
    Top = 376
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetAfterExecute = True
      StoredProc = spSelect_AllGoodsPrice
      StoredProcList = <
        item
          StoredProc = spSelect_AllGoodsPrice
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object QueryDS: TDataSource
    DataSet = ResultCDS
    Left = 488
    Top = 176
  end
  object ResultCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 392
    Top = 128
  end
  object DataSetProvider: TDataSetProvider
    DataSet = ADOQuery
    Left = 488
    Top = 128
  end
end
