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
    function GetAdded: TField;
    function GetExternalID: TField;
    function GetDeleted: TField;
    function GetID: TField;
    function GetParentExternalID: TField;
    function GetParentID: TField;
    function GetValue: TField;
    procedure MarkAllAsDeleted;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteAll;
    procedure HideNotDeleted;
    procedure HideNotAdded;
    procedure LoadRecords(ATreeExcelTable: TTreeExcelTable);
    function LocateByExternalID(AParentExternalID: Variant; const AExternalID:
        string): Boolean; overload;
    function LocateByExternalID(const AExternalID: string): Boolean; overload;
    function LocateByValue(AParentExternalID: Variant; const AValue: string):
        Boolean;
    property Added: TField read GetAdded;
    property ExternalID: TField read GetExternalID;
    property Deleted: TField read GetDeleted;
    property ID: TField read GetID;
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
  while not FDQuery.eof do
  begin
    try
      FDQuery.Delete;
    except
      FDQuery.Next;
    end;
  end;
end;

procedure TQueryRecursiveTree.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  Deleted.ReadOnly := False;
  Added.ReadOnly := False;
  ExternalID.DisplayLabel := 'Идентификатор';
  Added.Visible := False;
  Deleted.Visible := False;
  ParentExternalID.DisplayLabel := 'Родительский идентификатор';
  Value.DisplayLabel := 'Наименование';
  ParentID.Visible := False;
  ID.Visible := False;
end;

function TQueryRecursiveTree.GetAdded: TField;
begin
  Result := Field('Added');
end;

function TQueryRecursiveTree.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryRecursiveTree.GetDeleted: TField;
begin
  Result := Field('Deleted');
end;

function TQueryRecursiveTree.GetID: TField;
begin
  Result := Field('ID');
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
  FDQuery.Filter := Format('%s = 1', [Deleted.FieldName]);
  FDQuery.Filtered := True;
end;

procedure TQueryRecursiveTree.HideNotAdded;
begin
  FDQuery.Filter := Format('%s = 1', [Added.FieldName]);
  FDQuery.Filtered := True;
end;

procedure TQueryRecursiveTree.LoadRecords(ATreeExcelTable: TTreeExcelTable);
var
  AParentID: Variant;
  OK: Boolean;
begin
//  DeleteAll;

  FDQuery.DisableControls;
  try
    // Помечаем все узлы на удаление
    MarkAllAsDeleted;

    ATreeExcelTable.First;
    ATreeExcelTable.CallOnProcessEvent;

    while not ATreeExcelTable.Eof do
    begin

      // Если это корневая запись
      if ATreeExcelTable.ParentExternalID.IsNull then
      begin
        if not LocateByExternalID(NULL, ATreeExcelTable.ExternalID.AsString) then
        begin
          TryAppend;
          ExternalID.AsString := ATreeExcelTable.ExternalID.AsString;
          // Помечаем, что запись была добавлена
          Added.AsInteger := 1;
        end
        else
          TryEdit;
      end
      else
      begin
        // Ищем дочернюю запись
        if not LocateByExternalID(ATreeExcelTable.ParentExternalID.Value, ATreeExcelTable.ExternalID.AsString) then
        begin
          // Ищем родительскую запись по внешнему идентификатору
          OK := LocateByExternalID(ATreeExcelTable.ParentExternalID.AsString);
          Assert(OK);
          AParentID := PK.Value;

          TryAppend;
          ExternalID.AsString := ATreeExcelTable.ExternalID.AsString;
          ParentID.AsInteger := AParentID;
          ParentExternalID.AsString := ATreeExcelTable.ParentExternalID.AsString;
          // Помечаем, что запись была добавлена
          Added.AsInteger := 1;
        end
        else
          TryEdit;

      end;

        // Обновляем наименование
        Value.AsString := ATreeExcelTable.Value.AsString;
        // Помечаем, что эту запись не нужно удалять
        Deleted.AsInteger := 0;
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

  // Ищем в ветви дерева внешний идентификатор
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName, ExternalID.FieldName]);
  Result := FDQuery.LocateEx(AKeyFields, VarArrayOf([AParentExternalID, AExternalID]), []);
end;

function TQueryRecursiveTree.LocateByExternalID(const AExternalID: string):
    Boolean;
begin
  Assert(not AExternalID.IsEmpty);

  // Ищем в ветви дерева внешний идентификатор
  Result := FDQuery.LocateEx(ExternalID.FieldName, AExternalID, []);
end;

function TQueryRecursiveTree.LocateByValue(AParentExternalID: Variant; const
    AValue: string): Boolean;
var
  AKeyFields: string;
begin
  Assert(not AValue.IsEmpty);

  // Ищем в ветви дерева наименование
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName, Value.FieldName]);
  Result := FDQuery.LocateEx(AKeyFields, VarArrayOf([AParentExternalID, AValue]), [lxoCaseInsensitive]);
end;

procedure TQueryRecursiveTree.MarkAllAsDeleted;
begin
  Assert(FDQuery.Active);
  // Включаем режим обновления только на клиенте
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  try
    FDQuery.First;
    while not FDQuery.Eof do
    begin
      TryEdit;
      Deleted.AsInteger := 1;
      Trypost;
      FDQuery.Next;
    end;

  finally
    FDQuery.OnUpdateRecord := nil;
  end;
end;

end.
