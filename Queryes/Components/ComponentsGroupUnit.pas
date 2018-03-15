unit ComponentsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, FamilyQuery,
  Data.DB, BaseComponentsGroupUnit, ComponentsCountQuery, NotifyEvents,
  System.Generics.Collections, FireDAC.Comp.DataSet, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, ProgressInfo,
  ComponentsExcelDataModule, CustomErrorTable, CustomComponentsQuery,
  BaseQuery, QueryWithDataSourceUnit, BaseEventsQuery,
  QueryWithMasterUnit, BaseFamilyQuery, EmptyFamilyCountQuery,
  BaseComponentsQuery, ComponentsQuery, ExcelDataModule;

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

  TComponentsGroup = class(TBaseComponentsGroup)
    fdqUpdateBody: TFDQuery;
    qFamily: TQueryFamily;
    qComponents: TQueryComponents;
  private
    FNeedUpdateCount: Boolean;
    FQueryComponentsCount: TQueryComponentsCount;
    FQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    procedure AfterComponentPostOrDelete(Sender: TObject);
    function GetQueryComponentsCount: TQueryComponentsCount;
    function GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
    function GetTotalCount: Integer;
    { Private declarations }
  protected
    procedure DoBeforeDetailPost(Sender: TObject);
    property QueryComponentsCount: TQueryComponentsCount
      read GetQueryComponentsCount;
    property QueryEmptyFamilyCount: TQueryEmptyFamilyCount
      read GetQueryEmptyFamilyCount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AValues: TArray<String>);
    procedure Commit; override;
    procedure DoAfterLoadSheet(e: TFolderLoadEvent);
    procedure DoOnTotalProgress(e: TFolderLoadEvent);
    procedure LoadDataFromExcelTable(AComponentsExcelTable: TComponentsExcelTable;
        const AProducer: string);
    // TODO: LoadBodyList
    // procedure LoadBodyList(AExcelTable: TComponentBodyTypesExcelTable);
    procedure LoadFromExcelFolder(AFileNames: TList<String>;
      AutomaticLoadErrorTable: TAutomaticLoadErrorTable;
      const AProducer: String);
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses System.Types, System.StrUtils, RepositoryDataModule, BodyTypesQuery2,
  ErrorTable, TreeListQuery, System.IOUtils, StrHelper;

{$R *.dfm}
{ TfrmComponentsMasterDetail }

constructor TComponentsGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Main := qFamily;
  Detail := qComponents;

  TNotifyEventWrap.Create(qComponents.BeforePost, DoBeforeDetailPost);

  TNotifyEventWrap.Create(qFamily.AfterPost, AfterComponentPostOrDelete);
  TNotifyEventWrap.Create(qFamily.AfterDelete, AfterComponentPostOrDelete);
  TNotifyEventWrap.Create(qComponents.AfterPost, AfterComponentPostOrDelete);
  TNotifyEventWrap.Create(qComponents.AfterDelete, AfterComponentPostOrDelete);
end;

procedure TComponentsGroup.AfterComponentPostOrDelete(Sender: TObject);
begin
  FNeedUpdateCount := True;
end;

procedure TComponentsGroup.AppendRows(AValues: TArray<String>);
var
  AValue: string;
begin
  TryPost;

  // Добавляем в список родительские компоненты
  for AValue in AValues do
  begin
    qFamily.FDQuery.Append;
    qFamily.Value.AsString := AValue;
    qFamily.TryPost;
  end;
end;

procedure TComponentsGroup.Commit;
begin
  inherited;
  FNeedUpdateCount := True;
end;

procedure TComponentsGroup.DoAfterLoadSheet(e: TFolderLoadEvent);
var
  AExcelTable: TComponentsExcelTable;
  AWarringCount: Integer;
  S: string;
begin
  AExcelTable := e.ExcelDMEvent.ExcelTable as TComponentsExcelTable;
