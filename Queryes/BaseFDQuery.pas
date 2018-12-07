unit BaseFDQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, NotifyEvents,
  System.Contnrs;

type
  TQryBase = class(TFrame)
    FDQuery: TFDQuery;
  private
    FDataSource: TDataSource;
    FSQL: string;
    function GetAutoTransactionEventList: TObjectList;
    function GetDataSource: TDataSource;
    { Private declarations }
  protected
    FAutoTransactionEventList: TObjectList;
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest; var
        AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest; var
        AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest; var
        AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); virtual;
    // TODO: DoOnNeedPost
    // procedure DoOnNeedPost(var Message: TMessage); message WM_NEED_POST;
    procedure DoOnQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
        var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
    procedure FDQueryUpdateRecordOnClient(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
    property AutoTransactionEventList: TObjectList read GetAutoTransactionEventList;
    property SQL: string read FSQL write FSQL;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure CascadeDelete(const AIDMaster: Variant;
      const ADetailKeyFieldName: String;
      const AFromClientOnly: Boolean = False);
    procedure DeleteFromClient;
    procedure SetParamType(AParameterName: string;
      ADataType: TFieldType = ftInteger; AParamType: TParamType = ptInput);
    property DataSource: TDataSource read GetDataSource;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TQryBase.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TQryBase.Destroy;
begin
  inherited;
  if FAutoTransactionEventList <> nil then
    FreeAndNil(FAutoTransactionEventList);
end;

procedure TQryBase.AfterConstruction;
begin
  inherited;
  // Сохраняем первоначальный SQL
  FSQL := FDQuery.SQL.Text
end;

procedure TQryBase.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
    var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQryBase.ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
    var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQryBase.ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
    var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
end;

procedure TQryBase.CascadeDelete(const AIDMaster: Variant;
  const ADetailKeyFieldName: String; const AFromClientOnly: Boolean = False);
var
  E: TFDUpdateRecordEvent;
begin
  Assert(AIDMaster > 0);

  E := FDQuery.OnUpdateRecord;
  try
    // Если каскадное удаление уже реализовано на стороне сервера
    // Просто удалим эти записи с клиента ничего не сохраняя на стороне сервера
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;

    // Пока есть записи подчинённые мастеру
    while FDQuery.LocateEx(ADetailKeyFieldName, AIDMaster, []) do
    begin
      FDQuery.Delete;
    end;

  finally
    if AFromClientOnly then
      FDQuery.OnUpdateRecord := E;
  end;
end;

procedure TQryBase.DeleteFromClient;
var
  E: TFDUpdateRecordEvent;
begin
  Assert(FDQuery.RecordCount > 0);
  E := FDQuery.OnUpdateRecord;
  try
    FDQuery.OnUpdateRecord := FDQueryUpdateRecordOnClient;
    FDQuery.Delete;
  finally
    FDQuery.OnUpdateRecord := E;
  end;
end;

procedure TQryBase.DoOnQueryUpdateRecord(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
begin
  if ARequest in [arDelete, arInsert, arUpdate] then
  begin
    // try
    AAction := eaApplied;
    // Если произошло удаление
    if ARequest = arDelete then
    begin
      ApplyDelete(ASender, ARequest, AAction, AOptions);
    end;

    // Операция добавления записи на клиенте
    if ARequest = arInsert then
    begin
      ApplyInsert(ASender, ARequest, AAction, AOptions);
    end;

    // Операция обновления записи на клиенте
    if ARequest = arUpdate then
    begin
      ApplyUpdate(ASender, ARequest, AAction, AOptions);
    end;
    {
      except
      on E: Exception do
      begin
      AAction := eaFail;
      DoOnUpdateRecordException(E);
      end;
      end;
    }
  end
  else
    AAction := eaSkip;
end;

procedure TQryBase.FDQueryUpdateRecordOnClient(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  inherited;
  AAction := eaApplied;
end;

function TQryBase.GetAutoTransactionEventList: TObjectList;
begin
  if FAutoTransactionEventList = nil then
    FAutoTransactionEventList := TObjectList.Create;

  Result := FAutoTransactionEventList;
end;

function TQryBase.GetDataSource: TDataSource;
begin
  if FDataSource = nil then
  begin
    FDataSource := TDataSource.Create(Self);
    FDataSource.DataSet := FDQuery;
  end;
  Result := FDataSource;
end;

procedure TQryBase.SetParamType(AParameterName: string;
  ADataType: TFieldType = ftInteger; AParamType: TParamType = ptInput);
var
  P: TFDParam;
begin
  Assert(not AParameterName.IsEmpty);
  P := FDQuery.ParamByName(AParameterName);
  P.DataType := ADataType;
  P.ParamType := AParamType;
end;

end.
