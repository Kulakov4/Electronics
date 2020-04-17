object frmGridView: TfrmGridView
  Left = 0
  Top = 0
  Caption = 'frmGridView'
  ClientHeight = 370
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  DesignSize = (
    708
    370)
  PixelsPerInch = 96
  TextHeight = 18
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 706
    Height = 326
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
  end
  object cxbtnOK: TcxButton
    Left = 475
    Top = 332
    Width = 110
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
  end
  object cxbtnCancel: TcxButton
    Left = 592
    Top = 332
    Width = 110
    Height = 30
    Anchors = [akRight, akBottom]
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
