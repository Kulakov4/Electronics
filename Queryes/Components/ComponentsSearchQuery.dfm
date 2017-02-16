inherited QueryComponentsSearch: TQueryComponentsSearch
  inherited Label1: TLabel
    Width = 125
    Caption = 'ComponentsSearch'
    ExplicitWidth = 125
  end
  inherited FDQuery: TFDQuery
    CachedUpdates = True
    SQL.Strings = (
      'select '
      '  p.*,'
      '  '#39#39' Producer, '
      '  pup2.ID AS IDPackagePins,'
      '  pup2.Value AS PackagePins,'
      '  '#39#39' Datasheet,'
      '  '#39#39' Diagram,'
      '  '#39#39' Drawing,'
      '  '#39#39' Image,'
      '  '#39#39' Description'
      'from Products p'
      
        'LEFT JOIN ProductUnionParameters pup2 ON pup2.ProductID = p.Id A' +
        'ND pup2.UnionParameterId = :PackagePinsParameterID'
      'where p.ParentProductId in'
      '('
      '    select p.Id from'
      '    Products p'
      '    join ProductProductCategories ppc on p.Id = ppc.ProductId'
      
        '    join ProductProductCategories ppc2 on ppc2.ProductId = ppc.P' +
        'roductId'
      '    join ProductCategories pc on pc.Id = ppc2.ProductCategoryId'
      
        '    where instr('#39','#39'||:ParentIDList||'#39','#39' , '#39','#39'||p.Id||'#39','#39') > 0  a' +
        'nd ParentProductId is null'
      ')'
      'or instr('#39','#39'||:DetailIDList||'#39','#39' , '#39','#39'||p.Id||'#39','#39') > 0'
      'order by ParentProductId')
    ParamData = <
      item
        Name = 'PACKAGEPINSPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARENTIDLIST'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'DETAILIDLIST'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
