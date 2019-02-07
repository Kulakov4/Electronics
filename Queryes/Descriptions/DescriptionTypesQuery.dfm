inherited QueryDescriptionTypes: TQueryDescriptionTypes
  Width = 264
  Height = 79
  ExplicitWidth = 264
  ExplicitHeight = 79
  inherited Label1: TLabel
    Width = 111
    Caption = 'DescriptionTypes'
    ExplicitWidth = 111
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select dct.*'
      'from DescriptionComponentTypes dct'
      '/* ShowDuplicate'
      'where exists'
      '('
      '    select d.*'
      '    from descriptions2 d'
      '    where'
      '    d.IDComponentType = dct.ID'
      '    and d.ComponentName in'
      '    ('
      '        select ComponentName'
      '        from descriptions2 '
      '        group by ComponentName'
      '        having count(*) > 1'
      '    )'
      ')'
      'ShowDuplicate */'
      'order by dct.Ord')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO DESCRIPTIONCOMPONENTTYPES'
      '(COMPONENTTYPE, ORD)'
      'VALUES (:NEW_COMPONENTTYPE, :NEW_ORD);'
      'SELECT ID, ORD'
      'FROM DESCRIPTIONCOMPONENTTYPES'
      'WHERE ID = LAST_INSERT_AUTOGEN();')
    ModifySQL.Strings = (
      'UPDATE DESCRIPTIONCOMPONENTTYPES'
      'SET COMPONENTTYPE = :NEW_COMPONENTTYPE, ORD = :NEW_ORD'
      'WHERE ID = :OLD_ID')
    DeleteSQL.Strings = (
      'DELETE FROM DESCRIPTIONCOMPONENTTYPES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, COMPONENTTYPE, ORD'
      'FROM DESCRIPTIONCOMPONENTTYPES'
      'WHERE ID = :ID')
    Left = 144
    Top = 25
  end
end
