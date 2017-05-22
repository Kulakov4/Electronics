unit BodyKindsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, OrderQuery;

type
  TQueryBodyKinds = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetBodyKind: TField;
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property BodyKind: TField read GetBodyKind;
    { Public declarations }
  end;

implementation

uses NotifyEvents;

{$R *.dfm}

constructor TQueryBodyKinds.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryBodyKinds.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  BodyKind.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryBodyKinds.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
end;

function TQueryBodyKinds.GetBodyKind: TField;
begin
  Result := Field('BodyKind');
end;

procedure TQueryBodyKinds.LocateOrAppend(AValue: string);
begin
  if not FDQuery.LocateEx(BodyKind.FieldName, AValue, [lxoCaseInsensitive]) then
    AddNewValue(AValue);
end;

end.
