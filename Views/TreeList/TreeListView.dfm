inherited ViewTreeList: TViewTreeList
  inherited cxDBTreeList: TcxDBTreeList
    Bands = <
      item
      end>
    DragMode = dmAutomatic
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
    Visible = False
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
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
