object frmLoadParametric: TfrmLoadParametric
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' ...'
  ClientHeight = 414
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  DesignSize = (
    520
    414)
  PixelsPerInch = 96
  TextHeight = 18
  object cxGroupBox1: TcxGroupBox
    Left = 15
    Top = 13
    Caption = ' '#1042#1072#1088#1080#1072#1085#1090' '#1079#1072#1085#1077#1089#1077#1085#1080#1103' '#1079#1085#1072#1095#1077#1085#1080#1081' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '
    TabOrder = 0
    Height = 145
    Width = 489
    object cxLabel1: TcxLabel
      Left = 16
      Top = 24
      AutoSize = False
      Caption = 
        #1047#1085#1072#1095#1077#1085#1080#1103' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1085#1077#1082#1086#1090#1086#1088#1099#1093' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074' ('#1080#1083#1080' '#1089#1077#1084#1077#1081#1089#1090#1074' '#1082#1086#1084#1087#1086#1085#1077#1085 +
        #1090#1086#1074') '#1091#1078#1077' '#1084#1086#1075#1091#1090' '#1073#1099#1090#1100' '#1079#1072#1085#1077#1089#1077#1085#1099' '#1074' '#1041#1044'.'
      Properties.WordWrap = True
      Height = 49
      Width = 457
    end
    object cxrbReplace: TcxRadioButton
      Left = 16
      Top = 79
      Width = 273
      Height = 17
      Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1080#1084#1077#1102#1097#1080#1077#1089#1103' '#1079#1085#1072#1095#1077#1085#1080#1103' '#1085#1086#1074#1099#1084#1080
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object cxrbAdd: TcxRadioButton
      Left = 16
      Top = 110
      Width = 273
      Height = 17
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082' '#1080#1084#1077#1102#1097#1080#1084#1089#1103' '#1079#1085#1072#1095#1077#1085#1080#1103#1084' '#1085#1086#1074#1099#1077
      TabOrder = 2
    end
  end
  object cxGroupBox2: TcxGroupBox
    Left = 15
    Top = 164
    Caption = ' '#1060#1072#1081#1083' '#1089' '#1076#1072#1085#1085#1099#1084#1080' '
    TabOrder = 1
    Height = 77
    Width = 489
    object cxButton1: TcxButton
      Left = 440
      Top = 32
      Width = 33
      Height = 25
      Action = actOpenFile
      OptionsImage.Images = cxImageList1
      PaintStyle = bpsGlyph
      TabOrder = 0
    end
    object cxcbFileName: TcxComboBox
      Left = 16
      Top = 32
      Properties.OnChange = cxcbFileNamePropertiesChange
      TabOrder = 1
      Width = 418
    end
  end
  object cxbtnOK: TcxButton
    Left = 240
    Top = 357
    Width = 123
    Height = 41
    Action = actOK
    Anchors = [akRight, akBottom]
    Default = True
    TabOrder = 2
  end
  object cxbtnCancel: TcxButton
    Left = 381
    Top = 357
    Width = 123
    Height = 41
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object cxGroupBox3: TcxGroupBox
    Left = 15
    Top = 247
    Caption = ' '#1044#1077#1081#1089#1090#1074#1080#1103' '#1087#1086#1089#1083#1077' '#1079#1072#1075#1088#1091#1079#1082#1080' '
    TabOrder = 4
    Height = 98
    Width = 489
  end
  object cxImageList1: TcxImageList
    SourceDPI = 96
    Height = 24
    Width = 24
    FormatVersion = 1
    DesignInfo = 8389064
    ImageInfo = <
      item
        Image.Data = {
          36090000424D3609000000000000360000002800000018000000180000000100
          2000000000000009000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000090000000E0000001000000010000000100000
          00100000001000000011000000110000001100000011000000100000000B0000
          0003000000000000000000000000000000000000000000000000000000000000
          0000000000000000000017417CCA2159A8FF225BAAFF225AAAFF2159A9FF2158
          A9FF2057A8FF2057A7FF2055A7FF1F55A7FF1F54A6FF1E53A6FF1E52A4FF1A45
          8DE303080F290000000200000000000000000000000000000000000000000000
          00000000000000000000225DA8FF2F6BB0FF579AD3FF71BEECFF46A6E4FF44A3
          E4FF41A1E3FF3FA0E2FF3C9EE2FF3B9CE1FF389BE0FF369AE0FF3498DFFF2875
          C1FF0F284E8B0000000800000000000000000000000000000000000000000000
          000000000000000000002868B1FF4884BFFF4489C7FF9CD8F5FF63B9EBFF55B0
          E8FF52AEE8FF4EACE7FF4CA9E6FF49A8E5FF47A6E4FF44A4E4FF41A2E3FF3991
          D7FF1B4787D50000000D00000000000000000000000000000000000000000000
          000000000000000000002C6FB7FF6CA7D2FF3C87C6FFA0D4EFFF94D5F4FF66BD
          EEFF63BBEDFF60B9EBFF5DB6EBFF5BB5EAFF57B2EAFF55B0E9FF51AEE7FF4FAB
          E7FF2967B4FF040B142F00000000000000000000000000000000000000000000
          000000000000000000002F75BCFF8FC7E6FF4FA0D5FF7FBCE2FFC3EEFCFF78CA
          F2FF74C8F1FF72C5F0FF6FC4F0FF6DC2EFFF69C0EEFF66BDEEFF63BBEDFF60B9
          EBFF408ACAFF112C4E8100000000000000000000000000000000000000000000
          00000000000000000000327CBFFFAFE3F5FF75C8EDFF55A3D7FFD2F5FDFFD4F6
          FEFFD2F4FEFFCDF3FDFFC8F1FDFFC2EEFCFFBCEBFBFFB5E7FAFFADE3F9FFA5DF
          F8FF82C0E6FF1E5189CB00000000000000000000000000000000000000000000
          000000000000000000003582C4FFC7F5FEFF97E5FCFF62BBE7FF4AA0D6FF4A9D
          D5FF91C3E3FF8DBCDCFF8FBDE0FF5FA3D6FF4394CFFF4292CEFF2D73BAFF2D72
          B9FF2C71B8FF2765A7EA00000000000000000000000000000000000000000000
          000000000000000000003688C8FFCDF7FEFFA6ECFEFF9CE8FDFF93E4FBFF8EE1
          FBFFBBE6F3FFA68E78FFA6BABDFFB2E1F3FFB9E6F7FFB3E0F0FF8EADD1FF0000
          00180000000B0000000700000000000000000000000000000000000000000000
          00000000000000000000398ECBFFD0F8FEFFAEF0FEFFAAEEFEFFA6EDFEFFA5EB
          FDFFD3EDF3FFAD744CFF9A6841FFBEB8ADFFD1E1E3FF975D32FF8A6E59FF0C07
          032E000000070000000100000000000000000000000000000000000000000000
          000000000000000000003B92CEFFD3F9FEFFB6F3FEFFB3F1FDFFB0F1FEFFB8ED
          FAFF9CC3E0FFAD886CFFDBB891FFB07F53FF9B643AFF9F663DFFDBB67EFF8E5D
          33EF311D0F670000000600000000000000000000000000000000000000000000
          000000000000000000003D97D1FFE2FCFEFFE2FCFEFFE1FCFEFFD3F3FAFF428F
          C1EC0B111523382A1E58C49870FFEAD2B1FFFCF0D0FFFEF2D3FFFEE9BBFFF7E6
          C5FFA36C43FF0000000800000000000000000000000000000000000000000000
          000000000000000000002E739DBF3E9AD3FF3E99D3FF3E99D3FF3E97D2FF1432
          45590000000200000003382C204E987758CABF946DFAC3966DFFEAD3B4FFB790
          6CEE3D2E215B0000000300000000000000000000000000000000000000000000
          0000000000000000000000000002000000030000000300000004000000030000
          00020000000000000000000000010000000200000005CAA27AFF846A50AC110D
          0A1B000000020000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000001000000010000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
      end>
  end
  object ActionList1: TActionList
    Images = cxImageList1
    Left = 455
    Top = 69
    object actOpenFile: TAction
      Caption = 'actOpenFile'
      ImageIndex = 0
      OnExecute = actOpenFileExecute
    end
    object actOK: TAction
      Caption = 'OK'
      OnExecute = actOKExecute
    end
  end
end
