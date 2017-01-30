inherited QuerySearchDetailComponent: TQuerySearchDetailComponent
  inherited LabelSearch: TLabel
    Width = 115
    Caption = 'SearchDetailComponent'
    ExplicitWidth = 115
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from Products'
      'where ParentProductID = :ParentProductID'
      'and upper(value) = upper(:value)')
    ParamData = <
      item
        Name = 'PARENTPRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
