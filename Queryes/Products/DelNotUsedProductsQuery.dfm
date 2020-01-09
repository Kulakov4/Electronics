inherited QueryDelNotUsedProducts2: TQueryDelNotUsedProducts2
  inherited Label1: TLabel
    Width = 161
    Caption = 'DeleteNotUsedProducts2'
    ExplicitWidth = 161
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'delete'
      'from products2'
      'where '
      '  products2.IDproducer = :IDproducer'
      '  and not exists '
      '  ('
      
        '    select 1 from StorehouseProducts where productid = products2' +
        '.id'
      '  )')
    ParamData = <
      item
        Name = 'IDPRODUCER'
        ParamType = ptInput
      end>
  end
end
