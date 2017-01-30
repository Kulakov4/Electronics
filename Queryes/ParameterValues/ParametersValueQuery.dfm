inherited QueryParametersValue: TQueryParametersValue
  inherited Label1: TLabel
    Width = 112
    Caption = 'ParametersValue'
    ExplicitWidth = 112
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ProductUnionParameters pup'
      'where pup.ProductId = :ProductId'
      'and pup.UnionParameterId = :UnionParameterId')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end
      item
        Name = 'UNIONPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 962
      end>
    object FDQueryId: TFDAutoIncField
      FieldName = 'Id'
      Origin = 'Id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryUnionParameterId: TIntegerField
      FieldName = 'UnionParameterId'
      Origin = 'UnionParameterId'
    end
    object FDQueryValue: TWideStringField
      FieldName = 'Value'
      Origin = 'Value'
      Size = 32767
    end
    object FDQueryProductId: TIntegerField
      FieldName = 'ProductId'
      Origin = 'ProductId'
    end
  end
end
