inherited QuerySearchComponentCategory2: TQuerySearchComponentCategory2
  inherited Label1: TLabel
    Width = 186
    Caption = 'SearchComponentCategory2'
    ExplicitWidth = 186
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ppc.*'
      'from ProductProductCategories ppc'
      'join productCategories pc on ppc.ProductCategoryId = pc.id'
      
        'where ppc.ProductID = :ProductID and instr('#39','#39'||:SubGroup||'#39','#39', ' +
        #39','#39'||pc.externalID||'#39','#39') = 0')
    ParamData = <
      item
        Name = 'PRODUCTID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'SUBGROUP'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
