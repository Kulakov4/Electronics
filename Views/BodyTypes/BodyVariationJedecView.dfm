inherited ViewBodyVariationJEDEC: TViewBodyVariationJEDEC
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.DataSource = DataSource
      object clIDJEDEC: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDJEDEC'
        PropertiesClassName = 'TcxLookupComboBoxProperties'
        Properties.KeyFieldNames = 'ID'
        Properties.ListColumns = <
          item
            FieldName = 'JEDEC'
          end>
        Properties.ListSource = dsJEDEC
        Position.BandIndex = 0
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
  object DataSource: TDataSource
    Left = 328
    Top = 344
  end
  object dsJEDEC: TDataSource
    Left = 256
    Top = 240
  end
end
