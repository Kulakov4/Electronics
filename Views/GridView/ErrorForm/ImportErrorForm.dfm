inherited frmImportError: TfrmImportError
  Caption = #1054#1096#1080#1073#1082#1080' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077
  ClientHeight = 465
  ClientWidth = 855
  ExplicitWidth = 871
  ExplicitHeight = 504
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 855
    Height = 397
    ExplicitWidth = 855
    ExplicitHeight = 397
    inherited ViewGrid: TViewGrid
      Width = 853
      Height = 395
      ExplicitWidth = 853
      ExplicitHeight = 395
      inherited cxGrid: TcxGrid
        Width = 853
        Height = 348
        ExplicitWidth = 853
        ExplicitHeight = 348
      end
      inherited StatusBar: TStatusBar
        Top = 376
        Width = 853
        ExplicitTop = 376
        ExplicitWidth = 853
      end
      inherited dxBarManager: TdxBarManager
        DockControlHeights = (
          0
          0
          28
          0)
      end
    end
  end
  inherited PanelBottom: TPanel
    Top = 397
    Width = 855
    ExplicitTop = 397
    ExplicitWidth = 855
    DesignSize = (
      855
      68)
    inherited lblStatus: TLabel
      Top = 26
      ExplicitTop = 26
    end
    inherited cxbtnOK: TcxButton
      Left = 467
      Action = actAll
      DropDownMenu = pmContinue
      Kind = cxbkDropDownButton
      ExplicitLeft = 467
    end
    object cxbtnCancel: TcxButton
      Left = 662
      Top = 16
      Width = 177
      Height = 36
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pmContinue: TPopupMenu
    Left = 123
    Top = 187
    object N1: TMenuItem
      Action = actAll
      Default = True
    end
    object N2: TMenuItem
      Action = actSkip
    end
  end
  object ActionList1: TActionList
    Left = 123
    Top = 67
    object actAll: TAction
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1105
      OnExecute = actAllExecute
    end
    object actSkip: TAction
      Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100' '#1079#1072#1087#1080#1089#1080' '#1089' '#1087#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103#1084#1080
      OnExecute = actSkipExecute
    end
  end
end
