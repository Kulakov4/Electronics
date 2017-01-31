unit MainComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomComponentsQuery,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ApplyQueryFrame, Vcl.StdCtrls, SearchCategoryQuery,
  SearchComponentCategoryQuery, SearchComponentCategoryQuery2,
  SearchComponentQuery, SearchMainComponent2, SearchProductParameterValuesQuery;

type
  TQueryMainComponents = class(TQueryCustomComponents)
  private
    FQuerySearchCategory: TQuerySearchCategory;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    FQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    procedure DoBeforeOpen(Sender: TObject);
    function GetQuerySearchCategory: TQuerySearchCategory;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    function GetQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property QuerySearchCategory: TQuerySearchCategory
      read GetQuerySearchCategory;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
    property QuerySearchComponentCategory: TQuerySearchComponentCategory
      read GetQuerySearchComponentCategory;
    property QuerySearchComponentCategory2: TQuerySearchComponentCategory2
      read GetQuerySearchComponentCategory2;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

uses DBRecordHolder, System.Generics.Collections, ParameterValuesUnit,
  NotifyEvents;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryMainComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryMainComponents.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
begin
  AID := ASender.FieldByName(PKFieldName).AsInteger;
  if AID > 0 then
  begin
    // ������� ��������� �� ���� ���������
    UpdateCategory(AID, '');

    // ������� ��� ���������
    qProducts.DeleteRecord(AID);
  end;

  inherited;
end;

procedure TQueryMainComponents.ApplyInsert(ASender: TDataSet);
var
  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
  AValue: TField;
begin
  APK := ASender.FieldByName(PKFieldName);
  AValue := ASender.FieldByName(Value.FieldName);
  ASubGroup := ASender.FieldByName(SubGroup.FieldName);

  // ���� ������ ���������� ��� ���
  if QuerySearchMainComponent2.Search(AValue.AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // ���������� ��������������� ��������� ����
    APK.AsInteger := qProducts.PKValue;

    // ������������ �������� ����������
    UpdateParamValue(PKFieldName, ASender);
  end
  else
  begin
    // ���� ����� ��������� ��� ����
    // ���������� ��������� ��������� ����
    APK.AsInteger := QuerySearchMainComponent2.PKValue;

    // ��������� ������ ���� ���������� � �������
    ARH := TDBRecord.Fill(ASender, QuerySearchMainComponent2.FDQuery, PKFieldName);
    try
      // ���� ���� ����, ������� ����� ��������
      if ARH.Count > 0 then
      begin
        // ��������� �� ����, ������� ���� � ����������
        qProducts.UpdateRecord(ARH);

        // ���� �� ������� ���� �������� ���������
        if ARH.Find(SubGroup.FieldName) <> nil then
        begin
          ASubGroup.AsString := CombineSubgroup(ASubGroup.AsString,
            QuerySearchMainComponent2.SubGroup.AsString)
        end;

        // ������������ �������� ����������
        UpdateParamValue(PKFieldName, ASender);
      end;
    finally
      FreeAndNil(ARH);
    end;
  end;

  Assert(APK.AsInteger > 0);

  // ��������� ��������� ������ ����������
  UpdateCategory(APK.AsInteger, ASubGroup.AsString);

  inherited;
end;

procedure TQueryMainComponents.ApplyUpdate(ASender: TDataSet);
var
  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
begin
  ARH := TRecordHolder.Create(ASender);
  try
    // ��������� �� ����, ������� ���� � ����������
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  // ������������ ���������� �������� ����������
  UpdateParamValue(PKFieldName, ASender);

  ASubGroup := ASender.FindField('SubGroup');
  // ���� � ������� ���������� ������� ���� ���������
  if ASubGroup <> nil then
  begin
    APK := ASender.FieldByName(PKFieldName);

    // ��������� ��������� ������ ����������
    UpdateCategory(APK.AsInteger, ASubGroup.AsString);
  end;

  inherited;
end;

procedure TQueryMainComponents.DoBeforeOpen(Sender: TObject);
begin
  // ��������� ��� ��������� "�������������"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;

  FDQuery.ParamByName('PackagePinsParameterID').AsInteger :=
    TParameterValues.PackagePinsParameterID;

  FDQuery.ParamByName('DatasheetParameterID').AsInteger :=
    TParameterValues.DatasheetParameterID;

  FDQuery.ParamByName('DiagramParameterID').AsInteger :=
    TParameterValues.DiagramParameterID;

  FDQuery.ParamByName('DrawingParameterID').AsInteger :=
    TParameterValues.DrawingParameterID;

  FDQuery.ParamByName('ImageParameterID').AsInteger :=
    TParameterValues.ImageParameterID;

end;

function TQueryMainComponents.GetQuerySearchCategory: TQuerySearchCategory;
begin
  if FQuerySearchCategory = nil then
    FQuerySearchCategory := TQuerySearchCategory.Create(Self);

  Result := FQuerySearchCategory;
end;

function TQueryMainComponents.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);

  Result := FQuerySearchMainComponent2;
end;

function TQueryMainComponents.GetQuerySearchComponentCategory
  : TQuerySearchComponentCategory;
begin
  if FQuerySearchComponentCategory = nil then
    FQuerySearchComponentCategory := TQuerySearchComponentCategory.Create(Self);

  Result := FQuerySearchComponentCategory;
end;

function TQueryMainComponents.GetQuerySearchComponentCategory2
  : TQuerySearchComponentCategory2;
begin
  if FQuerySearchComponentCategory2 = nil then
    FQuerySearchComponentCategory2 :=
      TQuerySearchComponentCategory2.Create(Self);

  Result := FQuerySearchComponentCategory2;
end;

procedure TQueryMainComponents.UpdateCategory(AIDComponent: Integer;
  const ASubGroup: String);
var
  rc: Integer;
begin
  // ������� ������ ��������� �� "������" ���������
  QuerySearchComponentCategory2.SearchAndDelete(AIDComponent, ASubGroup);

  if not ASubGroup.IsEmpty then
  begin
    // ����� ������� ��������� � ������ ��� ���������
    rc := QuerySearchCategory.Search(ASubGroup);
    Assert(rc > 0);
    QuerySearchCategory.FDQuery.First;
    while not QuerySearchCategory.FDQuery.Eof do
    begin
      // ���� ��������� �� ��������� � ���� ��������� �� ��������� ��� � ��� ���������
      QuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
        QuerySearchCategory.PKValue);

      QuerySearchCategory.FDQuery.Next;
    end;
  end;
end;

end.
