inherited QuerySearchParameterSubParameter: TQuerySearchParameterSubParameter
  inherited Label1: TLabel
    Width = 207
    Caption = 'SearchParameterSubParameter'
    ExplicitWidth = 207
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select p.*, pt.ParameterType, t.ID ParamSubParamID, t.Name, t.Tr' +
        'anslation, t.IsDefault'
      'from Parameters p'
      'LEFT JOIN '
      '('
      
        '    select psp.ID, psp.IdParameter, sp.Name, sp.Translation, sp.' +
        'IsDefault'
      '    from ParamSubParams psp'
      
        '    join SubParameters sp on psp.IdSubParameter = sp.Id and sp.I' +
        'sDefault = 1'
      ') t on t.IdParameter = p.Id'
      'join ParameterTypes pt on p.IDParameterType = pt.ID'
      'where p.Id = :ID')
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
