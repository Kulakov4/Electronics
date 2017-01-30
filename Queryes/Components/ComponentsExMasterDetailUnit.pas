unit ComponentsExMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ComponentsBaseMasterDetailUnit,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, DataModuleFrame,
  ComponentsQuery, ComponentsExQuery, ComponentsBaseDetailQuery,
  ComponentsDetailQuery, ComponentsDetailExQuery, ParametersForCategoryQuery,
  ProductParametersQuery, Data.DB, FireDAC.Stan.Option, FireDAC.Comp.DataSet;

type
  TComponentsExMasterDetail = class(TComponentsBaseMasterDetail)
    qComponentsEx: TQueryComponentsEx;
    qComponentsDetailEx: TQueryComponentsDetailEx;
    procedure OnFDQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
  private
    FClientCount: Integer;
    FMark: string;
    FQueryParametersForCategory: TQueryParametersForCategory;
    FQueryProductParameters: TQueryProductParameters;

  const
    FFieldPrefix: string = 'Field';
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    { Private declarations }
  protected
    procedure ApplyModified(AQuery: TFDDataSet); override;
    procedure ClearUpdateCount;
    procedure LoadParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddClient;
    procedure ApplyUpdates; override;
    procedure DecClient;
    function GetFieldName(AIDParameter: Integer): String;
    function GetIDParameter(const AFieldName: String): Integer;
    procedure UpdateData;
    property Mark: string read FMark;
    property QueryParametersForCategory: TQueryParametersForCategory
      read FQueryParametersForCategory;
    property QueryProductParameters: TQueryProductParameters
      read FQueryProductParameters;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

{ TfrmComponentsMasterDetail }

constructor TComponentsExMasterDetail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMark := '!';

  FQueryParametersForCategory := TQueryParametersForCategory.Create(Self);
  FQueryProductParameters := TQueryProductParameters.Create(Self);

  Main := qComponentsEx;
  Detail := qComponentsDetailEx;

  TNotifyEventWrap.Create(qComponentsEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsDetailEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsEx.AfterOpen, DoAfterOpen);

  FClientCount := 1;
  DecClient; // Искусственно блокируем обновление
end;

procedure TComponentsExMasterDetail.AddClient;
begin
  Inc(FClientCount);

  // Если нужно разблокировать датасеты
  if (FClientCount > 0) then
  begin
    // Сначала обновим детали, чтобы при обновлении мастера знать сколько у него дочерних
    qComponentsDetailEx.Lock := False;
    qComponentsEx.Lock := False;
  end;

end;

procedure TComponentsExMasterDetail.ApplyModified(AQuery: TFDDataSet);
var
  AField: TField;
  AFieldName: String;
  AMark: Char;
  AValue: String;
  k: Integer;
  m: TArray<String>;
  S: string;
begin
  // изменённые
  AQuery.FilterChanges := [rtModified];
  AQuery.First;
  while not AQuery.Eof do
  begin
    // Цикл по всем добавленным полям
    QueryParametersForCategory.FDQuery.First;
    while not QueryParametersForCategory.FDQuery.Eof do
    begin
      AFieldName := GetFieldName(FQueryParametersForCategory.ID.AsInteger);
      AField := AQuery.FieldByName(AFieldName);

      if AField.OldValue <> AField.Value then
      begin
        // Фильтруем значения параметров
        FQueryProductParameters.FDQuery.Filter :=
          Format('(ProductID=%d) and (UnionParameterID=%d)',
          [AQuery.FieldByName('ID').AsInteger,
          FQueryParametersForCategory.ID.AsInteger]);
        FQueryProductParameters.FDQuery.Filtered := True;

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
                FQueryParametersForCategory.ID.AsInteger;
              FQueryProductParameters.ProductID.AsInteger :=
                AQuery.FieldByName('ID').AsInteger;
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
      end;

      QueryParametersForCategory.FDQuery.Next
    end;
    AQuery.Next;
  end;
  FQueryProductParameters.FDQuery.Filtered := False;
  inherited;
end;

procedure TComponentsExMasterDetail.ApplyUpdates;
// var
// ADetailValue: String;
// AMainValue: String;
begin
  // если осталась неактивной, т.к. была заблокирована
  if Main.Lock and (not Main.FDQuery.Active) then
    Exit;

  CheckMasterAndDetail;

  Main.TryPost;
  Detail.TryPost;

  // Main.FDQuery.DisableControls;
  // Detail.FDQuery.DisableControls;
  // try
  // Запоминаем, на каком наименовании мы стояли
  // AMainValue := Main.FDQuery.FieldByName('Value').AsString;
  // Запоминаем, на каком наименовании мы стояли
  // ADetailValue := Detail.FDQuery.FieldByName('Value').AsString;

  // Начинаем транзакцию
  FDTransaction.StartTransaction;
  try

    InternalCommit(Main.FDQuery, Detail.FDQuery);
    InternalCommit(Detail.FDQuery);

    // Как-бы сохраняем
    ClearUpdateCount;

    // Удаляем потерянные компоненты.
    DeleteLostComponents;

    // Завершаем транзакцию на сервере сохраняя
    FDTransaction.Commit;

    FullDeleted.Clear;

    // Извещаем всех что мы успешно сохранились в БД
    AfterApplyUpdates.CallEventHandlers(Self);
  except
    // В случае ошибки при сохранении - откатываем транзакцию
    FDTransaction.Rollback;
    raise;
  end;

  // Возвращаемся к той-же записи
  // Detail.FDQuery.Locate('Value', ADetailValue, []);
  // Main.FDQuery.Locate('Value', AMainValue, []);
  // finally
  // Detail.FDQuery.EnableControls;
  // Main.FDQuery.EnableControls;
  // end;
