inherited QueryBaseEvents: TQueryBaseEvents
  inherited FDQuery: TFDQuery
    BeforeInsert = FDQueryBeforeInsert
    BeforeEdit = FDQueryBeforeEdit
    BeforePost = FDQueryBeforePost
    BeforeDelete = FDQueryBeforeDelete
    BeforeScroll = FDQueryBeforeScroll
  end
end
