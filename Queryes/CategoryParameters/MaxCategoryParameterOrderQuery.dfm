inherited QueryMaxCategoryParameterOrder: TQueryMaxCategoryParameterOrder
  inherited Label1: TLabel
    Width = 164
    Caption = 'MaxCategoryParamOrder'
    ExplicitWidth = 164
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select ifnull(max([Order]), 0) MaxOrder'
      'from CategoryParams')
  end
end
