object DM2: TDM2
  Left = 0
  Top = 0
  Caption = 'DM2'
  ClientHeight = 705
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inline qVersion: TQueryVersion
    Left = 0
    Top = 0
    Width = 125
    Height = 80
    TabOrder = 0
  end
  inline qTreeList: TQueryTreeList
    Left = 144
    Top = 0
    Width = 125
    Height = 80
    TabOrder = 1
    ExplicitLeft = 144
  end
  inline BodyTypesGroup: TBodyTypesGroup
    Left = 2
    Top = 165
    Width = 971
    Height = 82
    TabOrder = 2
    ExplicitLeft = 2
    ExplicitTop = 165
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
  inline ProducersGroup: TProducersGroup
    Left = 2
    Top = 247
    Width = 315
    Height = 90
    TabOrder = 3
    ExplicitLeft = 2
    ExplicitTop = 247
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
  inline ParametersGroup: TParametersGroup
    Left = 1
    Top = 338
    Width = 790
    Height = 79
    TabOrder = 4
    ExplicitLeft = 1
    ExplicitTop = 338
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
  inline ComponentsExGroup: TComponentsExGroup
    Left = 1
    Top = 417
    Width = 539
    Height = 81
    TabOrder = 5
    ExplicitLeft = 1
    ExplicitTop = 417
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
  inline ComponentsGroup: TComponentsGroup
    Left = 2
    Top = 498
    Width = 514
    Height = 124
    TabOrder = 6
    ExplicitLeft = 2
    ExplicitTop = 498
    ExplicitHeight = 124
    inherited GridPanel1: TGridPanel
      Height = 124
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
      ExplicitHeight = 124
      inherited qFamily: TQueryFamily
        Height = 122
        ExplicitHeight = 122
      end
      inherited qComponents: TQueryComponents
        Height = 122
        ExplicitHeight = 122
      end
    end
  end
  inline ComponentsSearchGroup: TComponentsSearchGroup
    Left = 0
    Top = 623
    Width = 526
    Height = 82
    TabOrder = 7
    ExplicitTop = 623
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
  inline qCategoryParameters: TQueryCategoryParameters
    Left = 290
    Top = 0
    Width = 277
    Height = 80
    TabOrder = 8
    ExplicitLeft = 290
  end
  inline qChildCategories: TQueryChildCategories
    Left = 571
    Top = 0
    Width = 125
    Height = 77
    TabOrder = 9
    ExplicitLeft = 571
    ExplicitHeight = 77
  end
  inline qProducts: TQueryProducts
    Left = 560
    Top = 432
    Width = 139
    Height = 77
    TabOrder = 10
    ExplicitLeft = 560
    ExplicitTop = 432
  end
  inline qStoreHouseList: TQueryStoreHouseList
    Left = 532
    Top = 512
    Width = 208
    Height = 86
    TabOrder = 12
    ExplicitLeft = 532
    ExplicitTop = 512
  end
  inline qProductsSearch: TQueryProductsSearch
    Left = 733
    Top = 432
    Width = 190
    Height = 83
    TabOrder = 11
    ExplicitLeft = 733
    ExplicitTop = 432
  end
  inline DescriptionsGroup: TDescriptionsGroup
    Left = 8
    Top = 82
    Width = 604
    Height = 81
    TabOrder = 13
    ExplicitLeft = 8
    ExplicitTop = 82
    inherited GridPanel1: TGridPanel
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
        end>
    end
  end
end
