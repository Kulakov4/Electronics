unit ComponentsGroupUnit2;

interface

uses
  BaseComponentsGroupUnit2, System.Classes, NotifyEvents,
  ComponentsQuery, FamilyQuery, ComponentsCountQuery, EmptyFamilyCountQuery,
  ComponentsExcelDataModule, System.Generics.Collections,
  ExcelDataModule, Data.DB, CustomErrorTable, DSWrap;

type
  TAutomaticLoadErrorTableW = class(TCustomErrorTableW)
  private
    FCategoryName: TFieldWrap;
    FDescription: TFieldWrap;
    FFileName: TFieldWrap;
    FSheetIndex: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppendData(const AFileName: string; ASheetIndex: Variant;
      ACategoryName: string; const ADescription: string; AError: string);
    property CategoryName: TFieldWrap read FCategoryName;
    property Description: TFieldWrap read FDescription;
    property FileName: TFieldWrap read FFileName;
    property SheetIndex: TFieldWrap read FSheetIndex;
  end;

  TAutomaticLoadErrorTable = class(TCustomErrorTable)
  private
    function GetW: TAutomaticLoadErrorTableW;
  protected
    function CreateWrap: TCustomErrorTableW; override;
  public
    constructor Create(AOwner: TComponent); override;
    property W: TAutomaticLoadErrorTableW read GetW;
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
    FqComponents: TQueryComponents;
    FqFamily: TQueryFamily;
    function GetqComponents: TQueryComponents;
    function GetqFamily: TQueryFamily;
  protected
    procedure DoBeforeDetailPost(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoAfterLoadSheet(e: TFolderLoadEvent);
    procedure DoOnTotalProgress(e: TFolderLoadEvent);
    procedure LoadDataFromExcelTable(AComponentsExcelTable
      : TComponentsExcelTable; const AProducer: string);
    // TODO: LoadBodyList
    // procedure LoadBodyList(AExcelTable: TComponentBodyTypesExcelTable);
    function LoadFromExcelFolder(AFileNames: TList<String>;
      AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
      const AProducer: String): Integer;
    property qComponents: TQueryComponents read GetqComponents;
    property qFamily: TQueryFamily read GetqFamily;
  end;

implementation

uses
  ProgressInfo, System.SysUtils, Vcl.Forms, System.StrUtils, TreeListQuery,
  System.IOUtils, System.Variants, FireDAC.Comp.DataSet;

{ TfrmComponentsMasterDetail }

constructor TComponentsGroup2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Сначала будем открывать компоненты, чтобы при открытии семейства знать сколько у него компонент
  // Компоненты и семейства не связаны как главный-подчинённый главным для них является категория
  QList.Add(qComponents);
  QList.Add(qFamily);

  TNotifyEventWrap.Create(qComponents.W.BeforePost, DoBeforeDetailPost,
    EventList);
end;

procedure TComponentsGroup2.DoAfterLoadSheet(e: TFolderLoadEvent);
var
  AExcelTable: TComponentsExcelTable;
  AWarringCount: Integer;
  S: string;
begin
  AExcelTable := e.ExcelDMEvent.ExcelTable as TComponentsExcelTable;
  // if AExcelTable.RecordCount = 0 then Exit;

  e.AutomaticLoadErrorTable.W.LocateOrAppendData(e.FileName,
    e.ExcelDMEvent.SheetIndex, e.CategoryName,
    'Сохраняем в базе данных ...', '');

  try
    // Приступаем к сохранению в базе данных
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
        e.AutomaticLoadErrorTable.W.LocateOrAppendData(e.FileName,
          e.ExcelDMEvent.SheetIndex, e.CategoryName,
          Format('Сохраняем в базе данных (%d%%)', [Round(PI.Position)]), '');
        Application.ProcessMessages;
      end);

    AWarringCount := AExcelTable.Errors.TotalErrorsAndWarrings;
    S := IfThen(AWarringCount = 0, 'Успешно',
      Format('Успешно, предупреждений %d', [AWarringCount]));

    e.AutomaticLoadErrorTable.W.LocateOrAppendData(e.FileName,
      e.ExcelDMEvent.SheetIndex, e.CategoryName, S, '');

  except
    on ee: Exception do
    begin
      e.AutomaticLoadErrorTable.W.LocateOrAppendData(e.FileName,
        e.ExcelDMEvent.SheetIndex, e.CategoryName, ee.Message, 'Ошибка');
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
  e.AutomaticLoadErrorTable.W.LocateOrAppendData(e.FileName,
    e.ExcelDMEvent.SheetIndex, e.CategoryName,
    Format('Загружаем данные с листа %d (%d%%)', [e.ExcelDMEvent.SheetIndex,
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

  // работать в рамках одной транзакции гораздо быстрее
  // qFamily.AutoTransaction := True;
  // qComponents.AutoTransaction := True;

  k := 0; // Кол-во обновлённых записей
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
        // Добавляем семейство в базу данных
        qFamily.FamilyW.LocateOrAppend
          (AComponentsExcelTable.FamilyName.AsString, AProducer);

        // Если в Excel файле указаны дополнительные подгруппы
        if not AComponentsExcelTable.SubGroup.AsString.IsEmpty then
        begin
          // Получаем все коды категорий отдельно
          m := AComponentsExcelTable.SubGroup.AsString.Replace(' ', '',
            [rfReplaceAll]).Split([',']);
          S := ',' + qFamily.W.SubGroup.F.AsString + ',';
          for I := Low(m) to High(m) do
          begin
            // Если такой категории в списке ещё не было
            if S.IndexOf(',' + m[I] + ',') < 0 then
              S := S + m[I] + ',';
          end;
          m := nil;
          S := S.Trim([',']);

          // Если что-то изменилось
          if qFamily.W.SubGroup.F.AsString <> S then
          begin
            qFamily.W.TryEdit;
            qFamily.W.SubGroup.F.AsString := S;
            qFamily.W.TryPost
          end;
        end;

        // Добавляем дочерний компонент
        if not AComponentsExcelTable.ComponentName.AsString.IsEmpty then
        begin
          qComponents.ComponentsW.LocateOrAppend(qFamily.W.PK.Value,
            AComponentsExcelTable.ComponentName.AsString);
        end;

        Inc(k);
        // Уже много записей обновили в рамках одной транзакции
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

function TComponentsGroup2.LoadFromExcelFolder(AFileNames: TList<String>;
AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
const AProducer: String): Integer;
var
  AComponentsExcelDM: TComponentsExcelDM;
  AFullFileName: string;
  AFileName: string;
  m: TArray<String>;
  AQueryTreeList: TQueryTreeList;
begin
  Assert(AFileNames <> nil);
  Assert(AutomaticLoadErrorTable <> nil);
  Result := 0;

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
        AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL, '',
          'Файл не найден', 'Ошибка');
        Continue;
      end;

      AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

      AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL, '',
        'Идёт обработка этого файла...', '');

      m := AFileName.Split([' ']);
      if Length(m) = 0 then
      begin
        AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL, '',
          'Имя файла не содержит идентификатора категории загрузки (или пробела)',
          'Ошибка');
        Continue;
      end;

      try
        // Проверяем что первая часть содержит целочисленный код категории
        m[0].ToInteger;
      except
        AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL, '',
          'Имя файла не содержит идентификатора категории загрузки (или пробела)',
          'Ошибка');
        Continue;
      end;

      AQueryTreeList.W.FilterByExternalID(m[0]);
      if AQueryTreeList.FDQuery.RecordCount = 0 then
      begin
        AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL, '',
          Format('Категория %s не найдена', [m[0]]), 'Ошибка');
        Continue;
      end;

      AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL,
        AQueryTreeList.W.Value.F.AsString, 'Идёт обработка этого файла...', '');

      // загружаем компоненты из нужной нам категории
      qComponents.LoadFromMaster(AQueryTreeList.W.PK.Value);
      qFamily.LoadFromMaster(AQueryTreeList.W.PK.Value);

      AComponentsExcelDM := TComponentsExcelDM.Create(Self);
      try
        AComponentsExcelDM.ExcelTable.Producer := AProducer;

        TNotifyEventR.Create(AComponentsExcelDM.BeforeLoadSheet,
        // Перед загрузкой очередного листа
          procedure(ASender: TObject)
          Var
            e: TExcelDMEvent;
          begin
            e := ASender as TExcelDMEvent;
            AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName,
              e.SheetIndex, AQueryTreeList.W.Value.F.AsString,
              Format('Загружаем данные с листа %d...', [e.SheetIndex]), '');
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
        // После загрузки очередного листа
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
          // Загружаем даные из Excel файла
          AComponentsExcelDM.LoadExcelFile2(AFullFileName);
          qFamily.ApplyUpdates;
          qComponents.ApplyUpdates;
        except
          on e: Exception do
          begin
            AutomaticLoadErrorTable.W.LocateOrAppendData(AFileName, NULL,
              AQueryTreeList.W.Value.F.AsString, e.Message, 'Ошибка');
            Continue;
          end;
        end;

      finally
        FreeAndNil(AComponentsExcelDM);
      end;
    end;

    Result := AQueryTreeList.W.PK.Value;

  finally
    FreeAndNil(AQueryTreeList);
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

  FieldDefs.Add(W.FileName.FieldName, ftWideString, 100);
  FieldDefs.Add(W.SheetIndex.FieldName, ftInteger);
  FieldDefs.Add(W.CategoryName.FieldName, ftWideString, 100);
  FieldDefs.Add(W.Description.FieldName, ftWideString, 100);
  FieldDefs.Add(W.Error.FieldName, ftWideString, 20);
  IndexDefs.Add('idxOrd', Format('%s;%s', [W.FileName.FieldName,
    W.SheetIndex.FieldName]), []);

  CreateDataSet;
  IndexName := 'idxOrd';
  Open;
