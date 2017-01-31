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
  SearchMainComponent2;

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

  TLoadDocTable = class(TComponentsErrorTable)
  private
    function GetMark: TField;
    function GetFieldName: TField;
    function GetFileName: TField;
    function GetIDComponent: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DelMarked;
    procedure SetMark;
    property Mark: TField read GetMark;
    property FieldName: TField read GetFieldName;
    property FileName: TField read GetFileName;
    property IDComponent: TField read GetIDComponent;
  end;

  TAbsentDocTable = class(TComponentsErrorTable)
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddError(const AFolder, AComponentName, AErrorMessage: string);
  end;

  TComponentsBaseMasterDetail = class(TfrmMasterDetail)
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FBodyTypes: TQueryBodyTypes;
    FManufacturers: TQueryManufacturers2;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetDetailComponentsQuery: TQueryComponentsBaseDetail;
    function GetMainComponentsQuery: TQueryCustomComponents;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    { Private declarations }
  protected
    procedure DeleteLostComponents;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CheckAbsentDocFiles(ADocFieldInfos: TList<TDocFieldInfo>;
      const AIDCategory: Integer): TAbsentDocTable;
    procedure Commit; override;
    procedure LinkToDocFiles(ALoadDocTable: TLoadDocTable);
    function LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>;
      const AIDCategory: Integer): TLoadDocTable;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
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
  SettingsController, System.Types, FilesController, AllMainComponentsQuery,
  ProjectConst;

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
          if not TFilesController.Create.FileExists(ADocFieldInfo.Folder, S,
            sBodyTypesFilesExt) then
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

function TComponentsBaseMasterDetail.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);

  Result := FQuerySearchMainComponent2;
end;

function TComponentsBaseMasterDetail.LoadDocFiles(ADocFieldInfos
  : TList<TDocFieldInfo>; const AIDCategory: Integer): TLoadDocTable;
var
  ADocFieldInfo: TDocFieldInfo;
  AFileName: string;
  AFolder: string;
  d: TArray<String>;
  I: Integer;
  m: TStringDynArray;
  R0: MySplitRec;
  R1: MySplitRec;
  S: string;
  S2: string;
  SR: Integer;
  f: TArray<String>;
