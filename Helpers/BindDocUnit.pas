unit BindDocUnit;

interface

uses
  DocBindExcelDataModule;

type
  TBindDoc = class(TObject)
  protected
    class procedure DoBindDocs(ADocBindExcelTable: TDocBindExcelTable); static;
  public
    class procedure LoadDocBindsFromExcelDocument(const AFileName
      : string); static;
  end;

implementation

uses AllFamilyQuery, System.SysUtils, ProgressBarForm, ErrorForm, ProjectConst,
  System.UITypes, CustomExcelTable, System.IOUtils;

class procedure TBindDoc.DoBindDocs(ADocBindExcelTable: TDocBindExcelTable);
var
  i: Integer;
  qAllFamily: TQueryAllFamily;
begin
  qAllFamily := TQueryAllFamily.Create(nil);
  try
    // �������� ����������, ���� ��� ��� �� ��������
    if (not qAllFamily.FDQuery.Connection.InTransaction) then
      qAllFamily.FDQuery.Connection.StartTransaction;
    ADocBindExcelTable.First;
    ADocBindExcelTable.CallOnProcessEvent;
    i := 0;
    while not ADocBindExcelTable.Eof do
    begin
      // �������� ����� ��������� � ����� ���������������
      qAllFamily.Load(['ID'], [ADocBindExcelTable.IDProduct.AsInteger]);
      if qAllFamily.FDQuery.RecordCount = 1 then
      begin
        qAllFamily.TryEdit;
        // ���� ������������ ������ ������ � ����� � ������ �������������
        qAllFamily.Datasheet.AsString :=
          TPath.Combine(qAllFamily.Producer.AsString,
          ADocBindExcelTable.Datasheet.AsString);
        qAllFamily.Diagram.AsString :=
          TPath.Combine(qAllFamily.Producer.AsString,
          ADocBindExcelTable.Diagram.AsString);
        qAllFamily.TryPost;
        Inc(i);
        // ��� ����� ������� �������� � ������ ����� ����������
        if i >= 1000 then
        begin
          i := 0;
          qAllFamily.FDQuery.Connection.Commit;
          qAllFamily.FDQuery.Connection.StartTransaction;
        end;

      end;
      ADocBindExcelTable.Next;
      ADocBindExcelTable.CallOnProcessEvent;
    end;
    qAllFamily.FDQuery.Connection.Commit;
  finally
    FreeAndNil(qAllFamily);
  end;
end;

class procedure TBindDoc.LoadDocBindsFromExcelDocument(const AFileName: string);
var
  ADocBindExcelDM: TDocBindExcelDM;
  AfrmError: TfrmError;
  OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  ADocBindExcelDM := TDocBindExcelDM.Create(nil);
  try
    // ������ ���� - ��������� ������ �� Excel �����
    TfrmProgressBar.Process(ADocBindExcelDM,
      procedure (ASender: TObject)
      begin
        ADocBindExcelDM.LoadExcelFile(AFileName);
      end, '�������� ������ � ������ ������������ �� Excel ���������', sRows);

    // ������ ���� - ���������� ���� � ��������
    OK := ADocBindExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmError := TfrmError.Create(nil);
      try
        AfrmError.ErrorTable := ADocBindExcelDM.ExcelTable.Errors;
        // ���������� ������ (��������� �� �������)
        OK := AfrmError.ShowModal = mrOk;
        ADocBindExcelDM.ExcelTable.ExcludeErrors(etError);
      finally
        FreeAndNil(AfrmError);
      end;
    end;

    // ������ ���� - ��������� � ���� ������
    if OK then
    begin
      TfrmProgressBar.Process(ADocBindExcelDM.ExcelTable,
        procedure (ASender: TObject)
        begin
          DoBindDocs(ADocBindExcelDM.ExcelTable);
        end, '���������� �������� � ������������', sComponents);
    end;
  finally
    FreeAndNil(ADocBindExcelDM);
  end;
end;

end.
