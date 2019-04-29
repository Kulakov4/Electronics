unit CustomGridViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, Vcl.ExtCtrls, GridFrame,
  GridView, GridViewEx;

type
  TfrmCustomGridView = class(TfrmRoot)
    pnlMain: TPanel;
  private
    FViewGridEx: TViewGridEx;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewGridEx: TViewGridEx read FViewGridEx;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TfrmCustomGridView.Create(AOwner: TComponent);
begin
  inherited;
  FViewGridEx := TViewGridEx.Create(Self);
  FViewGridEx.Place(pnlMain);
end;

end.
