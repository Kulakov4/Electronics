unit BaseFamilyQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomComponentsQuery,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ApplyQueryFrame, Vcl.StdCtrls,
  SearchComponentCategoryQuery, SearchComponentCategoryQuery2,
  SearchComponentQuery, SearchFamilyByValue, SearchProductParameterValuesQuery,
  SearchCategoryBySubGroup, SearchCategoryByID;

type
  TQueryBaseFamily = class(TQueryCustomComponents)
  private
    FQuerySearchCategoryByID: TQuerySearchCategoryByID;
    FQuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup;
    FQuerySearchFamilyByValue: TQuerySearchFamilyByValue;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    FQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    procedure DoBeforeOpen(Sender: TObject);
    function GetExternalID: TField;
    function GetCategoryExternalID: string;
    function GetQuerySearchCategoryByID: TQuerySearchCategoryByID;
    function GetQuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup;
    function GetQuerySearchFamilyByValue: TQuerySearchFamilyByValue;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    function GetQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property QuerySearchCategoryByID: TQuerySearchCategoryByID
      read GetQuerySearchCategoryByID;
    property QuerySearchCategoryBySubGroup: TQuerySearchCategoryBySubGroup
      read GetQuerySearchCategoryBySubGroup;
    property QuerySearchFamilyByValue: TQuerySearchFamilyByValue
      read GetQuerySearchFamilyByValue;
    property QuerySearchComponentCategory: TQuerySearchComponentCategory
      read GetQuerySearchComponentCategory;
    property QuerySearchComponentCategory2: TQuerySearchComponentCategory2
      read GetQuerySearchComponentCategory2;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TField read GetExternalID;
    property CategoryExternalID: string read GetCategoryExternalID;
    { Public declarations }
  end;

implementation

uses DBRecordHolder, System.Generics.Collections, ParameterValuesUnit,
  NotifyEvents;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryBaseFamily.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryBaseFamily.ApplyDelete(ASender: TDataSet);
var
  AID: Integer;
begin
  AID := ASender.FieldByName(PKFieldName).AsInteger;
  if AID > 0 then
  begin
    // Удаляем компонент из всех категорий
    UpdateCategory(AID, '');

    // Удаляем сам компонент
    qProducts.DeleteRecord(AID);
  end;

  inherited;
end;

procedure TQueryBaseFamily.ApplyInsert(ASender: TDataSet; ARequest:
    TFDUpdateRequest; var AAction: TFDErrorAction; AOptions:
    TFDUpdateRowOptions);
var
  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
  AValue: TField;
begin
  APK := ASender.FieldByName(PKFieldName);
  AValue := ASender.FieldByName(Value.FieldName);
  ASubGroup := ASender.FieldByName(SubGroup.FieldName);

  // Если такого компонента ещё нет
  if QuerySearchFamilyByValue.Search(AValue.AsString) = 0 then
  begin
    ARH := TRecordHolder.Create(ASender);
    try
      qProducts.InsertRecord(ARH);
    finally
      FreeAndNil(ARH);
    end;

    // Запоминаем сгенерированный первичный ключ
    APK.AsInteger := qProducts.PKValue;

    // Обрабатываем значения параметров
    UpdateParamValue(PKFieldName, ASender);
  end
  else
  begin
    // Если такой компонент уже есть
    // Запоминаем найденный первичный ключ
    APK.Value := QuerySearchFamilyByValue.PK.Value;

    // Заполняем пустые поля значениями с сервера
    ARH := TDBRecord.Fill(ASender, QuerySearchFamilyByValue.FDQuery,
      PKFieldName);
    try
      // Если есть поля, которые нужно обновить
      if ARH.Count > 0 then
      begin
        // Обновляем те поля, которые есть у компонента
        qProducts.UpdateRecord(ARH);

        // Если на сервере иное значение подгруппы
        if ARH.Find(SubGroup.FieldName) <> nil then
        begin
          ASubGroup.AsString := CombineSubgroup(ASubGroup.AsString,
            QuerySearchFamilyByValue.SubGroup.AsString)
        end;

        // Обрабатываем значения параметров
        UpdateParamValue(PKFieldName, ASender);
      end;
    finally
      FreeAndNil(ARH);
    end;
  end;

  Assert(APK.AsInteger > 0);

  // Обновляем категории нашего компонента
  UpdateCategory(APK.AsInteger, ASubGroup.AsString);

  inherited;
end;

procedure TQueryBaseFamily.ApplyUpdate(ASender: TDataSet);
var
  // APackagePins: TField;
  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
