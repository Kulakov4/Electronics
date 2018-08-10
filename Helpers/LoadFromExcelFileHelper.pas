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
      AInitExcelTable: TProcRef = nil);
    class function NewInstance: TObject; override;
  end;

implementation

uses System.Sysutils, NotifyEvents, VCL.Controls, CustomExcelTable,
  ProjectConst, System.Contnrs, System.Classes, ErrorType;

var
  SingletonList: TObjectList;

procedure TLoad.DoAfterLoadSheet(ASender: TObject);
var
  AfrmError: TfrmCustomError;
  e: TExcelDMEvent;
  OK: Boolean;
begin
  e := ASender as TExcelDMEvent;

  // Надо обновить прогресс записи
  if FWriteProgress.PIList.Count = 0 then
    FWriteProgress.Assign(e.TotalProgress);

  OK := e.ExcelTable.Errors.RecordCount = 0;
  // Если в ходе загрузки данных произошли ошибки
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := FCustomErrorFormClass.Create(nil);
    try
      AfrmError.ViewGridEx.DataSet := e.ExcelTable.Errors;
      // Показываем ошибки
      OK := AfrmError.ShowModal = mrOk;
      if OK then
      begin
        if AfrmError.ContinueType = ctSkip then
          // Убираем записи с ошибками и предупреждениями
          e.ExcelTable.ExcludeErrors(etWarring)
        else
          // Убираем записи с ошибками
          e.ExcelTable.ExcludeErrors(etError);
      end;
    finally
      FreeAndNil(AfrmError);
    end;
  end;

  // Надо ли останавливать загрузку остальных листов
  e.Terminate := not OK;

  if OK then
  begin
    FfrmProgressBar.Show;
    e.ExcelTable.Process(FProcRef,
      // Обработчик события
      procedure(ASender: TObject)
      Var
        API: TProgressInfo;
      begin
        API := ASender as TProgressInfo;
        // Запоминаем прогресс записи листа
        FWriteProgress.PIList[e.SheetIndex - 1].Assign(API);
        // Обновляем общий прогресс записи
        FWriteProgress.UpdateTotalProgress;

        TryUpdateWriteStatistic(FWriteProgress.TotalProgress);
      end);
  end;
end;

procedure TLoad.DoOnTotalReadProgress(ASender: TObject);
var
  e: TExcelDMEvent;
begin
  Assert(FfrmProgressBar <> nil);

  e := ASender as TExcelDMEvent;
  FfrmProgressBar.UpdateReadStatistic(e.TotalProgress.TotalProgress);
end;

procedure TLoad.LoadAndProcess(const AFileName: string;
AExcelDMClass: TExcelDMClass; ACustomErrorFormClass: TCustomErrorFormClass;
AProcRef: TProcRef; AInitExcelTable: TProcRef = nil);
var
  AExcelDM: TExcelDM;
begin
  FProcRef := AProcRef;
  FCustomErrorFormClass := ACustomErrorFormClass;
  FfrmProgressBar := TfrmProgressBar2.Create(nil);
  FWriteProgress := TTotalProgress.Create;

  // Создаём модуль для работы с Excel нужного класса
  AExcelDM := AExcelDMClass.Create(nil);
  try
    // Дополнительно инициализируем Excel модуль
    if Assigned(AInitExcelTable) then
      AInitExcelTable(AExcelDM.CustomExcelTable);

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
  begin
    Instance := TLoad(inherited NewInstance);
    SingletonList.Add(Instance);
  end;

  Result := Instance;
end;

procedure TLoad.TryUpdateWriteStatistic(API: TProgressInfo);
begin
  if (API.ProcessRecords mod OnWriteProcessEventRecordCount = 0) or
    (API.ProcessRecords = API.TotalRecords) then
    // Отображаем общий прогресс записи
    FfrmProgressBar.UpdateWriteStatistic(API);
end;

initialization

SingletonList := TObjectList.Create(True);

finalization

FreeAndNil(SingletonList);

end.
