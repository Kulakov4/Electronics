unit DialogUnit2;

interface

type
  TOpenExcelDialog = class(TObject)
  private
  public
    class function SelectInLastFolder(var AFileName: String): Boolean; static;
  end;

implementation

uses DialogUnit, SettingsController, System.SysUtils, System.IOUtils;

class function TOpenExcelDialog.SelectInLastFolder(var AFileName: String):
    Boolean;
begin
  AFileName := TDialog.Create.OpenExcelFile
    (TSettings.Create.LastFolderForExcelFile);

  Result := not AFileName.IsEmpty;

  if Result then
    // Сохраняем эту папку в настройках
    TSettings.Create.LastFolderForExcelFile := TPath.GetDirectoryName(AFileName);

end;

end.
