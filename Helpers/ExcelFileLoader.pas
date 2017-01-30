unit ExcelFileLoader;

interface

uses
  ExcelDataModule, CustomExcelTable, NotifyEvents;

type
  // ������ �� ����� �������������� Excel �������
  TExcelTableProcessRef = reference to procedure(AExcelTable
    : TCustomExcelTable);

  TExcelData = class(TObject)
  public
    class procedure Load(const AFileName: string; AExcelDM: TExcelDM); static;
    class procedure Save(AExcelTable: TCustomExcelTable;
      AExcelTableProcessRef: TExcelTableProcessRef); static;
  end;

implementation

uses System.SysUtils, ProgressBarForm, ProgressInfo;

class procedure TExcelData.Load(const AFileName: string; AExcelDM: TExcelDM);
var
  AfrmProgressBar: TfrmProgressBar;
  ne: TNotifyEventR;
begin
  Assert(not AFileName.IsEmpty);
  Assert(AExcelDM <> nil);

  // ��������� ������ �� Excel �����
  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    AfrmProgressBar.Caption := '�������� ������ �� Excel ���������';
    AfrmProgressBar.Show;
    // ������������� �� �������
    ne := TNotifyEventR.Create(AExcelDM.OnProgress,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
    try
      // ��������� ������ �� Excel �����
      AExcelDM.LoadExcelFile(AFileName);
    finally
      FreeAndNil(ne); // ������������ �� �������
    end;
  finally
    FreeAndNil(AfrmProgressBar);
  end;

end;

class procedure TExcelData.Save(AExcelTable: TCustomExcelTable;
AExcelTableProcessRef: TExcelTableProcessRef);
var
  AfrmProgressBar: TfrmProgressBar;
  ne: TNotifyEventR;
begin
  Assert(AExcelTable <> nil);

  // ��������� ������ �� Excel �����
  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    AfrmProgressBar.Caption := '��������� ������ � ��';
    AfrmProgressBar.Show;
    // ������������� �� �������
    ne := TNotifyEventR.Create(AExcelTable.OnProgress,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
    try
      // ��������� ������ � ���� ������
      AExcelTableProcessRef(AExcelTable);
    finally
      FreeAndNil(ne); // ������������ �� �������
    end;
  finally
    FreeAndNil(AfrmProgressBar);
  end;

end;

end.
