unit CustomGridViewForm2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, Vcl.ExtCtrls, GridFrame,
  GridView, GridViewEx;

type
  TfrmCustomGridView2 = class(TfrmRoot)
    pnlMain: TPanel;
    ViewGridEx: TViewGridEx;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
