object FrmCreateBill: TFrmCreateBill
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1089#1095#1105#1090#1072
  ClientHeight = 283
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    340
    283)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 79
    Height = 16
    Caption = #1053#1086#1084#1077#1088' '#1089#1095#1105#1090#1072':'
  end
  object Label2: TLabel
    Left = 24
    Top = 66
    Width = 66
    Height = 16
    Caption = #1044#1072#1090#1072' '#1089#1095#1105#1090#1072
  end
  object Label3: TLabel
    Left = 24
    Top = 195
    Width = 83
    Height = 16
    Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080
  end
  object Label4: TLabel
    Left = 24
    Top = 109
    Width = 81
    Height = 16
    Caption = #1050#1091#1088#1089' '#1044#1086#1083#1083#1072#1088#1072
  end
  object Label5: TLabel
    Left = 24
    Top = 152
    Width = 58
    Height = 16
    Caption = #1050#1091#1088#1089' '#1045#1074#1088#1086
  end
  object cxteBillNumber: TcxTextEdit
    Left = 184
    Top = 21
    TabOrder = 0
    Text = 'cxteBillNumber'
    Width = 121
  end
  object cxdteBillDate: TcxDateEdit
    Left = 184
    Top = 63
    Properties.OnChange = cxdteBillDatePropertiesChange
    TabOrder = 1
    Width = 121
  end
  object btnOK: TcxButton
    Left = 109
    Top = 235
    Width = 121
    Height = 33
    Anchors = [akBottom]
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object cxteDollarCource: TcxTextEdit
    Left = 184
    Top = 106
    TabOrder = 2
    Text = 'cxteBillNumber'
    Width = 121
  end
  object cxteEuroCource: TcxTextEdit
    Left = 184
    Top = 149
    TabOrder = 3
    Text = 'cxteBillNumber'
    Width = 121
  end
  object cxdteShipmentDate: TcxDateEdit
    Left = 184
    Top = 192
    TabOrder = 5
    Width = 121
  end
end
