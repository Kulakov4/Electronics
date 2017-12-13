unit ComponentsExGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, FamilyExQuery,
  ParametersForCategoryQuery, ProductParametersQuery, Data.DB,
  FireDAC.Stan.Option, FireDAC.Comp.DataSet, CustomComponentsQuery,
  System.Contnrs, System.Generics.Collections, QueryWithDataSourceUnit,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, FamilyQuery, BaseFamilyQuery,
  BaseComponentsQuery, ComponentsQuery, ComponentsExQuery,
  BaseComponentsGroupUnit, NotifyEvents;

type
  TComponentsExGroup = class(TBaseComponentsGroup)
    qFamilyEx: TQueryFamilyEx;
    qComponentsEx: TQueryComponentsEx;
    procedure OnFDQueryUpdateRecord(ASender: TDataSet;
      ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
      AOptions: TFDUpdateRowOptions);
  private
    FApplyUpdateEvents: TObjectList;
    FClientCount: Integer;
    FMark: string;
    FAllParameterFields: TDictionary<Integer, String>;
    FOnParamOrderChange: TNotifyEventsEx;
    FQueryParametersForCategory: TQueryParametersForCategory;
    FQueryProductParameters: TQueryProductParameters;

  const
    FFieldPrefix: string = 'Field';
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    procedure DoOnApplyUpdate(Sender: TObject);
    function GetFieldName(AIDParameter: Integer): String;
    { Private declarations }
  protected
    // TODO: ClearUpdateCount
    procedure LoadParameterValues;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddClient;
    procedure DecClient;
    function GetIDParameter(const AFieldName: String): Integer;
    procedure TryRefresh;
    procedure UpdateData;
    property Mark: string read FMark;
    property AllParameterFields: TDictionary<Integer, String>
      read FAllParameterFields;
    property OnParamOrderChange: TNotifyEventsEx read FOnParamOrderChange;
    property QueryParametersForCategory: TQueryParametersForCategory
      read FQueryParametersForCategory;
    property QueryProductParameters: TQueryProductParameters
      read FQueryProductParameters;
    { Public declarations }
  end;

implementation

uses FireDAC.Stan.Param;

{$R *.dfm}
{ TfrmComponentsMasterDetail }

constructor TComponentsExGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAllParameterFields := TDictionary<Integer, String>.Create();

  FApplyUpdateEvents := TObjectList.Create;

  FMark := '!';

  FQueryParametersForCategory := TQueryParametersForCategory.Create(Self);
  FQueryProductParameters := TQueryProductParameters.Create(Self);

  Main := qFamilyEx;
  Detail := qComponentsEx;

  TNotifyEventWrap.Create(qFamilyEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qComponentsEx.BeforeOpen, DoBeforeOpen);
  TNotifyEventWrap.Create(qFamilyEx.AfterOpen, DoAfterOpen);

  FClientCount := 1;
  DecClient; // ������������ ��������� ����������

  FOnParamOrderChange := TNotifyEventsEx.Create(Self);
end;

destructor TComponentsExGroup.Destroy;
begin
  FreeAndNil(FAllParameterFields);
  FreeAndNil(FApplyUpdateEvents);
  inherited;
end;

procedure TComponentsExGroup.AddClient;
begin
  Inc(FClientCount);

  // ���� ����� �������������� ��������
  if (FClientCount > 0) then
  begin
    // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
    qComponentsEx.Lock := False;
    qFamilyEx.Lock := False;
  end;

end;

procedure TComponentsExGroup.DecClient;
begin
  Dec(FClientCount);
  Assert(FClientCount >= 0);

  if FClientCount = 0 then
  begin
    qComponentsEx.Lock := True;
    qFamilyEx.Lock := True;
  end;
end;

procedure TComponentsExGroup.DoAfterOpen(Sender: TObject);
begin
  LoadParameterValues;
end;

procedure TComponentsExGroup.DoBeforeOpen(Sender: TObject);
var
  AData: TQueryCustomComponents;
  AFDQuery: TFDQuery;
  AFieldName: String;
  AFieldType: TFieldType;
  ASize: Integer;
