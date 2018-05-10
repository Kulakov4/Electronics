unit CategoryParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryCategoryParams = class(TQueryBase)
  private
    function GetIsAttribute: TField;
    function GetOrd: TField;
    function GetParamSubParamID: TField;
    function GetProductCategoryID: TField;
    { Private declarations }
  public
    procedure AppendOrEdit(AProductCategoryID, AParamSubParamID, AOrd: Integer);
    function SearchBy(AProductCategoryID, AParamSubParamID: Integer)
      : Integer; overload;
    property IsAttribute: TField read GetIsAttribute;
    property Ord: TField read GetOrd;
    property ParamSubParamID: TField read GetParamSubParamID;
    property ProductCategoryID: TField read GetProductCategoryID;
    { Public declarations }
  end;

implementation

uses
  StrHelper;

{$R *.dfm}

procedure TQueryCategoryParams.AppendOrEdit(AProductCategoryID,
  AParamSubParamID, AOrd: Integer);
begin
  if SearchBy(AProductCategoryID, AParamSubParamID) = 0 then
    TryAppend
  else
    TryEdit;

  ProductCategoryID.AsInteger := AProductCategoryID;
  ParamSubParamID.AsInteger := AParamSubParamID;

  // если хотим изменить порядок
  if (AOrd > 0) and (Ord.AsInteger = 0) then
    Ord.AsInteger := AOrd;

  // Обязательно делаем параметр видимым
  IsAttribute.Value := 1;

  TryPost;
end;

function TQueryCategoryParams.GetIsAttribute: TField;
begin
  Result := Field('IsAttribute');
end;

function TQueryCategoryParams.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryCategoryParams.GetParamSubParamID: TField;
begin
  // TODO -cMM: TQueryCategoryParams.GetParamSubParamID default body inserted
  Result := Field('ParamSubParamID');
end;

function TQueryCategoryParams.GetProductCategoryID: TField;
begin
  Result := Field('ProductCategoryID');
end;

function TQueryCategoryParams.SearchBy(AProductCategoryID, AParamSubParamID
  : Integer): Integer;
begin
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    '0=0 and ProductCategoryID = :ProductCategoryID and ParamSubParamID = :ParamSubParamID',
    '0=0');

  SetParamType('ProductCategoryID');
  SetParamType('ParamSubParamID');

  Result := Search(['ProductCategoryID', 'ParamSubParamID'],
    [AProductCategoryID, AParamSubParamID]);
end;

end.
