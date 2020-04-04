inherited frmParameters: TfrmParameters
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  inherited Panel1: TPanel
    object cxPageControl: TcxPageControl
      Left = 1
      Top = 1
      Width = 788
      Height = 427
      Align = alClient
      TabOrder = 0
      Properties.ActivePage = cxtsParameters
      Properties.CustomButtons.Buttons = <>
      OnChange = cxPageControlChange
      OnPageChanging = cxPageControlPageChanging
      ExplicitLeft = 2
      ExplicitTop = 2
      ClientRectBottom = 423
      ClientRectLeft = 4
      ClientRectRight = 784
      ClientRectTop = 27
      object cxtsParameters: TcxTabSheet
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
        ImageIndex = 0
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
      object cxtsSubParameters: TcxTabSheet
        Caption = #1055#1086#1076#1087#1072#1088#1072#1084#1077#1090#1088#1099
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
      end
    end
  end
end
