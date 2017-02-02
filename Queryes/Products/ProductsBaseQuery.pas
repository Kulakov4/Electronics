unit ProductsBaseQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, DocFieldInfo, SearchMainComponent2, StoreHouseListQuery,
  SearchProductParameterValuesQuery, CustomComponentsQuery;

type
  TQueryProductsBase = class(TQueryCustomComponents)
    qStoreHouseProducts: TfrmApplyQuery;
  private
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    function GetProductID: TField;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetStorehouseId: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    property ProductID: TField read GetProductID;
    property StorehouseId: TField read GetStorehouseId;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses System.Generics.Collections, LostComponentsQuery, DBRecordHolder,
  System.IOUtils, SettingsController, RepositoryDataModule, NotifyEvents,
  ParameterValuesUnit, StrHelper;

constructor TQueryProductsBase.Create(AOwner: TComponent);
begin
  inherited;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // �� ��������� �� �� � ������ �������������� ����������
  AutoTransaction := False;
end;

procedure TQueryProductsBase.ApplyDelete(ASender: TDataSet);
begin
  Assert(PKValue > 0);
  // ������� ������� �� ������. ��� ������� �� �������.
  qStoreHouseProducts.DeleteRecord(PKValue);

  // ������� ���������� ������� ��� �� �� ������ �� � ������ ���������
  // DeleteLostComponents;

  inherited;
end;

procedure TQueryProductsBase.ApplyInsert(ASender: TDataSet);
var
  AFieldHolder: TFieldHolder;
  APK: TField;
  AProductID: TField;
  ARH: TRecordHolder;
  ARH2: TRecordHolder;
  // ASenderField: TField;
begin
  APK := ASender.FieldByName(PKFieldName);
  AProductID := ASender.FieldByName(ProductID.FieldName);

  ARH := TRecordHolder.Create(ASender);
  try

    // ���� ������ ���������� ��� ���
    if QuerySearchMainComponent2.Search(ASender.FieldByName(Value.FieldName)
      .AsString) = 0 then
    begin
      qProducts.InsertRecord(ARH);
      // ��������� ���� ������ �������� �� �������
      Assert(qProducts.PKValue > 0);

      ARH.Field[ProductID.FieldName] := qProducts.PKValue;

      // ������������ �������� ����������
      UpdateParamValue(ProductID.FieldName, ASender);
    end
    else
    begin
      // ���� ����� ��������� ��� ����
      // ���������� ��������� ��������� ����
      ARH.Field[ProductID.FieldName] := QuerySearchMainComponent2.PKValue;

      // ��������� ������ ���� ���������� � �������
      ARH2 := TDBRecord.Fill(ASender, QuerySearchMainComponent2.FDQuery, PKFieldName);
      try
        // ���� ���� ����, ������� ����� ��������
        if ARH2.Count > 0 then
        begin
          // ��������� �� ����, ������� ���� � ����������
          qProducts.UpdateRecord(ARH2);

          // � ����� �� ������ ��������� ����������� �� ������?

          {
            // ���� �� ������� ���� �������� ���������
            if ARH2.Find(SubGroup.FieldName) <> nil then
            begin
            ASubGroup.AsString := CombineSubgroup(ASubGroup.AsString,
            QuerySearchMainComponent2.SubGroup.AsString)
            end;
          }
          // ������������ �������� ����������
          UpdateParamValue(ProductID.FieldName, ASender);
        end;

      finally
        FreeAndNil(ARH2);
      end;
    end;

    // ��� ���������� �� ������ ���� ������
    Assert(not VarIsNull(ARH.Field[ProductID.FieldName]));
    // ��� ������ �� ������ ���� ������
    Assert(not VarIsNull(ARH.Field[StorehouseId.FieldName]));

    // ���� ID ��������� �� �����
    AFieldHolder := ARH.Find('ID');
    FreeAndNil(AFieldHolder);

    // �������� ��� ��������� �� �����
    qStoreHouseProducts.InsertRecord(ARH);
    Assert(qStoreHouseProducts.PKValue > 0);

    // ��������� ���� � ��� - ������������� ������ "�������-�����"
    APK.AsInteger := qStoreHouseProducts.PKValue;

    // ��������� ��� ��������
    AProductID.AsInteger := ARH.Field[ProductID.FieldName];
  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdate(ASender: TDataSet);
var
  ARH: TRecordHolder;
begin
  ARH := TRecordHolder.Create(ASender);
  try
    // ��������� ���������� � ���������� �� ������
    qStoreHouseProducts.UpdateRecord(ARH);

    // ��������� ���������� � ����� ����������
    ARH.Field['ID'] := ARH.Field[ProductID.FieldName];
    qProducts.UpdateRecord(ARH);

    // ������������ ���������� �������� ����������
    UpdateParamValue(ProductID.FieldName, ASender);

  finally
    FreeAndNil(ARH);
  end;

  inherited;
end;

procedure TQueryProductsBase.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryProductsBase.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryProductsBase.DoAfterOpen(Sender: TObject);
var
  AField: TField;
begin
  for AField in FDQuery.Fields do
    AField.ReadOnly := False;
end;

procedure TQueryProductsBase.DoBeforeOpen(Sender: TObject);
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

function TQueryProductsBase.GetProductID: TField;
begin
  Result := Field('ProductID');
end;

function TQueryProductsBase.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);
  Result := FQuerySearchMainComponent2;
end;

function TQueryProductsBase.GetStorehouseId: TField;
begin
  Result := Field('StorehouseId');
end;

procedure TQueryProductsBase.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: String;
begin
  if not AFileName.IsEmpty then
  begin
    // � �� ������ ���� �� ����� ������������ ����� � �������������
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    TryEdit;
    FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    TryPost;
  end;
end;

end.
