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

  // ��������� �����, � ������� �� ����� ������ ��� ����
  AFolders := TSettings.Create.BodyTypesJEDECFolder;


  Open(Handle, AFolders, AFileName, 'JEDEC ���� %s �� ������',
  '�� ����� ���� JEDEC', sBodyTypesFilesExt)
end;

end.
