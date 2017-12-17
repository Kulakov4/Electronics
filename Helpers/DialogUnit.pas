unit DialogUnit;

interface

uses Vcl.Dialogs, System.Classes, Winapi.Windows, System.IOUtils;

{$WARN SYMBOL_PLATFORM OFF}

type
  TFileOpenDialogClass = class of TFileOpenDialog;
  TOpenDialogClass = class of TOpenDialog;

  TOpenFolderDialog = class(TOpenDialog)
  private
    procedure DoOnShow(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TExcelFilesFolderOpenDialog = class(TOpenFolderDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

type
  TDatabaselFilesFolderOpenDialog = class(TOpenFolderDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

type
  TPDFFilesFolderOpenDialog = class(TOpenFolderDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TDialog = class(TObject)
  private
    class var Instance: TDialog;
  public
    function AddManufacturerDialog(const AValue: String): Boolean;
    procedure AutoBindNotFoundDialog;
    procedure AutoBindResultDialog(ACount: Integer);
    function ClearTreeDialog: Boolean;
    procedure BodyNotFoundDialog(const AValue: String);
    procedure MethodNotImplemended;
    procedure ComponentsDocFilesNotFound;
    procedure ParametricTableNotFound;
    function DeleteRecordsDialog(const AText: string): Boolean;
    procedure ErrorMessageDialog(const AErrorMessage: String);
    class function NewInstance: TObject; override;
    function OpenPictureDialog(const AInitialDir: string): string;
    function CreateFolderDialog(const AValue: String): Integer;
    procedure DirectoryNotExistDialog(const AValue: String);
    procedure ExcelFilesNotFoundDialog;
    function OpenDialog(AOpenDialogClass: TOpenDialogClass;
      const AInitialDir: string; AParentHWND: HWND;
      var AFileName: String): Boolean;
    function SaveToExcelFile(const ADefaultFileName: string;
      var ASelectedFileName: string): Boolean;
    function SaveDataDialog: Integer;
  end;

  TExcelFilesOpenDialog = class(TOpenDialog)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Vcl.ExtDlgs, Vcl.Forms, System.SysUtils, Winapi.ShlObj,
  Winapi.Messages, ProjectConst;

function TDialog.AddManufacturerDialog(const AValue: String): Boolean;
begin
  Result := Application.MessageBox
    (PChar(Format('� ����������� �������������� �� ������ ������������� %s.' +
    #13#10 + #13#10 + '�������� "%s" � ����������?', [AValue, AValue])),
    '���������� �������������', MB_YESNO + MB_ICONQUESTION) = IDYES;
end;

procedure TDialog.AutoBindNotFoundDialog;
begin
  Application.MessageBox
    (PChar('� ����������� ������� �������� �� ������� �� ����� ���������� ������'),
    '��������� �������������� ��������', MB_OK);
end;

procedure TDialog.AutoBindResultDialog(ACount: Integer);
begin
  Application.MessageBox(PChar(Format('����������� ��������: %d', [ACount])),
    '��������� ��������������� ������������', MB_OK);
end;

function TDialog.ClearTreeDialog: Boolean;
begin
  Result := Application.MessageBox
    (PChar('����� ��������� ������ ������ ��������� ����� �������' + #13#10 +
    '��� ���������� ����� �������' + #13#10 + #13#10 + '����������?'),
    '�������� ������ ���������', MB_YESNO + MB_ICONQUESTION) = IDYES;

end;

procedure TDialog.BodyNotFoundDialog(const AValue: String);
begin
  Application.MessageBox
    (PChar(Format('� ����������� �������� �� ������ ������ %s', [AValue])),
    '������ ��� ���������� �������', MB_OK + MB_ICONSTOP);
end;

procedure TDialog.MethodNotImplemended;
begin
  Application.MessageBox(PChar('������ ������� ���� �� �����������'), '������',
    MB_OK + MB_ICONSTOP);
end;

procedure TDialog.ComponentsDocFilesNotFound;
begin
  Application.MessageBox(PChar('�� ������� ����� ������������'),
    '������ ��� �������� ������ ������������', MB_OK + MB_ICONSTOP);
end;

procedure TDialog.ParametricTableNotFound;
begin
  Application.MessageBox(PChar('�� ������� ��������� ������������ ����������'),
    '��������� ���� �� �������� ��������� ������������ ����������',
    MB_OK + MB_ICONSTOP);
end;

function TDialog.DeleteRecordsDialog(const AText: string): Boolean;
begin
  Result := Application.MessageBox(PWideChar(AText), '��������',
    MB_YESNO + MB_ICONQUESTION) = IDYES;
end;

procedure TDialog.ErrorMessageDialog(const AErrorMessage: String);
begin
  Application.MessageBox(PChar(AErrorMessage), '������', MB_OK + MB_ICONSTOP);
end;

class function TDialog.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TDialog(inherited NewInstance);

  Result := Instance;
end;

function TDialog.OpenPictureDialog(const AInitialDir: string): string;
var
  AOpenPictureDialog: TOpenPictureDialog;
begin
  Result := '';
  AOpenPictureDialog := TOpenPictureDialog.Create(nil);
  try
    AOpenPictureDialog.Filter :=
      '����������� � pdf ����� (*.jpg,*.jpeg,*.gif,*.png,*.pdf)|*.jpg;*.jpeg;*.gif;*.png;*.pdf|'
      + '����������� (*.jpg,*.jpeg,*.gif,*.png,*.tif)|*.jpg;*.jpeg;*.gif;*.png;*.tif|'
      + '��������� (*.pdf, *.doc, *.hmtl)|*.pdf;*.doc;*.hmtl|' +
      '��� ����� (*.*)|*.*';
    AOpenPictureDialog.FilterIndex := 0;

    if not AInitialDir.IsEmpty then
      AOpenPictureDialog.InitialDir := AInitialDir;

    AOpenPictureDialog.Options := [ofFileMustExist];
    if AOpenPictureDialog.Execute() then
      Result := AOpenPictureDialog.FileName;
  finally
    AOpenPictureDialog.Free;
  end;

end;

procedure TDialog.DirectoryNotExistDialog(const AValue: String);
begin
  Application.MessageBox(PChar(Format('���������� %s �� ����������', [AValue])),
    '���������� �� ����������', MB_OK + MB_ICONSTOP);
end;

function TDialog.CreateFolderDialog(const AValue: String): Integer;
begin
  Result := Application.MessageBox(PChar(Format('%s', [AValue])),
    '����� �� ����������', MB_YESNO + MB_ICONQUESTION);
end;

procedure TDialog.ExcelFilesNotFoundDialog;
begin
  Application.MessageBox(PChar('�� ������� �� ������ Excel �����'),
    PChar(sError), MB_OK + MB_ICONSTOP);
end;

function TDialog.OpenDialog(AOpenDialogClass: TOpenDialogClass;
  const AInitialDir: string; AParentHWND: HWND; var AFileName: String): Boolean;
var
  fod: TOpenDialog;
begin
  AFileName := '';
  fod := AOpenDialogClass.Create(nil);
  try
    fod.InitialDir := AInitialDir;
    Result := fod.Execute(AParentHWND);
    if Result then
    begin
      AFileName := fod.FileName;
    end;
  finally
    FreeAndNil(fod);
  end;
end;

function TDialog.SaveToExcelFile(const ADefaultFileName: string;
  var ASelectedFileName: string): Boolean;
var
  SaveDialog: TSaveTextFileDialog;
begin
  // Result := False;
  SaveDialog := TSaveTextFileDialog.Create(nil);
  try
    SaveDialog.FileName := ADefaultFileName;
    SaveDialog.Filter := '��������� (*.xls, *.xlsx)|*.xls;*.xlsx|' +
      '��� ����� (*.*)|*.*';
    SaveDialog.FilterIndex := 0;
    SaveDialog.Options := [ofFileMustExist];
    Result := SaveDialog.Execute(Application.ActiveFormHandle);

    if Result then
      ASelectedFileName := SaveDialog.FileName
  finally
    SaveDialog.Free;
  end;
end;

function TDialog.SaveDataDialog: Integer;
begin
  Result := Application.MessageBox(PWideChar(sDoYouWantToSaveChanges),
    PWideChar(sSaving), MB_YESNOCANCEL + MB_ICONQUESTION);
end;

{ TExcelFilesFolderOpenDialog }
constructor TExcelFilesFolderOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  Self.FileName := '*.xls;*.xlsx';
end;

{ TDatabaselFilesFolderOpenDialog }
constructor TDatabaselFilesFolderOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  Self.FileName := '*.db';
end;

{ TPDFFilesFolderOpenDialog }
constructor TPDFFilesFolderOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  Self.FileName := '*.pdf;*.gif;*.jpg;*.png;*.bmp';
end;

{ TOpenFolderDialog }
constructor TOpenFolderDialog.Create(AOwner: TComponent);
begin
  inherited;
  // �������� ��� ����� ��� ����� ���������� ����������� �� ����
  Options := Options + [ofNoValidate];
  // ���������� ������� OnShow
  OnShow := DoOnShow;
end;

procedure TOpenFolderDialog.DoOnShow(Sender: TObject);
const
  // �������� �������� �� ������ � MSDN, �������� � Dlgs.h � WinUser.h
  stc3: Integer = $442; // ����� � ����� �������� �����
  cmb13: Integer = $47C; // ��������� � ������ �������� �����
  edt1: Integer = $480; // ���� ����� � ������ �������� �����

  stc2: Integer = $441; // ����� � ����������
  cmb1: Integer = $470; // ��������� �� ������� ��������
var
  fod: TOpenDialog;
  H: THandle;
begin
  fod := Sender as TOpenDialog;
  if Assigned(fod) then
  begin
    H := GetParent(fod.Handle);

    // ������ ������ ������ ������� ��� �����, ���� ����� � ���������
    SendMessage(H, WM_USER + 100 + 5, stc3, 0);
    SendMessage(H, WM_USER + 100 + 5, cmb13, 0);
    SendMessage(H, WM_USER + 100 + 5, edt1, 0);

    // ������ ������ ������ - ������
    SendMessage(H, WM_USER + 100 + 5, cmb1, 0);
    SendMessage(H, WM_USER + 100 + 5, stc2, 0);
  end;
end;

{ TExcelFilesOpenDialog }
constructor TExcelFilesOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  Filter := '��������� (*.xls, *.xlsx)|*.xls;*.xlsx|' + '��� ����� (*.*)|*.*';
  FilterIndex := 0;
  Options := [ofFileMustExist];
end;

end.
