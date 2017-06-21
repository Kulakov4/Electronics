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
    function GetRowsAsArray: TArray<String>;
    class function NewInstance: TObject; override;
  end;

implementation

uses Vcl.Clipbrd, Winapi.Windows, System.SysUtils;

// TODO: GetRows
// function TClb.GetRows: TStringList;
// var
// i: Integer;
// begin
// Result := TStringList.Create;
// if Clipboard.HasFormat(CF_TEXT) then
// begin
// Result.Text := Clipboard.AsText;
// for i := 0 to Result.Count - 1 do
// begin
// Result[i] := Result[i].Trim(['"', #13, #10]);
// end;
// end;
//
// end;

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
    Instance := TClb(inherited NewInstance);

  Result := Instance;
end;

end.
