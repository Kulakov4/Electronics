inherited QueryCategoryParameters2: TQueryCategoryParameters2
  inherited Label1: TLabel
    Width = 136
    Caption = 'CategoryParameters'
    ExplicitWidth = 136
  end
  inherited FDQuery: TFDQuery
    CachedUpdates = True
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrd'
        Fields = 'PosID;Ord'
      end>
    IndexName = 'idxOrd'
    SQL.Strings = (
      
        'select cp.*, psp.IdParameter, psp.IdSubParameter, p.Value, p.Tab' +
        'leName, p.ValueT, pt.ParameterType, sp.Name, sp.Translation, sp.' +
        'IsDefault'
      'from CategoryParams2 cp'
      'join ParamSubParams psp on cp.ParamSubParamId = psp.id'
      'join Parameters p on psp.IdParameter = p.id'
      'join ParameterTypes pt on p.IDParameterType = pt.ID'
      'join SubParameters sp on psp.IdSubParameter = sp.Id'
      'where ProductCategoryID = :ProductCategoryID'
      '--and'
      'order by cp.PosID, cp.Ord')
    ParamData = <
      item
        Name = 'PRODUCTCATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
