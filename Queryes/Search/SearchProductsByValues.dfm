inherited QuerySearchProductsByValues: TQuerySearchProductsByValues
  inherited Label1: TLabel
    Width = 162
    Caption = 'SearchProductsByValues'
    ExplicitWidth = 162
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select p.ID'
      'from Products2 p'
      'where instr('#39','#39'||:Value||'#39','#39', '#39','#39'||p.Value||'#39','#39') > 0')
    ParamData = <
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
