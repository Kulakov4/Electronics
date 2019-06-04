inherited QryBodyKindsColor: TQryBodyKindsColor
  inherited FDQuery: TFDQuery
    SQL.Strings = (
      'select distinct Color'
      'from BodyKinds'
      'where Color is not null')
  end
end
