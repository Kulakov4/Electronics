unit RecursiveTreeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, TreeExcelDataModule, DSWrap;

type
  TRecursiveTreeW = class(TDSWrap)
  private
    FAdded: TFieldWrap;
    FDeleted: TFieldWrap;
    FExternalID: TFieldWrap;
    FID: TFieldWrap;
    FParentExternalID: TFieldWrap;
    FParentID: TFieldWrap;
    FValue: TFieldWrap;
    procedure DoAfterOpen(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure HideNotAdded;
    procedure HideNotDeleted;
    function LocateByExternalID(const AExternalID: string; TestResult: Boolean =
        False): Boolean; overload;
    function LocateByExternalID(AParentExternalID: Variant; const AExternalID:
        string): Boolean; overload;
    function LocateByValue(AParentExternalID: Variant; const AValue: string):
        Boolean;
    property Added: TFieldWrap read FAdded;
    property Deleted: TFieldWrap read FDeleted;
    property ExternalID: TFieldWrap read FExternalID;
    property ID: TFieldWrap read FID;
    property ParentExternalID: TFieldWrap read FParentExternalID;
    property ParentID: TFieldWrap read FParentID;
    property Value: TFieldWrap read FValue;
  end;

  TQueryRecursiveTree = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TRecursiveTreeW;
    procedure MarkAllAsDeleted;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure DeleteAll;
    procedure LoadDataFromExcelTable(ATreeExcelTable: TTreeExcelTable);
    property W: TRecursiveTreeW read FW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses NotifyEvents;

constructor TQueryRecursiveTree.Create(AOwner: TComponent);
begin
  inherited;
  FW := TRecursiveTreeW.Create(FDQuery);
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

procedure TQueryRecursiveTree.LoadDataFromExcelTable(ATreeExcelTable:
    TTreeExcelTable);
var
  AParentID: Variant;
begin
  // DeleteAll;

  FDQuery.DisableControls;
  try
    // Помечаем все узлы на удаление
    MarkAllAsDeleted;

    ATreeExcelTable.First;
    ATreeExcelTable.CallOnProcessEvent;

    while not ATreeExcelTable.eof do
    begin

      // Если это корневая запись
      if ATreeExcelTable.ParentExternalID.IsNull then
      begin
        if not W.LocateByExternalID(NULL, ATreeExcelTable.ExternalID.AsString)
        then
        begin
          W.TryAppend;
          W.ExternalID.F.AsString := ATreeExcelTable.ExternalID.AsString;
          // Помечаем, что запись была добавлена
          W.Added.F.AsInteger := 1;
        end
        else
          W.TryEdit;
      end
      else
      begin
        // Ищем дочернюю запись
        if not W.LocateByExternalID(ATreeExcelTable.ParentExternalID.Value,
          ATreeExcelTable.ExternalID.AsString) then
        begin
          // Ищем родительскую запись по внешнему идентификатору
          W.LocateByExternalID(ATreeExcelTable.ParentExternalID.AsString, True);
          AParentID := PK.Value;

          W.TryAppend;
          W.ExternalID.F.AsString := ATreeExcelTable.ExternalID.AsString;
          W.ParentID.F.AsInteger := AParentID;
          W.ParentExternalID.F.AsString :=
            ATreeExcelTable.ParentExternalID.AsString;
          // Помечаем, что запись была добавлена
          W.Added.F.AsInteger := 1;
        end
        else
          TryEdit;

      end;

      // Обновляем наименование
      W.Value.F.AsString := ATreeExcelTable.Value.AsString;
      // Помечаем, что эту запись не нужно удалять
      W.Deleted.F.AsInteger := 0;
      W.TryPost;

      ATreeExcelTable.Next;
      ATreeExcelTable.CallOnProcessEvent;
    end;

  finally
    FDQuery.EnableControls;
  end;
end;

procedure TQueryRecursiveTree.MarkAllAsDeleted;
begin
  Assert(FDQuery.Active);
  // Включаем режим обновления только на клиенте
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
  try
    FDQuery.First;
    while not FDQuery.eof do
    begin
      TryEdit;
      W.Deleted.F.AsInteger := 1;
      TryPost;
      FDQuery.Next;
    end;

  finally
    FDQuery.OnUpdateRecord := nil;
  end;
end;

constructor TRecursiveTreeW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FAdded := TFieldWrap.Create(Self, 'Added');
  FDeleted := TFieldWrap.Create(Self, 'Deleted');
  FExternalID := TFieldWrap.Create(Self, 'ExternalID', 'Идентификатор');
  FParentExternalID := TFieldWrap.Create(Self, 'ParentExternalID', 'Родительский идентификатор');
  FParentID := TFieldWrap.Create(Self, 'ParentID');
  FValue := TFieldWrap.Create(Self, 'Value', 'Наименование');

  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, EventList);
end;

procedure TRecursiveTreeW.DoAfterOpen(Sender: TObject);
begin
  SetFieldsRequired(False);
  Deleted.F.ReadOnly := False;
  Added.F.ReadOnly := False;
  Added.F.Visible := False;
  Deleted.F.Visible := False;
  ParentID.F.Visible := False;
  ID.F.Visible := False;
end;

procedure TRecursiveTreeW.HideNotAdded;
begin
  DataSet.Filter := Format('%s = 1', [Added.FieldName]);
  DataSet.Filtered := True;
end;

procedure TRecursiveTreeW.HideNotDeleted;
begin
  DataSet.Filter := Format('%s = 1', [Deleted.FieldName]);
  DataSet.Filtered := True;
end;

function TRecursiveTreeW.LocateByExternalID(const AExternalID: string;
    TestResult: Boolean = False): Boolean;
begin
  Assert(not AExternalID.IsEmpty);

  // Ищем в ветви дерева внешний идентификатор
  Result := FDDataSet.LocateEx(ExternalID.FieldName, AExternalID, []);

  if TestResult then
    Assert(Result);
end;

function TRecursiveTreeW.LocateByExternalID(AParentExternalID: Variant; const
    AExternalID: string): Boolean;
var
  AKeyFields: string;
begin
  Assert(not AExternalID.IsEmpty);

  // Ищем в ветви дерева внешний идентификатор
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName,
    ExternalID.FieldName]);
  Result := FDDataSet.LocateEx(AKeyFields,
    VarArrayOf([AParentExternalID, AExternalID]), []);
end;

function TRecursiveTreeW.LocateByValue(AParentExternalID: Variant; const
    AValue: string): Boolean;
var
  AKeyFields: string;
begin
  Assert(not AValue.IsEmpty);

  // Ищем в ветви дерева наименование
  AKeyFields := Format('%s;%s', [ParentExternalID.FieldName, Value.FieldName]);
  Result := FDDataSet.LocateEx(AKeyFields, VarArrayOf([AParentExternalID, AValue]
    ), [lxoCaseInsensitive]);
end;

end.
