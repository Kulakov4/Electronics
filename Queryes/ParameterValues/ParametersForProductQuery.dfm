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
    SQL.Strings = (
      
        'select ppc.ProductID, ppc.ProductCategoryID ProductCategoryID2, ' +
        'upfc.*'
      'from Products p'
      
        'join ProductProductCategories ppc on ppc.ProductId = ifnull(p.Pa' +
        'rentProductID, p.id)'
      'join ProductCategories pc on ppc.ProductCategoryId = pc.Id'
      
        'left join unionparameterForCategories upfc on upfc.ProductCatego' +
        'ryId = pc.Id and upfc.UnionParameterId = :ParameterID'
      'where p.id = :ProductID')
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 962
      end
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
  end
  object fdqUpdate: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'update UnionParameterForCategories'
      'set IsEnabled = 1, IsAttribute = 1, [Order] = :Order'
      'where id = :id')
    Left = 136
    Top = 24
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
      
        'insert into UnionParameterForCategories(ProductCategoryId, Union' +
        'ParameterId, IsEnabled, IsAttribute, [Order])'
      'values (:ProductCategoryId, :UnionParameterId, 1, 1, :Order)')
    Left = 192
    Top = 24
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'UNIONPARAMETERID'
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
end
