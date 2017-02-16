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
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 410
    ExplicitHeight = 145
    inline qStoreHouseList: TQueryStoreHouseList
      Left = 1
      Top = 1
      Width = 204
      Height = 143
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 40
      ExplicitTop = 37
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
    inline qProducts: TQueryProducts
      Left = 205
      Top = 1
      Width = 204
      Height = 143
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 234
      ExplicitTop = 37
      ExplicitWidth = 146
      ExplicitHeight = 71
    end
  end
end
