inherited ComponentsSearchGroup: TComponentsSearchGroup
  Width = 526
  Height = 82
  ExplicitWidth = 526
  ExplicitHeight = 82
  inherited GridPanel1: TGridPanel
    Width = 526
    Height = 82
    ControlCollection = <
      item
        Column = 0
        Control = qFamilySearch
        Row = 0
      end
      item
        Column = -1
        Row = -1
      end
      item
        Column = -1
        Row = 0
      end
      item
        Column = 1
        Control = qComponentsSearch
        Row = 0
      end>
    ExplicitWidth = 526
    ExplicitHeight = 82
    inline qFamilySearch: TQueryFamilySearch
      Left = 1
      Top = 1
      Width = 262
      Height = 80
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 262
      ExplicitHeight = 80
    end
    inline qComponentsSearch: TQueryComponentsSearch
      Left = 263
      Top = 1
      Width = 262
      Height = 80
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 263
      ExplicitTop = 1
      ExplicitWidth = 262
      ExplicitHeight = 80
    end
  end
end
