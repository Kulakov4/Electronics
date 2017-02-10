inherited ViewProducts: TViewProducts
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      DataController.OnCompare = cxGridDBBandedTableViewDataControllerCompare
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
    OnResize = StatusBarResize
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
          ItemName = 'dxbrsbtmPaste'
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
    object dxbrsbtmPaste: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 20
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnPasteFromBuffer'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnPasteFromExcel'
        end>
    end
    object dxbrbtnPasteFromBuffer: TdxBarButton
      Action = actPasteFromBuffer
      Category = 0
    end
    object dxbrbtnPasteFromExcel: TdxBarButton
      Action = actPasteFromExcel
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton2: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
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
    object actPasteFromBuffer: TAction [8]
      Caption = #1048#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      OnExecute = actPasteFromBufferExecute
    end
    object actPasteFromExcel: TAction [9]
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actPasteFromExcelExecute
    end
    object actPasteFromExcelSheet: TAction [10]
      Caption = #1048#1079' '#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1083#1080#1089#1090#1072' Excel'
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1072#1082#1090#1080#1074#1085#1086#1075#1086' '#1083#1080#1089#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actPasteFromExcelSheetExecute
    end
  end
end
