inherited QueryCategoryParameters2: TQueryCategoryParameters2
  inherited Label1: TLabel
    Width = 136
    Caption = 'CategoryParameters'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select cp.*, p.Value, p.TableName, p.ValueT, pt.ParameterType, s' +
        'p.Name, sp.Translation'
      'from CategoryParams2 cp'
      'join ParamSubParams psp on cp.ParamSubParamId = psp.id'
      'join Parameters p on psp.IdParameter = p.id'
      'join ParameterTypes pt on p.IDParameterType = pt.ID'
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
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
end
