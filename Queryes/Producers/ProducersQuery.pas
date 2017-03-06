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
    fdqDropUnused: TFDQuery;
    FDQueryID: TFDAutoIncField;
    FDQueryName: TWideStringField;
    FDQueryProducts: TWideStringField;
    FDQueryProducerType: TWideStringField;
    FDQueryCnt: TLargeintField;
    procedure FDQueryCntGetText(Sender: TField; var Text: string; DisplayText:
        Boolean);
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetCnt: TField;
    function GetName: TField;
    function GetProducerType: TField;
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
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
    property Cnt: TField read GetCnt;
    property Name: TField read GetName;
    property ProducerType: TField read GetProducerType;
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
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen);
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

procedure TQueryProducers.DoAfterOpen(Sender: TObject);
begin
  // Кол-во - только для чтения
  Cnt.ReadOnly := True;
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

procedure TQueryProducers.FDQueryCntGetText(Sender: TField; var Text: string;
    DisplayText: Boolean);
begin
  Text := String.Format('%.0n', [Sender.AsFloat]);
end;

function TQueryProducers.GetCnt: TField;
begin
  Result := Field('Cnt');
end;

function TQueryProducers.GetName: TField;
begin
  Result := Field('Name');
end;

function TQueryProducers.GetProducerType: TField;
begin
  Result := Field('ProducerType');
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
