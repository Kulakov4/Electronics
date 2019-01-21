inherited QueryBodyKinds: TQueryBodyKinds
  Width = 263
  ExplicitWidth = 263
  inherited Label1: TLabel
    Width = 66
    Caption = 'BodyKinds'
    ExplicitWidth = 66
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'Ord'
      end>
    IndexName = 'idxOrder'
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select bk.*'
      'from BodyKinds bk'
      '/* ShowDuplicate'
      'join Bodies b on b.IDBodyKind = bk.id'
      'join BodyData bd on bd.IDBody = b.id'
      
        'join BodyVariations2 bv on bv.IDBodyData = bd.ID and bv.variatio' +
        'n in'
      '    ('
      '        select Variation'
      '        from BodyVariations2'
      '        where variation <> '#39#39
      '        group by Variation'
      '        having count(*) > 1    '
      '    )'
      'ShowDuplicate */    '
      'order by bk.Ord')
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO BODYKINDS'
      '(BODYKIND, ORD)'
      'VALUES (:NEW_BODYKIND, :NEW_ORD);'
      'SELECT ID, ORD'
      'FROM BODYKINDS'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE BODYKINDS'
      'SET BODYKIND = :NEW_BODYKIND, ORD = :NEW_ORD'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM BODYKINDS'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, BODYKIND, ORD'
      'FROM BODYKINDS'
      'WHERE ID = :ID')
    Left = 144
    Top = 24
  end
end
