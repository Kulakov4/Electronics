inherited QueryProducers: TQueryProducers
  Width = 127
  Height = 78
  ExplicitWidth = 127
  ExplicitHeight = 78
  inherited Label1: TLabel
    Width = 66
    Caption = 'Producers'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    OnDeleteError = FDQueryDeleteError
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'ProducerTypeID;Name'
      end>
    IndexName = 'idxOrder'
    SQL.Strings = (
      'select'
      '    pr.*, ifnull(t.cnt, 0) + ifnull(t2.cnt, 0) Cnt'
      'from Producers pr'
      'left join'
      '('
      '    select pv.Value, 0 + count(*) cnt'
      '    from products p'
      '    join products f on p.ParentProductId = f.Id'
      
        '    join ParameterValues2 pv on pv.ProductId = f.id and pv.Param' +
        'SubParamId = :ProducerParamSubParamID'
      '    group by pv.Value'
      ') t on pr.name = t.Value'
      ''
      'left join'
      '('
      '    select pv.Value, count(*) cnt'
      '    from products f'
      
        '    join ParameterValues2 pv on pv.ProductId = f.id and pv.Param' +
        'SubParamId = :ProducerParamSubParamID'
      '    where f.ParentProductId is null'
      '    and not exists '
      '    ('
      '        select p.* '
      '        from products p'
      '        where p.ParentProductId = f.id'
      '    )'
      '    group by pv.Value'
      ') t2 on pr.name = t2.Value'
      'order by pr.ProducerTypeID, pr.Name')
    ParamData = <
      item
        Name = 'PRODUCERPARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
