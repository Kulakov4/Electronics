inherited ViewProductsSearch: TViewProductsSearch
  inherited cxDBTreeList: TcxDBTreeList
    OnKeyDown = cxDBTreeListKeyDown
    object clStoreHouseID2: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'StorehouseId2'
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 1
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  inherited dxBarManager: TdxBarManager
    PixelsPerInch = 96
    inherited dxBarManagerBar1: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbsColumns'
        end
        item
          Visible = True
          ItemName = 'cxbeiDate'
        end
        item
          Visible = True
          ItemName = 'cxbeiDollar'
        end
        item
          Visible = True
          ItemName = 'cxbeiEuro'
        end
        item
          Visible = True
          ItemName = 'dxbbRefreshCources'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end>
    end
    object dxBarButton2: TdxBarButton
      Action = actSearch
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actClear
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actPasteFromBuffer
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actCommit
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actRollback
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Hint = #1069#1082#1089#1087#1086#1088#1090
      Visible = ivAlways
      ImageIndex = 6
      ShowCaption = False
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
    end
    object dxBarButton7: TdxBarButton
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actClearPrice
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actCreateBill
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actOpenInParametricTable
      Category = 0
    end
  end
  inherited ActionList: TActionList
    inherited actExportToExcelDocument: TAction
      Caption = #1042' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1105' '#1089#1086#1076#1077#1088#1078#1080#1084#1086#1077' '#1087#1086#1080#1089#1082#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
    end
    object actClear: TAction
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1080#1089#1082
      ImageIndex = 10
      OnExecute = actClearExecute
    end
    object actSearch: TAction
      Caption = #1055#1086#1080#1089#1082
      Hint = #1055#1086#1080#1089#1082' '#1085#1072' '#1089#1082#1083#1072#1076#1072#1093
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
    object actPasteFromBuffer: TAction
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      OnExecute = actPasteFromBufferExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
