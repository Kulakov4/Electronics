inherited QueryProducerTypes: TQueryProducerTypes
  inherited Label1: TLabel
    Width = 97
    Caption = 'ProducerTypes'
    ExplicitWidth = 97
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ProducerTypes'
      'order by ProducerType')
  end
end
