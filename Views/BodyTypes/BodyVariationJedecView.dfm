inherited ViewBodyVariationJEDEC: TViewBodyVariationJEDEC
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.DataSource = DataSource
      OptionsData.Appending = True
      OptionsView.Header = False
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarButton2: TdxBarButton
      Action = actOK
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actCancel
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actAdd
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actDeleteEx
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actOK: TAction
      Caption = 'OK'
      ImageIndex = 41
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 14
      OnExecute = actCancelExecute
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 1
      OnExecute = actAddExecute
    end
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
