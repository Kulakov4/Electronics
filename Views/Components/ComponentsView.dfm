inherited ViewComponents: TViewComponents
  Width = 960
  ExplicitWidth = 960
  inherited cxGrid: TcxGrid
    Width = 960
    ExplicitWidth = 960
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
    end
    inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
      inherited clSubGroup2: TcxGridDBBandedColumn
        DataBinding.FieldName = 'subgroup'
      end
    end
  end
  inherited StatusBar: TStatusBar
    Width = 960
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
      end
      item
        Width = 150
      end>
    ExplicitWidth = 960
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
          ItemName = 'dxbrsbtmAdd'
        end
        item
          Visible = True
          ItemName = 'dxbrsbtmDelete'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnApply'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end>
      OneOnRow = False
    end
    object dxBarManagerBar1: TdxBar [1]
      Caption = 'Second'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 448
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 903
      FloatTop = 0
      FloatClientWidth = 0
      FloatClientHeight = 0
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxbbParametricTable'
        end
        item
          Visible = True
          ItemName = 'dxbbSettings'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxbrsbtmAdd: TdxBarSubItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnAddFamily'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddComponent'
        end>
    end
    object dxbrbtnAddFamily: TdxBarButton
      Action = actAddFamily
      Category = 0
    end
    object dxbrbtnAddComponent: TdxBarButton
      Action = actAddComponent
      Category = 0
    end
    object dxbrsbtmDelete: TdxBarSubItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 2
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnDeleteMain'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnDeleteFromAllCategories'
        end>
    end
    object dxbrbtnDeleteMain: TdxBarButton
      Action = actDeleteEx
      Category = 0
    end
    object dxbrbtnDeleteFromAllCategories: TdxBarButton
      Action = actDeleteFromAllCategories
      Category = 0
    end
    object dxbrbtnApply: TdxBarButton
      Action = actCommit
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbrbtnPasteFromBuffer: TdxBarButton
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      Category = 0
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      Visible = ivAlways
      ImageIndex = 5
    end
    object dxbrbtnParametricTable: TdxBarButton
      Action = actShowParametricTable
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbb1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxbrsbtmLoad: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1090#1077#1093'. '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1094#1080#1102
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxbbLoadSpecifications: TdxBarButton
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080' '#1080#1079' '#1087#1072#1087#1082#1080
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1080' '#1080#1079' '#1092#1072#1081#1083#1086#1074
      Visible = ivAlways
      ImageIndex = 7
    end
    object dxbrbtnLoadImages: TdxBarButton
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103' '#1080#1079' '#1087#1072#1087#1082#1080
      Category = 0
      Visible = ivAlways
      ImageIndex = 8
    end
    object dxbrbtnLoadSchemes: TdxBarButton
      Caption = #1057#1093#1077#1084#1099' '#1080#1079' '#1087#1072#1087#1082#1080
      Category = 0
      Visible = ivAlways
      ImageIndex = 16
    end
    object dxbrbtnLoadDrawings: TdxBarButton
      Caption = #1063#1077#1088#1090#1077#1078#1080' '#1080#1079' '#1087#1072#1087#1082#1080
      Category = 0
      Visible = ivAlways
      ImageIndex = 17
    end
    object dxbbParametricTable: TdxBarButton
      Action = actShowParametricTable
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxbbSettings: TdxBarButton
      Action = actSettings
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actRefresh
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited ActionList: TActionList
    object actShowParametricTable: TAction [14]
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 11
      OnExecute = actShowParametricTableExecute
    end
    object actRefresh: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 4
      OnExecute = actRefreshExecute
    end
  end
end
