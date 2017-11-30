unit AnalogQueryes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ParametersForCategoryQuery, TableWithProgress, Data.DB,
  System.Generics.Collections, UniqueParameterValuesQuery, Sort.StringList,
  System.StrUtils, FireDAC.Comp.Client, DBRecordHolder;

type
  TParameterValuesTable = class(TTableWithProgress)
  private
    function GetValue: TField;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AppendRec(const AID: Integer; const AValue: string);
    property Value: TField read GetValue;
  end;

  TParamValues = class(TObject)
  private
    FCaption: String;
    FParameterID: Integer;
    FTable: TParameterValuesTable;
  public
    constructor Create(const ACaption: String; AParameterID: Integer);
    destructor Destroy; override;
    property Caption: String read FCaption;
    property ParameterID: Integer read FParameterID;
    property Table: TParameterValuesTable read FTable;
  end;

  TParamValuesList = class(TList<TParamValues>)
  public
    function FindByParameterID(AParameterID: Integer): TParamValues;
  end;

  TAnalogGroup = class(TQueryGroup)
  private
    FAllParameterFields: TDictionary<Integer, String>;
    FFDMemTable: TFDMemTable;
    FParamValuesList: TParamValuesList;
    FqParametersForCategory: TQueryParametersForCategory;
    FqUniqueParameterValues: TQueryUniqueParameterValues;
  const
    FFieldPrefix: string = 'Field';
    function GetFieldName(AIDParameter: Integer): String;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParamIDByFieldName(const AFieldName: String): Integer;
    procedure Load(AProductCategoryID: Integer; ARecHolder: TRecordHolder);
    property AllParameterFields: TDictionary<Integer, String> read
        FAllParameterFields;
    property FDMemTable: TFDMemTable read FFDMemTable;
    property ParamValuesList: TParamValuesList read FParamValuesList;
    property qParametersForCategory: TQueryParametersForCategory
      read FqParametersForCategory;
    property qUniqueParameterValues: TQueryUniqueParameterValues
      read FqUniqueParameterValues;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TAnalogGroup.Create(AOwner: TComponent);
begin
  inherited;
  FqParametersForCategory := TQueryParametersForCategory.Create(Self);
  FqUniqueParameterValues := TQueryUniqueParameterValues.Create(Self);
  FParamValuesList := TParamValuesList.Create;
  FFDMemTable := TFDMemTable.Create(Self);
  FAllParameterFields := TDictionary<Integer,String>.Create;
end;

destructor TAnalogGroup.Destroy;
begin
  FreeAndNil(FAllParameterFields);
  FreeAndNil(FParamValuesList);
  inherited;
end;

function TAnalogGroup.GetFieldName(AIDParameter: Integer): String;
begin
  Result := Format('%s%d', [FFieldPrefix, AIDParameter]);
end;

function TAnalogGroup.GetParamIDByFieldName(const AFieldName: String): Integer;
var
  i: Integer;
begin
  Assert(not AFieldName.IsEmpty);
  i := AFieldName.IndexOf( FFieldPrefix );
  Assert(i = 0);
  Result := AFieldName.Substring(FFieldPrefix.Length).ToInteger();
end;

procedure TAnalogGroup.Load(AProductCategoryID: Integer; ARecHolder:
    TRecordHolder);
var
  ACaption: String;
  AFieldName: string;
  AParamValues: TParamValues;
  ASortList: TStringList;
  F: TField;
  I: Integer;
begin
  Assert(ARecHolder <> nil);

  ASortList := TStringList.Create;
  try
    FFDMemTable.Close;

    // Ищем параметры используемые для поиска аналога
    FqParametersForCategory.SearchByParameterKind(AProductCategoryID);
    while not FqParametersForCategory.FDQuery.Eof do
    begin
      // Имя поля в таблице поределяющей выбранные значения для поиска аналога
      AFieldName := GetFieldName
        (FqParametersForCategory.ParameterID.AsInteger);
      // Добавляем очередное поле
      FFDMemTable.FieldDefs.Add(AFieldName, ftString, 200);
      FAllParameterFields.Add(FqParametersForCategory.ParameterID.AsInteger,
        AFieldName);





      ACaption := IfThen(qParametersForCategory.ParentCaption.AsString <> '',
        Format('%s (%s)', [qParametersForCategory.ParentCaption.AsString,
        FqParametersForCategory.Caption.AsString]),
        qParametersForCategory.Caption.AsString);

      // Создаём список значений параметра
      AParamValues := TParamValues.Create
        (ACaption, FqParametersForCategory.ParameterID.AsInteger);

      // Выбираем значения из БД
      FqUniqueParameterValues.SearchEx(AProductCategoryID,
        FqParametersForCategory.ParameterID.AsInteger);
      ASortList.Clear;
      while not FqUniqueParameterValues.FDQuery.Eof do
      begin
        ASortList.Add(FqUniqueParameterValues.Value.AsString);
        FqUniqueParameterValues.FDQuery.Next;
      end;
      // Сортируем
      TStringListSort.Sort(ASortList, False, True);
      for I := 0 to ASortList.Count - 1 do
      begin
        AParamValues.Table.AppendRec(I, ASortList[I]);
      end;

      ParamValuesList.Add(AParamValues);
      FqParametersForCategory.FDQuery.Next;
    end;
    // Создаём набор данныых в памятиж
    FDMemTable.CreateDataSet;

    // Добавляем в него одну запись
    FDMemTable.Append;
    for I := 0 to ARecHolder.Count - 1 do
    begin
      F := FDMemTable.FindField(ARecHolder.Items[i].FieldName);
      if F = nil then
        Continue;

      F.Value := ARecHolder.Items[i].Value;
    end;

    FDMemTable.Post;
  finally
    FreeAndNil(ASortList);
  end;
end;

constructor TParameterValuesTable.Create(AOwner: TComponent);
begin
  inherited;
  FieldDefs.Add('ID', ftInteger, 0, True);
  FieldDefs.Add('Value', ftWideString, 100, True);

  CreateDataSet;
end;

procedure TParameterValuesTable.AppendRec(const AID: Integer;
  const AValue: string);
begin
  Assert(not AValue.IsEmpty);
  AppendRecord([AID, AValue]);
end;

function TParameterValuesTable.GetValue: TField;
begin
  Result := FieldByName('Value');
end;

constructor TParamValues.Create(const ACaption: String; AParameterID: Integer);
begin
  Assert(not ACaption.IsEmpty);
  Assert(AParameterID > 0);

  FParameterID := AParameterID;
  FCaption := ACaption;
  FTable := TParameterValuesTable.Create(nil);
end;

destructor TParamValues.Destroy;
begin
  FreeAndNil(FTable);
  inherited;
end;

function TParamValuesList.FindByParameterID(AParameterID: Integer):
    TParamValues;
begin
  for Result in Self do
  begin
    if Result.ParameterID = AParameterID then
      Exit;
  end;

  Result := nil;
end;

end.
