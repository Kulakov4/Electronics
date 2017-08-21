unit LoadFromExcelFileHelper;

interface

uses ExcelDataModule, ProgressBarForm2, CustomErrorForm, ProcRefUnit,
  ProgressInfo;

type
  TLoad = class(TObject)
  private
    class var Instance: TLoad;

  var
    FCustomErrorFormClass: TCustomErrorFormClass;
    FfrmProgressBar: TfrmProgressBar2;
    FProcRef: TProcRef;
    FWriteProgress: TTotalProgress;
    procedure DoAfterLoadSheet(ASender: TObject);
    procedure DoOnTotalReadProgress(ASender: TObject);
    procedure TryUpdateWriteStatistic(API: TProgressInfo);
  public
    procedure LoadAndProcess(const AFileName: string;
      AExcelDMClass: TExcelDMClass;
      ACustomErrorFormClass: TCustomErrorFormClass; AProcRef: TProcRef;
      AInitExcelDM: TProcRef = nil);
    class function NewInstance: TObject; override;
  end;

implementation

uses System.Sysutils, NotifyEvents, VCL.Controls, CustomExcelTable,
  ProjectConst;

procedure TLoad.DoAfterLoadSheet(ASender: TObject);
var
  AfrmError: TfrmCustomError;
  e: TExcelDMEvent;
  OK: Boolean;
begin
  e := ASender as TExcelDMEvent;

  // ���� �������� �������� ������
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(e.TotalProgress);

  OK := e.ExcelTable.Errors.RecordCount = 0;
  // ���� � ���� �������� ������ ��������� ������ (������������� �� ������)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := FCustomErrorFormClass.Create(nil);
    try
      AfrmError.ErrorTable := e.ExcelTable.Errors;
      // ���������� ������
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // ������� ������ � �������� � ����������������
          e.ExcelTable.ExcludeErrors(etWarring)
        else
          // ������� ������ � ��������
          e.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // ���� �� ������������� �������� ��������� ������
  e.Terminate := not OK;

  if OK then
  begin
    FfrmProgressBar.Show;
    e.ExcelTable.Process(FProcRef,
      {
        // �����, �������������� ���� �������
        procedure
        begin
        ProductGroup.qProducts.AppendList(e.ExcelTable as TProductsExcelTable);
        end,
      }
      // ���������� �������
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        // ���������� �������� ������ �����
        FWriteProgress.PIList[e.SheetIndex - 1].Assign(API);
        // ��������� ����� �������� ������
        FWriteProgress.UpdateTotalProgress;

        TryUpdateWriteStatistic(FWriteProgress.TotalProgress);
      end);
  end;
end;

procedure TLoad.DoOnTotalReadProgress(ASender: TObject);
begin
  Assert(FfrmProgressBar <> nil);
  FfrmProgressBar.UpdateReadStatistic(ASender as TProgressInfo);
end;

procedure TLoad.LoadAndProcess(const AFileName: string;
AExcelDMClass: TExcelDMClass; ACustomErrorFormClass: TCustomErrorFormClass;
AProcRef: TProcRef; AInitExcelDM: TProcRef = nil);
var
  AExcelDM: TExcelDM;
begin
  FProcRef := AProcRef;
  FCustomErrorFormClass := ACustomErrorFormClass;
  FfrmProgressBar := TfrmProgressBar2.Create(nil);
  FWriteProgress := TTotalProgress.Create;

  // ������ ������ ��� ������ � Excel ������� ������
  AExcelDM := AExcelDMClass.Create(nil);
  try
    // ������������� �������������� Excel ������
    if Assigned(AInitExcelDM) then
      AInitExcelDM(AExcelDM.CustomExcelTable);

    TNotifyEventWrap.Create(AExcelDM.AfterLoadSheet, DoAfterLoadSheet);
    TNotifyEventWrap.Create(AExcelDM.OnTotalProgress, DoOnTotalReadProgress);
    FfrmProgressBar.Show;

    if not AFileName.IsEmpty then
      AExcelDM.LoadExcelFile2(AFileName)
    else
      AExcelDM.LoadFromActiveSheet;

  finally
    FreeAndNil(FWriteProgress);
    FreeAndNil(AExcelDM);
    FreeAndNil(FfrmProgressBar);
  end;
end;

class function TLoad.NewInstance: TObject;
begin
  if not Assigned(Instance) then
    Instance := TLoad(inherited NewInstance);

  Result := Instance;
end;

procedure TLoad.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // ���������� ����� �������� ������
    FfrmProgressBar.UpdateWriteStatistic(API);
end;

end.
