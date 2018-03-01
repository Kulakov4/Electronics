unit CategoryParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Data.DB, CategoryParametersQuery2,
  System.Generics.Collections, NotifyEvents, DBRecordHolder,
  SearchParamDefSubParamQuery, SearchParamSubParamQuery, DragHelper,
  ParamSubParamsQuery, System.Generics.Defaults, UpdateNegativeOrdQuery;

type
  TCategoryFDMemTable = class(TFDMemTable)
  private
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetPosID: TField;
  protected
    procedure DeleteTail(AFromRecNo: Integer);
    function LocateByField(const AFieldName: string; AValue: Variant;
      TestResult: Boolean = False): Boolean;
  public
    procedure AppendFrom(ASource: TCategoryFDMemTable);
    function GetFieldValues(const AFieldName: string): String;
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
    function LocateByPK(AValue: Integer; TestResult: Boolean = False): Boolean;
    procedure SetOrder(AOrder: Integer);
    procedure Update(ASource: TCategoryFDMemTable);
    procedure UpdateFrom(ASource: TCategoryFDMemTable);
    procedure UpdatePK(APKDictionary: TDictionary<Integer, Integer>);
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property PosID: TField read GetPosID;
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetIsDefault: TField;
    function GetParameterType: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
    function GetVID: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AVID, AID, AIDParameter: Integer;
      const AValue, ATableName, AValueT, AParameterType: String;
      AIsAttribute, AIsDefault, APosID, AOrd: Integer);
    function LocateByParameterID(AIDParameter: Integer): Boolean;
    function LocateByVID(AValue: Integer; TestResult: Boolean = False): Boolean;
    property IDParameter: TField read GetIDParameter;
    property IsDefault: TField read GetIsDefault;
    property ParameterType: TField read GetParameterType;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
    property VID: TField read GetVID;
  end;

  TQryCategorySubParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetIDParent: TField;
    function GetIDSubParameter: TField;
    function GetName: TField;
    function GetParamSubParamID: TField;
    function GetTranslation: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AID, AIDParent, AIDParameter, AParamSubParamId,
      AIDSubParameter: Integer; const AName, ATranslation: String;
      AIsAttribute, APosID, AOrd: Integer);
    procedure DeleteByIDParent(AIDCategoryParam: Integer);
    procedure FilterByIDParent(AIDCategoryParam: Integer);
    procedure FilterByIDParameter(AParameterID: Integer);
    function Locate2(AIDParent, AIDSubParameter: Integer;
      TestResult: Boolean = False): Boolean;
    property IDParameter: TField read GetIDParameter;
    property IDParent: TField read GetIDParent;
    property IDSubParameter: TField read GetIDSubParameter;
    property Name: TField read GetName;
    property ParamSubParamID: TField read GetParamSubParamID;
    property Translation: TField read GetTranslation;
  end;

  TCategoryParametersGroup = class(TQueryGroup)
  private
    FAfterUpdateData: TNotifyEventsEx;
    FBeforeUpdateData: TNotifyEventsEx;
    FFDQCategoryParameters: TQryCategoryParameters;
    FqCategoryParameters: TQueryCategoryParameters2;
    FFDQCategorySubParameters: TQryCategorySubParameters;
    FIDDic: TDictionary<Integer, Integer>;
    FqCatParams: TQryCategoryParameters;
    FqCatSubParams: TQryCategorySubParameters;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParamSubParam: TQuerySearchParamSubParam;
    FqUpdNegativeOrd: TQueryUpdNegativeOrd;
    FVID: Integer;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsAllQuerysActive: Boolean;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParamSubParam: TQuerySearchParamSubParam;
    function GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
    { Private declarations }
  protected
    procedure AppendParameter(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName, ATranslation: String; AIsDefault: Integer);
    procedure AppendSubParameter(AID, ASubParamID: Integer);
    function GetHaveAnyChanges: Boolean; override;
    function GetVirtualID(AID: Integer; AUseDic: Boolean): Integer;
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParamSubParam: TQuerySearchParamSubParam
      read GetqSearchParamSubParam;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddOrDeleteSubParameters(AID: Integer; ASubParamIDList: string);
    procedure AddOrDeleteParameters(AParamIDList: string; APosID: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DeleteParameters(APKValues: array of Integer);
    procedure DeleteSubParameters(APKValues: array of Integer);
    function GetIDList(AID: Integer): TArray<Integer>;
    procedure UpdateData;
    procedure LoadData;
    procedure MoveParameters(IDList: TList<Integer>; TargetID: Integer;
      AUp: Boolean);
    procedure MoveSubParameters(IDList: TList<Integer>; TargetID: Integer;
      AUp: Boolean);
    procedure RefreshData; override;
    procedure SetPos(AIDArray: TArray<Integer>; AWithSubParams: Boolean;
      APosID: Integer);
    property AfterUpdateData: TNotifyEventsEx read FAfterUpdateData;
    property BeforeUpdateData: TNotifyEventsEx read FBeforeUpdateData;
    property IsAllQuerysActive: Boolean read GetIsAllQuerysActive;
    property qCategoryParameters: TQueryCategoryParameters2
      read FqCategoryParameters;
    property qCatParams: TQryCategoryParameters read FqCatParams;
    property qCatSubParams: TQryCategorySubParameters read FqCatSubParams;
    property qUpdNegativeOrd: TQueryUpdNegativeOrd read GetqUpdNegativeOrd;
    { Public declarations }
  end;

implementation

uses
  System.StrUtils, System.Math, MoveHelper;

constructor TQryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('VID', ftInteger);
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDParameter', ftInteger);
  FieldDefs.Add('Value', ftWideString, 200);
  FieldDefs.Add('TableName', ftWideString, 200);
  FieldDefs.Add('ValueT', ftWideString, 200);
  FieldDefs.Add('ParameterType', ftWideString, 30);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('IsDefault', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
  IndexFieldNames := Format('%s;%s', [PosID.FieldName, Ord.FieldName]);
end;

procedure TQryCategoryParameters.AppendR(AVID, AID, AIDParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType: String;
  AIsAttribute, AIsDefault, APosID, AOrd: Integer);
begin
  Append;
  VID.Value := AVID;
  ID.Value := AID;
  IDParameter.Value := AIDParameter;
  Value.Value := AValue;
  TableName.Value := ATableName;
  ValueT.Value := AValueT;
  ParameterType.Value := AParameterType;
  IsAttribute.Value := AIsAttribute;
  IsDefault.Value := AIsDefault;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

function TQryCategoryParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TQryCategoryParameters.GetIsDefault: TField;
begin
  Result := FieldByName('IsDefault');
end;

function TQryCategoryParameters.GetParameterType: TField;
begin
  Result := FieldByName('ParameterType');
end;

function TQryCategoryParameters.GetTableName: TField;
begin
  Result := FieldByName('TableName');
end;

function TQryCategoryParameters.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

function TQryCategoryParameters.GetValueT: TField;
begin
  Result := FieldByName('ValueT');
end;

function TQryCategoryParameters.GetVID: TField;
begin
  Result := FieldByName('VID');
end;

function TQryCategoryParameters.LocateByParameterID(AIDParameter
  : Integer): Boolean;
begin
  Assert(AIDParameter > 0);
  Result := LocateEx(IDParameter.FieldName, AIDParameter);
end;

function TQryCategoryParameters.LocateByVID(AValue: Integer;
  TestResult: Boolean = False): Boolean;
begin
  Assert(AValue <> 0);
  Result := LocateEx(VID.FieldName, AValue);
  if TestResult then
    Assert(Result);
end;

constructor TQryCategorySubParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDParent', ftInteger);
  FieldDefs.Add('IDParameter', ftInteger);
  FieldDefs.Add('ParamSubParamID', ftInteger);
  FieldDefs.Add('IDSubParameter', ftInteger);
  FieldDefs.Add('Name', ftWideString, 200);
  FieldDefs.Add('Translation', ftWideString, 200);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
  IndexFieldNames := Format('%s;%s;%s', [IDParent.FieldName, PosID.FieldName,
    Ord.FieldName]);
end;

procedure TQryCategorySubParameters.AppendR(AID, AIDParent, AIDParameter,
  AParamSubParamId, AIDSubParameter: Integer; const AName, ATranslation: String;
  AIsAttribute, APosID, AOrd: Integer);
begin
  Append;
  ID.Value := AID;
  IDParent.Value := AIDParent;
  IDParameter.Value := AIDParameter;
  ParamSubParamID.Value := AParamSubParamId;
  IDSubParameter.Value := AIDSubParameter;
  Name.Value := AName;
  Translation.Value := ATranslation;
  IsAttribute.Value := AIsAttribute;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

procedure TQryCategorySubParameters.DeleteByIDParent(AIDCategoryParam: Integer);
begin
  Assert(AIDCategoryParam > 0);

  DisableControls;
  try
    while LocateEx(IDParent.FieldName, AIDCategoryParam) do
      Delete;
  finally
    EnableControls;
  end;
end;

procedure TQryCategorySubParameters.FilterByIDParent(AIDCategoryParam: Integer);
begin
  Assert(AIDCategoryParam <> 0);
  Filter := Format('%s = %d', [IDParent.FieldName, AIDCategoryParam]);
  Filtered := True;
end;

procedure TQryCategorySubParameters.FilterByIDParameter(AParameterID: Integer);
begin
  Assert(AParameterID <> 0);
  Filter := Format('%s = %d', [IDParameter.FieldName, AParameterID]);
  Filtered := True;
end;

function TQryCategorySubParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TQryCategorySubParameters.GetIDParent: TField;
begin
  Result := FieldByName('IDParent');
end;

function TQryCategorySubParameters.GetIDSubParameter: TField;
begin
  Result := FieldByName('IDSubParameter');
end;

function TQryCategorySubParameters.GetName: TField;
begin
  Result := FieldByName('Name');
end;

function TQryCategorySubParameters.GetParamSubParamID: TField;
begin
  Result := FieldByName('ParamSubParamID');
end;

function TQryCategorySubParameters.GetTranslation: TField;
begin
  Result := FieldByName('Translation');
end;

function TQryCategorySubParameters.Locate2(AIDParent, AIDSubParameter: Integer;
  TestResult: Boolean = False): Boolean;
var
  AFieldNames: string;
begin
  Assert(AIDParent > 0);
  Assert(AIDSubParameter > 0);

  AFieldNames := Format('%s;%s', [IDParent.FieldName,
    IDSubParameter.FieldName]);
  Result := LocateEx(AFieldNames, VarArrayOf([AIDParent, AIDSubParameter]));
  if TestResult then
    Assert(Result);
end;

constructor TCategoryParametersGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqCategoryParameters := TQueryCategoryParameters2.Create(Self);
  FFDQCategoryParameters := TQryCategoryParameters.Create(Self);
  FFDQCategorySubParameters := TQryCategorySubParameters.Create(Self);

  FqCatParams := TQryCategoryParameters.Create(Self);
  FqCatSubParams := TQryCategorySubParameters.Create(Self);

  TNotifyEventWrap.Create(FqCategoryParameters.AfterLoad, DoAfterLoad);

  FBeforeUpdateData := TNotifyEventsEx.Create(Self);
  FAfterUpdateData := TNotifyEventsEx.Create(Self);
  FIDDic := TDictionary<Integer, Integer>.Create;
end;

procedure TCategoryParametersGroup.AddOrDeleteSubParameters(AID: Integer;
  ASubParamIDList: string);
var
  AIDParameter: Integer;
  m: TArray<String>;
  S: String;
  S2: string;
  S1: String;
begin
  // Нужно добавить или удалить подпараметры

  // Ищем связку категория-параметр
  qCategoryParameters.LocateByPK(AID, True);
  AIDParameter := qCategoryParameters.IDParameter.AsInteger;

  // получаем все подпараметры нашего параметра
  // Они могут быть расположены в разных группах!!!
  S1 := Format(',%s,', [qCategoryParameters.GetAllIDSubParamList]);

  // Обработка добавленных галочек - подпараметров
  m := ASubParamIDList.Split([',']);
  for S in m do
  begin
    // Если хотим добавить новый подпараметр
    if S1.IndexOf(Format(',%s,', [S])) = -1 then
      AppendSubParameter(AID, S.ToInteger);
  end;

  // Обработка снятых галочек - подпараметров
  S2 := Format(',%s,', [ASubParamIDList]);
  m := S1.Trim([',']).Split([',']);
  for S in m do
  begin
    // Если хотим удалить старый подпараметр
    if S2.IndexOf(Format(',%s,', [S])) = -1 then
    begin
      // Мы знаем код параметра и код подпараметра для удаления
      // Ищем запись об удаляемом подпараметре
      qCategoryParameters.Locate(AIDParameter, S.ToInteger, True);
      // Удаляем такой подпараметр
      DeleteSubParameters([qCategoryParameters.PK.AsInteger]);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.AddOrDeleteParameters(AParamIDList: string;
  APosID: Integer);
var
  AIDParam: String;
  m: TArray<String>;
  S: string;
begin
  // Нужно добавить или удалить параметры

  // Список идентификаторов параметров нашей категории, которые не имеют подпараметров!
  qCategoryParameters.FilterByIsDefault(1);
  try
    S := Format(',%s,',
      [qCategoryParameters.GetFieldValues(qCategoryParameters.IDParameter.
      FieldName)]);
  finally
    qCategoryParameters.FDQuery.Filtered := False;
  end;

  m := S.Trim([',']).Split([',']);
  // Цикл по параметрам для категории
  for AIDParam in m do
  begin
    // Если галочку с одного из параметров категории сняли
    if AParamIDList.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      // Надо найти параметр без подпараметров
      qCategoryParameters.LocateDefault(AIDParam.ToInteger, True);
      DeleteParameters([qCategoryParameters.PK.AsInteger]);
    end;
  end;

  m := AParamIDList.Trim([',']).Split([',']);
  // Цикл по отмеченным в справочнике подпараметрам
  for AIDParam in m do
  begin
    // Если галочку поставили
    if S.IndexOf(',' + AIDParam + ',') < 0 then
    begin
      // ищем полную информацию об этом параметре
      qSearchParamDefSubParam.SearchByID(AIDParam.ToInteger, 1);

      // Добавляем параметр
      AppendParameter(qSearchParamDefSubParam.ParamSubParamID.Value,
        qCategoryParameters.NextOrder, 1, APosID,
        qSearchParamDefSubParam.PK.Value,
        qSearchParamDefSubParam.IDSubParameter.Value,
        qSearchParamDefSubParam.Value.Value,
        qSearchParamDefSubParam.TableName.Value,
        qSearchParamDefSubParam.ValueT.Value,
        qSearchParamDefSubParam.ParameterType.Value, '', '', 1);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.AppendParameter(AParamSubParamId, AOrd,
  AIsAttribute, APosID, AIDParameter, AIDSubParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType, AName,
  ATranslation: String; AIsDefault: Integer);
begin
  FqCategoryParameters.AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
    AIDParameter, AIDSubParameter, AValue, ATableName, AValueT, AParameterType,
    AName, ATranslation, AIsDefault);
end;

procedure TCategoryParametersGroup.AppendSubParameter(AID,
  ASubParamID: Integer);
var
  AClone: TFDMemTable;
  AOrder: Integer;
  APosID: Integer;
  rc: Integer;
begin
  Assert(AID <> 0);
  Assert(ASubParamID > 0);

  // Ищем связку категория-параметр
  qCategoryParameters.LocateByPK(AID, True);

  // Нужно добавить подпараметр к параметру, если у него его ещё не было
  rc := qParamSubParams.SearchBySubParam
    (qCategoryParameters.IDParameter.AsInteger, ASubParamID);
  // Если у этого параметра нет такого подпараметра
  if rc = 0 then
  begin
    qParamSubParams.AppendSubParameter
      (qCategoryParameters.IDParameter.AsInteger, ASubParamID);

    Assert(qParamSubParams.FDQuery.RecordCount > 0);
  end;

  // Выбираем полную информацию о этом подпараметре
  qSearchParamSubParam.SearchByID(qParamSubParams.PK.Value, 1);

  // Получам подпараметры текущего параметра
  AClone := qCategoryParameters.CreateSubParamsClone;
  try
    // Если этот параметр ещё не имеет подпараметров
    if (AClone.RecordCount = 1) and (qCategoryParameters.IsDefault.AsInteger = 1)
    then
    begin
      // Надо заменить подпараметр по умолчанию на добавляемый подпараметр
      qCategoryParameters.TryEdit;
      qCategoryParameters.ParamSubParamID.AsInteger := qParamSubParams.PK.Value;
      qCategoryParameters.Name.Value := qParamSubParams.Name.Value;
      qCategoryParameters.Translation.Value :=
        qParamSubParams.Translation.Value;
      qCategoryParameters.IsDefault.AsInteger := 0;
      qCategoryParameters.TryPost;
    end
    else
    begin
      // Добавлять подпараметр будем в конец!
      AClone.Last;
      // новое значение порядка
      AOrder := AClone.FieldByName(qCategoryParameters.Ord.FieldName)
        .AsInteger + 1;
      APosID := qCategoryParameters.PosID.AsInteger;
      // увеличим значение порядка всех параметров/подпараметров на 1.
      // Они сместятся вниз!
      qCategoryParameters.IncOrder(AOrder);

      // Добавляем подпараметр
      qCategoryParameters.AppendR(qSearchParamSubParam.PK.Value, AOrder, 1,
        APosID, qSearchParamSubParam.IDParameter.Value,
        qSearchParamSubParam.IDSubParameter.Value,
        qSearchParamSubParam.Value.Value, qSearchParamSubParam.TableName.Value,
        qSearchParamSubParam.ValueT.Value,
        qSearchParamSubParam.ParameterType.Value,
        qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
        qSearchParamSubParam.IsDefault.Value);

    end;
  finally
    qCategoryParameters.DropClone(AClone);
  end;
end;

procedure TCategoryParametersGroup.ApplyUpdates;
var
  AID: Integer;
  AKey: Integer;
  VID: Integer;
begin

  FqCategoryParameters.FDQuery.Connection.StartTransaction;

  // Тут все сделанные изменения применятся рекурсивно ко всей БД
  FqCategoryParameters.ApplyUpdates;

  // Проверяем, успешно ли
  if FqCategoryParameters.HaveAnyChanges then
  begin
    FqCategoryParameters.FDQuery.Connection.Rollback;
    Exit;
  end;

  // Меняем отрицательный порядок на положительный!
  qUpdNegativeOrd.FDQuery.ExecSQL;

  if FqCategoryParameters.PKDictionary.Count > 0 then
  begin
    // Тут надо обновить виртуальные идентификаторы на реальные
    FFDQCategoryParameters.UpdatePK(FqCategoryParameters.PKDictionary);
    FFDQCategorySubParameters.UpdatePK(FqCategoryParameters.PKDictionary);
    qCatParams.UpdatePK(FqCategoryParameters.PKDictionary);
    qCatSubParams.UpdatePK(FqCategoryParameters.PKDictionary);

    for AKey in FqCategoryParameters.PKDictionary.Keys do
    begin
      // Если такой ключ принадлежит подпараметру
      if not FIDDic.ContainsKey(AKey) then
        Continue;

      AID := FqCategoryParameters.PKDictionary[AKey];
      // Новый ключ БД -> VID
      VID := FIDDic[AKey];
      FIDDic.Add(AID, VID);
      FIDDic.Remove(AKey);
    end;
  end;
  FqCategoryParameters.FDQuery.Connection.Commit;
end;

procedure TCategoryParametersGroup.CancelUpdates;
begin
  // Тут все сделанные изменения отменяются
  FqCategoryParameters.CancelUpdates;

  LoadData;
end;

procedure TCategoryParametersGroup.DeleteParameters
  (APKValues: array of Integer);
var
  AClone: TFDMemTable;
  AID: Integer;
begin
  for AID in APKValues do
  begin
    qCategoryParameters.LocateByPK(AID);
    // Получаем все подпараметры, относящиеся к текущей записи
    AClone := qCategoryParameters.CreateSubParamsClone;
    try
      // Удаляем всё
      while not AClone.Eof do
        AClone.Delete;
    finally
      qCategoryParameters.DropClone(AClone);
    end;
  end;
  LoadData;
end;

procedure TCategoryParametersGroup.DeleteSubParameters
  (APKValues: array of Integer);
var
  AClone: TFDMemTable;
  AID: Integer;
  VID: Integer;
begin
  for AID in APKValues do
  begin
    qCategoryParameters.LocateByPK(AID, True);
    AClone := qCategoryParameters.CreateSubParamsClone;
    try
      // Если этот параметр имел единстенный подпараметр
      if AClone.RecordCount = 1 then
      begin
        // Выбираем информацию о том, какой подпараметр "по умолчанию" у нашего параметра
        qSearchParamDefSubParam.SearchByID
          (qCategoryParameters.IDParameter.AsInteger, 1);

        qCategoryParameters.TryEdit;
        // Меняем ссылку на связанный с параметром подпараметр
        qCategoryParameters.ParamSubParamID.Value :=
          qSearchParamDefSubParam.ParamSubParamID.Value;
        qCategoryParameters.IDSubParameter.Value :=
          qSearchParamDefSubParam.IDSubParameter.Value;
        qCategoryParameters.IsDefault.AsInteger := 1;
        qCategoryParameters.Name.Value := qSearchParamDefSubParam.Name.Value;
        qCategoryParameters.Translation.Value :=
          qSearchParamDefSubParam.Translation.Value;
        qCategoryParameters.TryPost;
      end
      else
      begin
        // Удаляем подпараметр;
        qCategoryParameters.FDQuery.Delete;
        Assert(AClone.RecordCount > 0);
        // Если мы удалили первый подпараметр
        if FIDDic.ContainsKey(AID) then
        begin
          // Виртуальный ID соотв. удалённому
          VID := FIDDic[AID];
          FIDDic.Remove(AID);
          // Добавляем идентификатор первого подпараметра
          FIDDic.Add(AClone.FieldByName(qCategoryParameters.PKFieldName)
            .AsInteger, VID);
        end;
      end;
    finally
      qCategoryParameters.DropClone(AClone);
    end;
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.DoAfterLoad(Sender: TObject);
begin
  FVID := 0;
  FIDDic.Clear;
  LoadData;
end;

function TCategoryParametersGroup.GetHaveAnyChanges: Boolean;
begin
  Result := qCategoryParameters.HaveAnyChanges;
end;

function TCategoryParametersGroup.GetIsAllQuerysActive: Boolean;
begin
  Result := qCategoryParameters.FDQuery.Active and
    FFDQCategoryParameters.Active and FFDQCategorySubParameters.Active;
end;

function TCategoryParametersGroup.GetVirtualID(AID: Integer;
  AUseDic: Boolean): Integer;
begin
  Assert(not AUseDic or (AUseDic and (FIDDic.Count > 0)));

  // Если значение виртуального идентификатора берём из словаря
  if AUseDic and FIDDic.ContainsKey(AID) then
  begin
    Result := FIDDic[AID]
  end
  else
  begin
    // В словаре такой записи нет. Видимо эту запись добавили
    Assert(FVID >= 0);
    Inc(FVID);
    FIDDic.Add(AID, FVID);
    Result := FVID;
  end;
end;

function TCategoryParametersGroup.GetqParamSubParams: TQueryParamSubParams;
begin
  if FqParamSubParams = nil then
    FqParamSubParams := TQueryParamSubParams.Create(Self);
  Result := FqParamSubParams;
end;

function TCategoryParametersGroup.GetqSearchParamDefSubParam
  : TQuerySearchParamDefSubParam;
begin
  if FqSearchParamDefSubParam = nil then
    FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create(Self);
  Result := FqSearchParamDefSubParam;
end;

function TCategoryParametersGroup.GetqSearchParamSubParam
  : TQuerySearchParamSubParam;
begin
  if FqSearchParamSubParam = nil then
    FqSearchParamSubParam := TQuerySearchParamSubParam.Create(Self);

  Result := FqSearchParamSubParam;
end;

function TCategoryParametersGroup.GetqUpdNegativeOrd: TQueryUpdNegativeOrd;
begin
  if FqUpdNegativeOrd = nil then
    FqUpdNegativeOrd := TQueryUpdNegativeOrd.Create(Self);
  Result := FqUpdNegativeOrd;
end;

function TCategoryParametersGroup.GetIDList(AID: Integer): TArray<Integer>;
var
  AClone: TFDMemTable;
  L: TList<Integer>;
begin
  Assert(AID > 0);
  // Хотябы одна группа должна существовать
  Assert(qCategoryParameters.FDQuery.RecordCount > 0);

  L := TList<Integer>.Create;
  try
    qCategoryParameters.LocateByPK(AID, True);
    AClone := qCategoryParameters.CreateSubParamsClone;
    try
      // Составляем список идентификаторов текущего бэнда
      while not AClone.Eof do
      begin
        L.Add(AClone.FieldByName(qCategoryParameters.PKFieldName).AsInteger);
        AClone.Next;
      end;
      Result := L.ToArray;
    finally
      qCategoryParameters.DropClone(AClone);
    end;
  finally
    FreeAndNil(L);
  end;
end;

procedure TCategoryParametersGroup.UpdateData;
begin
  FBeforeUpdateData.CallEventHandlers(Self);
  try
    qCatParams.Update(FFDQCategoryParameters);
    qCatSubParams.Update(FFDQCategorySubParameters);
  finally
    FAfterUpdateData.CallEventHandlers(Self);
  end;
end;

procedure TCategoryParametersGroup.LoadData;
var
  AFieldList: TStringList;
  AUseDic: Boolean;
  VID: Integer;
begin
  AUseDic := FIDDic.Count > 0;
  AFieldList := TStringList.Create;
  try
    FFDQCategorySubParameters.EmptyDataSet;
    FFDQCategoryParameters.EmptyDataSet;

    FFDQCategoryParameters.Fields.GetFieldNames(AFieldList);
    // Эти поля могут отличаться при группировке
    AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.ID.FieldName));
    AFieldList.Delete
      (AFieldList.IndexOf(FFDQCategoryParameters.IsAttribute.FieldName));
    AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.Ord.FieldName));
    Assert(AFieldList.Count > 0);

    qCategoryParameters.FDQuery.DisableControls;
    try
      qCategoryParameters.FDQuery.First;
      FFDQCategoryParameters.First;
      while not qCategoryParameters.FDQuery.Eof do
      begin
        FFDQCategoryParameters.LoadRecFrom(qCategoryParameters.FDQuery,
          AFieldList);
        if FFDQCategoryParameters.ID.IsNull then
        begin
          VID := GetVirtualID(qCategoryParameters.PK.AsInteger, AUseDic);
          FFDQCategoryParameters.Edit;
          FFDQCategoryParameters.VID.AsInteger := VID;
          FFDQCategoryParameters.ID.AsInteger :=
            qCategoryParameters.PK.AsInteger;
          FFDQCategoryParameters.IsAttribute.Value :=
            qCategoryParameters.IsAttribute.Value;
          FFDQCategoryParameters.Ord.Value := qCategoryParameters.Ord.Value;
          FFDQCategoryParameters.Post;
        end;

        if qCategoryParameters.IsDefault.AsInteger = 0 then
        begin
          FFDQCategorySubParameters.LoadRecFrom
            (qCategoryParameters.FDQuery, nil);

          FFDQCategorySubParameters.Edit;
          FFDQCategorySubParameters.IDParent.AsInteger :=
            FFDQCategoryParameters.VID.AsInteger;
          FFDQCategorySubParameters.Post;
        end;
        qCategoryParameters.FDQuery.Next;
      end;
    finally
      qCategoryParameters.FDQuery.EnableControls;
    end;
  finally
    FreeAndNil(AFieldList);
  end;
  UpdateData;
