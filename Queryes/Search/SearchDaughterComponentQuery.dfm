inherited QuerySearchDaughterComponent: TQuerySearchDaughterComponent
  inherited Label1: TLabel
    Width = 179
    Caption = 'SearchDaughterComponent'
    ExplicitWidth = 179
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select p.*, pv.Value Producer'
      'from Products p'
      'join Products f on p.ParentProductId = f.id'
      
        'join ParameterValues pv on pv.ProductID = f.Id and pv.ParameterI' +
        'd = :ProducerParameterID'
      'where '
      'p.Value = :ComponentName')
    ParamData = <
      item
        Name = 'PRODUCERPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'COMPONENTNAME'
        DataType = ftString
        ParamType = ptInput
        Value = ''
      end>
  end
end
