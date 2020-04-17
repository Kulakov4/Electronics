object frmPathSettings: TfrmPathSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 246
  ClientWidth = 788
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    788
    246)
  PixelsPerInch = 96
  TextHeight = 18
  object cxButton4: TcxButton
    Left = 196
    Top = 206
    Width = 185
    Height = 33
    Anchors = [akLeft, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton5: TcxButton
    Left = 406
    Top = 206
    Width = 185
    Height = 33
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cxPageControl: TcxPageControl
    Left = 0
    Top = 0
    Width = 788
    Height = 200
    Align = alTop
    TabOrder = 2
    Properties.ActivePage = cxtshDatabase
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 196
    ClientRectLeft = 4
    ClientRectRight = 784
    ClientRectTop = 29
    object cxtshDatabase: TcxTabSheet
      Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
      ImageIndex = 2
      object Label8: TLabel
        Left = 19
        Top = 32
        Width = 119
        Height = 18
        Caption = #1055#1091#1090#1100' '#1076#1086' '#1087#1072#1087#1082#1080' '#1089' '#1041#1044
      end
      object cxteDataBasePath: TcxTextEdit
        Left = 152
        Top = 29
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 537
      end
      object cxButton10: TcxButton
        Left = 696
        Top = 29
        Width = 75
        Height = 26
        Action = actBrowseDatabasePath
        TabOrder = 1
      end
      object cbLoadLastCategory: TcxCheckBox
        Left = 19
        Top = 61
        Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1086#1090#1082#1088#1099#1090#1091#1102' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
        TabOrder = 2
      end
    end
    object cxtshComponents: TcxTabSheet
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 1
      object Label4: TLabel
        Left = 8
        Top = 31
        Width = 99
        Height = 18
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080':'
      end
      object Label5: TLabel
        Left = 8
        Top = 127
        Width = 92
        Height = 18
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103':'
      end
      object Label6: TLabel
        Left = 8
        Top = 95
        Width = 60
        Height = 18
        Caption = #1063#1077#1088#1090#1077#1078#1080':'
      end
      object Label7: TLabel
        Left = 8
        Top = 63
        Width = 47
        Height = 18
        Caption = #1057#1093#1077#1084#1099':'
      end
      object cxteComponentsDataSheetFolder: TcxTextEdit
        Left = 224
        Top = 27
        TabOrder = 0
        Width = 457
      end
      object cxButton6: TcxButton
        Left = 696
        Top = 27
        Width = 75
        Height = 26
        Action = actBrowseComponentsDataSheetFolder
        TabOrder = 1
      end
      object cxteComponentsImageFolder: TcxTextEdit
        Left = 224
        Top = 123
        TabOrder = 2
        Width = 457
      end
      object cxButton7: TcxButton
        Left = 696
        Top = 123
        Width = 75
        Height = 26
        Action = actBrowseComponentsImageFolder
        TabOrder = 3
      end
      object cxteComponentsDrawingFolder: TcxTextEdit
        Left = 224
        Top = 91
        TabOrder = 4
        Width = 457
      end
      object cxButton8: TcxButton
        Left = 696
        Top = 91
        Width = 75
        Height = 26
        Action = actBrowseComponentsDrawingFolder
        TabOrder = 5
      end
      object cxteComponentsDiagramFolder: TcxTextEdit
        Left = 224
        Top = 59
        TabOrder = 6
        Width = 457
      end
      object cxButton9: TcxButton
        Left = 696
        Top = 59
        Width = 75
        Height = 26
        Action = actBrowseComponentsSchemeFolder
        TabOrder = 7
      end
    end
    object cxtsWareHouse: TcxTabSheet
      Caption = #1057#1082#1083#1072#1076
      ImageIndex = 3
      object Label9: TLabel
        Left = 8
        Top = 31
        Width = 99
        Height = 18
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080':'
      end
      object Label10: TLabel
        Left = 8
        Top = 63
        Width = 47
        Height = 18
        Caption = #1057#1093#1077#1084#1099':'
      end
      object Label11: TLabel
        Left = 8
        Top = 95
        Width = 60
        Height = 18
        Caption = #1063#1077#1088#1090#1077#1078#1080':'
      end
      object Label12: TLabel
        Left = 8
        Top = 127
        Width = 92
        Height = 18
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103':'
      end
      object cxteWareHouseDataSheetFolder: TcxTextEdit
        Left = 224
        Top = 27
        TabOrder = 0
        Width = 457
      end
      object cxteWareHouseDiagramFolder: TcxTextEdit
        Left = 224
        Top = 59
        TabOrder = 1
        Width = 457
      end
      object cxteWareHouseDrawingFolder: TcxTextEdit
        Left = 224
        Top = 91
        TabOrder = 2
        Width = 457
      end
      object cxteWareHouseImageFolder: TcxTextEdit
        Left = 224
        Top = 123
        TabOrder = 3
        Width = 457
      end
      object cxButton11: TcxButton
        Left = 696
        Top = 27
        Width = 75
        Height = 26
        Action = actBrowseWareHouseDataSheetFolder
        TabOrder = 4
      end
      object cxButton12: TcxButton
        Left = 696
        Top = 59
        Width = 75
        Height = 26
        Action = actBrowseWareHouseSchemeFolder
        TabOrder = 5
      end
      object cxButton13: TcxButton
        Left = 696
        Top = 91
        Width = 75
        Height = 26
        Action = actBrowseWareHouseDrawingFolder
        TabOrder = 6
      end
      object cxButton14: TcxButton
        Left = 696
        Top = 123
        Width = 75
        Height = 26
        Action = actBrowseWareHouseImageFilder
        TabOrder = 7
      end
    end
    object cxtshBodyTypes: TcxTabSheet
      Caption = #1050#1086#1088#1087#1091#1089#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 0
      object Label1: TLabel
        Left = 8
        Top = 31
        Width = 122
        Height = 18
        Caption = #1063#1077#1088#1090#1077#1078#1080' '#1082#1086#1088#1087#1091#1089#1086#1074':'
      end
      object Label2: TLabel
        Left = 8
        Top = 95
        Width = 207
        Height = 18
        Caption = #1063#1077#1088#1090#1077#1078#1080' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080':'
      end
      object Label3: TLabel
        Left = 8
        Top = 127
        Width = 154
        Height = 18
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1082#1086#1088#1087#1091#1089#1086#1074':'
      end
      object Label13: TLabel
        Left = 8
        Top = 63
        Width = 40
        Height = 18
        Caption = 'JEDEC:'
      end
      object cxteBodyOutlineDrawingFolder: TcxTextEdit
        Left = 224
        Top = 27
        TabOrder = 0
        Width = 457
      end
      object cxteBodyLandPatternFolder: TcxTextEdit
        Left = 224
        Top = 91
        TabOrder = 1
        Width = 457
      end
      object cxteBodyImageFolder: TcxTextEdit
        Left = 224
        Top = 123
        TabOrder = 2
        Width = 457
      end
      object cxButton1: TcxButton
        Left = 696
        Top = 27
        Width = 75
        Height = 26
        Action = actBrowseOutlineDrawingFolder
        TabOrder = 3
      end
      object cxButton2: TcxButton
        Left = 696
        Top = 91
        Width = 75
        Height = 26
        Action = actBrowseLandPatternFolder
        TabOrder = 4
      end
      object cxButton3: TcxButton
        Left = 696
        Top = 123
        Width = 75
        Height = 26
        Action = actBrowseImageFolder
        TabOrder = 5
      end
      object cxteBodyJEDECFolder: TcxTextEdit
        Left = 224
        Top = 59
        TabOrder = 6
        Width = 457
      end
      object cxButton15: TcxButton
        Left = 696
        Top = 59
        Width = 75
        Height = 26
        Action = actBrowseOutlineDrawingFolder
        TabOrder = 7
      end
    end
  end
  object ActionList1: TActionList
    Left = 376
    Top = 104
    object actBrowseOutlineDrawingFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseOutlineDrawingFolderExecute
    end
    object actBrowseLandPatternFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseLandPatternFolderExecute
    end
    object actBrowseImageFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseImageFolderExecute
    end
    object actBrowseComponentsDataSheetFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseComponentsDataSheetFolderExecute
    end
    object actBrowseComponentsImageFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseComponentsImageFolderExecute
    end
    object actBrowseComponentsDrawingFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseComponentsDrawingFolderExecute
    end
    object actBrowseComponentsSchemeFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseComponentsSchemeFolderExecute
    end
    object actBrowseDatabasePath: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseDatabasePathExecute
    end
    object actBrowseWareHouseDataSheetFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseWareHouseDataSheetFolderExecute
    end
    object actBrowseWareHouseImageFilder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseWareHouseImageFilderExecute
    end
    object actBrowseWareHouseDrawingFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseWareHouseDrawingFolderExecute
    end
    object actBrowseWareHouseSchemeFolder: TAction
      Caption = #1054#1073#1079#1086#1088
      OnExecute = actBrowseWareHouseSchemeFolderExecute
    end
    object actBrowseJEDECFolder: TAction
      Caption = 'actBrowseJEDECFolder'
      OnExecute = actBrowseJEDECFolderExecute
    end
  end
end
