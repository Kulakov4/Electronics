unit SearchParametersForCategoryQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchParametersForCategory = class(TQueryBase)
    FDUpdateSQL: TFDUpdateSQL;
    FDQueryId: TFDAutoIncField;
    FDQueryProductCategoryId: TIntegerField;
    FDQueryParameterId: TIntegerField;
    FDQueryOrder: TIntegerField;
    FDQueryIsEnabled: TBooleanField;
    FDQueryIsAttribute: TBooleanField;
  private
    function GetParameterID: TField;
    { Private declarations }
  protected
  public
    function LocateByParameterID(AIDParameter: Integer; TestResult: Boolean =
        False): Boolean;
    function Search(AIDCategory: Integer): Integer; overload;
    function SearchAndProcess(AIDCategory: Integer): Integer;
    property ParameterID: TField read GetParameterID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

function TQuerySearchParametersForCategory.GetParameterID: TField;
begin
  Result := Field('ParameterID');
end;

function TQuerySearchParametersForCategory.LocateByParameterID(AIDParameter:
    Integer; TestResult: Boolean = False): Boolean;
begin
  Assert(AIDParameter > 0);
  Result := FDQuery.LocateEx(ParameterID.FieldName, AIDParameter);
  if TestResult then
    Assert(Result);
end;

function TQuerySearchParametersForCategory.Search(AIDCategory: Integer)
  : Integer;
begin
  Assert(AIDCategory > 0);

  Result := Search(['IDCategory'], [AIDCategory]);
end;

function TQuerySearchParametersForCategory.SearchAndProcess
  (AIDCategory: Integer): Integer;
var
  AOrder: Integer;
begin
  Result := Search(AIDCategory);

  // Смещаем порядок параметров в отрицательную область и делаем их скрытыми
  AOrder := 0;
  while not FDQuery.eof do
  begin
    Dec(AOrder);
    if (FDQueryOrder.AsInteger <> AOrder) or (FDQueryIsAttribute.AsBoolean) then
    begin
      FDQuery.Edit;
      FDQueryOrder.AsInteger := AOrder; // отриц область
      FDQueryIsAttribute.AsBoolean := false; // скрытый
      FDQuery.Post;
    end;
    FDQuery.Next;
  end;

end;

end.
