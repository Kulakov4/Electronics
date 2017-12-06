inherited qSearchProductByParamValues: TqSearchProductByParamValues
  inherited Label1: TLabel
    Width = 196
    Caption = 'SearchProductByParamValues'
    ExplicitWidth = 196
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct p.id ProductId, pp.id FamilyID'
      'from Products p'
      'join Products pp on p.ParentProductId = pp.Id'
      
        'join ProductProductCategories ppc on ppc.ProductId = pp.Id and p' +
        'pc.ProductCategoryId = :ProductCategoryId'
      
        'left join ParameterValues pv on pv.ProductId = p.id and pv.Param' +
        'eterId = (0)'
      
        'left join ParameterValues pvcategory on pvcategory.ProductId = p' +
        'p.id and pvcategory.ParameterId = (1)'
      'where p.ParentProductID is not null '
      
        'and cast(ifnull(pv.Value, pvcategory.Value) as VARCHAR(255)) in ' +
        '(2)')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
