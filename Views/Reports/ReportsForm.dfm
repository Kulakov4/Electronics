inherited frmReports: TfrmReports
  Caption = #1054#1090#1095#1105#1090
  PixelsPerInch = 96
  TextHeight = 16
  inline ViewReports: TViewReports
    Left = 0
    Top = 0
    Width = 635
    Height = 299
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 635
    ExplicitHeight = 299
    inherited cxGrid: TcxGrid
      Width = 635
      Height = 224
      ExplicitWidth = 635
      ExplicitHeight = 224
      inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
        DataController.Summary.FooterSummaryItems = <
          item
            Kind = skCount
            Column = ViewReports.clComponent
          end>
      end
    end
    inherited StatusBar: TStatusBar
      Top = 280
      Width = 635
      ExplicitTop = 280
      ExplicitWidth = 635
    end
    inherited dxBarManager: TdxBarManager
      DockControlHeights = (
        0
        0
        56
        0)
    end
    inherited cxGridPopupMenu: TcxGridPopupMenu
      PopupMenus = <
        item
          GridView = ViewReports.cxGridDBBandedTableView
          HitTypes = [gvhtCell]
          Index = 0
          PopupMenu = ViewReports.pmGrid
        end>
    end
  end
end
