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
    FqParametersForCategory: TQueryParametersForCategory;
    FqProductParameters: TQueryProductParameters;

  const
    FFieldPrefix: string = 'Field';
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure ApplyUpdate(AQueryCustomComponents: TQueryCustomComponents; AFamily:
        Boolean);
    procedure DoOnApplyUpdateComponent(Sender: TObject);
    procedure DoOnApplyUpdateFamily(Sender: TObject);
    function GetFieldName(AIDParameter: Integer): String;
    property qProductParameters: TQueryProductParameters
      read FqProductParameters;
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
    property qParametersForCategory: TQueryParametersForCategory
      read FqParametersForCategory;
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

  FqParametersForCategory := TQueryParametersForCategory.Create(Self);
  FqProductParameters := TQueryProductParameters.Create(Self);

  Main := qFamilyEx;
  Detail := qComponentsEx;

  TNotifyEventWrap.Create(qFamilyEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qFamilyEx.AfterOpen, DoAfterOpen);

  FClientCount := 1;
  DecClient; // »скусственно блокируем обновление

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

  // ≈сли нужно разблокировать датасеты
  if (FClientCount > 0) then
  begin
    // —начала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
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
  // ќчищаем словарь параметров
  FAllParameterFields.Clear;

  AData := Sender as TQueryCustomComponents;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  AFDQuery.FieldDefs.Update;

  // ¬ списке параметров могли произойти изменени€ (пор€док, видимость)
  qParametersForCategory.Load(AData.ParentValue, True); // принудительно

  qParametersForCategory.FDQuery.First;
  while not FqParametersForCategory.FDQuery.Eof do
  begin
    // ≈сли дл€ такого параметра в SQL запросе пол€ не существует
    if not AData.ParameterFields.ContainsKey
      (FqParametersForCategory.ParameterID.AsInteger) then
    begin
      ASize := 0;
      // AFieldType := ftInteger;

      case qParametersForCategory.FieldType.AsInteger of
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
        // дата и врем€
        5:
          AFieldType := ftDateTime;
      else
        AFieldType := ftWideString;
        ASize := 200;
      end;

      AFieldName := GetFieldName(FqParametersForCategory.ParameterID.AsInteger);
      // ƒобавл€ем очередное поле
      AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
      FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
        AFieldName);
    end
    else
      FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
        AData.ParameterFields[FqParametersForCategory.ParameterID.AsInteger]);

    FqParametersForCategory.FDQuery.Next;
  end;

  AData.CreateDefaultFields(False);

  FqParametersForCategory.FDQuery.First;
  while not FqParametersForCategory.FDQuery.Eof do
  begin
    if not AData.ParameterFields.ContainsKey
      (FqParametersForCategory.ParameterID.AsInteger) then
    begin
      AFieldName := GetFieldName(FqParametersForCategory.ParameterID.AsInteger);
      AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FqParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.ApplyUpdate(AQueryCustomComponents:
    TQueryCustomComponents; AFamily: Boolean);
var
//  AQueryCustomComponents: TQueryCustomComponents;
  AField: TField;
  AFieldName: String;
  AMark: Char;
  AValue: string;
  k: Integer;
  m: TArray<String>;
  S: string;
//  ADataSet: TFDQuery;
  //ANewValue: String;
  //AOldValue: String;
begin
//  AQueryCustomComponents := Sender as TQueryCustomComponents;

