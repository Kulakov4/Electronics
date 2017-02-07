inherited frmGridView: TfrmGridView
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  ClientHeight = 478
  ClientWidth = 875
  ExplicitWidth = 891
  ExplicitHeight = 517
  PixelsPerInch = 96
  TextHeight = 16
  inherited MainPanel: TPanel
    Width = 875
    Height = 410
    ExplicitWidth = 875
    ExplicitHeight = 410
    inherited ViewGrid: TViewGrid
      Width = 873
      Height = 408
      ExplicitWidth = 873
      ExplicitHeight = 408
      inherited cxGrid: TcxGrid
        Left = 0
        Top = 28
        Width = 873
        Height = 361
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 873
        ExplicitHeight = 361
        inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          BackgroundBitmaps.Background.Data = {00000000}
          BackgroundBitmaps.Content.Data = {00000000}
          BackgroundBitmaps.FilterBox.Data = {00000000}
          BackgroundBitmaps.Footer.Data = {00000000}
          BackgroundBitmaps.Header.Data = {00000000}
          BackgroundBitmaps.Group.Data = {00000000}
          BackgroundBitmaps.GroupByBox.Data = {00000000}
          BackgroundBitmaps.Indicator.Data = {00000000}
          BackgroundBitmaps.Preview.Data = {00000000}
          BackgroundBitmaps.BandBackground.Data = {00000000}
          BackgroundBitmaps.BandHeader.Data = {00000000}
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.CopyCaptionsToClipboard = False
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.InvertSelect = False
          OptionsSelection.MultiSelect = True
          OptionsSelection.CellMultiSelect = True
          OptionsView.GroupByBox = False
          OptionsView.BandHeaders = False
          Bands = <
            item
            end>
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = ViewGrid.cxGridDBBandedTableView
        end
      end
      inherited StatusBar: TStatusBar
        Left = 0
        Top = 389
        Width = 873
        Height = 19
        Panels = <>
        ExplicitTop = 389
        ExplicitWidth = 873
      end
      inherited dxBarManager: TdxBarManager
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Backgrounds.Bar.Data = {00000000}
        Backgrounds.SubMenu.Data = {00000000}
        Categories.Strings = (
          'Default')
        Categories.ItemsVisibles = (
          2)
        Categories.Visibles = (
          True)
        HelpButtonGlyph.Data = {00000000}
        PopupMenuLinks = <>
        UseSystemFont = True
        DockControlHeights = (
          0
          0
          28
          0)
        inherited dxbrMain: TdxBar
          Caption = 'Main'
          CaptionButtons = <>
          DockedDockingStyle = dsTop
          DockedLeft = 0
          DockedTop = 0
          DockingStyle = dsTop
          FloatLeft = 903
          FloatTop = 0
          FloatClientWidth = 0
          FloatClientHeight = 0
          Glyph.Data = {00000000}
          Images = DMRepository.cxImageList
          ItemLinks = <
            item
              Visible = True
              ItemName = 'dxbrsbtmColumnsCustomization'
            end
            item
              Visible = True
              ItemName = 'dxBarButton1'
            end>
          OneOnRow = True
          Row = 0
          UseOwnFont = False
          Visible = True
          WholeRow = False
          BackgroundBitmap.Data = {00000000}
        end
        inherited dxbrsbtmColumnsCustomization: TdxBarSubItem
          Caption = #1050#1086#1083#1086#1085#1082#1080
          Category = 0
          Visible = ivAlways
          Glyph.Data = {00000000}
          ImageIndex = 0
          LargeGlyph.Data = {00000000}
          Images = DMRepository.cxImageList
          ItemLinks = <>
        end
        inherited dxBarButton1: TdxBarButton
          Action = ViewGrid.actExportToExcel
          Category = 0
          Glyph.Data = {00000000}
          LargeGlyph.Data = {00000000}
          PaintStyle = psCaptionGlyph
        end
      end
      inherited ActionList: TActionList
        Images = DMRepository.cxImageList
        inherited actCopyToClipboard: TAction
          Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100
          Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
          ImageIndex = 12
        end
        inherited actExportToExcel: TAction
          Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
          Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' Excel'
          ImageIndex = 6
        end
      end
      inherited pmGrid: TPopupMenu
        inherited N1: TMenuItem
          Action = ViewGrid.actCopyToClipboard
          Bitmap.Data = {00000000}
        end
      end
      inherited cxGridPopupMenu: TcxGridPopupMenu
        Grid = ViewGrid.cxGrid
        PopupMenus = <
          item
            HitTypes = [gvhtCell]
            Index = 0
          end>
      end
    end
  end
  object PanelBottom: TPanel [1]
    Left = 0
    Top = 410
    Width = 875
    Height = 68
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      875
      68)
    object lblStatus: TLabel
      Left = 16
      Top = 24
      Width = 4
      Height = 16
    end
    object cxbtnOK: TcxButton
      Left = 680
      Top = 16
      Width = 177
      Height = 36
      Anchors = [akRight, akBottom]
      Caption = '&OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
  end
end
