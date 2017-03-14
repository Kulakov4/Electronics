inherited QueryProducers: TQueryProducers
  Width = 204
  Height = 78
  ExplicitWidth = 204
  ExplicitHeight = 78
  inherited Label1: TLabel
    Width = 66
    Caption = 'Producers'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select '
      '    pr.*, ifnull(t.cnt, 0) + ifnull(t2.cnt, 0) Cnt'
      'from Producers pr'
      'left join'
      '('
      '    select pv.Value, 0 + count(*) cnt'
      '    from products p'
      '    join products f on p.ParentProductId = f.Id'
      
        '    join ParameterValues pv on pv.ProductId = f.id and pv.Parame' +
        'terId = :ProducerParameterID'
      '    group by pv.Value'
      ') t on pr.name = t.Value'
      ''
      'left join'
      '('
      '    select pv.Value, count(*) cnt'
      '    from products f'
      
        '    join ParameterValues pv on pv.ProductId = f.id and pv.Parame' +
        'terId = :ProducerParameterID'
      '    where f.ParentProductId is null'
      '    and not exists '
      '    ('
      '        select p.* '
      '        from products p'
      '        where p.ParentProductId = f.id'
      '    )'
      '    group by pv.Value'
      ') t2 on pr.name = t.Value'
      'order by pr.Name')
    ParamData = <
      item
        Name = 'PRODUCERPARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object fdqDropUnused: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'delete from manufacturers2'
      'where id in'
      '('
      '    select m.id'
      '    from manufacturers2 m'
      '    where not exists'
      '    ('
      '        select *'
      '            from descriptions2'
      '            where IDManufacturer = m.id '
      '    )'
      ')')
    Left = 144
    Top = 24
  end
end
