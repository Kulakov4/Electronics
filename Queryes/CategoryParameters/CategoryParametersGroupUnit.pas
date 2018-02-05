unit CategoryParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Data.DB, CategoryParametersQuery2,
  System.Generics.Collections, NotifyEvents, DBRecordHolder,
  SearchParamDefSubParamQuery, SearchParamSubParamQuery, DragHelper,
  ParamSubParamsQuery;

type
  TCategoryFDMemTable = class(TFDMemTable)
  private
    function GetID: TField;
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetPosID: TField;
  protected
    procedure DeleteTail(AFromRecNo: Integer);
  public
    function GetFieldValues(const AFieldName: string): String;
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
    function LocateByPK(Value: Integer): Boolean;
    procedure SetOrder(AOrder: Integer);
    procedure UpdatePK(APKDictionary: TDictionary<Integer, Integer>);
    property ID: TField read GetID;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property PosID: TField read GetPosID;
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIDParameter: TField;
    function GetParameterType: TField;
    function GetTableName: TField;
    function GetValue: TField;
    function GetValueT: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AID, AIDParameter: Integer;
      const AValue, ATableName, AValueT, AParameterType: String;
      AIsAttribute, APosID, AOrd: Integer);
    function LocateByParameterID(AIDParameter: Integer): Boolean;
    property IDParameter: TField read GetIDParameter;
    property ParameterType: TField read GetParameterType;
    property TableName: TField read GetTableName;
    property Value: TField read GetValue;
    property ValueT: TField read GetValueT;
  end;

  TQryCategorySubParameters = class(TCategoryFDMemTable)
  private
    function GetIDCategoryParam: TField;
    function GetIDSubParameter: TField;
    function GetName: TField;
    function GetParamSubParamID: TField;
    function GetTranslation: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendR(AID, AIDCategoryParam, AParamSubParamId, AIDSubParameter
      : Integer; const AName, ATranslation: String;
      AIsAttribute, APosID, AOrd: Integer);
    procedure DeleteByIDCategoryParam(AIDCategoryParam: Integer);
    procedure FilterByIDCategory(AIDCategoryParam: Integer);
    property IDCategoryParam: TField read GetIDCategoryParam;
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
    FqCatParams: TFDMemTable;
    FqCatSubParams: TFDMemTable;
    FqParamSubParams: TQueryParamSubParams;
    FqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    FqSearchParamSubParam: TQuerySearchParamSubParam;
    FVirtualID: Integer;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsAllQuerysActive: Boolean;
    function GetqParamSubParams: TQueryParamSubParams;
    function GetqSearchParamDefSubParam: TQuerySearchParamDefSubParam;
    function GetqSearchParamSubParam: TQuerySearchParamSubParam;
    { Private declarations }
  protected
    procedure AppendSubParameter(AID, ASubParamID: Integer);
    function IsVirtualID(AID: Integer): Boolean;
    property qParamSubParams: TQueryParamSubParams read GetqParamSubParams;
    property qSearchParamDefSubParam: TQuerySearchParamDefSubParam
      read GetqSearchParamDefSubParam;
    property qSearchParamSubParam: TQuerySearchParamSubParam
      read GetqSearchParamSubParam;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddOrDeleteSubParameters(AID: Integer; ASubParamIDList: string);
    procedure AppendParameter(AParamSubParamId, AOrd, AIsAttribute, APosID,
      AIDParameter, AIDSubParameter: Integer; const AValue, ATableName, AValueT,
      AParameterType, AName, ATranslation: String; AIsDefault: Integer);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DeleteParameters(APKValues: array of Variant);
    procedure DeleteSubParameters(APKValues: array of Variant);
    procedure DeleteParameter(AIDParameter: Integer);
    procedure UpdateData;
    property AfterUpdateData: TNotifyEventsEx read FAfterUpdateData;
    property BeforeUpdateData: TNotifyEventsEx read FBeforeUpdateData;
    property IsAllQuerysActive: Boolean read GetIsAllQuerysActive;
    property qCategoryParameters: TQueryCategoryParameters2
      read FqCategoryParameters;
    property qCatParams: TFDMemTable read FqCatParams;
    property qCatSubParams: TFDMemTable read FqCatSubParams;
    { Public declarations }
  end;

