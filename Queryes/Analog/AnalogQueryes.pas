unit AnalogQueryes;

interface

uses
  CategoryParametersGroupUnit2, DBRecordHolder,
  FireDAC.Comp.Client, QueryGroupUnit2, System.Classes,
  UniqueParameterValuesQuery, Data.DB, System.Generics.Collections,
  TableWithProgress, DSWrap;

type
  TParameterValuesTableW = class(TDSWrap)
  private
    FID: TFieldWrap;
    FValue: TFieldWrap;
    FChecked: TFieldWrap;
    FDefaultCheckedValues: string;
    procedure CheckNearNumerical;
    procedure CheckNearSubStr;
    procedure FilterChecked;
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
    property ID: TFieldWrap read FID;
    property Value: TFieldWrap read FValue;
    property Checked: TFieldWrap read FChecked;
    property DefaultCheckedValues: string read FDefaultCheckedValues
      write FDefaultCheckedValues;
  end;

  TParameterValuesTable = class(TTableWithProgress)
  private
    FW: TParameterValuesTableW;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TParameterValuesTableW read FW;
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

type
  TAnalogGroup = class(TQueryGroup2)
  private
    FAllParameterFields: TDictionary<Integer, String>;
    FCatParamsGroup: TCategoryParametersGroup2;
    FFDMemTable: TFDMemTable;
    FParamSubParamIDDic: TDictionary<String, Integer>;
    FParamValuesList: TParamValuesList;
    FProductCategoryID: Integer;
    FqUniqueParameterValues: TQueryUniqueParameterValues;
    FTempTableName: String;
    FW: TDSWrap;

  const
    FFieldPrefix: string = 'Field';
    { Private declarations }
  protected
    property FDMemTable: TFDMemTable read FFDMemTable;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyFilter;
    procedure CheckDefault;
    procedure CheckNear;
    procedure Clear(AParamSubParamID: Integer);
    function GetParamSubParamIDByFieldName(const AFieldName: String): Integer;
    function Load(AProductCategoryID: Integer; ARecHolder: TRecordHolder;
      AAllParameterFields: TDictionary<Integer, String>): Boolean;
    procedure SetAsDefaultValues;
    procedure UpdateParameterValues(AParamSubParamID: Integer);
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property CatParamsGroup: TCategoryParametersGroup2 read FCatParamsGroup;
    property ParamValuesList: TParamValuesList read FParamValuesList;
    property qUniqueParameterValues: TQueryUniqueParameterValues
      read FqUniqueParameterValues;
    property TempTableName: String read FTempTableName;
    property W: TDSWrap read FW;
    { Public declarations }
  end;

implementation

uses
  ParameterKindEnum, System.SysUtils, SearchProductByParamValuesQuery,
  System.Variants, NaturalSort, System.Math, System.StrUtils;

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

