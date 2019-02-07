unit CustomComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, NotifyEvents,
  SearchComponentCategoryQuery, SearchProductParameterValuesQuery,
  System.Generics.Collections, DBRecordHolder, DSWrap,
  DescriptionsQueryWrap, BaseEventsQuery;

type
  TCustomComponentsW = class(TDescriptionW)
  private
    FDatasheet: TFieldWrap;
    FDiagram: TFieldWrap;
    FDrawing: TFieldWrap;
    FID: TFieldWrap;
    FIDDatasheet: TFieldWrap;
    FIDDiagram: TFieldWrap;
    FIDDrawing: TFieldWrap;
    FIDImage: TFieldWrap;
    FIDProducer: TFieldWrap;
    FImage: TFieldWrap;
    FPackagePins: TFieldWrap;
    FParentProductID: TFieldWrap;
    FProducer: TFieldWrap;
    FqSearchProductParameterValues: TQuerySearchProductParameterValues;
    FSubGroup: TFieldWrap;
    FValue: TFieldWrap;
    function GetqSearchProductParameterValues
      : TQuerySearchProductParameterValues;
  protected
    procedure ProcessParamValue(AIDComponent: Integer;
      AIDProductParameterValue: TField; const AValue: Variant;
      AParamSubParamID: Integer);
    property qSearchProductParameterValues: TQuerySearchProductParameterValues
      read GetqSearchProductParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetPackagePins(AIDComponent: Integer; APackagePins: string);
    procedure SetProducer(AIDComponent: Integer; const AProducer: String);
    procedure UpdateParamValue(const AProductIDFieldName: string);
    property Datasheet: TFieldWrap read FDatasheet;
    property Diagram: TFieldWrap read FDiagram;
    property Drawing: TFieldWrap read FDrawing;
    property ID: TFieldWrap read FID;
    property IDDatasheet: TFieldWrap read FIDDatasheet;
    property IDDiagram: TFieldWrap read FIDDiagram;
    property IDDrawing: TFieldWrap read FIDDrawing;
    property IDImage: TFieldWrap read FIDImage;
    property IDProducer: TFieldWrap read FIDProducer;
    property Image: TFieldWrap read FImage;
    property PackagePins: TFieldWrap read FPackagePins;
    property ParentProductID: TFieldWrap read FParentProductID;
    property Producer: TFieldWrap read FProducer;
    property SubGroup: TFieldWrap read FSubGroup;
    property Value: TFieldWrap read FValue;
  end;

  TQueryCustomComponents = class(TQueryBaseEvents)
    qProducts: TfrmApplyQuery;
  private
    FParameterFields: TDictionary<Integer, String>;
    FSaveValuesAfterEdit: Boolean;
    FW: TCustomComponentsW;
    procedure DoAfterConnect(Sender: TObject);
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterEdit(Sender: TObject);
    { Private declarations }
  protected
    FRecordHolder: TRecordHolder;
    function CreateDSWrap: TDSWrap; override;
    procedure InitParameterFields; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CombineSubgroup(const ASubGroup1, ASubGroup2: String): String;
    property ParameterFields: TDictionary<Integer, String>
      read FParameterFields;
    property RecordHolder: TRecordHolder read FRecordHolder;
    property SaveValuesAfterEdit: Boolean read FSaveValuesAfterEdit
      write FSaveValuesAfterEdit;
    property W: TCustomComponentsW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, ProjectConst, DefaultParameters, StrHelper;

constructor TQueryCustomComponents.Create(AOwner: TComponent);
begin
  inherited;

  FW := FDSWrap as TCustomComponentsW;

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

  // �� ��������� ������������� ���������� ����� �� �������
  FDQuery.UpdateOptions.CheckRequired := False;

  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);

  // ����� ���� ��������� �����������
  AutoTransaction := False;

  // ����� ���� ��������� ������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;

  // ���� ����, ����� ���������� �������� ����� �����������
  TNotifyEventWrap.Create(W.AfterEdit, DoAfterEdit, W.EventList);
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

function TQueryCustomComponents.CreateDSWrap: TDSWrap;
begin
  Result := TCustomComponentsW.Create(FDQuery);
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
    F := W.Field(AFieldName);
    Assert(F <> nil);
  end;
end;

