unit CustomComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, NotifyEvents,
  SearchComponentCategoryQuery, SearchComponentCategoryQuery2,
  SearchProductParameterValuesQuery, System.Generics.Collections,
  QueryWithDataSourceUnit;

type
  TQueryCustomComponents = class(TQueryWithDataSource)
    qProducts: TfrmApplyQuery;
  private
    FParameterFields: TDictionary<Integer, String>;
    FQuerySearchProductParameterValues: TQuerySearchProductParameterValues;
    procedure DoAfterConnect(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    function GetDatasheet: TField;
    function GetPackagePins: TField;
    function GetParentProductID: TField;
    function GetProducer: TField;
    function GetDiagram: TField;
    function GetImage: TField;
    function GetDrawing: TField;
    function GetIDDatasheet: TField;
    function GetIDDiagram: TField;
    function GetIDDrawing: TField;
    function GetIDImage: TField;
    function GetIDProducer: TField;
    function GetQuerySearchProductParameterValues
      : TQuerySearchProductParameterValues;
    function GetSubGroup: TField;
    function GetValue: TField;
    { Private declarations }
  protected
    procedure InitParameterFields; virtual;
    procedure ProcessParamValue(AIDComponent: Integer;
      AIDProductParameterValue: TField; const AValue: Variant;
      AIDParameter: Integer);
    procedure UpdateParamValue(const AProductIDFieldName: string;
      ASender: TDataSet);
    property QuerySearchProductParameterValues
      : TQuerySearchProductParameterValues
      read GetQuerySearchProductParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CombineSubgroup(const ASubGroup1, ASubGroup2: String): String;
    procedure SetProducer(AIDComponent: Integer; const AProducer: String);
    procedure SetPackagePins(AIDComponent: Integer; APackagePins: string);
    property Datasheet: TField read GetDatasheet;
    property PackagePins: TField read GetPackagePins;
    property ParentProductID: TField read GetParentProductID;
    property Producer: TField read GetProducer;
    property Diagram: TField read GetDiagram;
    property Image: TField read GetImage;
    property Drawing: TField read GetDrawing;
    property IDDatasheet: TField read GetIDDatasheet;
    property IDDiagram: TField read GetIDDiagram;
    property IDDrawing: TField read GetIDDrawing;
    property IDImage: TField read GetIDImage;
    property IDProducer: TField read GetIDProducer;
    property ParameterFields: TDictionary<Integer, String>
      read FParameterFields;
    property SubGroup: TField read GetSubGroup;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, SearchMainParameterQuery, ProjectConst,
  ParameterValuesUnit, StrHelper;

constructor TQueryCustomComponents.Create(AOwner: TComponent);
begin
  inherited;

  // ������ �����, ������� �������� �����������
  FParameterFields := TDictionary<Integer, String>.Create;

  // ���� ���������� � �� ��� �� �����������
  if not DMRepository.dbConnection.Connected then
  begin
    TNotifyEventWrap.Create(DMRepository.AfterConnect, DoAfterConnect,
      FEventList);
  end
  else
    InitParameterFields;

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);

  // ����� ���� ��������� �����������
  AutoTransaction := false;

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
end;

destructor TQueryCustomComponents.Destroy;
begin
  inherited;
  FParameterFields.Free;
end;

function TQueryCustomComponents.CombineSubgroup(const ASubGroup1,
  ASubGroup2: String): String;
var
  m: TArray<String>;
  S: string;
  SS: string;
begin
  if ASubGroup2.IsEmpty then
  begin
    Result := ASubGroup1;
    Exit;
  end;

  if ASubGroup1.IsEmpty then
  begin
    Result := ASubGroup2;
    Exit;
  end;

  Result := String.Format(',%s,', [ASubGroup1.Trim([','])]);
  m := ASubGroup2.Split([',']);

  for S in m do
  begin
    SS := String.Format(',%s,', [S]);

    // ���� � ������ ������ ��� �������� �� ������ ������
    if Result.IndexOf(SS) = -1 then
      Result := Result + SS.TrimLeft([',']);
  end;
  Result := Result.Trim([',']);
end;

procedure TQueryCustomComponents.DoAfterConnect(Sender: TObject);
begin
  // �������������� ���� ������� �������� �����������
  InitParameterFields;
end;

procedure TQueryCustomComponents.DoAfterOpen(Sender: TObject);
var
  AFieldName: string;
  F: TField;
begin
  // ��������� ��� ��� ����, ������� �������� ����������� ����������
  for AFieldName in FParameterFields.Values do
  begin
    F := Field(AFieldName);
    Assert(F <> nil);
  end;

  SetFieldsRequired(false);
end;

function TQueryCustomComponents.GetDatasheet: TField;
begin
  Result := Field('Datasheet');
end;

function TQueryCustomComponents.GetPackagePins: TField;
begin
  Result := Field('PackagePins');
end;

function TQueryCustomComponents.GetParentProductID: TField;
begin
  Result := Field('ParentProductID');
end;

function TQueryCustomComponents.GetProducer: TField;
begin
  Result := Field('Producer');
end;

