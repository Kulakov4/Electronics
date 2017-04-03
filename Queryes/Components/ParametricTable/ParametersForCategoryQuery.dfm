inherited QueryParametersForCategory: TQueryParametersForCategory
  inherited Label1: TLabel
    Width = 156
    Caption = 'ParametersForCategory'
    ExplicitWidth = 156
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'SELECT '
      
        '  t.ID, t.Value, t.ValueT, t.TableName, t.Definition, t.FieldTyp' +
        'e, t.ParentParameter, t.IsCustomParameter, t.Band, cp.IsAttribut' +
        'e, cp.PosID, cp."Order"'
      'FROM CategoryParams cp '
      'join'
      '('
      '    select up.*, '#39'X'#39' Band'
      '    from Parameters up'
      '    where up.ParentParameter is null'
      
        '    and not exists (select id from Parameters up2 where up2.Pare' +
        'ntParameter = up.id)'
      '    '
      '    union'
      '  '
      '    select up.*, parent_up.TableName Band'
      '    from Parameters up'
      
        '    join Parameters parent_up on up.ParentParameter = parent_up.' +
        'id'
      '    where up.ParentParameter is not null'
      '    '
      
        ') t on (t.Id = cp.ParameterId) or (t.ParentParameter = cp.Parame' +
        'terId)'
      
        'WHERE cp.ProductCategoryId = :ProductCategoryId and cp.IsEnabled' +
        ' = 1 '
      'order by cp.PosID, cp."Order", t.ParentParameter')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
