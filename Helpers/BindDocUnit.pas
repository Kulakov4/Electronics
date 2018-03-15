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

uses AllFamilyQuery, System.SysUtils, ProgressBarForm, ProjectConst,
  System.UITypes, CustomExcelTable, System.IOUtils, LoadFromExcelFileHelper,
  CustomErrorForm;

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
        // ���� ������������ ������
        if not ADocBindExcelTable.Datasheet.AsString.IsEmpty then
        begin
          // ���� ������������ ������ ������ � ����� � ������ �������������
          qAllFamily.Datasheet.AsString :=
            TPath.Combine(qAllFamily.Producer.AsString,
            ADocBindExcelTable.Datasheet.AsString);
        end;
        // ���� �������������� ��������� ������
        if not ADocBindExcelTable.Diagram.AsString.IsEmpty then
        begin
          qAllFamily.Diagram.AsString :=
            TPath.Combine(qAllFamily.Producer.AsString,
            ADocBindExcelTable.Diagram.AsString);
        end;
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
// var
// ADocBindExcelDM: TDocBindExcelDM;
// AfrmError: TfrmError;
// OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  TLoad.Create.LoadAndProcess(AFileName, TDocBindExcelDM, TfrmCustomError,
    procedure(ASender: TObject)
    begin
      // ��������� ��������
      DoBindDocs(ASender as TDocBindExcelTable);
    end);
end;

end.