implementation

uses
  System.StrUtils;

const
  FirstVirtualID = -100000;

constructor TQryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDParameter', ftInteger);
  FieldDefs.Add('Value', ftWideString, 200);
  FieldDefs.Add('TableName', ftWideString, 200);
  FieldDefs.Add('ValueT', ftWideString, 200);
  FieldDefs.Add('ParameterType', ftWideString, 30);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
end;

procedure TQryCategoryParameters.AppendR(AID, AIDParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType: String;
  AIsAttribute, APosID, AOrd: Integer);
begin
  Append;
  ID.Value := AID;
  IDParameter.Value := AIDParameter;
  Value.Value := AValue;
  TableName.Value := ATableName;
  ValueT.Value := AValueT;
  ParameterType.Value := AParameterType;
  IsAttribute.Value := AIsAttribute;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

function TQryCategoryParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
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

function TQryCategoryParameters.LocateByParameterID(AIDParameter
  : Integer): Boolean;
begin
  Assert(AIDParameter > 0);
  Result := LocateEx(IDParameter.FieldName, AIDParameter);
end;

constructor TQryCategorySubParameters.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger);
  FieldDefs.Add('IDCategoryParam', ftInteger);
  FieldDefs.Add('ParamSubParamID', ftInteger);
  FieldDefs.Add('IDSubParameter', ftInteger);
  FieldDefs.Add('Name', ftWideString, 200);
  FieldDefs.Add('Translation', ftWideString, 200);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
end;

procedure TQryCategorySubParameters.AppendR(AID, AIDCategoryParam,
  AParamSubParamId, AIDSubParameter: Integer; const AName, ATranslation: String;
  AIsAttribute, APosID, AOrd: Integer);
begin
  Append;
  ID.Value := AID;
  IDCategoryParam.Value := AIDCategoryParam;
  ParamSubParamID.Value := AParamSubParamId;
  IDSubParameter.Value := AIDSubParameter;
  Name.Value := AName;
  Translation.Value := ATranslation;
  IsAttribute.Value := AIsAttribute;
  PosID.Value := APosID;
  Ord.AsInteger := AOrd;
  Post;
end;

procedure TQryCategorySubParameters.DeleteByIDCategoryParam(AIDCategoryParam
  : Integer);
begin
  Assert(AIDCategoryParam > 0);

  DisableControls;
  try
    while LocateEx(IDCategoryParam.FieldName, AIDCategoryParam) do
      Delete;
  finally
    EnableControls;
  end;
end;

procedure TQryCategorySubParameters.FilterByIDCategory(AIDCategoryParam
  : Integer);
begin
  Assert(AIDCategoryParam <> 0);
  Filter := Format('%s = %d', [IDCategoryParam.FieldName, AIDCategoryParam]);
  Filtered := True;
end;

function TQryCategorySubParameters.GetIDCategoryParam: TField;
begin
  Result := FieldByName('IDCategoryParam');
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

constructor TCategoryParametersGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqCategoryParameters := TQueryCategoryParameters2.Create(Self);
  FFDQCategoryParameters := TQryCategoryParameters.Create(Self);
  FFDQCategorySubParameters := TQryCategorySubParameters.Create(Self);

  // Создаём клон курсора
  FqCatParams := TFDMemTable.Create(Self);
  FqCatParams.CloneCursor(FFDQCategoryParameters);

  FqCatSubParams := TFDMemTable.Create(Self);
  FqCatSubParams.CloneCursor(FFDQCategorySubParameters);

  TNotifyEventWrap.Create(FqCategoryParameters.AfterLoad, DoAfterLoad);

  FBeforeUpdateData := TNotifyEventsEx.Create(Self);
  FAfterUpdateData := TNotifyEventsEx.Create(Self);
