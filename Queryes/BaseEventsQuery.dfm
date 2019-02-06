inherited QueryBaseEvents: TQueryBaseEvents
  inherited FDQuery: TFDQuery
    BeforeInsert = FDQueryBeforeInsert
    BeforeEdit = FDQueryBeforeEdit
    BeforePost = FDQueryBeforePost
    BeforeScroll = FDQueryBeforeScroll
  end
end
