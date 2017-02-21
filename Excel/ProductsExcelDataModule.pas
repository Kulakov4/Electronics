unit ProductsExcelDataModule;

interface

uses
  System.SysUtils, System.Classes, ExcelDataModule, Excel2010, Vcl.OleServer,
  CustomExcelTable, System.Generics.Collections, FieldInfoUnit, Data.DB;

type
  TProductsExcelTable = class(TCustomExcelTable)
  private
    function GetDescription: TField;
    function GetProducer: TField;
    function GetValue: TField;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce;
    property Description: TField read GetDescription;
    property Producer: TField read GetProducer;
    property Value: TField read GetValue;
  end;

  TProductsExcelDM = class(TExcelDM)
  private
    FFieldsInfo: TList<TFieldInfo>;
    function GetExcelTable: TProductsExcelTable;
    { Private declarations }
  protected
    function CreateExcelTable: TCustomExcelTable; override;
  public
    constructor Create(AOwner: TComponent; AFieldsInfo: TList<TFieldInfo>);
        reintroduce; overload;
    property ExcelTable: TProductsExcelTable read GetExcelTable;
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

function TProductsExcelDM.GetExcelTable: TProductsExcelTable;
begin
    Result := CustomExcelTable as TProductsExcelTable;
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

function TProductsExcelTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TProductsExcelTable.GetProducer: TField;
begin
  Result := FieldByName('Producer');
end;

function TProductsExcelTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

end.
