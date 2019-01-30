unit SearchComponentCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchComponentCategory = class(TQueryBase)
    fdqBase: TFDQuery;
  private
    function GetProductCategoryID: TField;
    function GetProductID: TField;
    { Private declarations }
  public
    procedure AddNewValue(AIDComponent, AIDCategory: Integer);
    procedure DeleteAll;
    procedure LocateOrAddValue(AIDComponent, AIDCategory: Integer);
    function Search(AIDComponent, AIDCategory: Integer): Integer; overload;
    property ProductCategoryID: TField read GetProductCategoryID;
    property ProductID: TField read GetProductID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses StrHelper;

procedure TQuerySearchComponentCategory.AddNewValue(AIDComponent,
  AIDCategory: Integer);
begin
  Assert(AIDComponent > 0);
  Assert(AIDCategory > 0);

  FDQuery.Append;
  ProductID.AsInteger := AIDComponent;
  ProductCategoryID.AsInteger := AIDCategory;
  FDQuery.Post;
end;

procedure TQuerySearchComponentCategory.DeleteAll;
begin
  Assert(FDQuery.Active);

  while not FDQuery.Eof do
    FDQuery.Delete;
end;

function TQuerySearchComponentCategory.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQuerySearchComponentCategory.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

procedure TQuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
  AIDCategory: Integer);
begin
  if Search(AIDComponent, AIDCategory) = 0 then
    AddNewValue(AIDComponent, AIDCategory);
end;

function TQuerySearchComponentCategory.Search(AIDComponent,
  AIDCategory: Integer): Integer;
var
  ACondition: string;
begin
  Assert(AIDComponent > 0);
  Assert(AIDCategory > 0);

  ACondition := 'ppc.ProductID = :ProductID and ppc.ProductCategoryID = :ProductCategoryID';
  FDQuery.SQL.Text := fdqBase.SQL.Text.Replace('0=0', ACondition);
  SetParamType('ProductID');
  SetParamType('ProductCategoryID');


  Result := Search(['ProductID', 'ProductCategoryID'],
    [AIDComponent, AIDCategory]);
end;

end.
