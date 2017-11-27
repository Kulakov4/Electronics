inherited frmAnalog: TfrmAnalog
  Caption = #1055#1086#1080#1089#1082' '#1073#1083#1080#1079#1082#1086#1075#1086' '#1072#1085#1072#1083#1086#1075#1072
  ClientHeight = 364
  ClientWidth = 743
  ExplicitWidth = 759
  ExplicitHeight = 403
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 297
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    inline ViewAnalog: TViewAnalog
      Left = 0
      Top = 0
      Width = 745
      Height = 297
      Align = alClient
      TabOrder = 0
      ExplicitTop = -101
      inherited cxPageControl: TcxPageControl
        Width = 745
        Height = 297
        ClientRectBottom = 293
        ClientRectRight = 741
      end
    end
  end
end
