inherited frmParameters: TfrmParameters
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    object cxPageControl: TcxPageControl
      Left = 1
      Top = 1
      Width = 788
      Height = 427
      Align = alClient
      TabOrder = 0
      Properties.ActivePage = cxtsSubParameters
      Properties.CustomButtons.Buttons = <>
      OnPageChanging = cxPageControlPageChanging
      ClientRectBottom = 423
      ClientRectLeft = 4
      ClientRectRight = 784
      ClientRectTop = 27
      object cxtsParameters: TcxTabSheet
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
        ImageIndex = 0
        inline ViewParameters: TViewParameters
          Left = 0
          Top = 0
          Width = 780
          Height = 396
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 396
          inherited cxGrid: TcxGrid
            Width = 780
            Height = 321
            ExplicitWidth = 780
            ExplicitHeight = 321
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
            Top = 377
            Width = 780
            ExplicitTop = 377
            ExplicitWidth = 780
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
                GridView = ViewParameters.cxGridDBBandedTableView
                HitTypes = [gvhtCell]
                Index = 0
                PopupMenu = ViewParameters.pmGrid
              end>
          end
        end
      end
      object cxtsSubParameters: TcxTabSheet
        Caption = #1055#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088#1099
        ImageIndex = 1
        inline ViewSubParameters: TViewSubParameters
          Left = 0
          Top = 0
          Width = 780
          Height = 396
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 780
          ExplicitHeight = 396
          inherited cxGrid: TcxGrid
            Width = 780
            Height = 349
            ExplicitWidth = 780
            ExplicitHeight = 349
          end
          inherited StatusBar: TStatusBar
            Top = 377
            Width = 780
            ExplicitTop = 377
            ExplicitWidth = 780
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
                GridView = ViewSubParameters.cxGridDBBandedTableView
                HitTypes = [gvhtCell]
                Index = 0
                PopupMenu = ViewSubParameters.pmGrid
              end>
          end
        end
      end
    end
  end
end
