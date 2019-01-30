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
        qAllFamily.W.TryEdit;
        // Если спецификация задана
        if not ADocBindExcelTable.Datasheet.AsString.IsEmpty then
        begin
          // Файл документации должен лежать в папке с именем производителя
          qAllFamily.W.Datasheet.F.AsString :=
            TPath.Combine(qAllFamily.W.Producer.F.AsString,
            ADocBindExcelTable.Datasheet.AsString);
        end;
        // Если функциональная диаграмма задана
        if not ADocBindExcelTable.Diagram.AsString.IsEmpty then
        begin
          qAllFamily.W.Diagram.F.AsString :=
            TPath.Combine(qAllFamily.W.Producer.F.AsString,
            ADocBindExcelTable.Diagram.AsString);
        end;
        qAllFamily.W.TryPost;
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
// var
// ADocBindExcelDM: TDocBindExcelDM;
// AfrmError: TfrmError;
// OK: Boolean;
begin
  Assert(not AFileName.IsEmpty);

  TLoad.Create.LoadAndProcess(AFileName, TDocBindExcelDM, TfrmCustomError,
    procedure(ASender: TObject)
    begin
      // Выполняем привязку
      DoBindDocs(ASender as TDocBindExcelTable);
    end);
end;

end.
