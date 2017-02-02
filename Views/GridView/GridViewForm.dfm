inherited frmGridView: TfrmGridView
  Caption = 'frmGridView'
  PixelsPerInch = 96
  TextHeight = 16
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    Align = alClient
    TabOrder = 0
    inline ViewImportError: TViewGrid
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
            GridView = ViewImportError.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewImportError.pmGrid
          end>
      end
    end
  end
  object DataSource: TDataSource
    Left = 128
    Top = 112
  end
end
