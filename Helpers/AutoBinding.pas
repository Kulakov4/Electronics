unit AutoBinding;

interface

uses
  System.Classes, DocFieldInfo, System.Generics.Collections,
  FireDAC.Comp.Client, TableWithProgress, Data.DB,
  SearchProductParameterValuesQuery, DocBindExcelDataModule;

type
  MySplitRec = record
    Name: string;
    Number: cardinal;
  end;

  TDocFilesTable = class(TTableWithProgress)
  private
    function GetIDParameter: TField;
    function GetFileName: TField;
    function GetRootFolder: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>);
    property IDParameter: TField read GetIDParameter;
    property FileName: TField read GetFileName;
    property RootFolder: TField read GetRootFolder;
  end;

  TAbsentDocTable = class(TFDMemTable)
  private
    function GetComponentName: TField;
    function GetFolder: TField;
    function GetDescription: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddError(const AFolder, AComponentName, AErrorMessage: string);
    property ComponentName: TField read GetComponentName;
    property Folder: TField read GetFolder;
    property Description: TField read GetDescription;
  end;

  TPossibleLinkDocTable = class(TTableWithProgress)
  private
    function GetComponentName: TField;
    function GetRange: TField;
    function GetFileName: TField;
    function GetRootFolder: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Range: TField read GetRange;
    property FileName: TField read GetFileName;
    property RootFolder: TField read GetRootFolder;
  end;

type
  TErrorLinkedDocTable = class(TTableWithProgress)
  private
    function GetComponentName: TField;
    function GetFolder: TField;
    function GetErrorMessage: TField;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Folder: TField read GetFolder;
    property ErrorMessage: TField read GetErrorMessage;
  end;

  TAutoBind = class(TObject)
  private
    class function AnalizeDocFiles(ADocFilesTable: TDocFilesTable)
      : TDictionary<Integer, TPossibleLinkDocTable>; static;
    class function CheckAbsentDocFiles(ADocFieldInfos: TList<TDocFieldInfo>;
      const AFDQuery: TFDQuery): TAbsentDocTable; static;
    class function LinkToDocFiles(APossibleLinkDocTables
      : TDictionary<Integer, TPossibleLinkDocTable>;
      const AComponentsDataSet: TTableWithProgress;
      ADocFieldInfos: TList<TDocFieldInfo>; AConnection: TFDCustomConnection;
      const ANoRange: Boolean): TErrorLinkedDocTable; static;
    class function MySplit(const S: String): MySplitRec; static;
  protected
  public
    class procedure BindDescriptions(const AIDCategory: Integer); static;
    class procedure BindDocs(ADocFieldInfos: TList<TDocFieldInfo>;
      const AFDQuery: TFDQuery; const ANoRange, ACheckAbsentDocFiles
      : Boolean); static;
  end;

implementation

uses cxGridDbBandedTableView, GridViewForm, ProgressBarForm, System.SysUtils,
  System.IOUtils, DialogUnit, StrHelper, System.Types, SearchDescriptionsQuery,
  System.StrUtils, ProjectConst;

class function TAutoBind.AnalizeDocFiles(ADocFilesTable: TDocFilesTable)
  : TDictionary<Integer, TPossibleLinkDocTable>;

  procedure Append(AIDParameter: Integer; const AComponentName: String;
    const ARange: cardinal);
  begin
    Assert(AIDParameter > 0);
    Assert(not AComponentName.IsEmpty);

    // Если такой таблицы в памяти ещё не существовало
    if not Result.ContainsKey(AIDParameter) then
      Result.Add(AIDParameter, TPossibleLinkDocTable.Create(nil));

    with Result[AIDParameter] do
    begin
      Append;
      FileName.AsString := ADocFilesTable.FileName.AsString;
      RootFolder.AsString := ADocFilesTable.RootFolder.AsString;
      ComponentName.AsString := AComponentName;
      Range.AsInteger := ARange;
      Post;

    end;
  end;

var
  AFileName: string;
  d: TArray<String>;
  i: Integer;
  OK: Boolean;
  R0: MySplitRec;
  R1: MySplitRec;

