inherited QueryBaseEvents: TQueryBaseEvents
  inherited FDQuery: TFDQuery
    BeforeOpen = FDQueryBeforeOpen
    AfterOpen = FDQueryAfterOpen
    AfterClose = FDQueryAfterClose
    BeforeInsert = FDQueryBeforeInsert
    AfterInsert = FDQueryAfterInsert
    BeforeEdit = FDQueryBeforeEdit
    AfterEdit = FDQueryAfterEdit
    BeforePost = FDQueryBeforePost
    AfterPost = FDQueryAfterPost
    BeforeDelete = FDQueryBeforeDelete
    AfterDelete = FDQueryAfterDelete
    BeforeScroll = FDQueryBeforeScroll
    AfterScroll = FDQueryAfterScroll
  end
end
