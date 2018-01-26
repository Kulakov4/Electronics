inherited QueryRecursiveParameters: TQueryRecursiveParameters
  Width = 316
  ExplicitWidth = 316
  inherited Label1: TLabel
    Width = 140
    Caption = 'RecursiveParameters'
    ExplicitWidth = 140
  end
  object FDQueryDelete: TFDQuery
    SQL.Strings = (
      'DELETE FROM CATEGORYPARAMS2'
      'WHERE ID in'
      '('
      
        '    with recursive m(ID, ProductCategoryID, ParamSubParamID, Ord' +
        ', IsEnabled, IsAttribute, PosID) '
      '    as '
      '    ('
      
        '        select cp.ID, cp.ProductCategoryID, cp.ParamSubParamID, ' +
        'cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      '            where pc.id = :CATEGORYID'
      '            union all'
      
        '            select cp.ID, cp.ProductCategoryID, cp.ParamSubParam' +
        'ID, cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      
        '            join m on pc.parentid = m.ProductCategoryID         ' +
        '   '
      '    ) '
      '    select '
      '        id'
      '    from m'
      ')   ')
    Left = 88
    Top = 25
    ParamData = <
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'CATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQueryUpdate: TFDQuery
    SQL.Strings = (
      'UPDATE CATEGORYPARAMS2'
      'SET POSID = :NEW_POSID,'
      '    [ORDER] = :NEW_ORDER,'
      '    ISATTRIBUTE = :NEW_ISATTRIBUTE'
      'WHERE ID in'
      '('
      
        '    with recursive m(ID, ProductCategoryID, ParamSubParamID, Ord' +
        ', IsEnabled, IsAttribute, PosID) '
      '    as '
      '    ('
      
        '        select cp.ID, cp.ProductCategoryID, cp.ParamSubParamID, ' +
        'cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      '            where pc.id = :CATEGORYID'
      '            union all'
      
        '            select cp.ID, cp.ProductCategoryID, cp.ParamSubParam' +
        'ID, cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      
        '            join m on pc.parentid = m.ProductCategoryID         ' +
        '   '
      '    ) '
      '    select '
      '        id'
      '    from m'
      ')'
      'and POSID = :OLD_POSID'
      'and [ORDER] = :OLD_ORDER'
      'and ISATTRIBUTE = :OLD_ISATTRIBUTE')
    Left = 176
    Top = 25
    ParamData = <
      item
        Name = 'NEW_POSID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NEW_ORDER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NEW_ISATTRIBUTE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARAMSUBPARAMID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'CATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OLD_POSID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OLD_ORDER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'OLD_ISATTRIBUTE'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQueryInsert: TFDQuery
    SQL.Strings = (
      
        'insert into CategoryParams2(ProductCategoryID, ParamSubParamID, ' +
        'Ord, IsEnabled, IsAttribute, PosID)'
      ''
      ''
      
        '    with recursive m(ID, ProductCategoryID, ParamSubParamID, Ord' +
        ', IsEnabled, IsAttribute, PosID) '
      '    as '
      '    ('
      
        '        select cp.ID, cp.ProductCategoryID, cp.ParamSubParamID, ' +
        'cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      '            where pc.id = :CATEGORYID'
      '            union all'
      
        '            select cp.ID, cp.ProductCategoryID, cp.ParamSubParam' +
        'ID, cp.Ord, cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams2 cp on cp.ProductCategoryId = pc' +
        '.Id and cp.ParamSubParamId = :ParamSubParamId'
      
        '            join m on pc.parentid = m.ProductCategoryID         ' +
        '   '
      '    )'
      'select '
      '*'
      'from m')
    Left = 258
    Top = 25
    ParamData = <
      item
        Name = 'PARAMSUBPARAMID'
        ParamType = ptInput
      end
      item
        Name = 'CATEGORYID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
