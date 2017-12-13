unit ComponentsExGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, FamilyExQuery,
  ParametersForCategoryQuery, ProductParametersQuery, Data.DB,
  FireDAC.Stan.Option, FireDAC.Comp.DataSet, CustomComponentsQuery,
  System.Contnrs, System.Generics.Collections, QueryWithDataSourceUnit,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, FamilyQuery, BaseFamilyQuery,
  BaseComponentsQuery, ComponentsQuery, ComponentsExQuery,
  BaseComponentsGroupUnit, NotifyEvents;

type
  TComponentsExGroup = class(TBaseComponentsGroup)
    qFamilyEx: TQueryFamilyEx;
    qComponentsEx: TQueryComponentsEx;
    procedure OnFDQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
  private
    FApplyUpdateEvents: TObjectList;
    FClientCount: Integer;
    FMark: string;
    FAllParameterFields: TDictionary<Integer, String>;
    FOnParamOrderChange: TNotifyEventsEx;
    FQueryParametersForCategory: TQueryParametersForCategory;
    FQueryProductParameters: TQueryProductParameters;

  const
    FFieldPrefix: string = 'Field';
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoOnApplyUpdate(Sender: TObject);
    function GetFieldName(AIDParameter: Integer): String;
    { Private declarations }
  protected
    // TODO: ClearUpdateCount
    procedure LoadParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient;
    procedure DecClient;
    function GetIDParameter(const AFieldName: String): Integer;
    procedure TryRefresh;
    procedure UpdateData;
    property Mark: string read FMark;
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property OnParamOrderChange: TNotifyEventsEx read FOnParamOrderChange;
    property QueryParametersForCategory: TQueryParametersForCategory
      read FQueryParametersForCategory;
    property QueryProductParameters: TQueryProductParameters
      read FQueryProductParameters;
    { Public declarations }
  end;

implementation

uses FireDAC.Stan.Param;

{$R *.dfm}
{ TfrmComponentsMasterDetail }

constructor TComponentsExGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAllParameterFields := TDictionary<Integer, String>.Create();

  FApplyUpdateEvents := TObjectList.Create;

  FMark := '!';

  FQueryParametersForCategory := TQueryParametersForCategory.Create(Self);
  FQueryProductParameters := TQueryProductParameters.Create(Self);

  Main := qFamilyEx;
  Detail := qComponentsEx;

  TNotifyEventWrap.Create(qFamilyEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qFamilyEx.AfterOpen, DoAfterOpen);

  FClientCount := 1;
  DecClient; // Искусственно блокируем обновление

  FOnParamOrderChange := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsExGroup.Destroy;
begin
  FreeAndNil(FAllParameterFields);
  FreeAndNil(FApplyUpdateEvents);
  inherited;
end;

procedure TComponentsExGroup.AddClient;
begin
  Inc(FClientCount);

  // Если нужно разблокировать датасеты
  if (FClientCount > 0) then
  begin
    // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
    qComponentsEx.Lock := False;
    qFamilyEx.Lock := False;
  end;

end;

procedure TComponentsExGroup.DecClient;
begin
  Dec(FClientCount);
  Assert(FClientCount >= 0);

  if FClientCount = 0 then
  begin
    qComponentsEx.Lock := True;
    qFamilyEx.Lock := True;
  end;
end;

procedure TComponentsExGroup.DoAfterOpen(Sender: TObject);
begin
  LoadParameterValues;
end;

procedure TComponentsExGroup.DoBeforeOpen(Sender: TObject);
var
  AData: TQueryCustomComponents;
  AFDQuery: TFDQuery;
  AFieldName: String;
  AFieldType: TFieldType;
  ASize: Integer;
begin
  // Очищаем словарь параметров
  FAllParameterFields.Clear;

  AData := Sender as TQueryCustomComponents;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  AFDQuery.FieldDefs.Update;

  // В списке параметров могли произойти изменения (порядок, видимость)
  QueryParametersForCategory.FDQuery.Close;
  QueryParametersForCategory.Load(AData.ParentValue);

  QueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    // Если для такого параметра в SQL запросе поля не существует
    if not AData.ParameterFields.ContainsKey
      (FQueryParametersForCategory.ParameterID.AsInteger) then
    begin
      ASize := 0;
      // AFieldType := ftInteger;

      case QueryParametersForCategory.FieldType.AsInteger of
        // целое число
        1:
          AFieldType := ftInteger;
        2: // строка
          begin
            AFieldType := ftWideString;
            ASize := 200;
          end;
        // дробное число
        3:
          AFieldType := ftFloat;
        // булево значение
        4:
          AFieldType := ftBoolean;
        // дата и время
        5:
          AFieldType := ftDateTime;
      else
        AFieldType := ftWideString;
        ASize := 200;
      end;

      AFieldName := GetFieldName
        (FQueryParametersForCategory.ParameterID.AsInteger);
      // Добавляем очередное поле
      AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
      FAllParameterFields.Add(FQueryParametersForCategory.ParameterID.AsInteger,
        AFieldName);
    end
    else
      FAllParameterFields.Add(FQueryParametersForCategory.ParameterID.AsInteger,
        AData.ParameterFields[FQueryParametersForCategory.ParameterID.
        AsInteger]);

    FQueryParametersForCategory.FDQuery.Next;
  end;

  AData.CreateDefaultFields(False);

  FQueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    if not AData.ParameterFields.ContainsKey
      (FQueryParametersForCategory.ParameterID.AsInteger) then
    begin
      AFieldName := GetFieldName
        (FQueryParametersForCategory.ParameterID.AsInteger);
      AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FQueryParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.DoOnApplyUpdate(Sender: TObject);
