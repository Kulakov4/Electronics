unit OpenJedecUnit;

interface

uses
  OpenDocumentUnit, Winapi.Windows, System.Generics.Collections;

type
  TJEDECDocument = class(TDocument)
  public
    class procedure OpenJEDEC(Handle: HWND; const AFileName: string); static;
  end;

implementation

uses
  System.SysUtils, DialogUnit, ProjectConst, SettingsController, Vcl.Forms;

class procedure TJEDECDocument.OpenJEDEC(Handle: HWND; const AFileName: string);
var
  AFolders: string;
begin
  Application.Hint := '';

  // Формируем папки, в которых мы будем искать наш файл
  AFolders := TSettings.Create.BodyTypesJEDECFolder;


  Open(Handle, AFolders, AFileName, 'JEDEC файл %s не найден',
  'Не задан файл JEDEC', sBodyTypesFilesExt)
end;

end.
