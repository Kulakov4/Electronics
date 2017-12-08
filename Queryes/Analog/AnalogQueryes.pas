unit AnalogQueryes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ParametersForCategoryQuery, TableWithProgress, Data.DB,
  System.Generics.Collections, UniqueParameterValuesQuery, Sort.StringList,
  System.StrUtils, FireDAC.Comp.Client, DBRecordHolder, StrHelper,
  SearchProductByParamValuesQuery, System.Math;

type
  TParameterValuesTable = class(TTableWithProgress)
  private
    FDefaultCheckedValues: string;
    function GetChecked: TField;
    function GetID: TField;
    function GetValue: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRec(const AID: Integer; const AValue: string);
    procedure CheckDefault;
    procedure CheckNear;
    procedure CheckRecord(const AChecked: Boolean);
    procedure CheckRecords(const AValues: string);
    function GetCheckedValues(const ADelimiter: string;
      const AQuote: Char): String;
    procedure SetAsDefaultValues;
    procedure UncheckAll;
    property Checked: TField read GetChecked;
    property DefaultCheckedValues: string read FDefaultCheckedValues
      write FDefaultCheckedValues;
    property ID: TField read GetID;
    property Value: TField read GetValue;
  end;

  TParamValues = class(TObject)
  private
    FCaption: String;
    FParameterID: Integer;
    FTable: TParameterValuesTable;
  public
    constructor Create(const ACaption: String; AParameterID: Integer);
    destructor Destroy; override;
    property Caption: String read FCaption;
    property ParameterID: Integer read FParameterID;
    property Table: TParameterValuesTable read FTable;
  end;

  TParamValuesList = class(TList<TParamValues>)
  public
    function FindByParameterID(AParameterID: Integer): TParamValues;
  end;

  TAnalogGroup = class(TQueryGroup)
  private
    FAllParameterFields: TDictionary<Integer, String>;
    FFDMemTable: TFDMemTable;
    FParamValuesList: TParamValuesList;
    FProductCategoryID: Integer;
    FqParametersForCategory: TQueryParametersForCategory;
    FqUniqueParameterValues: TQueryUniqueParameterValues;
    FTempTableName: String;

  const
    FFieldPrefix: string = 'Field';
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyFilter;
    procedure CheckDefault;
    procedure CheckNear;
    procedure Clear(AParameterID: Integer);
    function GetFieldName(AIDParameter: Integer): String;
    function GetParamIDByFieldName(const AFieldName: String): Integer;
    procedure Load(AProductCategoryID: Integer; ARecHolder: TRecordHolder);
    procedure SetAsDefaultValues;
    procedure UpdateParameterValues(AParameterID: Integer);
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property FDMemTable: TFDMemTable read FFDMemTable;
    property ParamValuesList: TParamValuesList read FParamValuesList;
    property qParametersForCategory: TQueryParametersForCategory
      read FqParametersForCategory;
    property qUniqueParameterValues: TQueryUniqueParameterValues
      read FqUniqueParameterValues;
    property TempTableName: String read FTempTableName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TAnalogGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqParametersForCategory := TQueryParametersForCategory.Create(Self);
  FqUniqueParameterValues := TQueryUniqueParameterValues.Create(Self);
  FParamValuesList := TParamValuesList.Create;
  FFDMemTable := TFDMemTable.Create(Self);
  FAllParameterFields := TDictionary<Integer, String>.Create;
  FTempTableName := 'search_analog_temp_table';
end;

destructor TAnalogGroup.Destroy;
begin
  FreeAndNil(FAllParameterFields);
  FreeAndNil(FParamValuesList);
  inherited;
end;

procedure TAnalogGroup.ApplyFilter;
var
  ACheckedValues: String;
  AParamValues: TParamValues;
  ASQL: string;
  Q: TqSearchProductByParamValues;
  S: string;
