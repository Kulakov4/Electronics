inherited frmStoreHouseMasterDetail: TfrmStoreHouseMasterDetail
  Height = 112
  ExplicitHeight = 112
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
    inline qStoreHouseList: TfrmQueryStoreHouseList
      Left = 1
      Top = 1
      Width = 146
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 146
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
      inherited qStoreHouseProducts: TfrmApplyQuery
        inherited FDQuery: TFDQuery
          Transaction = qProducts.FDTransaction
        end
      end
      inherited qProducts: TfrmApplyQuery
        inherited FDQuery: TFDQuery
          Transaction = qProducts.FDTransaction
        end
      end
    end
  end
end
