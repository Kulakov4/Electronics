inherited QueryBaseEvents: TQueryBaseEvents
  inherited FDQuery: TFDQuery
    BeforeClose = FDQueryBeforeClose
    BeforeInsert = FDQueryBeforeInsert
    BeforeEdit = FDQueryBeforeEdit
    AfterEdit = FDQueryAfterEdit
    BeforePost = FDQueryBeforePost
    AfterPost = FDQueryAfterPost
    AfterCancel = FDQueryAfterCancel
    BeforeDelete = FDQueryBeforeDelete
    AfterDelete = FDQueryAfterDelete
    BeforeScroll = FDQueryBeforeScroll
    AfterScroll = FDQueryAfterScroll
  end
end
