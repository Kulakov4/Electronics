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
  SearchComponentCategoryQuery, SearchProductParameterValuesQuery,
  SearchCategoryQuery, SearchFamily;

type
  TQueryBaseFamily = class(TQueryCustomComponents)
  private
    FqSearchCategory: TQuerySearchCategory;
    FqSearchFamily: TQuerySearchFamily;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    procedure DoBeforeOpen(Sender: TObject);
    function GetExternalID: TField;
    function GetCategoryExternalID: string;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
    property qSearchFamily: TQuerySearchFamily read GetqSearchFamily;
    property QuerySearchComponentCategory: TQuerySearchComponentCategory
      read GetQuerySearchComponentCategory;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TField read GetExternalID;
    property CategoryExternalID: string read GetCategoryExternalID;
    { Public declarations }
  end;

implementation

uses DBRecordHolder, System.Generics.Collections, DefaultParameters,
  NotifyEvents;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryBaseFamily.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryBaseFamily.ApplyDelete(ASender: TDataSet);
begin
  Assert(ASender = FDQuery);
  if PK.AsInteger > 0 then
  begin
    // ������� ��������� �� ���� ���������
    UpdateCategory(PK.AsInteger, '');

    // ������� ��� ���������
    qProducts.DeleteRecord(PK.AsInteger);
  end;

  inherited;
end;

procedure TQueryBaseFamily.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
begin
  Assert(ASender = FDQuery);

  // ���� ������ ��������� ��� ���
  if qSearchFamily.SearchByValue(Value.AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // ���������� ��������������� ��������� ����
    FetchFields([PK.FieldName], [qProducts.PKValue], ARequest,
      AAction, AOptions);
    //APK.AsInteger := qProducts.PKValue;

    // ������������ �������� ����������
    UpdateParamValue(PKFieldName);
  end
  else
  begin
    // ���� ����� ��������� ��� ����
    // ���������� ��������� ��������� ����
    FetchFields([PK.FieldName], [qSearchFamily.PK.Value], ARequest,
      AAction, AOptions);
    //APK.Value := qSearchFamily.PK.Value;

    // ��������� ������ ���� ���������� � �������
    ARH := TDBRecord.Fill(ASender, qSearchFamily.FDQuery,
      PKFieldName);
    try
      // ���� ���� ����, ������� ����� ��������
      if ARH.Count > 0 then
      begin
        // ��������� �� ����, ������� ���� � ����������
        qProducts.UpdateRecord(ARH);

        // ���� �� ������� ���� �������� ���������
        if ARH.Find(SubGroup.FieldName) <> nil then
        begin
          SubGroup.AsString := CombineSubgroup(SubGroup.AsString,
            qSearchFamily.SubGroup.AsString)
        end;

        // ������������ �������� ����������
        UpdateParamValue(PKFieldName);
      end;
    finally
      FreeAndNil(ARH);
    end;
  end;

  Assert(PK.AsInteger > 0);

  // ��������� ��������� ������ ����������
  UpdateCategory(PK.AsInteger, SubGroup.AsString);

  inherited;
end;

procedure TQueryBaseFamily.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  // APackagePins: TField;
//  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
begin
  // APackagePins := ASender.FieldByName(PackagePins.FieldName);
  Assert(ASender = FDQuery);

  ARH := TRecordHolder.Create(ASender);
  try
    // ��������� �� ����, ������� ���� � ����������
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  // ������������ ���������� �������� ����������
  UpdateParamValue(PKFieldName);

  ASubGroup := ASender.FindField('SubGroup');
  // ���� � ������� ���������� ������� ���� ���������
  if ASubGroup <> nil then
  begin
    //APK := ASender.FieldByName(PKFieldName);

    // ��������� ��������� ������ ����������
    UpdateCategory(PK.AsInteger, ASubGroup.AsString);
  end;

  inherited;
end;

procedure TQueryBaseFamily.DoBeforeOpen(Sender: TObject);
begin
  // ��������� ��� ��������� "�������������"
  FDQuery.ParamByName('ProducerParamSubParamID').AsInteger :=
    TDefaultParameters.ProducerParamSubParamID;

  FDQuery.ParamByName('PackagePinsParamSubParamID').AsInteger :=
    TDefaultParameters.PackagePinsParamSubParamID;

  FDQuery.ParamByName('DatasheetParamSubParamID').AsInteger :=
    TDefaultParameters.DatasheetParamSubParamID;

  FDQuery.ParamByName('DiagramParamSubParamID').AsInteger :=
    TDefaultParameters.DiagramParamSubParamID;

  FDQuery.ParamByName('DrawingParamSubParamID').AsInteger :=
    TDefaultParameters.DrawingParamSubParamID;

  FDQuery.ParamByName('ImageParamSubParamID').AsInteger :=
    TDefaultParameters.ImageParamSubParamID;

end;

function TQueryBaseFamily.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryBaseFamily.GetCategoryExternalID: string;
begin
  Assert(FDQuery.Active);

  if not ExternalID.AsString.IsEmpty then
  begin
    Result := ExternalID.AsString;
    Exit;
  end;

  Assert(not DetailParameterName.IsEmpty);

  qSearchCategory.SearchByID(FDQuery.ParamByName(DetailParameterName).AsInteger, 1);
  Result := qSearchCategory.ExternalID.AsString;
end;

function TQueryBaseFamily.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

function TQueryBaseFamily.GetqSearchFamily: TQuerySearchFamily;
begin
  if FqSearchFamily = nil then
    FqSearchFamily := TQuerySearchFamily.Create(Self);

  Result := FqSearchFamily;
end;

function TQueryBaseFamily.GetQuerySearchComponentCategory
  : TQuerySearchComponentCategory;
begin
  if FQuerySearchComponentCategory = nil then
    FQuerySearchComponentCategory := TQuerySearchComponentCategory.Create(Self);

  Result := FQuerySearchComponentCategory;
end;

procedure TQueryBaseFamily.UpdateCategory(AIDComponent: Integer;
  const ASubGroup: String);
var
  rc: Integer;
begin
  // ������� ������ ��������� �� "������" ���������
  QuerySearchComponentCategory.SearchAndDelete(AIDComponent, ASubGroup);

  if not ASubGroup.IsEmpty then
  begin
    // ����� ������� ��������� � ������ ��� ���������
    rc := qSearchCategory.SearchBySubgroup(ASubGroup);
    Assert(rc > 0);
    qSearchCategory.FDQuery.First;
    while not qSearchCategory.FDQuery.Eof do
    begin
      // ���� ��������� �� ��������� � ���� ��������� �� ��������� ��� � ��� ���������
      QuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
        qSearchCategory.PK.Value);

      qSearchCategory.FDQuery.Next;
    end;
  end;
end;

end.
