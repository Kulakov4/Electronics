unit FilesController;

interface

uses System.Generics.Collections;

type
  TFilesController = class(TObject)
  private
    class var Instance: TFilesController;
  public
    function FileExists(const AFolder, AFileName, AFileExts: string): Boolean;
    function GetFileList(const AFolder, AFileName, AFileExts: string)
      : TList<String>;
    class function NewInstance: TObject; override;
    function UploadFile(sourceFileName, targetDirectory: string): string;
  end;

implementation

uses System.IOUtils, System.SysUtils;

function TFilesController.FileExists(const AFolder, AFileName,
  AFileExts: string): Boolean;
var
  AFileList: TList<String>;
  FN: string;
begin
  AFileList := GetFileList(AFolder, AFileName, AFileExts);
  try
    Result := False;
    // Попробуем найти подходящие файлы
    for FN in AFileList do
    begin
      if TFile.Exists(FN) then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    FreeAndNil(AFileList);
  end;
end;

function TFilesController.GetFileList(const AFolder, AFileName,
  AFileExts: string): TList<String>;
var
  e: string;
  m: TArray<String>;
  S: string;
begin
  Result := TList<string>.Create;

  S := TPath.Combine(AFolder, AFileName);

  m := AFileExts.Split([';']);

  if Length(m) > 0 then
  begin
    for e in m do
    begin
      // Меняем расширение файла и добавляем файл в список подходящих
      Result.Add(TPath.ChangeExtension(S, e));
    end;
  end;
  Result.Add(S);
end;

class function TFilesController.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TFilesController(inherited NewInstance);

  Result := Instance;
end;

function TFilesController.UploadFile(sourceFileName, targetDirectory
  : string): string;
var
  targetFileName: string;
begin
  if sourceFileName = '' then
    Exit;
  if not TDirectory.Exists(targetDirectory) then
    // создать директорию, если надо
    TDirectory.CreateDirectory(targetDirectory);

  targetFileName := TPath.GetFileName(sourceFileName);
  targetFileName := TPath.Combine(targetDirectory, targetFileName);

  // Если исходный файл не в той-же папке что и целевой
  if sourceFileName <> targetFileName then
  begin
    if TFile.Exists(targetFileName) then
    begin
      TFile.Delete(targetFileName);
    end;
    TFile.Copy(sourceFileName, targetFileName);
  end;
  Result := TPath.GetFileName(targetFileName);
end;

end.
