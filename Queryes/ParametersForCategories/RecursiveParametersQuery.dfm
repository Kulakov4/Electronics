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
    Top = 24
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
      '    [ORDER] = :NEW_ORDER'
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
      'and [ORDER] = :OLD_ORDER')
    Left = 176
    Top = 24
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
      end>
  end
end
