inherited ViewStoreHouse: TViewStoreHouse
  inherited cxGrid: TcxGrid
    Top = 0
    Height = 472
    ExplicitTop = 0
    ExplicitHeight = 472
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnCanFocusRecord = cxGridDBBandedTableViewCanFocusRecord
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      Styles.Inactive = cxStyleInactive
    end
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
      Visible = False
    end
  end
  inherited ActionList: TActionList
    inherited actCopyToClipboard: TAction
      Visible = False
    end
    inherited actDeleteEx: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1083#1072#1076
    end
    object actAddStorehouse: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1083#1072#1076
      ImageIndex = 1
      OnExecute = actAddStorehouseExecute
    end
    object actRenameStorehouse: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1089#1082#1083#1072#1076
      ImageIndex = 11
      OnExecute = actRenameStorehouseExecute
    end
    object actStoreHouseInfo: TAction
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072
      ImageIndex = 18
      OnExecute = actStoreHouseInfoExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N2: TMenuItem
      Action = actAddStorehouse
    end
    object N3: TMenuItem
      Action = actDeleteEx
    end
    object N4: TMenuItem
      Action = actRenameStorehouse
    end
    object N5: TMenuItem
      Action = actStoreHouseInfo
    end
  end
  inherited cxGridPopupMenu: TcxGridPopupMenu
    PopupMenus = <
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 0
        PopupMenu = pmGrid
      end>
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 128
    Top = 160
    PixelsPerInch = 96
    object cxStyleInactive: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clHighlight
      TextColor = clHighlightText
    end
  end
end
