inherited QuerySearchParameterValues: TQuerySearchParameterValues
  inherited Label1: TLabel
    Width = 157
    Caption = 'SearchParameterValues'
    ExplicitWidth = 157
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct Value'
      'from ParameterValues pv '
      'where pv.ParameterId = :ParameterId'
      'order by Value')
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 0
      end>
  end
end
