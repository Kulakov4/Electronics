unit ComponentsGroupUnit2;

interface

uses
  BaseComponentsGroupUnit2, System.Classes, NotifyEvents,
  ComponentsQuery, FamilyQuery, ComponentsCountQuery, EmptyFamilyCountQuery,
  ComponentsExcelDataModule, System.Generics.Collections,
  ExcelDataModule, Data.DB, CustomErrorTable;

type
  TAutomaticLoadErrorTable = class(TCustomErrorTable)
  private
    function GetCategoryName: TField;
    function GetDescription: TField;
    function GetError: TField;
    function GetFileName: TField;
    function GetSheetIndex: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppendData(const AFileName: string; ASheetIndex: Variant;
      ACategoryName: string; const ADescription: string; AError: string);
    property CategoryName: TField read GetCategoryName;
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property FileName: TField read GetFileName;
    property SheetIndex: TField read GetSheetIndex;
  end;

  TFolderLoadEvent = class(TObject)
  private
    FAutomaticLoadErrorTable: TAutomaticLoadErrorTable;
    FCategoryName: string;
    FExcelDMEvent: TExcelDMEvent;
    FFileName: string;
    FProducer: string;
  public
    constructor Create(const AFileName: string;
      const AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
      const ACategoryName: string; const AExcelDMEvent: TExcelDMEvent;
      const AProducer: string);
    property AutomaticLoadErrorTable: TAutomaticLoadErrorTable
      read FAutomaticLoadErrorTable;
    property CategoryName: string read FCategoryName;
    property ExcelDMEvent: TExcelDMEvent read FExcelDMEvent;
    property FileName: string read FFileName;
    property Producer: string read FProducer;
  end;

  TComponentsGroup2 = class(TBaseComponentsGroup2)
  private
    FNeedUpdateCount: Boolean;
    FqComponents: TQueryComponents;
    FqFamily: TQueryFamily;
    FQueryComponentsCount: TQueryComponentsCount;
    FQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    procedure AfterComponentPostOrDelete(Sender: TObject);
    function GetqComponents: TQueryComponents;
    function GetqFamily: TQueryFamily;
    function GetQueryComponentsCount: TQueryComponentsCount;
    function GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    function GetTotalCount: Integer;
  protected
    procedure DoBeforeDetailPost(Sender: TObject);
    property QueryComponentsCount: TQueryComponentsCount
      read GetQueryComponentsCount;
    property QueryEmptyFamilyCount: TQueryEmptyFamilyCount
      read GetQueryEmptyFamilyCount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Commit; override;
    procedure DoAfterLoadSheet(e: TFolderLoadEvent);
    procedure DoOnTotalProgress(e: TFolderLoadEvent);
    procedure LoadDataFromExcelTable(AComponentsExcelTable
      : TComponentsExcelTable; const AProducer: string);
    // TODO: LoadBodyList
    // procedure LoadBodyList(AExcelTable: TComponentBodyTypesExcelTable);
    procedure LoadFromExcelFolder(AFileNames: TList<String>;
      AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
      const AProducer: String);
    property qComponents: TQueryComponents read GetqComponents;
    property qFamily: TQueryFamily read GetqFamily;
    property TotalCount: Integer read GetTotalCount;
  end;

implementation

uses
  ProgressInfo, System.SysUtils, Vcl.Forms, System.StrUtils, TreeListQuery,
  System.IOUtils, System.Variants, FireDAC.Comp.DataSet;

{ TfrmComponentsMasterDetail }

constructor TComponentsGroup2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // ������� ����� ��������� ����������, ����� ��� �������� ��������� ����� ������� � ���� ���������
  // ���������� � ��������� �� ������� ��� �������-���������� ������� ��� ��� �������� ���������
  QList.Add(qComponents);
  QList.Add(qFamily);

  TNotifyEventWrap.Create(qComponents.W.BeforePost, DoBeforeDetailPost,
    EventList);
  TNotifyEventWrap.Create(qFamily.W.AfterPostM, AfterComponentPostOrDelete,
    EventList);
  TNotifyEventWrap.Create(qFamily.W.AfterDelete, AfterComponentPostOrDelete,
    EventList);
  TNotifyEventWrap.Create(qComponents.W.AfterPostM, AfterComponentPostOrDelete,
    EventList);
  TNotifyEventWrap.Create(qComponents.W.AfterDelete, AfterComponentPostOrDelete,
    EventList);