begin
  Assert(ADocFilesTable <> nil);

  // Создаём словарь из таблиц с теми файлами которые мы будем сопоставлять компонентам
  Result := TDictionary<Integer, TPossibleLinkDocTable>.Create;

  ADocFilesTable.First;
  ADocFilesTable.CallOnProcessEvent;

  // Цикл по всем найденным файлам
  while not ADocFilesTable.Eof do
  begin
    AFileName := TPath.GetFileNameWithoutExtension
      (ADocFilesTable.FileName.AsString);

    // Разделяем имя файла на границы диапазона
    d := AFileName.Split(['-']);

    // Если файл документации предназначен для одного компонента
    if Length(d) = 1 then
    begin
      Append(ADocFilesTable.IDParameter.AsInteger, d[0], 1);
    end
    else
    begin
      // Надо вычленить номера начала и конца диапазона
      R0 := MySplit(d[0]);
      R1 := MySplit(d[1]);

      // ('Компонент в начале диапазона должен имееть номер меньше чем номер компонента в конце диапазона');
      // ('Компонент в начале диапазона должен имееть номер');
      // ('Компоненты в начале и в конце диапазона должны отличаться только номерами');
      OK := (R0.Number < R1.Number) and (R0.Number > 0) and (R0.Name = R1.Name);

      if OK then
      begin
        // Цикл по всем номерам компонентов, входящих в диапазон
        for i := R0.Number to R1.Number do
        begin
          Append(ADocFilesTable.IDParameter.AsInteger,
            Format('%s%d', [R0.Name, i]), R1.Number - R0.Number);
          ADocFilesTable.CallOnProcessEvent;
        end;

      end;
    end;

    ADocFilesTable.Next;
    ADocFilesTable.CallOnProcessEvent;
  end;
end;

class procedure TAutoBind.BindDescriptions(const AIDCategory: Integer);
var
  AQuerySearchDescriptions: TQuerySearchDescriptions;
begin
  // Привязываем компоненты к кратким описаниям
  AQuerySearchDescriptions := TQuerySearchDescriptions.Create(nil);
  try
    // Если какя-то отдельная категория
    if AIDCategory > 0 then
      AQuerySearchDescriptions.Search(AIDCategory)
    else
      AQuerySearchDescriptions.FDQuery.Open;

    // Если найдены компоненты, которые можно привязать
    if AQuerySearchDescriptions.FDQuery.RecordCount > 0 then
    begin
      TfrmProgressBar.Process(AQuerySearchDescriptions,
        AQuerySearchDescriptions.UpdateComponentDescriptions,
        'Выполняем привязку кратких описаний', sComponents);
    end;
  finally
    FreeAndNil(AQuerySearchDescriptions);
  end;

end;

class procedure TAutoBind.BindDocs(ADocFieldInfos: TList<TDocFieldInfo>;
  const AFDQuery: TFDQuery; const ANoRange, ACheckAbsentDocFiles: Boolean);
var
  AAbsentDocTable: TAbsentDocTable;
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
  ADocFilesTable: TDocFilesTable;
  AfrmGridView: TfrmGridView;
  AErrorLinkedDocTable: TErrorLinkedDocTable;
  AIDParameter: Integer;
  APossibleLinkDocTables: TDictionary<Integer, TPossibleLinkDocTable>;
  ATableWithProgress: TTableWithProgress;
  OK: Boolean;