//  if AExcelTable.RecordCount = 0 then Exit;

  e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
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
        e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
          e.ExcelDMEvent.SheetIndex, e.CategoryName,
          Format('Сохраняем в базе данных (%d%%)', [Round(PI.Position)]), '');
        Application.ProcessMessages;
      end);

    AWarringCount := AExcelTable.Errors.TotalErrorsAndWarrings;
    S := IfThen(AWarringCount = 0, 'Успешно',
      Format('Успешно, предупреждений %d', [AWarringCount]));

    e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
      e.ExcelDMEvent.SheetIndex, e.CategoryName, S, '');

  except
    on ee: Exception do
    begin
      e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
        e.ExcelDMEvent.SheetIndex, e.CategoryName, ee.Message, 'Ошибка');
    end;
  end;

end;

procedure TComponentsGroup.DoBeforeDetailPost(Sender: TObject);
begin
  Assert(qFamily.FDQuery.RecordCount > 0);

  if qComponents.ParentProductID.IsNull then
    qComponents.ParentProductID.Value := qFamily.PK.Value;
end;

procedure TComponentsGroup.DoOnTotalProgress(e: TFolderLoadEvent);
begin
  e.AutomaticLoadErrorTable.LocateOrAppendData(e.FileName,
    e.ExcelDMEvent.SheetIndex, e.CategoryName,
    Format('Загружаем данные с листа %d (%d%%)', [e.ExcelDMEvent.SheetIndex,
    Round(e.ExcelDMEvent.TotalProgress.PIList[e.ExcelDMEvent.SheetIndex - 1]
    .Position)]), '');
  Application.ProcessMessages;
end;

function TComponentsGroup.GetQueryComponentsCount: TQueryComponentsCount;
begin
  if FQueryComponentsCount = nil then
  begin
    FQueryComponentsCount := TQueryComponentsCount.Create(Self);
    FQueryComponentsCount.FDQuery.Connection := qFamily.FDQuery.Connection;
  end;
  Result := FQueryComponentsCount;
end;

function TComponentsGroup.GetQueryEmptyFamilyCount: TQueryEmptyFamilyCount;
begin
  if FQueryEmptyFamilyCount = nil then
  begin
    FQueryEmptyFamilyCount := TQueryEmptyFamilyCount.Create(Self);
    FQueryEmptyFamilyCount.FDQuery.Connection := qFamily.FDQuery.Connection;
  end;
  Result := FQueryEmptyFamilyCount;
end;

function TComponentsGroup.GetTotalCount: Integer;
var
  x: Integer;
begin
  if FNeedUpdateCount or not QueryEmptyFamilyCount.FDQuery.Active then
  begin
    // Обновляем кол-во компонентов без семей
    QueryEmptyFamilyCount.FDQuery.Close;
    QueryEmptyFamilyCount.FDQuery.Open;

    // Обновляем кол-во дочерних компонентов
    QueryComponentsCount.FDQuery.Close;
    QueryComponentsCount.FDQuery.Open;

    FNeedUpdateCount := false;
  end;
  x := QueryEmptyFamilyCount.Count + QueryComponentsCount.Count;
  Result := x;
end;