begin
  // Создаём таблицу с ошибками при привязке документации к компонентам
  Result := TLoadDocTable.Create(Self);

  I := 0;

  // Цикл по всем видам документов, которые будем загружать
  for ADocFieldInfo in ADocFieldInfos do
  begin
    m := TDirectory.GetFiles(ADocFieldInfo.Folder);
    if Length(m) = 0 then
      Continue;

    // Делим путь на части
    f := ADocFieldInfo.Folder.TrimRight(['\']).Split(['\']);
    Assert(Length(f) > 0);
    AFolder := f[Length(f) - 1];

    // Цикл по всем найденным файлам
    for S in m do
    begin
      AFileName := TPath.GetFileNameWithoutExtension(S);
      // Добавляем новую запись в таблицу
      Result.Append;
      Result.Folder.AsString := AFolder;
      Result.FileName.AsString := TPath.GetFileNameWithoutExtension(S);
      Result.FieldName.AsString := ADocFieldInfo.FieldName;

      Assert(not AFileName.IsEmpty);
      // Разделяем имя файла на границы диапазона
      d := AFileName.Split(['-']);

      // Если спецификация предназначена для одного компонента
      if Length(d) = 1 then
      begin
        Assert(not d[0].IsEmpty);
        Result.ComponentName.AsString := d[0];
        Assert(Result.ComponentName.AsString <> '');
        Result.Post;
      end
      else
      begin
        // Надо вычленить номера начала и конца диапазона
        R0 := MySplit(d[0]);
        R1 := MySplit(d[1]);

        if not R0.Number < R1.Number then
        begin
          Result.SetErrorMessage
            ('Компонент в начале диапазона должен имееть номер меньше чем номер компонента в конце диапазона');
          Continue;
        end;

        if R0.Number = 0 then
        begin
          Result.SetErrorMessage
            ('Компонент в начале диапазона должен имееть номер');
          Continue;
        end;

        if R0.Name <> R1.Name then
        begin
          Result.SetErrorMessage
            ('Компоненты в начале и в конце диапазона должны отличаться только номерами');
          Continue;
        end;
        for I := R0.Number to R1.Number do
        begin
          if not(Result.State in [dsInsert, dsEdit]) then
          begin
            Result.Append;
            Result.Folder.AsString := AFolder;
            Result.FileName.AsString := TPath.GetFileNameWithoutExtension(S);
            Result.FieldName.AsString := ADocFieldInfo.FieldName;
          end;
          Result.ComponentName.AsString := Format('%s%d', [R0.Name, I]);
          Assert(Result.ComponentName.AsString <> '');
          Result.Post;
        end;
        I := 0;
      end;

      // LoadDocFiles(AFieldName, AComponentList, S);
    end;

    // Этап второй - проверяем, все-ли компоненты присутствуют в базе данных
    // Фильтруем загруженные данные оставляя только одну папку
    Result.Filter := Format('FieldName=''%s''', [ADocFieldInfo.FieldName]);
    Result.Filtered := True;

    Result.First;
    while not Result.Eof do
    begin
      if Result.ComponentName.AsString = '' then
      begin
        Result.Next;
        Continue;
      end;

      SR := QuerySearchMainComponent2.Search(Result.ComponentName.AsString);
      if SR = 0 then
      begin
        // Считаем, что такого компонента в природе не существует
        Result.SetMark;
        // Result.SetErrorMessage(Format('Компонент %s не найден',
        // [Result.ComponentName.AsString]));
      end
      else
      begin
        if SR <> 1 then
        begin
          beep;
        end;

        Assert(SR = 1);
        if AIDCategory > 1 then
        begin
          S := Format(',%s,',
            [QuerySearchMainComponent2.CategoryIDList.AsString]);
          S2 := Format(',%d,', [AIDCategory]);
          I := S.IndexOf(S2);
        end;

        if (AIDCategory = 1) or (I >= 0) then
        begin

          Result.Edit;
          Result.IDComponent.AsInteger :=
            QuerySearchMainComponent2.PKValue;
          Result.Post;

          // Проверяем, может файл документации уже был загружен ранее
          S := QuerySearchMainComponent2.FDQuery.FieldByName
            (ADocFieldInfo.FieldName).AsString;

          if S <> '' then
          begin
            // Если компонент имеет другой файл документации
            if TPath.GetFileNameWithoutExtension(S) <> Result.FileName.AsString
            then
            begin
              if TFilesController.Create.FileExists(ADocFieldInfo.Folder, S,
                sBodyTypesFilesExt) then
              begin
                Result.SetErrorMessage(Format('Уже связан с файлом %s', [S]));
              end
              else
              begin
                Result.SetErrorMessage
                  (Format('Уже связан с файлом %s, но такой файл не найден',
                  [S]));
              end;
            end
            else
            begin
              // Компонент имеет тот-же самый файл документации
              if S = TPath.GetFileNameWithoutExtension(S) then
              begin
                Result.SetMark;
              end;
            end;
          end
        end
        else
        begin
          // Файл относится к компоненту из другой категории
          Result.SetMark;
        end;
      end;

      Result.Next;
    end;

    Result.Filtered := False;
    Result.Filter := '';

  end;
  Result.DelMarked;
  Result.First;

end;

procedure TComponentsBaseMasterDetail.LinkToDocFiles(ALoadDocTable
  : TLoadDocTable);
var
  AQueryAllMainComponents: TQueryAllMainComponents;
begin
  Assert(ALoadDocTable <> nil);
  if ALoadDocTable.RecordCount = 0 then
    Exit;

  // Создаём запрос выбирающий все или один компонент
  AQueryAllMainComponents := TQueryAllMainComponents.Create(Self);
  try
    // Будем работать в рамках одной транзакции
    AQueryAllMainComponents.AutoTransaction := False;

    ALoadDocTable.First;
    while not ALoadDocTable.Eof do
    begin
      if not ALoadDocTable.IDComponent.IsNull then
      begin
        // Выбираем компонент, который будем редактировать
        AQueryAllMainComponents.Load(['ID'], [ALoadDocTable.IDComponent.AsInteger]);
        AQueryAllMainComponents.TryEdit;
        AQueryAllMainComponents.Field(ALoadDocTable.FieldName.AsString).AsString :=
        ALoadDocTable.FileName.AsString;
        AQueryAllMainComponents.TryPost;
      end;
      ALoadDocTable.Next;
      // Извещаем всех о прогрессе
      ALoadDocTable.CallOnProcessEvent;
    end;
    AQueryAllMainComponents.FDQuery.Connection.Commit;
  finally
    FreeAndNil(AQueryAllMainComponents);
  end;
  // ALoadDocTable.EmptyDataSet;

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
    S := TPath.GetFileNameWithoutExtension(AFileName);
    Main.TryEdit;
    Main.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    Main.TryPost;
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

constructor TLoadDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('IDComponent', ftInteger);
  FieldDefs.Add('Folder', ftString, 100);
  FieldDefs.Add('ComponentName', ftString, 100);
  FieldDefs.Add('FileName', ftString, 100);
  FieldDefs.Add('Error', ftString, 20);
  FieldDefs.Add('Description', ftString, 150);
  FieldDefs.Add('FieldName', ftString, 100);
  FieldDefs.Add('Mark', ftInteger);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := 'Папка';
  ComponentName.DisplayLabel := 'Имя компонента';
  Description.DisplayLabel := 'Описание';
  Error.DisplayLabel := 'Вид ошибки';
  FileName.DisplayLabel := 'Имя файла';
  FieldName.Visible := False;
  Mark.Visible := False;
  IDComponent.Visible := False;
end;

procedure TLoadDocTable.DelMarked;
begin
  Assert(Filtered = False);
  Filter := 'Mark = 1';
  Filtered := True;
  while not Eof do
  begin
    Delete;
  end;
  Filtered := False;
  Filter := '';
end;

function TLoadDocTable.GetMark: TField;
begin
  Result := FieldByName('Mark');
end;

function TLoadDocTable.GetFieldName: TField;
begin
  Result := FieldByName('FieldName');
end;

function TLoadDocTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TLoadDocTable.GetIDComponent: TField;
begin
  Result := FieldByName('IDComponent');
end;

procedure TLoadDocTable.SetMark;
begin
  Assert(Active);

  if not(State in [dsEdit, dsInsert]) then
    Edit;
  Mark.AsInteger := 1;
  Post;
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

end.