procedure TQueryCustomComponents.DoAfterEdit(Sender: TObject);
begin
  if (FRecordHolder <> nil) and (FSaveValuesAfterEdit) then
    FRecordHolder.Attach(FDQuery);
end;

procedure TQueryCustomComponents.InitParameterFields;
begin
  if FParameterFields.Count > 0 then
    Exit;

  // ���� Producer (�������������)
  FParameterFields.Add(TDefaultParameters.ProducerParamSubParamID, 'Producer');

  // ���� Package/Pins (������/���-�� �������)
  // FParameterFields.Add(TDefaultParameters.PackagePinsParameterID, 'PackagePins');

  // ���� Datasheet (����������� ������������)
  FParameterFields.Add(TDefaultParameters.DatasheetParamSubParamID,
    'Datasheet');

  // ���� Diagram (����������� �����)
  FParameterFields.Add(TDefaultParameters.DiagramParamSubParamID, 'Diagram');

  // ���� Drawing (�����)
  FParameterFields.Add(TDefaultParameters.DrawingParamSubParamID, 'Drawing');

  // ���� Image (�����������)
  FParameterFields.Add(TDefaultParameters.ImageParamSubParamID, 'Image');

  // ���� Description (��������)
  FParameterFields.Add(TDefaultParameters.DescriptionParamSubParamID,
    'DescriptionComponentName');
end;

constructor TCustomComponentsW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FDatasheet := TFieldWrap.Create(Self, 'Datasheet');
  FDiagram := TFieldWrap.Create(Self, 'Diagram');
  FDrawing := TFieldWrap.Create(Self, 'Drawing');
  FIDDatasheet := TFieldWrap.Create(Self, 'IDDatasheet');
  FIDDiagram := TFieldWrap.Create(Self, 'IDDiagram');
  FIDDrawing := TFieldWrap.Create(Self, 'IDDrawing');
  FIDImage := TFieldWrap.Create(Self, 'IDImage');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
  FImage := TFieldWrap.Create(Self, 'Image');
  FPackagePins := TFieldWrap.Create(Self, 'PackagePins');
  FParentProductID := TFieldWrap.Create(Self, 'ParentProductID');
  FProducer := TFieldWrap.Create(Self, 'Producer');
  FSubGroup := TFieldWrap.Create(Self, 'SubGroup');
  FValue := TFieldWrap.Create(Self, 'Value');
end;

function TCustomComponentsW.GetqSearchProductParameterValues
  : TQuerySearchProductParameterValues;
begin
  if FqSearchProductParameterValues = nil then
  begin
    FqSearchProductParameterValues :=
      TQuerySearchProductParameterValues.Create(Self);
  end;
  Result := FqSearchProductParameterValues;
end;

procedure TCustomComponentsW.ProcessParamValue(AIDComponent: Integer;
  AIDProductParameterValue: TField; const AValue: Variant;
  AParamSubParamID: Integer);
var
  i: Integer;
  k: Integer;
  rc: Integer;
begin
  Assert(AParamSubParamID > 0);

  // ���� �������� ������������� ��� ������ ����������
  rc := qSearchProductParameterValues.Search(AParamSubParamID, AIDComponent);

  // ���� ����� �������� ��������� ������
  if VarIsStr(AValue) and VarToStr(AValue).IsEmpty then
  begin
    // ������� ��� �������� ���������� ��������� ��������� � ����� �����������
    while not qSearchProductParameterValues.FDQuery.Eof do
      qSearchProductParameterValues.FDQuery.Delete;

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
          qSearchProductParameterValues.AppendValue(AValue[i]);
        end;
        k := 1 + VarArrayHighBound(AValue, 1) - VarArrayLowBound(AValue, 1);
      end
      else
        // ��������� ����� ��������
        qSearchProductParameterValues.AppendValue(AValue);
    end
    else
    begin
      // ���� ���� ��������� ��������� ��������
      if VarIsArray(AValue) then
      begin
        for i := VarArrayLowBound(AValue, 1) to VarArrayHighBound(AValue, 1) do
        begin
          if qSearchProductParameterValues.FDQuery.Eof then
            // ��������� ����� ��������
            qSearchProductParameterValues.AppendValue(AValue[i])
          else
            // ���� ������ �������� �� ����� ������
            qSearchProductParameterValues.W.EditValue(AValue[i]);

          qSearchProductParameterValues.FDQuery.Next;
        end;
        k := 1 + VarArrayHighBound(AValue, 1) - VarArrayLowBound(AValue, 1);
      end
      else
      begin
        qSearchProductParameterValues.W.EditValue(AValue);
      end;

      // ������� "������" ������
      while qSearchProductParameterValues.FDQuery.RecordCount > k do
      begin
        qSearchProductParameterValues.FDQuery.Last;
        qSearchProductParameterValues.FDQuery.Delete;
      end;
    end;

    Assert(qSearchProductParameterValues.FDQuery.RecordCount = k);
    Assert(qSearchProductParameterValues.PK.AsInteger > 0);

    if AIDProductParameterValue <> nil then
      AIDProductParameterValue.Value := qSearchProductParameterValues.PK.Value;
  end;
