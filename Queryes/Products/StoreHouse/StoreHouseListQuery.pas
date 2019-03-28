unit StoreHouseListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DSWrap, BaseEventsQuery;

type
  TStoreHouseListW = class(TDSWrap)
  private
    FAbbreviation: TFieldWrap;
    FTitle: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    function LocateByAbbreviation(const AAbbreviation: string): Boolean;
    function LocateOrAppend(const AValue: string): Boolean;
    property Abbreviation: TFieldWrap read FAbbreviation;
    property Title: TFieldWrap read FTitle;
    property ID: TFieldWrap read FID;
  end;

  TQueryStoreHouseList = class(TQueryBaseEvents)
    FDUpdateSQL: TFDUpdateSQL;
    procedure FDQueryUpdateError(ASender: TDataSet; AException: EFDException; ARow:
        TFDDatSRow; ARequest: TFDUpdateRequest; var AAction: TFDErrorAction);
  private
    FW: TStoreHouseListW;
    procedure DoBeforePost(Sender: TObject);
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TStoreHouseListW read FW;
    { Public declarations }
  end;

implementation

uses NotifyEvents, RepositoryDataModule, StrHelper;

{$R *.dfm}
{ TfrmQueryStoreHouseList }

constructor TQueryStoreHouseList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FW := FDSWrap as TStoreHouseListW;
  TNotifyEventWrap.Create(W.BeforePost, DoBeforePost, W.EventList);
end;

function TQueryStoreHouseList.CreateDSWrap: TDSWrap;
begin
  Result := TStoreHouseListW.Create(FDQuery);
end;

procedure TQueryStoreHouseList.DoBeforePost(Sender: TObject);
begin
  if W.Title.F.AsString.Trim.IsEmpty then
    raise Exception.Create('Не задано наименование склада');

  // Если сокращённое наименование не задано
//  if (FDQuery.State = dsInsert) and W.Abbreviation.F.IsNull then
//  begin
    W.Abbreviation.F.AsString := DeleteDouble(W.Title.F.AsString, ' ')
      .Replace(' ', '');
//  end;

end;

procedure TQueryStoreHouseList.FDQueryUpdateError(ASender: TDataSet;
    AException: EFDException; ARow: TFDDatSRow; ARequest: TFDUpdateRequest; var
    AAction: TFDErrorAction);
begin
  inherited;
  if AException.Message ='[FireDAC][Phys][SQLite] ERROR: UNIQUE constraint failed: Storehouse.Title' then
    AException.Message := 'Наименование склада должно быть уникальным';
end;

constructor TStoreHouseListW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FAbbreviation := TFieldWrap.Create(Self, 'Abbreviation', 'Склад');
  FTitle := TFieldWrap.Create(Self, 'Title', 'Наименование');
end;

procedure TStoreHouseListW.AddNewValue(const AValue: string);
begin
  TryAppend;
  Title.F.AsString := AValue;
  TryPost;
end;

function TStoreHouseListW.LocateByAbbreviation(const AAbbreviation
  : string): Boolean;
begin
  Assert(not AAbbreviation.IsEmpty);
  Result := FDDataSet.Locate(Abbreviation.FieldName, AAbbreviation, []);
end;

function TStoreHouseListW.LocateOrAppend(const AValue: string): Boolean;
begin
  // Ищем склад по имени без учёта регистра
  Result := FDDataSet.LocateEx(Title.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue);

end;

end.