end;

procedure TComponentsGroup2.AfterComponentPostOrDelete(Sender: TObject);
begin
  FNeedUpdateCount := True;
end;

procedure TComponentsGroup2.Commit;
begin
  inherited;
  FNeedUpdateCount := True;
end;

procedure TComponentsGroup2.DoAfterLoadSheet(e: TFolderLoadEvent);
var
  AExcelTable: TComponentsExcelTable;
  AWarringCount: Integer;
  S: string;
begin
  AExcelTable := e.ExcelDMEvent.ExcelTable as TComponentsExcelTable;
  // if AExcelTable.RecordCount = 0 then Exit;

  e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
    e.ExcelDMEvent.SheetIndex, e.CategoryName,
    '��������� � ���� ������ ...', '');

  try
    // ���������� � ���������� � ���� ������
    AExcelTable.Process(
      procedure(ASender: TObject)
      begin
        LoadDataFromExcelTable(AExcelTable, e.Producer);
      end,
      procedure(ASender: TObject)
      Var
        PI: TProgressInfo;
      begin
        PI := ASender as TProgressInfo;
        e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
          e.ExcelDMEvent.SheetIndex, e.CategoryName,
          Format('��������� � ���� ������ (%d%%)', [Round(PI.Position)]), '');
        Application.ProcessMessages;
      end);

    AWarringCount := AExcelTable.Errors.TotalErrorsAndWarrings;
    S := IfThen(AWarringCount = 0, '�������',
      Format('�������, �������������� %d', [AWarringCount]));

    e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
      e.ExcelDMEvent.SheetIndex, e.CategoryName, S, '');

  except
    on ee: Exception do
    begin
      e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
        e.ExcelDMEvent.SheetIndex, e.CategoryName, ee.Message, '������');
    end;
  end;

end;

procedure TComponentsGroup2.DoBeforeDetailPost(Sender: TObject);
begin
  Assert(qFamily.FDQuery.RecordCount > 0);

  if qComponents.W.ParentProductID.F.IsNull then
    qComponents.W.ParentProductID.F.Value := qFamily.W.PK.Value;
end;

procedure TComponentsGroup2.DoOnTotalProgress(e: TFolderLoadEvent);
begin
  e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
    e.ExcelDMEvent.SheetIndex, e.CategoryName,
    Format('��������� ������ � ����� %d (%d%%)', [e.ExcelDMEvent.SheetIndex,
    Round(e.ExcelDMEvent.TotalProgress.PIList[e.ExcelDMEvent.SheetIndex - 1]
    .Position)]), '');
  Application.ProcessMessages;
end;

function TComponentsGroup2.GetqComponents: TQueryComponents;
begin
  if FqComponents = nil then
    FqComponents := TQueryComponents.Create(Self);
  Result := FqComponents;
end;

function TComponentsGroup2.GetqFamily: TQueryFamily;
begin
  if FqFamily = nil then
    FqFamily := TQueryFamily.Create(Self);

  Result := FqFamily;
end;

function TComponentsGroup2.GetQueryComponentsCount: TQueryComponentsCount;
begin
  if FQueryComponentsCount = nil then
  begin
    FQueryComponentsCount := TQueryComponentsCount.Create(Self);
    FQueryComponentsCount.FDQuery.Connection := qFamily.FDQuery.Connection;
  end;
  Result := FQueryComponentsCount;
end;

function TComponentsGroup2.GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
begin
  if FQueryEmptyFamilyCount = nil then
  begin
    FQueryEmptyFamilyCount := TQueryEmptyFamilyCount.Create(Self);
    FQueryEmptyFamilyCount.FDQuery.Connection := qFamily.FDQuery.Connection;
  end;
  Result := FQueryEmptyFamilyCount;
