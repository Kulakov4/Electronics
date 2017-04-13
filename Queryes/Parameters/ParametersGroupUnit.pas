unit ParametersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ParameterTypesQuery, MainParametersQuery, SubParametersQuery,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, NotifyEvents,
  ParametersExcelDataModule, System.Generics.Collections, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery,
  QueryWithMasterUnit, QueryGroupUnit;

type
  TParametersGroup = class(TQueryGroup)
    qParameterTypes: TQueryParameterTypes;
    qMainParameters: TQueryMainParameters;
    qSubParameters: TQuerySubParameters;
  private
    FAfterDataChange: TNotifyEventsEx;
    FAfterCommit: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit; override;
    function Find(const AFieldName, S: string): TList<String>;
    procedure InsertList(AParametersExcelTable: TParametersExcelTable);
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TParametersGroup.Create(AOwner: TComponent);
begin
  inherited;

  Main := qParameterTypes;
  Detail := qMainParameters;

  FAfterCommit := TNotifyEventsEx.Create(Self);
  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qParameterTypes.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qParameterTypes.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qMainParameters.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qMainParameters.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qSubParameters.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qSubParameters.AfterDelete, DoAfterPostOrDelete);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qParameterTypes.BeforeDelete, DoBeforeDelete);
end;

destructor TParametersGroup.Destroy;
begin
  inherited;
end;

procedure TParametersGroup.Commit;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  qParameterTypes.TryPost;
  qMainParameters.TryPost;
  qSubParameters.TryPost;

  Connection.Commit;

  FAfterCommit.CallEventHandlers(Self);
end;

procedure TParametersGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TParametersGroup.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем параметры
  qMainParameters.CascadeDelete(qParameterTypes.PKValue,
    qMainParameters.IDParameterType.FieldName);
end;

function TParametersGroup.Find(const AFieldName, S: string): TList<String>;
var
  OK: Boolean;
begin
  Assert(not AFieldName.IsEmpty);
  Result := TList<String>.Create();

  // Пытаемся искать среди параметров по какому-то полю
  if qMainParameters.Locate(AFieldName, S) then
  begin
    OK := qParameterTypes.LocateByPK(qMainParameters.IDParameterType.Value);
    Assert(OK);
    // запоминаем что надо искать на первом уровне
    Result.Add(qParameterTypes.ParameterType.AsString);
    // запоминаем что надо искать на втором уровне
    Result.Add(S);
  end
  else
    // Пытаемся искать среди типов параметров
    if qParameterTypes.Locate(S) then
    begin
      Result.Add(S);
    end;

end;

procedure TParametersGroup.InsertList(AParametersExcelTable
  : TParametersExcelTable);
var
  AField: TField;
  AParameterType: string;
  I: Integer;
begin
  TryPost;

  AParametersExcelTable.DisableControls;
  qParameterTypes.FDQuery.DisableControls;
  qMainParameters.FDQuery.DisableControls;
  try
    AParametersExcelTable.First;
    AParametersExcelTable.CallOnProcessEvent;
    while not AParametersExcelTable.Eof do
    begin
      AParameterType := AParametersExcelTable.ParameterType.AsString;
      qParameterTypes.LocateOrAppend(AParameterType);

      qMainParameters.FDQuery.Append;
      try
        for I := 0 to AParametersExcelTable.FieldCount - 1 do
        begin
          AField := qMainParameters.FDQuery.FindField
            (AParametersExcelTable.Fields[I].FieldName);
          if AField <> nil then
          begin
            AField.Value := AParametersExcelTable.Fields[I].Value;
          end;
        end;

        qMainParameters.IDParameterType.AsInteger := qParameterTypes.PKValue;
        qMainParameters.FDQuery.Post;
      except
        qMainParameters.FDQuery.Cancel;
        raise;
      end;
      AParametersExcelTable.Next;
      AParametersExcelTable.CallOnProcessEvent;
    end;
  finally
    AParametersExcelTable.EnableControls;
    qMainParameters.FDQuery.EnableControls;
    qParameterTypes.FDQuery.EnableControls;
  end;
end;

procedure TParametersGroup.ReOpen;
begin
  qSubParameters.FDQuery.Close;
  qMainParameters.FDQuery.Close;
  qParameterTypes.FDQuery.Close;

  qParameterTypes.FDQuery.Open;
  qMainParameters.FDQuery.Open;
  qSubParameters.FDQuery.Open;
end;

procedure TParametersGroup.Rollback;
begin
  CheckMasterAndDetail;
  // Предполагается что мы работаем в транзакции
  Assert(Connection.InTransaction);

  qSubParameters.TryCancel;
  qMainParameters.TryCancel;
  qParameterTypes.TryCancel;

  Connection.Rollback;

  ReOpen;
end;

end.