begin
  ASQL := '';

  Q := TqSearchProductByParamValues.Create(nil);

  // Цикл по всем отфильтрованным значениям параметров
  for AParamValues in ParamValuesList do
  begin
    ACheckedValues := AParamValues.Table.GetCheckedValues(',', '''');
    // Если по этому параметру не надо фильтровать
    if ACheckedValues.IsEmpty then
      Continue;

    S := Q.GetSQL(AParamValues.ParameterID,
      AParamValues.Table.GetCheckedValues(',', ''''));

    if not ASQL.IsEmpty then
      ASQL := ASQL + #13#10'intersect'#13#10;
    ASQL := ASQL + S;
  end;

  Assert(not FTempTableName.IsEmpty);

  // Сначала пытаемся удалить все записи
  Q.FDQuery.Connection.ExecSQL(Format('DELETE FROM %s', [FTempTableName]));
  Q.FDQuery.Connection.Commit;

  // Если хоть один фильтр надо наложить
  if not ASQL.IsEmpty then
  begin
    Q.FDQuery.SQL.Text := Format('INSERT INTO %s '#13#10'%s',
      [FTempTableName, ASQL]);
    // Q.FDQuery.SQL.SaveToFile('C:\public\sql.sql');
    Q.Execute(FProductCategoryID);
    Q.FDQuery.Connection.Commit;
  end;

  // Заполняем таблицу аналогов семейств
  Q.FDQuery.Connection.ExecSQL('DELETE FROM FamilyAnalog');
  Q.FDQuery.Connection.ExecSQL
    (Format('INSERT INTO FamilyAnalog SELECT DISTINCT FamilyID FROM %s',
    [FTempTableName]));
  Q.FDQuery.Connection.Commit;

  // Заполняем таблицу аналогов компонент
  Q.FDQuery.Connection.ExecSQL('DELETE FROM ProductsAnalog');
  Q.FDQuery.Connection.ExecSQL
    (Format('INSERT INTO ProductsAnalog SELECT DISTINCT ProductID FROM %s',
    [FTempTableName]));
  Q.FDQuery.Connection.Commit;
end;

procedure TAnalogGroup.CheckDefault;
var
  AParamValues: TParamValues;
begin
  // Цикл по всем значениям параметров
  for AParamValues in ParamValuesList do
  begin
    AParamValues.Table.CheckDefault;
    UpdateParameterValues(AParamValues.ParameterID);
  end;
end;

procedure TAnalogGroup.CheckNear;
var
  AParamValues: TParamValues;
begin
  // Цикл по всем значениям параметров
  for AParamValues in ParamValuesList do
  begin
    AParamValues.Table.CheckNear;
    UpdateParameterValues(AParamValues.ParameterID);
  end;
end;

procedure TAnalogGroup.Clear(AParameterID: Integer);
var
  AParamValues: TParamValues;
begin
  Assert(AParameterID > 0);

  AParamValues := ParamValuesList.FindByParameterID(AParameterID);
  Assert(AParamValues <> nil);

  AParamValues.Table.UncheckAll;

  FDMemTable.Edit;
  FDMemTable.FieldByName(GetFieldName(AParameterID)).Value := null;
  FDMemTable.Post;

end;

function TAnalogGroup.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TAnalogGroup.GetParamIDByFieldName(const AFieldName: String): Integer;
var
  i: Integer;
begin
  Assert(not AFieldName.IsEmpty);
  i := AFieldName.IndexOf(FFieldPrefix);
  Assert(i = 0);
  Result := AFieldName.Substring(FFieldPrefix.Length).ToInteger();
end;

procedure TAnalogGroup.Load(AProductCategoryID: Integer;
  ARecHolder: TRecordHolder);
var
  ACaption: String;
  AFieldName: string;
  AParameterID: Integer;
  AParamValues: TParamValues;
  ASortList: TStringList;
  F: TField;
  i: Integer;
begin
  Assert(ARecHolder <> nil);
  FProductCategoryID := AProductCategoryID;

  ASortList := TStringList.Create;
  try
    FFDMemTable.Close;

    // Ищем параметры используемые для поиска аналога
    FqParametersForCategory.SearchByParameterKind(AProductCategoryID);
    while not FqParametersForCategory.FDQuery.Eof do
    begin
      // Имя поля в таблице поределяющей выбранные значения для поиска аналога
      AFieldName := GetFieldName(FqParametersForCategory.ParameterID.AsInteger);
      // Добавляем очередное поле
      FFDMemTable.FieldDefs.Add(AFieldName, ftString, 200);
      FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
        AFieldName);

      ACaption := IfThen(qParametersForCategory.ParentCaption.AsString <> '',
        Format('%s (%s)', [qParametersForCategory.ParentCaption.AsString,
        FqParametersForCategory.Caption.AsString]),
        qParametersForCategory.Caption.AsString);

      // Создаём список значений параметра
      AParamValues := TParamValues.Create(ACaption,
        FqParametersForCategory.ParameterID.AsInteger);

      // Выбираем значения из БД
      FqUniqueParameterValues.SearchEx(AProductCategoryID,
        FqParametersForCategory.ParameterID.AsInteger);
      ASortList.Clear;
      while not FqUniqueParameterValues.FDQuery.Eof do
      begin
        ASortList.Add(FqUniqueParameterValues.Value.AsString);
        FqUniqueParameterValues.FDQuery.Next;
      end;
      // Сортируем
      TStringListSort.Sort(ASortList, False, True);
      for i := 0 to ASortList.Count - 1 do
      begin
        AParamValues.Table.AppendRec(i, ASortList[i]);
      end;

      ParamValuesList.Add(AParamValues);
      FqParametersForCategory.FDQuery.Next;
    end;
    // Создаём набор данныых в памятиж
    FDMemTable.CreateDataSet;

    // Добавляем в него одну запись
    FDMemTable.Append;
    for i := 0 to ARecHolder.Count - 1 do
    begin
      F := FDMemTable.FindField(ARecHolder.Items[i].FieldName);
      if F = nil then
        Continue;

      F.Value := ARecHolder.Items[i].Value;
      AParameterID := GetParamIDByFieldName(F.FieldName);
      AParamValues := ParamValuesList.FindByParameterID(AParameterID);
      AParamValues.Table.CheckRecords(F.Value);

      // Запоминаем эти значения для поиска полного аналога
      AParamValues.Table.DefaultCheckedValues := F.Value;
    end;

    FDMemTable.Post;
  finally
    FreeAndNil(ASortList);
  end;
