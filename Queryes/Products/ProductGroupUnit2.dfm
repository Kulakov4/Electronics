inherited ProductGroup: TProductGroup
  Height = 86
  ExplicitHeight = 86
  inherited GridPanel1: TGridPanel
    Height = 86
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
      Height = 84
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 29
    end
    inline qProducts: TQueryProducts
      Left = 205
      Top = 1
      Width = 204
      Height = 84
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 237
      ExplicitTop = 34
    end
  end
end