end;

function TComponentsGroup2.GetTotalCount: Integer;
var
  x: Integer;
begin
  if FNeedUpdateCount or not QueryEmptyFamilyCount.FDQuery.Active then
  begin
    // ��������� ���-�� ����������� ��� �����
    QueryEmptyFamilyCount.FDQuery.Close;
    QueryEmptyFamilyCount.FDQuery.Open;

    // ��������� ���-�� �������� �����������
    QueryComponentsCount.FDQuery.Close;
    QueryComponentsCount.FDQuery.Open;

    FNeedUpdateCount := false;
  end;
  x := QueryEmptyFamilyCount.Count + QueryComponentsCount.Count;
  Result := x;
end;

procedure TComponentsGroup2.LoadDataFromExcelTable(AComponentsExcelTable
  : TComponentsExcelTable; const AProducer: string);
var
  I: Integer;
  k: Integer;
  m: TArray<String>;
  S: string;
begin
  Assert(not AProducer.IsEmpty);
  Assert(not qFamily.AutoTransaction);
  Assert(not qComponents.AutoTransaction);

  // �������� � ������ ����� ���������� ������� �������
  // qFamily.AutoTransaction := True;
  // qComponents.AutoTransaction := True;

  k := 0; // ���-�� ���������� �������
  try

    qFamily.FDQuery.DisableControls;
    qComponents.FDQuery.DisableControls;
    try
      // qFamily.SaveBookmark;
      // qComponents.SaveBookmark;
      // try
      AComponentsExcelTable.First;
      AComponentsExcelTable.CallOnProcessEvent;
      while not AComponentsExcelTable.Eof do
      begin
        // ��������� ��������� � ���� ������
        qFamily.FamilyW.LocateOrAppend
          (AComponentsExcelTable.FamilyName.AsString, AProducer);

        // ���� � Excel ����� ������� �������������� ���������
        if not AComponentsExcelTable.SubGroup.AsString.IsEmpty then
        begin
          // �������� ��� ���� ��������� ��������
          m := AComponentsExcelTable.SubGroup.AsString.Replace(' ', '',
            [rfReplaceAll]).Split([',']);
          S := ',' + qFamily.W.SubGroup.F.AsString + ',';
          for I := Low(m) to High(m) do
          begin
            // ���� ����� ��������� � ������ ��� �� ����
            if S.IndexOf(',' + m[I] + ',') < 0 then
              S := S + m[I] + ',';
          end;
          m := nil;
          S := S.Trim([',']);

          // ���� ���-�� ����������
          if qFamily.W.SubGroup.F.AsString <> S then
          begin
            qFamily.W.TryEdit;
            qFamily.W.SubGroup.F.AsString := S;
            qFamily.W.TryPost
          end;
        end;

        // ��������� �������� ���������
        if not AComponentsExcelTable.ComponentName.AsString.IsEmpty then
        begin
          qComponents.ComponentsW.LocateOrAppend(qFamily.W.PK.Value,
            AComponentsExcelTable.ComponentName.AsString);
        end;

        Inc(k);
        // ��� ����� ������� �������� � ������ ����� ����������
        if k >= 1000 then
        begin
          k := 0;
          Connection.Commit;
          Connection.StartTransaction;
        end;

        AComponentsExcelTable.Next;
        AComponentsExcelTable.CallOnProcessEvent;
      end;
      // finally
      // qFamily.RestoreBookmark;
      // qComponents.RestoreBookmark;
      // end;
    finally
      qComponents.FDQuery.EnableControls;
      qFamily.FDQuery.EnableControls
    end;
  finally
    Connection.Commit;
  end;
end;

