inherited frmAnalog: TfrmAnalog
  Caption = #1055#1086#1080#1089#1082' '#1073#1083#1080#1079#1082#1086#1075#1086' '#1072#1085#1072#1083#1086#1075#1072
  ClientHeight = 316
  ClientWidth = 788
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  ExplicitWidth = 804
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 790
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    inline ViewAnalogGrid: TViewAnalogGrid
      Left = 0
      Top = 0
      Width = 790
      Height = 249
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 790
      ExplicitHeight = 249
      inherited cxGrid: TcxGrid
        Width = 790
        Height = 202
        ExplicitWidth = 790
        ExplicitHeight = 202
      end
      inherited StatusBar: TStatusBar
        Top = 230
        Width = 790
        ExplicitTop = 230
        ExplicitWidth = 790
      end
      inherited PopupPanel: TPanel
        inherited PopupViewGridEx: TViewGridEx
          inherited dxBarManager: TdxBarManager
            DockControlHeights = (
              0
              0
              0
              0)
          end
          inherited cxGridPopupMenu: TcxGridPopupMenu
            PopupMenus = <
              item
                GridView = ViewAnalogGrid.PopupViewGridEx.cxGridDBBandedTableView
                HitTypes = [gvhtNone, gvhtCell]
                Index = 0
                PopupMenu = ViewAnalogGrid.PopupViewGridEx.pmGrid
              end>
          end
          inherited cxImageList1: TcxImageList
            FormatVersion = 1
          end
        end
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
            GridView = ViewAnalogGrid.cxGridDBBandedTableView
            HitTypes = [gvhtNone, gvhtCell]
            Index = 0
            PopupMenu = ViewAnalogGrid.pmGrid
          end>
      end
      inherited cxImageList1: TcxImageList
        FormatVersion = 1
      end
    end
  end
  object cxbtnOK: TcxButton
    Left = 612
    Top = 260
    Width = 159
    Height = 45
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
