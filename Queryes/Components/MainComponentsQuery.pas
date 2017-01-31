unit MainComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CustomComponentsQuery,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, ApplyQueryFrame, Vcl.StdCtrls, SearchCategoryQuery,
  SearchComponentCategoryQuery, SearchComponentCategoryQuery2,
  SearchComponentQuery, SearchMainComponent2, SearchProductParameterValuesQuery;

type
  TQueryMainComponents = class(TQueryCustomComponents)
  private
    FQuerySearchCategory: TQuerySearchCategory;
    FQuerySearchMainComponent2: TQuerySearchMainComponent2;
    FQuerySearchComponentCategory: TQuerySearchComponentCategory;
    FQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    procedure DoBeforeOpen(Sender: TObject);
    function GetQuerySearchCategory: TQuerySearchCategory;
    function GetQuerySearchMainComponent2: TQuerySearchMainComponent2;
    function GetQuerySearchComponentCategory: TQuerySearchComponentCategory;
    function GetQuerySearchComponentCategory2: TQuerySearchComponentCategory2;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet); override;
    procedure ApplyInsert(ASender: TDataSet); override;
    procedure ApplyUpdate(ASender: TDataSet); override;
    procedure UpdateCategory(AIDComponent: Integer; const ASubGroup: String);
    property QuerySearchCategory: TQuerySearchCategory
      read GetQuerySearchCategory;
    property QuerySearchMainComponent2: TQuerySearchMainComponent2
      read GetQuerySearchMainComponent2;
    property QuerySearchComponentCategory: TQuerySearchComponentCategory
      read GetQuerySearchComponentCategory;
    property QuerySearchComponentCategory2: TQuerySearchComponentCategory2
      read GetQuerySearchComponentCategory2;
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

uses DBRecordHolder, System.Generics.Collections, ParameterValuesUnit,
  NotifyEvents;

{$R *.dfm}
{ TfrmQueryComponents }

constructor TQueryMainComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  TNotifyEventWrap.Create(BeforeOpen, DoBeforeOpen, FEventList);
end;

procedure TQueryMainComponents.ApplyDelete(ASender: TDataSet);
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

procedure TQueryMainComponents.ApplyInsert(ASender: TDataSet);
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
  if QuerySearchMainComponent2.Search(AValue.AsString) = 0 then
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
    APK.AsInteger := QuerySearchMainComponent2.PKValue;

    // Заполняем пустые поля значениями с сервера
    ARH := TDBRecord.Fill(ASender, QuerySearchMainComponent2.FDQuery, PKFieldName);
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
            QuerySearchMainComponent2.SubGroup.AsString)
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

procedure TQueryMainComponents.ApplyUpdate(ASender: TDataSet);
var
  APK: TField;
  ARH: TRecordHolder;
  ASubGroup: TField;
begin
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

procedure TQueryMainComponents.DoBeforeOpen(Sender: TObject);
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

function TQueryMainComponents.GetQuerySearchCategory: TQuerySearchCategory;
begin
  if FQuerySearchCategory = nil then
    FQuerySearchCategory := TQuerySearchCategory.Create(Self);

  Result := FQuerySearchCategory;
end;

function TQueryMainComponents.GetQuerySearchMainComponent2
  : TQuerySearchMainComponent2;
begin
  if FQuerySearchMainComponent2 = nil then
    FQuerySearchMainComponent2 := TQuerySearchMainComponent2.Create(Self);

  Result := FQuerySearchMainComponent2;
end;

function TQueryMainComponents.GetQuerySearchComponentCategory
  : TQuerySearchComponentCategory;
begin
  if FQuerySearchComponentCategory = nil then
    FQuerySearchComponentCategory := TQuerySearchComponentCategory.Create(Self);

  Result := FQuerySearchComponentCategory;
end;

function TQueryMainComponents.GetQuerySearchComponentCategory2
  : TQuerySearchComponentCategory2;
begin
  if FQuerySearchComponentCategory2 = nil then
    FQuerySearchComponentCategory2 :=
      TQuerySearchComponentCategory2.Create(Self);

  Result := FQuerySearchComponentCategory2;
end;

procedure TQueryMainComponents.UpdateCategory(AIDComponent: Integer;
  const ASubGroup: String);
var
  rc: Integer;
begin
  // Сначала удалим компонент из "лишних" категорий
  QuerySearchComponentCategory2.SearchAndDelete(AIDComponent, ASubGroup);

  if not ASubGroup.IsEmpty then
  begin
    // Потом добавим компонент в нужные нам категории
    rc := QuerySearchCategory.Search(ASubGroup);
    Assert(rc > 0);
    QuerySearchCategory.FDQuery.First;
    while not QuerySearchCategory.FDQuery.Eof do
    begin
      // Если компонент не находится в этой категории то добавляем его в эту категорию
      QuerySearchComponentCategory.LocateOrAddValue(AIDComponent,
        QuerySearchCategory.PKValue);

      QuerySearchCategory.FDQuery.Next;
    end;
  end;
end;

end.
