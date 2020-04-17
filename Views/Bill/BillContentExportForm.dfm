object FrmBillContentExport: TFrmBillContentExport
  Left = 0
  Top = 0
  Caption = 'FrmBillContentExport'
  ClientHeight = 312
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    635
    312)
  PixelsPerInch = 96
  TextHeight = 18
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 619
    Height = 272
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 1
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
end
