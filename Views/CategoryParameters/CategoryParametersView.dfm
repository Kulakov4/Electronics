inherited ViewCategoryParameters: TViewCategoryParameters
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnEditValueChanged = cxGridDBBandedTableViewEditValueChanged
      Styles.OnGetContentStyle = cxGridDBBandedTableViewStylesGetContentStyle
      object clID: TcxGridDBBandedColumn
        Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
        DataBinding.FieldName = 'ID'
        Visible = False
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
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
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object clValueT: TcxGridDBBandedColumn
        Caption = #1055#1077#1088#1077#1074#1086#1076
        DataBinding.FieldName = 'ValueT'
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object clPosID: TcxGridDBBandedColumn
        Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077
        DataBinding.FieldName = 'PosID'
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object clOrder: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Order'
        Options.Editing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        SortIndex = 1
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 5
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
          ItemName = 'dxbrsbtmColumnsCustomization'
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
  end
  inherited ActionList: TActionList
    object actPosBegin: TAction
      Caption = #1042' '#1085#1072#1095#1072#1083#1086
      OnExecute = actPosBeginExecute
    end
    object actPosCenter: TAction
      Caption = #1042' '#1089#1077#1088#1077#1076#1080#1085#1091
      OnExecute = actPosCenterExecute
    end
    object actPosEnd: TAction
      Caption = #1042' '#1082#1086#1085#1077#1094
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
  end
  object cxStyleRepository: TcxStyleRepository
    Left = 591
    Top = 120
    PixelsPerInch = 96
  end
end