end;

procedure TCategoryParametersGroup.AddOrDeleteSubParameters(AID: Integer;
  ASubParamIDList: string);
var
  m: TArray<String>;
  S: String;
  S2: string;
  S1: String;
begin
  // Нужно добавить или удалить подпараметры

  // Ищем связку категория-параметр
  FFDQCategoryParameters.LocateByPK(AID);

  // Отфильтровываем подпараметры
  FFDQCategorySubParameters.FilterByIDCategory(AID);
  try
    // Получаем идентификаторы всех подпараметров текущего параметра
    S1 := Format(',%s,',
      [FFDQCategorySubParameters.GetFieldValues
      (FFDQCategorySubParameters.IDSubParameter.FieldName)]);
  finally
    FFDQCategorySubParameters.Filtered := False;
  end;

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
      DeleteSubParameters([S]);
  end;

end;

procedure TCategoryParametersGroup.AppendParameter(AParamSubParamId, AOrd,
  AIsAttribute, APosID, AIDParameter, AIDSubParameter: Integer;
  const AValue, ATableName, AValueT, AParameterType, AName,
  ATranslation: String; AIsDefault: Integer);
begin

  // Сначала добавляем это в "плоский" запрос, чтобы он хоть как-то вычислил ID
  // При сохранении в БД ID будет обновлён
  FqCategoryParameters.AppendR(AParamSubParamId, AOrd, AIsAttribute, APosID,
    AIDParameter, AIDSubParameter, AValue, ATableName, AValueT, AParameterType,
    AName, ATranslation, AIsDefault);

  // Затем добавим ту же запись в параметры
  FFDQCategoryParameters.AppendR(FqCategoryParameters.PK.Value, AIDParameter,
    AValue, ATableName, AValueT, AParameterType, AIsAttribute, APosID, AOrd);
end;

procedure TCategoryParametersGroup.AppendSubParameter(AID,
  ASubParamID: Integer);
var
  AIDParameter: Integer;
  ANewOrder: Integer;
  AOrder: Integer;
  APosID: Integer;
  ID: Integer;
  OK: Boolean;
  rc: Integer;
