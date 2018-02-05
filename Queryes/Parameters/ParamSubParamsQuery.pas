unit ParamSubParamsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents;

type
  TQueryParamSubParams = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FProductCategoryIDValue: Integer;
    procedure DoAfterOpen(Sender: TObject);
    function GetChecked: TField;
    function GetIDParameter: TField;
    function GetIDSubParameter: TField;
    function GetName: TField;
    function GetTranslation: TField;
    { Private declarations }
  protected
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendSubParameter(AParamID, ASubParamID: Integer);
    function GetCheckedValues(const AFieldName: String): string;
    function SearchBySubParam(AParamID, ASubParamID: Integer): Integer;
    property Checked: TField read GetChecked;
    property IDParameter: TField read GetIDParameter;
    property IDSubParameter: TField read GetIDSubParameter;
    property Name: TField read GetName;
    property ProductCategoryIDValue: Integer read FProductCategoryIDValue
      write FProductCategoryIDValue;
    property Translation: TField read GetTranslation;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, System.StrUtils, StrHelper;

constructor TQueryParamSubParams.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryParamSubParams.AppendSubParameter(AParamID, ASubParamID:
    Integer);
begin
  Assert(AParamID > 0);
  Assert(ASubParamID > 0);

  TryAppend;
  IDParameter.Value := AParamID;
  IDSubParameter.Value := ASubParamID;
  TryPost;
end;

procedure TQueryParamSubParams.DoAfterOpen(Sender: TObject);
begin
  Checked.ReadOnly := False;
end;

procedure TQueryParamSubParams.DoBeforeOpen(Sender: TObject);
begin
  SetParameters(['ProductCategoryID'], [FProductCategoryIDValue]);

  if FDQuery.FieldCount = 0 then
  begin
    // Обновляем описания полей
    FDQuery.FieldDefs.Update;
    // Создаём поля по умолчанию
    CreateDefaultFields(False);
    Checked.FieldKind := fkInternalCalc;
  end;

end;

procedure TQueryParamSubParams.DoBeforePost(Sender: TObject);
begin
  if IDSubParameter.IsNull then
    // Ничего не сохраняем на сервере
    FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord
  else
    // Всё сохраняем на сервере
    FDQuery.OnUpdateRecord := nil;
end;

function TQueryParamSubParams.GetChecked: TField;
begin
  Result := Field('Checked');
end;

function TQueryParamSubParams.GetCheckedValues(const AFieldName
  : String): string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := AddClone(Format('%s = %d', [Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

function TQueryParamSubParams.GetIDParameter: TField;
begin
  Result := Field('IDParameter');
end;

function TQueryParamSubParams.GetIDSubParameter: TField;
begin
  Result := Field('IdSubParameter');
end;

function TQueryParamSubParams.GetName: TField;
begin
  Result := Field('Name');
end;

function TQueryParamSubParams.GetTranslation: TField;
begin
  Result := Field('Translation');
end;

function TQueryParamSubParams.SearchBySubParam(AParamID,
  ASubParamID: Integer): Integer;
begin
  Assert(AParamID > 0);
  Assert(ASubParamID > 0);

  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    'and 0=0 and psp.IdParameter = :IdParameter and idSubParameter = :idSubParameter',
    'and 0=0');
  SetParamType('IdParameter');
  SetParamType('idSubParameter');
  Result := Search(['IdParameter', 'idSubParameter'], [AParamID, ASubParamID]);
end;

end.
