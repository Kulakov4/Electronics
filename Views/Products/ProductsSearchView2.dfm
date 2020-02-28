inherited ViewProductsSearch2: TViewProductsSearch2
  inherited cxDBTreeList: TcxDBTreeList
    inherited clSaleCount: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleCount
          Kind = skSum
        end>
    end
    inherited clSaleR: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleR
          Kind = skSum
        end>
    end
    inherited clSaleD: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleD
          Kind = skSum
        end>
    end
    inherited clSaleE: TcxDBTreeListColumn
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = clSaleE
          Kind = skSum
        end>
    end
  end
  inherited StatusBar: TStatusBar
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
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
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxbbCreateBill'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      ShowCaption = False
    end
    object dxBarButton1: TdxBarButton [10]
      Action = actPasteFromBuffer
      Category = 0
    end
    object dxBarButton3: TdxBarButton [11]
      Action = actSearch
      Category = 0
    end
    object dxBarButton4: TdxBarButton [12]
      Action = actCommit
      Category = 0
    end
    object dxBarButton5: TdxBarButton [13]
      Action = actRollback
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem [14]
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 6
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end>
    end
    object dxBarButton6: TdxBarButton [15]
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton7: TdxBarButton [16]
      Action = actOpenInParametricTable
      Category = 0
    end
    object dxBarButton8: TdxBarButton [17]
      Action = actApplyBestFit
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actClear
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actPasteFromBuffer: TAction [15]
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      OnExecute = actPasteFromBufferExecute
    end
    object actClear: TAction [16]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1087#1086#1080#1089#1082
      ImageIndex = 10
      OnExecute = actClearExecute
    end
    object actSearch: TAction [17]
      Caption = #1055#1086#1080#1089#1082
      Hint = #1055#1086#1080#1089#1082' '#1085#1072' '#1089#1082#1083#1072#1076#1072#1093
      ImageIndex = 9
      OnExecute = actSearchExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
