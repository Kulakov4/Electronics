inherited frmQuerySubGroups: TfrmQuerySubGroups
  inherited Label1: TLabel
    Width = 69
    Caption = 'SubGroups'
    ExplicitWidth = 69
  end
  inherited FDQuery: TFDQuery
    CachedUpdates = True
    SQL.Strings = (
      'select pc.*, case when 0=0 then 1 else 0 end IsMain'
      'from ProductCategories pc'
      'where 1=1 '
      'order by IsMain desc, pc.ExternalId')
  end
end
