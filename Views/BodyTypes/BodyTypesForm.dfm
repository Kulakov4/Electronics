inherited frmBodyTypes: TfrmBodyTypes
  Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
  ClientHeight = 490
  ExplicitHeight = 529
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    inline ViewBodyTypes: TViewBodyTypes
      Left = 1
      Top = 1
      Width = 788
      Height = 427
      Align = alClient
      Constraints.MinHeight = 200
      Constraints.MinWidth = 600
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
              Column = ViewBodyTypes.clBodyType
            end>
        end
        inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewBodyTypes.clBodyType1
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
            GridView = ViewBodyTypes.cxGridDBBandedTableView
            HitTypes = [gvhtCell]
            Index = 0
            PopupMenu = ViewBodyTypes.pmGrid
          end>
      end
    end
  end
  inherited btnOk: TcxButton
    Top = 447
    ExplicitTop = 447
  end
  inherited btnCancel: TcxButton
    Top = 447
    ExplicitTop = 447
  end
end
