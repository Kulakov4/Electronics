unit ProducersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, ProducerInterface, DSWrap,
  BaseEventsQuery;

type
  TProducersW = class(TDSWrap)
    procedure FDQueryCntGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
  private
    FCnt: TFieldWrap;
    FID: TFieldWrap;
    FName: TFieldWrap;
    FProducerParamSubParamID: TParamWrap;
    FProducerTypeID: TFieldWrap;
    procedure DoBeforeDelete(Sender: TObject);
  protected
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string; AProducerTypeID: Integer);
    property Cnt: TFieldWrap read FCnt;
    property ID: TFieldWrap read FID;
    property Name: TFieldWrap read FName;
    property ProducerParamSubParamID: TParamWrap read FProducerParamSubParamID;
    property ProducerTypeID: TFieldWrap read FProducerTypeID;
  end;

  TQueryProducers = class(TQueryBaseEvents, IProducer)
    procedure FDQueryDeleteError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  strict private
    function Exist(const AProducerName: String): Boolean; stdcall;
    function GetProducerID(const AProducerName: String): Integer; stdcall;
  private
    FW: TProducersW;
    procedure DoBeforeOpen(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CancelUpdates; override;
    function Locate(AValue: string; TestResult: Boolean = False): Boolean;
    procedure OrderByProducerName;
    property W: TProducersW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, DefaultParameters, ProducerTypesQuery,
  FireDAC.Phys.SQLiteWrapper, DelNotUsedProductsQuery;

constructor TQueryProducers.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TProducersW;

  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);

  AutoTransaction := False;
end;

procedure TQueryProducers.CancelUpdates;
begin
  // отменяем все сделанные изменения на стороне клиента
  W.TryCancel;
  FDQuery.Connection.Rollback;
  W.RefreshQuery;
end;

function TQueryProducers.CreateDSWrap: TDSWrap;
begin
  Result := TProducersW.Create(FDQuery);
end;

procedure TQueryProducers.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName(W.ProducerParamSubParamID.FieldName).AsInteger :=
    TDefaultParameters.ProducerParamSubParamID;
end;

function TQueryProducers.Exist(const AProducerName: String): Boolean;
begin
  Result := GetProducerID(AProducerName) > 0;
end;

procedure TQueryProducers.FDQueryDeleteError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
var
  AE: ESQLiteNativeException;
begin
  inherited;
  if not(E is ESQLiteNativeException) then
    Exit;

  AE := E as ESQLiteNativeException;
  // Foreign Key Constraint Failed
  if AE.ErrorCode = 787 then
    E.Message :=
      'Производитель присутствует на складе или в Компонентной базе. Удаление невозможно.';
end;

function TQueryProducers.GetProducerID(const AProducerName: String): Integer;
var
  V: Variant;
begin
  Assert(not AProducerName.IsEmpty);
  Result := 0;
  V := FDQuery.LookupEx(W.Name.FieldName, AProducerName, W.PK.FieldName);
  if not VarIsNull(V) then
    Result := V;
end;

function TQueryProducers.Locate(AValue: string;
  TestResult: Boolean = False): Boolean;
begin
  Result := FDQuery.LocateEx(W.Name.FieldName, AValue.Trim,
    [lxoCaseInsensitive]);
  if TestResult then
    Assert(Result);

end;

procedure TQueryProducers.OrderByProducerName;
begin
  Assert(FDQuery.Indexes.Count = 2);
  Assert(FDQuery.Indexes[1].Name = 'idxName');
  FDQuery.Indexes[1].Active := True;
  FDQuery.Indexes[1].Selected := True;
end;

constructor TProducersW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FCnt := TFieldWrap.Create(Self, 'Cnt');
  FName := TFieldWrap.Create(Self, 'Name', 'Производитель');
  FProducerTypeID := TFieldWrap.Create(Self, 'ProducerTypeID');

  // Параметры SQL запроса
  FProducerParamSubParamID := TParamWrap.Create(Self,
    'ProducerParamSubParamID');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);
  TNotifyEventWrap.Create(BeforeDelete, DoBeforeDelete, EventList);
end;

procedure TProducersW.AddNewValue(const AValue: string;
  AProducerTypeID: Integer);
begin
  Assert(AProducerTypeID > 0);

  TryAppend;
  ProducerTypeID.F.AsInteger := AProducerTypeID;
  Name.F.AsString := AValue;
  TryPost;
end;

procedure TProducersW.DoAfterOpen(Sender: TObject);
begin
  // Кол-во - только для чтения
  Cnt.F.ReadOnly := True;
  Cnt.F.OnGetText := FDQueryCntGetText;
  // Name.DisplayLabel := 'Производитель';
end;

procedure TProducersW.DoBeforeDelete(Sender: TObject);
begin
  if DataSet.RecordCount = 0 then
    Exit;

  // Удаляем неиспользуемые продукты этого производителя!!!
  TQueryDelNotUsedProducts2.Delete(ID.F.AsInteger);
end;

procedure TProducersW.FDQueryCntGetText(Sender: TField; var Text: string;
  DisplayText: Boolean);
begin
  if (not Sender.IsNull) and (Sender.AsFloat > 0) then
    Text := String.Format('%.0n', [Sender.AsFloat])
  else
    Text := '';
end;

end.
