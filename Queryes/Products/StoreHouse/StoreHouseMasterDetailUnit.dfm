inherited StoreHouseMasterDetail: TStoreHouseMasterDetail
  inherited GridPanel1: TGridPanel
    ControlCollection = <
      item
        Column = 0
        Control = qStoreHouseList
        Row = 0
      end
      item
        Column = 1
        Control = qProducts
        Row = 0
      end>
    DesignSize = (
      294
      73)
    inline qStoreHouseList: TQueryStoreHouseList
      Left = 11
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 11
      ExplicitTop = 1
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
    inline qProducts: TQueryProducts
      Left = 147
      Top = 1
      Width = 146
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 147
      ExplicitTop = 1
      ExplicitWidth = 146
      ExplicitHeight = 71
    end
  end
end
