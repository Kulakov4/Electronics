unit ParametersForProductQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryParametersForProduct = class(TQueryBase)
    fdqUpdate: TFDQuery;
    fdqInsert: TFDQuery;
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    function GetID: TField;
    function GetParameterIDParam: TFDParam;
    function GetIsAttribute: TField;
    function GetOrder: TField;
    function GetProductCategoryID2: TField;
    function GetProductIDParam: TFDParam;
    procedure Process(AOrder: Integer);
    { Private declarations }
  protected
    property Order: TField read GetOrder;
  public
    procedure LoadAndProcess(AParameterID, AProductID, AOrder: Integer);
    property ID: TField read GetID;
    property ParameterIDParam: TFDParam read GetParameterIDParam;
    property IsAttribute: TField read GetIsAttribute;
    property ProductCategoryID2: TField read GetProductCategoryID2;
    property ProductIDParam: TFDParam read GetProductIDParam;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

procedure TQueryParametersForProduct.FDQueryUpdateRecord(ASender: TDataSet;
    ARequest: TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  if ARequest = arUpdate then
  begin
    if ID.IsNull then
    begin
      fdqInsert.ParamByName('ProductCategoryId').AsInteger := ProductCategoryID2.AsInteger;
      fdqInsert.ParamByName('ParameterId').AsInteger := ParameterIDParam.AsInteger;
      if Order.AsInteger > 0 then
        fdqInsert.ParamByName('Order').AsInteger := Order.AsInteger
      else
        fdqInsert.ParamByName('Order').Value := NULL;

      fdqInsert.ExecSQL;
    end
    else
    begin
      // Включаем этот параметр применительно к текущей категории
      fdqUpdate.ParamByName('ID').AsInteger := ID.AsInteger;

      if Order.AsInteger > 0 then
        fdqUpdate.ParamByName('Order').AsInteger := Order.AsInteger
      else
        fdqUpdate.ParamByName('Order').Value := NULL;

      fdqUpdate.ExecSQL;
    end;
    AAction := eaApplied;
  end
end;

function TQueryParametersForProduct.GetID: TField;
begin
  Result :=Field('ID') ;
end;

function TQueryParametersForProduct.GetParameterIDParam: TFDParam;
begin
  Result := FDQuery.ParamByName('ParameterID');
end;

function TQueryParametersForProduct.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryParametersForProduct.GetOrder: TField;
begin
  Result := Field('Order');
end;

function TQueryParametersForProduct.GetProductCategoryID2: TField;
begin
  Result := Field('ProductCategoryID2');
end;

function TQueryParametersForProduct.GetProductIDParam: TFDParam;
begin
  Result := FDQuery.ParamByName('ProductID');
end;

procedure TQueryParametersForProduct.LoadAndProcess(AParameterID, AProductID,
    AOrder: Integer);
begin
  Assert(AParameterID > 0);
  Assert(AProductID > 0);
  Assert(AOrder >= 0);
  Load([ParameterIDParam.Name, ProductIDParam.Name], [AParameterID, AProductID]);
  Process(AOrder);
end;

procedure TQueryParametersForProduct.Process(AOrder: Integer);
begin
  Assert(AOrder > 0);

  FDQuery.First;
  while not FDQuery.Eof do
  begin
    FDQuery.Edit;

    // если хотим изменить порядок
    if AOrder > 0 then
      Order.AsInteger := AOrder;

    // Обязательно делаем параметр видимым
    IsAttribute.Value := 1;

    FDQuery.Post;

    FDQuery.Next;
  end;
end;

end.
