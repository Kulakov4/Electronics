inherited QueryBodyKinds: TQueryBodyKinds
  Width = 203
  ExplicitWidth = 203
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
      'select *'
      'from BodyKinds'
      'order by Ord')
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
