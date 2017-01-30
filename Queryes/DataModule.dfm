object DM: TDM
  Left = 0
  Top = 0
  Caption = #1052#1086#1076#1091#1083#1100' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 675
  ClientWidth = 1034
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
    Left = 147
    Top = 64
    Width = 125
    Height = 80
    TabOrder = 1
    ExplicitLeft = 147
    ExplicitTop = 64
  end
  inline BodyTypesMasterDetail: TBodyTypesMasterDetail
    Left = 0
    Top = 230
    Width = 578
    Height = 113
    TabOrder = 2
    ExplicitTop = 230
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = BodyTypesMasterDetail.qBodyKinds
          Row = 0
        end
        item
          Column = 1
          Control = BodyTypesMasterDetail.qBodyTypes2
          Row = 0
        end
        item
          Column = 2
          Control = BodyTypesMasterDetail.qBodyTypesBranch
          Row = 0
        end>
    end
  end
  inline qBodyTypesTree: TQueryBodyTypesTree
    Left = 0
    Top = 150
    Width = 257
    Height = 80
    TabOrder = 3
    ExplicitTop = 150
    ExplicitWidth = 257
    ExplicitHeight = 80
  end
  inline qManufacturers2: TQueryManufacturers2
    Left = 284
    Top = 150
    Width = 204
    Height = 90
    TabOrder = 4
    ExplicitLeft = 284
    ExplicitTop = 150
  end
  inline ParametersMasterDetail2: TParametersMasterDetail2
    Left = 0
    Top = 454
    Width = 480
    Height = 96
    TabOrder = 5
    ExplicitTop = 454
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ParametersMasterDetail2.qParameterTypes
          Row = 0
        end
        item
          Column = 1
          Control = ParametersMasterDetail2.qMainParameters
          Row = 0
        end
        item
          Column = 2
          Control = ParametersMasterDetail2.qSubParameters
          Row = 0
        end>
    end
  end
  inline ComponentsExMasterDetail: TComponentsExMasterDetail
    Left = 0
    Top = 554
    Width = 320
    Height = 96
    TabOrder = 6
    ExplicitTop = 554
    ExplicitWidth = 320
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ComponentsExMasterDetail.qComponentsEx
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsExMasterDetail.qComponentsDetailEx
          Row = 0
        end>
    end
  end
  inline ComponentsSearchMasterDetail: TComponentsSearchMasterDetail
    Left = 665
    Top = 16
    Width = 320
    Height = 96
    TabOrder = 7
    ExplicitLeft = 665
    ExplicitTop = 16
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = ComponentsSearchMasterDetail.qComponentsSearch
          Row = 0
        end
        item
          Column = -1
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsSearchMasterDetail.qComponentsDetailsSearch
          Row = 0
        end>
    end
  end
  inline ParametersForCategoriesMasterDetail: TParametersForCategoriesMasterDetail
    Left = 584
    Top = 230
    Width = 320
    Height = 96
    TabOrder = 8
    ExplicitLeft = 584
    ExplicitTop = 230
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 1
          Control = ParametersForCategoriesMasterDetail.qParametersDetail
          Row = 0
        end
        item
          Column = 0
          Control = ParametersForCategoriesMasterDetail.qParameterTypes
          Row = 0
        end>
    end
  end
  inline qProductsSearch: TQueryProductsSearch
    Left = 584
    Top = 328
    Width = 156
    Height = 159
    TabOrder = 9
    ExplicitLeft = 584
    ExplicitTop = 328
    ExplicitWidth = 156
    ExplicitHeight = 159
  end
  inline ComponentsMasterDetail: TComponentsMasterDetail
    Left = 301
    Top = 32
    Width = 320
    Height = 105
    TabOrder = 10
    ExplicitLeft = 301
    ExplicitTop = 32
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
          Column = 0
          Control = ComponentsMasterDetail.qComponents
          Row = 0
        end
        item
          Column = 1
          Control = ComponentsMasterDetail.qComponentsDetail
          Row = 0
        end>
    end
  end
  inline DescriptionsMasterDetail: TDescriptionsMasterDetail
    Left = 4
    Top = 349
    Width = 574
    Height = 96
    TabOrder = 12
    ExplicitLeft = 4
    ExplicitTop = 349
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = DescriptionsMasterDetail.qDescriptionsMaster
          Row = 0
        end
        item
          Column = 1
          Control = DescriptionsMasterDetail.qDescriptionsDetail
          Row = 0
        end
        item
          Column = 2
          Control = DescriptionsMasterDetail.qManufacturers2
          Row = 0
        end>
    end
  end
  inline qBodyTypes: TQueryBodyTypes
    Left = 537
    Top = 144
    Width = 125
    Height = 80
    TabOrder = 11
    ExplicitLeft = 537
    ExplicitTop = 144
  end
  inline StoreHouseMasterDetail: TStoreHouseMasterDetail
    Left = 511
    Top = 493
    Width = 320
    Height = 96
    TabOrder = 13
    ExplicitLeft = 511
    ExplicitTop = 493
    inherited GridPanel1: TGridPanel
      ControlCollection = <
        item
          Column = 0
          Control = StoreHouseMasterDetail.qStoreHouseList
          Row = 0
        end
        item
          Column = 1
          Control = StoreHouseMasterDetail.qProducts
          Row = 0
        end>
    end
  end
  inline qStoreHouseList: TQueryStoreHouseList
    Left = 800
    Top = 371
    Width = 208
    Height = 86
    TabOrder = 14
    ExplicitLeft = 800
    ExplicitTop = 371
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 40
    Top = 8
  end
end
