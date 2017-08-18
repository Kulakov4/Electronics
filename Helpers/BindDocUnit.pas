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
    // начинаем транзакцию, если она ещё не началась
    if (not qAllFamily.FDQuery.Connection.InTransaction) then
      qAllFamily.FDQuery.Connection.StartTransaction;
    ADocBindExcelTable.First;
    ADocBindExcelTable.CallOnProcessEvent;
    i := 0;
    while not ADocBindExcelTable.Eof do
    begin
      // Пытаемся найти семейство с таким идентификатором
      qAllFamily.Load(['ID'], [ADocBindExcelTable.IDProduct.AsInteger]);
      if qAllFamily.FDQuery.RecordCount = 1 then
      begin
        qAllFamily.TryEdit;
        // Файл документации должен лежать в папке с именем производителя
        qAllFamily.Datasheet.AsString :=
          TPath.Combine(qAllFamily.Producer.AsString,
          ADocBindExcelTable.Datasheet.AsString);
        qAllFamily.Diagram.AsString :=
          TPath.Combine(qAllFamily.Producer.AsString,
          ADocBindExcelTable.Diagram.AsString);
        qAllFamily.TryPost;
        Inc(i);
        // Уже много записей обновили в рамках одной транзакции
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
    // Первый этап - загружаем данные из Excel файла
    TfrmProgressBar.Process(ADocBindExcelDM,
      procedure (ASender: TObject)
      begin
        ADocBindExcelDM.LoadExcelFile(AFileName);
      end, 'Загрузка данных о файлах документации из Excel документа', sRows);

    // Второй этап - отображаем окно с ошибками
    OK := ADocBindExcelDM.ExcelTable.Errors.RecordCount = 0;

    if not OK then
    begin
      AfrmError := TfrmError.Create(nil);
      try
        AfrmError.ErrorTable := ADocBindExcelDM.ExcelTable.Errors;
        // Показываем ошибки (семейство не найдено)
        OK := AfrmError.ShowModal = mrOk;
        ADocBindExcelDM.ExcelTable.ExcludeErrors(etError);
      finally
        FreeAndNil(AfrmError);
      end;
    end;

    // Третий этап - сохраняем в базе данных
    if OK then
    begin
      TfrmProgressBar.Process(ADocBindExcelDM.ExcelTable,
        procedure (ASender: TObject)
        begin
          DoBindDocs(ADocBindExcelDM.ExcelTable);
        end, 'Выполнение привязки к документации', sComponents);
    end;
  finally
    FreeAndNil(ADocBindExcelDM);
  end;
end;

end.
