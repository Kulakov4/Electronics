object ViewBodyTypesTree: TViewBodyTypesTree
  Left = 0
  Top = 0
  Width = 801
  Height = 442
  TabOrder = 0
  object cxDBTreeList: TcxDBTreeList
    Left = 0
    Top = 28
    Width = 801
    Height = 414
    Align = alClient
    Bands = <
      item
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.EditAutoHeight = eahRow
    OptionsData.Inserting = True
    OptionsSelection.HideSelection = True
    OptionsSelection.MultiSelect = True
    OptionsView.CategorizedColumn = lcOutlineDrawing
    OptionsView.PaintStyle = tlpsCategorized
    RootValue = -1
    TabOrder = 0
    OnChange = cxDBTreeListChange
    OnEdited = cxDBTreeListEdited
    OnEditing = cxDBTreeListEditing
    OnIsGroupNode = cxDBTreeListIsGroupNode
    OnKeyDown = cxDBTreeListKeyDown
    object lcOutlineDrawing: TcxDBTreeListColumn
      Caption.Text = #1063#1077#1088#1090#1105#1078' '#1082#1086#1088#1087#1091#1089#1072
      DataBinding.FieldName = 'OutlineDrawing'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      SortOrder = soAscending
      SortIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
      OnGetEditProperties = lcOutlineDrawingGetEditProperties
    end
    object lcLandPattern: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = lcLandPatternPropertiesButtonClick
      Caption.Text = #1063#1077#1088#1090#1105#1078' '#1087#1086#1089#1072#1076#1086#1095#1085#1086#1081' '#1087#1083#1086#1097#1072#1076#1082#1080
      DataBinding.FieldName = 'LandPattern'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lcVariation: TcxDBTreeListColumn
      Caption.Text = #1042#1072#1088#1080#1072#1085#1090' '#1082#1086#1088#1087#1091#1089#1072
      DataBinding.FieldName = 'Variation'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lcImage: TcxDBTreeListColumn
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = lcImagePropertiesButtonClick
      Caption.Text = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      DataBinding.FieldName = 'Image'
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lcID: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ID'
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object lcLevel: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'Level'
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 296
    Top = 192
    DockControlHeights = (
      0
      0
      28
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'MainToolbar'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 637
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnApplyBestFit'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddBodyType'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddBodyVariation'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnDrop'
        end
        item
          Visible = True
          ItemName = 'dxbbCommit'
        end
        item
          Visible = True
          ItemName = 'dxbbRollback'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmExportImport'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbrbtnApplyBestFit: TdxBarButton
      Action = actAddRoot
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnAddBodyType: TdxBarButton
      Action = actAddBodyType
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnAddBodyVariation: TdxBarButton
      Action = actAddBodyVariation
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnDrop: TdxBarButton
      Action = actDrop
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrsbtmExportImport: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090'/'#1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnLoadFromExcelDocument'
        end
        item
          Visible = True
          ItemName = 'dxbbExportToExcel'
        end>
    end
    object dxbrbtnLoadFromExcelDocument: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
    end
    object dxbbCommit: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbExportToExcel: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxbbRollback: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  object ActionList: TActionList
    Images = DMRepository.cxImageList
    Left = 208
    Top = 192
    object actApplyBestFit: TAction
      Caption = 'actApplyBestFit'
      OnExecute = actApplyBestFitExecute
    end
    object actAddRoot: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087
      ImageIndex = 1
      OnExecute = actAddRootExecute
    end
    object actAddBodyType: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1088#1087#1091#1089
      ImageIndex = 1
      OnExecute = actAddBodyTypeExecute
    end
    object actAddBodyVariation: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1072#1088#1080#1072#1085#1090' '#1082#1086#1088#1087#1091#1089#1072
      ImageIndex = 1
      OnExecute = actAddBodyVariationExecute
    end
    object actDrop: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      ImageIndex = 2
      OnExecute = actDropExecute
    end
    object actLoadFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actExportToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportToExcelDocumentExecute
    end
    object actCommit: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 3
      OnExecute = actCommitExecute
    end
    object actRollback: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      ImageIndex = 14
      OnExecute = actRollbackExecute
    end
  end
  object cxEditRepository: TcxEditRepository
    Left = 48
    Top = 192
    object cxEditRepositoryButtonItem1: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxEditRepositoryButtonItem1PropertiesButtonClick
    end
    object cxEditRepositoryTextItem1: TcxEditRepositoryTextItem
    end
  end
end