//  ADataSet := AQueryCustomComponents.FDQuery;
  Assert(AQueryCustomComponents.RecordHolder <> nil);

  // ÷икл по всем добавленным пол€м
  qParametersForCategory.FDQuery.First;
  while not qParametersForCategory.FDQuery.Eof do
  begin
    AFieldName := AllParameterFields
      [FqParametersForCategory.ParameterID.AsInteger];
    AField := AQueryCustomComponents.Field(AFieldName);


    // AField.OldValue <> AField.Value почему-то не работает
    //AOldValue := VarToStrDef(AQueryCustomComponents.RecordHolder.Field[AFieldName], '');
    //ANewValue := VarToStrDef(AField.Value, '');
    
    if AQueryCustomComponents.RecordHolder.Field[AFieldName] <> AField.Value then
    begin
      // ‘ильтруем значени€ параметров
      FqProductParameters.ApplyFilter(AQueryCustomComponents.PK.AsInteger,
        FqParametersForCategory.ParameterID.AsInteger);

      FqProductParameters.FDQuery.First;

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
          if not(FqProductParameters.FDQuery.Eof) then
            FqProductParameters.FDQuery.Edit
          else
          begin
            FqProductParameters.FDQuery.Append;
            FqProductParameters.ParameterID.AsInteger :=
              FqParametersForCategory.ParameterID.AsInteger;
            FqProductParameters.ProductID.AsInteger :=
              AQueryCustomComponents.PK.AsInteger;
          end;

          FqProductParameters.Value.AsString := AValue;
          FqProductParameters.TryPost;
          FqProductParameters.FDQuery.Next;
        end;
      end;

      // ”дал€ем "лишние" значени€
      while FqProductParameters.FDQuery.RecordCount > k do
      begin
        FqProductParameters.FDQuery.Last;
        FqProductParameters.FDQuery.Delete;
      end;
      FqProductParameters.FDQuery.Filtered := False;
    end;
    // ѕереходим к следующему параметру
    qParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.DoOnApplyUpdateComponent(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, False);
end;

procedure TComponentsExGroup.DoOnApplyUpdateFamily(Sender: TObject);
begin
  ApplyUpdate(Sender as TQueryCustomComponents, True);
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
  // ¬о врем€ загрузки ничего сохран€ть не будем
  FApplyUpdateEvents.Clear;
  qFamilyEx.SaveValuesAfterEdit := False;
  qComponentsEx.SaveValuesAfterEdit := False;

  // «агружаем значени€ параметров из Ѕƒ принудительно
  FqProductParameters.Load(qFamilyEx.ParentValue, True);

  qFamilyEx.FDQuery.DisableControls;
  qComponentsEx.FDQuery.DisableControls;
  try
    FqProductParameters.FDQuery.First;
    while not FqProductParameters.FDQuery.Eof do
    begin

      if FqProductParameters.ParentProductID.IsNull then
        qryComponents := qFamilyEx
      else
        qryComponents := qComponentsEx;

      OK := qryComponents.LocateByPK(FqProductParameters.ProductID.Value);
      Assert(OK);

      // ≈сли дл€ такого параметра в SQL запросе пол€ не существует
      if not qryComponents.ParameterFields.ContainsKey
        (FqParametersForCategory.ParameterID.AsInteger) then
      begin
        AFieldName := GetFieldName(FqProductParameters.ParameterID.AsInteger);
        S := FqProductParameters.Value.AsString.Trim;
        if not S.IsEmpty then
        begin
          // ¬озможно такого параметра у нашей категории уже нет
          AField := qryComponents.FDQuery.FindField(AFieldName);
          // ≈сли такой параметр у нашей категории есть
          if AField <> nil then
          begin
            // ƒобавл€ем ограничители, чтобы потом можно было фильтровать
            ANewValue := Format('%s%s%s',
              [FMark, FqProductParameters.Value.AsString.Trim, FMark]);

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
      FqProductParameters.FDQuery.Next;
    end;
  finally
    qFamilyEx.FDQuery.First;
    qComponentsEx.FDQuery.First;
    qComponentsEx.FDQuery.EnableControls;
    qFamilyEx.FDQuery.EnableControls;
  end;

  // ѕодписываемс€ на событие, чтобы сохранить
  TNotifyEventWrap.Create(qFamilyEx.On_ApplyUpdate, DoOnApplyUpdateFamily,
    FApplyUpdateEvents);
  TNotifyEventWrap.Create(qComponentsEx.On_ApplyUpdate, DoOnApplyUpdateComponent,
    FApplyUpdateEvents);

  qFamilyEx.SaveValuesAfterEdit := True;
  qComponentsEx.SaveValuesAfterEdit := True;
    
  // «авершаем транзакцию
  Connection.Commit;
end;

procedure TComponentsExGroup.TryRefresh;
begin
  // ќбновл€ем если они не заблокированы
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

procedure TComponentsExGroup.UpdateData;
begin
  qParametersForCategory.FDQuery.Params.ParamByName
    (qParametersForCategory.DetailParameterName).AsInteger := 0;
  qProductParameters.FDQuery.Params.ParamByName
    (qProductParameters.DetailParameterName).AsInteger := 0;
  // «апросы нужно обновить, но мастер у них не изменилс€
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

end.
