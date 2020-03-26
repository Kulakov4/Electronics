inherited ViewBillContentExport: TViewBillContentExport
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OptionsView.ColumnAutoWidth = False
      OptionsView.Header = False
      OptionsView.BandHeaders = True
      OnCustomDrawGroupCell = cxGridDBBandedTableViewCustomDrawGroupCell
      Bands = <
        item
          Visible = False
        end>
    end
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
  end
end
