unit BillContentExportQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TBillContentExportW = class(TDSWrap)
  private
    FBillTitle: TFieldWrap;
    FID: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property BillTitle: TFieldWrap read FBillTitle;
    property ID: TFieldWrap read FID;
    property Value: TFieldWrap read FValue;
  end;

  TQryBillContentExport = class(TQueryBase)
  private
    FW: TBillContentExportW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property W: TBillContentExportW read FW;
    { Public declarations }
  end;
implementation

constructor TBillContentExportW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', 'ID', True);
  FBillTitle := TFieldWrap.Create(Self, 'BillTitle', 'Счёт');
  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');
end;

constructor TQryBillContentExport.Create(AOwner: TComponent);
begin
  inherited;
  FW := TBillContentExportW.Create(FDQuery);
end;

{$R *.dfm}

end.
