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
  SearchCategoryQuery, SearchFamily, DSWrap;

type
  TBaseFamilyW = class(TCustomComponentsW)
  private
    FExternalID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TFieldWrap read FExternalID;
  end;

  TQueryBaseFamily = class(TQueryCustomComponents)
  private
    FBaseFamilyW: TBaseFamilyW;
    FqSearchCategory: TQuerySearchCategory;
    FqSearchFamily: TQuerySearchFamily;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    procedure DoBeforeOpen(Sender: TObject);
    function GetCategoryExternalID: string;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetqSearchFamily: TQuerySearchFamily;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    function CreateDSWrap: TDSWrap; override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
    property qSearchFamily: TQuerySearchFamily read GetqSearchFamily;
    property QuerySearchComponentCategory: TQuerySearchComponentCategory
      read GetQuerySearchComponentCategory;
  public
    constructor Create(AOwner: TComponent); override;
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
  FBaseFamilyW := FDSWrap as TBaseFamilyW;
  TNotifyEventWrap.Create(W.BeforeOpen, DoBeforeOpen, W.EventList);
end;

procedure TQueryBaseFamily.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);
  if W.PK.AsInteger > 0 then
  begin
    // ������� ��������� �� ���� ���������
    UpdateCategory(W.PK.AsInteger, '');

    // ������� ��� ���������
    qProducts.DeleteRecord(W.PK.AsInteger);
  end;

  inherited;
end;

procedure TQueryBaseFamily.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  ARH: TRecordHolder;
  ASubGroup: TField;
begin
  Assert(ASender = FDQuery);

  ARH := TRecordHolder.Create(ASender);
  try
    // ��������� �� ����, ������� ���� � ����������
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  // ������������ ���������� �������� ����������
  W.UpdateParamValue(W.PKFieldName);

  ASubGroup := FDQuery.FindField('SubGroup');
  // ���� � ������� ���������� ������� ���� ���������
  if ASubGroup <> nil then
  begin
    // ��������� ��������� ������ ����������
    UpdateCategory(W.PK.AsInteger, ASubGroup.AsString);
  end;

  inherited;
end;

function TQueryBaseFamily.CreateDSWrap: TDSWrap;
begin
  Result := TBaseFamilyW.Create(FDQuery);
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

function TQueryBaseFamily.GetCategoryExternalID: string;
begin
  Assert(FDQuery.Active);

  if not FBaseFamilyW.ExternalID.F.AsString.IsEmpty then
  begin
    Result := FBaseFamilyW.ExternalID.F.AsString;
    Exit;
  end;

  Assert(not DetailParameterName.IsEmpty);

  qSearchCategory.SearchByID(FDQuery.ParamByName(DetailParameterName).AsInteger, 1);
  Result := qSearchCategory.W.ExternalID.F.AsString;
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
        qSearchCategory.W.PK.Value);

      qSearchCategory.FDQuery.Next;
    end;
  end;
end;

constructor TBaseFamilyW.Create(AOwner: TComponent);
begin
  inherited;
  FExternalID := TFieldWrap.Create(Self, 'ExternalID');
end;

end.
