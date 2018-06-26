unit OpenDocumentUnit;

interface

uses Winapi.Windows, System.Generics.Collections;

type
  TDocument = class(TObject)
  private
  protected
    class procedure GetFileNames(const AFileName, AFileExts: string;
      L: TList<String>); static;
  public
    class procedure Open(Handle: HWND; const AFolders, AFileName, AErrorMessage,
      AEmptyErrorMessage: string; const AFileExts: string = ''); static;
  end;

implementation

uses System.IOUtils, SettingsController, Winapi.ShellAPI, DialogUnit, SysUtils;

class procedure TDocument.GetFileNames(const AFileName, AFileExts: string;
  L: TList<String>);
var
  AExt: String;
  D: string;
  F: string;
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
    begin
      D := TPath.GetDirectoryName(AFileName);
      F := TPath.GetFileNameWithoutExtension(AFileName);

      L.Add(Format('%s.%s', [TPath.Combine(D, F), S]));
    end;
  end;
end;

class procedure TDocument.Open(Handle: HWND; const AFolders, AFileName,
  AErrorMessage, AEmptyErrorMessage: string; const AFileExts: string = '');
var
  AFolder: string;
  AFullFileName: string;
  L: TList<String>;
  m: TArray<String>;
  S: string;
begin
  Assert(not AFolders.IsEmpty);

  if AFileName.IsEmpty then
  begin
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);
    Exit;
  end;

  // Получаем все возможные папки
  m := AFolders.Split([';']);
  Assert(Length(m) > 0);

  L := TList<String>.Create;
  try
    // Получаем все возможные имена файлов
    GetFileNames(AFileName, AFileExts, L);
    Assert(L.Count > 0);
    for S in L do
    begin
      for AFolder in m do
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
    end;
    TDialog.Create.ErrorMessageDialog(Format(AErrorMessage,
      [TPath.Combine(m[0], AFileName)]));
  finally
    FreeAndNil(L);
  end;

end;

end.
