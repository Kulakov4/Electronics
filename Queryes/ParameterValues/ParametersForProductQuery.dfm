inherited QueryParametersForProduct: TQueryParametersForProduct
  Width = 253
  ExplicitWidth = 253
  inherited Label1: TLabel
    Width = 147
    Caption = 'ParametersForProduct'
    ExplicitWidth = 147
  end
  inherited FDQuery: TFDQuery
    OnUpdateRecord = FDQueryUpdateRecord
  end
  object fdqUpdate: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'update CategoryParams'
      'set IsEnabled = 1, IsAttribute = 1, [Order] = :Order'
      'where id = :id')
    Left = 136
    Top = 25
    ParamData = <
      item
        Name = 'ORDER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdqInsert: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      
        'insert into CategoryParams(ProductCategoryId, ParameterId, IsEna' +
        'bled, IsAttribute, [Order])'
      'values (:ProductCategoryId, :ParameterId, 1, 1, :Order)')
    Left = 192
    Top = 25
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ORDER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdqSelect: TFDQuery
    SQL.Strings = (
      'select distinct ppc.ProductCategoryID ProductCategoryID2, cp.*'
      'from '
      '--temp_table_name'
      'tt'
      'join ProductProductCategories ppc on ppc.ProductId = tt.id'
      'join ProductCategories pc on ppc.ProductCategoryId = pc.Id'
      
        'left join CategoryParams cp on cp.ProductCategoryId = pc.Id and ' +
        'cp.ParameterId = :ParameterID')
    Left = 72
    Top = 25
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
