unit FamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, {Sequence,} RepositoryDataModule,
  System.Generics.Collections, ExcelDataModule, SearchComponentCategoryQuery,
  CustomComponentsQuery, ApplyQueryFrame, BaseFamilyQuery;

type
  TQueryFamily = class(TQueryBaseFamily)
  private
    procedure DoAfterInsert(Sender: TObject);
    { Private declarations }
  protected
    procedure AddNewValue(const AValue, AProducer: string); virtual;
    procedure DoAfterOpen(Sender: TObject);
    procedure OnDatasheetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function LocateOrAppend(const AValue, AProducer: string): Boolean;
    function LocateValue(const AValue: string): Boolean;
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
  // Заполняем SubGroup внешним идентификатором текущей категории компонентов
  FDQuery.FieldByName('SubGroup').AsString := CategoryExternalID;
end;

procedure TQueryFamily.DoAfterOpen(Sender: TObject);
begin
  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
end;

function TQueryFamily.LocateOrAppend(const AValue, AProducer: string): Boolean;
begin
  // Ищем компонент по имени без учёта регистра
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue, AProducer);

end;

function TQueryFamily.LocateValue(const AValue: string): Boolean;
begin
  // Ищем компонент по имени без учёта регистра
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
end;

procedure TQueryFamily.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

end.
