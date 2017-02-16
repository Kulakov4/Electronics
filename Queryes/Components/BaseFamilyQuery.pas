unit BaseFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomComponentsQuery,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ApplyQueryFrame, Vcl.StdCtrls,
  SearchComponentCategoryQuery, SearchComponentCategoryQuery2,
  SearchComponentQuery, SearchFamilyByValue, SearchProductParameterValuesQuery,
  SearchCategoryBySubGroup;

type
  TQueryBaseFamily = class(TQueryCustomComponents)
  private
    FQuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup;
    FQuerySearchFamilyByValue: TQuerySearchFamilyByValue;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    FQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    procedure DoBeforeOpen(Sender: TObject);
    function GetQuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup;
    function GetQuerySearchFamilyByValue: TQuerySearchFamilyByValue;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    function GetQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property QuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup read
        GetQuerySearchCategoryBySubGroup;
    property QuerySearchFamilyByValue: TQuerySearchFamilyByValue read
        GetQuerySearchFamilyByValue;
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

constructor TQueryBaseFamily.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryBaseFamily.ApplyDelete(ASender: TDataSet);
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

procedure TQueryBaseFamily.ApplyInsert(ASender: TDataSet);
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
  if QuerySearchFamilyByValue.Search(AValue.AsString) = 0 then
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
    APK.AsInteger := QuerySearchFamilyByValue.PKValue;

    // ��������� ������ ���� ���������� � �������
    ARH := TDBRecord.Fill(ASender, QuerySearchFamilyByValue.FDQuery, PKFieldName);
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
            QuerySearchFamilyByValue.SubGroup.AsString)
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

procedure TQueryBaseFamily.ApplyUpdate(ASender: TDataSet);
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

procedure TQueryBaseFamily.DoBeforeOpen(Sender: TObject);
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

function TQueryBaseFamily.GetQuerySearchCategoryBySubGroup:
    TQuerySearchCategoryBySubGroup;
begin
  if FQuerySearchCategoryBySubGroup = nil then
    FQuerySearchCategoryBySubGroup := TQuerySearchCategoryBySubGroup.Create(Self);

  Result := FQuerySearchCategoryBySubGroup;
end;

function TQueryBaseFamily.GetQuerySearchFamilyByValue:
    TQuerySearchFamilyByValue;
begin
  if FQuerySearchFamilyByValue = nil then
    FQuerySearchFamilyByValue := TQuerySearchFamilyByValue.Create(Self);

  Result := FQuerySearchFamilyByValue;
end;

function TQueryBaseFamily.GetQuerySearchComponentCategory
  : TQuerySearchComponentCategory;
begin
  if FQuerySearchComponentCategory = nil then
    FQuerySearchComponentCategory := TQuerySearchComponentCategory.Create(Self);

  Result := FQuerySearchComponentCategory;
end;

function TQueryBaseFamily.GetQuerySearchComponentCategory2
  : TQuerySearchComponentCategory2;
begin
  if FQuerySearchComponentCategory2 = nil then
    FQuerySearchComponentCategory2 :=
      TQuerySearchComponentCategory2.Create(Self);

  Result := FQuerySearchComponentCategory2;
end;

procedure TQueryBaseFamily.UpdateCategory(AIDComponent: Integer;
  const ASubGroup: String);
var
  rc: Integer;
begin
  // ������� ������ ��������� �� "������" ���������
  QuerySearchComponentCategory2.SearchAndDelete(AIDComponent, ASubGroup);

  if not ASubGroup.IsEmpty then
  begin
    // ����� ������� ��������� � ������ ��� ���������
    rc := QuerySearchCategoryBySubGroup.Search(ASubGroup);
    Assert(rc > 0);
    QuerySearchCategoryBySubGroup.FDQuery.First;
    while not QuerySearchCategoryBySubGroup.FDQuery.Eof do
    begin
      // ���� ��������� �� ��������� � ���� ��������� �� ��������� ��� � ��� ���������
      QuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
        QuerySearchCategoryBySubGroup.PKValue);

      QuerySearchCategoryBySubGroup.FDQuery.Next;
    end;
  end;
end;

end.