unit DescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit;

type
  TQueryDescriptions = class(TQueryWithDataSource)
    fdqBase: TFDQuery;
    FDQueryID: TFDAutoIncField;
    FDQueryComponentName: TWideStringField;
    FDQueryDescription: TWideMemoField;
    FDQueryIDComponentType: TIntegerField;
    FDQueryIDProducer: TIntegerField;
  private
    FShowDublicate: Boolean;
    function GetComponentName: TField;
    function GetDescription: TField;
    function GetIDComponentType: TField;
    function GetIDProducer: TField;
    procedure SetShowDublicate(const Value: Boolean);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Description: TField read GetDescription;
    property IDComponentType: TField read GetIDComponentType;
    property IDProducer: TField read GetIDProducer;
    property ShowDublicate: Boolean read FShowDublicate write SetShowDublicate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper;

constructor TQueryDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  //  опируем базовый запрос и параметры
  AssignFrom(fdqBase);

  AutoTransaction := False;
end;

function TQueryDescriptions.GetComponentName: TField;
begin
  Result := Field('ComponentName');
end;

function TQueryDescriptions.GetDescription: TField;
begin
  Result := Field('Description');
end;

function TQueryDescriptions.GetIDComponentType: TField;
begin
  Result := Field('IDComponentType');
end;

function TQueryDescriptions.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

procedure TQueryDescriptions.SetShowDublicate(const Value: Boolean);
var
  ASQL: String;
begin
  if FShowDublicate <> Value then
  begin
    FShowDublicate := Value;

    ASQL := fdqBase.SQL.Text;
    if FShowDublicate then
    begin
      ASQL := Replace(ASQL, '', '/* ShowDublicate');
      ASQL := Replace(ASQL, '', 'ShowDublicate */');
    end;

    FDQuery.Close;
    FDQuery.SQL.Text := ASQL;
    FDQuery.Open;
  end;
end;

end.
