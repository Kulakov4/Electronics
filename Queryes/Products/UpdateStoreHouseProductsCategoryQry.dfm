inherited QryUpdateStoreHouseProductsCategory: TQryUpdateStoreHouseProductsCategory
  inherited Label1: TLabel
    Width = 240
    Caption = 'UpdateStoreHouseProductsCategory'
    ExplicitWidth = 240
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'update StorehouseProducts'
      'set IDComponentGroup = :New_IDComponentGroup'
      
        'where IDComponentGroup = :Old_IDComponentGroup and StorehouseId ' +
        '= :StorehouseId')
    ParamData = <
      item
        Name = 'NEW_IDCOMPONENTGROUP'
        ParamType = ptInput
      end
      item
        Name = 'OLD_IDCOMPONENTGROUP'
        ParamType = ptInput
      end
      item
        Name = 'STOREHOUSEID'
        ParamType = ptInput
      end>
  end
end