end;

procedure TAnalogGroup.SetAsDefaultValues;
var
  AParamValues: TParamValues;
begin
  // Цикл по всем значениям параметров
  for AParamValues in ParamValuesList do
  begin
    AParamValues.Table.SetAsDefaultValues;
  end;
end;

procedure TAnalogGroup.UpdateParameterValues(AParameterID: Integer);
var
  AParamValues: TParamValues;
  AValues: String;
begin
  Assert(AParameterID > 0);
  AParamValues := ParamValuesList.FindByParameterID(AParameterID);
  Assert(AParamValues <> nil);

  AValues := AParamValues.Table.GetCheckedValues(#13#10, #0);

  FDMemTable.Edit;
  FDMemTable.FieldByName(GetFieldName(AParameterID)).Value := AValues;
  FDMemTable.Post;
end;

constructor TParameterValuesTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger, 0, True);
  FieldDefs.Add('Checked', ftInteger, 0, True);
  FieldDefs.Add('Value', ftWideString, 200, True);

  CreateDataSet;
  ID.Visible := False;
end;

procedure TParameterValuesTable.AppendRec(const AID: Integer;
  const AValue: string);
begin
  Assert(not AValue.IsEmpty);

  Append;
  ID.AsInteger := AID;
  Checked.AsInteger := 0;
  Value.AsString := AValue;
  Post;
end;

procedure TParameterValuesTable.CheckDefault;
begin
  UncheckAll;
  CheckRecords(FDefaultCheckedValues);