constructor TAnalogGroup.Create(AOwner: TComponent);
begin
  inherited;
  FCatParamsGroup := TCategoryParametersGroup2.Create(Self);
  FqUniqueParameterValues := TQueryUniqueParameterValues.Create(Self);
  FParamValuesList := TParamValuesList.Create;
  FFDMemTable := TFDMemTable.Create(Self);
  FAllParameterFields := TDictionary<Integer, String>.Create;
  FParamSubParamIDDic := TDictionary<String, Integer>.Create;
  FTempTableName := 'search_analog_temp_table';
  FW := TDSWrap.Create(FDMemTable);
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
    ACheckedValues := AParamValues.Table.W.GetCheckedValues(',', '''');
    // Если по этому параметру не надо фильтровать
    if ACheckedValues.IsEmpty then
      Continue;

    S := Q.GetSQL(AParamValues.ParamSubParamID,
      AParamValues.Table.W.GetCheckedValues(',', ''''));

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
    AParamValues.Table.W.CheckDefault;
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
    AParamValues.Table.W.CheckNear(AParamValues.ParameterKindID);
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

  AParamValues.Table.W.UncheckAll;

  Assert(AllParameterFields.ContainsKey(AParamSubParamID));

  FDMemTable.Edit;
  FDMemTable.FieldByName(AllParameterFields[AParamSubParamID]).Value := null;
  FDMemTable.Post;

end;

function TAnalogGroup.GetParamSubParamIDByFieldName(const AFieldName
  : String): Integer;
begin
  Assert(not AFieldName.IsEmpty);
  Assert(FParamSubParamIDDic.ContainsKey(AFieldName));

  Result := FParamSubParamIDDic[AFieldName];
end;

function TAnalogGroup.Load(AProductCategoryID: Integer;
  ARecHolder: TRecordHolder;
  AAllParameterFields: TDictionary<Integer, String>): Boolean;
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
  Result := False;
  Assert(ARecHolder <> nil);

  FAllParameterFields.Clear;
  FParamSubParamIDDic.Clear;

  FProductCategoryID := AProductCategoryID;

  AFieldList := TList<String>.Create;
  ASortList := TList<String>.Create;
  try
    // Ищем параметры используемые для поиска аналога
    CatParamsGroup.qCategoryParameters.SearchAnalog(AProductCategoryID);
    CatParamsGroup.qCategoryParameters.FDQuery.First;
    while not CatParamsGroup.qCategoryParameters.FDQuery.Eof do
    begin
      AParamSubParamID := CatParamsGroup.qCategoryParameters.W.ParamSubParamID.
        F.AsInteger;
      AIDParameterKind := CatParamsGroup.qCategoryParameters.W.IDParameterKind.
        F.AsInteger;
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
        ASortList.Add(FqUniqueParameterValues.W.Value.F.AsString);
        FqUniqueParameterValues.FDQuery.Next;
      end;
      // Сортируем
      ASortList.Sort(TNaturalStringComparer.Create);

      for i := 0 to ASortList.Count - 1 do
      begin
        AParamValues.Table.W.AppendRec(i, ASortList[i]);
      end;

      ParamValuesList.Add(AParamValues);
      CatParamsGroup.qCategoryParameters.FDQuery.Next;
    end;

    // Если не найдено ни одного поля, по которому можно искать аналог
    if AFieldList.Count = 0 then
      Exit;

    FFDMemTable.Close;
    FFDMemTable.FieldDefs.Clear;
    FFDMemTable.Name := 'asdsad';
    // Создаём набор данныых в памяти
    for S in AFieldList do
    begin
      FFDMemTable.FieldDefs.Add(S, ftWideString, 200);
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
      AParamValues.Table.W.CheckRecords(F.Value);

      // Запоминаем эти значения для поиска полного аналога
      AParamValues.Table.W.DefaultCheckedValues := F.Value;
    end;

    FDMemTable.Post;
    Result := True;
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
    AParamValues.Table.W.SetAsDefaultValues;
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

  AValues := AParamValues.Table.W.GetCheckedValues(#13#10, #0);

  Assert(AllParameterFields.ContainsKey(AParamSubParamID));

  FDMemTable.Edit;
  FDMemTable.FieldByName(AllParameterFields[AParamSubParamID]).Value := AValues;
  FDMemTable.Post;
end;

constructor TParameterValuesTable.Create(AOwner: TComponent);
begin
  inherited;
  FW := TParameterValuesTableW.Create(Self);

  FieldDefs.Add(W.ID.FieldName, ftInteger, 0, True);
  FieldDefs.Add(W.Checked.FieldName, ftInteger, 0, True);
  FieldDefs.Add(W.Value.FieldName, ftWideString, 200, True);

  CreateDataSet;
end;

constructor TParameterValuesTableW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FValue := TFieldWrap.Create(Self, 'Value', 'Значение');
  FChecked := TFieldWrap.Create(Self, 'Checked', 'X');
end;

procedure TParameterValuesTableW.AppendRec(const AID: Integer;
  const AValue: string);
begin
  Assert(not AValue.IsEmpty);

  TryAppend;
  ID.F.AsInteger := AID;
  Checked.F.AsInteger := 0;
  Value.F.AsString := AValue;
  TryPost;
end;

procedure TParameterValuesTableW.CheckDefault;
begin
  UncheckAll;
  CheckRecords(FDefaultCheckedValues);
end;

procedure TParameterValuesTableW.CheckNear(AParameterKindID: Integer);
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

procedure TParameterValuesTableW.CheckNearNumerical;
var
  AID: Integer;
  i: Integer;
begin
  // Выделяет галочками ближайшие значения
  DataSet.DisableControls;
  try
    CheckDefault;
    AID := 0;

    i := 0;
    while i < RecordCount do
    begin
      // Переходим к следующей записи
      Inc(i);
      DataSet.RecNo := i;
      if Checked.F.AsInteger = 0 then
        Continue;

      // Отмечаем предшествующую запись
      if i > 1 then
      begin
        DataSet.RecNo := i - 1;
        CheckRecord(True);
      end;

      // Отмечаем следующую запись
      if i < RecordCount then
      begin
        DataSet.RecNo := i + 1;
        CheckRecord(True);
      end;

      AID := ID.F.AsInteger;

      // Пропускаем одну запись
      Inc(i);
    end;

    // Переходим на последнюю отмеченную запись
    if AID > 0 then
      ID.Locate(AID, [])
  finally
    DataSet.EnableControls;
  end;

end;

procedure TParameterValuesTableW.CheckNearSubStr;
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
  DataSet.DisableControls;
  try
    CheckDefault;
    DataSet.First;
    while not DataSet.Eof do
    begin
      if Checked.F.AsInteger = 0 then
      begin
        // Цикл по всем подстрокам
        for i := Low(m) to High(m) do
        begin
          S := m[i].Trim([#10, ' ']).ToUpperInvariant;
          V := Value.F.AsString.ToUpperInvariant;
          // Нашли подстроку
          if V.IndexOf(S) >= 0 then
            CheckRecord(True);
        end;
      end;
      DataSet.Next;
    end;

  finally
    DataSet.EnableControls;
  end;

end;

procedure TParameterValuesTableW.CheckRecord(const AChecked: Boolean);
begin
  TryEdit;
  Checked.F.AsInteger := IfThen(AChecked, 1, 0);
  TryPost;
end;

procedure TParameterValuesTableW.CheckRecords(const AValues: string);
var
  i: Integer;
  m: TArray<String>;
  S: string;
begin
  DataSet.DisableControls;
  try
    m := AValues.Split([#13, #10]);
    for i := Low(m) to High(m) do
    begin
      S := m[i].Trim([#13, #10, ' ']);
      if S.IsEmpty then
        Continue;
      Value.Locate(S, [], True);
      CheckRecord(True);
    end;
  finally
    DataSet.EnableControls;
  end;
end;

procedure TParameterValuesTableW.FilterChecked;
begin
  DataSet.Filter := Format('%s = 1', [Checked.FieldName]);
  DataSet.Filtered := True;
end;

function TParameterValuesTableW.GetCheckedValues(const ADelimiter: string;
  const AQuote: Char): String;
var
  AClone: TFDMemTable;
  ACloneWrap: TParameterValuesTableW;
  AQuoteStr: string;
begin
  Assert(not ADelimiter.IsEmpty);

  TryPost;

  AQuoteStr := IfThen(AQuote = #0, '', AQuote);

  AClone := AddClone('');
  try
    ACloneWrap := TParameterValuesTableW.Create(AClone);
    ACloneWrap.FilterChecked;

    Result := '';
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ADelimiter);
      Result := Format('%s%s%s%s', [Result, AQuoteStr,
        ACloneWrap.Value.F.AsString, AQuoteStr]);

      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

procedure TParameterValuesTableW.SetAsDefaultValues;
begin
  // Делаем выбранные сейчас значения - значениями по умолчанию
  FDefaultCheckedValues := GetCheckedValues(#13#10, #0)
end;

procedure TParameterValuesTableW.UncheckAll;
begin
  DataSet.DisableControls;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      if Checked.F.AsInteger = 1 then
        CheckRecord(False);
      DataSet.Next;
    end;
  finally
    DataSet.EnableControls;
  end;
end;

end.