begin
  // Assert(AID > 0);
  Assert(ASubParamID > 0);

  // Ищем связку категория-параметр
  FFDQCategoryParameters.LocateByPK(AID);

  // Нужно добавить подпараметр к параметру, если у него его ещё не было
  rc := qParamSubParams.SearchBySubParam
    (FFDQCategoryParameters.IDParameter.AsInteger, ASubParamID);
  // Если у этого параметра нет такого подпараметра
  if rc = 0 then
  begin
    qParamSubParams.AppendSubParameter
      (FFDQCategoryParameters.IDParameter.AsInteger, ASubParamID);

    Assert(qParamSubParams.FDQuery.RecordCount > 0);
  end;

  // Выбираем полную информацию о этом подпараметре
  rc := qSearchParamSubParam.SearchByID(qParamSubParams.PK.Value);
  Assert(rc = 1);

  // Либо добавляем, либо обновляем
  // Если этот параметр уже имеет подпараметры
  if IsVirtualID(AID) then
  begin
    // Надо смещать порядок подпараметров вниз на 1
    APosID := FFDQCategoryParameters.PosID.AsInteger;
    AIDParameter := FFDQCategoryParameters.IDParameter.AsInteger;
    AOrder := FFDQCategoryParameters.Ord.AsInteger;

    // Выбираем подпараметры только текущего положения (В начале, в середине)
    qCategoryParameters.FilterByPosition(APosID);
    Assert(qCategoryParameters.FDQuery.RecordCount > 0);

    // Ищем первый подпараметр нашего параметра
    OK := qCategoryParameters.Locate(AIDParameter, APosID, AOrder);
    Assert(OK);

    // Ищем место, куда будем вставлять подпараметр
    while (not qCategoryParameters.FDQuery.Eof) and
      (qCategoryParameters.IDParameter.AsInteger = AIDParameter) do
    begin
      qCategoryParameters.FDQuery.Next;
    end;
    // Если вставлять подпараметр нужно в самый конец
    if (qCategoryParameters.FDQuery.Eof) then
    begin
      AOrder := qCategoryParameters.NextOrder;
    end
    else
    begin
      // Если вставлять нужно в середину какого-либо положения (в начале, в конце)
      // Нужно сместить всё что ниже вниз
      Assert(qCategoryParameters.IDParameter.AsInteger <> AIDParameter);
      ID := qCategoryParameters.PK.Value;
      // Всё что ниже, будем перемещать вниз
      qCategoryParameters.FDQuery.Last;
      ANewOrder := qCategoryParameters.Ord.AsInteger + 1;
      repeat
        AOrder := qCategoryParameters.Ord.AsInteger;
        qCategoryParameters.TryEdit;
        qCategoryParameters.Ord.AsInteger := ANewOrder;
        qCategoryParameters.TryPost;

        // Если поменяли положения параметра "по умолчанию"
        if qCategoryParameters.IsDefault.AsInteger = 1 then
        begin
          FFDQCategoryParameters.LocateByPK(qCategoryParameters.PK.Value);
          FFDQCategoryParameters.SetOrder(ANewOrder);
        end
        else
        begin
          // Если поменяли положение у подпараметра
          FFDQCategorySubParameters.LocateByPK(qCategoryParameters.PK.Value);
          FFDQCategoryParameters.LocateByPK
            (FFDQCategorySubParameters.IDCategoryParam.AsInteger);
          if FFDQCategoryParameters.Ord.AsInteger = FFDQCategorySubParameters.
            Ord.AsInteger then
            FFDQCategoryParameters.SetOrder(ANewOrder);
          FFDQCategorySubParameters.SetOrder(ANewOrder);
        end;
        ANewOrder := AOrder;
      until (qCategoryParameters.PK.Value = ID);
    end;

    // Сбрасываем фильтр
    qCategoryParameters.FDQuery.Filtered := False;

    // Добавляем подпараметр в "плоский" набор
    qCategoryParameters.AppendR(qSearchParamSubParam.PK.Value, AOrder, 1,
      APosID, qSearchParamSubParam.IDParameter.Value,
      qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Value.Value, qSearchParamSubParam.TableName.Value,
      qSearchParamSubParam.ValueT.Value,
      qSearchParamSubParam.ParameterType.Value, qSearchParamSubParam.Name.Value,
      qSearchParamSubParam.Translation.Value,
      qSearchParamSubParam.IsDefault.Value);

    FFDQCategorySubParameters.AppendR(qCategoryParameters.PK.Value, AID,
      qSearchParamSubParam.PK.Value, qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
      qCategoryParameters.IsAttribute.Value, APosID, AOrder);
  end
  else
  begin
    // Это первый добавленный подпараметр
    // Надо заменить подпараметр по умолчанию на него
    // Ищем подпараметр "по умолчанию" нашего параметра
    OK := qCategoryParameters.LocateByPK(AID);
    Assert(OK);
    Assert(qCategoryParameters.IsDefault.AsInteger = 1);

    // Меняем подпараметр "по умолчанию" на выбранный
    qCategoryParameters.TryEdit;
    qCategoryParameters.ParamSubParamID.AsInteger := qParamSubParams.PK.Value;
    qCategoryParameters.Name.Value := qParamSubParams.Name.Value;
    qCategoryParameters.Translation.Value := qParamSubParams.Translation.Value;
    qCategoryParameters.IsDefault.AsInteger := 0;
    qCategoryParameters.TryPost;

    // Делаем у параметра виртуальный ID
    Dec(FVirtualID);
    FFDQCategoryParameters.Edit;
    FFDQCategoryParameters.ID.Value := FVirtualID;
    FFDQCategoryParameters.Post;

    // Добавляем подпараметр
    FFDQCategorySubParameters.AppendR(AID, FFDQCategoryParameters.ID.Value,
      qParamSubParams.PK.Value, qSearchParamSubParam.IDSubParameter.Value,
      qSearchParamSubParam.Name.Value, qSearchParamSubParam.Translation.Value,
      FFDQCategoryParameters.IsAttribute.Value,
      FFDQCategoryParameters.PosID.Value, FFDQCategoryParameters.Ord.AsInteger);
  end;
