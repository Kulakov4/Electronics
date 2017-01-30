unit DescriptionsMasterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryDescriptionsMaster = class(TfrmDataModule)
    FDQueryID: TFDAutoIncField;
    FDQueryComponentType: TWideStringField;
    FDQuery2: TFDQuery;
  private
    FShowDublicate: Boolean;
    function GetComponentType: TField;
    procedure SetShowDublicate(const Value: Boolean);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure LocateOrAppend(AValue: string);
    property ComponentType: TField read GetComponentType;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryDescriptionsMaster.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
end;

procedure TQueryDescriptionsMaster.AddNewValue(const AValue: string);
//var
//  AClone: TFDMemTable;
begin
{
  AClone := TFDMemTable.Create(Self);
  try
    AClone.CloneCursor(FDQuery);
    AClone.Append;
    AClone.FieldByName(ComponentType.FieldName).AsString := AValue;
    AClone.Post;
  finally
    FreeAndNil(AClone);
  end;
}
  FDQuery.Append;
  ComponentType.AsString := AValue;
  FDQuery.Post;
end;


function TQueryDescriptionsMaster.GetComponentType: TField;
begin
  Result := Field('ComponentType');
end;

procedure TQueryDescriptionsMaster.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  OK := FDQuery.LocateEx('ComponentType', AValue, []);

  if not OK then
    AddNewValue(AValue);
end;

procedure TQueryDescriptionsMaster.SetShowDublicate(const Value: Boolean);
var
  ASQL: TStringList;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    ASQL := TStringList.Create;
    try
      ASQL.Assign(FDQuery.SQL);

      FDQuery.Close;
      FDQuery.SQL.Assign(FDQuery2.SQL);
      FDQuery.Open;

      FDQuery2.SQL.Assign(ASQL);
    finally
      FreeAndNil(ASQL)
    end;
  end;
end;

end.
