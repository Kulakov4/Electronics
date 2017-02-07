unit ComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Sequence, RepositoryDataModule,
  System.Generics.Collections, ExcelDataModule, SearchComponentCategoryQuery,
  SearchCategoryQuery, SearchComponentCategoryQuery2, CustomComponentsQuery,
  ApplyQueryFrame, SearchComponentQuery, SearchProductCategoryByID,
  MainComponentsQuery;

type
  TQueryComponents = class(TQueryMainComponents)
  private
    FQuerySearchProductCategoryByID: TQuerySearchProductCategoryByID;
    procedure DoAfterInsert(Sender: TObject);
    function GetCurProductCategoriesExternalID: string;
    function GetQuerySearchProductCategoryByID: TQuerySearchProductCategoryByID;
    { Private declarations }
  protected
    procedure AddNewValue(const AValue, AProducer: string); virtual;
    procedure DoAfterOpen(Sender: TObject);
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    property QuerySearchProductCategoryByID: TQuerySearchProductCategoryByID
      read GetQuerySearchProductCategoryByID;
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AValue, AProducer: string): Boolean;
    property CurProductCategoriesExternalID: string
      read GetCurProductCategoriesExternalID;
    { Public declarations }
  end;

implementation

uses NotifyEvents, System.IOUtils, SettingsController, DBRecordHolder,
  ParameterValuesUnit;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vProductCategoryId';
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryComponents.AddNewValue(const AValue, AProducer: string);
begin
  Assert(not AValue.Trim.IsEmpty);
  Assert(not AProducer.Trim.IsEmpty);
  FDQuery.Append;
  Value.AsString := AValue;
  Producer.AsString := AProducer;
  FDQuery.Post;
end;

procedure TQueryComponents.DoAfterInsert(Sender: TObject);
begin
  // Заполняем SubGroup внешним идентификатором текущей категории компонентов
  FDQuery.FieldByName('SubGroup').AsString := CurProductCategoriesExternalID;
end;

procedure TQueryComponents.DoAfterOpen(Sender: TObject);
begin
  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
end;

function TQueryComponents.GetCurProductCategoriesExternalID: string;
var
  rc: Integer;
begin
  Assert(FDQuery.Active);
  rc := QuerySearchProductCategoryByID.Search
    (FDQuery.ParamByName(DetailParameterName).AsInteger);
  Assert(rc = 1);
  Result := QuerySearchProductCategoryByID.ExternalID.AsString;
end;

function TQueryComponents.GetQuerySearchProductCategoryByID
  : TQuerySearchProductCategoryByID;
begin
  if FQuerySearchProductCategoryByID = nil then
    FQuerySearchProductCategoryByID :=
      TQuerySearchProductCategoryByID.Create(Self);
  Result := FQuerySearchProductCategoryByID;
end;

function TQueryComponents.LocateOrAppend(const AValue, AProducer: string):
    Boolean;
begin
  // Ищем компонент по имени без учёта регистра
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue, AProducer);

end;

procedure TQueryComponents.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

end.
