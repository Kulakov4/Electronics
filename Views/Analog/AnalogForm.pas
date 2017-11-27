unit AnalogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, Vcl.ExtCtrls, AnalogView;

type
  TfrmAnalog = class(TfrmRoot)
    pnlMain: TPanel;
    ViewAnalog: TViewAnalog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
