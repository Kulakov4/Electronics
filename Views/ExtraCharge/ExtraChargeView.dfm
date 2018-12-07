inherited ViewExtraCharge: TViewExtraCharge
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.KeyFieldNames = 'ID'
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Appending = True
      OptionsView.ColumnAutoWidth = False
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Bands = <
        item
        end>
    end
    inherited cxGridLevel: TcxGridLevel
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBBandedTableView2
      end
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end
      item
        Width = 150
      end>
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actAdd
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090'/'#1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end>
    end
    object dxBarButton5: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actClear
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1090#1086#1074#1099#1077' '#1085#1072#1094#1077#1085#1082#1080
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1086#1087#1090#1086#1074#1099#1077' '#1085#1072#1094#1077#1085#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1087#1090#1086#1074#1099#1077' '#1085#1072#1094#1077#1085#1082#1080
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 33
      OnExecute = actClearExecute
    end
  end
end
