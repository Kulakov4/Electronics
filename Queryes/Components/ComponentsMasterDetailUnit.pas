unit ComponentsMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, ComponentsQuery,
  ComponentsDetailQuery, Data.DB, ComponentsBaseMasterDetailUnit,
  ComponentsCountQuery, ComponentsMainCountQuery, ComponentsDetailCountQuery,
  NotifyEvents, System.Generics.Collections, ComponentsBaseDetailQuery,
  FireDAC.Comp.DataSet, ComponentBodyTypesExcelDataModule, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, ProgressInfo,
  ComponentsExcelDataModule, CustomErrorTable, CustomComponentsQuery,
  MainComponentsQuery, BaseQuery, QueryWithDataSourceUnit;

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

  TComponentsMasterDetail = class(TComponentsBaseMasterDetail)
    qComponents: TQueryComponents;
    qComponentsDetail: TQueryComponentsDetail;
    fdqUpdateBody: TFDQuery;
  private
    FNeedUpdateCount: Boolean;
    FQueryComponentsDetailCount: TQueryComponentsDetailCount;
    FQueryComponentsMainCount: TQueryComponentsMainCount;
    procedure AfterComponentPostOrDelete(Sender: TObject);
    function GetQueryComponentsDetailCount: TQueryComponentsDetailCount;
    function GetQueryComponentsMainCount: TQueryComponentsMainCount;
    function GetTotalCount: Integer;
    { Private declarations }
  protected
    procedure DoBeforeDetailPost(Sender: TObject);
    property QueryComponentsDetailCount: TQueryComponentsDetailCount
      read GetQueryComponentsDetailCount;
    property QueryComponentsMainCount: TQueryComponentsMainCount
      read GetQueryComponentsMainCount;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRows(AValues: TArray<String>);
    procedure Commit; override;
    procedure InsertRecordList(AComponentsExcelTable: TComponentsExcelTable);
    procedure LoadBodyList(AExcelTable: TComponentBodyTypesExcelTable);
    procedure LoadFromExcelFolder(AFileNames: TList<String>;
      AutomaticLoadErrorTable: TAutomaticLoadErrorTable);
    property TotalCount: Integer read GetTotalCount;
    { Public declarations }
  end;

implementation

uses System.Types, System.StrUtils, LostComponentsQuery, RepositoryDataModule,
  BodyTypesQuery2, BodyTypesQuery, ErrorTable, TreeListQuery, System.IOUtils;

{$R *.dfm}
{ TfrmComponentsMasterDetail }

constructor TComponentsMasterDetail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Main := qComponents;
  Detail := qComponentsDetail;

  TNotifyEventWrap.Create(qComponentsDetail.BeforePost, DoBeforeDetailPost);

  // TNotifyEventWrap.Create(qComponents.AfterPost, AfterComponentPostOrDelete);
  // TNotifyEventWrap.Create(qComponents.AfterDelete, AfterComponentPostOrDelete);
  // TNotifyEventWrap.Create(qComponentsDetail.AfterPost, AfterComponentPostOrDelete);
  // TNotifyEventWrap.Create(qComponentsDetail.AfterDelete, AfterComponentPostOrDelete);
end;

procedure TComponentsMasterDetail.AfterComponentPostOrDelete(Sender: TObject);
begin
  FNeedUpdateCount := True;
end;

procedure TComponentsMasterDetail.AppendRows(AValues: TArray<String>);
var
  AValue: string;
begin
  TryPost;

  // Добавляем в список родительские компоненты
  for AValue in AValues do
  begin
    qComponents.FDQuery.Append;
    qComponents.Value.AsString := AValue;
    qComponents.TryPost;
  end;
end;

procedure TComponentsMasterDetail.Commit;
begin
  inherited;
  FNeedUpdateCount := True;
end;

procedure TComponentsMasterDetail.DoBeforeDetailPost(Sender: TObject);
begin
  Assert(qComponents.FDQuery.RecordCount > 0);
  if qComponentsDetail.FDQuery.FieldByName('ParentProductId').IsNull then
    qComponentsDetail.FDQuery.FieldByName('ParentProductId').AsInteger :=
      qComponents.PKValue;
end;

function TComponentsMasterDetail.GetQueryComponentsDetailCount
  : TQueryComponentsDetailCount;
begin
  if FQueryComponentsDetailCount = nil then
  begin
    FQueryComponentsDetailCount := TQueryComponentsDetailCount.Create(Self);
    FQueryComponentsDetailCount.FDQuery.Connection :=
      qComponents.FDQuery.Connection;
  end;
  Result := FQueryComponentsDetailCount;
end;

function TComponentsMasterDetail.GetQueryComponentsMainCount
  : TQueryComponentsMainCount;
begin
  if FQueryComponentsMainCount = nil then
  begin
    FQueryComponentsMainCount := TQueryComponentsMainCount.Create(Self);
    FQueryComponentsMainCount.FDQuery.Connection :=
      qComponents.FDQuery.Connection;
  end;
  Result := FQueryComponentsMainCount;
end;

function TComponentsMasterDetail.GetTotalCount: Integer;
var
  x: Integer;
