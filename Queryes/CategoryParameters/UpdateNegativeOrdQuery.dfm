inherited QueryUpdNegativeOrd: TQueryUpdNegativeOrd
  inherited Label1: TLabel
    Width = 104
    Caption = 'UpdNegativeOrd'
    ExplicitWidth = 104
  end
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'update CategoryParams2'
      'set ord = -ord'
      'where ord < 0')
  end
end
