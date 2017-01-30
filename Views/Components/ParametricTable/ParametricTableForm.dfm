inherited frmParametricTable: TfrmParametricTable
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
  ClientHeight = 538
  ClientWidth = 852
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 868
  ExplicitHeight = 577
  PixelsPerInch = 96
  TextHeight = 16
  inline ViewParametricTable: TViewParametricTable
    Left = 0
    Top = 0
    Width = 852
    Height = 538
    Align = alClient
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitWidth = 852
    ExplicitHeight = 538
    inherited cxGrid: TcxGrid
      Width = 852
      Height = 491
      ExplicitWidth = 852
      ExplicitHeight = 491
    end
    inherited StatusBar: TStatusBar
      Top = 519
      Width = 852
      ExplicitTop = 519
      ExplicitWidth = 852
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
          GridView = ViewParametricTable.cxGridDBBandedTableView
          HitTypes = [gvhtCell]
          Index = 0
          PopupMenu = ViewParametricTable.pmGrid
        end
        item
          GridView = ViewParametricTable.cxGridDBBandedTableView2
          HitTypes = [gvhtCell]
          Index = 1
          PopupMenu = ViewParametricTable.pmGrid
        end>
    end
  end
end
