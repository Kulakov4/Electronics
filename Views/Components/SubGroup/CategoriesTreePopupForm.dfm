inherited frmCategoriesTreePopup: TfrmCategoriesTreePopup
  Caption = 'frmCategoriesTreePopup'
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxdbtlCaterories: TcxDBTreeList
    Left = 0
    Top = 26
    Width = 395
    Height = 274
    Align = alClient
    Bands = <
      item
      end>
    DataController.ParentField = 'ParentID'
    DataController.KeyField = 'ID'
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.ImmediateEditor = False
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    RootValue = -1
    TabOrder = 0
    OnDblClick = cxdbtlCateroriesDblClick
    object cxdbtlCateroriesId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'Id'
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxdbtlCateroriesValue: TcxDBTreeListColumn
      Caption.Text = #1047#1085#1072#1095#1077#1085#1080#1077
      DataBinding.FieldName = 'Value'
      Width = 245
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxdbtlCateroriesParentId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ParentId'
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object cxdbtlCateroriesExternalId: TcxDBTreeListColumn
      Caption.Text = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
      DataBinding.FieldName = 'ExternalId'
      Width = 100
      Position.ColIndex = 3
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
    Left = 80
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom 1'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 429
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxBarEditItem'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object cxBarEditItem: TcxBarEditItem
      Caption = #1055#1086#1080#1089#1082' '#1087#1086' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1091
      Category = 0
      Hint = #1055#1086#1080#1089#1082' '#1087#1086' '#1080#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088#1091
      Visible = ivAlways
      ShowCaption = True
      PropertiesClassName = 'TcxTextEditProperties'
      Properties.OnChange = cxBarEditItemPropertiesChange
      Properties.OnEditValueChanged = cxBarEditItemPropertiesEditValueChanged
    end
  end
end
