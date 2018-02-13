inherited QueryComponents: TQueryComponents
  Width = 268
  ExplicitWidth = 268
  inherited Label1: TLabel
    Top = 3
    Width = 80
    Caption = 'Components'
    ExplicitTop = 3
    ExplicitWidth = 80
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'IndexParentProductId'
        Fields = 'ParentProductId'
      end>
    IndexName = 'IndexParentProductId'
    SQL.Strings = (
      'select '
      '    p.*, '
      '    '#39#39' Producer, '
      '    pv2.ID AS IDPackagePins,'
      '    pv2.Value AS PackagePins,'
      '    '#39#39' Datasheet,'
      '    '#39#39' Diagram,'
      '    '#39#39' Drawing,'
      '    '#39#39' Image,'
      '    '#39#39' DescriptionComponentName,'
      '    '#39#39' Description'
      'from Products p'
      
        'LEFT JOIN ParameterValues2 pv2 ON pv2.ProductID = p.Id AND pv2.P' +
        'aramSubParamId = :PackagePinsParamSubParamID'
      'where p.ParentProductId in'
      '('
      '    select p.id'
      '    from ProductProductCategories ppc'
      
        '    JOIN Products p ON ppc.ProductId = p.Id AND p.ParentProductI' +
        'd IS NULL'
      '    WHERE ppc.ProductCategoryId = :vProductCategoryId     '
      ')'
      'order by ParentProductId, Value')
    ParamData = <
      item
        Name = 'PACKAGEPINSPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'VPRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
