inherited QuerySearchComponentsByValues: TQuerySearchComponentsByValues
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    p.ID,'
      '    p.ParentProductId '
      'from'
      'Products p'
      'where instr('#39','#39'||:Value||'#39','#39', '#39','#39'||p.Value||'#39','#39') > 0'
      'order by p.ID')
    ParamData = <
      item
        Name = 'VALUE'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
