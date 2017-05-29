inherited ViewProducts: TViewProducts
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      OnColumnHeaderClick = cxGridDBBandedTableViewColumnHeaderClick
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 150
      end>
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
          ItemName = 'dxbrsbtmColumnsCustomization'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAdd'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnDelete'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnSave'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    object dxbrbtnAdd: TdxBarButton
      Action = actAdd
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnDelete: TdxBarButton
      Action = actDelete
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnSave: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actOpenInParametricTable
      Category = 0
      PaintStyle = psCaptionInMenu
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxBarButton3: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actFullScreen
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actAdd: TAction [6]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actDelete: TAction [7]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actPasteComponents: TAction [9]
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099
      ImageIndex = 5
      OnExecute = actPasteComponentsExecute
    end
    inherited actOpenInParametricTable: TAction
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
    end
    inherited actExportToExcelDocument: TAction
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
    end
    object actFullScreen: TAction
      Caption = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      Hint = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      ImageIndex = 35
      OnExecute = actFullScreenExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N2: TMenuItem
      Action = actPasteComponents
    end
  end
end