function TQueryCustomComponents.GetDiagram: TField;
begin
  Result := Field('Diagram');
end;

function TQueryCustomComponents.GetImage: TField;
begin
  Result := Field('Image');
end;

function TQueryCustomComponents.GetDrawing: TField;
begin
  Result := Field('Drawing');
end;

function TQueryCustomComponents.GetIDDatasheet: TField;
begin
  Result := Field('IDDatasheet');
end;

function TQueryCustomComponents.GetIDDiagram: TField;
begin
  Result := Field('IDDiagram');
end;

function TQueryCustomComponents.GetIDDrawing: TField;
begin
  Result := Field('IDDrawing');
end;

function TQueryCustomComponents.GetIDImage: TField;
begin
  Result := Field('IDImage');
end;

function TQueryCustomComponents.GetIDProducer: TField;
begin
  Result := Field('IDProducer');
end;

function TQueryCustomComponents.GetQuerySearchProductParameterValues
  : TQuerySearchProductParameterValues;
begin
  if FQuerySearchProductParameterValues = nil then
  begin
    FQuerySearchProductParameterValues :=
      TQuerySearchProductParameterValues.Create(Self);
  end;
  Result := FQuerySearchProductParameterValues;
end;

function TQueryCustomComponents.GetSubGroup: TField;
begin
  Result := Field('SubGroup');
end;

function TQueryCustomComponents.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryCustomComponents.InitParameterFields;
begin
  // ���� Producer (�������������)
  FParameterFields.Add(TParameterValues.ProducerParameterID, 'Producer');

  // ���� Package/Pins (������/���-�� �������)
  // FParameterFields.Add(TParameterValues.PackagePinsParameterID, 'PackagePins');

  // ���� Datasheet (����������� ������������)
  FParameterFields.Add(TParameterValues.DatasheetParameterID, 'Datasheet');

  // ���� Diagram (����������� �����)
  FParameterFields.Add(TParameterValues.DiagramParameterID, 'Diagram');

  // ���� Drawing (�����)
  FParameterFields.Add(TParameterValues.DrawingParameterID, 'Drawing');

  // ���� Image (�����������)
  FParameterFields.Add(TParameterValues.ImageParameterID, 'Image');

  // ���� Description (��������)
  FParameterFields.Add(TParameterValues.DescriptionParameterID, 'Description');
end;

procedure TQueryCustomComponents.ProcessParamValue(AIDComponent: Integer;
  AIDProductParameterValue: TField; const AValue: Variant;
  AIDParameter: Integer);
var
  i: Integer;
  k: Integer;
  rc: Integer;
begin
  Assert(AIDParameter > 0);

  // ���� �������� ������������� ��� ������ ����������
  rc := QuerySearchProductParameterValues.Search(AIDParameter, AIDComponent);

  // ���� ����� �������� ��������� ������
  if VarIsStr(AValue) and VarToStr(AValue).IsEmpty then
  begin
    // ������� ��� �������� ���������� ��������� ��������� � ����� �����������
    while not QuerySearchProductParameterValues.FDQuery.Eof do
      QuerySearchProductParameterValues.FDQuery.Delete;

    if AIDProductParameterValue <> nil then
      AIDProductParameterValue.Value := NULL;
  end
  else
  begin
    k := 1;
    // ������� �������� �� ����������
    if rc = 0 then // ���� ������ ������ �������� �� �����
    begin
      // ���� ���� ��������� ��������� ��������
      if VarIsArray(AValue) then
      begin
        for i := VarArrayLowBound(AValue, 1) to VarArrayHighBound(AValue, 1) do
        begin
          // ��������� ����� ��������
          QuerySearchProductParameterValues.AppendValue(AValue[i]);
        end;
        k := 1 + VarArrayHighBound(AValue, 1) - VarArrayLowBound(AValue, 1);
      end
      else
        // ��������� ����� ��������
        QuerySearchProductParameterValues.AppendValue(AValue);
    end
    else
    begin
      // ���� ���� ��������� ��������� ��������
      if VarIsArray(AValue) then
      begin
        for i := VarArrayLowBound(AValue, 1) to VarArrayHighBound(AValue, 1) do
        begin
          if QuerySearchProductParameterValues.FDQuery.Eof then
            // ��������� ����� ��������
            QuerySearchProductParameterValues.AppendValue(AValue[i])
          else
            // ���� ������ �������� �� ����� ������
            QuerySearchProductParameterValues.EditValue(AValue[i]);

          QuerySearchProductParameterValues.FDQuery.Next;
        end;
        k := 1 + VarArrayHighBound(AValue, 1) - VarArrayLowBound(AValue, 1);
      end
      else
      begin
        QuerySearchProductParameterValues.EditValue(AValue);
      end;

      // ������� "������" ������
      while QuerySearchProductParameterValues.FDQuery.RecordCount > k do
      begin
        QuerySearchProductParameterValues.FDQuery.Last;
        QuerySearchProductParameterValues.FDQuery.Delete;
      end;
    end;

    Assert(QuerySearchProductParameterValues.FDQuery.RecordCount = k);
    Assert(QuerySearchProductParameterValues.PKValue > 0);

    if AIDProductParameterValue <> nil then
      AIDProductParameterValue.Value :=
        QuerySearchProductParameterValues.PKValue;
  end;