end;

procedure TCategoryParametersGroup.MoveParameters(IDList: TList<Integer>;
  TargetID: Integer; AUp: Boolean);
var
  AClone: TFDMemTable;
  AID: Integer;
  L: TDictionary<Integer, Integer>;
  ACount: Integer;
begin
  Assert(IDList.Count > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  L := TDictionary<Integer, Integer>.Create;
  try
    IDList.Add(TargetID);
    for AID in IDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // Количество переносимых записей

      qCategoryParameters.LocateByPK(AID, True);
      AClone := qCategoryParameters.CreateSubParamsClone;
      try
        while not AClone.Eof do
        begin
          L.Add(AClone.FieldByName(qCategoryParameters.PKFieldName).AsInteger,
            AClone.FieldByName(qCategoryParameters.Ord.FieldName).AsInteger);
          AClone.Next;
        end;
      finally
        qCategoryParameters.DropClone(AClone);
      end;
    end;

    qCategoryParameters.Move(TMoveHelper.Move(L.ToArray, AUp, ACount));
  finally
    FreeAndNil(L);
  end;
  LoadData;
end;

procedure TCategoryParametersGroup.MoveSubParameters(IDList: TList<Integer>;
  TargetID: Integer; AUp: Boolean);
var
  AClone: TFDMemTable;
  AID: Integer;
  L: TDictionary<Integer, Integer>;
  ACount: Integer;
  ANewID: Integer;
  AVID: Integer;
begin
  Assert(IDList.Count > 0);
  Assert(TargetID <> 0);
  ACount := 0;

  L := TDictionary<Integer, Integer>.Create;
  try
    IDList.Add(TargetID);
    for AID in IDList do
    begin
      if AID = TargetID then
        ACount := L.Count; // Количество переносимых записей

      qCategoryParameters.LocateByPK(AID, True);
      L.Add(qCategoryParameters.PK.Value, qCategoryParameters.Ord.Value);
    end;

    AClone := qCategoryParameters.CreateSubParamsClone;
    try
      // Идентификатор первого подпараметра
      AID := AClone.FieldByName(qCategoryParameters.PKFieldName).AsInteger;
      // Просим произвести перенос
      qCategoryParameters.Move(TMoveHelper.Move(L.ToArray, AUp, ACount));
      ANewID := AClone.FieldByName(qCategoryParameters.PKFieldName).AsInteger;
    finally
      qCategoryParameters.DropClone(AClone);
    end;

    // Если в ходе перемещения, на первое место встал другой подпараметр
    if ANewID <> AID then
    begin
      AVID := FIDDic[AID];
      FIDDic.Add(ANewID, AVID);
      FIDDic.Remove(AID);
    end;

  finally
    FreeAndNil(L);
  end;

  LoadData;
end;

procedure TCategoryParametersGroup.RefreshData;
begin
  qCategoryParameters.RefreshQuery;
  LoadData;
end;

procedure TCategoryParametersGroup.SetPos(AIDArray: TArray<Integer>;
  AWithSubParams: Boolean; APosID: Integer);
var
  AClone: TFDMemTable;
  AID: Integer;
  AIDList: TList<Integer>;
begin
  AIDList := TList<Integer>.Create;
  try
    for AID in AIDArray do
    begin
      qCategoryParameters.LocateByPK(AID);
      if AWithSubParams then
      begin
        AClone := qCategoryParameters.CreateSubParamsClone;
        try
          while not AClone.Eof do
          begin
            AIDList.Add(AClone.FieldByName(qCategoryParameters.PKFieldName)
              .AsInteger);
            AClone.Next;
          end;
        finally
          qCategoryParameters.DropClone(AClone);
        end;
      end
      else
        AIDList.Add(qCategoryParameters.PK.AsInteger);
    end;

    // Просим изменить положение всех этих записей
    qCategoryParameters.SetPos(AIDList.ToArray, APosID);

  finally
    FreeAndNil(AIDList);
  end;
  LoadData;
end;

procedure TCategoryFDMemTable.AppendFrom(ASource: TCategoryFDMemTable);
var
  F: TField;
begin
  Assert(ASource <> nil);
  Append;
  for F in Fields do
    F.Value := ASource.FieldByName(F.FieldName).Value;
  Post;
end;

procedure TCategoryFDMemTable.DeleteTail(AFromRecNo: Integer);
begin
  if RecordCount < AFromRecNo then
    Exit;

  DisableControls;
  try

    while RecordCount >= AFromRecNo do
    begin
      RecNo := AFromRecNo;
      Delete;
    end;

  finally
    EnableControls;
  end;
end;

function TCategoryFDMemTable.GetFieldValues(const AFieldName: string): String;
begin
  Result := '';
  First;
  while not Eof do
  begin
    Result := Result + IfThen(Result <> '', ',', '') +
      FieldByName(AFieldName).AsString;
    Next;
  end;
end;

function TCategoryFDMemTable.GetID: TField;
begin
  Result := FieldByName('ID');
end;

function TCategoryFDMemTable.GetIsAttribute: TField;
begin
  Result := FieldByName('IsAttribute');
end;

function TCategoryFDMemTable.GetOrd: TField;
begin
  Result := FieldByName('Ord');
end;

function TCategoryFDMemTable.GetPosID: TField;
begin
  Result := FieldByName('PosID');
end;

procedure TCategoryFDMemTable.LoadRecFrom(ADataSet: TDataSet;
  AFieldList: TStrings);
var
  AFieldName: String;
  AFL: TStrings;
  AUF: TDictionary<String, Variant>;
  F: TField;
  FF: TField;
  NeedEdit: Boolean;
begin
  Assert(ADataSet <> nil);
  Assert(ADataSet.RecordCount > 0);

  if AFieldList = nil then
  begin
    AFL := TStringList.Create;
    ADataSet.Fields.GetFieldNames(AFL);
  end
  else
    AFL := AFieldList;

  Assert(AFL.Count > 0);

  NeedEdit := False;

  AUF := TDictionary<String, Variant>.Create;
  try
    // Цикл по всем полям
    for F in ADataSet.Fields do
    begin
      if AFL.IndexOf(F.FieldName) = -1 then
        Continue;

      FF := FindField(F.FieldName);
      if (FF <> nil) then
      begin
        NeedEdit := NeedEdit or (FF.Value <> F.Value);

        AUF.Add(FF.FieldName, F.Value);
      end;
    end;

    // Если есть отличающиеся заначения
    if NeedEdit then
    begin
      Append;

      for AFieldName in AUF.Keys do
      begin
        FieldByName(AFieldName).Value := AUF[AFieldName];
      end;

      Post;
    end;

  finally
    FreeAndNil(AUF);
    if AFieldList = nil then
      FreeAndNil(AFL);
  end;
end;

function TCategoryFDMemTable.LocateByField(const AFieldName: string;
  AValue: Variant; TestResult: Boolean = False): Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := LocateEx(AFieldName, AValue);
  if TestResult then
    Assert(Result);
end;

function TCategoryFDMemTable.LocateByPK(AValue: Integer;
  TestResult: Boolean = False): Boolean;
begin
  Assert(AValue <> 0);
  Result := LocateEx(ID.FieldName, AValue);
  if TestResult then
    Assert(Result);
end;

procedure TCategoryFDMemTable.SetOrder(AOrder: Integer);
begin
  Assert(AOrder > 0);
  Assert(RecordCount > 0);
  Edit;
  Ord.AsInteger := AOrder;
  Post;
end;

procedure TCategoryFDMemTable.Update(ASource: TCategoryFDMemTable);
var
  AID: Integer;
begin
  Assert(ASource <> nil);

  DisableControls;
  try
    AID := ID.AsInteger;
    ASource.First;
    while not ASource.Eof do
    begin
      // Если такой записи у нас ещё нет
      if not LocateByPK(ASource.ID.AsInteger) then
        AppendFrom(ASource)
      else
        UpdateFrom(ASource);
      ASource.Next;
    end;

    // Удаляем то, чего уже нет
    First;
    while not Eof do
    begin
      if not ASource.LocateByPK(ID.AsInteger) then
        Delete
      else
        Next;
    end;

    if AID <> 0 then
      LocateByPK(AID);
  finally
    EnableControls;
  end;
end;

procedure TCategoryFDMemTable.UpdateFrom(ASource: TCategoryFDMemTable);
var
  AFieldName: string;
  F: TField;
  UpdatedFields: TDictionary<String, Variant>;
begin
  UpdatedFields := TDictionary<String, Variant>.Create;
  try
    Assert(ASource <> nil);
    for F in Fields do
    begin
      if F.Value <> ASource.FieldByName(F.FieldName).Value then
        UpdatedFields.Add(F.FieldName, ASource.FieldByName(F.FieldName).Value);
    end;

    if UpdatedFields.Count > 0 then
    begin
      // Производим обновление записи
      Edit;
      for AFieldName in UpdatedFields.Keys do
        FieldByName(AFieldName).Value := UpdatedFields[AFieldName];
      Post;
    end;

  finally
    FreeAndNil(UpdatedFields)
  end;
end;

procedure TCategoryFDMemTable.UpdatePK(APKDictionary
  : TDictionary<Integer, Integer>);
var
  AClone: TFDMemTable;
  AField: TField;
  AID: Integer;
begin
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(Self);
    AField := AClone.FieldByName(ID.FieldName);

    for AID in APKDictionary.Keys do
    begin
      if not AClone.LocateEx(ID.FieldName, AID) then
        Continue;

      AClone.Edit;
      AField.AsInteger := APKDictionary[AField.AsInteger];
      AClone.Post;
    end;
  finally
    FreeAndNil(AClone);
  end;
end;

{$R *.dfm}

end.
