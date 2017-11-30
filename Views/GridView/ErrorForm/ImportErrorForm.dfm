inherited frmImportError: TfrmImportError
  Caption = #1054#1096#1080#1073#1082#1080' '#1087#1088#1080' '#1079#1072#1075#1088#1091#1079#1082#1077
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    inherited ViewGridEx: TViewGridEx
      inherited dxBarManager: TdxBarManager
        DockControlHeights = (
          0
          0
          28
          0)
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        PopupMenus = <
          item
            GridView = ViewGridEx.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewGridEx.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  inherited cxButton1: TcxButton
    Left = 226
    DropDownMenu = pmContinue
    Kind = cxbkDropDownButton
    ExplicitLeft = 226
  end
  object cxButton2: TcxButton
    Left = 402
    Top = 302
    Width = 163
    Height = 33
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object pmContinue: TPopupMenu
    Left = 131
    Top = 35
    object N1: TMenuItem
      Action = actAll
      Default = True
    end
    object N2: TMenuItem
      Action = actSkip
    end
  end
  object ErrorActionList: TActionList
    Left = 43
    Top = 35
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
