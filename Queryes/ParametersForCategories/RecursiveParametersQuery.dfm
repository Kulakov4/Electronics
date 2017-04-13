inherited QueryRecursiveParameters: TQueryRecursiveParameters
  Width = 332
  ExplicitWidth = 332
  inherited Label1: TLabel
    Width = 140
    Caption = 'RecursiveParameters'
    ExplicitWidth = 140
  end
  object FDQueryDelete: TFDQuery
    SQL.Strings = (
      'DELETE FROM CATEGORYPARAMS'
      'WHERE ID in'
      '('
      
        '    with recursive m(ID, ProductCategoryID, ParameterID, [Order]' +
        ', IsEnabled, IsAttribute, PosID) '
      '    as '
      '    ('
      
        '        select cp.ID, cp.ProductCategoryID, cp.ParameterID, cp.[' +
        'Order], cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams cp on cp.ProductCategoryId = pc.' +
        'Id and cp.ParameterId = :PARAMETERID'
      '            where pc.id = :CATEGORYID'
      '            union all'
      
        '            select cp.ID, cp.ProductCategoryID, cp.ParameterID, ' +
        'cp.[Order], cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams cp on cp.ProductCategoryId = pc.' +
        'Id and cp.ParameterId = :PARAMETERID'
      '            join m on pc.parentid = m.ProductCategoryID'
      '    ) '
      '    select '
      '        id'
      '    from m'
      ')')
    Left = 88
    Top = 25
    ParamData = <
      item
        Name = 'PARAMETERID'
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
      'UPDATE CATEGORYPARAMS'
      'SET POSID = :NEW_POSID,'
      '    [ORDER] = :NEW_ORDER,'
      '    ISATTRIBUTE = :NEW_ISATTRIBUTE'
      'WHERE ID in'
      '('
      
        '    with recursive m(ID, ProductCategoryID, ParameterID, [Order]' +
        ', IsEnabled, IsAttribute, PosID) '
      '    as '
      '    ('
      
        '        select cp.ID, cp.ProductCategoryID, cp.ParameterID, cp.[' +
        'Order], cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams cp on cp.ProductCategoryId = pc.' +
        'Id and cp.ParameterId = :PARAMETERID'
      '            where pc.id = :CATEGORYID'
      '            union all'
      
        '            select cp.ID, cp.ProductCategoryID, cp.ParameterID, ' +
        'cp.[Order], cp.IsEnabled, cp.IsAttribute, cp.PosID'
      '            from ProductCategories pc'
      
        '            join CategoryParams cp on cp.ProductCategoryId = pc.' +
        'Id and cp.ParameterId = :PARAMETERID'
      '            join m on pc.parentid = m.ProductCategoryID'
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
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'PARAMETERID'
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
        DataType = ftBoolean
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDQueryInsert: TFDQuery
    SQL.Strings = (
      
        'insert into CategoryParams(ProductCategoryID, ParameterID, [Orde' +
        'r], IsEnabled, IsAttribute, PosID)'
      ''
      ''
      
        'with recursive m(ProductCategoryID, ParameterID, [Order], IsEnab' +
        'led, IsAttribute, PosID) '
      'as '
      '('
      
        '    select pc.ID ProductCategoryID, :ParameterID, :Order, 1, 1, ' +
        ':PosID'
      '    from ProductCategories pc'
      '    where pc.id = :CATEGORYID'
      '    union all'
      
        '    select pc.ID ProductCategoryID, :ParameterID, :Order, 1, 1, ' +
        ':PosID'
      '    from ProductCategories pc'
      '    join m on pc.parentid = m.ProductCategoryID'
      ') '
      'select '
      '*'
      'from m')
    Left = 258
    Top = 25
    ParamData = <
      item
        Name = 'PARAMETERID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'ORDER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'POSID'
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
end
