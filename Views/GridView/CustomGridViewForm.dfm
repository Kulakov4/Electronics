inherited frmCustomGridView: TfrmCustomGridView
  Caption = 'frmCustomGridView'
  ExplicitWidth = 651
  ExplicitHeight = 338
  PixelsPerInch = 96
  TextHeight = 16
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    Align = alClient
    TabOrder = 0
    inline ViewGrid: TViewGrid
      Left = 1
      Top = 1
      Width = 633
      Height = 297
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 633
      ExplicitHeight = 297
      inherited cxGrid: TcxGrid
        Width = 633
        Height = 250
        ExplicitWidth = 633
        ExplicitHeight = 250
      end
      inherited StatusBar: TStatusBar
        Top = 278
        Width = 633
        ExplicitTop = 278
        ExplicitWidth = 633
      end
      inherited dxBarManager: TdxBarManager
        DockControlHeights = (
          0
          0
          28
          0)
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        PopupMenus = <
          item
            GridView = ViewGrid.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewGrid.pmGrid
          end>
      end
    end
  end
  object DataSource: TDataSource
    OnUpdateData = DataSourceUpdateData
    Left = 128
    Top = 112
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 296
    Top = 88
  end
end
