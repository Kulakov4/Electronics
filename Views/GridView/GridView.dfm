inherited ViewGrid: TViewGrid
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = False
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actExportToExcel
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actExportToExcel: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelExecute
    end
  end
  inherited cxGridPopupMenu: TcxGridPopupMenu
    PopupMenus = <
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtNone, gvhtCell]
        Index = 0
        PopupMenu = pmGrid
      end>
  end
end
