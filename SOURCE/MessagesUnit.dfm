object MessagesForm: TMessagesForm
  Left = 283
  Top = 85
  BorderStyle = bsDialog
  Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1080#1081' '#1059#1095#1077#1090' '#171'Project'#187
  ClientHeight = 423
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object rlError: TLabel
    Left = 0
    Top = 0
    Width = 467
    Height = 181
    Align = alClient
    Alignment = taCenter
    Caption = 'rlError'
    Layout = tlCenter
    WordWrap = True
    ExplicitWidth = 27
    ExplicitHeight = 13
  end
  object meFullMessage: TMemo
    Left = 0
    Top = 222
    Width = 467
    Height = 201
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    Visible = False
  end
  object paButtons: TPanel
    Left = 0
    Top = 181
    Width = 467
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOk: TBitBtn
      Left = 203
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object btnDetails: TButton
      Left = 389
      Top = 8
      Width = 73
      Height = 25
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' >>'
      TabOrder = 1
      OnClick = btnDetailsClick
    end
  end
  object ActionList: TActionList
    Left = 222
    Top = 68
    object actExit: TAction
      Caption = #1042#1099#1093#1086#1076
      Hint = #1042#1099#1093#1086#1076
      ShortCut = 27
      OnExecute = actExitExecute
    end
  end
end
