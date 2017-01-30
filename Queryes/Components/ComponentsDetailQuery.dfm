inherited QueryComponentsDetail: TQueryComponentsDetail
  Width = 268
  ExplicitWidth = 268
  inherited Label1: TLabel
    Top = 3
    Width = 117
    Caption = 'ComponentsDetail'
    ExplicitTop = 3
    ExplicitWidth = 117
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
      '    pup2.ID AS IDPackagePins,'
      '    pup2.Value AS PackagePins,'
      '    '#39#39' Datasheet,'
      '    '#39#39' Diagram,'
      '    '#39#39' Drawing,'
      '    '#39#39' Image,'
      '    '#39#39' Description'
      'from Products p'
      
        'LEFT JOIN ProductUnionParameters pup2 ON pup2.ProductID = p.Id A' +
        'ND pup2.UnionParameterId = :PackagePinsParameterID'
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
        Name = 'PACKAGEPINSPARAMETERID'
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
