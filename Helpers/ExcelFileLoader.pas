unit ExcelFileLoader;

interface

uses
  ExcelDataModule, CustomExcelTable, NotifyEvents;

type
  // Ссылка на метод обрабатывающий Excel таблицу
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

  // Загружаем данные из Excel файла
  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    AfrmProgressBar.Caption := 'Загрузка данных из Excel документа';
    AfrmProgressBar.Show;
    // Подписываемся на событие
    ne := TNotifyEventR.Create(AExcelDM.OnProgress,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
    try
      // загружаем данные из Excel файла
      AExcelDM.LoadExcelFile(AFileName);
    finally
      FreeAndNil(ne); // Отписываемся от события
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

  // Загружаем данные из Excel файла
  AfrmProgressBar := TfrmProgressBar.Create(nil);
  try
    AfrmProgressBar.Caption := 'Сохраняем данные в БД';
    AfrmProgressBar.Show;
    // Подписываемся на событие
    ne := TNotifyEventR.Create(AExcelTable.OnProgress,
      procedure(ASender: TObject)
      begin
        AfrmProgressBar.ProgressInfo.Assign(ASender as TProgressInfo);
      end);
    try
      // Сохраняем данные в базе данных
      AExcelTableProcessRef(AExcelTable);
    finally
      FreeAndNil(ne); // Отписываемся от события
    end;
  finally
    FreeAndNil(AfrmProgressBar);
  end;

end;

end.
