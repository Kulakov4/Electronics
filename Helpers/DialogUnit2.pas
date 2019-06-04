unit DialogUnit2;

interface

uses Winapi.Windows;

type
  TOpenExcelDialog = class(TObject)
  private
  public
// TODO: SelectInLastFolder
//  class function SelectInLastFolder(var AFileName: String; AParentWnd: HWND)
//    : Boolean; static;
    class function SelectInFolder(var AFileName: String; AParentWnd: HWND; const
        AFolderKey: String): Boolean; static;
  end;

implementation

uses DialogUnit, SettingsController, System.SysUtils, System.IOUtils;


class function TOpenExcelDialog.SelectInFolder(var AFileName: String;
    AParentWnd: HWND; const AFolderKey: String): Boolean;
begin
  Result := TDialog.Create.ShowDialog(TExcelFileOpenDialog,
    TSettings.Create.GetFolderFoExcelFile(AFolderKey), '', AFileName);

  if Result then
    // ��������� ��� ����� � ����������
    TSettings.Create.SetFolderForExcelFile(AFolderKey, TPath.GetDirectoryName(AFileName));
end;

end.