begin
  // ������� ������� ����������
  FAllParameterFields.Clear;

  AData := Sender as TQueryCustomComponents;
  AFDQuery := AData.FDQuery;
  AFDQuery.Fields.Clear;
  AFDQuery.FieldDefs.Clear;

  AFDQuery.FieldDefs.Update;

  // � ������ ���������� ����� ��������� ��������� (�������, ���������)
  QueryParametersForCategory.FDQuery.Close;
  QueryParametersForCategory.Load(AData.ParentValue);

  QueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
    if not AData.ParameterFields.ContainsKey
      (FQueryParametersForCategory.ParameterID.AsInteger) then
    begin
      ASize := 0;
      // AFieldType := ftInteger;

      case QueryParametersForCategory.FieldType.AsInteger of
        // ����� �����
        1:
          AFieldType := ftInteger;
        2: // ������
          begin
            AFieldType := ftWideString;
            ASize := 200;
          end;
        // ������� �����
        3:
          AFieldType := ftFloat;
        // ������ ��������
        4:
          AFieldType := ftBoolean;
        // ���� � �����
        5:
          AFieldType := ftDateTime;
      else
        AFieldType := ftWideString;
        ASize := 200;
      end;

      AFieldName := GetFieldName
        (FQueryParametersForCategory.ParameterID.AsInteger);
      // ��������� ��������� ����
      AFDQuery.FieldDefs.Add(AFieldName, AFieldType, ASize);
      FAllParameterFields.Add(FQueryParametersForCategory.ParameterID.AsInteger,
        AFieldName);
    end
    else
      FAllParameterFields.Add(FQueryParametersForCategory.ParameterID.AsInteger,
        AData.ParameterFields[FQueryParametersForCategory.ParameterID.
        AsInteger]);

    FQueryParametersForCategory.FDQuery.Next;
  end;

  AData.CreateDefaultFields(False);

  FQueryParametersForCategory.FDQuery.First;
  while not FQueryParametersForCategory.FDQuery.Eof do
  begin
    if not AData.ParameterFields.ContainsKey
      (FQueryParametersForCategory.ParameterID.AsInteger) then
    begin
      AFieldName := GetFieldName
        (FQueryParametersForCategory.ParameterID.AsInteger);
      AFDQuery.FieldByName(AFieldName).FieldKind := fkInternalCalc;
    end;
    FQueryParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.DoOnApplyUpdate(Sender: TObject);
var
  ADataSet: TDataSet;
  AField: TField;
  AFieldName: String;
  AMark: Char;
  AValue: string;
  k: Integer;
  m: TArray<String>;
  S: string;