begin
  Assert(AFDQuery <> nil);
  if AFDQuery.RecordCount = 0 then
  begin
    TDialog.Create.ErrorMessageDialog
      ('Нет компонентов в выбранной категории либо в БД');
    Exit;
  end;

  // Создаём таблицу со всеми файлами документации
  ADocFilesTable := TDocFilesTable.Create(nil);
  try
    // Просим загрузить список файлов
    ADocFilesTable.LoadDocFiles(ADocFieldInfos);

    TfrmProgressBar.Process(ADocFilesTable,
      procedure (ASender: TObject)
      begin
        // Просим проанализировать, к каким компонентам можно привязать эти файлы
        APossibleLinkDocTables := AnalizeDocFiles(ADocFilesTable);
      end, 'Анализ найденных файлов документации', sFiles);
  finally
    FreeAndNil(ADocFilesTable);
  end;

  OK := False;
  for AIDParameter in APossibleLinkDocTables.Keys do
  begin
    OK := APossibleLinkDocTables[AIDParameter].RecordCount > 0;
    if OK then
      break;
  end;

  // Если есть что привязывать
  if OK then
  begin
    ATableWithProgress := TTableWithProgress.Create(nil);
    try
      // Клонируем курсор с компонентами
      ATableWithProgress.CloneCursor(AFDQuery);
      // Для того чтобы знать общее кол-во записей
      ATableWithProgress.Last;

      TfrmProgressBar.Process(ATableWithProgress,
        procedure (ASender: TObject)
        begin
          // Просим привязать компоненты к файлам
          AErrorLinkedDocTable := LinkToDocFiles(APossibleLinkDocTables,
            ATableWithProgress, ADocFieldInfos, AFDQuery.Connection, ANoRange);
        end, 'Поиск подходящих файлов документации', sComponents);

    finally
      FreeAndNil(ATableWithProgress);
    end;

    // Если в ходе привязки были ошибки
    if AErrorLinkedDocTable.RecordCount > 0 then
    begin
      // Отображаем список ошибок возникших при привязке
      AfrmGridView := TfrmGridView.Create(nil);
      try
        with AfrmGridView do
        begin
          Caption := 'Ошибки привязки компонентов к файлам документации';
          DataSet := AErrorLinkedDocTable;
          // Показываем что мы собираемся привязывать
          ShowModal;
        end;
      finally
        FreeAndNil(AfrmGridView);
      end;
    end;
  end
  else
  begin
    TDialog.Create.ComponentsDocFilesNotFound;
  end;

  for AIDParameter in APossibleLinkDocTables.Keys do
  begin
    // Разрушаем таблицу в памяти
    APossibleLinkDocTables[AIDParameter].Free;
  end;
  // Разрушаем сам словарь
  FreeAndNil(APossibleLinkDocTables);

  // Если нужно вывести отчёт об отсутсвующих файлах документации
  if ACheckAbsentDocFiles then
  begin

    // Проверяем на отсутсвующие файлы
    AAbsentDocTable := CheckAbsentDocFiles(ADocFieldInfos, AFDQuery);
    try
      // Если есть компоненты для которых отсутствует документация
      if AAbsentDocTable.RecordCount > 0 then
      begin
        AfrmGridView := TfrmGridView.Create(nil);
        try
          AfrmGridView.Caption :=
            'Компоненты для которых отсутствует документация';
          AfrmGridView.DataSet := AAbsentDocTable;
          AcxGridDBBandedColumn :=
            AfrmGridView.ViewGrid.MainView.GetColumnByFieldName
            (AAbsentDocTable.Folder.FieldName);
          Assert(AcxGridDBBandedColumn <> nil);
          AcxGridDBBandedColumn.GroupIndex := 0;
          AcxGridDBBandedColumn.Visible := False;
          // Показываем отчёт
          AfrmGridView.ShowModal;
        finally
          FreeAndNil(AfrmGridView);
        end;
      end;

    finally
      FreeAndNil(AAbsentDocTable);
    end;
  end;
end;

class function TAutoBind.CheckAbsentDocFiles(ADocFieldInfos
  : TList<TDocFieldInfo>; const AFDQuery: TFDQuery): TAbsentDocTable;
var
  AComponentsClone: TTableWithProgress;
  ADocFieldInfo: TDocFieldInfo;
  AErrorMessage: string;
  AFolder: string;
  AFullName: string;
  f: TArray<String>;
  S: string;