end;

procedure TCategoryParametersGroup.ApplyUpdates;
begin
  // Тут все сделанные изменения применятся рекурсивно ко всей БД
  FqCategoryParameters.ApplyUpdates;

  if FqCategoryParameters.PKDictionary.Count > 0 then
  begin
    // Тут надо обновить виртуальные идентификаторы на реальные
    FFDQCategoryParameters.UpdatePK(FqCategoryParameters.PKDictionary);
    FFDQCategorySubParameters.UpdatePK(FqCategoryParameters.PKDictionary);
  end;
end;

procedure TCategoryParametersGroup.CancelUpdates;
begin
  // Тут все сделанные изменения отменяются
  FqCategoryParameters.CancelUpdates;

  UpdateData;
end;

procedure TCategoryParametersGroup.DeleteParameters
  (APKValues: array of Variant);
var
  ADeletedID: TList<Integer>;
  AID: Variant;
  OK: Boolean;
begin
  ADeletedID := TList<Integer>.Create;
  FFDQCategoryParameters.DisableControls;
  try
    for AID in APKValues do
    begin
      // Пока у параметра есть подпараметры
      while FFDQCategorySubParameters.LocateEx
        (FFDQCategorySubParameters.IDCategoryParam.FieldName, AID) do
      begin
        // Удаляем из "плоского" набора, если ещё не удалили
        if (AID > 0) and
          (ADeletedID.IndexOf(FFDQCategorySubParameters.ID.AsInteger) = -1) then
        begin
          OK := qCategoryParameters.LocateByPK
            (FFDQCategorySubParameters.ID.AsInteger);
          Assert(OK);
          qCategoryParameters.FDQuery.Delete;
        end;
        // Удаляем из подпараметров
        FFDQCategorySubParameters.Delete;
      end;

      // Удаляем из параметров
      OK := FFDQCategoryParameters.LocateEx
        (FFDQCategoryParameters.ID.FieldName, AID);
      Assert(OK);
      FFDQCategoryParameters.Delete;

      // Удаляем из "плоского" набора, если ещё не удалили
      if (AID > 0) and (ADeletedID.IndexOf(AID) = -1) then
      begin
        OK := qCategoryParameters.LocateByPK(AID);
        Assert(OK);
        qCategoryParameters.FDQuery.Delete;
      end;
    end;
  finally
    FFDQCategoryParameters.EnableControls;
    FreeAndNil(ADeletedID);
  end;
end;

procedure TCategoryParametersGroup.DeleteSubParameters
  (APKValues: array of Variant);
var
  AID: Variant;
  AVIDList: TList<Integer>;
  OK: Boolean;
  rc: Integer;
  V: Variant;
  VID: Integer;
