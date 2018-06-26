inherited ViewBodyVariationJEDEC: TViewBodyVariationJEDEC
  inherited cxGrid: TcxGrid
    inherited cxGridDBBandedTableView: TcxGridDBBandedTableView
      DataController.DataSource = DataSource
      OptionsData.Appending = True
      OptionsView.Header = False
      object clIDJEDEC: TcxGridDBBandedColumn
        DataBinding.FieldName = 'IDJEDEC'
        Visible = False
        VisibleForCustomization = False
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object clJEDEC: TcxGridDBBandedColumn
        DataBinding.FieldName = 'JEDEC'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = actOpenJEDEC
            Default = True
            Kind = bkGlyph
          end
          item
            Action = actLoadJEDEC
            Kind = bkEllipsis
          end>
        Properties.Images = DMRepository.cxImageList
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end>
    end
    inherited dxbsColumns: TdxBarSubItem
      Visible = ivNever
    end
    object dxBarButton2: TdxBarButton
      Action = actOK
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actCancel
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton1: TdxBarButton
      Action = actAdd
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actDeleteEx
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actOpenAll
      Category = 0
    end
  end
  inherited ActionList: TActionList
    inherited actDeleteEx: TAction
      Hint = #1059#1076#1072#1083#1080#1090#1100' JEDEC '#1076#1086#1082#1091#1084#1077#1085#1090
    end
    object actOK: TAction
      Caption = 'OK'
      ImageIndex = 41
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = #1054#1090#1084#1077#1085#1072
      ImageIndex = 14
      OnExecute = actCancelExecute
    end
    object actAdd: TAction
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' JEDEC '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
      OnExecute = actAddExecute
    end
    object actOpenJEDEC: TAction
      Caption = 'JD'
      Hint = #1054#1090#1082#1088#1099#1090#1100' JEDEC'
      ImageIndex = 42
      OnExecute = actOpenJEDECExecute
    end
    object actLoadJEDEC: TAction
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' JEDEC'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' JEDEC'
      ImageIndex = 43
      OnExecute = actLoadJEDECExecute
    end
    object actOpenAll: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1074#1089#1105
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1074#1089#1077' JEDEC '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 42
      OnExecute = actOpenAllExecute
    end
  end
  inherited pmGrid: TPopupMenu
    object N2: TMenuItem
      Action = actDeleteEx
    end
  end
  object DataSource: TDataSource
    Left = 328
    Top = 344
  end
  object dsJEDEC: TDataSource
    Left = 256
    Top = 240
  end
end
