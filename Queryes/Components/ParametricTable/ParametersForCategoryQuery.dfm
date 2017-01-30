inherited QueryParametersForCategory: TQueryParametersForCategory
  inherited Label1: TLabel
    Width = 156
    Caption = 'ParametersForCategory'
    ExplicitWidth = 156
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'SELECT '
      
        '  t.ID, t.Value, t.ValueT, t.TableName, t.Definition, t."Order",' +
        ' t.FieldType, t.ParentParameter, t.IsCustomParameter, t.Band, up' +
        'fc.IsAttribute'
      'FROM UnionParameterForCategories upfc '
      'join'
      '('
      '    select up.*, '#39'X'#39' Band'
      '    from unionParameters up'
      '    where up.ParentParameter is null'
      
        '    and not exists (select id from unionParameters up2 where up2' +
        '.ParentParameter = up.id)'
      '    '
      '    union'
      '  '
      '    select up.*, parent_up.TableName Band'
      '    from unionParameters up'
      
        '    join unionParameters parent_up on up.ParentParameter = paren' +
        't_up.id'
      '    where up.ParentParameter is not null'
      '    '
      
        ') t on (t.Id = upfc.UnionParameterId) or (t.ParentParameter = up' +
        'fc.UnionParameterId)'
      
        'WHERE upfc.ProductCategoryId = :ProductCategoryId and upfc.IsEna' +
        'bled = 1 '
      'order by upfc."Order", t.ParentParameter')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
