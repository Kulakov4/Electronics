unit ComponentsBaseMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, Data.DB,
  System.Generics.Collections, NotifyEvents, FireDAC.Comp.DataSet,
  Manufacturers2Query, BodyTypesQuery2, ExcelDataModule, CustomErrorTable,
  DocFieldInfo, SearchMainComponent, MasterDetailFrame, BodyTypesQuery,
  ComponentsBaseDetailQuery, CustomComponentsQuery,
  SearchMainComponent2, ProcRefUnit, SearchMainComponent3;

type
  TComponentsErrorTable = class(TCustomErrorTable)
  private
    function GetComponentName: TField;
    function GetDescription: TField;
    function GetError: TField;
    function GetFolder: TField;
  public
    procedure SetErrorMessage(AMessage: string);
    procedure SetWarringMessage(AMessage: string);
    procedure SkipError;
    procedure SkipErrorAndWarrings;
    property ComponentName: TField read GetComponentName;
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property Folder: TField read GetFolder;
  end;

  TLinkedDocTable = class(TCustomErrorTable)
  private
    function GetComponentName: TField;
    function GetFieldName: TField;
    function GetVisibleFileName: TField;
    function GetFileName: TField;
    function GetFolder: TField;
    function GetIDComponent: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property FieldName: TField read GetFieldName;
    property VisibleFileName: TField read GetVisibleFileName;
    property FileName: TField read GetFileName;
    property Folder: TField read GetFolder;
    property IDComponent: TField read GetIDComponent;
  end;

  TAbsentDocTable = class(TComponentsErrorTable)
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddError(const AFolder, AComponentName, AErrorMessage: string);
  end;

  TDocFilesTable = class(TCustomErrorTable)
  private
    function GetFieldName: TField;
    function GetFileName: TField;
    function GetRootFolder: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>);
    property FieldName: TField read GetFieldName;
    property FileName: TField read GetFileName;
    property RootFolder: TField read GetRootFolder;
  end;

  TComponentsBaseMasterDetail = class(TfrmMasterDetail)
  strict private
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FBodyTypes: TQueryBodyTypes;
    FManufacturers: TQueryManufacturers2;
    FQuerySearchMainComponent3: TQuerySearchMainComponent3;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetDetailComponentsQuery: TQueryComponentsBaseDetail;
    function GetMainComponentsQuery: TQueryCustomComponents;
    function GetQuerySearchMainComponent3: TQuerySearchMainComponent3;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    { Private declarations }
  protected
    procedure DeleteLostComponents;
    property QuerySearchMainComponent3: TQuerySearchMainComponent3
      read GetQuerySearchMainComponent3;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckAbsentDocFiles(ADocFieldInfos: TList<TDocFieldInfo>;
      const AIDCategory: Integer): TAbsentDocTable;
    procedure Commit; override;
    procedure LinkToDocFiles(ALinkedDocTable: TLinkedDocTable);
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    function ProcessDocFiles(ADocFilesTable: TDocFilesTable;
      const AIDCategory: Integer): TLinkedDocTable;
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property BodyTypes: TQueryBodyTypes read FBodyTypes write FBodyTypes;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property DetailComponentsQuery: TQueryComponentsBaseDetail
      read GetDetailComponentsQuery;
    property MainComponentsQuery: TQueryCustomComponents
      read GetMainComponentsQuery;
    property Manufacturers: TQueryManufacturers2 read FManufacturers
      write FManufacturers;
    { Public declarations }
  end;

implementation

uses LostComponentsQuery, RepositoryDataModule, System.Math, System.IOUtils,
  SettingsController, System.Types, AllMainComponentsQuery,
  ProjectConst, StrHelper, BaseQuery;

{$R *.dfm}

constructor TComponentsBaseMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  FFullDeleted := TList<Integer>.Create;

  // Создаём событие
  FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsBaseMasterDetail.Destroy;
begin
  FreeAndNil(FFullDeleted);
  inherited;
end;

// Удаляет "Потерянные" компоненты.
// Почему они теряются, надо ещё разобраться
procedure TComponentsBaseMasterDetail.DeleteLostComponents;
var
  AQuery: TDeleteLostComponentsQuery;
