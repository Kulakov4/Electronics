unit ProductsViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, ProductsView2;

type
  TfrmProducts = class(TfrmRoot)
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
  private
    FViewProducts2: TViewProducts2;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewProducts2: TViewProducts2 read FViewProducts2;
    { Public declarations }
  end;

var
  frmProducts: TfrmProducts;

implementation

{$R *.dfm}

constructor TfrmProducts.Create(AOwner: TComponent);
begin
  inherited;
  FViewProducts2 := TViewProducts2.Create(Self);
  FViewProducts2.Parent := Self;
  FViewProducts2.Align := alClient;
  FViewProducts2.actFullScreen.Visible := False;
end;

procedure TfrmProducts.FormActivate(Sender: TObject);
begin
  inherited;
  ViewProducts2.DataSource.Enabled := True;
end;

procedure TfrmProducts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  frmProducts := nil;
end;

procedure TfrmProducts.FormDeactivate(Sender: TObject);
begin
  inherited;
  ViewProducts2.DataSource.Enabled := False;
end;

end.
