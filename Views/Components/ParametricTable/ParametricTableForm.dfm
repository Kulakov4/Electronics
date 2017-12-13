inherited frmParametricTable: TfrmParametricTable
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
  ClientHeight = 538
  ClientWidth = 852
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
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
    ShowHint = False
    TabOrder = 0
    ExplicitWidth = 852
    ExplicitHeight = 538
    inherited cxGrid: TcxGrid
      Width = 852
      Height = 491
      ExplicitWidth = 852
      ExplicitHeight = 491
      inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
        inherited clProducer: TcxGridDBBandedColumn
          IsCaptionAssigned = True
        end
        inherited clDescription: TcxGridDBBandedColumn
          IsCaptionAssigned = True
        end
        inherited clDatasheet: TcxGridDBBandedColumn
          Properties.Buttons = <
            item
              Action = ViewParametricTable.actOpenDatasheet
              Kind = bkText
            end
            item
              Action = ViewParametricTable.actLoadDatasheet
              Default = True
              Kind = bkEllipsis
            end>
          IsCaptionAssigned = True
        end
        inherited clDiagram: TcxGridDBBandedColumn
          Properties.Buttons = <
            item
              Action = ViewParametricTable.actOpenDiagram
              Kind = bkText
            end
            item
              Action = ViewParametricTable.actLoadDiagram
              Default = True
              Kind = bkEllipsis
            end>
          IsCaptionAssigned = True
        end
        inherited clDrawing: TcxGridDBBandedColumn
          Properties.Buttons = <
            item
              Action = ViewParametricTable.actOpenDrawing
              Kind = bkText
            end
            item
              Action = ViewParametricTable.actLoadDrawing
              Default = True
              Kind = bkEllipsis
            end>
          IsCaptionAssigned = True
        end
        inherited clImage: TcxGridDBBandedColumn
          Properties.Buttons = <
            item
              Action = ViewParametricTable.actOpenImage
              Kind = bkText
            end
            item
              Action = ViewParametricTable.actLoadImage
              Default = True
              Kind = bkEllipsis
            end>
          IsCaptionAssigned = True
        end
        inherited clPackagePins: TcxGridDBBandedColumn
          IsCaptionAssigned = True
        end
      end
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
    inherited cxStyleRepository: TcxStyleRepository
      PixelsPerInch = 96
    end
  end
end
