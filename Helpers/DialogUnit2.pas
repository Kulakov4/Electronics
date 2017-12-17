unit DialogUnit2;

interface

uses Winapi.Windows;

type
  TOpenExcelDialog = class(TObject)
  private
  public
    class function SelectInLastFolder(var AFileName: String; AParentWnd: HWND)
      : Boolean; static;
  end;

implementation

uses DialogUnit, SettingsController, System.SysUtils, System.IOUtils;

class function TOpenExcelDialog.SelectInLastFolder(var AFileName: String;
  AParentWnd: HWND): Boolean;
begin
  Result := TDialog.Create.OpenDialog(TExcelFilesOpenDialog,
    TSettings.Create.LastFolderForExcelFile, AParentWnd, AFileName);

  if Result then
    // Сохраняем эту папку в настройках
    TSettings.Create.LastFolderForExcelFile :=
      TPath.GetDirectoryName(AFileName);

end;

end.