begin
  Assert(AFDQuery <> nil);

  // Создаём таблицу с компонентами у которых отсутствует документация
  Result := TAbsentDocTable.Create(nil);

  // Третий этап - ищем компоненты, для которых не задан (не найден) файл документации
  AComponentsClone := TTableWithProgress.Create(nil);
  try
    // Создаём клон компонентов
    AComponentsClone.CloneCursor(AFDQuery);

    // Цикл по всем видам документов, которые будем проверять
    for ADocFieldInfo in ADocFieldInfos do
    begin
      // Делим путь на части
      f := ADocFieldInfo.Folder.TrimRight(['\']).Split(['\']);
      Assert(Length(f) > 0);
      AFolder := f[Length(f) - 1];

      AComponentsClone.First;
      AComponentsClone.CallOnProcessEvent;

      while not AComponentsClone.Eof do
      begin
        AErrorMessage := '';

        S := AComponentsClone.FieldByName(ADocFieldInfo.FieldName).AsString;
        // Если компонент имеет файл документации
        if S <> '' then
        begin
          AFullName := TPath.Combine(ADocFieldInfo.Folder, S);
          if not TFile.Exists(AFullName) then
            AErrorMessage :=
              Format('Cвязан с файлом %s, но файл не найден', [S]);
        end
        else
        begin
          // Если файл с документацией не задан
          AErrorMessage := 'Не задан файл документации';
        end;

        if AErrorMessage <> '' then
          Result.AddError(AFolder, AComponentsClone.FieldByName('Value')
            .AsString, AErrorMessage);

        AComponentsClone.Next;
        AComponentsClone.CallOnProcessEvent;
      end;
    end;
    AComponentsClone.Close;
  finally
    FreeAndNil(AComponentsClone);
  end;

  Result.First;
end;

class function TAutoBind.LinkToDocFiles(APossibleLinkDocTables
  : TDictionary<Integer, TPossibleLinkDocTable>;
const AComponentsDataSet: TTableWithProgress;
ADocFieldInfos: TList<TDocFieldInfo>; AConnection: TFDCustomConnection;
const ANoRange: Boolean): TErrorLinkedDocTable;

  procedure AppendError(APossibleLinkDocTable: TPossibleLinkDocTable);
  Var
    AFolder: string;
    S: String;
  begin
    S := '';
    APossibleLinkDocTable.First;

    AFolder := TPath.Combine
      (TPath.GetFileName(APossibleLinkDocTable.RootFolder.AsString),
      TPath.GetDirectoryName(GetRelativeFileName(APossibleLinkDocTable.FileName.
      AsString, APossibleLinkDocTable.RootFolder.AsString)));

    while not APossibleLinkDocTable.Eof do
    begin
      S := IfThen(S.IsEmpty, '', S + ', ');
      S := S + TPath.GetFileNameWithoutExtension
        (APossibleLinkDocTable.FileName.AsString);
      APossibleLinkDocTable.Next;
    end;

    Result.Append;
    Result.ComponentName.AsString :=
      APossibleLinkDocTable.ComponentName.AsString;
    Result.Folder.AsString := AFolder;
    Result.ErrorMessage.AsString :=
      Format('Несколько возможных файлов (%s)', [S]);
    Result.Post;
  end;

var
  ADocFieldInfo: TDocFieldInfo;
  APossibleLinkDocTable: TPossibleLinkDocTable;
  ASQL: string;
  i: Integer;
  OK: Boolean;
  Q: TQuerySearchProductParameterValues;
  rc: Integer;
  S: String;
begin
  Assert(APossibleLinkDocTables <> nil);
  Assert(AComponentsDataSet <> nil);
  Result := TErrorLinkedDocTable.Create(nil);

  AComponentsDataSet.BeginBatch();
  // Список всех компонентов
  AComponentsDataSet.First;
  AComponentsDataSet.CallOnProcessEvent;

  Q := TQuerySearchProductParameterValues.Create(nil);
  // Будем работать в рамках одной транзакции
  AConnection.StartTransaction;
  try
    i := 0;
    while not AComponentsDataSet.Eof do
    begin
      // Цикл по всем типам файлов
      for ADocFieldInfo in ADocFieldInfos do
      begin
        // Если компонент ещё не имеет файла документации данного вида
        if (AComponentsDataSet.FieldByName(ADocFieldInfo.FieldName)
          .AsString.IsEmpty) then
        begin
          // Если для этого параметра существует таблица с возможными файлами
          if APossibleLinkDocTables.ContainsKey(ADocFieldInfo.IDParameter) then
          begin
            APossibleLinkDocTable := APossibleLinkDocTables
              [ADocFieldInfo.IDParameter];
            // Ищем есть ли для этого компонента подходящие файлы подходящего типа
            APossibleLinkDocTable.Filter :=
              Format('%s = %s', [APossibleLinkDocTable.ComponentName.FieldName,
              QuotedStr(AComponentsDataSet.FieldByName('Value').AsString)]);
            APossibleLinkDocTable.Filtered := True;

            rc := APossibleLinkDocTable.RecordCount;
            // Если нашли хотя-бы один подходящий файл
            if rc > 0 then
            begin
              // Первая запись - с самым узким диапазоном
              APossibleLinkDocTable.First;
              // Если подходящих файлов ровно 1 либо можно выбрать с самым узким диапазоном
              OK := (rc = 1) or (not ANoRange);
              // Если подходящих файлов несколько
              if not OK then
              begin
                // Имя файла без расширения
                S := TPath.GetFileNameWithoutExtension
                  (APossibleLinkDocTable.FileName.AsString);
                // если первый из нескольких файлов в точности равен названию компонента
                OK := string.Compare(S,
                  APossibleLinkDocTable.ComponentName.AsString, True) = 0;
                // Всё таки несколько файлов и ни один точно компоненту не соответствует
                if not OK then
                begin
                  // Добавляем сообщение об ошибке
                  AppendError(APossibleLinkDocTable);
                end;
              end;

              if OK then
              begin
                with Result do
                begin
                  S := StrHelper.GetRelativeFileName
                    (APossibleLinkDocTable.FileName.AsString,
                    APossibleLinkDocTable.RootFolder.AsString);

                  if Q.Search(ADocFieldInfo.IDParameter,
                    AComponentsDataSet.FieldByName('ID').AsInteger) = 0 then
                  begin
                    ASQL := 'INSERT INTO ParameterValues' +
                      '(ParameterID, Value, ProductID) ' +
                      Format('Values (%d, ''%s'', %d)',
                      [ADocFieldInfo.IDParameter, S,
                      AComponentsDataSet.FieldByName('ID').AsInteger]);

                    AConnection.ExecSQL(ASQL);
                    Inc(i);
                  end;

                  if i >= 1000 then
                  begin
                    AConnection.Commit;
                    AConnection.StartTransaction;
                    i := 0;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      AComponentsDataSet.Next;
      AComponentsDataSet.CallOnProcessEvent;
    end;
  finally
    AConnection.Commit;
    AComponentsDataSet.EndBatch;
    FreeAndNil(Q);
  end;
end;

class function TAutoBind.MySplit(const S: String): MySplitRec;
var
  StartIndex: Integer;
begin
  Result.Name := S;
  Result.Number := 0;

  StartIndex := S.Length - 1;

  // Пока в конце строки находим цифру
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    StartIndex) = StartIndex do
    Dec(StartIndex);

  Inc(StartIndex);

  // Если в конце строки были цифры
  if StartIndex < S.Length then
  begin
    Result.Number := StrToInt(S.Substring(StartIndex));
    Result.Name := S.Substring(0, StartIndex);
  end;
end;

constructor TAbsentDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('Folder', ftString, 100);
  FieldDefs.Add('ComponentName', ftString, 100);
  // FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := 'Папка';
  ComponentName.DisplayLabel := 'Имя компонента';
  Description.DisplayLabel := 'Описание';
  // Error.DisplayLabel := 'Вид ошибки';
end;

procedure TAbsentDocTable.AddError(const AFolder, AComponentName,
  AErrorMessage: string);
begin
  Assert(Active);

  Append;
  Folder.AsString := AFolder;
  ComponentName.AsString := AComponentName;
  // Error.AsString := ErrorMessage;
  Description.AsString := AErrorMessage;
  Post;
end;

function TAbsentDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TAbsentDocTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

function TAbsentDocTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

constructor TDocFilesTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('RootFolder', ftString, 500);
  FieldDefs.Add('IDParameter', ftInteger);

  CreateDataSet;

  Open;
end;

function TDocFilesTable.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TDocFilesTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TDocFilesTable.GetRootFolder: TField;
begin
  Result := FieldByName('RootFolder');
end;

procedure TDocFilesTable.LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>);

  procedure AddFiles(ADocFieldInfo: TDocFieldInfo; const AFolder: String);
  Var
    // ASubFolder: string;
    m: TStringDynArray;
    S: string;
  begin
    m := TDirectory.GetFiles(AFolder);
    if Length(m) > 0 then
    begin

      // Цикл по всем найденным файлам
      for S in m do
      begin
        // Добавляем в таблицу запись о найденном файле
        Append;
        RootFolder.AsString := ADocFieldInfo.Folder;
        FileName.AsString := S;
        IDParameter.AsInteger := ADocFieldInfo.IDParameter;
        Post;
      end;
    end;

    // Получаем список дочерних директорий
    m := TDirectory.GetDirectories(AFolder);

    // Для каждой дочерней директории
    for S in m do
    begin
      // Рекурсивно получаем файлы в этой директории
      AddFiles(ADocFieldInfo, S);
    end;

  end;

