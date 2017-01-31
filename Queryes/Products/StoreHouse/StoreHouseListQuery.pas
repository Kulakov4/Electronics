unit StoreHouseListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit;

type
  TQueryStoreHouseList = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    function GetTitle: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    function LocateOrAppend(const AValue: string): Boolean;
    property Title: TField read GetTitle;
    { Public declarations }
  end;

implementation

uses NotifyEvents, RepositoryDataModule;

{$R *.dfm}

{ TfrmQueryStoreHouseList }

constructor TQueryStoreHouseList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TQueryStoreHouseList.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  Title.AsString := AValue;
  FDQuery.Post;
end;

function TQueryStoreHouseList.GetTitle: TField;
begin
  Result := Field('Title');
end;

function TQueryStoreHouseList.LocateOrAppend(const AValue: string): Boolean;
begin
  // »щем склад по имени без учЄта регистра
  Result := FDQuery.LocateEx(Title.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue);

end;

end.
