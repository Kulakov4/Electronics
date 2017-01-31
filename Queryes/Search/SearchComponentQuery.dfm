inherited QuerySearchComponent: TQuerySearchComponent
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.*'
      'from Products p'
      'where upper(p.Value) = upper(:vValue)')
    ParamData = <
      item
        Name = 'VVALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
