unit CategoryParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  FireDAC.Comp.Client, Data.DB, CategoryParametersQuery2,
  System.Generics.Collections, NotifyEvents, DBRecordHolder,
  SearchParameterSubParameterQuery;

type
  TCategoryFDMemTable = class(TFDMemTable)
  private
    function GetID: TField;
  protected
    procedure DeleteTail(AFromRecNo: Integer);
  public
    procedure LoadRecFrom(ADataSet: TDataSet; AFieldList: TStrings);
    procedure UpdatePK(APKDictionary: TDictionary<Integer, Integer>);
    property ID: TField read GetID;
  end;

  TQryCategoryParameters = class(TCategoryFDMemTable)
  private
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetIDParameter: TField;
    function GetPosID: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendParameter(ARecordHolder: TRecordHolder);
    function LocateByParameterID(AIDParameter: Integer): Boolean;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property IDParameter: TField read GetIDParameter;
    property PosID: TField read GetPosID;
  end;

  TQryCategorySubParameters = class(TCategoryFDMemTable)
  private
    function GetIDCategoryParam: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteByIDCategoryParam(AIDCategoryParam: Integer);
    property IDCategoryParam: TField read GetIDCategoryParam;
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
    FqSearchParameterSubParameter: TQuerySearchParameterSubParameter;
    procedure DoAfterLoad(Sender: TObject);
    function GetIsAllQuerysActive: Boolean;
    function GetqSearchParameterSubParameter: TQuerySearchParameterSubParameter;
    { Private declarations }
  protected
    property qSearchParameterSubParameter: TQuerySearchParameterSubParameter
      read GetqSearchParameterSubParameter;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendParameter(ARecordHolder: TRecordHolder);
    procedure AppendSubParameter(ARecordHolder: TRecordHolder);
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

procedure TQryCategoryParameters.AppendParameter(ARecordHolder: TRecordHolder);
begin
  Assert(ARecordHolder <> nil);

  Append;
  ARecordHolder.TryPut(Self);
  Post;
end;

function TQryCategoryParameters.GetIsAttribute: TField;
begin
  Result := FieldByName('IsAttribute');
end;

function TQryCategoryParameters.GetOrd: TField;
begin
  Result := FieldByName('Ord');
end;

function TQryCategoryParameters.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TQryCategoryParameters.GetPosID: TField;
begin
  Result := FieldByName('PosID');
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
  FieldDefs.Add('Name', ftWideString, 200);
  FieldDefs.Add('Translation', ftWideString, 200);
  FieldDefs.Add('IsAttribute', ftInteger);
  FieldDefs.Add('PosID', ftInteger);
  FieldDefs.Add('Ord', ftInteger);

  CreateDataSet;
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

function TQryCategorySubParameters.GetIDCategoryParam: TField;
begin
  Result := FieldByName('IDCategoryParam');
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

procedure TCategoryParametersGroup.AppendParameter(ARecordHolder:
    TRecordHolder);
var
  ARH: TRecordHolder;
begin
  Assert(ARecordHolder <> nil);

  // Сначала добавляем это в "плоский" запрос, чтобы он хоть как-то вычислил ID
  // При сохранении в БД ID будет обновлён
  FqCategoryParameters.AppendParameter(ARecordHolder);

  ARH := TRecordHolder.Create(FqCategoryParameters.FDQuery);
  try
    // Затем добавим ту же запись в параметры
    FFDQCategoryParameters.AppendParameter(ARH);
  finally
    FreeAndNil(ARH);
  end;
end;

procedure TCategoryParametersGroup.AppendSubParameter(ARecordHolder:
    TRecordHolder);
begin
  // Добавляем подпараметр в "плоский" набор
  qCategoryParameters.AppendParameter(ARecordHolder);

  FFDQCategorySubParameters.Append;
  ARecordHolder.Put(FFDQCategorySubParameters);
  FFDQCategorySubParameters.Post;
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
  ARH: TRecordHolder;
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

      if AVIDList.IndexOf(FFDQCategorySubParameters.IDCategoryParam.
        AsInteger) = -1 then
        AVIDList.Add(FFDQCategorySubParameters.IDCategoryParam.AsInteger);

      FFDQCategorySubParameters.Delete;

      // Удаляем из плоского набора
      OK := qCategoryParameters.LocateByPK(AID);
      Assert(OK);
      qCategoryParameters.FDQuery.Delete;
    end;

    // Возможно надо заменить виртуальные идентификаторы реальными
    for VID in AVIDList do
    begin
      // Ишем, остались-ли у нашего параметра подпараметры
      V := FFDQCategorySubParameters.LookupEx
        (FFDQCategorySubParameters.IDCategoryParam.FieldName, VID,
        FFDQCategorySubParameters.ID.FieldName);

      // Если остались, то ничего менять не надо
      if not VarIsNull(V) then
        Continue;

      // Ищем наш параметр, у которого не осталось подпараметров
      OK := FFDQCategoryParameters.LocateEx
        (FFDQCategoryParameters.ID.FieldName, VID);
      Assert(OK);

      // Выбираем информацию о том, какой подпараметр "по умолчанию" у нашего параметра
      rc := qSearchParameterSubParameter.SearchByID
        (FFDQCategoryParameters.IDParameter.AsInteger);
      Assert(rc = 1);

      // Добавляем в "плоский" набор новый параметр
      ARH := TRecordHolder.Create(qSearchParameterSubParameter.FDQuery);
      try
        // ID меняем на IdParameter
        ARH.Find(qSearchParameterSubParameter.PKFieldName).FieldName :=
          qCategoryParameters.IDParameter.FieldName;

        // Порядок подпараметра будет тем-же
        TFieldHolder.Create(ARH, qCategoryParameters.Ord.FieldName,
          FFDQCategoryParameters.Ord.Value);

        // Позиция подпараметра будет той-же
        TFieldHolder.Create(ARH, qCategoryParameters.PosID.FieldName,
          FFDQCategoryParameters.PosID.Value);

        qCategoryParameters.AppendParameter(ARH);
      finally
        FreeAndNil(ARH);
      end;

      // Меняем виртуальный ID на временный, который потом заменим на настоящий при сохранении в БД
      FFDQCategoryParameters.Edit;
      FFDQCategoryParameters.ID.Value := qCategoryParameters.PK.Value;
      FFDQCategoryParameters.Post;
    end;

  finally
    FreeAndNil(AVIDList);
  end;
