inherited QuerySearchDaughterComponent: TQuerySearchDaughterComponent
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from Products'
      'where '
      'parentProductID is not null'
      'and Value = :ComponentName')
    ParamData = <
      item
        Name = 'COMPONENTNAME'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
  end
end
