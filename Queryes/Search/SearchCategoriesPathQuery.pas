unit SearchCategoriesPathQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchCategoriesPath = class(TQueryBase)
  private
    function GetPath: TField;
    { Private declarations }
  public
    function GetFullPath(ACategoryID: Integer): string;
    function GetLastTreeNodes(ACategoryID: Integer; const ACount: Integer;
      ASplitter: string): string;
    function GetMinimizePath(ACategoryID: Integer; ACanvas: TCanvas;
      MaxLen: Integer): String;
    function Search(ACategoryID: Integer): Integer; overload;
    property Path: TField read GetPath;
    { Public declarations }
  end;

var
  QuerySearchCategoriesPath: TQuerySearchCategoriesPath;

implementation

{$R *.dfm}
{$WARN UNIT_PLATFORM OFF}

uses Vcl.FileCtrl;

function TQuerySearchCategoriesPath.GetFullPath(ACategoryID: Integer): string;
var
  rc: Integer;
begin
  rc := Search(ACategoryID);
  Assert(rc = 1);
  Result := Path.AsString;
end;

function TQuerySearchCategoriesPath.GetLastTreeNodes(ACategoryID: Integer;
  const ACount: Integer; ASplitter: string): string;
var
  h: Integer;
  I: Integer;
  k: Integer;
  m: TArray<String>;
begin
  Assert(ACount > 0);
  Result := GetFullPath(ACategoryID);
  m := Result.Split(['\']);
  Assert(Length(m) > 0);

  h := High(m);
  Result := m[h];
  Dec(h);
  k := 1;

  for I := h downto Low(m) do
  begin
    if k >= ACount then
      break;

    Result := m[I] + ASplitter + Result;
    Inc(k);
  end;
end;

function TQuerySearchCategoriesPath.GetMinimizePath(ACategoryID: Integer;
  ACanvas: TCanvas; MaxLen: Integer): String;
begin
  Result := GetFullPath(ACategoryID);
  Result := MinimizeName(Result, ACanvas, MaxLen);
  Result := Result.Trim(['\']).Replace('\', '-');
end;

function TQuerySearchCategoriesPath.GetPath: TField;
begin
  Result := Field('Path');
end;

function TQuerySearchCategoriesPath.Search(ACategoryID: Integer): Integer;
begin
  Assert(ACategoryID > 0);

  Result := Search(['ID'], [ACategoryID]);
end;

end.
