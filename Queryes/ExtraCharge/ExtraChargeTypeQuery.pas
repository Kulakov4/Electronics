unit ExtraChargeTypeQuery;

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
  TQueryExtraChargeType = class(TQueryWithDataSource)
  private
    procedure DoAfterOpen(Sender: TObject);
    function GetName: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function Lookup(const AExtraChargeTypeName: String): Variant;
    procedure LocateOrAppend(const AName: String);
    property Name: TField read GetName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryExtraChargeType.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryExtraChargeType.DoAfterOpen(Sender: TObject);
begin
  PK.Visible := False;
  Name.DisplayLabel := 'Наименование';
end;

function TQueryExtraChargeType.Lookup(const AExtraChargeTypeName
  : String): Variant;
begin
  Result := FDQuery.LookupEx(Name.FieldName, AExtraChargeTypeName, PKFieldName,
    [lxoCaseInsensitive]);
end;

function TQueryExtraChargeType.GetName: TField;
begin
  Result := Field('Name');
end;

procedure TQueryExtraChargeType.LocateOrAppend(const AName: String);
begin
  if not FDQuery.LocateEx(Name.FieldName, AName, [lxoCaseInsensitive]) then
  begin
    TryAppend;
    Name.AsString := AName;
    TryPost;
  end;
end;

end.
