unit AutoBinding;

interface

uses
  System.Classes, DocFieldInfo, System.Generics.Collections,
  FireDAC.Comp.Client, TableWithProgress, Data.DB,
  SearchProductParameterValuesQuery, DocBindExcelDataModule;

type
  MySplitRec = record
    Name: string;
    Number: cardinal;
  end;

  TDocFilesTable = class(TTableWithProgress)
  private
    function GetIDParameter: TField;
    function GetFileName: TField;
    function GetRootFolder: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>);
    property IDParameter: TField read GetIDParameter;
    property FileName: TField read GetFileName;
    property RootFolder: TField read GetRootFolder;
  end;

  TAbsentDocTable = class(TFDMemTable)
  private
    function GetComponentName: TField;
    function GetFolder: TField;
    function GetDescription: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddError(const AFolder, AComponentName, AErrorMessage: string);
    property ComponentName: TField read GetComponentName;
    property Folder: TField read GetFolder;
    property Description: TField read GetDescription;
  end;

  TPossibleLinkDocTable = class(TTableWithProgress)
  private
    function GetComponentName: TField;
    function GetRange: TField;
    function GetFileName: TField;
    function GetRootFolder: TField;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Range: TField read GetRange;
    property FileName: TField read GetFileName;
    property RootFolder: TField read GetRootFolder;
  end;

type
  TErrorLinkedDocTable = class(TTableWithProgress)
  private
    function GetComponentName: TField;
    function GetFolder: TField;
    function GetErrorMessage: TField;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentName: TField read GetComponentName;
    property Folder: TField read GetFolder;
    property ErrorMessage: TField read GetErrorMessage;
  end;

  TAutoBind = class(TObject)
  private
    class function AnalizeDocFiles(ADocFilesTable: TDocFilesTable)
      : TDictionary<Integer, TPossibleLinkDocTable>; static;
    class function CheckAbsentDocFiles(ADocFieldInfos: TList<TDocFieldInfo>;
      const AFDQuery: TFDQuery): TAbsentDocTable; static;
    class function LinkToDocFiles(APossibleLinkDocTables
      : TDictionary<Integer, TPossibleLinkDocTable>;
      const AComponentsDataSet: TTableWithProgress;
      ADocFieldInfos: TList<TDocFieldInfo>; AConnection: TFDCustomConnection;
      const ANoRange: Boolean): TErrorLinkedDocTable; static;
    class function MySplit(const S: String): MySplitRec; static;
  protected
  public
    class procedure BindDescriptions(const AIDCategory: Integer); static;
    class procedure BindDocs(ADocFieldInfos: TList<TDocFieldInfo>;
      const AFDQuery: TFDQuery; const ANoRange, ACheckAbsentDocFiles
      : Boolean); static;
  end;

implementation

uses cxGridDbBandedTableView, GridViewForm, ProgressBarForm, System.SysUtils,
  System.IOUtils, DialogUnit, StrHelper, System.Types, SearchDescriptionsQuery,
  System.StrUtils, ProjectConst;

class function TAutoBind.AnalizeDocFiles(ADocFilesTable: TDocFilesTable)
  : TDictionary<Integer, TPossibleLinkDocTable>;

  procedure Append(AIDParameter: Integer; const AComponentName: String;
    const ARange: cardinal);
  begin
    Assert(AIDParameter > 0);
    Assert(not AComponentName.IsEmpty);

    // ���� ����� ������� � ������ ��� �� ������������
    if not Result.ContainsKey(AIDParameter) then
      Result.Add(AIDParameter, TPossibleLinkDocTable.Create(nil));

    with Result[AIDParameter] do
    begin
      Append;
      FileName.AsString := ADocFilesTable.FileName.AsString;
      RootFolder.AsString := ADocFilesTable.RootFolder.AsString;
      ComponentName.AsString := AComponentName;
      Range.AsInteger := ARange;
      Post;

    end;
  end;

var
  AFileName: string;
  d: TArray<String>;
  i: Integer;
  OK: Boolean;
  R0: MySplitRec;
  R1: MySplitRec;

