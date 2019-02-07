unit ParamSubParamsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, DSWrap, BaseEventsQuery;

type
  TParamSubParamW = class(TDSWrap)
  private
    FChecked: TFieldWrap;
    FID: TFieldWrap;
    FIDParameter: TFieldWrap;
    FIDSubParameter: TFieldWrap;
    FName: TFieldWrap;
    FProductCategoryId: TParamWrap;
    FTranslation: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendSubParameter(AParamID, ASubParamID: Integer);
    property Checked: TFieldWrap read FChecked;
    property ID: TFieldWrap read FID;
    property IDParameter: TFieldWrap read FIDParameter;
    property IDSubParameter: TFieldWrap read FIDSubParameter;
    property Name: TFieldWrap read FName;
    property ProductCategoryId: TParamWrap read FProductCategoryId;
    property Translation: TFieldWrap read FTranslation;
  end;

  TQueryParamSubParams = class(TQueryBaseEvents)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TParamSubParamW;
    procedure DoAfterOpen(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedValues(const AFieldName: String): string;
    function SearchBySubParam(AParamID, ASubParamID: Integer): Integer;
    property W: TParamSubParamW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, System.StrUtils, StrHelper, BaseQuery;

constructor TQueryParamSubParams.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParamSubParamW;
  TNotifyEventWrap.Create(W.BeforePost, DoBeforePost, W.EventList);
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
end;

function TQueryParamSubParams.CreateDSWrap: TDSWrap;
begin
  Result := TParamSubParamW.Create(FDQuery);
end;

procedure TQueryParamSubParams.DoAfterOpen(Sender: TObject);
begin
  W.Checked.F.ReadOnly := False;
end;

procedure TQueryParamSubParams.DoBeforeOpen(Sender: TObject);
begin
  // Этот параметр - постоянный
  SetParameters([W.ProductCategoryId.FieldName],
    [W.ProductCategoryId.DefaultValue]);

  if FDQuery.FieldCount = 0 then
  begin
    // Обновляем описания полей и создаём поля по умолчанию
    W.CreateDefaultFields(True);
    W.Checked.F.FieldKind := fkInternalCalc;
  end;

end;

procedure TQueryParamSubParams.DoBeforePost(Sender: TObject);
begin
  if W.IDSubParameter.F.IsNull then
    // Ничего не сохраняем на сервере
    FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord
  else
    // Всё сохраняем на сервере
    FDQuery.OnUpdateRecord := nil;
end;

function TQueryParamSubParams.GetCheckedValues(const AFieldName
  : String): string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := W.AddClone(Format('%s = %d', [W.Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    W.DropClone(AClone);
  end;
end;

function TQueryParamSubParams.SearchBySubParam(AParamID,
  ASubParamID: Integer): Integer;
begin
  Assert(AParamID > 0);
  Assert(ASubParamID > 0);

  Result := SearchEx([TParamRec.Create(W.IDParameter.FullName, AParamID),
    TParamRec.Create(W.IDSubParameter.FullName, ASubParamID)])
end;

constructor TParamSubParamW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FIDParameter := TFieldWrap.Create(Self, 'psp.IDParameter');
  FIDSubParameter := TFieldWrap.Create(Self, 'psp.IDSubParameter');
  FName := TFieldWrap.Create(Self, 'Name');
  FTranslation := TFieldWrap.Create(Self, 'Translation');

  // Параметры SQL запроса
  FProductCategoryId := TParamWrap.Create(Self, 'cp.ProductCategoryId');
  FProductCategoryId.DefaultValue := 0;
end;

procedure TParamSubParamW.AppendSubParameter(AParamID, ASubParamID: Integer);
begin
  Assert(AParamID > 0);
  Assert(ASubParamID > 0);

  TryAppend;
  IDParameter.F.Value := AParamID;
  IDSubParameter.F.Value := ASubParamID;
  TryPost;
end;

end.
