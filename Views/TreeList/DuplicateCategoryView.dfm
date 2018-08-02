inherited ViewDuplicateCategory: TViewDuplicateCategory
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnCellClick = cxGridDBBandedTableViewCellClick
      DataController.DataSource = DataSource
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = False
      OptionsSelection.CellMultiSelect = False
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
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
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarStatic1: TdxBarStatic
      Action = actRecordCount
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actRecordCount: TAction
      Caption = 'actRecordCount'
      OnExecute = actRecordCountExecute
    end
  end
  object DataSource: TDataSource
    Left = 264
    Top = 336
  end
end
