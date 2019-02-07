inherited QueryBodyTypesBase: TQueryBodyTypesBase
  Width = 326
  ExplicitWidth = 326
  inherited Label1: TLabel
    Width = 101
    Caption = 'BodyTypesBase'
    ExplicitWidth = 101
  end
  object fdqUnusedBodies: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'select b.*'
      'from Bodies b'
      'where not exists'
      '('
      '  Select 1 from BodyData bd'
      '  where bd.IDBody = b.id'
      ')')
    Left = 251
    Top = 25
  end
  object fdqUnusedBodyData: TFDQuery
    Connection = DMRepository.dbConnection
    SQL.Strings = (
      'select bd.*'
      'from BodyData bd'
      'where not exists'
      '('
      '    select 1'
      '    from BodyVariations2 bv'
      '    where bv.IDBodyData = bd.ID'
      ')')
    Left = 153
    Top = 25
  end
end
