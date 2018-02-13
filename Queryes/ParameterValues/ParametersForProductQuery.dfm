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
      'update CategoryParams2'
      'set IsEnabled = 1, IsAttribute = 1, Ord = :Ord'
      'where id = :id')
    Left = 136
    Top = 25
    ParamData = <
      item
        Name = 'ORD'
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
      
        'insert into CategoryParams2(ProductCategoryId, ParamSubParamId, ' +
        'IsEnabled, IsAttribute, Ord)'
      'values (:ProductCategoryId, :ParamSubParamId, 1, 1, :Ord)')
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
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ORD'
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
      
        'left join CategoryParams2 cp on cp.ProductCategoryId = pc.Id and' +
        ' cp.ParamSubParamID = :ParamSubParamID')
    Left = 72
    Top = 25
    ParamData = <
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
