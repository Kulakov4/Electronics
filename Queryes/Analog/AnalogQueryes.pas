unit AnalogQueryes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  QueryGroupUnit, Vcl.ExtCtrls, TableWithProgress, Data.DB,
  System.Generics.Collections, UniqueParameterValuesQuery, System.StrUtils,
  FireDAC.Comp.Client, DBRecordHolder, StrHelper,
  SearchProductByParamValuesQuery, System.Math, CategoryParametersGroupUnit;

type
  TParameterValuesTable = class(TTableWithProgress)
  private
    FDefaultCheckedValues: string;
    procedure CheckNearNumerical;
    procedure CheckNearSubStr;
    function GetChecked: TField;
    function GetID: TField;
    function GetValue: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRec(const AID: Integer; const AValue: string);
    procedure CheckDefault;
    procedure CheckNear(AParameterKindID: Integer);
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
    FParamSubParamID: Integer;
    FParameterKindID: Integer;
    FTable: TParameterValuesTable;
  public
    constructor Create(AParamSubParamID, AParameterKindID: Integer);
    destructor Destroy; override;
    property ParamSubParamID: Integer read FParamSubParamID;
    property ParameterKindID: Integer read FParameterKindID
      write FParameterKindID;
    property Table: TParameterValuesTable read FTable;
  end;

  TParamValuesList = class(TList<TParamValues>)
  public
    function FindByParamSubParamID(AParamSubParamID: Integer): TParamValues;
  end;

  TAnalogGroup = class(TQueryGroup)
  private
    FAllParameterFields: TDictionary<Integer, String>;
    FCatParamsGroup: TCategoryParametersGroup;
    FFDMemTable: TFDMemTable;
    FParamSubParamIDDic: TDictionary<String, Integer>;
    FParamValuesList: TParamValuesList;
    FProductCategoryID: Integer;
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
    procedure Clear(AParamSubParamID: Integer);
    function GetParamSubParamIDByFieldName(const AFieldName: String): Integer;
    procedure Load(AProductCategoryID: Integer; ARecHolder: TRecordHolder;
      AAllParameterFields: TDictionary<Integer, String>);
    procedure SetAsDefaultValues;
    procedure UpdateParameterValues(AParamSubParamID: Integer);
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property CatParamsGroup: TCategoryParametersGroup read FCatParamsGroup;
    property FDMemTable: TFDMemTable read FFDMemTable;
    property ParamValuesList: TParamValuesList read FParamValuesList;
    property qUniqueParameterValues: TQueryUniqueParameterValues
      read FqUniqueParameterValues;
    property TempTableName: String read FTempTableName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ParameterKindEnum, NaturalSort;

constructor TAnalogGroup.Create(AOwner: TComponent);
begin
  inherited;
  FCatParamsGroup := TCategoryParametersGroup.Create(Self);
  FqUniqueParameterValues := TQueryUniqueParameterValues.Create(Self);
  FParamValuesList := TParamValuesList.Create;
  FFDMemTable := TFDMemTable.Create(Self);
  FAllParameterFields := TDictionary<Integer, String>.Create;
  FParamSubParamIDDic := TDictionary<String, Integer>.Create;
  FTempTableName := 'search_analog_temp_table';
end;

