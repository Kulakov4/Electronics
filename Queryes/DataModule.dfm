object DM: TDM
  Left = 0
  Top = 0
  Caption = #1052#1086#1076#1091#1083#1100' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 675
  ClientWidth = 1161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline qTreeList: TQueryTreeList
    Left = 0
    Top = 64
    Width = 125
    Height = 80
    TabOrder = 0
    ExplicitTop = 64
  end
  inline qChildCategories: TQueryChildCategories
    Left = 138
    Top = 75
    Width = 125
    Height = 80
    TabOrder = 1
    ExplicitLeft = 138
    ExplicitTop = 75
  end
  inline qBodyTypesTree: TQueryBodyTypesTree
    Left = 0
    Top = 150
    Width = 257
    Height = 80
    TabOrder = 2
    ExplicitTop = 150
    ExplicitWidth = 257
    ExplicitHeight = 80
  end
  inline qProductsSearch: TQueryProductsSearch
    Left = 555
    Top = 488
    Width = 254
    Height = 159
    TabOrder = 3
    ExplicitLeft = 555
    ExplicitTop = 488
    ExplicitWidth = 254
    ExplicitHeight = 159
    inherited qProducts: TfrmApplyQuery
      Left = 113
      Top = 27
      ExplicitLeft = 113
      ExplicitTop = 27
      inherited FDQuery: TFDQuery
        Left = 16
      end
    end
  end
  inline qBodyTypes: TQueryBodyTypes
    Left = 269
    Top = 64
    Width = 125
    Height = 80
    TabOrder = 4
    ExplicitLeft = 269
    ExplicitTop = 64
  end
  inline qStoreHouseList: TQueryStoreHouseList
    Left = 800
    Top = 371
    Width = 208
    Height = 86
    TabOrder = 5
    ExplicitLeft = 800
    ExplicitTop = 371
  end
  inline BodyTypesGroup: TBodyTypesGroup
    Left = 2
    Top = 238
    Width = 623
    Height = 139
    TabOrder = 6
    ExplicitLeft = 2
    ExplicitTop = 238
    ExplicitWidth = 623
    ExplicitHeight = 139
    inherited GridPanel1: TGridPanel
      Width = 623
      Height = 139
      ControlCollection = <
        item
          Column = 0
          Control = BodyTypesGroup.qBodyKinds
          Row = 0
        end
        item
          Column = 1
          Control = BodyTypesGroup.qBodyTypes2
          Row = 0
        end
        item
          Column = 2
          Control = BodyTypesGroup.qBodyTypesBranch
          Row = 0
        end>
      ExplicitWidth = 623
      ExplicitHeight = 139
      inherited qBodyKinds: TQueryBodyKinds
        Width = 207
        Height = 137
        ExplicitWidth = 207
        ExplicitHeight = 137
      end
      inherited qBodyTypes2: TQueryBodyTypes2
        Left = 208
        Width = 206
        Height = 137
        ExplicitLeft = 208
        ExplicitWidth = 206
        ExplicitHeight = 137
      end
      inherited qBodyTypesBranch: TQueryBodyTypesBranch
        Left = 414
        Width = 208
        Height = 137
        ExplicitLeft = 414
        ExplicitWidth = 208
        ExplicitHeight = 137
      end
    end
  end
  inline StoreHouseGroup: TStoreHouseGroup
    Left = 1
    Top = 454
    Width = 525
    Height = 143
    TabOrder = 7
    ExplicitLeft = 1
    ExplicitTop = 454
    ExplicitWidth = 525
    ExplicitHeight = 143
    inherited GridPanel1: TGridPanel
      Width = 525
      Height = 143
      ControlCollection = <
        item
          Column = 0
          Control = StoreHouseGroup.qStoreHouseList
          Row = 0
        end
        item
          Column = 1
          Control = StoreHouseGroup.qProducts
          Row = 0
        end>
      ExplicitWidth = 525
      ExplicitHeight = 143
      inherited qStoreHouseList: TQueryStoreHouseList
        Width = 261
        Height = 141
        ExplicitWidth = 261
        ExplicitHeight = 141
      end
      inherited qProducts: TQueryProducts
        Left = 262
        Width = 262
        Height = 141
        ExplicitLeft = 262
        ExplicitWidth = 262
        ExplicitHeight = 141
      end
    end
  end
  inline ComponentsSearchGroup: TComponentsSearchGroup
    Left = 0
    Top = 603
    Width = 526
    Height = 82
    TabOrder = 8
    ExplicitTop = 603
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ComponentsSearchGroup.qFamilySearch
          Row = 0
        end
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsSearchGroup.qComponentsSearch
          Row = 0
        end>
    end
  end
  inline ParametersForCategoriesGroup: TParametersForCategoriesGroup
    Left = 104
    Top = -9
    Width = 400
    Height = 81
    TabOrder = 9
    ExplicitLeft = 104
    ExplicitTop = -9
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = -1
          Row = 0
        end
        item
          Column = 0
          Control = ParametersForCategoriesGroup.qParameterTypes
          Row = 0
        end
        item
          Column = 1
          Control = ParametersForCategoriesGroup.qParametersDetail
          Row = 0
        end>
    end
  end
  inline ComponentsGroup: TComponentsGroup
    Left = 630
    Top = 240
    Width = 516
    Height = 122
    TabOrder = 10
    ExplicitLeft = 630
    ExplicitTop = 240
    ExplicitWidth = 516
    inherited GridPanel1: TGridPanel
      Width = 516
      ControlCollection = <
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = 0
        end
        item
          Column = 0
          Control = ComponentsGroup.qFamily
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsGroup.qComponents
          Row = 0
        end>
      ExplicitWidth = 516
      inherited qFamily: TQueryFamily
        Width = 257
        ExplicitWidth = 257
      end
      inherited qComponents: TQueryComponents
        Left = 258
        Width = 257
        ExplicitLeft = 258
        ExplicitWidth = 257
      end
    end
  end
  inline ComponentsExGroup: TComponentsExGroup
    Left = 622
    Top = 120
    Width = 539
    Height = 81
    TabOrder = 11
    ExplicitLeft = 622
    ExplicitTop = 120
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = -1
          Row = -1
        end
        item
          Column = -1
          Row = 0
        end
        item
          Column = -1
          Row = -1
        end
        item
          Column = 0
          Control = ComponentsExGroup.qFamilyEx
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsExGroup.qComponentsEx
          Row = 0
        end>
    end
  end
  inline ParametersGroup: TParametersGroup
    Left = 0
    Top = 376
    Width = 790
    Height = 79
    TabOrder = 13
    ExplicitTop = 376
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ParametersGroup.qParameterTypes
          Row = 0
        end
        item
          Column = 1
          Control = ParametersGroup.qMainParameters
          Row = 0
        end
        item
          Column = 2
          Control = ParametersGroup.qSubParameters
          Row = 0
        end>
    end
  end
  inline DescriptionsGroup: TDescriptionsGroup
    Left = 544
    Top = 16
    Width = 604
    Height = 81
    TabOrder = 12
    ExplicitLeft = 544
    ExplicitTop = 16
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = DescriptionsGroup.qDescriptionsMaster
          Row = 0
        end
        item
          Column = 1
          Control = DescriptionsGroup.qDescriptionsDetail
          Row = 0
        end
        item
          Column = 2
          Row = 0
        end>
    end
  end
  inline qProducers: TQueryProducers
    Left = 352
    Top = 144
    Width = 204
    Height = 78
    TabOrder = 14
    ExplicitLeft = 352
    ExplicitTop = 144
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 40
    Top = 8
  end
end
