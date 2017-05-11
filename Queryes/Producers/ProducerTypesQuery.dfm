inherited QueryProducerTypes: TQueryProducerTypes
  Width = 214
  ExplicitWidth = 214
  inherited Label1: TLabel
    Width = 97
    Caption = 'ProducerTypes'
    ExplicitWidth = 97
  end
  inherited FDQuery: TFDQuery
    Active = True
    UpdateObject = FDUpdateSQL
    SQL.Strings = (
      'select *'
      'from ProducerTypes'
      'order by Ord')
  end
  inherited DataSource: TDataSource
    Top = 25
  end
  object FDUpdateSQL: TFDUpdateSQL
    InsertSQL.Strings = (
      'INSERT INTO PRODUCERTYPES'
      '(PRODUCERTYPE, ORD)'
      'VALUES (:NEW_PRODUCERTYPE, :NEW_ORD);'
      'SELECT ID, ORD'
      'FROM PRODUCERTYPES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE PRODUCERTYPES'
      'SET PRODUCERTYPE = :NEW_PRODUCERTYPE, ORD = :NEW_ORD'
      'WHERE ID = :OLD_ID;')
    DeleteSQL.Strings = (
      'DELETE FROM PRODUCERTYPES'
      'WHERE ID = :OLD_ID')
    FetchRowSQL.Strings = (
      'SELECT ID, PRODUCERTYPE, ORD'
      'FROM PRODUCERTYPES'
      'WHERE ID = :ID')
    Left = 145
    Top = 25
  end
end
