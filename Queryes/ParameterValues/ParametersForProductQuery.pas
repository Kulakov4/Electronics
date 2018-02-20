unit ParametersForProductQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParametersForProduct = class(TQueryBase)
    fdqUpdate: TFDQuery;
    fdqInsert: TFDQuery;
    fdqSelect: TFDQuery;
    procedure FDQueryAfterOpen(DataSet: TDataSet);
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    function GetID: TField;
    function GetParamSubParamIDParam: TFDParam;
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetProductCategoryID2: TField;
    procedure Process(AOrder: Integer);
    { Private declarations }
  protected
    property Ord: TField read GetOrd;
  public
    procedure LoadAndProcess(const ATempTableName: String; AParamSubParamID,
        AOrder: Integer);
    property ID: TField read GetID;
    property ParamSubParamIDParam: TFDParam read GetParamSubParamIDParam;
    property IsAttribute: TField read GetIsAttribute;
    property ProductCategoryID2: TField read GetProductCategoryID2;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, StrHelper;

procedure TQueryParametersForProduct.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetFieldsRequired(False);
end;

procedure TQueryParametersForProduct.FDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  if ARequest = arUpdate then
  begin
    if ID.IsNull then
    begin
      fdqInsert.ParamByName('ProductCategoryId').AsInteger :=
        ProductCategoryID2.AsInteger;
      fdqInsert.ParamByName('ParamSubParamId').AsInteger :=
        ParamSubParamIDParam.AsInteger;
      if Ord.AsInteger > 0 then
        fdqInsert.ParamByName('Ord').AsInteger := Ord.AsInteger
      else
        fdqInsert.ParamByName('Ord').Value := NULL;

      fdqInsert.ExecSQL;
    end
    else
    begin
      // ¬ключаем этот параметр применительно к текущей категории
      fdqUpdate.ParamByName('ID').AsInteger := ID.AsInteger;

      if Ord.AsInteger > 0 then
        fdqUpdate.ParamByName('Ord').AsInteger := Ord.AsInteger
      else
        fdqUpdate.ParamByName('Ord').Value := NULL;

      fdqUpdate.ExecSQL;
    end;
    AAction := eaApplied;
  end
end;

function TQueryParametersForProduct.GetID: TField;
begin
  Result := Field('ID');
end;

function TQueryParametersForProduct.GetParamSubParamIDParam: TFDParam;
begin
  Result := FDQuery.ParamByName('ParamSubParamID');
end;

function TQueryParametersForProduct.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryParametersForProduct.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryParametersForProduct.GetProductCategoryID2: TField;
begin
  Result := Field('ProductCategoryID2');
end;

procedure TQueryParametersForProduct.LoadAndProcess(const ATempTableName:
    String; AParamSubParamID, AOrder: Integer);
begin
  Assert(not ATempTableName.IsEmpty);
  Assert(AParamSubParamID > 0);
  Assert(AOrder >= 0);

  // ‘ормируем SQL запрос с участием временной таблицы
  FDQuery.SQL.Text := fdqSelect.SQL.Text.Replace('--temp_table_name',
    ATempTableName);

  //  опируем параметры
  FDQuery.Params.Assign(fdqSelect.Params);

  Load([ParamSubParamIDParam.Name], [AParamSubParamID]);
  Process(AOrder);
end;

procedure TQueryParametersForProduct.Process(AOrder: Integer);
begin
  FDQuery.First;
  while not FDQuery.Eof do
  begin
    FDQuery.Edit;

    // если хотим изменить пор€док
    if (AOrder > 0) and (Ord.AsInteger = 0) then
      Ord.AsInteger := AOrder;

    // ќб€зательно делаем параметр видимым
    IsAttribute.Value := 1;

    FDQuery.Post;

    FDQuery.Next;
  end;
end;

end.
