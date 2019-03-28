inherited ViewProductsBasket: TViewProductsBasket
  inherited cxDBTreeList: TcxDBTreeList
    Bands = <
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        FixedKind = tlbfLeft
      end
      item
        Caption.Text = #1057#1082#1083#1072#1076
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
      end
      item
        Caption.AlignHorz = taCenter
        Caption.MultiLine = True
        Caption.ShowEndEllipsis = False
        Caption.Text = #1050#1088#1072#1090#1082#1086#1077' '#1086#1087#1080#1089#1072#1085#1080#1077
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1093#1077#1084#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1063#1077#1088#1090#1105#1078
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1088#1087#1091#1089
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1044#1072#1090#1072' '#1074#1099#1087#1091#1089#1082#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1059#1087#1072#1082#1086#1074#1082#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1054#1087#1090#1086#1074#1072#1103' '#1094#1077#1085#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1056#1086#1079#1085#1080#1095#1085#1072#1103' '#1094#1077#1085#1072' ('#1079#1072' 1 '#1096#1090'.)'
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1047#1072#1082#1091#1087#1086#1095#1085#1072#1103' '#1094#1077#1085#1072' ('#1073#1077#1079' '#1053#1044#1057')'
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1088#1072#1085#1072' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1086#1084#1077#1088' '#1087#1072#1088#1090#1080#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1086#1084#1077#1088' '#1090#1072#1084#1086#1078#1077#1085#1085#1086#1081' '#1076#1077#1082#1083#1072#1088#1072#1094#1080#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1052#1077#1089#1090#1086' '#1093#1088#1072#1085#1077#1085#1080#1103
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103'-'#1087#1088#1086#1076#1072#1074#1077#1094
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1062#1080#1092#1088#1086#1074#1086#1081' '#1082#1086#1076
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1044#1072#1090#1072' '#1079#1072#1075#1088#1091#1079#1082#1080
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1091#1088#1089#1099' '#1074#1072#1083#1102#1090
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078#1080
        FixedKind = tlbfRight
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1086#1080#1084#1086#1089#1090#1100
        FixedKind = tlbfRight
      end>
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
        Width = 100
      end
      item
        Width = 100
      end>
  end
  inherited dxBarManager: TdxBarManager
    Top = 285
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
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
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
          ItemName = 'cxbeiTotalR'
        end
        item
          Visible = True
          ItemName = 'dxbbCreateBill'
        end
        item
          Visible = True
          ItemName = 'dxbbRubToDollar'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      ShowCaption = False
    end
    inherited dxbbCreateBill: TdxBarButton
      PaintStyle = psCaptionInMenu
    end
    object dxBarButton1: TdxBarButton [13]
      Action = actBasketDelete
      Category = 0
    end
    object dxBarButton2: TdxBarButton [14]
      Action = actBasketClear
      Category = 0
    end
    object dxBarButton4: TdxBarButton [15]
      Action = actApplyBestFit
      Category = 0
    end
    object dxBarButton3: TdxBarButton [18]
      Action = actCommit
      Category = 0
    end
    object dxBarButton5: TdxBarButton [19]
      Action = actRollback
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actBasketDelete: TAction [25]
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1090#1086#1074#1072#1088' '#1080#1079' '#1082#1088#1079#1080#1085#1099
      ImageIndex = 2
      OnExecute = actBasketDeleteExecute
    end
    object actBasketClear: TAction [26]
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1082#1086#1088#1079#1080#1085#1091
      ImageIndex = 10
      OnExecute = actBasketClearExecute
    end
    object actCalcExecCount: TAction [27]
      Caption = 'actCalcExecCount'
      OnExecute = actCalcExecCountExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
