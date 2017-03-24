inherited QueryRecursiveTree: TQueryRecursiveTree
  Width = 205
  Height = 77
  ExplicitWidth = 205
  ExplicitHeight = 77
  inherited Label1: TLabel
    Width = 93
    Caption = 'RecursiveTree'
    ExplicitWidth = 93
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'with recursive m(Depth, Path, ID, Value, ParentID, ExternalID) '
      'as '
      '('
      '    select 1, value path, id, value, parentid, externalid'
      '    from ProductCategories '
      '    where parentid is null'
      '    union all'
      
        '    select depth + 1, path || '#39'-'#39' || c.value, c.id, c.value, c.p' +
        'arentid, c.externalid'
      '    from ProductCategories c'
      '    join m on c.parentid = m.id'
      ') '
      'select '
      
        '  m.ID, m.ParentID, m.ExternalID, m.Value, m2.ExternalId as Pare' +
        'ntExternalID, 0 "Deleted", 0 "Added" -- , m.depth - 1 "'#1059#1088#1086#1074#1077#1085#1100'",' +
        ' m.Path "'#1055#1091#1090#1100'"'
      'from m'
      'left join m m2 on m.parentid = m2.id and m.parentid <> m.id'
      'order by m.depth, m.externalid')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PRODUCTCATEGORIES'
      '(VALUE, PARENTID, EXTERNALID)'
      'VALUES (:NEW_VALUE, :NEW_PARENTID, :NEW_EXTERNALID);'
      'SELECT ID, VALUE, PARENTID, EXTERNALID'
      'FROM PRODUCTCATEGORIES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE PRODUCTCATEGORIES'
      
        'SET VALUE = :NEW_VALUE, PARENTID = :NEW_PARENTID, EXTERNALID = :' +
        'NEW_EXTERNALID'
      'WHERE ID = :OLD_ID;'
      'SELECT ID, VALUE, PARENTID, EXTERNALID'
      'FROM PRODUCTCATEGORIES'
      'WHERE ID = :NEW_ID')
    DeleteSQL.Strings = (
      'DELETE FROM PRODUCTCATEGORIES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, VALUE, PARENTID, EXTERNALID'
      'FROM PRODUCTCATEGORIES'
      'WHERE ID = :ID')
    Left = 144
    Top = 24
  end
end
