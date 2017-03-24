unit RecursiveTreeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, TreeExcelDataModule;

type
  TQueryRecursiveTree = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    procedure DoAfterOpen(Sender: TObject);
    function GetExternalID: TField;
    function GetMarkAsDeleted: TField;
    function GetParentExternalID: TField;
    function GetParentID: TField;
    function GetValue: TField;
    procedure MarkAllAsDeleted;
    function NewExternalID(AExternalID: Variant): Variant;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteAll;
    procedure HideNotDeleted;
    procedure LoadRecords(ATreeExcelTable: TTreeExcelTable);
    function LocateByExternalID(AParentExternalID: Variant; const AExternalID:
        string): Boolean; overload;
    function LocateByExternalID(const AExternalID: string): Boolean; overload;
    function LocateByValue(AParentExternalID: Variant; const AValue: string):
        Boolean;
    property ExternalID: TField read GetExternalID;
    property MarkAsDeleted: TField read GetMarkAsDeleted;
    property ParentExternalID: TField read GetParentExternalID;
    property ParentID: TField read GetParentID;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryRecursiveTree.Create(AOwner: TComponent);
begin
  inherited;
  TNotifyEventWrap.Create( AfterOpen, DoAfterOpen, FEventList );
end;

procedure TQueryRecursiveTree.DeleteAll;
begin
  Assert(FDQuery.Active);
  if FDQuery.RecordCount = 0 then
    Exit;

  FDQuery.First;
  // ������ ������ - ��� ������ ����� ������
  Assert(ParentExternalID.IsNull);
  // ��� �������� ����� �� ������� �������� �������� � �������� �����
  FDQuery.Delete;
  RefreshQuery;
  Assert(FDQuery.RecordCount = 0);
end;

procedure TQueryRecursiveTree.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  MarkAsDeleted.ReadOnly := False;
end;

function TQueryRecursiveTree.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryRecursiveTree.GetMarkAsDeleted: TField;
begin
  Result := Field('MarkAsDeleted');
end;

function TQueryRecursiveTree.GetParentExternalID: TField;
begin
  Result := Field('ParentExternalID');
end;

function TQueryRecursiveTree.GetParentID: TField;
begin
  Result := Field('ParentID');
end;

function TQueryRecursiveTree.GetValue: TField;
begin
  Result := Field('Value');
end;

procedure TQueryRecursiveTree.HideNotDeleted;
begin
  FDQuery.Filter := Format('%s = 1', [MarkAsDeleted.FieldName]);
  FDQuery.Filtered := True;
end;

procedure TQueryRecursiveTree.LoadRecords(ATreeExcelTable: TTreeExcelTable);
var
  ANewExternalID: string;
  AParentID: Integer;
  OK: Boolean;
begin
//  DeleteAll;

  FDQuery.DisableControls;
  try
    // �������� ��� ���� �� ��������
    MarkAllAsDeleted;

    ATreeExcelTable.First;
    ATreeExcelTable.CallOnProcessEvent;

    while not ATreeExcelTable.Eof do
    begin

      // ���� ��� �������� ������
      if ATreeExcelTable.ParentExternalID.IsNull then
      begin
        if not LocateByExternalID(NULL, ATreeExcelTable.ExternalID.AsString) then
        begin
          TryAppend;
          ExternalID.AsString := ATreeExcelTable.ExternalID.AsString;
        end
        else
          TryEdit;
      end
      else
      begin
        // ���� �������� ������
        if not LocateByExternalID(ATreeExcelTable.ParentExternalID.Value, ATreeExcelTable.ExternalID.AsString) then
        begin
          // ���� ������������ ������ �� �������� ��������������
          OK := LocateByExternalID(ATreeExcelTable.ParentExternalID.AsString);
          Assert(OK);
          AParentID := PKValue;

          TryAppend;
          ExternalID.AsString := ATreeExcelTable.ExternalID.AsString;
          ParentID.AsInteger := AParentID;
        end
        else
          TryEdit;

      end;

        // ��������� ������������
        Value.AsString := ATreeExcelTable.Value.AsString;
        // ��������, ��� ��� ������ �� ����� �������
        MarkAsDeleted.AsInteger := 0;
        TryPost;

      ATreeExcelTable.Next;
      ATreeExcelTable.CallOnProcessEvent;
    end;

  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryRecursiveTree.LocateByExternalID(AParentExternalID: Variant;
    const AExternalID: string): Boolean;
var
  AKeyFields: string;
begin
  Assert(not AExternalID.IsEmpty);

  // ���� � ����� ������ ������� �������������
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName, ExternalID.FieldName]);
  Result := FDQuery.LocateEx(AKeyFields, VarArrayOf([AParentExternalID, AExternalID]), []);
end;

function TQueryRecursiveTree.LocateByExternalID(const AExternalID: string):
    Boolean;
begin
  Assert(not AExternalID.IsEmpty);

  // ���� � ����� ������ ������� �������������
  Result := FDQuery.LocateEx(ExternalID.FieldName, AExternalID, []);
end;

function TQueryRecursiveTree.LocateByValue(AParentExternalID: Variant; const
    AValue: string): Boolean;
var
  AKeyFields: string;
begin
  Assert(not AValue.IsEmpty);

  // ���� � ����� ������ ������������
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName, Value.FieldName]);
  Result := FDQuery.LocateEx(AKeyFields, VarArrayOf([AParentExternalID, AValue]), [lxoCaseInsensitive]);
end;

procedure TQueryRecursiveTree.MarkAllAsDeleted;
begin
  Assert(FDQuery.Active);
  // �������� ����� ���������� ������ �� �������
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  try
    FDQuery.First;
    while not FDQuery.Eof do
    begin
      TryEdit;
      MarkAsDeleted.AsInteger := 1;
      Trypost;
      FDQuery.Next;
    end;

  finally
    FDQuery.OnUpdateRecord := nil;
  end;
end;

function TQueryRecursiveTree.NewExternalID(AExternalID: Variant): Variant;
begin
  Result := AExternalID;
  if VarIsNull(AExternalID) then
    Exit;

  Result := Format('~%s~', [AExternalID]);
end;

end.
