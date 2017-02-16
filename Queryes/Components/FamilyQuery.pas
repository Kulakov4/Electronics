unit FamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, Sequence, RepositoryDataModule,
  System.Generics.Collections, ExcelDataModule, SearchComponentCategoryQuery,
  SearchComponentCategoryQuery2, CustomComponentsQuery, ApplyQueryFrame,
  SearchComponentQuery, SearchCategoryByID, BaseFamilyQuery;

type
  TQueryFamily = class(TQueryBaseFamily)
  private
    FQuerySearchCategoryByID: TQuerySearchCategoryByID;
    procedure DoAfterInsert(Sender: TObject);
    function GetCurProductCategoriesExternalID: string;
    function GetQuerySearchCategoryByID: TQuerySearchCategoryByID;
    { Private declarations }
  protected
    procedure AddNewValue(const AValue, AProducer: string); virtual;
    procedure DoAfterOpen(Sender: TObject);
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    property QuerySearchCategoryByID: TQuerySearchCategoryByID read
        GetQuerySearchCategoryByID;
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

constructor TQueryFamily.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vProductCategoryId';
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryFamily.AddNewValue(const AValue, AProducer: string);
begin
  Assert(not AValue.Trim.IsEmpty);
  Assert(not AProducer.Trim.IsEmpty);
  FDQuery.Append;
  Value.AsString := AValue;
  Producer.AsString := AProducer;
  FDQuery.Post;
end;

procedure TQueryFamily.DoAfterInsert(Sender: TObject);
begin
  // ��������� SubGroup ������� ��������������� ������� ��������� �����������
  FDQuery.FieldByName('SubGroup').AsString := CurProductCategoriesExternalID;
end;

procedure TQueryFamily.DoAfterOpen(Sender: TObject);
begin
  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
end;

function TQueryFamily.GetCurProductCategoriesExternalID: string;
var
  rc: Integer;
begin
  Assert(FDQuery.Active);
  rc := QuerySearchCategoryByID.Search
    (FDQuery.ParamByName(DetailParameterName).AsInteger);
  Assert(rc = 1);
  Result := QuerySearchCategoryByID.ExternalID.AsString;
end;

function TQueryFamily.GetQuerySearchCategoryByID: TQuerySearchCategoryByID;
begin
  if FQuerySearchCategoryByID = nil then
    FQuerySearchCategoryByID := TQuerySearchCategoryByID.Create(Self);
  Result := FQuerySearchCategoryByID;
end;

function TQueryFamily.LocateOrAppend(const AValue, AProducer: string):
    Boolean;
begin
  // ���� ��������� �� ����� ��� ����� ��������
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue, AProducer);

end;

procedure TQueryFamily.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

end.
