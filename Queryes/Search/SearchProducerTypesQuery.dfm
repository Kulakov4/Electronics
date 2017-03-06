inherited QuerySearchProducerTypes: TQuerySearchProducerTypes
  inherited Label1: TLabel
    Width = 142
    Caption = 'SearchProducerTypes'
    ExplicitWidth = 142
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct ProducerType'
      'from Producers'
      'where ProducerType is not null'
      'order by 1')
  end
end
