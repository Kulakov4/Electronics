{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit ExtraChargeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ExtraChargeSimpleQuery,
  ExtraChargeExcelDataModule;

type
  TQueryExtraCharge = class(TQueryWithDataSource)
  private
    FqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetqExtraChargeSimple: TQueryExtraChargeSimple;
    function GetRange: TField;
    function GetWholeSale: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoBeforeOpen(Sender: TObject);
    property qExtraChargeSimple: TQueryExtraChargeSimple
      read GetqExtraChargeSimple;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteAll;
    procedure LoadDataFromExcelTable(AExcelTable: TExtraChargeExcelTable);
    function LocateByRange(ARange: string): Boolean;
    property Range: TField read GetRange;
    property WholeSale: TField read GetWholeSale;
    { Public declarations }
  end;

implementation

uses
  ProjectConst, NotifyEvents, ExceptionHelper;

{$R *.dfm}

constructor TQueryExtraCharge.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
end;

procedure TQueryExtraCharge.ApplyDelete(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  Assert(ASender = FDQuery);

  // Ищем удаляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  // Удаляем эту запись
  qExtraChargeSimple.FDQuery.Delete;
end;

procedure TQueryExtraCharge.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(0, Range.AsString,
    ALow, AHight);
  if not MyExceptionMessage.IsEmpty then
  begin
    // Потом будет создана исключительная ситуация
    AAction := eaFail;
    raise Exception.Create(MyExceptionMessage);
    // Exit;
  end;

  if not qExtraChargeSimple.FDQuery.Active then
    qExtraChargeSimple.SearchByID(0);

  // Добавляем запись
  qExtraChargeSimple.TryAppend;
  qExtraChargeSimple.L.AsInteger := ALow;
  qExtraChargeSimple.H.AsInteger := AHight;
  qExtraChargeSimple.WholeSale.Value := WholeSale.Value;
  qExtraChargeSimple.TryPost;

  Assert(qExtraChargeSimple.PK.AsInteger > 0);

  FetchFields([PKFieldName], [qExtraChargeSimple.PK.Value], ARequest, AAction,
    AOptions);
end;

procedure TQueryExtraCharge.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AHight: Integer;
  ALow: Integer;
begin
  Assert(ASender = FDQuery);
  MyExceptionMessage := qExtraChargeSimple.CheckBounds(PK.AsInteger,
    Range.AsString, ALow, AHight);
  if not MyExceptionMessage.IsEmpty then
  begin
    AAction := eaFail;
    // Потом будет создана исключительная ситуация
    raise Exception.Create(MyExceptionMessage);

    // Exit;
  end;

  // Ищем обновляемую запись
  qExtraChargeSimple.SearchByID(PK.AsInteger, 1);

  qExtraChargeSimple.TryEdit;
  qExtraChargeSimple.L.Value := ALow;
  qExtraChargeSimple.H.Value := AHight;
  qExtraChargeSimple.WholeSale.Value := WholeSale.Value;
  qExtraChargeSimple.TryPost;
end;

procedure TQueryExtraCharge.DeleteAll;
begin
  FDQuery.DisableControls;
  try
    while not FDQuery.Eof do
      FDQuery.Delete;
  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryExtraCharge.DoAfterOpen(Sender: TObject);
begin
  Range.ReadOnly := False;
end;

procedure TQueryExtraCharge.DoBeforeOpen(Sender: TObject);
begin
  if FDQuery.FieldDefs.Count > 0 then
  begin
    FDQuery.FieldDefs.Clear;
    FDQuery.Fields.Clear;
  end;

  FDQuery.FieldDefs.Update;
  FDQuery.FieldDefs.Find('Range').Size := 30;
  CreateDefaultFields(False);
end;

function TQueryExtraCharge.GetqExtraChargeSimple: TQueryExtraChargeSimple;
begin
  if FqExtraChargeSimple = nil then
    FqExtraChargeSimple := TQueryExtraChargeSimple.Create(Self);

  Result := FqExtraChargeSimple;
end;

function TQueryExtraCharge.GetRange: TField;
begin
  Result := Field('Range');
end;

function TQueryExtraCharge.GetWholeSale: TField;
begin
  Result := Field('WholeSale');
end;

procedure TQueryExtraCharge.LoadDataFromExcelTable
  (AExcelTable: TExtraChargeExcelTable);
begin
  // FDQuery.DisableControls;
  try
    AExcelTable.First;
    while not AExcelTable.Eof do
    begin
      // Если такой диапазон уже есть
      if LocateByRange(AExcelTable.Range.Value) then
        TryEdit
      else
        TryAppend;

      Range.Value := AExcelTable.Range.Value;
      WholeSale.Value := AExcelTable.WholeSale.Value;
      TryPost;

      AExcelTable.Next;
    end;
  finally
    // FDQuery.EnableControls;
  end;
end;

function TQueryExtraCharge.LocateByRange(ARange: string): Boolean;
begin
  Result := FDQuery.LocateEx(Range.FieldName, ARange, []);
end;

end.
