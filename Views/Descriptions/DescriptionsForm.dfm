inherited frmDescriptions: TfrmDescriptions
  Caption = #1050#1088#1072#1090#1082#1080#1077' '#1086#1087#1080#1089#1072#1085#1080#1103
  ExplicitWidth = 806
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    inline ViewDescriptions: TViewDescriptions
      Left = 1
      Top = 1
      Width = 788
      Height = 427
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 788
      ExplicitHeight = 427
      inherited cxGrid: TcxGrid
        Width = 788
        Height = 380
        ExplicitWidth = 788
        ExplicitHeight = 380
        inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewDescriptions.clComponentType
            end>
        end
        inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewDescriptions.clComponentName
            end>
        end
      end
      inherited StatusBar: TStatusBar
        Top = 408
        Width = 788
        ExplicitTop = 408
        ExplicitWidth = 788
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
            GridView = ViewDescriptions.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewDescriptions.pmGrid
          end>
      end
    end
  end
end