end;

procedure TCustomComponentsW.SetPackagePins(AIDComponent: Integer;
  APackagePins: string);
begin
  Assert(AIDComponent > 0);

  // ���� ������ ���������
  LocateByPK(AIDComponent, True);

  // ����������� ���
  TryEdit;
  PackagePins.F.AsString := APackagePins;
  TryPost;
end;

procedure TCustomComponentsW.SetProducer(AIDComponent: Integer;
  const AProducer: String);
begin
  Assert(AIDComponent > 0);

  // ���� ������ ���������
  LocateByPK(AIDComponent, True);

  // ����������� ���
  TryEdit;
  Producer.F.AsString := AProducer;
  TryPost;
end;

procedure TCustomComponentsW.UpdateParamValue(const AProductIDFieldName
  : string);
var
  AIDComponent: TField;
  i: Integer;
  L: TStringList;
  VarArr: Variant;
begin
  Assert(not AProductIDFieldName.IsEmpty);
  AIDComponent := Field(AProductIDFieldName);

  // ������������ �������������� ������ ��������
  if PackagePins.F.OldValue <> PackagePins.F.Value then
  begin
    if not VarIsNull(PackagePins.F.Value) then
    begin
      L := TStringList.Create;
      try
        // ����������� � ������ ��������
        L.Delimiter := ',';
        L.StrictDelimiter := True;
        L.DelimitedText := PackagePins.F.AsString.Trim;
        // ������� ������ ������
        for i := L.Count - 1 downto 0 do
          if L[i].Trim.IsEmpty then
            L.Delete(i)
          else
            L[i] := L[i].Trim;

        // ���� �������� �� ������ ������
        if L.Count > 0 then
        begin
          VarArr := VarArrayCreate([0, L.Count - 1], varVariant);
          try
            for i := 0 to L.Count - 1 do
              VarArr[i] := L[i];

            ProcessParamValue(AIDComponent.AsInteger, nil, VarArr,
              TDefaultParameters.PackagePinsParamSubParamID);

          finally
            VarClear(VarArr);
          end;
        end
        else
          ProcessParamValue(AIDComponent.AsInteger, nil, '',
            TDefaultParameters.PackagePinsParamSubParamID);

        PackagePins.F.Value := L.DelimitedText;
      finally
        FreeAndNil(L);
      end;
    end
    else
      ProcessParamValue(AIDComponent.AsInteger, nil, '',
        TDefaultParameters.PackagePinsParamSubParamID);
  end;

  // ������������ �������������
  ProcessParamValue(AIDComponent.AsInteger, IDProducer.F, Producer.F.AsString,
    TDefaultParameters.ProducerParamSubParamID);

  {
    // ������������ ������
    ProcessParamValue(AIDComponent.AsInteger, AIDPackagePins,
    APackagePins.AsString, TDefaultParameters.PackagePinsParameterID);
  }
  // ������������ ������������
  ProcessParamValue(AIDComponent.AsInteger, IDDatasheet.F, Datasheet.F.AsString,
    TDefaultParameters.DatasheetParamSubParamID);

  // ������������ ����������� �����
  ProcessParamValue(AIDComponent.AsInteger, IDDiagram.F, Diagram.F.AsString,
    TDefaultParameters.DiagramParamSubParamID);

  // ������������ �����
  ProcessParamValue(AIDComponent.AsInteger, IDDrawing.F, Drawing.F.AsString,
    TDefaultParameters.DrawingParamSubParamID);

  // ������������ �����������
  ProcessParamValue(AIDComponent.AsInteger, IDImage.F, Image.F.AsString,
    TDefaultParameters.ImageParamSubParamID);
end;

end.