begin
  AQuery := TDeleteLostComponentsQuery.Create(Self);
  try
    AQuery.Connection := Main.FDQuery.Connection;
    // AQuery.Connection := FDTransaction.Connection;
    // AQuery.Transaction := FDTransaction;
    AQuery.ExecSQL;
  finally
    FreeAndNil(AQuery);
  end;
end;

type
  MySplitRec = record
    Name: string;
    Number: cardinal;
  end;

function MySplit(const S: String): MySplitRec;
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

function TComponentsBaseMasterDetail.CheckAbsentDocFiles(ADocFieldInfos
  : TList<TDocFieldInfo>; const AIDCategory: Integer): TAbsentDocTable;
var
  AAllComponents: TQueryAllMainComponents;
  AComponentsClone: TFDMemTable;
  ADocFieldInfo: TDocFieldInfo;
  AErrorMessage: string;
  AFolder: string;
  AFullName: string;
  f: TArray<String>;
  S: string;
begin
  AAllComponents := nil;

  // Создаём таблицу с компонентами у которых отсутствует документация
  Result := TAbsentDocTable.Create(Self);

  // Третий этап - ищем компоненты, для которых не задан (не найден) файл документации
  AComponentsClone := TFDMemTable.Create(Self);
  try

    if AIDCategory > 1 then
    begin
      // Создаём клон компонентов из текущей категории
      AComponentsClone.CloneCursor(Main.FDQuery);
    end
    else
    begin
      // Создаём клон всех компонентов
      AAllComponents := TQueryAllMainComponents.Create(Self);
      AAllComponents.RefreshQuery;
      AComponentsClone.CloneCursor(AAllComponents.FDQuery);
    end;

    // Цикл по всем видам документов, которые будем проверять
    for ADocFieldInfo in ADocFieldInfos do
    begin
      // Делим путь на части
      f := ADocFieldInfo.Folder.TrimRight(['\']).Split(['\']);
      Assert(Length(f) > 0);
      AFolder := f[Length(f) - 1];

      AComponentsClone.First;
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
      end;
    end;
    AComponentsClone.Close;
  finally
    FreeAndNil(AComponentsClone);
  end;

  if AAllComponents <> nil then
  begin
    FreeAndNil(AAllComponents);
  end;

  Result.First;
end;

procedure TComponentsBaseMasterDetail.Commit;
begin
  inherited;
  FFullDeleted.Clear;
end;

function TComponentsBaseMasterDetail.GetDetailComponentsQuery
  : TQueryComponentsBaseDetail;
begin
  Assert(Detail <> nil);
  Result := Detail as TQueryComponentsBaseDetail;
end;

function TComponentsBaseMasterDetail.GetMainComponentsQuery
  : TQueryCustomComponents;
begin
  Assert(Main <> nil);
  Result := Main as TQueryCustomComponents;
end;

function TComponentsBaseMasterDetail.GetQuerySearchMainComponent3
  : TQuerySearchMainComponent3;
begin
  if FQuerySearchMainComponent3 = nil then
    FQuerySearchMainComponent3 := TQuerySearchMainComponent3.Create(Self);

  Result := FQuerySearchMainComponent3;
end;

function TComponentsBaseMasterDetail.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);

  Result := FQuerySearchMainComponent2;
end;

procedure TComponentsBaseMasterDetail.LinkToDocFiles(ALinkedDocTable
  : TLinkedDocTable);
var
  AQueryAllMainComponents: TQueryAllMainComponents;
begin
  Assert(ALinkedDocTable <> nil);
  if ALinkedDocTable.RecordCount = 0 then
    Exit;

  // Создаём запрос выбирающий все или один компонент
  AQueryAllMainComponents := TQueryAllMainComponents.Create(Self);
  try
    // Будем работать в рамках одной транзакции
    AQueryAllMainComponents.AutoTransaction := False;

    ALinkedDocTable.First;
    // Извещаем всех о прогрессе
    ALinkedDocTable.CallOnProcessEvent;

    while not ALinkedDocTable.Eof do
    begin
      if not ALinkedDocTable.IDComponent.IsNull then
      begin
        // Выбираем компонент, который будем редактировать
        AQueryAllMainComponents.Load(['ID'],
          [ALinkedDocTable.IDComponent.AsInteger]);
        AQueryAllMainComponents.TryEdit;
        AQueryAllMainComponents.Field(ALinkedDocTable.FieldName.AsString)
          .AsString := ALinkedDocTable.FileName.AsString;
        AQueryAllMainComponents.TryPost;
      end;
      ALinkedDocTable.Next;
      // Извещаем всех о прогрессе
      ALinkedDocTable.CallOnProcessEvent;
    end;
    AQueryAllMainComponents.FDQuery.Connection.Commit;
  finally
    FreeAndNil(AQueryAllMainComponents);
  end;
  // ALinkedDocTable.EmptyDataSet;

  if not Main.HaveAnyChanges then
    Main.RefreshQuery;
end;

procedure TComponentsBaseMasterDetail.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: string;
begin
  if not AFileName.IsEmpty then
  begin
    // В БД храним путь до файла относительно папки с документацией
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    Main.TryEdit;
    Main.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    Main.TryPost;
  end;
end;

function TComponentsBaseMasterDetail.ProcessDocFiles(ADocFilesTable
  : TDocFilesTable; const AIDCategory: Integer): TLinkedDocTable;

  procedure Append(const AComponentName: String; const AIDComponent: Integer);
  begin
    Assert(not ADocFilesTable.IsEmpty);
    Assert(not AComponentName.IsEmpty);
    Assert(AIDComponent > 0);

    with Result do
    begin
      Append;
      // Ссылка на компонент
      IDComponent.AsInteger := AIDComponent;
      // В базе данных будем сохранять относительное имя файла
      FileName.AsString := StrHelper.GetRelativeFileName
        (ADocFilesTable.FileName.AsString, ADocFilesTable.RootFolder.AsString);

      // Отображаемое в отчёте имя файла
      VisibleFileName.AsString := TPath.GetFileName(ADocFilesTable.FileName.AsString);

      // Относительный путь из папок в которых находится файл
      Folder.AsString :=
        TPath.Combine(TPath.GetFileName(ADocFilesTable.RootFolder.AsString),
        TPath.GetDirectoryName(FileName.AsString));
      ComponentName.AsString := AComponentName;
      FieldName.AsString := ADocFilesTable.FieldName.AsString;
      Post;
    end;

  end;

  procedure LocateAndAppend(const AComponentName: String;
    AQueryBase: TQueryBase);
  var
    AIDComponent: Integer;
    i: Integer;
    OK: Boolean;
    AOldFileName: String;
    V: Variant;
  begin
    Assert(not ADocFilesTable.IsEmpty);
    Assert(not AComponentName.IsEmpty);
    Assert(AQueryBase <> nil);

    // Ищем в наборе данных на клиенте наш компонент по имени
    V := AQueryBase.FDQuery.LookupEx('Value', AComponentName,
      Format('%s;%s', [AQueryBase.PKFieldName,
      ADocFilesTable.FieldName.AsString]), []);

    // Если компонент найден
    if not VarIsNull(V) then
    begin
      AIDComponent := V[0]; // Идентификатор найденного компонента

      // Если раньше файл документаци был не задан
      OK := VarIsNull(V[1]);

      if not OK then
      begin
        AOldFileName := V[1]; // Файл документации найденного компонента

        if AOldFileName <> '' then
        begin
          // Получаем полное имя файла
          AOldFileName := TPath.Combine(ADocFilesTable.RootFolder.AsString,
            AOldFileName);

          // Если компонент имеет другой файл документации и такого файла не существует
          OK := (ADocFilesTable.FileName.AsString <> AOldFileName) and
            (not TFile.Exists(AOldFileName));
        end;
      end;
      if OK then
        Append(AComponentName, AIDComponent);
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

  // Создаём таблицу с теми файлами которые мы будем сопоставлять компонентам
  Result := TLinkedDocTable.Create(Self);

  ADocFilesTable.First;
  ADocFilesTable.CallOnProcessEvent;

  while not ADocFilesTable.Eof do
  begin
    AFileName := TPath.GetFileNameWithoutExtension
      (ADocFilesTable.FileName.AsString);

    // Разделяем имя файла на границы диапазона
    d := AFileName.Split(['-']);

    // Если файл документации предназначен для одного компонента
    if Length(d) = 1 then
    begin
      Assert(not d[0].IsEmpty);
      if QuerySearchMainComponent2.Search(d[0]) > 0 then
        Append(d[0], QuerySearchMainComponent2.PKValue);
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
        // Если найдены близкие по имени компоненты
        if QuerySearchMainComponent3.Search(R0.Name) > 0 then
        begin
          // Цикл по всем номерам компонентов, входящих в диапазон
          for i := R0.Number to R1.Number do
          begin
            LocateAndAppend(Format('%s%d', [R0.Name, i]),
              QuerySearchMainComponent3);
            ADocFilesTable.CallOnProcessEvent;
          end;
        end;
      end;
    end;

    ADocFilesTable.Next;
    ADocFilesTable.CallOnProcessEvent;
  end;
end;

procedure TComponentsBaseMasterDetail.ReOpen;
begin
  // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
  Detail.RefreshQuery;
  Main.RefreshQuery;
end;

procedure TComponentsBaseMasterDetail.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

constructor TLinkedDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('IDComponent', ftInteger);
  FieldDefs.Add('Folder', ftString, 500);
  FieldDefs.Add('ComponentName', ftString, 200);
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('VisibleFileName', ftString, 100);
  FieldDefs.Add('FieldName', ftString, 100);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := 'Папка';
  ComponentName.DisplayLabel := 'Имя компонента';
  VisibleFileName.DisplayLabel := 'Имя файла';

  FileName.Visible := False;
  FieldName.Visible := False;
  IDComponent.Visible := False;
end;

function TLinkedDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TLinkedDocTable.GetFieldName: TField;
begin
  Result := FieldByName('FieldName');
end;

function TLinkedDocTable.GetVisibleFileName: TField;
begin
  Result := FieldByName('VisibleFileName');
end;

function TLinkedDocTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TLinkedDocTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

function TLinkedDocTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

constructor TAbsentDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('Folder', ftString, 100);
  FieldDefs.Add('ComponentName', ftString, 100);
  FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := 'Папка';
  ComponentName.DisplayLabel := 'Имя компонента';
  Description.DisplayLabel := 'Описание';
  Error.DisplayLabel := 'Вид ошибки';
end;

procedure TAbsentDocTable.AddError(const AFolder, AComponentName,
  AErrorMessage: string);
begin
  Assert(Active);

  Append;
  Folder.AsString := AFolder;
  ComponentName.AsString := AComponentName;
  Error.AsString := ErrorMessage;
  Description.AsString := AErrorMessage;
  Post;
end;

function TComponentsErrorTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TComponentsErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TComponentsErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TComponentsErrorTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

procedure TComponentsErrorTable.SetErrorMessage(AMessage: string);
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Edit;
  Error.AsString := ErrorMessage;
  Description.AsString := AMessage;
  Post;
end;

procedure TComponentsErrorTable.SetWarringMessage(AMessage: string);
begin
  Assert(RecordCount > 0);

  if not(State in [dsEdit, dsInsert]) then
    Edit;
  Error.AsString := WarringMessage;
  Description.AsString := AMessage;
  Post;
end;

procedure TComponentsErrorTable.SkipError;
begin
  Filter := Format('(Error = null) or (Error = ''%s'')', [WarringMessage]);
  Filtered := True;
end;

procedure TComponentsErrorTable.SkipErrorAndWarrings;
begin
  Filter := '(Error = null)';
  Filtered := True;
end;

constructor TDocFilesTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('RootFolder', ftString, 500);
  FieldDefs.Add('FieldName', ftString, 100);

  CreateDataSet;

  Open;
end;

function TDocFilesTable.GetFieldName: TField;
begin
  Result := FieldByName('FieldName');
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
    ASubFolder: string;
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
        FieldName.AsString := ADocFieldInfo.FieldName;
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

end.
