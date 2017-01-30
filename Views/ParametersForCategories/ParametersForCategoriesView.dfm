inherited ViewParametersForCategories: TViewParametersForCategories
  inherited cxGrid: TcxGrid
    Top = 0
    Height = 472
    ExplicitTop = 0
    ExplicitHeight = 472
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.OnDetailExpanded = cxGridDBBandedTableViewDataControllerDetailExpanded
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      object clID1: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ParameterType'
        PropertiesClassName = 'TcxLabelProperties'
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
    end
    object cxGridDBBandedTableView2: TcxGridDBBandedTableView [1]
      Navigator.Buttons.CustomButtons = <>
      DataController.DataModeController.DetailInSQLMode = True
      DataController.DataModeController.OnDetailFirst = cxGridDBBandedTableView2DataControllerDataModeControllerDetailFirst
      DataController.DataModeController.OnDetailIsCurrentQuery = cxGridDBBandedTableView2DataControllerDataModeControllerDetailIsCurrentQuery
      DataController.DetailKeyFieldNames = 'IDParameterType'
      DataController.KeyFieldNames = 'ID'
      DataController.MasterKeyFieldNames = 'ID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.AlwaysShowEditor = True
      OptionsBehavior.IncSearch = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      Bands = <
        item
        end>
      object clCheckBox: TcxGridDBBandedColumn
        Caption = #1057#1090#1072#1090#1091#1089
        DataBinding.FieldName = 'isAdded'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.ValueChecked = 1
        Properties.ValueUnchecked = 0
        Properties.OnChange = clCheckBoxPropertiesChange
        MinWidth = 30
        Options.AutoWidthSizable = False
        Width = 30
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clID: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Id'
        Visible = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clIsAttribute: TcxGridDBBandedColumn
        Caption = #1040#1090#1088#1080#1073#1091#1090
        DataBinding.FieldName = 'IsAttribute'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ImmediatePost = True
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        Properties.OnChange = clCheckBoxPropertiesChange
        MinWidth = 30
        Options.AutoWidthSizable = False
        Width = 30
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1072
        DataBinding.FieldName = 'Value'
        MinWidth = 100
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clTableName: TcxGridDBBandedColumn
        Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'TableName'
        MinWidth = 100
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        MinWidth = 100
        Options.Editing = False
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clIDParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'IDParameterType'
        Visible = False
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Order'
        Visible = False
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
    inherited cxGridLevel: TcxGridLevel
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBBandedTableView2
      end
    end
  end
  inherited StatusBar: TStatusBar
    Visible = False
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      0
      0)
    inherited dxbrMain: TdxBar
      Visible = False
    end
  end
end
