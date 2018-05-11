inherited ViewTreeList: TViewTreeList
  Width = 377
  Height = 420
  ExplicitWidth = 377
  ExplicitHeight = 420
  inherited cxDBTreeList: TcxDBTreeList
    Width = 377
    Height = 220
    Bands = <
      item
      end>
    DragMode = dmAutomatic
    OptionsBehavior.CellHints = False
    OptionsBehavior.ImmediateEditor = False
    OptionsBehavior.BestFitMaxRecordCount = 10
    OptionsBehavior.DragDropText = True
    OptionsBehavior.ExpandOnIncSearch = True
    OptionsBehavior.IncSearch = True
    OptionsBehavior.IncSearchItem = clValue
    OptionsData.SmartRefresh = True
    OptionsView.Headers = False
    OptionsView.ShowRoot = False
    OnClick = cxDBTreeListClick
    OnCollapsed = cxDBTreeListCollapsed
    OnDragDrop = cxDBTreeListDragDrop
    OnDragOver = cxDBTreeListDragOver
    OnExpanded = cxDBTreeListExpanded
    OnMouseUp = cxDBTreeListMouseUp
    ExplicitWidth = 355
    ExplicitHeight = 220
    object clID: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ID'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clValue: TcxDBTreeListColumn
      DataBinding.FieldName = 'Value'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object clOrd: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'Ord'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      SortOrder = soAscending
      SortIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  inherited StatusBar: TStatusBar
    Top = 401
    Width = 377
    Visible = False
    ExplicitTop = 401
    ExplicitWidth = 355
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 256
    Width = 377
    Height = 145
    Align = alBottom
    TabOrder = 6
    ExplicitWidth = 355
  end
  object cxSplitter: TcxSplitter [3]
    Left = 0
    Top = 248
    Width = 377
    Height = 8
    HotZoneClassName = 'TcxSimpleStyle'
    AlignSplitter = salBottom
    Control = pnlBottom
    OnAfterOpen = cxSplitterAfterOpen
    OnAfterClose = cxSplitterAfterClose
    ExplicitWidth = 355
  end
  inherited dxBarManager: TdxBarManager
    ShowHint = False
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxBarManagerBar1: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'cxbeiSearch'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = actDuplicate
      Category = 0
    end
    object cxbeiSearch: TcxBarEditItem
      Caption = #1055#1086#1080#1089#1082':'
      Category = 0
      Hint = #1055#1086#1080#1089#1082':'
      Visible = ivAlways
      OnKeyDown = cxbeiSearchKeyDown
      ShowCaption = True
      PropertiesClassName = 'TcxTextEditProperties'
      Properties.OnChange = cxbeiSearchPropertiesChange
    end
    object dxBarButton2: TdxBarButton
      Action = actSearch
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actClear
      Category = 0
      PaintStyle = psCaptionInMenu
    end
  end
  inherited ActionList: TActionList
    Images = DMRepository.cxImageList
    inherited actCopy: TAction
      ImageIndex = 5
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1076#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actRename: TAction
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      Hint = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 11
      OnExecute = actRenameExecute
    end
    object actDelete: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1102
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actExportTreeToExcelDocument: TAction
      Caption = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actExportTreeToExcelDocumentExecute
    end
    object actLoadTreeFromExcelDocument: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 6
      OnExecute = actLoadTreeFromExcelDocumentExecute
    end
    object actDuplicate: TAction
      Caption = #1044#1091#1073#1083#1080#1082#1072#1090#1099
      Hint = #1044#1091#1073#1083#1080#1082#1072#1090#1099
      ImageIndex = 40
      OnExecute = actDuplicateExecute
    end
    object actSearch: TAction
      Caption = #1055#1086#1080#1089#1082
      Hint = #1055#1086#1080#1089#1082' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1087#1086' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1091
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1083#1077' '#1087#1086#1080#1089#1082#1072
      ImageIndex = 10
      OnExecute = actClearExecute
    end
  end
  inherited PopupMenu: TPopupMenu
    Images = DMRepository.cxImageList
    object N2: TMenuItem
      Action = actAdd
    end
    object N3: TMenuItem
      Action = actRename
    end
    object N4: TMenuItem
      Action = actDelete
    end
    object Excel1: TMenuItem
      Action = actExportTreeToExcelDocument
    end
    object Excel2: TMenuItem
      Action = actLoadTreeFromExcelDocument
    end
  end
end
