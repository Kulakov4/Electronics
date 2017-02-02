unit OpenDocumentUnit;

interface

uses Winapi.Windows, System.Generics.Collections;

type
  TDocument = class(TObject)
  public
    class procedure Open(Handle: HWND; const AFolder, AFileName, AErrorMessage,
        AEmptyErrorMessage: string; const AFileExts: string = ''); static;
  end;

implementation

uses System.IOUtils, SettingsController, Winapi.ShellAPI, DialogUnit, SysUtils;

class procedure TDocument.Open(Handle: HWND; const AFolder, AFileName,
    AErrorMessage, AEmptyErrorMessage: string; const AFileExts: string = '');
var
  AFullFileName: string;
begin
  if AFileName <> '' then
  begin
    // Получаем полное имя файла
    AFullFileName := TPath.Combine(AFolder, AFileName);
    if TFile.Exists(AFullFileName) then
    begin
      ShellExecute(Handle, nil, PChar(AFullFileName), nil, nil, SW_SHOWNORMAL);
    end
    else
    begin
      TDialog.Create.ErrorMessageDialog(Format(AErrorMessage, [AFullFileName]));
    end;
  end
  else
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);
end;

end.
