inherited QueryParametersForCategory: TQueryParametersForCategory
  Width = 150
  ExplicitWidth = 150
  inherited Label1: TLabel
    Width = 156
    Caption = 'ParametersForCategory'
    ExplicitWidth = 156
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    cp.*'
      '    , ifnull(cp."Order", pcp."Order") ord'
      '    , ifnull(p.TableName, p.Value) Caption'
      '    , ifnull(pp.TableName, pp.Value) ParentCaption  '
      '    , ifnull(pcp.id, cp.id) IDCategory'
      '    , ifnull(p.ValueT, pp.ValueT) Hint'
      '    , p.ParentParameter'
      '    , p.FieldType'
      'from CategoryParams cp'
      
        'join Parameters p on cp.ParameterId = p.id  and not exists (sele' +
        'ct id from Parameters dp where dp.ParentParameter = p.id)'
      'left join Parameters pp on p.ParentParameter = pp.id'
      
        'left join CategoryParams pcp on pcp.ProductCategoryId = cp.Produ' +
        'ctCategoryId and pcp.ParameterId = p.ParentParameter'
      
        'WHERE cp.ProductCategoryId = :ProductCategoryId and cp.IsEnabled' +
        ' = 1 '
      'order by cp.PosID, ord, cp.id')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
