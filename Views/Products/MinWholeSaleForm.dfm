object frmMinWholeSale: TfrmMinWholeSale
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1086#1087#1090#1086#1074#1072#1103' '#1085#1072#1094#1077#1085#1082#1072
  ClientHeight = 190
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    464
    190)
  PixelsPerInch = 96
  TextHeight = 18
  object cxLabel1: TcxLabel
    Left = 36
    Top = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1091#1102' '#1086#1087#1090#1086#1074#1091#1102' '#1085#1072#1094#1077#1085#1082#1091'?'
  end
  object cxseMinWholeSale: TcxSpinEdit
    Left = 394
    Top = 59
    Properties.AssignedValues.MinValue = True
    Properties.MaxValue = 300.000000000000000000
    Properties.ValueType = vtFloat
    TabOrder = 0
    Width = 49
  end
  object cxLabel2: TcxLabel
    Left = 36
    Top = 61
    Caption = #1056#1072#1079#1084#1077#1088' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1081' '#1086#1087#1090#1086#1074#1086#1081' '#1085#1072#1094#1077#1085#1082#1080' ('#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093'):'
  end
  object cxbtnYes: TcxButton
    Left = 43
    Top = 136
    Width = 177
    Height = 37
    Anchors = [akLeft, akBottom]
    Caption = #1044#1072
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cxbtnCancel: TcxButton
    Left = 243
    Top = 136
    Width = 177
    Height = 37
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1053#1077#1090
    ModalResult = 2
    TabOrder = 2
  end
  object cxcbSave: TcxCheckBox
    Left = 36
    Top = 96
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1101#1090#1086' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1082#1072#1082' '#1079#1085#1072#1095#1077#1085#1080#1077' "'#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102'"'
    State = cbsChecked
    TabOrder = 5
  end
end
