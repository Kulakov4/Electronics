inherited ViewExtraChargeSimple: TViewExtraChargeSimple
  inherited cxGrid: TcxGrid
    Top = 0
    Height = 472
    ExplicitTop = 0
    ExplicitHeight = 472
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnCellClick = cxGridDBBandedTableViewCellClick
      OptionsView.ColumnAutoWidth = False
    end
  end
  inherited StatusBar: TStatusBar
    Visible = False
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMain: TdxBar
      Visible = False
    end
  end
end
