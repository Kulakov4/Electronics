unit OpenDocumentUnit;

interface

uses Winapi.Windows, System.Generics.Collections;

type
  TDocument = class(TObject)
  private
    class procedure GetFileNames(const AFileName, AFileExts: string;
      L: TList<String>); static;
  public
    class procedure Open(Handle: HWND; const AFolder, AFileName, AErrorMessage,
      AEmptyErrorMessage: string; const AFileExts: string = ''); static;
  end;

implementation

uses System.IOUtils, SettingsController, Winapi.ShellAPI, DialogUnit, SysUtils;

class procedure TDocument.GetFileNames(const AFileName, AFileExts: string;
  L: TList<String>);
var
  AExt: String;
  m: TArray<String>;
  S: string;
begin
  Assert(not AFileName.IsEmpty);
  S := TPath.GetExtension(AFileName);
  if not S.IsEmpty then
    L.Add(AFileName);

  m := AFileExts.Split([';']);
  for AExt in m do
  begin
    S := AExt.Trim;
    if not S.IsEmpty then
      L.Add(Format('%s.%s', [TPath.GetFileNameWithoutExtension(AFileName), S]));
  end;
end;

class procedure TDocument.Open(Handle: HWND;
  const AFolder, AFileName, AErrorMessage, AEmptyErrorMessage: string;
  const AFileExts: string = '');
var
  AFullFileName: string;
  L: TList<String>;
  S: string;
begin
  if AFileName <> '' then
  begin
    L := TList<String>.Create;
    try
      // Получаем все возможные имена файлов
      GetFileNames(AFileName, AFileExts, L);
      Assert(L.Count > 0);
      for S in L do
      begin
        // Получаем полное имя файла
        AFullFileName := TPath.Combine(AFolder, S);
        if TFile.Exists(AFullFileName) then
        begin
          ShellExecute(Handle, nil, PChar(AFullFileName), nil, nil,
            SW_SHOWNORMAL);
          Exit;
        end
      end;
      TDialog.Create.ErrorMessageDialog(Format(AErrorMessage,
        [TPath.Combine(AFolder, AFileName)]));
    finally
      FreeAndNil(L);
    end;
  end
  else
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);
end;

end.
