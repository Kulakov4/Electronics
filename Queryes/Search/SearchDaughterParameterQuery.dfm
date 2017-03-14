inherited QuerySearchDaughterParameter: TQuerySearchDaughterParameter
  inherited Label1: TLabel
    Width = 175
    Caption = 'SearchDaughterParameter'
    ExplicitWidth = 175
  end
  inherited FDQuery: TFDQuery
    AfterOpen = FDQueryAfterOpen
    SQL.Strings = (
      'select *'
      'from Parameters'
      'where upper(Value) = upper(:Value)'
      'and ParentParameter = :ParentParameter')
    ParamData = <
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARENTPARAMETER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
