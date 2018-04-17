inherited frmBodyTypes: TfrmBodyTypes
  Caption = #1058#1080#1087#1099' '#1082#1086#1088#1087#1091#1089#1086#1074
  ClientHeight = 490
  ExplicitWidth = 806
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
              Column = ViewBodyTypes.clBodyKind
            end>
        end
        inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skCount
              Column = ViewBodyTypes.clBody
            end>
          inherited clOutlineDrawing: TcxGridDBBandedColumn
            Properties.Buttons = <
              item
                Action = ViewBodyTypes.actOpenOutlineDrawing
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewBodyTypes.actLoadOutlineDrawing
                Kind = bkEllipsis
              end>
          end
          inherited clLandPattern: TcxGridDBBandedColumn
            Properties.Buttons = <
              item
                Action = ViewBodyTypes.actOpenLandPattern
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewBodyTypes.actLoadLandPattern
                Kind = bkEllipsis
              end>
          end
          inherited clImage: TcxGridDBBandedColumn
            Properties.Buttons = <
              item
                Action = ViewBodyTypes.actOpenImage
                Default = True
                Kind = bkGlyph
              end
              item
                Action = ViewBodyTypes.actLoadImage
                Kind = bkEllipsis
              end>
          end
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
          56
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
