unit ParametersForCategories;

interface

uses
  Classes, FireDAC.Comp.Client, Data.DB, System.Generics.Collections,
  Vcl.Dialogs;

type
  TParametersForCategories = class(TObject)
  private const
    SRecursiveCategoriesQuery = 'WITH RECURSIVE cnt(id) AS ( ' + #13#10 +
      ' SELECT id from ProductCategories pc where pc.Id = :vParentId union ' +
      #13#10 + ' SELECT pc2.id FROM cnt, ProductCategories pc2 where cnt.id = pc2.ParentId ) '
      + #13#10 + ' SELECT id FROM cnt';
  public
    function AddParameter(vProductCategoryId: Integer; vRecord: string;
      vParentId, vOrder: Integer): Integer;
    procedure DisableParameterForCategory(vParameterId, vProductCategoryId
      : Integer);
    function GetParametersListForCategory(vProductCategoryId: Integer)
      : TList<Integer>;
    procedure UpdateOrder(vParameterId, vOrder, vProductCategoryId: Integer);
    procedure UpdateParameter(vParameterId: Integer; Value: string;
      vStatus: boolean; vOrder, vProductCategoryId: Integer);
    procedure UpdateRecord(vProductCategoriesList: TList<Integer>;
      vParameterGroupId, vStatus, vAttribute, vOrder: Integer);
    procedure UpdateRecordRecursive(vProductCategoryId, vParameterGroupId,
      vStatus, vAttribute, vOrder: Integer);
  end;

implementation

uses
  RepositoryDataModule;

function TParametersForCategories.AddParameter(vProductCategoryId: Integer;
  vRecord: string; vParentId, vOrder: Integer): Integer;
var
  AQuery: TFDQuery;
begin
  // Result := -1;
  AQuery := TFDQuery.Create(nil);
  try
    { добавить запись }
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.SQL.Add
      ('insert into Parameters (Value, ValueT, TableName, "Order", ParentParameter, IsCustomParameter)  '
      + ' values (:vRecord, :vRecord, :vRecord, 0, :vParentId, 1)');

    AQuery.Params.ParamValues['vRecord'] := vRecord;
    AQuery.Params.ParamValues['vParentId'] := vParentId;
    if (vParentId > 0) then
      AQuery.Params.ParamValues['vParentId'] := vParentId
    else
    begin
      AQuery.Params.ParamValues['vParentId'] := 0;
      AQuery.Params.ParamByName('vParentId').Clear();
    end;

    AQuery.Execute();

    { выбрать последний добавленный идентификатор }
    AQuery.SQL.Clear;
    AQuery.Params.Clear;
    AQuery.SQL.Add('select last_insert_rowid() id');
    AQuery.Open();
    Result := AQuery.FieldByName('Id').AsInteger;
    AQuery.Close;

    { задать параметр как нужный для категории }
    AQuery.SQL.Clear;
    AQuery.SQL.Add
      ('insert into CategoryParams (ProductCategoryId, ParameterId, "Order", IsEnabled) '
      + ' values (:vProductCategoryId, :vParameterId, :vOrder, 1)');
    AQuery.Params.ParamValues['vProductCategoryId'] := vProductCategoryId;
    AQuery.Params.ParamValues['vParameterId'] := Result;
    AQuery.Params.ParamValues['vOrder'] := vOrder;
    AQuery.Execute();
  finally
    AQuery.Free;
  end;
end;

{ отключить параметр для категории }
procedure TParametersForCategories.DisableParameterForCategory(vParameterId,
  vProductCategoryId: Integer);
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.SQL.Add
      ('delete from CategoryParams where ProductCategoryId = :vProductCategoryId '
      + ' and ParameterId = :vParameterId');
    AQuery.Params.ParamValues['vParameterId'] := vParameterId;
    AQuery.Params.ParamValues['vProductCategoryId'] := vProductCategoryId;
    AQuery.Execute();
  finally
    AQuery.Free;
  end;
end;

{ получить список параметров для категории компонентов }
function TParametersForCategories.GetParametersListForCategory
  (vProductCategoryId: Integer): TList<Integer>;
var
  AQuery: TFDQuery;
  val: Integer;
begin
  Result := TList<Integer>.Create;
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DMRepository.dbConnection;
    // выбрать все параметры для дальнейшей их обработки
    AQuery.SQL.Add('SELECT p.Id, p.ParentParameter, cp.IsAttribute ' +
      '     FROM CategoryParams cp ' + '   left join Parameters p ' +
      '   on (p.ParentParameter = cp.ParameterId) ' +
      '    or (p.Id = fc.ParameterId) ' +
      '    WHERE cp.ProductCategoryId = :vProductCategoryId AND ' +
      '          cp.IsEnabled = 1 ' +
      '   order by cp."Order", p.ParentParameter');
    AQuery.Params.ParamValues['vProductCategoryId'] := vProductCategoryId;
    AQuery.Open();
    AQuery.First;
    while not AQuery.Eof do
    begin
      val := AQuery.FieldByName('Id').AsInteger;
      // чтобы не создавать отдельного типа необязательные параметры передаются отрицателными
      if AQuery.FieldByName('IsAttribute').AsBoolean then
        val := -1 * val;
      Result.Add(val);
      AQuery.Next;
    end;
  finally
    AQuery.Free;
  end;
