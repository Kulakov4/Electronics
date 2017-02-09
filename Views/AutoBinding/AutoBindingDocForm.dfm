object frmAutoBindingDoc: TfrmAutoBindingDoc
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1092#1072#1081#1083#1072#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
  ClientHeight = 391
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    501
    391)
  PixelsPerInch = 96
  TextHeight = 16
  object cxGroupBox1: TcxGroupBox
    Left = 8
    Top = 8
    Anchors = [akLeft, akTop, akRight]
    Caption = ' '#1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1082' '#1092#1072#1081#1083#1072#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080' '
    TabOrder = 0
    ExplicitWidth = 474
    Height = 121
    Width = 485
    object cxcbDatasheet: TcxCheckBox
      Left = 20
      Top = 32
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      State = cbsChecked
      TabOrder = 0
    end
    object cxcbDiagram: TcxCheckBox
      Left = 20
      Top = 80
      Caption = #1057#1093#1077#1084#1072
      State = cbsChecked
      TabOrder = 1
    end
    object cxcbDrawing: TcxCheckBox
      Left = 225
      Top = 32
      Caption = #1063#1077#1088#1090#1105#1078
      State = cbsChecked
      TabOrder = 2
    end
    object cxcbImage: TcxCheckBox
      Left = 225
      Top = 80
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      State = cbsChecked
      TabOrder = 3
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 144
    Width = 485
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = #1045#1089#1083#1080' '#1086#1076#1085#1086#1084#1091' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1091' '#1087#1086#1076#1073#1080#1088#1072#1077#1090#1089#1103' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1092#1072#1081#1083#1086#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
    TabOrder = 1
    ExplicitWidth = 474
    object cxrbNoRange: TcxRadioButton
      Left = 20
      Top = 32
      Width = 309
      Height = 17
      Caption = #1057#1095#1080#1090#1072#1090#1100' '#1101#1090#1086' '#1086#1096#1080#1073#1082#1086#1081' '#1080' '#1085#1077' '#1074#1099#1087#1086#1083#1085#1103#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1091
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object cxrbNarrowRange: TcxRadioButton
      Left = 20
      Top = 64
      Width = 399
      Height = 17
      Caption = #1042#1099#1073#1080#1088#1072#1090#1100' '#1092#1072#1081#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080' '#1089' '#1089#1072#1084#1099#1084' '#1091#1079#1082#1080#1084' '#1076#1080#1072#1087#1072#1079#1086#1085#1086#1084
      TabOrder = 1
    end
  end
  object cxbtnAllDB: TcxButton
    Left = 8
    Top = 343
    Width = 153
    Height = 40
    Action = actAll
    Anchors = [akLeft, akBottom]
    Default = True
    ModalResult = 12
    TabOrder = 2
    WordWrap = True
    ExplicitTop = 274
  end
  object cxbtnCategoryDB: TcxButton
    Left = 174
    Top = 343
    Width = 153
    Height = 40
    Action = actCategory
    Anchors = [akLeft, akBottom]
    ModalResult = 1
    TabOrder = 3
    WordWrap = True
    ExplicitTop = 265
  end
  object cxbtnCancel: TcxButton
    Left = 340
    Top = 343
    Width = 153
    Height = 40
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
    WordWrap = True
    ExplicitTop = 265
  end
  object cxGroupBox2: TcxGroupBox
    Left = 8
    Top = 255
    Caption = ' '#1054#1090#1095#1105#1090#1099' '
    TabOrder = 5
    Height = 74
    Width = 485
    object cxcbAbsentDoc: TcxCheckBox
      Left = 20
      Top = 32
      Caption = #1054#1090#1095#1105#1090' '#1086' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1072#1093' '#1076#1083#1103' '#1082#1086#1090#1086#1088#1099#1093' '#1085#1077' '#1085#1072#1081#1076#1077#1085#1099' '#1092#1072#1081#1083#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1080
      TabOrder = 0
    end
  end
  object ActionList: TActionList
    Left = 168
    Top = 48
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
