inherited QueryProductParameters: TQueryProductParameters
  inherited Label1: TLabel
    Top = 11
    Width = 127
    Caption = 'ProductParameters'
    ExplicitTop = 11
    ExplicitWidth = 127
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select pup.Id, pup.UnionParameterId, pup.Value, pup.ProductId, p' +
        '.ParentProductId'
      'from'
      'ProductUnionParameters pup'
      'join Products p on pup.ProductId = p.Id'
      'where '
      'pup.ProductId in'
      '('
      '    select distinct detailp.Id'
      '    from ProductProductCategories ppc'
      '    join products p on ppc.ProductId = p.id'
      '    join products detailp on detailp.ParentProductId = p.Id'
      '    where ppc.ProductCategoryId = :ProductCategoryId'
      '    union'
      '    select distinct ProductId'
      '    from ProductProductCategories ppc'
      '    where ppc.ProductCategoryId = :ProductCategoryId'
      ')'
      'order by pup.ProductID, pup.UnionParameterId, pup.ID')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
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
    object FDQueryParentProductId: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ParentProductId'
      Origin = 'ParentProductId'
      ProviderFlags = []
      ReadOnly = True
    end
  end
end
