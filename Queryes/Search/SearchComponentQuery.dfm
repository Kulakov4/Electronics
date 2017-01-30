inherited QuerySearchComponent: TQuerySearchComponent
  inherited LabelSearch: TLabel
    Width = 88
    Caption = 'SearchComponent'
    ExplicitWidth = 88
  end
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
