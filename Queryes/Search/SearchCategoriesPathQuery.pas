unit SearchCategoriesPathQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap;

type
  TSearchCategoriesPathW = class(TDSWrap)
  private
    FPath: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Path: TFieldWrap read FPath;
    property ID: TFieldWrap read FID;
  end;

  TQuerySearchCategoriesPath = class(TQueryBase)
  private
    FW: TSearchCategoriesPathW;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    function GetFullPath(ACategoryID: Integer): string;
    function GetLastTreeNodes(ACategoryID: Integer; const ACount: Integer;
      ASplitter: string): string;
    function GetMinimizePath(ACategoryID: Integer; ACanvas: TCanvas;
      MaxLen: Integer): String;
    function Search(ACategoryID: Integer; TestResult: Integer = -1): Integer;
        overload;
    property W: TSearchCategoriesPathW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}
{$WARN UNIT_PLATFORM OFF}

uses Vcl.FileCtrl;

constructor TQuerySearchCategoriesPath.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchCategoriesPathW.Create(FDQuery);
end;

function TQuerySearchCategoriesPath.GetFullPath(ACategoryID: Integer): string;
begin
  Search(ACategoryID, 1);
  Result := W.Path.F.AsString;
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

function TQuerySearchCategoriesPath.Search(ACategoryID: Integer; TestResult:
    Integer = -1): Integer;
begin
  Assert(ACategoryID > 0);

  Result := Search([W.ID.FieldName], [ACategoryID], TestResult);
end;

constructor TSearchCategoriesPathW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FPath := TFieldWrap.Create(Self, 'Path');
end;

end.
