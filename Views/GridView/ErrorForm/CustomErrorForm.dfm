inherited frmCustomError: TfrmCustomError
  Caption = #1054#1096#1080#1073#1082#1080
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    Anchors = [akLeft, akTop, akRight, akBottom]
    inherited ViewGridEx: TViewGridEx
      inherited dxBarManager: TdxBarManager
        PixelsPerInch = 96
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
  object lblStatus: TcxLabel
    Left = 8
    Top = 394
    Anchors = [akLeft, akBottom]
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
