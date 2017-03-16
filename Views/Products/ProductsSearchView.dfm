inherited ViewProductsSearch: TViewProductsSearch
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.OnCompare = cxGridDBBandedTableViewDataControllerCompare
      inherited clValue: TcxGridDBBandedColumn
        Properties.OnChange = clValuePropertiesChange
      end
      inherited clStorehouseID: TcxGridDBBandedColumn
        MinWidth = 100
        VisibleForCustomization = False
      end
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
          ItemName = 'dxbrsbtmColumnsCustomization'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnSearch'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnClear'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnApply'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnPasteFromBuffer'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    object dxbrbtnSearch: TdxBarButton
      Action = actSearch
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnClear: TdxBarButton
      Action = actClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnApply: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnPasteFromBuffer: TdxBarButton
      Action = actPasteFromBuffer
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
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
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton2: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actOpenInParametricTable
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actSearch: TAction [6]
      Caption = #1055#1086#1080#1089#1082
      Hint = #1055#1086#1080#1089#1082
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actClear: TAction [7]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actClearExecute
    end
    object actPasteFromBuffer: TAction [8]
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      ImageIndex = 5
      OnExecute = actPasteFromBufferExecute
    end
  end
end
