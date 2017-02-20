unit ProductsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, System.Generics.Collections, FieldInfoUnit;

type
  TProductsExcelTable = class(TCustomExcelTable)
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    FFieldsInfo: TList<TFieldInfo>;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce; overload;
    { Public declarations }
  end;



implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

constructor TProductsExcelDM.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>);
begin
  Assert(AFieldsInfo <> nil);
  FFieldsInfo := AFieldsInfo;

  Create(AOwner);
end;

function TProductsExcelDM.CreateExcelTable: TCustomExcelTable;
begin
  Assert(FFieldsInfo <> nil);
  Result := TProductsExcelTable.Create(Self, FFieldsInfo);
end;

constructor TProductsExcelTable.Create(AOwner: TComponent; AFieldsInfo:
    TList<TFieldInfo>);
var
  AFieldInfo: TFieldInfo;
begin
  inherited Create(AOwner);
  for AFieldInfo in AFieldsInfo do
    FieldsInfo.Add(AFieldInfo);
end;

end.
