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
    procedure DoBeforePost(Sender: TObject);
    { Private declarations }
  protected
    procedure AddNewValue(const AValue, AProducer: string); virtual;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CheckRecord: String;
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
  TNotifyEventWrap.Create(BeforePost, DoBeforePost, FEventList);
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

procedure TQueryFamily.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
begin
  inherited;
  Assert(ASender = FDQuery);

  // ���� ������ ��������� ��� ���
  if PK.AsInteger <= 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // ���������� ��������������� ��������� ����
    FetchFields([PK.FieldName], [qProducts.PKValue], ARequest, AAction,
      AOptions);

  end;

  Assert(PK.AsInteger > 0);

  // ������������ �������� ����������
  UpdateParamValue(PKFieldName);

  Assert(PK.AsInteger > 0);

  // ��������� ��������� ������ ����������
  UpdateCategory(PK.AsInteger, SubGroup.AsString);

  inherited;
end;

function TQueryFamily.CheckRecord: String;
begin
  Result := '';

  if Value.AsString.Trim.IsEmpty then
  begin
    Result := '���������� ������ ������������';
    Exit;
  end;

  if Producer.IsNull then
  begin
    Result := '���������� ������� �������������';
    Exit;
  end;

  if SubGroup.AsString.Trim.IsEmpty then
  begin
    Result := '���������� ������ ������������� ���������';
    Exit;
  end;
end;

procedure TQueryFamily.DoAfterInsert(Sender: TObject);
begin
  // ��������� SubGroup ������� ��������������� ������� ��������� �����������
  FDQuery.FieldByName('SubGroup').AsString := CategoryExternalID;
end;

procedure TQueryFamily.DoAfterOpen(Sender: TObject);
begin
  Datasheet.OnGetText := OnDatasheetGetText;
  Diagram.OnGetText := OnDatasheetGetText;
  Drawing.OnGetText := OnDatasheetGetText;
  Image.OnGetText := OnDatasheetGetText;
end;

procedure TQueryFamily.DoBeforePost(Sender: TObject);
var
  AErrorMessage: string;
begin
  // ���� �� ���������� ������� ����� ������
  if not(FDQuery.State in [dsInsert]) then
    Exit;

  // ��������� ������ �� ������� ������
  AErrorMessage := CheckRecord;
  if not AErrorMessage.IsEmpty then
    raise Exception.Create(AErrorMessage);

  // ���� ����� ��������� ��� ����
  if qSearchFamily.SearchByValueAndProducer(Value.AsString, Producer.AsString) > 0
  then
  begin
    // ���������� ��������� ��������� ����
    PK.Value := qSearchFamily.PK.Value;

    // ��������� ���� �� ���������� ���������
    UpdateFields([IDProducer, IDDatasheet, Datasheet, IDDiagram, Diagram,
      IDDrawing, Drawing, IDImage, Image, DescriptionID,
      DescriptionComponentName, Description], [qSearchFamily.W.IDProducer.F.Value,
      qSearchFamily.W.IDDatasheet.F.Value, qSearchFamily.W.Datasheet.F.Value,
      qSearchFamily.W.IDDiagram.F.Value, qSearchFamily.W.Diagram.F.Value,
      qSearchFamily.W.IDDrawing.F.Value, qSearchFamily.W.Drawing.F.Value,
      qSearchFamily.W.IDImage.F.Value, qSearchFamily.W.Image.F.Value,
      qSearchFamily.W.DescriptionID.F.Value,
      qSearchFamily.W.DescriptionComponentName.F.Value,
      qSearchFamily.W.Description.F.Value], False);

    // ���� ��������� ���� ������� � ������ ���������
    if SubGroup.AsString <> qSearchFamily.W.SubGroup.F.AsString then
      SubGroup.AsString := CombineSubgroup(SubGroup.AsString,
        qSearchFamily.W.SubGroup.F.AsString);
  end;
end;

function TQueryFamily.LocateOrAppend(const AValue, AProducer: string): Boolean;
begin
  // ���� ��������� �� ����� ��� ����� ��������
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
  if not Result then
    AddNewValue(AValue, AProducer);

end;

function TQueryFamily.LocateValue(const AValue: string): Boolean;
begin
  // ���� ��������� �� ����� ��� ����� ��������
  Result := FDQuery.LocateEx(Value.FieldName, AValue, [lxoCaseInsensitive]);
end;

procedure TQueryFamily.OnDatasheetGetText(Sender: TField; var Text: String;
  DisplayText: Boolean);
begin
  if not Sender.AsString.IsEmpty then
    Text := TPath.GetFileNameWithoutExtension(Sender.AsString);
end;

end.
