object frmAutoBinding: TfrmAutoBinding
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072
  ClientHeight = 227
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 28
    Top = 20
    Width = 324
    Height = 36
    Caption = 
      #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1091#1102' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1092#1072#1081#1083#1086#1074' '#1076#1072#1085#1085#1099#1093' '#1082' '#1089#1074#1086#1080#1084' '#1082#1086#1084#1087#1086#1085#1077#1085 +
      #1090#1072#1084'?'
    WordWrap = True
  end
  object cxcbDatasheet: TcxCheckBox
    Left = 28
    Top = 72
    Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
    State = cbsChecked
    TabOrder = 0
  end
  object cxcbDiagram: TcxCheckBox
    Left = 28
    Top = 120
    Caption = #1057#1093#1077#1084#1072
    State = cbsChecked
    TabOrder = 1
  end
  object cxcbDrawing: TcxCheckBox
    Left = 233
    Top = 72
    Caption = #1063#1077#1088#1090#1105#1078
    State = cbsChecked
    TabOrder = 2
  end
  object cxcbImage: TcxCheckBox
    Left = 233
    Top = 120
    Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
    State = cbsChecked
    TabOrder = 3
  end
  object cxbtnAllDB: TcxButton
    Left = 28
    Top = 160
    Width = 102
    Height = 49
    Action = actAll
    Default = True
    TabOrder = 4
    WordWrap = True
  end
  object cxbtnCategoryDB: TcxButton
    Left = 138
    Top = 160
    Width = 102
    Height = 49
    Action = actCategory
    TabOrder = 5
    WordWrap = True
  end
  object cxbtnCancel: TcxButton
    Left = 248
    Top = 160
    Width = 102
    Height = 49
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
    WordWrap = True
  end
  object ActionList: TActionList
    Left = 160
    Top = 104
    object actAll: TAction
      Caption = #1042' '#1087#1086#1083#1085#1086#1084' '#1086#1073#1098#1105#1084#1077' '#1041#1044
      Hint = #1042' '#1087#1086#1083#1085#1086#1084' '#1086#1073#1098#1105#1084#1077' '#1041#1044
      OnExecute = actAllExecute
      OnUpdate = actAllUpdate
    end
    object actCategory: TAction
      Caption = #1042' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      Hint = #1042' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      OnExecute = actCategoryExecute
      OnUpdate = actAllUpdate
    end
  end
end
