inherited ViewComponentsParent: TViewComponentsParent
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnCellClick = cxGridDBBandedTableViewCellClick
      OnEditKeyUp = cxGridDBBandedTableViewEditKeyUp
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      DataController.KeyFieldNames = 'ID'
      DataController.OnDetailExpanded = cxGridDBBandedTableViewDataControllerDetailExpanded
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = False
      OnColumnSizeChanged = cxGridDBBandedTableViewColumnSizeChanged
      OnLeftPosChanged = cxGridDBBandedTableViewLeftPosChanged
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end>
      OnBandSizeChanged = cxGridDBBandedTableViewBandSizeChanged
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        OnGetProperties = clValueGetProperties
        OnGetPropertiesForEdit = clValueGetPropertiesForEdit
        Options.ShowEditButtons = isebAlways
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      OnKeyDown = cxGridDBBandedTableViewKeyDown
      OnMouseDown = cxGridDBBandedTableViewMouseDown
      Navigator.Buttons.CustomButtons = <>
      OnCellClick = cxGridDBBandedTableView2CellClick
      OnEditKeyDown = cxGridDBBandedTableView2EditKeyDown
      OnEditKeyUp = cxGridDBBandedTableViewEditKeyUp
      DataController.DetailKeyFieldNames = 'ParentProductId'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.OnCompare = cxGridDBBandedTableViewDataControllerCompare
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsData.DeletingConfirmation = False
      OptionsSelection.MultiSelect = True
      OptionsSelection.CellMultiSelect = True
      OptionsSelection.InvertSelect = False
      OptionsView.ScrollBars = ssVertical
      OptionsView.GroupByBox = False
      OptionsView.Header = False
      OptionsView.BandHeaders = False
      OnLeftPosChanged = cxGridDBBandedTableViewLeftPosChanged
      Bands = <
        item
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end>
      object clID2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clValue2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        OnGetProperties = clValue2GetProperties
        OnGetPropertiesForEdit = clValue2GetPropertiesForEdit
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    inherited cxGridLevel: TcxGridLevel
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBBandedTableView2
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
  inherited ActionList: TActionList
    object actDeleteFromAllCategories: TAction
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1079' '#1074#1089#1077#1093' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086' '#1080#1079' '#1074#1089#1077#1093' '#1082#1072#1090#1077#1075#1086#1088#1080#1081
      ImageIndex = 33
      OnExecute = actDeleteFromAllCategoriesExecute
    end
    object actAddFamily: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1077#1084#1077#1081#1089#1090#1074#1086' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1074
      ImageIndex = 1
      OnExecute = actAddFamilyExecute
    end
    object actAddComponent: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      ImageIndex = 1
      OnExecute = actAddComponentExecute
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
  inherited cxGridPopupMenu: TcxGridPopupMenu
    PopupMenus = <
      item
        GridView = cxGridDBBandedTableView
        HitTypes = [gvhtGridNone, gvhtNone, gvhtCell]
        Index = 0
        PopupMenu = pmGrid
      end
      item
        GridView = cxGridDBBandedTableView2
        HitTypes = [gvhtCell]
        Index = 1
        PopupMenu = pmGrid
      end>
  end
  object cxerComponents: TcxEditRepository
    Left = 64
    Top = 208
    object cxFieldValueWithExpand: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Caption = 'F'
          Default = True
          ImageIndex = 15
          Kind = bkGlyph
        end>
      Properties.Images = DMRepository.cxImageList
      Properties.OnButtonClick = cxFieldValueWithExpandPropertiesButtonClick
    end
    object cxFieldValueWithExpandRO: TcxEditRepositoryButtonItem
      Properties.Buttons = <
        item
          Caption = 'F'
          Default = True
          ImageIndex = 15
          Kind = bkGlyph
        end>
      Properties.Images = DMRepository.cxImageList
      Properties.ReadOnly = True
      Properties.OnButtonClick = cxFieldValueWithExpandPropertiesButtonClick
    end
    object cxertiValue: TcxEditRepositoryTextItem
    end
    object cxertiValueRO: TcxEditRepositoryTextItem
      Properties.ReadOnly = True
    end
  end
end