end;

// Полностью удаляет параметр вместе со всеми его подпараметрами
procedure TCategoryParametersGroup.DeleteParameter(AIDParameter: Integer);
begin
  Assert(AIDParameter > 0);

  FFDQCategoryParameters.DisableControls;
  try
    while FFDQCategoryParameters.LocateByParameterID(AIDParameter) do
    begin
      // Сначала надо удалить все подпарамеры
      FFDQCategorySubParameters.DeleteByIDCategoryParam
        (FFDQCategoryParameters.ID.AsInteger);
      // Потом удаляем сам параметр
      FFDQCategoryParameters.Delete;
    end;
  finally
    FFDQCategoryParameters.EnableControls;
  end;

  // Удаляем из "плоского" запроса
  FqCategoryParameters.FDQuery.DisableControls;
  try
    while FqCategoryParameters.LocateByField
      (FqCategoryParameters.IDParameter.FieldName, AIDParameter) do
      FqCategoryParameters.FDQuery.Delete;
  finally
    FqCategoryParameters.FDQuery.EnableControls;
  end;
end;

procedure TCategoryParametersGroup.DoAfterLoad(Sender: TObject);
begin
  UpdateData;
end;

function TCategoryParametersGroup.GetIsAllQuerysActive: Boolean;
begin
  Result := qCategoryParameters.FDQuery.Active and
    FFDQCategoryParameters.Active and FFDQCategorySubParameters.Active;
end;

function TCategoryParametersGroup.GetqSearchParameterSubParameter
  : TQuerySearchParameterSubParameter;
begin
  if FqSearchParameterSubParameter = nil then
    FqSearchParameterSubParameter :=
      TQuerySearchParameterSubParameter.Create(Self);
  Result := FqSearchParameterSubParameter;
end;

procedure TCategoryParametersGroup.UpdateData;
var
  AFieldList: TStringList;
  AID: Integer;
begin
  FBeforeUpdateData.CallEventHandlers(Self);
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
      AID := -100000;
      while not qCategoryParameters.FDQuery.Eof do
      begin
        FFDQCategoryParameters.LoadRecFrom(qCategoryParameters.FDQuery,
          AFieldList);
        if FFDQCategoryParameters.ID.IsNull then
        begin
          FFDQCategoryParameters.Edit;
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

          // Меняем реальный ID на виртуальный
          if FFDQCategoryParameters.ID.AsInteger > 0 then
          begin
            Dec(AID);
            FFDQCategoryParameters.Edit;
            FFDQCategoryParameters.ID.AsInteger := AID;
            FFDQCategoryParameters.Post;
          end;

          FFDQCategorySubParameters.Edit;
          FFDQCategorySubParameters.IDCategoryParam.AsInteger :=
            FFDQCategoryParameters.ID.AsInteger;
          FFDQCategorySubParameters.Post;
        end;
        qCategoryParameters.FDQuery.Next;
      end;
      // FFDQCategorySubParameters.DeleteTail(FFDQCategorySubParameters.RecNo + 1);
      // FFDQCategoryParameters.DeleteTail(FFDQCategoryParameters.RecNo + 1);
    finally
      qCategoryParameters.FDQuery.EnableControls;
    end;
  finally
    FreeAndNil(AFieldList);
    FAfterUpdateData.CallEventHandlers(Self);
  end;
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

function TCategoryFDMemTable.GetID: TField;
begin
  Result := FieldByName('ID');
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

procedure TCategoryFDMemTable.UpdatePK(APKDictionary
  : TDictionary<Integer, Integer>);
var
  AClone: TFDMemTable;
  AField: TField;
  AID: Integer;
begin
  AClone := TFDMemTable.Create(Self);
  try
    AField := AClone.FieldByName(ID.FieldName);
    AClone.CloneCursor(Self);

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
