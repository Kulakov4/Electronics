inherited ComponentsExMasterDetail: TComponentsExMasterDetail
  inherited GridPanel1: TGridPanel
    Left = 3
    ControlCollection = <
      item
        Column = 0
        Control = qComponentsEx
        Row = 0
      end
      item
        Column = 1
        Control = qComponentsDetailEx
        Row = 0
      end>
    ExplicitLeft = 3
    DesignSize = (
      294
      73)
    inline qComponentsEx: TQueryComponentsEx
      Left = 11
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 11
      ExplicitTop = 1
      ExplicitHeight = 71
      inherited FDQuery: TFDQuery
        CachedUpdates = True
      end
    end
    inline qComponentsDetailEx: TQueryComponentsDetailEx
      Left = 157
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 157
      ExplicitTop = 1
      ExplicitHeight = 71
      inherited FDQuery: TFDQuery
        CachedUpdates = True
      end
    end
  end
end
