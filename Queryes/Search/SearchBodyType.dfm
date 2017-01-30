inherited QuerySearchBodyType: TQuerySearchBodyType
  inherited LabelSearch: TLabel
    Width = 81
    Caption = 'SearchBodyType'
    ExplicitWidth = 81
  end
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
