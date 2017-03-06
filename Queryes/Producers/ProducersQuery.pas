unit ProducersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, ManufacturersExcelDataModule,
  QueryWithDataSourceUnit;

type
  TQueryProducers = class(TQueryWithDataSource)
    FDQueryID: TFDAutoIncField;
    FDQueryName: TWideStringField;
    fdqDropUnused: TFDQuery;
    FDQueryProducts: TWideStringField;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetName: TField;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DropUnuses;
    procedure InsertRecordList(AManufacturesExcelTable
      : TManufacturesExcelTable);
    function Locate(AValue: string): Boolean;
    procedure LocateOrAppend(AValue: string);
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property Name: TField read GetName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ParameterValuesUnit;

constructor TQueryProducers.Create(AOwner: TComponent);
begin
  inherited;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(AfterDelete, DoAfterPostOrDelete);

  AutoTransaction := False;
end;

procedure TQueryProducers.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  Name.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryProducers.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryProducers.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryProducers.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TQueryProducers.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;
end;

procedure TQueryProducers.DropUnuses;
begin
  fdqDropUnused.ExecSQL;
  RefreshQuery;
end;

function TQueryProducers.GetName: TField;
begin
  Result := Field('Name');
end;

procedure TQueryProducers.InsertRecordList(AManufacturesExcelTable
  : TManufacturesExcelTable);
var
  AField: TField;
  I: Integer;
begin
  FDQuery.DisableControls;
  try
    // Цикл по всем записям, которые будем добавлять
    AManufacturesExcelTable.First;
    AManufacturesExcelTable.CallOnProcessEvent;
    while not AManufacturesExcelTable.Eof do
    begin
      FDQuery.Append;

      for I := 0 to AManufacturesExcelTable.FieldCount - 1 do
      begin
        AField := FDQuery.FindField(AManufacturesExcelTable.Fields[I]
          .FieldName);
        if AField <> nil then
          AField.Value := AManufacturesExcelTable.Fields[I].Value;
      end;
      TryPost;

      AManufacturesExcelTable.Next;
      AManufacturesExcelTable.CallOnProcessEvent;
    end;

  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryProducers.Locate(AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(Name.FieldName, AValue.Trim, [lxoCaseInsensitive]);
end;

procedure TQueryProducers.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  OK := Locate(AValue);

  if not OK then
    AddNewValue(AValue);
end;

end.
