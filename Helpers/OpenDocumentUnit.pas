unit OpenDocumentUnit;

interface

uses Winapi.Windows, System.Generics.Collections;

type
  TDocument = class(TObject)
  private
    class var Instance: TDocument;
  public
    class function NewInstance: TObject; override;
    procedure Open(Handle: HWND; const AFolder, AFileName, AErrorMessage,
      AEmptyErrorMessage: string; const AFileExts: string = '');
  end;

implementation

uses System.IOUtils, SettingsController, Winapi.ShellAPI, DialogUnit, SysUtils,
  FilesController;

class function TDocument.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TDocument(inherited NewInstance);

  Result := Instance;
end;

procedure TDocument.Open(Handle: HWND; const AFolder, AFileName, AErrorMessage,
  AEmptyErrorMessage: string; const AFileExts: string = '');
var
  AFileList: TList<String>;
  AFullFileName: string;
  Ok: Boolean;
begin
  if AFileName <> '' then
  begin
    AFileList := TFilesController.Create.GetFileList(AFolder, AFileName,
      AFileExts);
    try
      Ok := False;
      for AFullFileName in AFileList do
      begin
        if TFile.Exists(AFullFileName) then
        begin
          ShellExecute(Handle, nil, PChar(AFullFileName), nil, nil,
            SW_SHOWNORMAL);
          Ok := True;
          Break;
        end
      end;
      if not Ok then
        TDialog.Create.ErrorMessageDialog(Format(AErrorMessage,
          [AFullFileName]));

    finally
      FreeAndNil(AFileList);
    end;

    AFullFileName := TPath.Combine(TPath.Combine(TSettings.Create.DataBasePath,
      AFolder), AFileName);

  end
  else
    TDialog.Create.ErrorMessageDialog(AEmptyErrorMessage);
end;

end.
