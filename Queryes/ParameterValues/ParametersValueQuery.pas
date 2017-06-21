unit ParametersValueQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  BaseEventsQuery, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ParametricExcelDataModule,
  BaseQuery;

type
  TQueryParametersValue = class(TQueryBaseEvents)
  private
    procedure DoAfterInsert(Sender: TObject);
    function GetProductId: TField;
    function GetProductIDParam: TFDParam;
    function GetParameterId: TField;
    function GetParameterIdParam: TFDParam;
    function GetValue: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure Load(AIDComponent, AIDParameter: Integer); overload;
    procedure LocateOrAppend(AValue: string);
    property ProductId: TField read GetProductId;
    property ProductIDParam: TFDParam read GetProductIDParam;
    property ParameterId: TField read GetParameterId;
    property ParameterIdParam: TFDParam read GetParameterIdParam;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryParametersValue.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
end;

procedure TQueryParametersValue.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  Value.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryParametersValue.DoAfterInsert(Sender: TObject);
begin
  ParameterId.AsInteger := ParameterIdParam.AsInteger;
  ProductId.AsInteger := ProductIDParam.AsInteger;
end;

function TQueryParametersValue.GetProductId: TField;
begin
  Result := Field('ProductId');
end;

function TQueryParametersValue.GetProductIDParam: TFDParam;
begin
  Result := FDQuery.ParamByName('ProductID');
end;

function TQueryParametersValue.GetParameterId: TField;
begin
  Result := Field('ParameterId');
end;

function TQueryParametersValue.GetParameterIdParam: TFDParam;
begin
  Result := FDQuery.ParamByName('ParameterId');
end;

function TQueryParametersValue.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryParametersValue.Load(AIDComponent, AIDParameter: Integer);
begin
  Assert(AIDComponent > 0);
  Assert(AIDParameter > 0);
  Load([ProductIDParam.Name, ParameterIdParam.Name],
    [AIDComponent, AIDParameter]);
end;

procedure TQueryParametersValue.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  OK := FDQuery.LocateEx(Value.FieldName, AValue, []);

  if not OK then
    AddNewValue(AValue);
end;

end.
