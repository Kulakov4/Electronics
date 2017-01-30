inherited ViewBodyTypesGrid: TViewBodyTypesGrid
  Font.Height = -13
  ParentFont = False
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      object clBodyType1: TcxGridDBBandedColumn
        Caption = #1058#1080#1087' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'BodyType1'
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clBodyType: TcxGridDBBandedColumn
        Caption = #1060#1086#1088#1084#1092#1072#1082#1090#1086#1088', '#1055#1072#1088#1072#1084#1077#1090#1088#1099
        DataBinding.FieldName = 'BodyType'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clLandPattern: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'LandPattern'
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clOutlineDrawing: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085'. '#1087#1083#1086#1097'-'#1082#1080
        DataBinding.FieldName = 'OutlineDrawing'
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clVariation: TcxGridDBBandedColumn
        Caption = #1042#1072#1088#1080#1072#1085#1090' '#1082#1086#1088#1087#1091#1089#1072
        DataBinding.FieldName = 'Variation'
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clImage: TcxGridDBBandedColumn
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'Image'
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clBodyType0: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'BodyType0'
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
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actExportToExcelDocument: TAction
      Caption = 'actExportToExcelDocument'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
  end
end
