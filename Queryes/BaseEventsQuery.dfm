inherited QueryBaseEvents: TQueryBaseEvents
  inherited FDQuery: TFDQuery
    AfterOpen = FDQueryAfterOpen
    BeforeClose = FDQueryBeforeClose
    AfterClose = FDQueryAfterClose
    BeforeInsert = FDQueryBeforeInsert
    AfterInsert = FDQueryAfterInsert
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
