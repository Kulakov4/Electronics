unit ClipboardUnit;

interface

uses
  System.Classes;

type
  TClb = class(TObject)
  private
    class var Instance: TClb;
    // TODO: GetRows
    // function GetRows: TStringList;
  public
    function ConcatRows: string;
    function GetRowsAsArray: TArray<String>;
    class function NewInstance: TObject; override;
  end;

implementation

uses Vcl.Clipbrd, Winapi.Windows, System.SysUtils, System.Contnrs, StrHelper;

var
  SingletonList: TObjectList;

function TClb.ConcatRows: string;
begin
  Result := StrHelper.DeleteDouble(Clipboard.AsText.Trim.Replace(#13, ' ')
    .Replace(#10, ' '), ' ');
end;

function TClb.GetRowsAsArray: TArray<String>;
var
  i: Integer;
  S: string;
begin
  S := Clipboard.AsText.Trim;
  // Разбиваем текст на строки
  Result := S.Split([#13]);
  for i := Low(Result) to High(Result) do
  begin
    Result[i] := Result[i].Trim([#13, #10, ' ']);
  end;

end;

class function TClb.NewInstance: TObject;
begin
  if not Assigned(Instance) then
  begin
    Instance := TClb(inherited NewInstance);
    SingletonList.Add(Instance);
  end;

  Result := Instance;
end;

initialization

SingletonList := TObjectList.Create(True);

finalization

FreeAndNil(SingletonList);

end.
