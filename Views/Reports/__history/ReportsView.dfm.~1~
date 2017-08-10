inherited ViewReports: TViewReports
  inherited cxGrid: TcxGrid
    Top = 56
    Height = 416
    ExplicitTop = 56
    ExplicitHeight = 416
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.Summary.FooterSummaryItems = <
        item
          Kind = skCount
          Column = clComponent
        end>
      OptionsView.Footer = True
      object clManufacturer: TcxGridDBBandedColumn
        DataBinding.FieldName = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clComponent: TcxGridDBBandedColumn
        DataBinding.FieldName = #1050#1086#1084#1087#1086#1085#1077#1085#1090
        MinWidth = 100
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clSpecification: TcxGridDBBandedColumn
        DataBinding.FieldName = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clScheme: TcxGridDBBandedColumn
        DataBinding.FieldName = #1057#1093#1077#1084#1072
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clDrawing: TcxGridDBBandedColumn
        DataBinding.FieldName = #1063#1077#1088#1090#1105#1078
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clImage: TcxGridDBBandedColumn
        DataBinding.FieldName = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clDescription: TcxGridDBBandedColumn
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = #1054#1087#1080#1089#1072#1085#1080#1077
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      56
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrsbtmColumnsCustomization'
        end
        item
          Visible = True
          ItemName = 'dxbrbExportToExcelDocument'
        end>
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = #1060#1080#1083#1100#1090#1088
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 28
      DockingStyle = dsTop
      FloatLeft = 903
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end>
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbrbExportToExcelDocument: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actFilterBySpecification
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton2: TdxBarButton
      Action = actFilterBySchema
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
      PaintStyle = psCaptionGlyph
    end
    object dxBarStatic1: TdxBarStatic
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1086#1090#1089#1091#1090#1089#1090#1074#1080#1102':'
      Category = 0
      Hint = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1086#1090#1089#1091#1090#1089#1090#1074#1080#1102':'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Action = actFilterByDrawing
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actFilterByImage
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton5: TdxBarButton
      Action = actClearFilters
      Category = 0
      AllowAllUp = True
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton6: TdxBarButton
      Action = actFilterByDescription
      Category = 0
      AllowAllUp = True
      ButtonStyle = bsChecked
      GroupIndex = 1
    end
  end
  inherited ActionList: TActionList
    object actExportToExcelDocument: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actFilterBySpecification: TAction
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      GroupIndex = 1
      ImageIndex = 7
      OnExecute = actFilterBySpecificationExecute
    end
    object actFilterBySchema: TAction
      Caption = #1057#1093#1077#1084#1072
      GroupIndex = 1
      ImageIndex = 16
      OnExecute = actFilterBySchemaExecute
    end
    object actFilterByDrawing: TAction
      Caption = #1063#1077#1088#1090#1105#1078
      GroupIndex = 1
      ImageIndex = 17
      OnExecute = actFilterByDrawingExecute
    end
    object actFilterByImage: TAction
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      GroupIndex = 1
      ImageIndex = 8
      OnExecute = actFilterByImageExecute
    end
    object actFilterByDescription: TAction
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
      GroupIndex = 1
      OnExecute = actFilterByDescriptionExecute
    end
    object actClearFilters: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      GroupIndex = 1
      ImageIndex = 10
      OnExecute = actClearFiltersExecute
    end
  end
end
