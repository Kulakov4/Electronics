inherited ComponentsSearchMasterDetail: TComponentsSearchMasterDetail
  inherited GridPanel1: TGridPanel
    ControlCollection = <
      item
        Column = 0
        Control = qComponentsSearch
        Row = 0
      end
      item
        Column = -1
        Row = 0
      end
      item
        Column = 1
        Control = qComponentsDetailsSearch
        Row = 0
      end>
    DesignSize = (
      294
      73)
    inline qComponentsSearch: TQueryComponentsSearch
      Left = 1
      Top = 1
      Width = 146
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 146
      ExplicitHeight = 71
    end
    inline qComponentsDetailsSearch: TQueryComponentsDetailsSearch
      Left = 157
      Top = 1
      Width = 125
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 157
      ExplicitTop = 1
      ExplicitWidth = 125
      ExplicitHeight = 71
    end
  end
end
