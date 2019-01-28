unit SubParametersQuery2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, SubParametersExcelDataModule,
  System.StrUtils, OrderQuery, SubParametersInterface, DSWrap;

type
  TSubParametersW = class(TOrderW)
  private
    FChecked: TFieldWrap;
    FID: TFieldWrap;
    FIdParameter: TParamWrap;
    FIsDefault: TFieldWrap;
    FName: TFieldWrap;
    FProductCategoryId: TParamWrap;
    FTranslation: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property Checked: TFieldWrap read FChecked;
    property ID: TFieldWrap read FID;
    property IdParameter: TParamWrap read FIdParameter;
    property IsDefault: TFieldWrap read FIsDefault;
    property Name: TFieldWrap read FName;
    property ProductCategoryId: TParamWrap read FProductCategoryId;
    property Translation: TFieldWrap read FTranslation;
  end;

  TQuerySubParameters2 = class(TQueryOrder, ISubParameters)
  strict private
    function GetSubParameterID(const AName: string): Integer; stdcall;
  private
    FW: TSubParametersW;
    procedure DoAfterInsert(Sender: TObject);
    procedure DoBeforeCheckedOpen(Sender: TObject);
    function GetCheckedMode: Boolean;
    { Private declarations }
  protected
    function CreateDataSetWrap: TOrderW; override;
    procedure DoAfterCheckedOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedValues(const AFieldName: String): string;
    procedure LoadDataFromExcelTable(AExcelTable: TSubParametersExcelTable);
    procedure OpenWithChecked(AIDParameter, AProductCategoryId: Integer);
    function Search(const AName: String): Integer; overload;
    function SearchByID(AID: Integer; TestResult: Boolean = False)
      : Integer; overload;
    property CheckedMode: Boolean read GetCheckedMode;
    property W: TSubParametersW read FW;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, StrHelper, BaseQuery;

{$R *.dfm}

constructor TQuerySubParameters2.Create(AOwner: TComponent);
begin
  inherited;
  FW := OrderW as TSubParametersW;
  AutoTransaction := False;
  TNotifyEventWrap.Create(W.AfterInsert, DoAfterInsert, FEventList);
end;

function TQuerySubParameters2.CreateDataSetWrap: TOrderW;
begin
  Result := TSubParametersW.Create(FDQuery);
end;

procedure TQuerySubParameters2.DoAfterInsert(Sender: TObject);
begin
  W.IsDefault.F.AsInteger := W.IsDefault.DefaultValue;
end;

procedure TQuerySubParameters2.DoAfterCheckedOpen(Sender: TObject);
begin
  W.Checked.F.ReadOnly := False;
end;

procedure TQuerySubParameters2.DoBeforeCheckedOpen(Sender: TObject);
begin
  if FDQuery.FieldCount = 0 then
  begin
    // ��������� �������� �����
    FDQuery.FieldDefs.Update;
    // ������ ���� �� ���������
    CreateDefaultFields(False);
    W.Checked.F.FieldKind := fkInternalCalc;
  end;
end;

function TQuerySubParameters2.GetCheckedMode: Boolean;
begin
  Result := FDQuery.FindField('Checked') <> nil;
end;

function TQuerySubParameters2.GetCheckedValues(const AFieldName
  : String): string;
var
  AClone: TFDMemTable;
begin
  Assert(not AFieldName.IsEmpty);

  Result := '';
  AClone := AddClone(Format('%s = %d', [W.Checked.FieldName, 1]));
  try
    while not AClone.Eof do
    begin
      Result := Result + IfThen(Result.IsEmpty, '', ',') +
        AClone.FieldByName(AFieldName).AsString;
      AClone.Next;
    end;
  finally
    DropClone(AClone);
  end;
end;

function TQuerySubParameters2.GetSubParameterID(const AName: string): Integer;
var
  V: Variant;
begin
  Result := 0;
  V := FDQuery.LookupEx(W.Name.FullName, AName, PKFieldName,
    [lxoCaseInsensitive]);
  if not VarIsNull(V) then
    Result := V;
end;

procedure TQuerySubParameters2.LoadDataFromExcelTable
  (AExcelTable: TSubParametersExcelTable);
var
  AField: TField;
  I: Integer;
begin
  AExcelTable.DisableControls;
  try
    AExcelTable.First;
    AExcelTable.CallOnProcessEvent;
    while not AExcelTable.Eof do
    begin
      TryAppend;
      try
        for I := 0 to AExcelTable.FieldCount - 1 do
        begin
          AField := FDQuery.FindField(AExcelTable.Fields[I].FieldName);
          if AField <> nil then
          begin
            AField.Value := AExcelTable.Fields[I].Value;
          end;
        end;

        TryPost;
      except
        TryCancel;
        raise;
      end;

      AExcelTable.Next;
      AExcelTable.CallOnProcessEvent;
    end;
  finally
    AExcelTable.EnableControls;
  end;

end;

procedure TQuerySubParameters2.OpenWithChecked(AIDParameter, AProductCategoryId
  : Integer);
begin
  Assert(AIDParameter > 0);
  Assert(AProductCategoryId > 0);

  // ������ ������ � �������� �������
  FDQuery.SQL.Text := SQL.Replace('/* IFCHECKED', '/* IFCHECKED */');

  SetParamType(W.IdParameter.ParamName);
  SetParamType(W.ProductCategoryId.ParamName);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeCheckedOpen, FEventList);
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterCheckedOpen, W.EventList);

  // ��������� � ����� ����������� �������
  FDQuery.CachedUpdates := True;
  AutoTransaction := True;

  Load([W.IdParameter.ParamName, W.ProductCategoryId.ParamName],
    [AIDParameter, AProductCategoryId]);
end;

function TQuerySubParameters2.Search(const AName: String): Integer;
begin
  Assert(not AName.IsEmpty);

  Result := SearchEx([TParamRec.Create(W.Name.FullName, AName,
    ftWideString, True)]);
end;

function TQuerySubParameters2.SearchByID(AID: Integer;
  TestResult: Boolean = False): Integer;
begin
  Result := SearchEx([TParamRec.Create(W.ID.FullName, AID)],
    IfThen(TestResult, 1, -1));
end;

constructor TSubParametersW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'sp.ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FChecked := TFieldWrap.Create(Self, 'Checked');
  FIsDefault := TFieldWrap.Create(Self, 'IsDefault');
  FName := TFieldWrap.Create(Self, 'Name');
  FTranslation := TFieldWrap.Create(Self, 'Translation');

  FIsDefault.DefaultValue := 0;

  // ��������� SQL �������
  FIdParameter := TParamWrap.Create(Self, 'IdParameter');
  FProductCategoryId := TParamWrap.Create(Self, 'ProductCategoryId');
end;

end.
