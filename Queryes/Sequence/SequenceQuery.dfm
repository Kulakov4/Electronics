inherited QuerySequence: TQuerySequence
  inherited Label1: TLabel
    Width = 63
    Caption = 'Sequence'
    ExplicitWidth = 63
  end
  inherited FDQuery: TFDQuery
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from sqlite_sequence'
      'where name=:name')
    ParamData = <
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO SQLITE_SEQUENCE'
      '(NAME, SEQ)'
      'VALUES (:NEW_NAME, :NEW_SEQ)')
    ModifySQL.Strings = (
      'UPDATE SQLITE_SEQUENCE'
      'SET SEQ = :NEW_SEQ'
      'WHERE NAME = :OLD_NAME;'
      'SELECT NAME, SEQ'
      'FROM SQLITE_SEQUENCE'
      'WHERE NAME = :OLD_NAME')
    DeleteSQL.Strings = (
      'DELETE FROM SQLITE_SEQUENCE'
      'WHERE NAME = :OLD_NAME')
    FetchRowSQL.Strings = (
      'SELECT NAME, SEQ'
      'FROM SQLITE_SEQUENCE'
      'WHERE NAME = :NAME')
    Left = 72
    Top = 25
  end
end
