unit StoreHouseListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit;

type
  TQueryStoreHouseList = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
    procedure FDQueryBeforeOpen(DataSet: TDataSet);
  private
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforePost(Sender: TObject);
    function GetAbbreviation: TField;
    function GetTitle: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    function LocateByAbbreviation(const AAbbreviation: string): Boolean;
    function LocateOrAppend(const AValue: string): Boolean;
    property Abbreviation: TField read GetAbbreviation;
    property Title: TField read GetTitle;
    { Public declarations }
  end;

implementation

uses NotifyEvents, RepositoryDataModule, StrHelper;

{$R *.dfm}
{ TfrmQueryStoreHouseList }

constructor TQueryStoreHouseList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
end;

procedure TQueryStoreHouseList.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  Title.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryStoreHouseList.DoAfterOpen(Sender: TObject);
begin
  Abbreviation.DisplayLabel := 'Склад';
end;

procedure TQueryStoreHouseList.DoBeforePost(Sender: TObject);
begin
  if Title.AsString.Trim.IsEmpty then
    raise Exception.Create('Не задано наименование склада');

  // Если сокращённое наименование не задано
  if (FDQuery.State = dsInsert) and Abbreviation.IsNull then
  begin
    Abbreviation.AsString := DeleteDouble(Title.AsString, ' ').Replace(' ', '');
  end;

end;

procedure TQueryStoreHouseList.FDQueryBeforeOpen(DataSet: TDataSet);
begin;
  inherited;
end;

function TQueryStoreHouseList.GetAbbreviation: TField;
begin
  Result := Field('Abbreviation');
end;

function TQueryStoreHouseList.GetTitle: TField;
begin
  Result := Field('Title');
end;

function TQueryStoreHouseList.LocateByAbbreviation(const AAbbreviation
  : string): Boolean;
begin
  Assert(not AAbbreviation.IsEmpty);
  Result := FDQuery.Locate(Abbreviation.FieldName, AAbbreviation, []);
end;

function TQueryStoreHouseList.LocateOrAppend(const AValue: string): Boolean;
begin
  // Ищем склад по имени без учёта регистра
  Result := FDQuery.LocateEx(Title.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue);

end;

end.
