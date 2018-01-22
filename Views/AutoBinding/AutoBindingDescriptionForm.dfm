object frmAutoBindingDescriptions: TfrmAutoBindingDescriptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1077' '#1087#1088#1080#1082#1088#1077#1087#1083#1077#1085#1080#1077' '#1082#1088#1072#1090#1082#1080#1093' '#1086#1087#1080#1089#1072#1085#1080#1081
  ClientHeight = 146
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    501
    146)
  PixelsPerInch = 96
  TextHeight = 16
  object cxbtnAllDB: TcxButton
    Left = 8
    Top = 98
    Width = 153
    Height = 40
    Action = actAll
    Anchors = [akLeft, akBottom]
    Default = True
    ModalResult = 12
    TabOrder = 0
    WordWrap = True
  end
  object cxbtnCategoryDB: TcxButton
    Left = 173
    Top = 98
    Width = 153
    Height = 40
    Action = actCategory
    Anchors = [akLeft, akBottom]
    ModalResult = 1
    TabOrder = 1
    WordWrap = True
  end
  object cxbtnCancel: TcxButton
    Left = 338
    Top = 98
    Width = 153
    Height = 40
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
    WordWrap = True
  end
  object dxCheckGroupBox1: TdxCheckGroupBox
    Left = 8
    Top = 16
    Caption = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' '#1082' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1072#1084' '#1082#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103' '
    TabOrder = 3
    Height = 73
    Width = 483
    object CheckBox1: TCheckBox
      Left = 24
      Top = 32
      Width = 417
      Height = 17
      Caption = #1042#1099#1076#1072#1074#1072#1090#1100' '#1086#1096#1080#1073#1082#1091', '#1077#1089#1083#1080' '#1085#1072#1081#1076#1077#1085#1086' '#1073#1086#1083#1077#1077' '#1086#1076#1085#1086#1075#1086' '#1082#1088#1072#1090#1082#1086#1075#1086' '#1086#1087#1080#1089#1072#1085#1080#1103
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 456
    Top = 32
    object actAll: TAction
      Caption = #1042' '#1087#1086#1083#1085#1086#1084' '#1086#1073#1098#1105#1084#1077' '#1041#1044
      Hint = #1042' '#1087#1086#1083#1085#1086#1084' '#1086#1073#1098#1105#1084#1077' '#1041#1044
      OnUpdate = actAllUpdate
    end
    object actCategory: TAction
      Caption = #1042' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      Hint = #1042' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      OnUpdate = actAllUpdate
    end
  end
end
