inherited QueryBodyTypesBranch: TQueryBodyTypesBranch
  inherited Label1: TLabel
    Width = 115
    Caption = 'BodyTypesBranch'
    ExplicitWidth = 115
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select *'
      'from BodyTypes bt'
      'where bt.IDParentBodyType = :IDParentBodyType'
      'order by BodyType')
    ParamData = <
      item
        Name = 'IDPARENTBODYTYPE'
        DataType = ftInteger
        ParamType = ptInput
        Value = 38
      end>
  end
end
