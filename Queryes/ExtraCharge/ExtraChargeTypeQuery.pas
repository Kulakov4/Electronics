unit ExtraChargeTypeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, NotifyEvents, DSWrap;

type
  TExtraChargeType = class(TDSWrap)
  private
    FName: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppend(const AName: String);
    function Lookup(const AExtraChargeTypeName: String): Variant;
    property Name: TFieldWrap read FName;
    property ID: TFieldWrap read FID;
  end;

  TQueryExtraChargeType = class(TQueryWithDataSource)
  private
    FW: TExtraChargeType;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TExtraChargeType read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryExtraChargeType.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TExtraChargeType;
  AutoTransaction := False;
end;

function TQueryExtraChargeType.CreateDSWrap: TDSWrap;
begin
  Result := TExtraChargeType.Create(FDQuery);
end;

constructor TExtraChargeType.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FName := TFieldWrap.Create(Self, 'Name', 'Наименование');
end;

procedure TExtraChargeType.LocateOrAppend(const AName: String);
begin
  if not FDDataSet.LocateEx(Name.FieldName, AName, [lxoCaseInsensitive]) then
  begin
    TryAppend;
    Name.F.AsString := AName;
    TryPost;
  end;
end;

function TExtraChargeType.Lookup(const AExtraChargeTypeName: String): Variant;
begin
  Result := FDDataSet.LookupEx(Name.FieldName, AExtraChargeTypeName,
    PKFieldName, [lxoCaseInsensitive]);
end;

end.
