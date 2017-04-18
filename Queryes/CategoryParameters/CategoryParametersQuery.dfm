inherited QueryCategoryParameters: TQueryCategoryParameters
  Width = 277
  ExplicitWidth = 277
  inherited Label1: TLabel
    Width = 136
    Caption = 'CategoryParameters'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    CachedUpdates = True
    SQL.Strings = (
      'select cp.*, p.Value, p.TableName, p.ValueT, pt.ParameterType'
      'from CategoryParams cp'
      'join Parameters p on cp.ParameterId = p.Id'
      'join ParameterTypes pt on p.IDParameterType = pt.ID'
      'where ProductCategoryID = :ProductCategoryID'
      '--and')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  inherited DataSource: TDataSource
    Top = 25
  end
  object fdqDeleteSubParameters: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'delete from CategoryParams'
      'where id in'
      '('
      '    select cp.id'
      '    from CategoryParams cp'
      '    join Parameters p on cp.ParameterId = p.id'
      '    join Parameters pp on p.ParentParameter = pp.Id'
      '    where not exists '
      '    ('
      
        '        select cp2.id from CategoryParams cp2 where cp2.Paramete' +
        'rId = pp.id'
      '    )'
      ')')
    Left = 184
    Top = 25
  end
end
