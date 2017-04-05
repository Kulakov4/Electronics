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
      '    select p.*, '#39'X'#39' Band'
      '    from Parameters p'
      '    where p.ParentParameter is null'
      
        '    and not exists (select id from Parameters dp where dp.Parent' +
        'Parameter = p.id)'
      '    '
      '    union'
      '  '
      '    select p.*, pp.TableName Band'
      '    from Parameters p'
      '    join Parameters pp on p.ParentParameter = pp.id'
      '    where p.ParentParameter is not null'
      '    '
      ') t on (t.Id = cp.ParameterId)'
      
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