procedure TComponentsGroup.LoadDataFromExcelTable(AComponentsExcelTable:
    TComponentsExcelTable; const AProducer: string);
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
      AComponentsExcelTable.First;
      AComponentsExcelTable.CallOnProcessEvent;
      while not AComponentsExcelTable.Eof do
      begin
        // Добавляем компонент в базу данных
        qFamily.LocateOrAppend(AComponentsExcelTable.FamilyName.AsString,
          AProducer);

        // Если в Excel файле указаны дополнительные подгруппы
        if not AComponentsExcelTable.SubGroup.AsString.IsEmpty then
        begin
          // Получаем все коды категорий отдельно
          m := AComponentsExcelTable.SubGroup.AsString.Replace(' ', '',
            [rfReplaceAll]).Split([',']);
          S := ',' + qFamily.SubGroup.AsString + ',';
          for I := Low(m) to High(m) do
          begin
            // Если такой категории в списке ещё не было
            if S.IndexOf(',' + m[I] + ',') < 0 then
              S := S + m[I] + ',';
          end;
          m := nil;
          S := S.Trim([',']);

          // Если что-то изменилось
          if qFamily.SubGroup.AsString <> S then
          begin
            qFamily.TryEdit;
            qFamily.SubGroup.AsString := S;
            qFamily.TryPost
          end;
        end;

        // Добавляем дочерний компонент
        if not AComponentsExcelTable.ComponentName.AsString.IsEmpty then
        begin
          qComponents.LocateOrAppend(qFamily.PK.Value,
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
    finally
      qComponents.FDQuery.EnableControls;
      qFamily.FDQuery.EnableControls
    end;
  finally
    Connection.Commit;
  end;
end;

// TODO: LoadBodyList
// procedure TComponentsGroup.LoadBodyList(AExcelTable
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
// // Если неизвестный тип корпуса
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

procedure TComponentsGroup.LoadFromExcelFolder(AFileNames: TList<String>;
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
    AQueryTreeList.RefreshQuery;

    for AFullFileName in AFileNames do
    begin
      if not TFile.Exists(AFullFileName) then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          'Файл не найден', 'Ошибка');
        Continue;
      end;

      AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

      AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
        'Идёт обработка этого файла...', '');

      m := AFileName.Split([' ']);
      if Length(m) = 0 then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          'Имя файла должно содержать пробел', 'Ошибка');
        Continue;
      end;

      try
        // Проверяем что первая часть содержит целочисленный код категории
        m[0].ToInteger;
      except
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          'В начале имени файла должен быть код категории', 'Ошибка');
        Continue;
      end;

      AQueryTreeList.FilterByExternalID(m[0]);
      if AQueryTreeList.FDQuery.RecordCount = 0 then
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL, '',
          Format('Категория %s не найдена', [m[0]]), 'Ошибка');
        Continue;
      end;

      AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL,
        AQueryTreeList.Value.AsString, 'Идёт обработка этого файла...', '');

      // загружаем компоненты из нужной нам категории
      qComponents.Load(AQueryTreeList.PK.Value);
      qFamily.Load(AQueryTreeList.PK.Value);

      AComponentsExcelDM := TComponentsExcelDM.Create(Self);
      try
        TNotifyEventR.Create(AComponentsExcelDM.BeforeLoadSheet,
        // Перед загрузкой очередного листа
          procedure(ASender: TObject)
          Var
            e: TExcelDMEvent;
          begin
            e := ASender as TExcelDMEvent;
            AutomaticLoadErrorTable.LocateOrAppendData(AFileName, e.SheetIndex,
              AQueryTreeList.Value.AsString,
              Format('Загружаем данные с листа %d...', [e.SheetIndex]), '');
          end);

        TNotifyEventR.Create(AComponentsExcelDM.OnTotalProgress,
          procedure(ASender: TObject)
          Var
            e: TFolderLoadEvent;
          begin
            e := TFolderLoadEvent.Create(AFileName, AutomaticLoadErrorTable,
              AQueryTreeList.Value.AsString, ASender as TExcelDMEvent,
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
              AQueryTreeList.Value.AsString, ASender as TExcelDMEvent,
              AProducer);
            DoAfterLoadSheet(e);
            FreeAndNil(e);
          end);

        try
          // Загружаем даные из Excel файла
          AComponentsExcelDM.LoadExcelFile2(AFullFileName);
        except
          on e: Exception do
          begin
            AutomaticLoadErrorTable.LocateOrAppendData(AFileName, NULL,
              AQueryTreeList.Value.AsString, e.Message, 'Ошибка');
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

  // загружаем компоненты из нужной нам категории
  qComponents.Load(qComponents.Master.PK.Value);
  qFamily.Load(qComponents.Master.PK.Value);
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

  FileName.DisplayLabel := 'Имя файла';
  SheetIndex.DisplayLabel := '№ листа';
  CategoryName.DisplayLabel := 'Категория';
  Error.DisplayLabel := 'Ошибка';
  Description.DisplayLabel := 'Описание';
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

end.