var
  ADocFieldInfo: TDocFieldInfo;

begin
  // Цикл по всем видам документов, которые будем загружать
  for ADocFieldInfo in ADocFieldInfos do
  begin
    AddFiles(ADocFieldInfo, ADocFieldInfo.Folder);
  end;

end;

constructor TPossibleLinkDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('RootFolder', ftString, 500);
  FieldDefs.Add('ComponentName', ftString, 200);
  FieldDefs.Add('Range', ftInteger);
  IndexDefs.Add('idxOrder', 'ComponentName;Range', []);

  CreateDataSet;
  IndexName := 'idxOrder';
  Indexes[0].Active := True;

  Open;

end;

function TPossibleLinkDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TPossibleLinkDocTable.GetRange: TField;
begin
  Result := FieldByName('Range');
end;

function TPossibleLinkDocTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TPossibleLinkDocTable.GetRootFolder: TField;
begin
  Result := FieldByName('RootFolder');
end;

constructor TErrorLinkedDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ComponentName', ftString, 200);
  FieldDefs.Add('Folder', ftString, 500);
  FieldDefs.Add('ErrorMessage', ftString, 1000);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := 'Папка';
  ComponentName.DisplayLabel := 'Имя компонента';
  ErrorMessage.DisplayLabel := 'Сообщение об ошибке';
end;

function TErrorLinkedDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TErrorLinkedDocTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

function TErrorLinkedDocTable.GetErrorMessage: TField;
begin
  Result := FieldByName('ErrorMessage');
end;

end.
