inherited QuerySearchComponentParamSubParams: TQuerySearchComponentParamSubParams
  inherited Label1: TLabel
    Width = 231
    Caption = 'SearchComponentParamSubParams'
    ExplicitWidth = 231
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select cp.*'
      'from CategoryParams2 cp'
      'join ProductCategories PC ON cp.ProductCategoryId = PC.Id'
      
        'join ProductProductCategories PPC ON PC.Id = PPC.ProductCategory' +
        'Id'
      'join Products c on c.ParentProductId = ppc.ProductId'
      
        'where c.Id = :ProductID and cp.ParamSubParamId = :ParamSubParamI' +
        'd')
    ParamData = <
      item
        Name = 'PRODUCTID'
        ParamType = ptInput
      end
      item
        Name = 'PARAMSUBPARAMID'
        ParamType = ptInput
      end>
  end
end
