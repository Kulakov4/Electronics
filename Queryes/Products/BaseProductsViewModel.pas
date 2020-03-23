unit BaseProductsViewModel;

interface

uses
  System.Classes, ProductsBaseQuery0, ProducersGroupUnit2, NotifyEvents,
  FireDAC.Comp.Client;

type
  TBaseProductsViewModel = class(TComponent)
  private
    FNotGroupClone: TFDMemTable;
    FqProductsBase0: TQryProductsBase0;

  class var
    FProducersGroup: TProducersGroup2;
  protected
    function CreateProductsQuery: TQryProductsBase0; virtual;
    function GetExportFileName: string; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ExportFileName: string read GetExportFileName;
    property NotGroupClone: TFDMemTable read FNotGroupClone;
    class property ProducersGroup: TProducersGroup2 read FProducersGroup;
    property qProductsBase0: TQryProductsBase0 read FqProductsBase0;
  end;

implementation

uses
  System.SysUtils;

constructor TBaseProductsViewModel.Create(AOwner: TComponent);
begin
  inherited;
  if FProducersGroup = nil then
  begin
    FProducersGroup := TProducersGroup2.Create(Self);
    FProducersGroup.ReOpen;
  end;

  FqProductsBase0 := CreateProductsQuery;

  FNotGroupClone := FqProductsBase0.BPW.AddClone
    (Format('%s = 0', [FqProductsBase0.BPW.IsGroup.FieldName]));
end;

destructor TBaseProductsViewModel.Destroy;
begin
  if FNotGroupClone <> nil then
    qProductsBase0.BPW.DropClone(FNotGroupClone);
  FNotGroupClone := nil;

  inherited;
end;

function TBaseProductsViewModel.CreateProductsQuery: TQryProductsBase0;
begin
  Result := TQryProductsBase0.Create(Self);
end;

function TBaseProductsViewModel.GetExportFileName: string;
begin
  Result := 'file.xls';
end;

end.
