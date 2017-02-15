inherited QuerySearchDaughterComponent: TQuerySearchDaughterComponent
  inherited Label1: TLabel
    Width = 179
    Caption = 'SearchDaughterComponent'
    ExplicitWidth = 179
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select dp.*, pup.Value Producer'
      'from Products dp'
      'join Products p on dp.ParentProductId = p.id'
      
        'join ProductUnionParameters pup on pup.ProductID = p.Id and pup.' +
        'UnionParameterId = :ProducerParameterID'
      'where '
      'dp.Value = :ComponentName')
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
