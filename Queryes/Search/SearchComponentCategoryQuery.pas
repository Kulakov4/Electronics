unit SearchComponentCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchComponentCategoryW = class(TDSWrap)
  private
    FExternalID: TParamWrap;
    FProductCategoryID: TFieldWrap;
    FProductID: TFieldWrap;
    procedure AddNewValue(AIDComponent, AIDCategory: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TParamWrap read FExternalID;
    property ProductCategoryID: TFieldWrap read FProductCategoryID;
    property ProductID: TFieldWrap read FProductID;
  end;

  TQuerySearchComponentCategory = class(TQueryBase)
  private
    FW: TSearchComponentCategoryW;
    function Search(AIDComponent, AIDCategory: Integer): Integer; overload;
    function Search(AIDComponent: Integer; const ASubGroup: String)
      : Integer; overload;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAddValue(AIDComponent, AIDCategory: Integer);
    procedure SearchAndDelete(AIDComponent: Integer; const ASubGroup: String);
    property W: TSearchComponentCategoryW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

constructor TQuerySearchComponentCategory.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchComponentCategoryW.Create(FDQuery);
end;

function TQuerySearchComponentCategory.Search(AIDComponent: Integer;
  const ASubGroup: String): Integer;
var
  ASQL: string;
begin
  Assert(AIDComponent > 0);

  // Добавляем соединение таблиц
  ASQL := SQL;
  ASQL := ASQL.Replace('/* productCategories', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('productCategories */', '', [rfReplaceAll]);

  // Добавляем условие
  ASQL := ReplaceInSQL(ASQL, Format('%s = :%s', [W.ProductID.FullName,
    W.ProductID.FieldName]), 0);

  // Добавляем условие
  FDQuery.SQL.Text := ReplaceInSQL(ASQL,
    Format('instr('',''||:%s||'','', '',''||%s||'','') = 0',
    [W.ExternalID.FieldName, W.ExternalID.FullName]), 1);

  SetParamType(W.ProductID.FieldName);
  SetParamType(W.ExternalID.FieldName, ptInput, ftWideString);

  Result := Search([W.ProductID.FieldName, W.ExternalID.FieldName],
    [AIDComponent, ASubGroup]);
end;

procedure TQuerySearchComponentCategory.SearchAndDelete(AIDComponent: Integer;
  const ASubGroup: String);
begin
  if Search(AIDComponent, ASubGroup) > 0 then
    DeleteAll;
end;

procedure TQuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
  AIDCategory: Integer);
begin
  if Search(AIDComponent, AIDCategory) = 0 then
    W.AddNewValue(AIDComponent, AIDCategory);
end;

function TQuerySearchComponentCategory.Search(AIDComponent,
  AIDCategory: Integer): Integer;
begin
  Assert(AIDComponent > 0);
  Assert(AIDCategory > 0);

  Result := SearchEx([TParamRec.Create(W.ProductID.FullName, AIDComponent),
    TParamRec.Create(W.ProductCategoryID.FullName, AIDCategory)]);
end;

constructor TSearchComponentCategoryW.Create(AOwner: TComponent);
begin
  inherited;
  FProductCategoryID := TFieldWrap.Create(Self, 'ppc.ProductCategoryID');
  FProductID := TFieldWrap.Create(Self, 'ppc.ProductID');

  FExternalID := TParamWrap.Create(Self, 'pc.externalID');
end;

procedure TSearchComponentCategoryW.AddNewValue(AIDComponent,
  AIDCategory: Integer);
begin
  Assert(AIDComponent > 0);
  Assert(AIDCategory > 0);

  TryAppend;
  ProductID.F.AsInteger := AIDComponent;
  ProductCategoryID.F.AsInteger := AIDCategory;
  TryPost;
end;

end.
