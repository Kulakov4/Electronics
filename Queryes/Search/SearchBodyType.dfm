inherited QuerySearchBodyType: TQuerySearchBodyType
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BodyTypes'
      'where upper(BodyType) = upper(:BodyType)')
    ParamData = <
      item
        Name = 'BODYTYPE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