destructor TAnalogGroup.Destroy;
begin
  FreeAndNil(FAllParameterFields);
  FreeAndNil(FParamValuesList);
  FreeAndNil(FParamSubParamIDDic);
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

    S := Q.GetSQL(AParamValues.ParamSubParamID,
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
    UpdateParameterValues(AParamValues.ParamSubParamID);
  end;
end;

procedure TAnalogGroup.CheckNear;
var
  AParamValues: TParamValues;
begin
  // Цикл по всем значениям параметров
  for AParamValues in ParamValuesList do
  begin
    AParamValues.Table.CheckNear(AParamValues.ParameterKindID);
    UpdateParameterValues(AParamValues.ParamSubParamID);
  end;
end;

procedure TAnalogGroup.Clear(AParamSubParamID: Integer);
var
  AParamValues: TParamValues;
begin
  Assert(AParamSubParamID > 0);

  AParamValues := ParamValuesList.FindByParamSubParamID(AParamSubParamID);
  Assert(AParamValues <> nil);

  AParamValues.Table.UncheckAll;

  Assert(AllParameterFields.ContainsKey(AParamSubParamID));

  FDMemTable.Edit;
  FDMemTable.FieldByName(AllParameterFields[AParamSubParamID]).Value := null;
  FDMemTable.Post;

end;

function TAnalogGroup.GetParamSubParamIDByFieldName(const AFieldName: String):
    Integer;
begin
  Assert(not AFieldName.IsEmpty);
  Assert(FParamSubParamIDDic.ContainsKey(AFieldName));

  Result := FParamSubParamIDDic[AFieldName];
end;

procedure TAnalogGroup.Load(AProductCategoryID: Integer;
  ARecHolder: TRecordHolder; AAllParameterFields: TDictionary<Integer, String>);
var
  AFieldList: TList<String>;
  AFieldName: string;
  AIDParameterKind: Integer;
  AParamSubParamID: Integer;
  AParamValues: TParamValues;
  ASortList: TList<String>;
  F: TField;
  i: Integer;
  S: string;
begin
  Assert(ARecHolder <> nil);

  FAllParameterFields.Clear;
  FParamSubParamIDDic.Clear;

  FProductCategoryID := AProductCategoryID;

  AFieldList := TList<String>.Create;
  ASortList := TList<String>.Create;
  try
    // Ищем параметры используемые для поиска аналога
    CatParamsGroup.qCategoryParameters.SearchAnalog(AProductCategoryID);
    while not CatParamsGroup.qCategoryParameters.FDQuery.Eof do
    begin
      AParamSubParamID := CatParamsGroup.qCategoryParameters.
        ParamSubParamID.AsInteger;
      AIDParameterKind := CatParamsGroup.qCategoryParameters.
        IDParameterKind.AsInteger;
      // Имя поля в таблице определяющей выбранные значения для поиска аналога
      Assert(AAllParameterFields.ContainsKey(AParamSubParamID));
      AFieldName := AAllParameterFields[AParamSubParamID];
      // Добавляем очередное поле
      AFieldList.Add(AFieldName);

      // Заполняем словари id->поле и поле->id
      FAllParameterFields.Add(AParamSubParamID, AFieldName);
      FParamSubParamIDDic.Add(AFieldName, AParamSubParamID);

      // Создаём список значений параметра
      AParamValues := TParamValues.Create(AParamSubParamID, AIDParameterKind);

      // Выбираем значения из БД
      FqUniqueParameterValues.SearchEx(AProductCategoryID, AParamSubParamID);

      ASortList.Clear;
      while not FqUniqueParameterValues.FDQuery.Eof do
      begin
        ASortList.Add(FqUniqueParameterValues.Value.AsString);
        FqUniqueParameterValues.FDQuery.Next;
      end;
      // Сортируем
      ASortList.Sort(TNaturalStringComparer.Create);

      for i := 0 to ASortList.Count - 1 do
      begin
        AParamValues.Table.AppendRec(i, ASortList[i]);
      end;

      ParamValuesList.Add(AParamValues);
      CatParamsGroup.qCategoryParameters.FDQuery.Next;
    end;

    FFDMemTable.Close;
    FFDMemTable.FieldDefs.Clear;
    FFDMemTable.Name := 'asdsad';
    // Создаём набор данныых в памяти
    for S in AFieldList do
    begin
      FFDMemTable.FieldDefs.Add(S, ftString, 200);
    end;
    FDMemTable.CreateDataSet;

    // Добавляем в него одну запись
    FDMemTable.Append;
    for i := 0 to ARecHolder.Count - 1 do
    begin
      F := FDMemTable.FindField(ARecHolder.Items[i].FieldName);
      if F = nil then
        Continue;

      F.Value := ARecHolder.Items[i].Value;
      AParamSubParamID := GetParamSubParamIDByFieldName(F.FieldName);
      AParamValues := ParamValuesList.FindByParamSubParamID(AParamSubParamID);
      AParamValues.Table.CheckRecords(F.Value);

      // Запоминаем эти значения для поиска полного аналога
      AParamValues.Table.DefaultCheckedValues := F.Value;
    end;

    FDMemTable.Post;
  finally
    FreeAndNil(ASortList);
    FreeAndNil(AFieldList);
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

procedure TAnalogGroup.UpdateParameterValues(AParamSubParamID: Integer);
var
  AParamValues: TParamValues;
  AValues: String;
begin
  Assert(AParamSubParamID > 0);
  AParamValues := ParamValuesList.FindByParamSubParamID(AParamSubParamID);
  Assert(AParamValues <> nil);

  AValues := AParamValues.Table.GetCheckedValues(#13#10, #0);

  Assert(AllParameterFields.ContainsKey(AParamSubParamID));

  FDMemTable.Edit;
  FDMemTable.FieldByName(AllParameterFields[AParamSubParamID]).Value := AValues;
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

procedure TParameterValuesTable.CheckNear(AParameterKindID: Integer);
begin
  Assert(AParameterKindID > Integer(Неиспользуется));
  Assert(AParameterKindID <= Integer(Строковый_частичный));

  case AParameterKindID of
    Integer(Числовой):
      CheckNearNumerical;
    Integer(Строковый_точный):
      ; // нет ближайшего аналога
    Integer(Строковый_частичный):
      CheckNearSubStr;
  else
    Assert(False);
  end;
end;

procedure TParameterValuesTable.CheckNearNumerical;
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

procedure TParameterValuesTable.CheckNearSubStr;
var
  i: Integer;
  m: TArray<string>;
  S: string;
  V: string;
begin
  if FDefaultCheckedValues.IsEmpty then
    Exit;

  m := FDefaultCheckedValues.Split([#13]);

  // Выделяет галочками строки содержащие выбранные
  DisableControls;
  try
    CheckDefault;
    First;
    while not Eof do
    begin
      if Checked.AsInteger = 0 then
      begin
        // Цикл по всем подстрокам
        for i := Low(m) to High(m) do
        begin
          S := m[i].Trim([#10, ' ']).ToUpperInvariant;
          V := Value.AsString.ToUpperInvariant;
          // Нашли подстроку
          if V.IndexOf(S) >= 0 then
            CheckRecord(True);
        end;
      end;
      Next;
    end;

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

constructor TParamValues.Create(AParamSubParamID, AParameterKindID: Integer);
begin
  // Assert(not ACaption.IsEmpty);
  Assert(AParamSubParamID > 0);
  Assert(AParameterKindID >= Integer(Неиспользуется));
  Assert(AParameterKindID <= Integer(Строковый_частичный));

  FParamSubParamID := AParamSubParamID;
  // FCaption := ACaption;
  FParameterKindID := AParameterKindID;
  FTable := TParameterValuesTable.Create(nil);
end;

destructor TParamValues.Destroy;
begin
  FreeAndNil(FTable);
  inherited;
end;

function TParamValuesList.FindByParamSubParamID(AParamSubParamID: Integer)
  : TParamValues;
begin
  for Result in Self do
  begin
    if Result.ParamSubParamID = AParamSubParamID then
      Exit;
  end;

  Result := nil;
end;

end.
