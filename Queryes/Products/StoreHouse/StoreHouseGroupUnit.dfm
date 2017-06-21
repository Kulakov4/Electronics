inherited StoreHouseGroup: TStoreHouseGroup
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
    inline qStoreHouseList: TQueryStoreHouseList
      Left = 1
      Top = 1
      Width = 204
      Height = 143
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 204
      ExplicitHeight = 143
    end
    inline qProducts: TQueryProducts
      Left = 205
      Top = 1
      Width = 204
      Height = 143
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 205
      ExplicitTop = 1
      ExplicitWidth = 204
      ExplicitHeight = 143
    end
  end
end
