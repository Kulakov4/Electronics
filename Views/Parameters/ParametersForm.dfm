inherited frmParameters: TfrmParameters
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ExplicitWidth = 806
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    inline ViewParameters: TViewParameters
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
        Height = 352
        ExplicitWidth = 788
        ExplicitHeight = 352
        inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewParameters.clParameterType
            end>
        end
        inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewParameters.clValue2
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
        ShowHint = False
        DockControlHeights = (
          0
          0
          56
          0)
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        PopupMenus = <
          item
            GridView = ViewParameters.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewParameters.pmGrid
          end>
      end
    end
  end
end
