object MainCehForm: TMainCehForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
  ClientHeight = 641
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 352
    Top = 33
    Width = 617
    Height = 608
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 617
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bbDeleteItem: TSpeedButton
        Left = 225
        Top = 2
        Width = 31
        Height = 29
        Hint = #1091#1076#1072#1083#1080#1090#1100'/'#1074#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
        Glyph.Data = {
          C6040000424DC60400000000000036040000280000000C0000000C0000000100
          0800000000009000000000000000000000000001000000000000000000004000
          000080000000FF000000002000004020000080200000FF200000004000004040
          000080400000FF400000006000004060000080600000FF600000008000004080
          000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
          000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
          200080002000FF002000002020004020200080202000FF202000004020004040
          200080402000FF402000006020004060200080602000FF602000008020004080
          200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
          200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
          400080004000FF004000002040004020400080204000FF204000004040004040
          400080404000FF404000006040004060400080604000FF604000008040004080
          400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
          400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
          600080006000FF006000002060004020600080206000FF206000004060004040
          600080406000FF406000006060004060600080606000FF606000008060004080
          600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
          600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
          800080008000FF008000002080004020800080208000FF208000004080004040
          800080408000FF408000006080004060800080608000FF608000008080004080
          800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
          800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
          A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
          A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
          A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
          A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
          C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
          C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
          C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
          C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
          FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
          FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
          FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
          FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          00000000000000000000FF00E0E0E0E0E0E0E0E0E000FF00E0E0E0E0E0E0E0E0
          E000FF00E0E0E0E0E0E0E0E0E000FF0000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbDeleteItemClick
      end
      object bbExit: TSpeedButton
        Left = 489
        Top = 2
        Width = 31
        Height = 29
        Action = actExit
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888808077708888888880807770880800008080777088888880008077
          7088888880088078708800808000807770888888000000777088888888008007
          7088888880008077708888888800800770888888888880000088888888888888
          8888888888884444888888888888488488888888888844448888}
        ParentShowHint = False
        ShowHint = True
      end
      object bbRefresh: TSpeedButton
        Left = 380
        Top = 2
        Width = 31
        Height = 29
        Action = actRefresh
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          00007777770FFFFFFFF000700000FF0F00F0E00BFBFB0FFFFFF0E0BFBF000FFF
          F0F0E0FBFBFBF0F00FF0E0BFBF00000B0FF0E0FBFBFBFBF0FFF0E0BF0000000F
          FFF0000BFB00B0FF00F07770000B0FFFFFF0777770B0FFFF000077770B0FF00F
          0FF07770B00FFFFF0F077709070FFFFF00777770770000000777}
        ParentShowHint = False
        ShowHint = True
      end
      object bbExportToEDI: TSpeedButton
        Left = 658
        Top = 3
        Width = 31
        Height = 29
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' EDI'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888873333333333338887BB3B33B3B3
          B38887B3B3B13B3B3388873B3B9913B3B38887B3B399973B3388873B397B9973
          B38887B397BBB997338887FFFFFFFF91BB8888FBBBBB88891888888FFFF88888
          9188888888888888898888888888888888988888888888888888}
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object bbChoice_UnComlete: TSpeedButton
        Left = 287
        Top = 2
        Width = 31
        Height = 29
        Hint = #1042#1077#1088#1085#1091#1090#1100#1089#1103' '#1082' '#1085#1077' '#1079#1072#1082#1088#1099#1090#1086#1084#1091' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102
        Glyph.Data = {
          06020000424D0602000000000000760000002800000019000000190000000100
          0400000000009001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888000000088888888888888888888888880000000888888888888
          8888888888888000000088888888888888888888888880000000888888888887
          7777788888888000000088888888800000377788888880000000888888880EEE
          E0307778888880000000888888880EEEE030777888888000000088888880EEEE
          0333077888888000000088888880EEEE03330778888880000000888888800000
          0333077888888000000088888888887033330778888880000000888888888000
          33330778888880000000888888880EE03333077888888000000088888880EEEE
          033307788888800000008888880EEEEEE0330778888880000000888880EEEEEE
          EE03077888888000000088888000EEEE0003077888888000000088888880EEEE
          03330788888880000000888888880EEEE0307888888880000000888888880EEE
          E030888888888000000088888888800000388888888880000000888888888888
          8888888888888000000088888888888888888888888880000000888888888888
          88888888888880000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChoice_UnComleteClick
      end
      object bbView_all: TSpeedButton
        Left = 318
        Top = 2
        Width = 31
        Height = 29
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1042#1057#1045#1061'> '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
        Glyph.Data = {
          06020000424D0602000000000000760000002800000019000000190000000100
          0400000000009001000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777000000077777777777777777777777770000000777777777777
          7777777777777000000077777777777777777777777770000000777777777778
          8888877777777000000077777777700000388877777770000000777777770BBB
          B0308887777770000000777777770BBBB030888777777000000077777770BBBB
          0333088777777000000077777770BBBB03330887777770000000777777700000
          0333088777777000000077777777778033330887777770000000777777777000
          33330887777770000000777777770BB03333088777777000000077777770BBBB
          033308877777700000007777770BBBBBB0330887777770000000777770BBBBBB
          BB03088777777000000077777000BBBB0003088777777000000077777770BBBB
          03330877777770000000777777770BBBB0308777777770000000777777770BBB
          B030777777777000000077777777700000377777777770000000777777777777
          7777777777777000000077777777777777777777777770000000777777777777
          77777777777770000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbView_allClick
      end
      object bbChangeCount: TSpeedButton
        Left = 102
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1072#1090#1086#1085#1086#1074'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800E308888888888880EE308888888888880EE308888888888880EE308
          888888888880EE308888888888880EE308888888888880EE0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeCountClick
      end
      object bbChangeLiveWeight: TSpeedButton
        Left = 34
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1046#1080#1074#1086#1081' '#1074#1077#1089'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800B308888888888880BB308888888888880BB308888888888880BB308
          888888888880BB308888888888880BB308888888888880BB0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeLiveWeightClick
      end
      object bbChangeCountPack: TSpeedButton
        Left = 133
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1072#1082#1077#1090#1086#1074'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800B308888888888880BB308888888888880BB308888888888880BB308
          888888888880BB308888888888880BB308888888888880BB0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeCountPackClick
      end
      object bbChangeHeadCount: TSpeedButton
        Left = 3
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1075#1086#1083#1086#1074'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800E308888888888880EE308888888888880EE308888888888880EE308
          888888888880EE308888888888880EE308888888888880EE0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeHeadCountClick
      end
      object bbChangePartionGoods: TSpeedButton
        Left = 65
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888870888888888888873308888888888888733088888888888887330888888
          8888888733088888888888887330888888888888873308888088888888733088
          8008888888873308087088888888730700888888888880887888888888888088
          0888888888880800888888888888808888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangePartionGoodsClick
      end
      object bbChangePartionGoodsDate: TSpeedButton
        Left = 164
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1072#1088#1090#1080#1103' '#1044#1040#1058#1040'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888870888888888888873308888888888888733088888888888887330888888
          8888888733088888888888887330888888888888873308888088888888733088
          8008888888873308087088888888730700888888888880887888888888888088
          0888888888880800888888888888808888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangePartionGoodsDateClick
      end
    end
    object infoPanelTotalSumm: TPanel
      Left = 0
      Top = 567
      Width = 617
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object gbWeightTare: TGroupBox
        Left = 240
        Top = 0
        Width = 100
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
        TabOrder = 0
        object PanelWeightTare: TPanel
          Left = 2
          Top = 15
          Width = 96
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightTare'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbWeightOther: TGroupBox
        Left = 340
        Top = 0
        Width = 140
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1082#1088','#1096#1087','#1087#1088#1086#1095
        TabOrder = 1
        object PanelWeightOther: TPanel
          Left = 2
          Top = 15
          Width = 136
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightOther'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbRealWeight: TGroupBox
        Left = 0
        Top = 0
        Width = 140
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
        TabOrder = 2
        object PanelRealWeight: TPanel
          Left = 2
          Top = 15
          Width = 136
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelRealWeight'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbCountSkewer: TGroupBox
        Left = 480
        Top = 0
        Width = 100
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083' '#1096#1087','#1082#1088
        TabOrder = 3
        object PanelCountSkewer: TPanel
          Left = 2
          Top = 15
          Width = 96
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelCountSkewer'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbAmountWeight: TGroupBox
        Left = 140
        Top = 0
        Width = 100
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1087#1088#1086#1076'.'
        TabOrder = 4
        object PanelAmountWeight: TPanel
          Left = 2
          Top = 15
          Width = 96
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelAmountWeight'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 617
      Height = 534
      Align = alClient
      TabOrder = 2
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Count
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = HeadCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = LiveWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightTare
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer1_k
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer1_k
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightOther
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountPack
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Count
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = HeadCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = LiveWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightTare
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer1_k
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer1_k
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer1
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountSkewer2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = TotalWeightSkewer2
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightOther
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountPack
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 200
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object PartionGoods: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071
          DataBinding.FieldName = 'PartionGoods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 90
        end
        object PartionGoodsDate: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103' '#1044#1040#1058#1040
          DataBinding.FieldName = 'PartionGoodsDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object isStartWeighing: TcxGridDBColumn
          Caption = #1056#1077#1078#1080#1084' '#1085#1086#1074'.'
          DataBinding.FieldName = 'isStartWeighing'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object Count: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1073#1072#1090'.'
          DataBinding.FieldName = 'Count'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 45
        end
        object CountPack: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1087#1072#1082'.'
          DataBinding.FieldName = 'CountPack'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object HeadCount: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
          DataBinding.FieldName = 'HeadCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object LiveWeight: TcxGridDBColumn
          Caption = #1046#1080#1074#1086#1081' '#1074#1077#1089
          DataBinding.FieldName = 'LiveWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object Amount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object RealWeight: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
          DataBinding.FieldName = 'RealWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object WeightTare: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1090#1072#1088#1099
          DataBinding.FieldName = 'WeightTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object CountSkewer1_k: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1082#1088#1102#1095'.'
          DataBinding.FieldName = 'CountSkewer1_k'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object WeightSkewer1_k: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1086#1076#1085'. '#1082#1088#1102#1095'.'
          DataBinding.FieldName = 'WeightSkewer1_k'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalWeightSkewer1_k: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1082#1088#1102#1095'.'
          DataBinding.FieldName = 'TotalWeightSkewer1_k'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object CountSkewer1: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1096#1087'.1'
          DataBinding.FieldName = 'CountSkewer1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object WeightSkewer1: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1086#1076#1085'. '#1096#1087'.1'
          DataBinding.FieldName = 'WeightSkewer1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalWeightSkewer1: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1096#1087'.1'
          DataBinding.FieldName = 'TotalWeightSkewer1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object CountSkewer2: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1096#1087'.2'
          DataBinding.FieldName = 'CountSkewer2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object WeightSkewer2: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1086#1076#1085'. '#1096#1087'.2'
          DataBinding.FieldName = 'WeightSkewer2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalWeightSkewer2: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1096#1087'.2'
          DataBinding.FieldName = 'TotalWeightSkewer2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object WeightOther: TcxGridDBColumn
          Caption = #1042#1077#1089', '#1087#1088#1086#1095#1077#1077
          DataBinding.FieldName = 'WeightOther'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'('#1074#1088') '#1089#1086#1079#1076#1072#1085#1080#1103
          DataBinding.FieldName = 'InsertDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'('#1074#1088') '#1080#1079#1084'.'
          DataBinding.FieldName = 'UpdateDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object PanelSaveItem: TPanel
    Left = 222
    Top = 33
    Width = 130
    Height = 608
    Align = alLeft
    BevelOuter = bvNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object infoPanel_Scale: TPanel
      Left = 0
      Top = 573
      Width = 130
      Height = 35
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object ScaleLabel: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = 'Scale.Active = ???'
        ExplicitWidth = 91
      end
      object PanelWeight_Scale: TPanel
        Left = 1
        Top = 15
        Width = 128
        Height = 19
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Weight=???'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        OnDblClick = PanelWeight_ScaleDblClick
      end
    end
    object rgScale: TRadioGroup
      Left = 0
      Top = 456
      Width = 130
      Height = 117
      Align = alBottom
      Caption = #1042#1077#1089#1099
      TabOrder = 1
      OnClick = rgScaleClick
    end
    object Panel25: TPanel
      Left = 0
      Top = 0
      Width = 130
      Height = 40
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      TabOrder = 2
      object Label17: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Caption = '   '#1057#1084#1077#1085#1072' '#1079#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 59
      end
      object OperDateEdit: TcxDateEdit
        Left = 10
        Top = 14
        EditValue = 41640d
        Properties.DateButtons = [btnToday]
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 0
        Width = 110
      end
    end
    object PanelPartionDate: TPanel
      Left = 0
      Top = 40
      Width = 130
      Height = 40
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      TabOrder = 3
      object LabelPartionDate: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Caption = '   '#1055#1072#1088#1090#1080#1103' '#1079#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 62
      end
      object PartionDateEdit: TcxDateEdit
        Left = 10
        Top = 15
        EditValue = 41640d
        Properties.DateButtons = [btnToday]
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 0
        Width = 110
      end
    end
    object HeadCountPanel: TPanel
      Left = 0
      Top = 396
      Width = 130
      Height = 60
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object HeadCountLabel: TLabel
        Left = 0
        Top = 0
        Width = 130
        Height = 15
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1050#1054#1051#1048#1063#1045#1057#1058#1042#1054
        ExplicitWidth = 112
      end
      object EditEnterCount: TcxCurrencyEdit
        Left = 10
        Top = 14
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 0
        Properties.OnChange = EditEnterCountPropertiesChange
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -12
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        OnEnter = EditEnterCountEnter
        OnExit = EditEnterCountExit
        OnKeyDown = EditEnterCountKeyDown
        Width = 110
      end
    end
  end
  object PanelInfoItem: TPanel
    Left = 352
    Top = 33
    Width = 0
    Height = 608
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object PanelProduction_Goods: TPanel
      Left = 0
      Top = 15
      Width = 0
      Height = 136
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 0
      object LabelProduction_Goods: TLabel
        Left = 0
        Top = 0
        Width = 0
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1090#1086#1074#1072#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 115
      end
      object GBProduction_GoodsCode: TGroupBox
        Left = 0
        Top = 13
        Width = 0
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object PanelProduction_GoodsCode: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_GoodsCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object EditProduction_GoodsCode: TEdit
            Left = 2
            Top = 1
            Width = 195
            Height = 21
            TabOrder = 0
            Text = 'EditProduction_GoodsCode'
          end
        end
      end
      object GBProduction_Goods_Weight: TGroupBox
        Left = 0
        Top = 95
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1042#1077#1089
        TabOrder = 1
        object PanelProduction_Goods_Weight: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_Goods_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBProduction_GoodsName: TGroupBox
        Left = 0
        Top = 54
        Width = 0
        Height = 41
        Align = alClient
        Caption = #1053#1072#1084#1077#1085#1086#1074#1072#1085#1080#1077
        TabOrder = 2
        object PanelProduction_GoodsName: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_GoodsName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelTare_Goods: TPanel
      Left = 0
      Top = 166
      Width = 0
      Height = 173
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LabelTare_Goods: TLabel
        Left = 0
        Top = 0
        Width = 0
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1058#1072#1088#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 30
      end
      object GBTare_GoodsCode: TGroupBox
        Left = 0
        Top = 13
        Width = 0
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object PanelTare_GoodsCode: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_GoodsCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBTare_Goods_Weight: TGroupBox
        Left = 0
        Top = 132
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1042#1077#1089
        TabOrder = 1
        object PanelTare_Goods_Weight: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_Goods_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBTare_GoodsName: TGroupBox
        Left = 0
        Top = 54
        Width = 0
        Height = 37
        Align = alClient
        Caption = #1053#1072#1084#1077#1085#1086#1074#1072#1085#1080#1077
        TabOrder = 2
        object PanelTare_GoodsName: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_GoodsName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbTare_Goods_Count: TGroupBox
        Left = 0
        Top = 91
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        TabOrder = 3
        object PanelTare_Goods_Count: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_Goods_Count'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object PanelSpace1: TPanel
      Left = 0
      Top = 0
      Width = 0
      Height = 15
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object PanelSpace2: TPanel
      Left = 0
      Top = 151
      Width = 0
      Height = 15
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object infoPanelTotalWeight: TPanel
      Left = 0
      Top = 571
      Width = 0
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object GBTotalWeight: TGroupBox
        Left = 0
        Top = 0
        Width = 122
        Height = 37
        Align = alClient
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object PanelTotalWeight: TPanel
          Left = 2
          Top = 15
          Width = 118
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBDiscountWeight: TGroupBox
        Left = -81
        Top = 0
        Width = 81
        Height = 37
        Align = alRight
        Caption = #1057#1082#1076' ('#1074#1077#1089')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object PanelDiscountWeight: TPanel
          Left = 2
          Top = 15
          Width = 77
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelDiscountWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object infoPanel_mastre: TPanel
    Left = 0
    Top = 0
    Width = 969
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object PanelMovement: TPanel
      Left = 649
      Top = 0
      Width = 320
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      Caption = 'PanelMovement'
      TabOrder = 0
    end
    object PanelMovementDesc: TPanel
      Left = 0
      Top = 0
      Width = 649
      Height = 33
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMovementDesc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 33
    Width = 222
    Height = 608
    Align = alLeft
    BevelOuter = bvNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object PanelGoods: TPanel
      Left = 0
      Top = 40
      Width = 222
      Height = 73
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object LabelGoods: TLabel
        Left = 0
        Top = 0
        Width = 222
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 61
      end
      object Panel3: TPanel
        Left = 0
        Top = 14
        Width = 222
        Height = 36
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object PanelGoodsCode: TPanel
          Left = 0
          Top = 0
          Width = 100
          Height = 36
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object LabelGoodsCode: TLabel
            Left = 0
            Top = 0
            Width = 100
            Height = 14
            Align = alTop
            Alignment = taCenter
            Caption = #1050#1086#1076
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ExplicitWidth = 19
          end
          object EditGoodsCode: TcxCurrencyEdit
            Left = 4
            Top = 12
            Properties.Alignment.Horz = taRightJustify
            Properties.Alignment.Vert = taVCenter
            Properties.AssignedValues.DisplayFormat = True
            Properties.DecimalPlaces = 0
            TabOrder = 0
            OnExit = EditGoodsCodeExit
            OnKeyDown = EditGoodsCodeKeyDown
            Width = 90
          end
        end
        object infoPanelGoodsWeight: TPanel
          Left = 100
          Top = 0
          Width = 122
          Height = 36
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          object LabelGoodsWeight: TLabel
            Left = 0
            Top = 0
            Width = 122
            Height = 14
            Align = alTop
            Alignment = taCenter
            Caption = #1042#1077#1089
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ExplicitWidth = 19
          end
          object PanelGoodsWeight: TPanel
            Left = 0
            Top = 14
            Width = 122
            Height = 22
            Align = alClient
            BevelOuter = bvNone
            Caption = 'PanelGoodsWeight'
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
        end
      end
      object PanelGoodsName: TPanel
        Left = 0
        Top = 50
        Width = 222
        Height = 23
        Align = alClient
        Caption = 'PanelGoodsName'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
    object PanelGoodsKind: TPanel
      Left = 0
      Top = 183
      Width = 222
      Height = 156
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LabelGoodsKind: TLabel
        Left = 0
        Top = 0
        Width = 222
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1091#1087#1072#1082#1086#1074#1082#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 106
      end
      object PanelGoodsKindCode: TPanel
        Left = 0
        Top = 14
        Width = 222
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object EditGoodsKindCode: TcxCurrencyEdit
          Left = 5
          Top = 0
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditGoodsKindCodePropertiesChange
          TabOrder = 0
          OnEnter = EditGoodsKindCodeEnter
          OnExit = EditGoodsKindCodeExit
          OnKeyDown = EditGoodsKindCodeKeyDown
          Width = 90
        end
      end
      object rgGoodsKind: TRadioGroup
        Left = 0
        Top = 40
        Width = 222
        Height = 116
        Align = alClient
        Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = rgGoodsKindClick
      end
    end
    object PanelPartionGoods: TPanel
      Left = 0
      Top = 339
      Width = 222
      Height = 41
      Align = alTop
      TabOrder = 2
      object LabelPartionGoods: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1055#1040#1056#1058#1048#1071' '#1057#1067#1056#1068#1071
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 119
      end
      object EditPartionGoods: TEdit
        Left = 5
        Top = 16
        Width = 190
        Height = 22
        TabOrder = 0
        Text = 'EditPartionGoods'
        OnEnter = EditPartionGoodsEnter
        OnExit = EditPartionGoodsExit
        OnKeyDown = EditPartionGoodsKeyDown
      end
    end
    object infoPanelCount: TPanel
      Left = 0
      Top = 380
      Width = 222
      Height = 51
      Align = alTop
      TabOrder = 3
      object LabelCount_all: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1082#1086#1083'-'#1074#1086' '#1096#1090'.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 88
      end
      object PanelCount: TPanel
        Left = 1
        Top = 15
        Width = 100
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object LabelCount: TLabel
          Left = 0
          Top = 0
          Width = 100
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1041#1072#1090#1086#1085#1099'/'#1064#1090#1091#1082#1080
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 75
        end
        object EditCount: TcxCurrencyEdit
          Left = 4
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 4
          Properties.OnChange = EditCountPropertiesChange
          TabOrder = 0
          OnKeyDown = EditCountKeyDown
          Width = 90
        end
      end
      object PanelLiveWeight: TPanel
        Left = 101
        Top = 15
        Width = 120
        Height = 35
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelCountPack: TLabel
          Left = 0
          Top = 0
          Width = 120
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1055#1072#1082#1077#1090#1099'/'#1046#1080#1074#1086#1081' '#1074#1077#1089
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 100
        end
        object EditCountPack: TcxCurrencyEdit
          Left = 5
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 4
          Properties.OnChange = EditCountPackPropertiesChange
          TabOrder = 0
          OnKeyDown = EditCountPackKeyDown
          Width = 90
        end
      end
    end
    object infoPanelSkewer2: TPanel
      Left = 0
      Top = 533
      Width = 222
      Height = 37
      Align = alTop
      TabOrder = 4
      object PanelSkewer2: TPanel
        Left = 1
        Top = 1
        Width = 100
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object LabelSkewer2: TLabel
          Left = 0
          Top = 0
          Width = 100
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 0.0 '#1082#1075
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 81
        end
        object EditSkewer2: TcxCurrencyEdit
          Left = 4
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditSkewer2PropertiesChange
          TabOrder = 0
          OnExit = EditSkewer2Exit
          OnKeyDown = EditSkewer2KeyDown
          Width = 90
        end
      end
      object infoPanelWeightSkewer2: TPanel
        Left = 101
        Top = 1
        Width = 120
        Height = 35
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelWeightSkewer2: TLabel
          Left = 0
          Top = 0
          Width = 120
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1042#1077#1089
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 19
        end
        object PanelWeightSkewer2: TPanel
          Left = 0
          Top = 14
          Width = 120
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightSkewer2'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object infoPanelTare_enter: TPanel
      Left = 0
      Top = 431
      Width = 222
      Height = 51
      Align = alTop
      TabOrder = 5
      object LabelTare_enter_all: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1058#1072#1088#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 26
      end
      object infoPanelWeightTare_enter: TPanel
        Left = 1
        Top = 15
        Width = 100
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object LabelWeightTare_enter: TLabel
          Left = 0
          Top = 0
          Width = 100
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1042#1077#1089
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 19
        end
        object EditWeightTare_enter: TcxCurrencyEdit
          Left = 4
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 2
          Properties.OnChange = EditWeightTare_enterPropertiesChange
          TabOrder = 0
          OnExit = EditWeightTare_enterExit
          OnKeyDown = EditWeightTare_enterKeyDown
          Width = 90
        end
      end
      object infoPanelWeightTare_enter_two: TPanel
        Left = 101
        Top = 15
        Width = 120
        Height = 35
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelWeightTare_enter_two: TLabel
          Left = 0
          Top = 0
          Width = 120
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1042#1077#1089
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 19
        end
        object PanelWeightTare_enter_two: TPanel
          Left = 0
          Top = 14
          Width = 120
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightTare_enter_two'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object infoPanelSkewer1: TPanel
      Left = 0
      Top = 482
      Width = 222
      Height = 51
      Align = alTop
      TabOrder = 6
      object LabelSkewer: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1064#1087#1072#1075#1080'/'#1050#1088#1102#1095#1082#1080
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 81
      end
      object PanelSkewer1: TPanel
        Left = 1
        Top = 15
        Width = 100
        Height = 35
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
        object LabelSkewer1: TLabel
          Left = 0
          Top = 0
          Width = 100
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086' 0.0 '#1082#1075
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 81
        end
        object EditSkewer1: TcxCurrencyEdit
          Left = 4
          Top = 12
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditSkewer1PropertiesChange
          TabOrder = 0
          OnExit = EditSkewer1Exit
          OnKeyDown = EditSkewer1KeyDown
          Width = 90
        end
      end
      object infoPanelWeightSkewer1: TPanel
        Left = 101
        Top = 15
        Width = 120
        Height = 35
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object LabelWeightSkewer1: TLabel
          Left = 0
          Top = 0
          Width = 120
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1042#1077#1089
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 19
        end
        object PanelWeightSkewer1: TPanel
          Left = 0
          Top = 14
          Width = 120
          Height = 21
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightSkewer1'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object infoPanelWeightOther: TPanel
      Left = 0
      Top = 570
      Width = 222
      Height = 38
      Align = alTop
      TabOrder = 7
      object LabelWeightOther: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1055#1088#1086#1095#1080#1077', '#1086#1073#1097#1080#1081' '#1074#1077#1089', '#1082#1075
        ExplicitWidth = 125
      end
      object EditWeightOther: TcxCurrencyEdit
        Left = 55
        Top = 14
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 2
        Properties.OnChange = EditWeightOtherPropertiesChange
        TabOrder = 0
        OnExit = EditWeightOtherExit
        OnKeyDown = EditWeightOtherKeyDown
        Width = 90
      end
    end
    object infoPanel_Weight: TPanel
      Left = 0
      Top = 573
      Width = 222
      Height = 35
      Align = alBottom
      TabOrder = 8
      object Label_Weight: TLabel
        Left = 1
        Top = 1
        Width = 220
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1054#1073#1097#1080#1081' '#1074#1077#1089
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 66
      end
      object Panel_Weight: TPanel
        Left = 1
        Top = 14
        Width = 220
        Height = 20
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel_Weight'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object gbStartWeighing: TRadioGroup
      Left = 0
      Top = 0
      Width = 222
      Height = 40
      Align = alTop
      Caption = #1056#1077#1078#1080#1084
      Columns = 2
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Items.Strings = (
        #1053#1086#1074#1099#1081
        #1054#1073#1085#1091#1083#1080#1090#1100)
      ParentFont = False
      TabOrder = 9
      OnClick = gbStartWeighingClick
      OnEnter = gbStartWeighingEnter
    end
    object PanelMovementInfo: TPanel
      Left = 0
      Top = 113
      Width = 222
      Height = 70
      Align = alTop
      BevelOuter = bvNone
      Caption = 'PanelMovementInfo'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      object MemoMovementInfo: TMemo
        Left = 0
        Top = 0
        Width = 222
        Height = 70
        Align = alClient
        Lines.Strings = (
          'MemoMovementInfo')
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object PopupMenu: TPopupMenu
    Left = 256
    Top = 184
    object miPrintZakazMinus: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1047#1072#1103#1074#1082#1072'/'#1055#1088#1086#1076#1072#1078#1072' ('#1089' '#1084#1080#1085#1091#1089#1086#1084')'
    end
    object miPrintZakazAll: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1047#1072#1103#1074#1082#1072'/'#1055#1088#1086#1076#1072#1078#1072' ('#1042#1057#1045')'
    end
    object miLine11: TMenuItem
      Caption = '-'
    end
    object miPrintBill_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '
    end
    object miPrintBill_andNaliog_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' + '#1053#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object miPrintBillTotal_byClient: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
    end
    object miPrintBillTotal_byFozzi: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1087#1086' '#1060#1086#1079#1079#1080
    end
    object miLine12: TMenuItem
      Caption = '-'
    end
    object miPrintSchet_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072
    end
    object miPrintBillTransport_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081' '#1085#1072#1083#1072#1076#1085#1086#1081
    end
    object miPrintBillTransportNew_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081' '#1085#1072#1083#1072#1076#1085#1086#1081' ('#1053#1054#1042#1040#1071')'
    end
    object miPrintBillKachestvo_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1059#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103
    end
    object miPrintBillNumberTare_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1089' '#1053#1086#1084#1077#1088#1086#1084' '#1071#1097#1080#1082#1072
    end
    object miPrintBillNotice_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
    end
    object miLine13: TMenuItem
      Caption = '-'
    end
    object miPrintSaleAll: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090' ('#1042#1057#1045')'
    end
    object miPrint_Report_byTare: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1088#1077
    end
    object miPrint_Report_byMemberProduction: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
    end
    object miLine14: TMenuItem
      Caption = '-'
    end
    object miScaleIni_DB: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1052#1072#1083#1099#1077' '#1042#1077#1089#1099' (DB)'
    end
    object miScaleIni_BI: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1041#1086#1083#1100#1096#1080#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miScaleIni_Zeus: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1047#1045#1059#1057' '#1042#1077#1089#1099'  (Zeus)'
    end
    object miScaleIni_BI_R: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1056#1077#1083#1100#1089#1086#1074#1099#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miLine15: TMenuItem
      Caption = '-'
    end
    object miScaleRun_DB: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1052#1072#1083#1099#1077' '#1042#1077#1089#1099' (DB)'
    end
    object miScaleRun_BI: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1041#1086#1083#1100#1096#1080#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miScaleRun_Zeus: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1047#1045#1059#1057' '#1042#1077#1089#1099'  (Zeus)'
    end
    object miScaleRun_BI_R: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1056#1077#1083#1100#1089#1086#1074#1099#1077' '#1042#1077#1089#1099' (BI)'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 400
    Top = 232
  end
  object DS: TDataSource
    DataSet = CDS
    Left = 472
    Top = 224
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDSAfterOpen
    Left = 408
    Top = 280
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 408
    Top = 392
  end
  object ActionList: TActionList
    Left = 592
    Top = 240
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
  end
end