begin
  if FNeedUpdateCount or not QueryComponentsMainCount.FDQuery.Active then
  begin
    // Обновляем кол-во компонентов без семей
    QueryComponentsMainCount.FDQuery.Close;
    QueryComponentsMainCount.FDQuery.Open;

    // Обновляем кол-во дочерних компонентов
    QueryComponentsDetailCount.FDQuery.Close;
    QueryComponentsDetailCount.FDQuery.Open;

    // FNeedUpdateCount := false;
  end;
  x := QueryComponentsMainCount.Count + QueryComponentsDetailCount.Count;
  Result := x;
end;

procedure TComponentsMasterDetail.InsertRecordList(AComponentsExcelTable
  : TComponentsExcelTable);
begin
  Assert(not qComponents.AutoTransaction);
  Assert(not qComponentsDetail.AutoTransaction);

  // работать в рамках одной транзакции гораздо быстрее
  // qComponents.AutoTransaction := True;
  // qComponentsDetail.AutoTransaction := True;
  try

    qComponents.FDQuery.DisableControls;
    qComponentsDetail.FDQuery.DisableControls;
    try
      AComponentsExcelTable.First;
      AComponentsExcelTable.CallOnProcessEvent;
      while not AComponentsExcelTable.Eof do
      begin
        qComponents.LocateOrAppend(AComponentsExcelTable.MainValue.AsString);
        if not AComponentsExcelTable.SubGroup.AsString.IsEmpty then
        begin
          // если ещё не добавляли доп. подгруппы
          if qComponents.SubGroup.AsString.IndexOf
            (AComponentsExcelTable.SubGroup.AsString) = -1 then
          begin
            qComponents.TryEdit;
            qComponents.SubGroup.AsString :=
              Format('%s,%s', [qComponents.SubGroup.AsString,
              AComponentsExcelTable.SubGroup.AsString]);
            qComponents.TryPost
          end;
        end;

        // Добавляем дочерний компонент
        if not AComponentsExcelTable.Value.AsString.IsEmpty then
        begin
          qComponentsDetail.LocateOrAppend(qComponents.PKValue,
            AComponentsExcelTable.Value.AsString);
        end;

        AComponentsExcelTable.Next;
        AComponentsExcelTable.CallOnProcessEvent;
      end;
    finally
      qComponentsDetail.FDQuery.EnableControls;
      qComponents.FDQuery.EnableControls
    end;
  finally
    Connection.Commit;
  end;
end;

procedure TComponentsMasterDetail.LoadBodyList(AExcelTable
  : TComponentBodyTypesExcelTable);
var
  AIDBodyType: Integer;
  AIDComponent: Integer;
  AQueryBodyTypes: TQueryBodyTypes;
begin
  if AExcelTable.RecordCount = 0 then
    Exit;

  AQueryBodyTypes := TQueryBodyTypes.Create(Self);
  try
    AQueryBodyTypes.FDQuery.Open;

    AExcelTable.First;
    AExcelTable.CallOnProcessEvent;
    while not AExcelTable.Eof do
    begin
      AIDComponent := AExcelTable.IDComponent.AsInteger;
      Assert(AIDComponent <> 0);

      // Если неизвестный тип корпуса
      if AExcelTable.IDBodyType.IsNull then
      begin
        AQueryBodyTypes.LocateOrAppend(AExcelTable.BodyType.AsString);
        AIDBodyType := AQueryBodyTypes.PKValue;
      end
      else
        AIDBodyType := AExcelTable.IDBodyType.AsInteger;

      fdqUpdateBody.ParamByName('ID').AsInteger := AIDComponent;
      fdqUpdateBody.ParamByName('BodyID').AsInteger := AIDBodyType;
      fdqUpdateBody.ExecSQL;

      AExcelTable.Next;
      AExcelTable.CallOnProcessEvent;
    end;
  finally
    FreeAndNil(AQueryBodyTypes);
  end;

end;

procedure TComponentsMasterDetail.LoadFromExcelFolder(AFileNames: TList<String>;
  AutomaticLoadErrorTable: TAutomaticLoadErrorTable);
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

  Assert(not qComponents.AutoTransaction);
  Assert(not qComponentsDetail.AutoTransaction);

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
          AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
            AQueryTreeList.Value.AsString, 'Имя файла должно содержать пробел',
            'Ошибка');
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
        qComponentsDetail.Load(AQueryTreeList.PKValue);
        qComponents.Load(AQueryTreeList.PKValue);

        AutomaticLoadErrorTable.LocateOrAppendData(AFileName,
          AQueryTreeList.Value.AsString, 'Загружаем данные из файла...', '');

        AComponentsExcelDM := TComponentsExcelDM.Create(Self);
        try
          try
            // Загружаем даные из Excel файла
            AComponentsExcelDM.LoadExcelFile(AFullFileName,
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
              procedure
              begin
                InsertRecordList(AComponentsExcelDM.ExcelTable)
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
  qComponentsDetail.Load(qComponentsDetail.Master.PKValue);
  qComponents.Load(qComponentsDetail.Master.PKValue);

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
