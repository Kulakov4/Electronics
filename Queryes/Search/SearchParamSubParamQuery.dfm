inherited QuerySearchParamSubParam: TQuerySearchParamSubParam
  inherited Label1: TLabel
    Width = 151
    Caption = 'SearchParamSubParam'
    ExplicitWidth = 151
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select psp.*'
      '    , p.Value'
      '    , p.ValueT'
      '    , p.CodeLetters'
      '    , p.MeasuringUnit'
      '    , p.TableName'
      '    , p.Definition'
      '    , p.[Order]'
      '    , p.IDParameterType'
      '    , p.IDParameterKind'
      '    , sp.Name'
      '    , sp.Translation'
      '    , sp.IsDefault '
      '    , pt.ParameterType'
      'from ParamSubParams psp'
      'join Parameters p on psp.IdParameter = p.Id'
      'join ParameterTypes pt on p.IDParameterType = pt.ID'
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
      'where psp.Id = :ID')
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
