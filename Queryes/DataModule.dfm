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
  inline qProductsSearch: TQueryProductsSearch
    Left = 555
    Top = 488
    Width = 254
    Height = 159
    TabOrder = 2
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
    TabOrder = 3
    ExplicitLeft = 269
    ExplicitTop = 64
  end
  inline qStoreHouseList: TQueryStoreHouseList
    Left = 275
    Top = 150
    Width = 208
    Height = 86
    TabOrder = 4
    ExplicitLeft = 275
    ExplicitTop = 150
  end
  inline StoreHouseGroup: TStoreHouseGroup
    Left = 1
    Top = 454
    Width = 525
    Height = 143
    TabOrder = 5
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
    TabOrder = 6
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
    TabOrder = 7
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
    TabOrder = 8
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
    TabOrder = 9
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
    TabOrder = 10
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
    Left = 514
    Top = -4
    Width = 604
    Height = 90
    TabOrder = 11
    ExplicitLeft = 514
    ExplicitTop = -4
    ExplicitHeight = 90
    inherited GridPanel1: TGridPanel
      Height = 90
      ControlCollection = <
        item
          Column = 0
          Control = DescriptionsGroup.qDescriptionTypes
          Row = 0
        end
        item
          Column = 1
          Control = DescriptionsGroup.qDescriptions
          Row = 0
        end
        item
          Column = 2
          Control = DescriptionsGroup.qProducers
          Row = 0
        end>
      ExplicitHeight = 90
      inherited qDescriptionTypes: TQueryDescriptionTypes
        Height = 88
        ExplicitHeight = 88
      end
      inherited qDescriptions: TQueryDescriptions
        Height = 88
        ExplicitHeight = 88
      end
      inherited qProducers: TQueryProducers
        Top = 6
        ExplicitTop = 6
      end
    end
  end
  inline qVersion: TQueryVersion
    Left = 489
    Top = 140
    Width = 125
    Height = 80
    TabOrder = 12
    ExplicitLeft = 489
    ExplicitTop = 140
  end
  inline qCategoryParameters: TQueryCategoryParameters
    Left = 904
    Top = 584
    Width = 125
    Height = 80
    TabOrder = 13
    ExplicitLeft = 904
    ExplicitTop = 584
    ExplicitWidth = 125
  end
  inline ProducersGroup: TProducersGroup
    Left = 798
    Top = 373
    Width = 315
    Height = 90
    TabOrder = 15
    ExplicitLeft = 798
    ExplicitTop = 373
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ProducersGroup.qProducerTypes
          Row = 0
        end
        item
          Column = 1
          Control = ProducersGroup.qProducers
          Row = 0
        end>
    end
  end
  inline BodyTypesGroup: TBodyTypesGroup
    Left = 16
    Top = 272
    Width = 971
    Height = 82
    TabOrder = 14
    ExplicitLeft = 16
    ExplicitTop = 272
    inherited GridPanel1: TGridPanel
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
          Control = BodyTypesGroup.qProducers
          Row = 0
        end>
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 40
    Top = 8
  end
end
