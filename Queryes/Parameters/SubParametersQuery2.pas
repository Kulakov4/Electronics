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
  System.StrUtils, OrderQuery;

type
  TQuerySubParameters2 = class(TQueryOrder)
  private
    procedure DoAfterInsert(Sender: TObject);
    procedure DoBeforeCheckedOpen(Sender: TObject);
    function GetChecked: TField;
    function GetCheckedMode: Boolean;
    function GetIsDefault: TField;
    function GetName: TField;
    function GetTranslation: TField;
    { Private declarations }
  protected
    procedure DoAfterCheckedOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    function GetCheckedValues(const AFieldName: String): string;
    procedure LoadDataFromExcelTable(AExcelTable: TSubParametersExcelTable);
    procedure OpenWithChecked(AIDParameter, AProductCategoryId: Integer);
    function Search(const AName: String): Integer; overload;
    property Checked: TField read GetChecked;
    property CheckedMode: Boolean read GetCheckedMode;
    property IsDefault: TField read GetIsDefault;
    property Name: TField read GetName;
    property Translation: TField read GetTranslation;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents, StrHelper;

{$R *.dfm}

constructor TQuerySubParameters2.Create(AOwner: TComponent);
begin
  inherited;
  AutoTransaction := False;
  TNotifyEventWrap.Create(AfterInsert, DoAfterInsert, FEventList);
end;

procedure TQuerySubParameters2.DoAfterInsert(Sender: TObject);
begin
  IsDefault.AsInteger := 0;
end;

procedure TQuerySubParameters2.DoAfterCheckedOpen(Sender: TObject);
begin
  Checked.ReadOnly := False;
end;

procedure TQuerySubParameters2.DoBeforeCheckedOpen(Sender: TObject);
begin
  if FDQuery.FieldCount = 0 then
  begin
    // Обновляем описания полей
    FDQuery.FieldDefs.Update;
    // Создаём поля по умолчанию
    CreateDefaultFields(False);
    Checked.FieldKind := fkInternalCalc;
  end;
end;

function TQuerySubParameters2.GetChecked: TField;
begin
  Result := Field('Checked');
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
  AClone := AddClone(Format('%s = %d', [Checked.FieldName, 1]));
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

function TQuerySubParameters2.GetIsDefault: TField;
begin
  Result := Field('IsDefault');
end;

function TQuerySubParameters2.GetName: TField;
begin
  Result := Field('Name');
end;

function TQuerySubParameters2.GetTranslation: TField;
begin
  Result := Field('Translation');
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
  FDQuery.SQL.Text := FDQuery.SQL.Text.Replace('/* IFCHECKED',
    '/* IFCHECKED */');
  SetParamType('IdParameter');
  SetParamType('ProductCategoryId');
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeCheckedOpen, FEventList);
  TNotifyEventWrap.Create(AfterOpen, DoAfterCheckedOpen, FEventList);
  Load(['IdParameter', 'ProductCategoryId'],
    [AIDParameter, AProductCategoryId]);
end;

function TQuerySubParameters2.Search(const AName: String): Integer;
begin
  FDQuery.SQL.Text := Replace(FDQuery.SQL.Text,
    Format('and 0=0 and upper(Name) = upper(:Name)', [QuotedStr(AName)]),
    'and 0=0');

  SetParamType('Name', ptInput, ftString);

  Result := Search(['Name'], [AName]);
end;

end.
