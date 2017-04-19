inherited QuerySearchComponent: TQuerySearchComponent
  inherited Label1: TLabel
    Left = 3
    Top = 3
    Width = 118
    Caption = 'SearchComponent'
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 118
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
