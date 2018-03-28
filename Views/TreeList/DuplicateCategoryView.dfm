inherited ViewDuplicateCategory: TViewDuplicateCategory
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.DataSource = DataSource
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clCaption: TcxGridDBBandedColumn
        Caption = #1057#1086#1074#1087#1072#1076#1077#1085#1080#1103
        DataBinding.FieldName = 'Caption'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
  end
  inherited StatusBar: TStatusBar
    Visible = False
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
  end
  object DataSource: TDataSource
    Left = 264
    Top = 336
  end
end
