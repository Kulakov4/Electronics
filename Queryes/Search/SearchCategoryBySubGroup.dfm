inherited QuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup
  inherited Label1: TLabel
    Width = 183
    Caption = 'SearchCategoryBySubGroup'
    ExplicitWidth = 183
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from ProductCategories'
      'where instr('#39','#39'||:subgroup||'#39','#39', '#39','#39'||externalID||'#39','#39') > 0')
    ParamData = <
      item
        Name = 'SUBGROUP'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
