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
  Result := TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.LastFolderForExcelFile, '', AFileName);

  if Result then
    // ��������� ��� ����� � ����������
    TSettings.Create.LastFolderForExcelFile :=
      TPath.GetDirectoryName(AFileName);

end;

end.
