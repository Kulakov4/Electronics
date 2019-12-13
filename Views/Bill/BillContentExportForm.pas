unit BillContentExportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BillContentExportView;

type
  TFrmBillContentExport = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
  private
    FViewBillContentExport: TViewBillContentExport;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewBillContentExport: TViewBillContentExport read
        FViewBillContentExport;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TFrmBillContentExport.Create(AOwner: TComponent);
begin
  inherited;
  FViewBillContentExport := TViewBillContentExport.Create(Self);
  FViewBillContentExport.Align := alClient;
  FViewBillContentExport.Parent := Panel1;
end;

end.
