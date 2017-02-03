inherited frmError: TfrmError
  Caption = #1054#1096#1080#1073#1082#1080
  ClientHeight = 447
  ClientWidth = 834
  ExplicitWidth = 850
  ExplicitHeight = 486
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 834
    Height = 379
    ExplicitWidth = 834
    ExplicitHeight = 311
    inherited ViewImportError: TViewGrid
      Width = 832
      Height = 377
      ExplicitWidth = 832
      ExplicitHeight = 309
      inherited cxGrid: TcxGrid
        Width = 832
        Height = 330
        ExplicitWidth = 832
        ExplicitHeight = 262
      end
      inherited StatusBar: TStatusBar
        Top = 358
        Width = 832
        ExplicitTop = 290
        ExplicitWidth = 832
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
  inherited PanelBottom: TPanel
    Top = 379
    Width = 834
    ExplicitTop = 379
    ExplicitWidth = 834
    inherited cxbtnOK: TcxButton
      Left = 640
      ExplicitLeft = 640
    end
  end
end
