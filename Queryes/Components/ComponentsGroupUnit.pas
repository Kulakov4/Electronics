unit ComponentsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, FamilyQuery,
  Data.DB, BaseComponentsGroupUnit, ComponentsCountQuery, NotifyEvents,
  System.Generics.Collections, FireDAC.Comp.DataSet,
  ComponentBodyTypesExcelDataModule, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, ProgressInfo,
  ComponentsExcelDataModule, CustomErrorTable, CustomComponentsQuery,
  BaseQuery, QueryWithDataSourceUnit, BaseEventsQuery,
  QueryWithMasterUnit, BaseFamilyQuery, EmptyFamilyCountQuery,
  BaseComponentsQuery, ComponentsQuery;

type
  TAutomaticLoadErrorTable = class(TCustomErrorTable)
  private
    function GetCategoryName: TField;
    function GetDescription: TField;
    function GetError: TField;
    function GetFileName: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppendData(const AFileName: string; ACategoryName: string;
      const ADescription: string; AError: string);
    property CategoryName: TField read GetCategoryName;
    property Description: TField read GetDescription;
    property Error: TField read GetError;
    property FileName: TField read GetFileName;
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
    procedure InsertRecordList(AComponentsExcelTable: TComponentsExcelTable;
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

procedure TComponentsGroup.DoBeforeDetailPost(Sender: TObject);
begin
  Assert(qFamily.FDQuery.RecordCount > 0);

  if qComponents.ParentProductID.IsNull then
    qComponents.ParentProductID.Value := qFamily.PK.Value;
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

procedure TComponentsGroup.InsertRecordList(AComponentsExcelTable
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
  AWarringCount: Integer;
  m: TArray<String>;
  AQueryTreeList: TQueryTreeList;
  S: string;
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
      if TFile.Exists(AFullFileName) then
      begin
        AFileName := TPath.GetFileNameWithoutExtension(AFullFileName);

        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, '',
          'Идёт обработка этого файла...', '');

        m := AFileName.Split([' ']);
        if Length(m) = 0 then
        begin
          AutomaticLoadErrorTable.LocateOrAppendData(AFileName, '',
            'Имя файла должно содержать пробел', 'Ошибка');
          Continue;
        end;

        try
          // Проверяем что первая часть содержит целочисленный код категории
          m[0].ToInteger;
        except
          AutomaticLoadErrorTable.LocateOrAppendData(AFileName, '',
            'В начале имени файла должен быть код категории', 'Ошибка');
          Continue;
        end;

        AQueryTreeList.FilterByExternalID(m[0]);
        if AQueryTreeList.FDQuery.RecordCount = 0 then
        begin
          AutomaticLoadErrorTable.LocateOrAppendData(AFileName, '',
            Format('Категория %s не найдена', [m[0]]), 'Ошибка');
          Continue;
        end;

        AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
          AQueryTreeList.Value.AsString, 'Идёт обработка этого файла...', '');

        // загружаем компоненты из нужной нам категории
        qComponents.Load(AQueryTreeList.PK.Value);
        qFamily.Load(AQueryTreeList.PK.Value);

        AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
          AQueryTreeList.Value.AsString, 'Загружаем данные из файла...', '');

        AComponentsExcelDM := TComponentsExcelDM.Create(Self);
        try
          try
            // Загружаем даные из Excel файла
            AComponentsExcelDM.LoadExcelFile2(AFullFileName,
              procedure(ASender: TObject)
              Var
                PI: TProgressInfo;
              begin
                PI := ASender as TProgressInfo;
                AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
                  AQueryTreeList.Value.AsString,
                  Format('Загружаем данные из файла (%d%%)',
                  [Round(PI.Position)]), '');
                Application.ProcessMessages;
              end);
          except
            on e: Exception do
            begin
              AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
                AQueryTreeList.Value.AsString, e.Message, 'Ошибка');
              Continue;
            end;
          end;

          AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
            AQueryTreeList.Value.AsString, 'Сохраняем в базе данных ...', '');

          try
            // Приступаем к сохранению в базе данных
            AComponentsExcelDM.ExcelTable.Process(
              procedure (ASender: TObject)
              begin
                InsertRecordList(AComponentsExcelDM.ExcelTable, AProducer)
              end,
              procedure(ASender: TObject)
              Var
                PI: TProgressInfo;
              begin
                PI := ASender as TProgressInfo;
                AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
                  AQueryTreeList.Value.AsString,
                  Format('Сохраняем в базе данных (%d%%)',
                  [Round(PI.Position)]), '');
                Application.ProcessMessages;
              end);
          except
            on e: Exception do
            begin
              AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
                AQueryTreeList.Value.AsString, e.Message, 'Ошибка');
              Continue;
            end;
          end;

          AWarringCount := AComponentsExcelDM.ExcelTable.Errors.
            TotalErrorsAndWarrings;
          S := IfThen(AWarringCount = 0, 'Успешно',
            Format('Успешно, предупреждений %d', [AWarringCount]));

          AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
            AQueryTreeList.Value.AsString, S, '');
        finally
          FreeAndNil(AComponentsExcelDM);
        end;
      end
      else
      begin
        AutomaticLoadErrorTable.LocateOrAppendData(AFileName, '',
          'Файл не найден', 'Ошибка');
      end;
    end;

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

  FieldDefs.Add('FileName', ftString, 100);
  FieldDefs.Add('CategoryName', ftString, 100);
  FieldDefs.Add('Description', ftString, 100);
  FieldDefs.Add('Error', ftString, 20);

  CreateDataSet;

  Open;

  FileName.DisplayLabel := 'Имя файла';
  CategoryName.DisplayLabel := 'Категория';
  Error.DisplayLabel := 'Ошибка';
  Description.DisplayLabel := 'Описание';
end;

procedure TAutomaticLoadErrorTable.LocateOrAppendData(const AFileName: string;
ACategoryName: string; const ADescription: string; AError: string);
begin
  Assert(AFileName <> '');

  if not LocateEx(FileName.FieldName, AFileName, [lxoCaseInsensitive]) then
  begin
    Append;
    FileName.AsString := AFileName;
  end
  else
    Edit;

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

end.
