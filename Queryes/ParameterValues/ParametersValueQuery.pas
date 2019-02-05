unit ParametersValueQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  BaseEventsQuery, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ParametricExcelDataModule,
  BaseQuery, DSWrap;

type
  TParameterValueW = class(TDSWrap)
  private
    FParamSubParamId: TFieldWrap;
    FID: TFieldWrap;
    FProductId: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property ParamSubParamId: TFieldWrap read FParamSubParamId;
    property ID: TFieldWrap read FID;
    property ProductId: TFieldWrap read FProductId;
    property Value: TFieldWrap read FValue;
  end;

  TQueryParametersValue = class(TQueryBaseEvents)
  private
    FW: TParameterValueW;
    procedure DoAfterInsert(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Search(AIDComponent, AParamSubParamID: Integer); overload;
    property W: TParameterValueW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryParametersValue.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TParameterValueW;
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, W.EventList);
end;

function TQueryParametersValue.CreateDSWrap: TDSWrap;
begin
  Result := TParameterValueW.Create(FDQuery);
end;

procedure TQueryParametersValue.DoAfterInsert(Sender: TObject);
begin
  W.ParamSubParamId.F.AsInteger :=
    FDQuery.ParamByName(W.ParamSubParamId.FieldName).AsInteger;
  W.ProductId.F.AsInteger := FDQuery.ParamByName(W.ProductId.FieldName)
    .AsInteger;
end;

procedure TQueryParametersValue.Search(AIDComponent, AParamSubParamID: Integer);
begin
  Assert(AIDComponent > 0);
  Assert(AParamSubParamID > 0);

  SearchEx([TParamRec.Create(W.ProductId.FullName, AIDComponent),
    TParamRec.Create(W.ParamSubParamId.FullName, AParamSubParamID)]);
end;

constructor TParameterValueW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'pv.ID', '', True);
  FParamSubParamId := TFieldWrap.Create(Self, 'pv.ParamSubParamId');
  FProductId := TFieldWrap.Create(Self, 'pv.ProductId');
  FValue := TFieldWrap.Create(Self, 'pv.Value');
end;

procedure TParameterValueW.AddNewValue(const AValue: string);
begin
  TryAppend;
  Value.F.AsString := AValue;
  TryPost;
end;

procedure TParameterValueW.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  OK := FDDataSet.LocateEx(Value.FieldName, AValue, []);

  if not OK then
    AddNewValue(AValue);
end;

end.
