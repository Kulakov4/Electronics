inherited ViewCategoryParameters: TViewCategoryParameters
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = False
      Styles.OnGetContentStyle = cxGridDBBandedTableViewStylesGetContentStyle
      Styles.OnGetHeaderStyle = nil
      object clID: TcxGridDBBandedColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ID'
        Visible = False
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clValue: TcxGridDBBandedColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Value'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object clTableName: TcxGridDBBandedColumn
        Caption = #1058#1072#1073#1083#1080#1095#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'TableName'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clParameterType: TcxGridDBBandedColumn
        Caption = #1058#1080#1087
        DataBinding.FieldName = 'ParameterType'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clPosID: TcxGridDBBandedColumn
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'PosID'
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        SortIndex = 0
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Order'
        Visible = False
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        SortIndex = 1
        SortOrder = soAscending
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object clIsAttribute: TcxGridDBBandedColumn
        Caption = #1040#1082#1090#1080#1074#1085#1099#1081
        DataBinding.FieldName = 'IsAttribute'
        Options.VertSizing = False
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
    end
  end
  inherited dxBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      28
      0)
    inherited dxbrMain: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actPosBegin
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actPosEnd
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actPosCenter
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUp
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actDown
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actApplyUpdates
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton7: TdxBarButton
      Action = actCancelUpdates
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton8: TdxBarButton
      Action = actDeleteEx
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end>
    end
    object dxBarButton9: TdxBarButton
      Action = actAddToBegin
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actAddToCenter
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actAddToEnd
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actPosBegin: TAction
      Caption = #1042' '#1085#1072#1095#1072#1083#1086
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1085#1072#1095#1072#1083#1100#1085#1099#1093
      OnExecute = actPosBeginExecute
    end
    object actPosCenter: TAction
      Caption = #1042' '#1089#1077#1088#1077#1076#1080#1085#1091
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1089#1088#1077#1076#1085#1080#1093
      OnExecute = actPosCenterExecute
    end
    object actPosEnd: TAction
      Caption = #1042' '#1082#1086#1085#1077#1094
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1085#1077#1095#1085#1099#1093
      OnExecute = actPosEndExecute
    end
    object actUp: TAction
      Caption = #1042#1074#1077#1088#1093
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1074#1077#1088#1093
      ImageIndex = 37
      OnExecute = actUpExecute
    end
    object actDown: TAction
      Caption = #1042#1085#1080#1079
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1074#1085#1080#1079
      ImageIndex = 38
      OnExecute = actDownExecute
    end
    object actApplyUpdates: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 3
      OnExecute = actApplyUpdatesExecute
    end
    object actCancelUpdates: TAction
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1089#1076#1077#1083#1072#1085#1085#1099#1077' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      ImageIndex = 14
      OnExecute = actCancelUpdatesExecute
    end
    object actAddToBegin: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1085#1072#1095#1072#1083#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1085#1072#1095#1072#1083#1100#1085#1099#1093
      ImageIndex = 1
      OnExecute = actAddToBeginExecute
    end
    object actAddToCenter: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1089#1077#1088#1077#1076#1080#1085#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1089#1088#1077#1076#1085#1080#1093
      ImageIndex = 1
      OnExecute = actAddToCenterExecute
    end
    object actAddToEnd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1082#1086#1085#1077#1094
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088' '#1074' '#1075#1088#1091#1087#1087#1091' '#1082#1086#1085#1077#1095#1085#1099#1093
      ImageIndex = 1
      OnExecute = actAddToEndExecute
    end
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 594
    Top = 120
    PixelsPerInch = 96
    object cxStyleBegin: TcxStyle
      AssignedValues = [svColor]
      Color = 16113353
    end
    object cxStyleEnd: TcxStyle
      AssignedValues = [svColor]
      Color = 13431295
    end
  end
end