var
  ADataSet: TDataSet;
  AField: TField;
  AFieldName: String;
  AMark: Char;
  AValue: string;
  k: Integer;
  m: TArray<String>;
  S: string;
begin
  ADataSet := Sender as TDataSet;

  // Цикл по всем добавленным полям
  QueryParametersForCategory.FDQuery.First;
  while not QueryParametersForCategory.FDQuery.Eof do
  begin
    AFieldName := AllParameterFields
      [FQueryParametersForCategory.ParameterID.AsInteger];
    AField := ADataSet.FieldByName(AFieldName);

    if AField.OldValue <> AField.Value then
    begin
      // Фильтруем значения параметров
      FQueryProductParameters.FDQuery.Filter :=
        Format('(ProductID=%d) and (ParameterID=%d)',
        [ADataSet.FieldByName('ID').AsInteger,
        FQueryParametersForCategory.ParameterID.AsInteger]);
      FQueryProductParameters.FDQuery.Filtered := True;
      FQueryProductParameters.FDQuery.First;

      S := AField.AsString;
      m := S.Split([#13]);
      k := 0;
      for S in m do
      begin
        AMark := FMark.Chars[0];
        AValue := S.Trim([AMark, #13, #10]);
        if not AValue.IsEmpty then
        begin
          Inc(k);
          if not(FQueryProductParameters.FDQuery.Eof) then
            FQueryProductParameters.FDQuery.Edit
          else
          begin
            FQueryProductParameters.FDQuery.Append;
            FQueryProductParameters.ParameterID.AsInteger :=
              FQueryParametersForCategory.ParameterID.AsInteger;
            FQueryProductParameters.ProductID.AsInteger :=
              ADataSet.FieldByName('ID').AsInteger;
          end;

          FQueryProductParameters.Value.AsString := AValue;
          FQueryProductParameters.TryPost;
          FQueryProductParameters.FDQuery.Next;
        end;
      end;

      // Удаляем "лишние" значения
      while FQueryProductParameters.FDQuery.RecordCount > k do
      begin
        FQueryProductParameters.FDQuery.Last;
        FQueryProductParameters.FDQuery.Delete;
      end;
      FQueryProductParameters.FDQuery.Filtered := False;
    end;
    // Переходим к следующему параметру
    QueryParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.OnFDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TComponentsExGroup.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TComponentsExGroup.GetIDParameter(const AFieldName: String): Integer;
var
  S: string;
begin
  S := AFieldName.Remove(0, FFieldPrefix.Length);
  Result := S.ToInteger();
end;

procedure TComponentsExGroup.LoadParameterValues;
var
  AField: TField;
  qryComponents: TQueryCustomComponents;
  AFieldName: String;
  ANewValue: string;
  AValue: string;
  OK: Boolean;
  S: string;
begin
  // Во время загрузки ничего сохранять не будем
  FApplyUpdateEvents.Clear;

  // Загружаем значения параметров из БД принудительно
  FQueryProductParameters.Load(qFamilyEx.ParentValue, True);

  qFamilyEx.FDQuery.DisableControls;
  qComponentsEx.FDQuery.DisableControls;
  try
    FQueryProductParameters.FDQuery.First;
    while not FQueryProductParameters.FDQuery.Eof do
    begin

      if FQueryProductParameters.ParentProductID.IsNull then
        qryComponents := qFamilyEx
      else
        qryComponents := qComponentsEx;

      OK := qryComponents.LocateByPK(FQueryProductParameters.ProductID.Value);
      Assert(OK);

      // Если для такого параметра в SQL запросе поля не существует
      if not qryComponents.ParameterFields.ContainsKey
        (FQueryParametersForCategory.ParameterID.AsInteger) then
      begin
        AFieldName := GetFieldName
          (FQueryProductParameters.ParameterID.AsInteger);
        S := FQueryProductParameters.Value.AsString.Trim;
        if not S.IsEmpty then
        begin
          // Возможно такого параметра у нашей категории уже нет
          AField := qryComponents.FDQuery.FindField(AFieldName);
          // Если такой параметр у нашей категории есть
          if AField <> nil then
          begin
            // Добавляем ограничители, чтобы потом можно было фильтровать
            ANewValue := Format('%s%s%s',
              [FMark, FQueryProductParameters.Value.AsString.Trim, FMark]);

            AValue := AField.AsString.Trim;
            if AValue <> '' then
              AValue := AValue + #13#10;
            AValue := AValue + ANewValue;

            qryComponents.TryEdit;
            AField.AsString := AValue;
            qryComponents.TryPost;
          end;
        end;
      end;
      FQueryProductParameters.FDQuery.Next;
    end;
  finally
    qComponentsEx.FDQuery.EnableControls;
    qFamilyEx.FDQuery.EnableControls;
  end;

  // Подписываемся на событие, чтобы сохранить
  TNotifyEventWrap.Create(qFamilyEx.On_ApplyUpdate, DoOnApplyUpdate,
    FApplyUpdateEvents);
  TNotifyEventWrap.Create(qComponentsEx.On_ApplyUpdate, DoOnApplyUpdate);
  // Завершаем транзакцию
  Connection.Commit;
end;

procedure TComponentsExGroup.TryRefresh;
begin
  // Обновляем если они не заблокированы
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

procedure TComponentsExGroup.UpdateData;
begin
  QueryParametersForCategory.FDQuery.Params.ParamByName
    (QueryParametersForCategory.DetailParameterName).AsInteger := 0;
  QueryProductParameters.FDQuery.Params.ParamByName
    (QueryProductParameters.DetailParameterName).AsInteger := 0;
  // Запросы нужно обновить, но мастер у них не изменился
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

end.
