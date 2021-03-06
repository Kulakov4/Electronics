unit DescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, DescriptionsInterface, RecordCheck, DSWrap,
  BaseEventsQuery;

type
  TDescrW = class(TDSWrap)
  private
    FComponentName: TFieldWrap;
    FDescription: TFieldWrap;
    FIDComponentType: TFieldWrap;
    FIDProducer: TFieldWrap;
    FID: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TFieldWrap read FComponentName;
    property Description: TFieldWrap read FDescription;
    property IDComponentType: TFieldWrap read FIDComponentType;
    property IDProducer: TFieldWrap read FIDProducer;
    property ID: TFieldWrap read FID;
  end;

  TQueryDescriptions = class(TQueryBaseEvents, IDescriptions)
    FDQueryID: TFDAutoIncField;
    FDQueryComponentName: TWideStringField;
    FDQueryDescription: TWideMemoField;
    FDQueryIDComponentType: TIntegerField;
    FDQueryIDProducer: TIntegerField;
  strict private
    function Check(const AComponentName, ADescription: String;
      AProducerID: Integer): TRecordCheck; stdcall;
  private
    FCheckClone: TFDMemTable;
    FFilterText: string;
    FShowDuplicate: Boolean;
    FW: TDescrW;
    procedure ApplyFilter(AShowDuplicate: Boolean; const AFilterText: string);
    function GetCheckClone: TFDMemTable;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    property CheckClone: TFDMemTable read GetCheckClone;
  public
    constructor Create(AOwner: TComponent); override;
    function TryApplyFilter(AShowDuplicate: Boolean; const AFilterText: string):
        Boolean;
    property FilterText: string read FFilterText;
    property ShowDuplicate: Boolean read FShowDuplicate;
    property W: TDescrW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule, NotifyEvents, StrHelper, ErrorType;

constructor TQueryDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TDescrW;

  AutoTransaction := False;
end;

procedure TQueryDescriptions.ApplyFilter(AShowDuplicate: Boolean; const
    AFilterText: string);
var
  ASQL: String;
begin

  // �������� �������������� ������
  ASQL := SQL;

  // ���� ����� �������� ���������
  if AShowDuplicate then
  begin
    ASQL := ASQL.Replace('/* ShowDuplicate', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('ShowDuplicate */', '', [rfReplaceAll]);
  end;

  // ���� ����� �������� ������������� �� �������� ����������
  if not AFilterText.IsEmpty then
  begin
    ASQL := ASQL.Replace('/* Filter', '', [rfReplaceAll]);
    ASQL := ASQL.Replace('Filter */', '', [rfReplaceAll]);
  end;

  FDQuery.Close;
  FDQuery.SQL.Text := ASQL;

  if not AFilterText.IsEmpty then
  begin
    SetParamType(W.ComponentName.FieldName, ptInput, ftWideString);
    SetParameters([W.ComponentName.FieldName], [AFilterText + '%']);
  end;

  FDQuery.Open;
end;

function TQueryDescriptions.Check(const AComponentName, ADescription: String;
  AProducerID: Integer): TRecordCheck;
begin
  Result.ErrorType := etNone;

  // ���� ���������
  if not CheckClone.LocateEx(W.ComponentName.FieldName, AComponentName,
    [lxoCaseInsensitive]) then
    Exit;

  // ���������� ��������
  if W.Description.F.AsString = ADescription then
  begin
    Result.ErrorType := etError;
    Result.Description := '����� �������� ��� ���� � �����������';
  end
  else
  begin
    Result.ErrorType := etWarring;
    Result.Description :=
      '��������� � ����� ������������� ����� ������ �������� � �����������';
  end;
end;

function TQueryDescriptions.CreateDSWrap: TDSWrap;
begin
  Result := TDescrW.Create(FDQuery);
end;

function TQueryDescriptions.GetCheckClone: TFDMemTable;
begin
  if FCheckClone = nil then
    FCheckClone := W.AddClone('');

  Result := FCheckClone;
end;

function TQueryDescriptions.TryApplyFilter(AShowDuplicate: Boolean; const
    AFilterText: string): Boolean;
begin
  Result := FDQuery.RecordCount > 0;

  if (AShowDuplicate = FShowDuplicate) and (AFilterText = FFilterText) then
    Exit;

  ApplyFilter(AShowDuplicate, AFilterText);

  Result := FDQuery.RecordCount > 0;

  if Result then
  begin
    FShowDuplicate := AShowDuplicate;
    FFilterText := AFilterText;
  end
  else
    // ���������� ������ ��������
    ApplyFilter(FShowDuplicate, FFilterText);
end;

constructor TDescrW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FComponentName := TFieldWrap.Create(Self, 'ComponentName');
  FDescription := TFieldWrap.Create(Self, 'Description');
  FIDComponentType := TFieldWrap.Create(Self, 'IDComponentType');
  FIDProducer := TFieldWrap.Create(Self, 'IDProducer');
end;

end.