// TODO: LoadBodyList
// procedure TComponentsGroup2.LoadBodyList(AExcelTable
// : TComponentBodyTypesExcelTable);
// var
// AIDBodyType: Integer;
// AIDComponent: Integer;
// AQueryBodyTypes: TQueryBodyTypes;
// begin
// if AExcelTable.RecordCount = 0 then
// Exit;
//
// AQueryBodyTypes := TQueryBodyTypes.Create(Self);
// try
// AQueryBodyTypes.FDQuery.Open;
//
// AExcelTable.First;
// AExcelTable.CallOnProcessEvent;
// while not AExcelTable.Eof do
// begin
// AIDComponent := AExcelTable.IDComponent.AsInteger;
// Assert(AIDComponent <> 0);
//
// // ���� ����������� ��� �������
// if AExcelTable.IDBodyType.IsNull then
// begin
// AQueryBodyTypes.LocateOrAppend(AExcelTable.BodyType.AsString);
// AIDBodyType := AQueryBodyTypes.PKValue;
// end
// else
// AIDBodyType := AExcelTable.IDBodyType.AsInteger;
//
// fdqUpdateBody.ParamByName('ID').AsInteger := AIDComponent;
// fdqUpdateBody.ParamByName('BodyID').AsInteger := AIDBodyType;
// fdqUpdateBody.ExecSQL;
//
// AExcelTable.Next;
// AExcelTable.CallOnProcessEvent;
// end;
// finally
// FreeAndNil(AQueryBodyTypes);
// end;
//
// end;

procedure TComponentsGroup2.LoadFromExcelFolder(AFileNames: TList<String>;
AutomaticLoadErrorTable: TAutomaticLoadErrorTable; const AProducer: String);
var
  AComponentsExcelDM: TComponentsExcelDM;
  AFullFileName: string;
  AFileName: string;
  m: TArray<String>;
  AQueryTreeList: TQueryTreeList;
begin
  Assert(AFileNames <> nil);
  Assert(AutomaticLoadErrorTable <> nil);

  if AFileNames.Count = 0 then
    Exit;

  Assert(not qFamily.AutoTransaction);
  Assert(not qComponents.AutoTransaction);

  AQueryTreeList := TQueryTreeList.Create(Self);
  try
    AQueryTreeList.FDQuery.Open;

    for AFullFileName in AFileNames do
    begin
      if not TFile.Exists(AFullFileName) then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          '���� �� ������', '������');
        Continue;
      end;

      AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

      AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
        '��� ��������� ����� �����...', '');

      m := AFileName.Split([' ']);
      if Length(m) = 0 then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          '��� ����� ������ ��������� ������', '������');
        Continue;
      end;

      try
        // ��������� ��� ������ ����� �������� ������������� ��� ���������
        m[0].ToInteger;
      except
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          '� ������ ����� ����� ������ ���� ��� ���������', '������');
        Continue;
      end;

      AQueryTreeList.W.FilterByExternalID(m[0]);
      if AQueryTreeList.FDQuery.RecordCount = 0 then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          Format('��������� %s �� �������', [m[0]]), '������');
        Continue;
      end;

      AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL,
        AQueryTreeList.W.Value.F.AsString, '��� ��������� ����� �����...', '');

      // ��������� ���������� �� ������ ��� ���������
      qComponents.Load(AQueryTreeList.W.PK.Value);
      qFamily.Load(AQueryTreeList.W.PK.Value);

      AComponentsExcelDM := TComponentsExcelDM.Create(Self);
      try
        TNotifyEventR.Create(AComponentsExcelDM.BeforeLoadSheet,
        // ����� ��������� ���������� �����
          procedure(ASender: TObject)
          Var
            e: TExcelDMEvent;
          begin
            e := ASender as TExcelDMEvent;
            AutomaticLoadErrorTable.LocateOrAppendData(AFileName, e.SheetIndex,
              AQueryTreeList.W.Value.F.AsString,
              Format('��������� ������ � ����� %d...', [e.SheetIndex]), '');
          end);

        TNotifyEventR.Create(AComponentsExcelDM.OnTotalProgress,
          procedure(ASender: TObject)
          Var
            e: TFolderLoadEvent;
          begin
            e := TFolderLoadEvent.Create(AFileName, AutomaticLoadErrorTable,
              AQueryTreeList.W.Value.F.AsString, ASender as TExcelDMEvent,
              AProducer);
            DoOnTotalProgress(e);
            FreeAndNil(e);
          end);

        TNotifyEventR.Create(AComponentsExcelDM.AfterLoadSheet,
        // ����� �������� ���������� �����
          procedure(ASender: TObject)
          Var
            e: TFolderLoadEvent;
          begin
            e := TFolderLoadEvent.Create(AFileName, AutomaticLoadErrorTable,
              AQueryTreeList.W.Value.F.AsString, ASender as TExcelDMEvent,
              AProducer);
            DoAfterLoadSheet(e);
            FreeAndNil(e);
          end);

        try
          // ��������� ����� �� Excel �����
          AComponentsExcelDM.LoadExcelFile2(AFullFileName);
          qFamily.ApplyUpdates;
          qComponents.ApplyUpdates;
        except
          on e: Exception do
          begin
            AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL,
              AQueryTreeList.W.Value.F.AsString, e.Message, '������');
            Continue;
          end;
        end;

      finally
        FreeAndNil(AComponentsExcelDM);
      end;
    end

  finally
    FreeAndNil(AQueryTreeList);
  end;

  if qComponents.Master <> nil then
  begin
    // ��������� ���������� �� ������ ��� ���������
    qComponents.Load(qComponents.Master.Wrap.PK.Value);
    qFamily.Load(qComponents.Master.Wrap.PK.Value);
  end;
