unit AnalogQueryes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ParametersForCategoryQuery, TableWithProgress, Data.DB,
  System.Generics.Collections, UniqueParameterValuesQuery, Sort.StringList,
  System.StrUtils;

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
    FOrd: Integer;
    FPosID: Integer;
    FTable: TParameterValuesTable;
  public
    constructor Create(APosID, AOrder: Integer; const ACaption: String);
    destructor Destroy; override;
    property Caption: String read FCaption;
    property Ord: Integer read FOrd;
    property PosID: Integer read FPosID;
    property Table: TParameterValuesTable read FTable;
  end;

  TAnalogGroup = class(TQueryGroup)
  private
    FParamValuesList: TList<TParamValues>;
    FqParametersForCategory: TQueryParametersForCategory;
    FqUniqueParameterValues: TQueryUniqueParameterValues;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(AProductCategoryID: Integer);
    property ParamValuesList: TList<TParamValues> read FParamValuesList;
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
  FParamValuesList := TList<TParamValues>.Create;
end;

destructor TAnalogGroup.Destroy;
begin
  FreeAndNil(FParamValuesList);
  inherited;
end;

procedure TAnalogGroup.Load(AProductCategoryID: Integer);
var
  ACaption: String;
  AParamValues: TParamValues;
  ASortList: TStringList;
  I: Integer;
begin
  ASortList := TStringList.Create;
  try

    // Ищем параметры используемые для поиска аналога
    FqParametersForCategory.SearchByParameterKind(AProductCategoryID);
    while not FqParametersForCategory.FDQuery.Eof do
    begin
      ACaption := IfThen(qParametersForCategory.ParentCaption.AsString <> '',
        Format('%s (%s)', [qParametersForCategory.ParentCaption.AsString,
        FqParametersForCategory.Caption.AsString]),
        qParametersForCategory.Caption.AsString);

      // Создаём список значений параметра
      AParamValues := TParamValues.Create
        (FqParametersForCategory.PosID.AsInteger,
        FqParametersForCategory.Ord.AsInteger, ACaption);

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

constructor TParamValues.Create(APosID, AOrder: Integer;
  const ACaption: String);
begin
  FPosID := APosID;
  AOrder := AOrder;
  Assert(not ACaption.IsEmpty);
  FCaption := ACaption;
  FTable := TParameterValuesTable.Create(nil);
end;

destructor TParamValues.Destroy;
begin
  FreeAndNil(FTable);
  inherited;
end;

end.