begin
  Assert(ADocFilesTable <> nil);

  // ������ ������� �� ������ � ���� ������� ������� �� ����� ������������ �����������
  Result := TDictionary<Integer, TPossibleLinkDocTable>.Create;

  ADocFilesTable.First;
  ADocFilesTable.CallOnProcessEvent;

  // ���� �� ���� ��������� ������
  while not ADocFilesTable.Eof do
  begin
    AFileName := TPath.GetFileNameWithoutExtension
      (ADocFilesTable.FileName.AsString);

    // ��������� ��� ����� �� ������� ���������
    d := AFileName.Split(['-']);

    // ���� ���� ������������ ������������ ��� ������ ����������
    if Length(d) = 1 then
    begin
      Append(ADocFilesTable.IDParameter.AsInteger, d[0], 1);
    end
    else
    begin
      // ���� ��������� ������ ������ � ����� ���������
      R0 := MySplit(d[0]);
      R1 := MySplit(d[1]);

      // ('��������� � ������ ��������� ������ ������ ����� ������ ��� ����� ���������� � ����� ���������');
      // ('��������� � ������ ��������� ������ ������ �����');
      // ('���������� � ������ � � ����� ��������� ������ ���������� ������ ��������');
      OK := (R0.Number < R1.Number) and (R0.Number > 0) and (R0.Name = R1.Name);

      if OK then
      begin
        // ���� �� ���� ������� �����������, �������� � ��������
        for i := R0.Number to R1.Number do
        begin
          Append(ADocFilesTable.IDParameter.AsInteger,
            Format('%s%d', [R0.Name, i]), R1.Number - R0.Number);
          ADocFilesTable.CallOnProcessEvent;
        end;

      end;
    end;

    ADocFilesTable.Next;
    ADocFilesTable.CallOnProcessEvent;
  end;
end;

class procedure TAutoBind.BindDescriptions(const AIDCategory: Integer);
var
  AQuerySearchDescriptions: TQuerySearchDescriptions;
begin
  // ����������� ���������� � ������� ���������
  AQuerySearchDescriptions := TQuerySearchDescriptions.Create(nil);
  try
    // ���� ����-�� ��������� ���������
    if AIDCategory > 0 then
      AQuerySearchDescriptions.Search(AIDCategory)
    else
      AQuerySearchDescriptions.FDQuery.Open;

    // ���� ������� ����������, ������� ����� ���������
    if AQuerySearchDescriptions.FDQuery.RecordCount > 0 then
    begin
      TfrmProgressBar.Process(AQuerySearchDescriptions,
        AQuerySearchDescriptions.UpdateComponentDescriptions,
        '��������� �������� ������� ��������', sComponents);
    end;
  finally
    FreeAndNil(AQuerySearchDescriptions);
  end;

end;

class procedure TAutoBind.BindDocs(ADocFieldInfos: TList<TDocFieldInfo>;
  const AFDQuery: TFDQuery; const ANoRange, ACheckAbsentDocFiles: Boolean);
var
  AAbsentDocTable: TAbsentDocTable;
  AcxGridDBBandedColumn: TcxGridDBBandedColumn;
  ADocFilesTable: TDocFilesTable;
  AfrmGridView: TfrmGridView;
  AErrorLinkedDocTable: TErrorLinkedDocTable;
  AIDParameter: Integer;
  APossibleLinkDocTables: TDictionary<Integer, TPossibleLinkDocTable>;
  ATableWithProgress: TTableWithProgress;
  OK: Boolean;
