unit BillContentExportForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  BillContentExportView;

type
  TFrmBillContentExport = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FViewBillContentExport: TViewBillContentExport;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property ViewBillContentExport: TViewBillContentExport
      read FViewBillContentExport;
    { Public declarations }
  end;

implementation

uses
  FormsHelper;

{$R *.dfm}

constructor TFrmBillContentExport.Create(AOwner: TComponent);
begin
  inherited;
  FViewBillContentExport := TViewBillContentExport.Create(Self);
  FViewBillContentExport.Align := alClient;
  FViewBillContentExport.Parent := Panel1;
  TFormsHelper.SetFont(Self);
end;

procedure TFrmBillContentExport.Button1Click(Sender: TObject);
begin
  ViewBillContentExport.Export('C:\Electronics DB\test.xls');
end;

procedure TFrmBillContentExport.FormShow(Sender: TObject);
begin
  ViewBillContentExport.MainView.ApplyBestFit;
end;

end.
