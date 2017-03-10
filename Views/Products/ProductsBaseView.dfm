inherited ViewProductsBase: TViewProductsBase
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnEditKeyDown = cxGridDBBandedTableViewEditKeyDown
      DataController.KeyFieldNames = 'ID'
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = False
      OptionsView.BandHeaders = True
      Bands = <
        item
          FixedKind = fkLeft
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          HeaderAlignmentHorz = taLeftJustify
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end>
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        VisibleForCustomization = False
        Width = 50
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxTextEditProperties'
        VisibleForCustomization = False
        Width = 109
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clProducer: TcxGridDBBandedColumn
        Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
        DataBinding.FieldName = 'IDProducer'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.DropDownListStyle = lsEditList
        Properties.ListColumns = <>
        Width = 129
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clStorehouseID: TcxGridDBBandedColumn
        Caption = #1057#1082#1083#1072#1076
        DataBinding.FieldName = 'StorehouseID'
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clSubgroup: TcxGridDBBandedColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
        DataBinding.FieldName = 'ComponentGroup'
        PropertiesClassName = 'TcxTextEditProperties'
        Width = 145
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clDescription: TcxGridDBBandedColumn
        Caption = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
        DataBinding.FieldName = 'Description'
        PropertiesClassName = 'TcxBlobEditProperties'
        Properties.BlobEditKind = bekMemo
        Width = 143
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clDatasheet: TcxGridDBBandedColumn
        Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
        DataBinding.FieldName = 'Datasheet'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDatasheet
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadDatasheet
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clDatasheetGetDataText
        Width = 138
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clDiagram: TcxGridDBBandedColumn
        Caption = #1057#1093#1077#1084#1072
        DataBinding.FieldName = 'Diagram'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDiagram
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadDiagram
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clDatasheetGetDataText
        Width = 50
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clDrawing: TcxGridDBBandedColumn
        Caption = #1063#1077#1088#1090#1105#1078
        DataBinding.FieldName = 'Drawing'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenDrawing
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadDrawing
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clDatasheetGetDataText
        Width = 50
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clImage: TcxGridDBBandedColumn
        Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'Image'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenImage
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadImage
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        OnGetDataText = clDatasheetGetDataText
        Width = 136
        Position.BandIndex = 1
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clPackagePins: TcxGridDBBandedColumn
        Caption = #1050#1086#1088#1087#1091#1089
        DataBinding.FieldName = 'PackagePins'
        PropertiesClassName = 'TcxTextEditProperties'
        Width = 144
        Position.BandIndex = 1
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object clReleaseDate: TcxGridDBBandedColumn
        Caption = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
        DataBinding.FieldName = 'ReleaseDate'
        PropertiesClassName = 'TcxTextEditProperties'
        Width = 135
        Position.BandIndex = 1
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
      object clBatchNumber: TcxGridDBBandedColumn
        Caption = #1053#1086#1084#1077#1088' '#1087#1072#1088#1090#1080#1080
        DataBinding.FieldName = 'BatchNumber'
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 9
        Position.RowIndex = 0
      end
      object clAmount: TcxGridDBBandedColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        PropertiesClassName = 'TcxSpinEditProperties'
        Properties.ReadOnly = False
        Properties.UseNullString = True
        Width = 129
        Position.BandIndex = 1
        Position.ColIndex = 10
        Position.RowIndex = 0
      end
      object clPackaging: TcxGridDBBandedColumn
        Caption = #1059#1087#1072#1082#1086#1074#1082#1072
        DataBinding.FieldName = 'Packaging'
        Width = 100
        Position.BandIndex = 1
        Position.ColIndex = 11
        Position.RowIndex = 0
      end
      object clPrice: TcxGridDBBandedColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        Position.BandIndex = 1
        Position.ColIndex = 12
        Position.RowIndex = 0
      end
      object clOriginCountryCode: TcxGridDBBandedColumn
        Caption = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
        DataBinding.FieldName = 'OriginCountryCode'
        Width = 80
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clOriginCountry: TcxGridDBBandedColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'OriginCountry'
        Width = 54
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clCustomsDeclarationNumber: TcxGridDBBandedColumn
        Caption = #1053#1086#1084#1077#1088' '#1090#1072#1084#1086#1078#1077#1085#1085#1086#1081' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1080
        DataBinding.FieldName = 'CustomsDeclarationNumber'
        Width = 166
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clStorage: TcxGridDBBandedColumn
        Caption = #1057#1090#1077#1083#1083#1072#1078' '#8470
        DataBinding.FieldName = 'Storage'
        Width = 67
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clStoragePlace: TcxGridDBBandedColumn
        Caption = #1052#1077#1089#1090#1086' '#8470
        DataBinding.FieldName = 'StoragePlace'
        Width = 53
        Position.BandIndex = 4
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clBarcode: TcxGridDBBandedColumn
        Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076
        DataBinding.FieldName = 'Barcode'
        Width = 63
        Position.BandIndex = 5
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clSeller: TcxGridDBBandedColumn
        Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'-'#1087#1088#1086#1076#1072#1074#1077#1094
        DataBinding.FieldName = 'Seller'
        Width = 137
        Position.BandIndex = 5
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clProductId: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ProductId'
        Visible = False
        VisibleForCustomization = False
        Width = 50
        Position.BandIndex = 5
        Position.ColIndex = 0
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
    object actOpenDatasheet: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      ImageIndex = 7
      OnExecute = actOpenDatasheetExecute
    end
    object actLoadDatasheet: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1102
      OnExecute = actLoadDatasheetExecute
    end
    object actOpenImage: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      ImageIndex = 8
      OnExecute = actOpenImageExecute
    end
    object actLoadImage: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      OnExecute = actLoadImageExecute
    end
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 14
      OnExecute = actRollback2Execute
    end
    object actOpenDiagram: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1093#1077#1084#1091
      ImageIndex = 16
      OnExecute = actOpenDiagramExecute
    end
    object actLoadDiagram: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1093#1077#1084#1091
      OnExecute = actLoadDiagramExecute
    end
    object actOpenDrawing: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1095#1077#1088#1090#1105#1078
      ImageIndex = 17
      OnExecute = actOpenDrawingExecute
    end
    object actLoadDrawing: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1095#1077#1088#1090#1105#1078
      OnExecute = actLoadDrawingExecute
    end
    object actOpenInParametricTable: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1080#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 34
      OnExecute = actOpenInParametricTableExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1042' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
  end
end