end;

procedure TQueryCustomComponents.SetProducer(AIDComponent: Integer;
  const AProducer: String);
var
  OK: Boolean;
begin
  Assert(AIDComponent > 0);

  // ���� ������ ���������
  OK := LocateByPK(AIDComponent);
  Assert(OK);

  // ����������� ���
  TryEdit;
  Producer.AsString := AProducer;
  TryPost;
end;

procedure TQueryCustomComponents.SetPackagePins(AIDComponent: Integer;
  APackagePins: string);
var
  OK: Boolean;
begin
  Assert(AIDComponent > 0);

  // ���� ������ ���������
  OK := LocateByPK(AIDComponent);
  Assert(OK);

  // ����������� ���
  TryEdit;
  PackagePins.AsString := APackagePins;
  TryPost;
end;

procedure TQueryCustomComponents.UpdateParamValue(const AProductIDFieldName
  : string; ASender: TDataSet);
var
  ADatasheet: TField;
  ADiagram: TField;
  ADrawing: TField;
  AIDDatasheet: TField;
  AIDDiagram: TField;
  AIDDrawing: TField;
  AIDImage: TField;
  // AIDPackagePins: TField;
  AIDProducer: TField;
  AImage: TField;
  APackagePins: TField;
  AIDComponent: TField;
  AProducer: TField;
  i: Integer;
  L: TStringList;
  m: TArray<String>;
  S: string;
  VarArr: Variant;
begin
  Assert(not AProductIDFieldName.IsEmpty);
  Assert(ASender <> nil);
  AIDComponent := ASender.FieldByName(AProductIDFieldName);
  AIDProducer := ASender.FieldByName(IDProducer.FieldName);
  AProducer := ASender.FieldByName(Producer.FieldName);
  // AIDPackagePins := ASender.FieldByName(IDPackagePins.FieldName);
  APackagePins := ASender.FieldByName(PackagePins.FieldName);
  AIDDatasheet := ASender.FieldByName(IDDatasheet.FieldName);
  ADatasheet := ASender.FieldByName(Datasheet.FieldName);
  AIDDiagram := ASender.FieldByName(IDDiagram.FieldName);
  ADiagram := ASender.FieldByName(Diagram.FieldName);
  AIDDrawing := ASender.FieldByName(IDDrawing.FieldName);
  ADrawing := ASender.FieldByName(Drawing.FieldName);
  AIDImage := ASender.FieldByName(IDImage.FieldName);
  AImage := ASender.FieldByName(Image.FieldName);

  // ������������ �������������� ������ ��������
  if APackagePins.OldValue <> APackagePins.Value then
  begin
    if not VarIsNull(APackagePins.Value) then
    begin
      // ����������� ������� ������� �������
      S := DeleteDouble(VarToStr(APackagePins.Value), ',');
      // ����� ������� �� �����
      m := S.Split([',']);
      L := TStringList.Create;
      try
        for i := Low(m) to High(m) do
        begin
          if not m[i].IsEmpty then
            L.Add(m[i]);
        end;

        if L.Count > 0 then
        begin
          VarArr := VarArrayCreate([0, L.Count - 1], varVariant);
          try
            for i := 0 to l.Count - 1 do
              VarArr[i] := L[i];

            ProcessParamValue(AIDComponent.AsInteger, nil, VarArr,
              TParameterValues.PackagePinsParameterID);

          finally
            VarClear(VarArr);
          end;
        end
        else
          ProcessParamValue(AIDComponent.AsInteger, nil, '',
            TParameterValues.PackagePinsParameterID);

        APackagePins.Value := L.ToString;
      finally
        FreeAndNil(L);
      end;
    end
    else
      ProcessParamValue(AIDComponent.AsInteger, nil, '',
        TParameterValues.PackagePinsParameterID);
  end;

  // ������������ �������������
  ProcessParamValue(AIDComponent.AsInteger, AIDProducer, AProducer.AsString,
    TParameterValues.ProducerParameterID);

  {
    // ������������ ������
    ProcessParamValue(AIDComponent.AsInteger, AIDPackagePins,
    APackagePins.AsString, TParameterValues.PackagePinsParameterID);
  }
  // ������������ ������������
  ProcessParamValue(AIDComponent.AsInteger, AIDDatasheet, ADatasheet.AsString,
    TParameterValues.DatasheetParameterID);

  // ������������ ����������� �����
  ProcessParamValue(AIDComponent.AsInteger, AIDDiagram, ADiagram.AsString,
    TParameterValues.DiagramParameterID);

  // ������������ �����
  ProcessParamValue(AIDComponent.AsInteger, AIDDrawing, ADrawing.AsString,
    TParameterValues.DrawingParameterID);

  // ������������ �����������
  ProcessParamValue(AIDComponent.AsInteger, AIDImage, AImage.AsString,
    TParameterValues.ImageParameterID);
end;

end.
