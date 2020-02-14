inherited ViewProducts2: TViewProducts2
  Width = 1206
  ExplicitWidth = 1206
  inherited cxDBTreeList: TcxDBTreeList
    Width = 1206
    Bands = <
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        FixedKind = tlbfLeft
      end
      item
        Caption.Text = #1057#1082#1083#1072#1076
        Visible = False
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
      end
      item
        Caption.AlignHorz = taCenter
        Caption.Text = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      end>
    ExplicitWidth = 1206
    inherited clStoreHouseID: TcxDBTreeListColumn
      DataBinding.FieldName = ''
    end
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
    Width = 1206
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
    ExplicitWidth = 1206
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
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
          ItemName = 'dxBarSubItem3'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
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
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end>
    end
    inherited dxBarManagerBar2: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'cxbeiExtraChargeType'
        end
        item
          UserDefine = [udWidth]
          UserWidth = 84
          Visible = True
          ItemName = 'cxbeiExtraCharge'
        end
        item
          Visible = True
          ItemName = 'dxbcWholeSale'
        end
        item
          Visible = True
          ItemName = 'dxbcMinWholeSale'
        end
        item
          Visible = True
          ItemName = 'dxbcRetail'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Hint = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1082#1086#1083#1086#1085#1082#1072#1084#1080
      ShowCaption = False
    end
    object dxBarSubItem1: TdxBarSubItem [4]
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 1
      ShowCaption = False
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
    object dxBarButton1: TdxBarButton [5]
      Action = actAddCategory
      Category = 0
    end
    object dxBarButton2: TdxBarButton [6]
      Action = actAddComponent
      Category = 0
    end
    object dxBarButton3: TdxBarButton [7]
      Action = actDelete
      Category = 0
      PaintStyle = psCaptionInMenu
    end
    object dxBarButton4: TdxBarButton [8]
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionInMenu
    end
    object dxBarButton5: TdxBarButton [9]
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionInMenu
    end
    object dxBarButton6: TdxBarButton [10]
      Action = actOpenInParametricTable
      Category = 0
    end
    object dxBarSubItem2: TdxBarSubItem [15]
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Hint = #1069#1082#1089#1087#1086#1088#1090
      Visible = ivAlways
      ImageIndex = 6
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end>
    end
    object dxBarButton9: TdxBarButton [16]
      Action = actExportToExcelDocument
      Category = 0
    end
    object dxBarButton7: TdxBarButton [19]
      Action = actApplyBestFit
      Category = 0
    end
    object dxBarButton8: TdxBarButton [20]
      Action = actFullScreen
      Category = 0
    end
    object dxBarButton10: TdxBarButton [21]
      Action = actFilterAndExportToExcelDocument
      Category = 0
    end
    object dxBarSubItem3: TdxBarSubItem [25]
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 20
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end>
    end
    object dxBarButton17: TdxBarButton [26]
      Action = actLoadFromExcelDocument
      Category = 0
    end
    inherited dxbbRubToDollar: TdxBarButton
      Hint = #1055#1088#1080#1082#1088#1077#1087#1080#1090#1100' '#1079#1072#1082#1091#1087#1086#1095#1085#1091#1102' '#1094#1077#1085#1091' '#1074' '#8381' '#1082' '#1080#1079#1084#1077#1085#1077#1085#1080#1102' '#1082#1091#1088#1089#1072' $'
    end
  end
  inherited ActionList: TActionList
    object actColumnsAutoWidth2: TAction [16]
      Caption = #1040#1074#1090#1086#1096#1080#1088#1080#1085#1072' '#1082#1086#1083#1086#1085#1086#1082
      OnExecute = actColumnsAutoWidth2Execute
    end
    object actFullScreen: TAction [23]
      Caption = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      Hint = #1055#1086#1083#1085#1086#1101#1082#1088#1072#1085#1085#1099#1081' '#1088#1077#1078#1080#1084
      ImageIndex = 35
      OnExecute = actFullScreenExecute
    end
    object actFilterAndExportToExcelDocument: TAction [24]
      Caption = #1042#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1089#1090#1088#1086#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      Hint = #1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1077' '#1089#1090#1088#1086#1082#1080' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090' Excel'
      ImageIndex = 6
      OnExecute = actFilterAndExportToExcelDocumentExecute
    end
    object actCalcCount: TAction [28]
      Caption = 'actCalcCount'
      OnExecute = actCalcCountExecute
    end
    object actTryEdit: TAction [29]
      Caption = 'actTryEdit'
      OnExecute = actTryEditExecute
    end
    object actDisContrl: TAction [30]
      Caption = 'actDisContrl'
      OnExecute = actDisContrlExecute
    end
    object actEnContrl: TAction [31]
      Caption = 'actEnContrl'
      OnExecute = actEnContrlExecute
    end
    object actIsContolDis: TAction [32]
      Caption = 'actIsContolDis'
      OnExecute = actIsContolDisExecute
    end
    object actLoadFromExcelDocument: TAction [33]
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 32
      OnExecute = actLoadFromExcelDocumentExecute
    end
  end
  inherited cxStyleRepository1: TcxStyleRepository
    PixelsPerInch = 96
  end
end
