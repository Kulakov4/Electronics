unit ApplyQueryFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, DBRecordHolder;

type
  TfrmApplyQuery = class(TFrame)
    FDQuery: TFDQuery;
    FDUpdateSQL: TFDUpdateSQL;
  private
    FPKFieldName: string;
    function GetPKValue: Integer;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteRecord(APKValue: Integer);
    function InsertRecord(ARecordHolder: TRecordHolder): Integer;
    function Search(AID: Integer): Integer;
    function UpdateRecord(ARecordHolder: TRecordHolder): Integer;
    property PKFieldName: string read FPKFieldName write FPKFieldName;
    property PKValue: Integer read GetPKValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Generics.Collections, RepositoryDataModule;

constructor TfrmApplyQuery.Create(AOwner: TComponent);
begin
  inherited;
  PKFieldName := 'ID';
end;

procedure TfrmApplyQuery.DeleteRecord(APKValue: Integer);
begin
  Search(APKValue);
  Assert(FDQuery.RecordCount = 1);

  // Удаляем запись
  FDQuery.Delete;
end;

function TfrmApplyQuery.GetPKValue: Integer;
begin
  Result := FDQuery.FieldByName(PKFieldName).AsInteger;
end;

function TfrmApplyQuery.InsertRecord(ARecordHolder: TRecordHolder): Integer;
var
  AFieldHolder: TFieldHolder;
  AFieldName: string;
  I: Integer;
begin
  I := Search(-1);
  Assert(I = 0);

  FDQuery.Insert;
  try
    for I := 0 to FDQuery.FieldCount - 1 do
    begin
      AFieldName := FDQuery.Fields[I].FieldName;
      // if AFieldName.ToUpper = PKFieldName.ToUpper then
      // Continue;

      // Ищем такое поле в коллекции вставляемых значений
      AFieldHolder := ARecordHolder.Find(AFieldName);

      // Если нашли
      if (AFieldHolder <> nil) and not VarIsNull(AFieldHolder.Value) then
      begin
        FDQuery.Fields[I].Value := AFieldHolder.Value;
      end;
    end;

    FDQuery.Post;
    Assert(not FDQuery.FieldByName(PKFieldName).IsNull);
    Result := FDQuery.FieldByName(PKFieldName).AsInteger;
  except
    FDQuery.Cancel;
    raise;
  end;

end;

function TfrmApplyQuery.Search(AID: Integer): Integer;
begin
  FDQuery.Close;
  FDQuery.ParamByName(PKFieldName).AsInteger := AID;
  FDQuery.Open;
  Result := FDQuery.RecordCount;
end;

function TfrmApplyQuery.UpdateRecord(ARecordHolder: TRecordHolder): Integer;
var
  AChangedFields: TDictionary<String, Variant>;
  AFieldHolder: TFieldHolder;
  AFieldName: string;
  I: Integer;
begin
  Result := ARecordHolder.Field[PKFieldName];
  // Выбираем запись, которую будем обновлять
  I := Search(Result);
  Assert(I = 1);

  // Создаём словарь тех полей что нужно будет обновить
  AChangedFields := TDictionary<String, Variant>.Create;
  try

    for I := 0 to FDQuery.FieldCount - 1 do
    begin
      AFieldName := FDQuery.Fields[I].FieldName;

      // Первичный ключ обновлять не будем
      if AFieldName.ToUpper = PKFieldName.ToUpper then
        Continue;

      // Ищем такое поле в коллекции обновляемых значений
      AFieldHolder := ARecordHolder.Find(AFieldName);

      // Запоминаем в словаре какое поле нужно будет обновить
      if (AFieldHolder <> nil) and
        (FDQuery.Fields[I].Value <> AFieldHolder.Value) then
        AChangedFields.Add(AFieldName, AFieldHolder.Value);
    end;

    // Если есть те поля, которые нужно обновлять
    if AChangedFields.Count > 0 then
    begin
      FDQuery.Edit;
      try
        // Цикл по всем изменившимся полям
        for AFieldName in AChangedFields.Keys do
        begin
          FDQuery.FieldByName(AFieldName).Value := AChangedFields[AFieldName];
        end;
        FDQuery.Post;
      except
        FDQuery.Cancel;
        raise;
      end;
    end;

  finally
    FreeAndNil(AChangedFields);
  end;

end;

end.
