object frmProgressBar: TfrmProgressBar
  Left = 0
  Top = 0
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
  ClientHeight = 97
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 397
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object cxlblProgress: TcxLabel
      Left = 22
      Top = 16
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1086' '#1089#1090#1088#1086#1082': 0'
    end
    object cxpbMain: TcxProgressBar
      Left = 22
      Top = 48
      TabOrder = 1
      Width = 353
    end
  end
end
