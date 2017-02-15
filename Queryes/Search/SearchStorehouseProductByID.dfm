inherited QuerySearchStorehouseProductByID: TQuerySearchStorehouseProductByID
  inherited Label1: TLabel
    Width = 201
    Caption = 'SearchStorehouseProductByID'
    ExplicitWidth = 201
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from storehouseproducts'
      'where ProductID = :ProductID')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
