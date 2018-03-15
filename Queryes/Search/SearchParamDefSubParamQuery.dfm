inherited QuerySearchParamDefSubParam: TQuerySearchParamDefSubParam
  inherited Label1: TLabel
    Width = 173
    Caption = 'SearchParamDefSubParam'
    ExplicitWidth = 173
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      
        'select p.*, pt.ParameterType, t.ID ParamSubParamID, t.IdSubParam' +
        'eter, t.Name, t.Translation, t.IsDefault'
      'from Parameters p'
      'LEFT JOIN '
      '('
      
        '    select psp.ID, psp.IdParameter, psp.IdSubParameter, sp.Name,' +
        ' sp.Translation, sp.IsDefault'
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