begin
  Assert(AFDQuery <> nil);
  if AFDQuery.RecordCount = 0 then
  begin
    TDialog.Create.ErrorMessageDialog
      ('��� ����������� � ��������� ��������� ���� � ��');
    Exit;
  end;

  // ������ ������� �� ����� ������� ������������
  ADocFilesTable := TDocFilesTable.Create(nil);
  try
    // ������ ��������� ������ ������
    ADocFilesTable.LoadDocFiles(ADocFieldInfos);

    TfrmProgressBar.Process(ADocFilesTable,
      procedure (ASender: TObject)
      begin
        // ������ ����������������, � ����� ����������� ����� ��������� ��� �����
        APossibleLinkDocTables := AnalizeDocFiles(ADocFilesTable);
      end, '������ ��������� ������ ������������', sFiles);
  finally
    FreeAndNil(ADocFilesTable);
  end;

  OK := False;
  for AIDParameter in APossibleLinkDocTables.Keys do
  begin
    OK := APossibleLinkDocTables[AIDParameter].RecordCount > 0;
    if OK then
      break;
  end;

  // ���� ���� ��� �����������
  if OK then
  begin
    ATableWithProgress := TTableWithProgress.Create(nil);
    try
      // ��������� ������ � ������������
      ATableWithProgress.CloneCursor(AFDQuery);
      // ��� ���� ����� ����� ����� ���-�� �������
      ATableWithProgress.Last;

      TfrmProgressBar.Process(ATableWithProgress,
        procedure (ASender: TObject)
        begin
          // ������ ��������� ���������� � ������
          AErrorLinkedDocTable := LinkToDocFiles(APossibleLinkDocTables,
            ATableWithProgress, ADocFieldInfos, AFDQuery.Connection, ANoRange);
        end, '����� ���������� ������ ������������', sComponents);

    finally
      FreeAndNil(ATableWithProgress);
    end;

    // ���� � ���� �������� ���� ������
    if AErrorLinkedDocTable.RecordCount > 0 then
    begin
      // ���������� ������ ������ ��������� ��� ��������
      AfrmGridView := TfrmGridView.Create(nil);
      try
        with AfrmGridView do
        begin
          Caption := '������ �������� ����������� � ������ ������������';
          DataSet := AErrorLinkedDocTable;
          // ���������� ��� �� ���������� �����������
          ShowModal;
        end;
      finally
        FreeAndNil(AfrmGridView);
      end;
    end;
  end
  else
  begin
    TDialog.Create.ComponentsDocFilesNotFound;
  end;

  for AIDParameter in APossibleLinkDocTables.Keys do
  begin
    // ��������� ������� � ������
    APossibleLinkDocTables[AIDParameter].Free;
  end;
  // ��������� ��� �������
  FreeAndNil(APossibleLinkDocTables);

  // ���� ����� ������� ����� �� ������������ ������ ������������
  if ACheckAbsentDocFiles then
  begin

    // ��������� �� ������������ �����
    AAbsentDocTable := CheckAbsentDocFiles(ADocFieldInfos, AFDQuery);
    try
      // ���� ���� ���������� ��� ������� ����������� ������������
      if AAbsentDocTable.RecordCount > 0 then
      begin
        AfrmGridView := TfrmGridView.Create(nil);
        try
          AfrmGridView.Caption :=
            '���������� ��� ������� ����������� ������������';
          AfrmGridView.DataSet := AAbsentDocTable;
          AcxGridDBBandedColumn :=
            AfrmGridView.ViewGrid.MainView.GetColumnByFieldName
            (AAbsentDocTable.Folder.FieldName);
          Assert(AcxGridDBBandedColumn <> nil);
          AcxGridDBBandedColumn.GroupIndex := 0;
          AcxGridDBBandedColumn.Visible := False;
          // ���������� �����
          AfrmGridView.ShowModal;
        finally
          FreeAndNil(AfrmGridView);
        end;
      end;

    finally
      FreeAndNil(AAbsentDocTable);
    end;
  end;
end;

class function TAutoBind.CheckAbsentDocFiles(ADocFieldInfos
  : TList<TDocFieldInfo>; const AFDQuery: TFDQuery): TAbsentDocTable;
var
  AComponentsClone: TTableWithProgress;
  ADocFieldInfo: TDocFieldInfo;
  AErrorMessage: string;
  AFolder: string;
  AFullName: string;
  f: TArray<String>;
  S: string;
