inherited ViewChildCategories: TViewChildCategories
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      object clFunctionalGroupId: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clFunctionalGroupExternalId: TcxGridDBBandedColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ExternalId'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clFunctionalGroupValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clFunctionalGroupOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Order'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clFunctionalGroupParentExternalId: TcxGridDBBandedColumn
        Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1089#1082#1080#1081' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ParentExternalId'
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clOrd: TcxGridDBBandedColumn
        Caption = #1055#1086#1088#1103#1076#1086#1082
        DataBinding.FieldName = 'Ord'
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited ActionList: TActionList
    object actRename: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      ImageIndex = 11
      OnExecute = actRenameExecute
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 1
      OnExecute = actAddExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N3: TMenuItem
      Action = actAdd
    end
    object N2: TMenuItem
      Action = actRename
    end
    object N4: TMenuItem
      Action = actDeleteEx
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
end
