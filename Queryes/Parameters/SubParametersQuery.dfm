inherited QuerySubParameters: TQuerySubParameters
  inherited Label1: TLabel
    Width = 100
    Caption = 'SubParameters'
    ExplicitWidth = 100
  end
  inherited FDQuery: TFDQuery
    Indexes = <
      item
        Active = True
        Selected = True
        Name = 'idxOrder'
        Fields = 'ParentParameter;Order'
      end>
    IndexName = 'idxOrder'
    SQL.Strings = (
      'select  *'
      'from Parameters'
      'where ParentParameter is not null'
      'order by ParentParameter, `Order`')
  end
end
