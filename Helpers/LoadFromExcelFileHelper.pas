unit LoadFromExcelFileHelper;

interface

uses ExcelDataModule, ProgressBarForm2, CustomErrorForm, ProcRefUnit;

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
  public
    procedure LoadAndProcess(const AFileName: string;
      AExcelDMClass: TExcelDMClass;
      ACustomErrorFormClass: TCustomErrorFormClass; AProcRef: TProcRef);
    class function NewInstance: TObject; override;
  end;

implementation

uses System.Sysutils, NotifyEvents, VCL.Controls, CustomExcelTable,
  ProgressInfo;

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
  // Если в ходе загрузки данных произошли ошибки (производитель не найден)
  if not OK then
  begin
    FfrmProgressBar.Hide;
    AfrmError := FCustomErrorFormClass.Create(nil);
    try
      AfrmError.ErrorTable := e.ExcelTable.Errors;
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
      {
        // Метод, обрабатывающий нашу таблицу
        procedure
        begin
        ProductGroup.qProducts.AppendList(e.ExcelTable as TProductsExcelTable);
        end,
      }
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
        // Отображаем общий прогресс записи
        FfrmProgressBar.UpdateWriteStatistic(FWriteProgress.TotalProgress);
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
AProcRef: TProcRef);
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
    TNotifyEventWrap.Create(AExcelDM.AfterLoadSheet, DoAfterLoadSheet);
    TNotifyEventWrap.Create(AExcelDM.OnTotalProgress, DoOnTotalReadProgress);
    FfrmProgressBar.Show;
    AExcelDM.LoadExcelFile2(AFileName);

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

end.