end;

procedure TComponentsExMasterDetail.ClearUpdateCount;
begin
  // "как-бы" сохраняем внесённые данные
  qComponentsEx.FDQuery.OnUpdateRecord := OnFDQueryUpdateRecord;
  qComponentsDetailEx.FDQuery.OnUpdateRecord := OnFDQueryUpdateRecord;
  qComponentsEx.ApplyUpdates;
  qComponentsDetailEx.ApplyUpdates;
  qComponentsEx.FDQuery.OnUpdateRecord := nil;
  qComponentsDetailEx.FDQuery.OnUpdateRecord := nil;
end;

procedure TComponentsExMasterDetail.DecClient;
begin
  Dec(FClientCount);
  Assert(FClientCount >= 0);

  if FClientCount = 0 then
  begin
    qComponentsDetailEx.Lock := True;
    qComponentsEx.Lock := True;
  end;
end;

procedure TComponentsExMasterDetail.DoAfterOpen(Sender: TObject);
begin
  LoadParameterValues;
end;

procedure TComponentsExMasterDetail.DoBeforeOpen(Sender: TObject);
var
  AData: TfrmDataModule;
  AFDQuery: TFDQuery;
  AFieldName: String;
  AFieldType: TFieldType;
  ASize: Integer;
begin
  AData := Sender as TfrmDataModule;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  AFDQuery.FieldDefs.Update;

  QueryParametersForCategory.Load(AData.ParentValue);
  QueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    ASize := 0;
    // AFieldType := ftInteger;

    case QueryParametersForCategory.FieldType.AsInteger of
      // целое число
      1:
        AFieldType := ftInteger;
      2: // строка
        begin
          AFieldType := ftString;
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
      AFieldType := ftString;
      ASize := 200;
    end;

    AFieldName := GetFieldName(FQueryParametersForCategory.ID.AsInteger);
    // Добавляем очередное поле
    AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
    FQueryParametersForCategory.FDQuery.Next;
  end;

  AData.CreateDefaultFields(False);

  FQueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    AFieldName := GetFieldName(FQueryParametersForCategory.ID.AsInteger);
    AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    FQueryParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExMasterDetail.OnFDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TComponentsExMasterDetail.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TComponentsExMasterDetail.GetIDParameter(const AFieldName
  : String): Integer;
var
  S: string;
begin
  S := AFieldName.Remove(0, FFieldPrefix.Length);
  Result := S.ToInteger();
end;

procedure TComponentsExMasterDetail.LoadParameterValues;
var
  AField: TField;
  qryComponents: TfrmDataModule;
  AFieldName: String;
  ANewValue: string;
  AValue: string;
  OK: Boolean;
begin
  // Зашружаем значения параметров из БД
  FQueryProductParameters.Load(qComponentsEx.ParentValue);

  qComponentsEx.FDQuery.DisableControls;
  qComponentsDetailEx.FDQuery.DisableControls;
  try
    FQueryProductParameters.FDQuery.First;
    while not FQueryProductParameters.FDQuery.Eof do
    begin
      if FQueryProductParameters.ParentProductID.IsNull then
        qryComponents := qComponentsEx
      else
        qryComponents := qComponentsDetailEx;

      OK := qryComponents.LocateByPK(FQueryProductParameters.ProductID.Value);
      Assert(OK);
      // if OK then
      // begin
      AFieldName := GetFieldName(FQueryProductParameters.ParameterID.AsInteger);
      ANewValue := Format('%s%s%s',
        [FMark, FQueryProductParameters.Value.AsString.Trim, FMark]);
      if not ANewValue.IsEmpty then
      begin
        // Возможно такого параметра у нашей категории уже нет
        AField := qryComponents.FDQuery.FindField(AFieldName);
        // Если такой параметр у нашей категории есть
        if AField <> nil then
        begin
          AValue := AField.AsString.Trim;
          if AValue <> '' then
            AValue := AValue + #13#10;
          AValue := AValue + ANewValue;

          qryComponents.TryEdit;
          AField.AsString := AValue;
          qryComponents.TryPost;
        end;
      end;
      // end;
      FQueryProductParameters.FDQuery.Next;
    end;
  finally
    qComponentsDetailEx.FDQuery.EnableControls;
    qComponentsEx.FDQuery.EnableControls;
  end;

  ClearUpdateCount();
end;

procedure TComponentsExMasterDetail.UpdateData;
begin
  QueryParametersForCategory.FDQuery.Params.ParamByName(QueryParametersForCategory.DetailParameterName).AsInteger := 0;
  QueryProductParameters.FDQuery.Params.ParamByName(QueryProductParameters.DetailParameterName).AsInteger := 0;
  // Запросы нужно обновить, но мастер у них не изменился
  qComponentsDetailEx.TryRefresh;
  qComponentsEx.TryRefresh;
end;

end.
