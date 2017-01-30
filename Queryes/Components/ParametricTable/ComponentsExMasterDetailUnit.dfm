inherited ComponentsExMasterDetail: TComponentsExMasterDetail
  Width = 529
  ExplicitWidth = 529
  inherited GridPanel1: TGridPanel
    Left = 0
    Top = 20
    Width = 513
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
    ExplicitLeft = 0
    ExplicitTop = 20
    ExplicitWidth = 513
    DesignSize = (
      513
      73)
    inline qComponentsEx: TQueryComponentsEx
      Left = 1
      Top = 1
      Width = 255
      Height = 71
      Anchors = []
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 255
      ExplicitHeight = 71
    end
    inline qComponentsDetailEx: TQueryComponentsDetailEx
      Left = 263
      Top = 1
      Width = 242
      Height = 71
      Anchors = []
      TabOrder = 1
      ExplicitLeft = 263
      ExplicitTop = 1
      ExplicitWidth = 242
      ExplicitHeight = 71
      inherited Label1: TLabel
        Left = 3
        Top = 5
        ExplicitLeft = 3
        ExplicitTop = 5
      end
    end
  end
end
