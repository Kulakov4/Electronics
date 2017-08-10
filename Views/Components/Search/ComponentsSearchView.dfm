inherited ViewComponentsSearch: TViewComponentsSearch
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
          ItemName = 'dxbrbtnSearch'
        end
        item
          Visible = True
          ItemName = 'dxbbClear'
        end
        item
          Visible = True
          ItemName = 'dxbbDeleteFromAllCategories'
        end
        item
          Visible = True
          ItemName = 'dxbbSave'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxbbPasteFromBuffer'
        end>
    end
    object dxbrbtnSearch: TdxBarButton
      Action = actSearch
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbClear: TdxBarButton
      Action = actClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbDeleteFromAllCategories: TdxBarButton
      Action = actDeleteFromAllCategories
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbSave: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbPasteFromBuffer: TdxBarButton
      Action = actPasteFromBuffer
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actSearch: TAction
      Caption = #1055#1086#1080#1089#1082
      Hint = #1055#1086#1080#1089#1082
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 10
      OnExecute = actClearExecute
    end
    object actPasteFromBuffer: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      OnExecute = actPasteFromBufferExecute
    end
  end
  inherited cxerComponents: TcxEditRepository
    inherited cxFieldValueWithExpand: TcxEditRepositoryButtonItem
      Properties.OnChange = cxFieldValueWithExpandPropertiesChange
    end
  end
end