begin
  ADataSet := Sender as TDataSet;

  // ���� �� ���� ����������� �����
  QueryParametersForCategory.FDQuery.First;
  while not QueryParametersForCategory.FDQuery.Eof do
  begin
    AFieldName := AllParameterFields
      [FQueryParametersForCategory.ParameterID.AsInteger];
    AField := ADataSet.FieldByName(AFieldName);

    if AField.OldValue <> AField.Value then
    begin
      // ��������� �������� ����������
      FQueryProductParameters.FDQuery.Filter :=
        Format('(ProductID=%d) and (ParameterID=%d)',
        [ADataSet.FieldByName('ID').AsInteger,
        FQueryParametersForCategory.ParameterID.AsInteger]);
      FQueryProductParameters.FDQuery.Filtered := True;
      FQueryProductParameters.FDQuery.First;

      S := AField.AsString;
      m := S.Split([#13]);
      k := 0;
      for S in m do
      begin
        AMark := FMark.Chars[0];
        AValue := S.Trim([AMark, #13, #10]);
        if not AValue.IsEmpty then
        begin
          Inc(k);
          if not(FQueryProductParameters.FDQuery.Eof) then
            FQueryProductParameters.FDQuery.Edit
          else
          begin
            FQueryProductParameters.FDQuery.Append;
            FQueryProductParameters.ParameterID.AsInteger :=
              FQueryParametersForCategory.ParameterID.AsInteger;
            FQueryProductParameters.ProductID.AsInteger :=
              ADataSet.FieldByName('ID').AsInteger;
          end;

          FQueryProductParameters.Value.AsString := AValue;
          FQueryProductParameters.TryPost;
          FQueryProductParameters.FDQuery.Next;
        end;
      end;

      // ������� "������" ��������
      while FQueryProductParameters.FDQuery.RecordCount > k do
      begin
        FQueryProductParameters.FDQuery.Last;
        FQueryProductParameters.FDQuery.Delete;
      end;
      FQueryProductParameters.FDQuery.Filtered := False;
    end;
    // ��������� � ���������� ���������
    QueryParametersForCategory.FDQuery.Next;
  end;
end;

procedure TComponentsExGroup.OnFDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  AAction := eaApplied;
end;

function TComponentsExGroup.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TComponentsExGroup.GetIDParameter(const AFieldName: String): Integer;
var
  S: string;
begin
  S := AFieldName.Remove(0, FFieldPrefix.Length);
  Result := S.ToInteger();
end;

procedure TComponentsExGroup.LoadParameterValues;
var
  AField: TField;
  qryComponents: TQueryCustomComponents;
  AFieldName: String;
  ANewValue: string;
  AValue: string;
  OK: Boolean;
  S: string;
begin
  // �� ����� �������� ������ ��������� �� �����
  FApplyUpdateEvents.Clear;

  // ��������� �������� ���������� �� �� �������������
  FQueryProductParameters.Load(qFamilyEx.ParentValue, True);

  qFamilyEx.FDQuery.DisableControls;
  qComponentsEx.FDQuery.DisableControls;
  try
    FQueryProductParameters.FDQuery.First;
    while not FQueryProductParameters.FDQuery.Eof do
    begin

      if FQueryProductParameters.ParentProductID.IsNull then
        qryComponents := qFamilyEx
      else
        qryComponents := qComponentsEx;

      OK := qryComponents.LocateByPK(FQueryProductParameters.ProductID.Value);
      Assert(OK);

      // ���� ��� ������ ��������� � SQL ������� ���� �� ����������
      if not qryComponents.ParameterFields.ContainsKey
        (FQueryParametersForCategory.ParameterID.AsInteger) then
      begin
        AFieldName := GetFieldName
          (FQueryProductParameters.ParameterID.AsInteger);
        S := FQueryProductParameters.Value.AsString.Trim;
        if not S.IsEmpty then
        begin
          // �������� ������ ��������� � ����� ��������� ��� ���
          AField := qryComponents.FDQuery.FindField(AFieldName);
          // ���� ����� �������� � ����� ��������� ����
          if AField <> nil then
          begin
            // ��������� ������������, ����� ����� ����� ���� �����������
            ANewValue := Format('%s%s%s',
              [FMark, FQueryProductParameters.Value.AsString.Trim, FMark]);

            AValue := AField.AsString.Trim;
            if AValue <> '' then
              AValue := AValue + #13#10;
            AValue := AValue + ANewValue;

            qryComponents.TryEdit;
            AField.AsString := AValue;
            qryComponents.TryPost;
          end;
        end;
      end;
      FQueryProductParameters.FDQuery.Next;
    end;
  finally
    qComponentsEx.FDQuery.EnableControls;
    qFamilyEx.FDQuery.EnableControls;
  end;

  // ������������� �� �������, ����� ���������
  TNotifyEventWrap.Create(qFamilyEx.On_ApplyUpdate, DoOnApplyUpdate,
    FApplyUpdateEvents);
  TNotifyEventWrap.Create(qComponentsEx.On_ApplyUpdate, DoOnApplyUpdate);
  // ��������� ����������
  Connection.Commit;
end;

procedure TComponentsExGroup.TryRefresh;
begin
  // ��������� ���� ��� �� �������������
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

procedure TComponentsExGroup.UpdateData;
begin
  QueryParametersForCategory.FDQuery.Params.ParamByName
    (QueryParametersForCategory.DetailParameterName).AsInteger := 0;
  QueryProductParameters.FDQuery.Params.ParamByName
    (QueryProductParameters.DetailParameterName).AsInteger := 0;
  // ������� ����� ��������, �� ������ � ��� �� ���������
  qComponentsEx.TryRefresh;
  qFamilyEx.TryRefresh;
end;

end.
