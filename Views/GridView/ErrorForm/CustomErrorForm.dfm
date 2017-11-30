inherited frmCustomError: TfrmCustomError
  Caption = #1054#1096#1080#1073#1082#1080
  PixelsPerInch = 96
  TextHeight = 16
  inherited pnlMain: TPanel
    inherited ViewGridEx: TViewGridEx
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
            GridView = ViewGridEx.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewGridEx.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  object lblStatus: TcxLabel
    Left = 8
    Top = 308
  end
end
