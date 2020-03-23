unit ProductsViewForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, ProductsView;

type
  TfrmProducts = class(TfrmRoot)
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDeactivate(Sender: TObject);
  private
    FViewProducts: TViewProducts;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewProducts: TViewProducts read FViewProducts;
    { Public declarations }
  end;

var
  frmProducts: TfrmProducts;

implementation

{$R *.dfm}

constructor TfrmProducts.Create(AOwner: TComponent);
begin
  inherited;
  FViewProducts := TViewProducts.Create(Self);
  FViewProducts.Parent := Self;
  FViewProducts.Align := alClient;
  FViewProducts.actFullScreen.Visible := False;
end;

procedure TfrmProducts.FormActivate(Sender: TObject);
begin
  inherited;
  ViewProducts.ConnectView;
  // Выводим в заголовок формы название текущего склада
  Caption := ViewProducts.ProductsModel.StorehouseListInt.StoreHouseTitle;
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
  ViewProducts.DisconnectView;
end;

end.
