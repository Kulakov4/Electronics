inherited QuerySubParameters2: TQuerySubParameters2
  Width = 220
  ExplicitWidth = 220
  inherited Label1: TLabel
    Width = 100
    Caption = 'SubParameters'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    UpdateOptions.AssignedValues = [uvRefreshMode]
    UpdateOptions.RefreshMode = rmAll
    SQL.Strings = (
      'select sp.*'
      '/* IFCHECKED '
      ', IFNULL(cp.id, 0) > 0 Checked'
      '/* ENDIF */'
      'from SubParameters sp'
      '/* IFCHECKED '
      
        'left join ParamSubParams psp on psp.IdSubParameter = sp.Id and p' +
        'sp.IdParameter = :IdParameter'
      
        'left join CategoryParams2 cp on cp.ParamSubParamId = psp.id and ' +
        'cp.ProductCategoryId = :ProductCategoryId'
      '/* ENDIF */'
      'where sp.IsDefault = 0'
      'and 0=0'
      'order by Name')
  end
end
