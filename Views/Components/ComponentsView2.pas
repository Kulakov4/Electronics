inherited ViewComponents: TViewComponents
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      OnSelectionChanged = cxGridDBBandedTableViewSelectionChanged
      inherited clProducer: TcxGridDBBandedColumn
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.Items.Strings = (
          'qwead'
          'asd sadsad'
          'asd asdqw'
          'qw eqwewq')
      end
    end
    inherited cxGridDBBandedTableView2: TcxGridDBBandedTableView
      inherited clProducer2: TcxGridDBBandedColumn
        Position.ColIndex = 2
      end
      inherited clSubGroup2: TcxGridDBBandedColumn
        Position.ColIndex = 1
      end
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
      end
      item
        Width = 150
      end>
    OnResize = StatusBarResize
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
        end
        item
          Visible = True
          ItemName = 'dxbsiLoad'
        end
        item
          Visible = True
          ItemName = 'dxbbParametricTable'
        end
        item
          Visible = True
          ItemName = 'dxbbSettings'
        end>
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
          ItemName = 'dxbrbtnAddMain'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnAddDetail'
        end>
    end
    object dxbrbtnAddMain: TdxBarButton
      Action = actAddComponent
      Category = 0
    end
    object dxbrbtnAddDetail: TdxBarButton
      Action = actAddSubComponent
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
      Action = actDelete
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
    object dxbsiLoad: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 20
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end>
    end
    object dxbrbtnPasteFromBuffer: TdxBarButton
      Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      Category = 0
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      Visible = ivAlways
      ImageIndex = 5
    end
    object dxbrbtnPasteFromExcel: TdxBarButton
      Action = actLoadFromExcelDocument
      Category = 0
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
    object dxbrbtnLoadBodyTypes: TdxBarButton
      Action = actLoadBodyTypes
      Category = 0
    end
    object dxbrbtnLoadRecommendedReplacement: TdxBarButton
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1088#1077#1082#1086#1084#1077#1085#1076#1091#1077#1084#1086#1081' '#1079#1072#1084#1077#1085#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 26
    end
    object dxbrbtnLoadTemp: TdxBarButton
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1086#1084#1091' '#1076#1080#1072#1087#1072#1079#1086#1085#1091
      Category = 0
      Visible = ivAlways
      ImageIndex = 27
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
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1050#1086#1084#1087#1086#1085#1077#1085#1090#1099
      Category = 0
      Visible = ivAlways
      ImageIndex = 21
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnPasteFromExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1044#1072#1085#1085#1099#1077
      Category = 0
      Visible = ivAlways
      ImageIndex = 22
      Images = DMRepository.cxImageList
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxbrbtnLoadBodyTypes'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnLoadRecommendedReplacement'
        end
        item
          Visible = True
          ItemName = 'dxbrbtnLoadTemp'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actLoadFromExcelFolder
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1090#1072#1090#1091#1089#1091' '#1080#1079#1076#1077#1083#1080#1103
      Category = 0
      Visible = ivAlways
      ImageIndex = 28
      OnClick = actLoadStatusExecute
    end
    object dxBarButton3: TdxBarButton
      Action = actRollback
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton4: TdxBarButton
      Action = actLoadParametricTable
      Category = 0
    end
  end
  inherited ActionList: TActionList
    object actLoadFromExcelDocument: TAction [15]
      Caption = #1048#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1099' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' Excel'
      ImageIndex = 23
      OnExecute = actLoadFromExcelDocumentExecute
    end
    object actLoadFromExcelFolder: TAction [16]
      Caption = #1048#1079' '#1087#1072#1087#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' Excel'
      ImageIndex = 24
      OnExecute = actLoadFromExcelFolderExecute
    end
    object actShowParametricTable: TAction [17]
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      Hint = #1055#1072#1088#1072#1084#1077#1090#1088#1080#1095#1077#1089#1082#1072#1103' '#1090#1072#1073#1083#1080#1094#1072
      ImageIndex = 11
      OnExecute = actShowParametricTableExecute
    end
    object actLoadBodyTypes: TAction [20]
      Caption = #1050#1086#1088#1087#1091#1089#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 25
      OnExecute = actLoadBodyTypesExecute
    end
    object actLoadParametricTable: TAction
      Caption = #1058#1072#1073#1083#1080#1095#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1089#1077#1084#1077#1081#1089#1090#1074
      ImageIndex = 31
      OnExecute = actLoadParametricTableExecute
    end
  end
end