end;

constructor TFolderLoadEvent.Create(const AFileName: string;
const AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
const ACategoryName: string; const AExcelDMEvent: TExcelDMEvent;
const AProducer: string);
begin
  inherited Create;
  FFileName := AFileName;
  FAutomaticLoadErrorTable := AutomaticLoadErrorTable;
  FCategoryName := ACategoryName;
  FExcelDMEvent := AExcelDMEvent;
  FProducer := AProducer;
end;

constructor TAutomaticLoadErrorTable.Create(AOwner: TComponent);
begin
  inherited;

  FieldDefs.Add('FileName', ftWideString, 100);
  FieldDefs.Add('SheetIndex', ftInteger);
  FieldDefs.Add('CategoryName', ftWideString, 100);
  FieldDefs.Add('Description', ftWideString, 100);
  FieldDefs.Add('Error', ftWideString, 20);
  IndexDefs.Add('idxOrd', 'FileName;SheetIndex', []);

  CreateDataSet;
  IndexName := 'idxOrd';
  Open;

  FileName.DisplayLabel := '��� �����';
  SheetIndex.DisplayLabel := '� �����';
  CategoryName.DisplayLabel := '���������';
  Error.DisplayLabel := '������';
  Description.DisplayLabel := '��������';
end;

procedure TAutomaticLoadErrorTable.LocateOrAppendData(const AFileName: string;
ASheetIndex: Variant; ACategoryName: string; const ADescription: string;
AError: string);
var
  AFieldNames: string;
begin
  Assert(AFileName <> '');

  AFieldNames := Format('%s;%s', [FileName.FieldName, SheetIndex.FieldName]);

  if not LocateEx(AFieldNames, VarArrayOf([AFileName, ASheetIndex]),
    [lxoCaseInsensitive]) then
  begin
    if not LocateEx(AFieldNames, VarArrayOf([AFileName, NULL]),
      [lxoCaseInsensitive]) then
    begin
      Append;
      FileName.AsString := AFileName;
    end
    else
      Edit;
  end
  else
    Edit;

  SheetIndex.Value := ASheetIndex;
  CategoryName.AsString := ACategoryName;
  Description.AsString := ADescription;
  Error.AsString := AError;
  Post;
end;

function TAutomaticLoadErrorTable.GetCategoryName: TField;
begin
  Result := FieldByName('CategoryName');
end;

function TAutomaticLoadErrorTable.GetDescription: TField;
begin
  Result := FieldByName('Description');
end;

function TAutomaticLoadErrorTable.GetError: TField;
begin
  Result := FieldByName('Error');
end;

function TAutomaticLoadErrorTable.GetFileName: TField;
begin
  Result := FieldByName('FileName');
end;

function TAutomaticLoadErrorTable.GetSheetIndex: TField;
begin
  Result := FieldByName('SheetIndex');
end;

end.
