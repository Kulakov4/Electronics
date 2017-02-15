inherited QuerySearchProduct: TQuerySearchProduct
  inherited Label1: TLabel
    Width = 96
    Caption = 'SearchProduct'
    ExplicitWidth = 96
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from Products2'
      'where Value = :Value and IDProducer = :IDProducer')
    ParamData = <
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'IDPRODUCER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
