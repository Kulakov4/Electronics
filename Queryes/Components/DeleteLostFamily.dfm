inherited QueryDeleteLostFamily: TQueryDeleteLostFamily
  inherited Label1: TLabel
    Width = 109
    Caption = 'DeleteLostFamily'
    ExplicitWidth = 109
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'delete from Products'
      'where id in'
      '('
      '    select f.Id'
      '    from products f'
      '    where '
      '        f.ParentProductId is null'
      '        and'
      '        not exists'
      '        ('
      '            select *'
      '            from ProductProductCategories ppc'
      '            where ppc.ProductId = f.id'
      '        )'
      ')')
  end
end