begin
  AVIDList := TList<Integer>.Create;
  try
    for AID in APKValues do
    begin
      // Если удаляем подпараметры
      OK := FFDQCategorySubParameters.LocateEx
        (FFDQCategorySubParameters.ID.FieldName, AID);
      Assert(OK);

      FFDQCategorySubParameters.Delete;

      // Если этот подпараметр не первый в группе
      if not FFDQCategoryParameters.LocateEx
        (FFDQCategoryParameters.ID.FieldName, AID) then
      begin
        // Удаляем связь с ним
        OK := qCategoryParameters.LocateByPK(AID);
        Assert(OK);
        qCategoryParameters.FDQuery.Delete;
      end
      else
      begin
        AVIDList.Add(AID);
      end;
    end;

    // Список переметров, которые нужно связать с новым подпараметром
    for VID in AVIDList do
    begin
      // Ищем такой параметр
      OK := qCategoryParameters.LocateByPK(AID);
      Assert(OK);

      // Ишем, остались-ли у нашего параметра подпараметры
      OK := FFDQCategorySubParameters.LocateEx
        ((FFDQCategorySubParameters.IDCategoryParam.FieldName, VID, []);

        // Если остались, то заменим ссылку на подпараметр
        if OK then begin qCategoryParameters.TryEdit;
        // Меняем ссулку на связанный с параметром подпараметр
        qCategoryParameters.ParamSubParamID.Value :=
        FFDQCategorySubParameters.ParamSubParamID.Value;
        qCategoryParameters.Ord.Value := FFDQCategorySubParameters.Ord.Value;
        qCategoryParameters.IsAttribute.Value :=
        FFDQCategorySubParameters.IsAttribute.Value;
        qCategoryParameters.IDSubParameter.Value :=
        FFDQCategorySubParameters.IDSubParameter.Value;
        qCategoryParameters.TryPost; end else begin
        // Выбираем информацию о том, какой подпараметр "по умолчанию" у нашего параметра
        rc := qSearchParamDefSubParam.SearchByID
        (FFDQCategoryParameters.IDParameter.AsInteger); Assert(rc = 1);

        // Добавляем в "плоский" набор новый параметр
        qCategoryParameters.AppendR(qSearchParamDefSubParam.ParamSubParamID.
        Value, FFDQCategoryParameters.Ord.Value,
        FFDQCategoryParameters.IsAttribute.Value,
        FFDQCategoryParameters.PosID.Value, qSearchParamDefSubParam.PK.Value,
        qSearchParamDefSubParam.IDSubParameter.Value,
        qSearchParamDefSubParam.Value.Value,
        qSearchParamDefSubParam.TableName.Value,
        qSearchParamDefSubParam.ValueT.Value,
        qSearchParamDefSubParam.ParameterType.Value,
        qSearchParamDefSubParam.Name.Value,
        qSearchParamDefSubParam.Translation.Value,
        qSearchParamDefSubParam.IsDefault.Value);

        // Меняем виртуальный ID на временный, который потом заменим на настоящий при сохранении в БД
        FFDQCategoryParameters.Edit;
        FFDQCategoryParameters.ID.Value := qCategoryParameters.PK.Value;
        FFDQCategoryParameters.Post; end;

        // Ищем наш параметр, у которого не осталось подпараметров
        OK := FFDQCategoryParameters.LocateEx
        (FFDQCategoryParameters.ID.FieldName, VID); Assert(OK); end; end; end;
        finally FreeAndNil(AVIDList); end;

        // Полностью удаляет параметр вместе со всеми его подпараметрами
      procedure TCategoryParametersGroup.DeleteParameter(AIDParameter: Integer);
      begin Assert(AIDParameter > 0);

      FFDQCategoryParameters.DisableControls;
      try while FFDQCategoryParameters.LocateByParameterID
        (AIDParameter) do begin
      // Сначала надо удалить все подпарамеры
      FFDQCategorySubParameters.DeleteByIDCategoryParam
        (FFDQCategoryParameters.ID.AsInteger);
      // Потом удаляем сам параметр
      FFDQCategoryParameters.Delete; end;
      finally FFDQCategoryParameters.EnableControls; end;

      // Удаляем из "плоского" запроса
      FqCategoryParameters.FDQuery.DisableControls;
      try while FqCategoryParameters.LocateByField
        (FqCategoryParameters.IDParameter.FieldName, AIDParameter)
        do FqCategoryParameters.FDQuery.Delete;
      finally FqCategoryParameters.FDQuery.EnableControls; end; end;

      procedure TCategoryParametersGroup.DoAfterLoad(Sender: TObject);
      begin UpdateData; end;

      function TCategoryParametersGroup.GetIsAllQuerysActive: Boolean;
      begin Result := qCategoryParameters.FDQuery.Active and
        FFDQCategoryParameters.Active and FFDQCategorySubParameters.Active; end;

      function TCategoryParametersGroup.GetqParamSubParams
        : TQueryParamSubParams; begin if FqParamSubParams = nil
      then FqParamSubParams := TQueryParamSubParams.Create(Self);
      Result := FqParamSubParams; end;

      function TCategoryParametersGroup.GetqSearchParamDefSubParam
        : TQuerySearchParamDefSubParam; begin if FqSearchParamDefSubParam = nil
      then FqSearchParamDefSubParam := TQuerySearchParamDefSubParam.Create
        (Self); Result := FqSearchParamDefSubParam; end;

      function TCategoryParametersGroup.GetqSearchParamSubParam
        : TQuerySearchParamSubParam; begin if FqSearchParamSubParam = nil
      then FqSearchParamSubParam := TQuerySearchParamSubParam.Create(Self);

      Result := FqSearchParamSubParam; end;

      function TCategoryParametersGroup.IsVirtualID(AID: Integer): Boolean;
      begin Result := AID <= FirstVirtualID; end;

      procedure TCategoryParametersGroup.UpdateData;
      var AFieldList: TStringList;
      begin FBeforeUpdateData.CallEventHandlers(Self);
      AFieldList := TStringList.Create;
      try FFDQCategorySubParameters.EmptyDataSet;
      FFDQCategoryParameters.EmptyDataSet;

      FFDQCategoryParameters.Fields.GetFieldNames(AFieldList);
      // Эти поля могут отличаться при группировке
      AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.ID.FieldName)
        ); AFieldList.Delete(AFieldList.IndexOf
        (FFDQCategoryParameters.IsAttribute.FieldName));
      AFieldList.Delete(AFieldList.IndexOf(FFDQCategoryParameters.Ord.FieldName)
        ); Assert(AFieldList.Count > 0);

      qCategoryParameters.FDQuery.DisableControls;
      try qCategoryParameters.FDQuery.First; FFDQCategoryParameters.First;
      FVirtualID := FirstVirtualID;
      while not qCategoryParameters.FDQuery.Eof do begin FFDQCategoryParameters.
        LoadRecFrom(qCategoryParameters.FDQuery, AFieldList);
      if FFDQCategoryParameters.ID.IsNull
      then begin FFDQCategoryParameters.Edit;
      FFDQCategoryParameters.ID.AsInteger := qCategoryParameters.PK.AsInteger;
      FFDQCategoryParameters.IsAttribute.Value :=
        qCategoryParameters.IsAttribute.Value;
      FFDQCategoryParameters.Ord.Value := qCategoryParameters.Ord.Value;
      FFDQCategoryParameters.Post; end;

      if qCategoryParameters.IsDefault.AsInteger = 0
      then begin FFDQCategorySubParameters.LoadRecFrom
        (qCategoryParameters.FDQuery, nil);

      // Меняем реальный ID на виртуальный
      if FFDQCategoryParameters.ID.AsInteger > 0 then begin Dec(FVirtualID);
      FFDQCategoryParameters.Edit; FFDQCategoryParameters.ID.AsInteger :=
        FVirtualID; FFDQCategoryParameters.Post; end;

      FFDQCategorySubParameters.Edit;
      FFDQCategorySubParameters.IDCategoryParam.AsInteger :=
        FFDQCategoryParameters.ID.AsInteger; FFDQCategorySubParameters.Post;
      end; qCategoryParameters.FDQuery.Next; end;
      // FFDQCategorySubParameters.DeleteTail(FFDQCategorySubParameters.RecNo + 1);
      // FFDQCategoryParameters.DeleteTail(FFDQCategoryParameters.RecNo + 1);
      finally qCategoryParameters.FDQuery.EnableControls; end;
      finally FreeAndNil(AFieldList);
      FAfterUpdateData.CallEventHandlers(Self); end; end;

      procedure TCategoryFDMemTable.DeleteTail(AFromRecNo: Integer);
      begin if RecordCount < AFromRecNo then Exit;

      DisableControls; try

        while RecordCount >= AFromRecNo do begin RecNo := AFromRecNo;
      Delete; end;

      finally EnableControls; end; end;

      function TCategoryFDMemTable.GetFieldValues(const AFieldName: string)
        : String; begin Result := ''; First;
      while not Eof do begin Result := Result + IfThen(Result <> '', ',', '') +
        FieldByName(AFieldName).AsString; Next; end; end;

      function TCategoryFDMemTable.GetID: TField;
      begin Result := FieldByName('ID'); end;

      function TCategoryFDMemTable.GetIsAttribute: TField;
      begin Result := FieldByName('IsAttribute'); end;

      function TCategoryFDMemTable.GetOrd: TField;
      begin Result := FieldByName('Ord'); end;

      function TCategoryFDMemTable.GetPosID: TField;
      begin Result := FieldByName('PosID'); end;

      procedure TCategoryFDMemTable.LoadRecFrom(ADataSet: TDataSet;
        AFieldList: TStrings); var AFieldName: String; AFL: TStrings;
      AUF: TDictionary<String, Variant>; F: TField; FF: TField;
      NeedEdit: Boolean; begin Assert(ADataSet <> nil);
      Assert(ADataSet.RecordCount > 0);

      if AFieldList = nil then begin AFL := TStringList.Create;
      ADataSet.Fields.GetFieldNames(AFL); end else AFL := AFieldList;

      Assert(AFL.Count > 0);

      NeedEdit := False;

      AUF := TDictionary<String, Variant>.Create; try
      // Цикл по всем полям
        for F in ADataSet.Fields do begin if AFL.IndexOf(F.FieldName) = -1
      then Continue;

      FF := FindField(F.FieldName); if (FF <> nil) then begin NeedEdit :=
        NeedEdit or (FF.Value <> F.Value);

      AUF.Add(FF.FieldName, F.Value); end; end;

      // Если есть отличающиеся заначения
      if NeedEdit then begin Append;

      for AFieldName in AUF.Keys do begin FieldByName(AFieldName).Value :=
        AUF[AFieldName]; end;

      Post; end;

      finally FreeAndNil(AUF);
      if AFieldList = nil then FreeAndNil(AFL); end; end;

      function TCategoryFDMemTable.LocateByPK(Value: Integer): Boolean;
      begin Assert(Value <> 0); Result := LocateEx(ID.FieldName, Value);
      Assert(Result); end;

      procedure TCategoryFDMemTable.SetOrder(AOrder: Integer);
      begin Assert(AOrder > 0); Assert(RecordCount > 0); Edit;
      Ord.AsInteger := AOrder; Post; end;

      procedure TCategoryFDMemTable.UpdatePK(APKDictionary: TDictionary<Integer,
        Integer>); var AClone: TFDMemTable; AField: TField; AID: Integer;
      begin AClone := TFDMemTable.Create(Self);
      try AField := AClone.FieldByName(ID.FieldName); AClone.CloneCursor(Self);

      for AID in APKDictionary.Keys do begin if not AClone.LocateEx
        (ID.FieldName, AID) then Continue;

      AClone.Edit; AField.AsInteger := APKDictionary[AField.AsInteger];
      AClone.Post; end; finally FreeAndNil(AClone); end; end;

{$R *.dfm}
      end.