begin
  // APackagePins := ASender.FieldByName(PackagePins.FieldName);

  ARH := TRecordHolder.Create(ASender);
  try
    // Обновляем те поля, которые есть у компонента
    qProducts.UpdateRecord(ARH);
  finally
    FreeAndNil(ARH);
  end;

  // Обрабатываем обновление значений параметров
  UpdateParamValue(PKFieldName, ASender);

  ASubGroup := ASender.FindField('SubGroup');
  // Если в запросе выбираются внешние коды категорий
  if ASubGroup <> nil then
  begin
    APK := ASender.FieldByName(PKFieldName);

    // Обновляем категории нашего компонента
    UpdateCategory(APK.AsInteger, ASubGroup.AsString);
  end;

  inherited;
end;

procedure TQueryBaseFamily.DoBeforeOpen(Sender: TObject);
begin
  // Заполняем код параметра "Производитель"
  FDQuery.ParamByName('ProducerParameterID').AsInteger :=
    TParameterValues.ProducerParameterID;

  FDQuery.ParamByName('PackagePinsParameterID').AsInteger :=
    TParameterValues.PackagePinsParameterID;

  FDQuery.ParamByName('DatasheetParameterID').AsInteger :=
    TParameterValues.DatasheetParameterID;

  FDQuery.ParamByName('DiagramParameterID').AsInteger :=
    TParameterValues.DiagramParameterID;

  FDQuery.ParamByName('DrawingParameterID').AsInteger :=
    TParameterValues.DrawingParameterID;

  FDQuery.ParamByName('ImageParameterID').AsInteger :=
    TParameterValues.ImageParameterID;

end;

function TQueryBaseFamily.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryBaseFamily.GetCategoryExternalID: string;
var
  rc: Integer;
begin
  Assert(FDQuery.Active);

  if not ExternalID.AsString.IsEmpty then
  begin
    Result := ExternalID.AsString;
    Exit;
  end;

  Assert(not DetailParameterName.IsEmpty);

  rc := QuerySearchCategoryByID.Search(FDQuery.ParamByName(DetailParameterName)
    .AsInteger);
  Assert(rc = 1);
  Result := QuerySearchCategoryByID.ExternalID.AsString;
end;

function TQueryBaseFamily.GetQuerySearchCategoryByID: TQuerySearchCategoryByID;
begin
  if FQuerySearchCategoryByID = nil then
    FQuerySearchCategoryByID := TQuerySearchCategoryByID.Create(Self);
  Result := FQuerySearchCategoryByID;
end;

function TQueryBaseFamily.GetQuerySearchCategoryBySubGroup
  : TQuerySearchCategoryBySubGroup;
begin
  if FQuerySearchCategoryBySubGroup = nil then
    FQuerySearchCategoryBySubGroup :=
      TQuerySearchCategoryBySubGroup.Create(Self);

  Result := FQuerySearchCategoryBySubGroup;
end;

function TQueryBaseFamily.GetQuerySearchFamilyByValue
  : TQuerySearchFamilyByValue;
begin
  if FQuerySearchFamilyByValue = nil then
    FQuerySearchFamilyByValue := TQuerySearchFamilyByValue.Create(Self);

  Result := FQuerySearchFamilyByValue;
end;

function TQueryBaseFamily.GetQuerySearchComponentCategory
  : TQuerySearchComponentCategory;
begin
  if FQuerySearchComponentCategory = nil then
    FQuerySearchComponentCategory := TQuerySearchComponentCategory.Create(Self);

  Result := FQuerySearchComponentCategory;
end;

function TQueryBaseFamily.GetQuerySearchComponentCategory2
  : TQuerySearchComponentCategory2;
begin
  if FQuerySearchComponentCategory2 = nil then
    FQuerySearchComponentCategory2 :=
      TQuerySearchComponentCategory2.Create(Self);

  Result := FQuerySearchComponentCategory2;
end;

procedure TQueryBaseFamily.UpdateCategory(AIDComponent: Integer;
  const ASubGroup: String);
var
  rc: Integer;
begin
  // Сначала удалим компонент из "лишних" категорий
  QuerySearchComponentCategory2.SearchAndDelete(AIDComponent, ASubGroup);

  if not ASubGroup.IsEmpty then
  begin
    // Потом добавим компонент в нужные нам категории
    rc := QuerySearchCategoryBySubGroup.Search(ASubGroup);
    Assert(rc > 0);
    QuerySearchCategoryBySubGroup.FDQuery.First;
    while not QuerySearchCategoryBySubGroup.FDQuery.Eof do
    begin
      // Если компонент не находится в этой категории то добавляем его в эту категорию
      QuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
        QuerySearchCategoryBySubGroup.PK.Value);

      QuerySearchCategoryBySubGroup.FDQuery.Next;
    end;
  end;
end;

end.