end;

{ обновить порядок параметра для категории компонентов }
procedure TParametersForCategories.UpdateOrder(vParameterId, vOrder,
  vProductCategoryId: Integer);
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.SQL.Add
      ('update CategoryParams set "Order" = :vOrder where ProductCategoryId = '
      + ' :vProductCategoryId and ParameterId = :vParameterId');
    AQuery.Params.ParamValues['vOrder'] := vOrder;
    AQuery.Params.ParamValues['vProductCategoryId'] := vProductCategoryId;
    AQuery.Params.ParamValues['vParameterId'] := vParameterId;
    AQuery.Execute();
  finally
    AQuery.Free;
  end;
end;

procedure TParametersForCategories.UpdateParameter(vParameterId: Integer;
  Value: string; vStatus: boolean; vOrder, vProductCategoryId: Integer);
var
  AQuery: TFDQuery;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.Connection.StartTransaction;
    AQuery.CachedUpdates := true;

    AQuery.SQL.Add
      ('select * from CategoryParams where ParameterId = :vParameterId ' +
      ' and ProductCategoryId = :vProductCategoryId');
    AQuery.Params.ParamValues['vParameterId'] := vParameterId;
    AQuery.Params.ParamValues['vProductCategoryId'] := vProductCategoryId;
    AQuery.Open();
  finally
    AQuery.Free;
  end;
end;

procedure TParametersForCategories.UpdateRecord(vProductCategoriesList
  : TList<Integer>; vParameterGroupId, vStatus, vAttribute, vOrder: Integer);
var
  AQuery: TFDQuery;
  i, amount: Integer;
  isLocated: boolean;
begin
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := DMRepository.dbConnection;
    AQuery.Connection.StartTransaction;
    AQuery.CachedUpdates := true;

    AQuery.SQL.Add('select * from ' + #13#10 + ' CategoryParams cp ' + #13#10 +
      ' where cp.ParameterId = :vParameterId');
    AQuery.Params.ParamValues['vParameterId'] := vParameterGroupId;
    AQuery.Open();

    amount := 0;
    for i in vProductCategoriesList do
    begin
      isLocated := AQuery.Locate('ProductCategoryId', i, []);

      if isLocated then
      begin
        AQuery.Edit;
        AQuery.FieldByName('Order').AsInteger := vOrder;
        AQuery.FieldByName('IsEnabled').AsVariant := vStatus;
        AQuery.FieldByName('IsAttribute').AsVariant := vAttribute;
        // if vStatus = 1 then
        // AQuery.FieldByName('Rename').AsString := '';
      end
      else
      begin
        AQuery.Append;
        AQuery.FieldByName('ProductCategoryId').AsInteger := i;
        AQuery.FieldByName('ParameterId').AsInteger := vParameterGroupId;
        AQuery.FieldByName('Order').AsInteger := vOrder;
        AQuery.FieldByName('IsEnabled').AsVariant := vStatus;
        AQuery.FieldByName('IsAttribute').AsVariant := vAttribute;
      end;
      AQuery.Post;
      inc(amount);
      if amount > 150 then
      begin
        AQuery.ApplyUpdates();
        AQuery.CommitUpdates;
        amount := 0;
      end;
    end;
    AQuery.ApplyUpdates();
    AQuery.CommitUpdates;
  finally
    AQuery.Connection.Commit;
    AQuery.Free;
  end;
end;

procedure TParametersForCategories.UpdateRecordRecursive(vProductCategoryId,
  vParameterGroupId, vStatus, vAttribute, vOrder: Integer);
var
  { AQuery, } ACategoriesQ: TFDQuery;
  ACategoriesList: TList<Integer>;
begin
  ACategoriesQ := TFDQuery.Create(nil);
  ACategoriesList := TList<Integer>.Create();
  try
    ACategoriesQ.Connection := DMRepository.dbConnection;
    ACategoriesQ.SQL.Add(SRecursiveCategoriesQuery);
    ACategoriesQ.Params.ParamValues['vParentId'] := vProductCategoryId;
    // рекурсивным запросом выбираются все вложенные категории
    ACategoriesQ.Open();
    ACategoriesQ.First;
    while not ACategoriesQ.Eof do
    begin
      // UpdateRecord(ACategoriesQ.FieldByName('Id').AsInteger, vParameterGroupId, vStatus, vOrder);
      ACategoriesList.Add(ACategoriesQ.FieldByName('Id').AsInteger);
      ACategoriesQ.Next;
    end;
    UpdateRecord(ACategoriesList, vParameterGroupId, vStatus,
      vAttribute, vOrder);
  finally
    ACategoriesQ.Free;
  end;
end;

end.