end;

procedure TParameterValuesTable.CheckNear;
var
  AID: Integer;
  i: Integer;
begin
  // Выделяет галочками ближайшие значения
  DisableControls;
  try
    CheckDefault;
    AID := 0;

    i := 0;
    while i < RecordCount do
    begin
      // Переходим к следующей записи
      Inc(i);
      RecNo := i;
      if Checked.AsInteger = 0 then
        Continue;

      // Отмечаем предшествующую запись
      if i > 1 then
      begin
        RecNo := i - 1;
        CheckRecord(True);
      end;

      // Отмечаем следующую запись
      if i < RecordCount then
      begin
        RecNo := i + 1;
        CheckRecord(True);
      end;

      AID := ID.AsInteger;

      // Пропускаем одну запись
      Inc(i);
    end;

    // Переходим на последнюю отмеченную запись
    if AID > 0 then
      LocateEx(ID.FieldName, AID, []);
  finally
    EnableControls;
  end;
end;

procedure TParameterValuesTable.CheckRecord(const AChecked: Boolean);
begin
  Edit;
  Checked.AsInteger := IfThen(AChecked, 1, 0);
  Post;
end;

procedure TParameterValuesTable.CheckRecords(const AValues: string);
var
  i: Integer;
  m: TArray<String>;
  OK: Boolean;
  S: string;
begin
  DisableControls;
  try
    m := AValues.Split([#13, #10]);
    for i := Low(m) to High(m) do
    begin
      S := m[i].Trim([#13, #10, ' ']);
      if S.IsEmpty then
        Continue;

      OK := LocateEx(Value.FieldName, S, []);
      Assert(OK);
      CheckRecord(True);
    end;
  finally
    EnableControls;
  end;
end;

function TParameterValuesTable.GetChecked: TField;
begin
  Result := FieldByName('Checked');
end;

function TParameterValuesTable.GetCheckedValues(const ADelimiter: string;
  const AQuote: Char): String;
var
  AClone: TFDMemTable;
  AQuoteStr: string;
begin
  Assert(not ADelimiter.IsEmpty);

  if State in [dsEdit, dsInsert] then
    Post;

  AQuoteStr := IfThen(AQuote = #0, '', AQuote);

  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(Self);
    AClone.Filter := Format('%s=1', [Checked.FieldName]);
    AClone.Filtered := True;
    AClone.First;
    Result := '';
    while not AClone.Eof do
    begin
      if not Result.IsEmpty then
        Result := Result + ADelimiter;

      Result := Format('%s%s%s%s', [Result, AQuoteStr,
        AClone.FieldByName(Value.FieldName).AsString, AQuoteStr]);

      AClone.Next;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

function TParameterValuesTable.GetID: TField;
begin
  Result := FieldByName('ID');
end;

function TParameterValuesTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

procedure TParameterValuesTable.SetAsDefaultValues;
begin
  // Делаем выбранные сейчас значения - значениями по умолчанию
  FDefaultCheckedValues := GetCheckedValues(#13#10, #0)
end;

procedure TParameterValuesTable.UncheckAll;
begin
  DisableControls;
  try
    First;
    while not Eof do
    begin
      if Checked.AsInteger = 1 then
        CheckRecord(False);
      Next;
    end;
  finally
    EnableControls;
  end;
end;

constructor TParamValues.Create(const ACaption: String; AParameterID: Integer);
begin
  Assert(not ACaption.IsEmpty);
  Assert(AParameterID > 0);

  FParameterID := AParameterID;
  FCaption := ACaption;
  FTable := TParameterValuesTable.Create(nil);
end;

destructor TParamValues.Destroy;
begin
  FreeAndNil(FTable);
  inherited;
end;

function TParamValuesList.FindByParameterID(AParameterID: Integer)
  : TParamValues;
begin
  for Result in Self do
  begin
    if Result.ParameterID = AParameterID then
      Exit;
  end;

  Result := nil;
end;

end.