begin
  Assert(AFDQuery <> nil);

  // ������ ������� � ������������ � ������� ����������� ������������
  Result := TAbsentDocTable.Create(nil);

  // ������ ���� - ���� ����������, ��� ������� �� ����� (�� ������) ���� ������������
  AComponentsClone := TTableWithProgress.Create(nil);
  try
    // ������ ���� �����������
    AComponentsClone.CloneCursor(AFDQuery);

    // ���� �� ���� ����� ����������, ������� ����� ���������
    for ADocFieldInfo in ADocFieldInfos do
    begin
      // ����� ���� �� �����
      f := ADocFieldInfo.Folder.TrimRight(['\']).Split(['\']);
      Assert(Length(f) > 0);
      AFolder := f[Length(f) - 1];

      AComponentsClone.First;
      AComponentsClone.CallOnProcessEvent;

      while not AComponentsClone.Eof do
      begin
        AErrorMessage := '';

        S := AComponentsClone.FieldByName(ADocFieldInfo.FieldName).AsString;
        // ���� ��������� ����� ���� ������������
        if S <> '' then
        begin
          AFullName := TPath.Combine(ADocFieldInfo.Folder, S);
          if not TFile.Exists(AFullName) then
            AErrorMessage :=
              Format('C����� � ������ %s, �� ���� �� ������', [S]);
        end
        else
        begin
          // ���� ���� � ������������� �� �����
          AErrorMessage := '�� ����� ���� ������������';
        end;

        if AErrorMessage <> '' then
          Result.AddError(AFolder, AComponentsClone.FieldByName('Value')
            .AsString, AErrorMessage);

        AComponentsClone.Next;
        AComponentsClone.CallOnProcessEvent;
      end;
    end;
    AComponentsClone.Close;
  finally
    FreeAndNil(AComponentsClone);
  end;

  Result.First;
end;

class function TAutoBind.LinkToDocFiles(APossibleLinkDocTables
  : TDictionary<Integer, TPossibleLinkDocTable>;
const AComponentsDataSet: TTableWithProgress;
ADocFieldInfos: TList<TDocFieldInfo>; AConnection: TFDCustomConnection;
const ANoRange: Boolean): TErrorLinkedDocTable;

  procedure AppendError(APossibleLinkDocTable: TPossibleLinkDocTable);
  Var
    AFolder: string;
    S: String;
  begin
    S := '';
    APossibleLinkDocTable.First;

    AFolder := TPath.Combine
      (TPath.GetFileName(APossibleLinkDocTable.RootFolder.AsString),
      TPath.GetDirectoryName(GetRelativeFileName(APossibleLinkDocTable.FileName.
      AsString, APossibleLinkDocTable.RootFolder.AsString)));

    while not APossibleLinkDocTable.Eof do
    begin
      S := IfThen(S.IsEmpty, '', S + ', ');
      S := S + TPath.GetFileNameWithoutExtension
        (APossibleLinkDocTable.FileName.AsString);
      APossibleLinkDocTable.Next;
    end;

    Result.Append;
    Result.ComponentName.AsString :=
      APossibleLinkDocTable.ComponentName.AsString;
    Result.Folder.AsString := AFolder;
    Result.ErrorMessage.AsString :=
      Format('��������� ��������� ������ (%s)', [S]);
    Result.Post;
  end;

var
  ADocFieldInfo: TDocFieldInfo;
  APossibleLinkDocTable: TPossibleLinkDocTable;
  ASQL: string;
  i: Integer;
  OK: Boolean;
  Q: TQuerySearchProductParameterValues;
  rc: Integer;
  S: String;
begin
  Assert(APossibleLinkDocTables <> nil);
  Assert(AComponentsDataSet <> nil);
  Result := TErrorLinkedDocTable.Create(nil);

  AComponentsDataSet.BeginBatch();
  // ������ ���� �����������
  AComponentsDataSet.First;
  AComponentsDataSet.CallOnProcessEvent;

  Q := TQuerySearchProductParameterValues.Create(nil);
  // ����� �������� � ������ ����� ����������
  AConnection.StartTransaction;
  try
    i := 0;
    while not AComponentsDataSet.Eof do
    begin
      // ���� �� ���� ����� ������
      for ADocFieldInfo in ADocFieldInfos do
      begin
        // ���� ��������� ��� �� ����� ����� ������������ ������� ����
        if (AComponentsDataSet.FieldByName(ADocFieldInfo.FieldName)
          .AsString.IsEmpty) then
        begin
          // ���� ��� ����� ��������� ���������� ������� � ���������� �������
          if APossibleLinkDocTables.ContainsKey(ADocFieldInfo.IDParameter) then
          begin
            APossibleLinkDocTable := APossibleLinkDocTables
              [ADocFieldInfo.IDParameter];
            // ���� ���� �� ��� ����� ���������� ���������� ����� ����������� ����
            APossibleLinkDocTable.Filter :=
              Format('%s = %s', [APossibleLinkDocTable.ComponentName.FieldName,
              QuotedStr(AComponentsDataSet.FieldByName('Value').AsString)]);
            APossibleLinkDocTable.Filtered := True;

            rc := APossibleLinkDocTable.RecordCount;
            // ���� ����� ����-�� ���� ���������� ����
            if rc > 0 then
            begin
              // ������ ������ - � ����� ����� ����������
              APossibleLinkDocTable.First;
              // ���� ���������� ������ ����� 1 ���� ����� ������� � ����� ����� ����������
              OK := (rc = 1) or (not ANoRange);
              // ���� ���������� ������ ���������
              if not OK then
              begin
                // ��� ����� ��� ����������
                S := TPath.GetFileNameWithoutExtension
                  (APossibleLinkDocTable.FileName.AsString);
                // ���� ������ �� ���������� ������ � �������� ����� �������� ����������
                OK := string.Compare(S,
                  APossibleLinkDocTable.ComponentName.AsString, True) = 0;
                // �� ���� ��������� ������ � �� ���� ����� ���������� �� �������������
                if not OK then
                begin
                  // ��������� ��������� �� ������
                  AppendError(APossibleLinkDocTable);
                end;
              end;

              if OK then
              begin
                with Result do
                begin
                  S := StrHelper.GetRelativeFileName
                    (APossibleLinkDocTable.FileName.AsString,
                    APossibleLinkDocTable.RootFolder.AsString);

                  if Q.Search(ADocFieldInfo.IDParameter,
                    AComponentsDataSet.FieldByName('ID').AsInteger) = 0 then
                  begin
                    ASQL := 'INSERT INTO ParameterValues' +
                      '(ParameterID, Value, ProductID) ' +
                      Format('Values (%d, ''%s'', %d)',
                      [ADocFieldInfo.IDParameter, S,
                      AComponentsDataSet.FieldByName('ID').AsInteger]);

                    AConnection.ExecSQL(ASQL);
                    Inc(i);
                  end;

                  if i >= 1000 then
                  begin
                    AConnection.Commit;
                    AConnection.StartTransaction;
                    i := 0;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
      AComponentsDataSet.Next;
      AComponentsDataSet.CallOnProcessEvent;
    end;
  finally
    AConnection.Commit;
    AComponentsDataSet.EndBatch;
    FreeAndNil(Q);
  end;
end;

class function TAutoBind.MySplit(const S: String): MySplitRec;
var
  StartIndex: Integer;
begin
  Result.Name := S;
  Result.Number := 0;

  StartIndex := S.Length - 1;

  // ���� � ����� ������ ������� �����
  while S.IndexOfAny(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
    StartIndex) = StartIndex do
    Dec(StartIndex);

  Inc(StartIndex);

  // ���� � ����� ������ ���� �����
  if StartIndex < S.Length then
  begin
    Result.Number := StrToInt(S.Substring(StartIndex));
    Result.Name := S.Substring(0, StartIndex);
  end;
end;

constructor TAbsentDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('Folder', ftString, 100);
  FieldDefs.Add('ComponentName', ftString, 100);
  // FieldDefs.Add('Error', ftString, 50);
  FieldDefs.Add('Description', ftString, 150);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := '�����';
  ComponentName.DisplayLabel := '��� ����������';
  Description.DisplayLabel := '��������';
  // Error.DisplayLabel := '��� ������';
end;

procedure TAbsentDocTable.AddError(const AFolder, AComponentName,
  AErrorMessage: string);
begin
  Assert(Active);

  Append;
  Folder.AsString := AFolder;
  ComponentName.AsString := AComponentName;
  // Error.AsString := ErrorMessage;
  Description.AsString := AErrorMessage;
  Post;
end;

function TAbsentDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TAbsentDocTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

function TAbsentDocTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

constructor TDocFilesTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('RootFolder', ftString, 500);
  FieldDefs.Add('IDParameter', ftInteger);

  CreateDataSet;

  Open;
end;

function TDocFilesTable.GetIDParameter: TField;
begin
  Result := FieldByName('IDParameter');
end;

function TDocFilesTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TDocFilesTable.GetRootFolder: TField;
begin
  Result := FieldByName('RootFolder');
end;

procedure TDocFilesTable.LoadDocFiles(ADocFieldInfos: TList<TDocFieldInfo>);

  procedure AddFiles(ADocFieldInfo: TDocFieldInfo; const AFolder: String);
  Var
    // ASubFolder: string;
    m: TStringDynArray;
    S: string;
  begin
    m := TDirectory.GetFiles(AFolder);
    if Length(m) > 0 then
    begin

      // ���� �� ���� ��������� ������
      for S in m do
      begin
        // ��������� � ������� ������ � ��������� �����
        Append;
        RootFolder.AsString := ADocFieldInfo.Folder;
        FileName.AsString := S;
        IDParameter.AsInteger := ADocFieldInfo.IDParameter;
        Post;
      end;
    end;

    // �������� ������ �������� ����������
    m := TDirectory.GetDirectories(AFolder);

    // ��� ������ �������� ����������
    for S in m do
    begin
      // ���������� �������� ����� � ���� ����������
      AddFiles(ADocFieldInfo, S);
    end;

  end;

var
  ADocFieldInfo: TDocFieldInfo;

begin
  // ���� �� ���� ����� ����������, ������� ����� ���������
  for ADocFieldInfo in ADocFieldInfos do
  begin
    AddFiles(ADocFieldInfo, ADocFieldInfo.Folder);
  end;

end;

constructor TPossibleLinkDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('FileName', ftString, 1000);
  FieldDefs.Add('RootFolder', ftString, 500);
  FieldDefs.Add('ComponentName', ftString, 200);
  FieldDefs.Add('Range', ftInteger);
  IndexDefs.Add('idxOrder', 'ComponentName;Range', []);

  CreateDataSet;
  IndexName := 'idxOrder';
  Indexes[0].Active := True;

  Open;

end;

function TPossibleLinkDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TPossibleLinkDocTable.GetRange: TField;
begin
  Result := FieldByName('Range');
end;

function TPossibleLinkDocTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TPossibleLinkDocTable.GetRootFolder: TField;
begin
  Result := FieldByName('RootFolder');
end;

constructor TErrorLinkedDocTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ComponentName', ftString, 200);
  FieldDefs.Add('Folder', ftString, 500);
  FieldDefs.Add('ErrorMessage', ftString, 1000);
  CreateDataSet;

  Open;

  Folder.DisplayLabel := '�����';
  ComponentName.DisplayLabel := '��� ����������';
  ErrorMessage.DisplayLabel := '��������� �� ������';
end;

function TErrorLinkedDocTable.GetComponentName: TField;
begin
  Result := FieldByName('ComponentName');
end;

function TErrorLinkedDocTable.GetFolder: TField;
begin
  Result := FieldByName('Folder');
end;

function TErrorLinkedDocTable.GetErrorMessage: TField;
begin
  Result := FieldByName('ErrorMessage');
end;

end.