end;

function TAutomaticLoadErrorTable.CreateWrap: TCustomErrorTableW;
begin
  Result := TAutomaticLoadErrorTableW.Create(Self);
end;

function TAutomaticLoadErrorTable.GetW: TAutomaticLoadErrorTableW;
begin
  Result := Wrap as TAutomaticLoadErrorTableW;
end;

constructor TAutomaticLoadErrorTableW.Create(AOwner: TComponent);
begin
  inherited;
  FCategoryName := TFieldWrap.Create(Self, 'CategoryName', 'Категория');
  FDescription := TFieldWrap.Create(Self, 'Description', 'Описание');
  FFileName := TFieldWrap.Create(Self, 'FileName', 'Имя файла');
  FSheetIndex := TFieldWrap.Create(Self, 'SheetIndex', '№ листа');
end;

procedure TAutomaticLoadErrorTableW.LocateOrAppendData(const AFileName: string;
ASheetIndex: Variant; ACategoryName: string; const ADescription: string;
AError: string);
var
  AFieldNames: string;
begin
  Assert(AFileName <> '');

  AFieldNames := Format('%s;%s', [FileName.FieldName, SheetIndex.FieldName]);

  if not FDDataSet.LocateEx(AFieldNames, VarArrayOf([AFileName, ASheetIndex]),
    [lxoCaseInsensitive]) then
  begin
    if not FDDataSet.LocateEx(AFieldNames, VarArrayOf([AFileName, NULL]),
      [lxoCaseInsensitive]) then
    begin
      TryAppend;
      FileName.F.AsString := AFileName;
    end
    else
      TryEdit;
  end
  else
    TryEdit;

  SheetIndex.F.Value := ASheetIndex;
  CategoryName.F.AsString := ACategoryName;
  Description.F.AsString := ADescription;
  Error.F.AsString := AError;
  TryPost;
end;

end.
