unit SearchDescriptionsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, ProgressInfo, HandlingQueryUnit, DSWrap;

type
  TSearchDescriptionW = class(TDSWrap)
  private
    FDescrID: TFieldWrap;
    FID: TFieldWrap;
    FDescriptionID: TFieldWrap;
    FProductCategoryId: TParamWrap;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    property DescrID: TFieldWrap read FDescrID;
    property ID: TFieldWrap read FID;
    property DescriptionID: TFieldWrap read FDescriptionID;
    property ProductCategoryId: TParamWrap read FProductCategoryId;
  end;

  TQuerySearchDescriptions = class(THandlingQuery)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FW: TSearchDescriptionW;
    { Private declarations }
  protected
    property W: TSearchDescriptionW read FW;
  public
    constructor Create(AOwner: TComponent); override;
    function Search(const AIDCategory: Integer): Integer; overload;
    procedure SearchAll;
    procedure UpdateComponentDescriptions(ASender: TObject);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses ProgressBarForm, StrHelper;

constructor TQuerySearchDescriptions.Create(AOwner: TComponent);
begin
  inherited;
  FW := TSearchDescriptionW.Create(FDQuery);
end;

function TQuerySearchDescriptions.Search(const AIDCategory: Integer): Integer;
var
  ASQL: string;
begin
  Assert(AIDCategory > 0);

  ASQL := SQL;
  // Раскомментируем в запросе JOIN
  ASQL := ASQL.Replace('/* ProductCategory', '', [rfReplaceAll]);
  ASQL := ASQL.Replace('ProductCategory */', '', [rfReplaceAll]);

  // Формируем запрос
  FDQuery.SQL.Text := ASQL;

  SetParamType(W.ProductCategoryId.FieldName);
  Result := Search([W.ProductCategoryId.FieldName], [AIDCategory]);
end;

procedure TQuerySearchDescriptions.SearchAll;
begin
  // Возвращаем базовый запрос
  FDQuery.SQL.Text := SQL;
  RefreshQuery;
end;

procedure TQuerySearchDescriptions.UpdateComponentDescriptions
  (ASender: TObject);
var
  i: Integer;
begin
  Assert(FDQuery.Active);

  // начинаем транзакцию, если она ещё не началась
  if (not FDQuery.Connection.InTransaction) then
    FDQuery.Connection.StartTransaction;

  FDQuery.Last;
  FDQuery.First;
  i := 0;

  CallOnProcessEvent;
  while not FDQuery.Eof do
  begin
    // Связываем компоненты со своими описаниями
    if W.DescriptionID.F.AsInteger <> W.DescrID.F.AsInteger then
    begin
      W.TryEdit;
      W.DescriptionID.F.AsInteger := W.DescrID.F.AsInteger;
      W.TryPost;
      Inc(i);
      // Уже много записей обновили в рамках одной транзакции
      if i >= 1000 then
      begin
        i := 0;
        FDQuery.Connection.Commit;
        FDQuery.Connection.StartTransaction;
      end;
    end;
    FDQuery.Next;
    CallOnProcessEvent;
  end;

  FDQuery.Connection.Commit;

end;

constructor TSearchDescriptionW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'p.ID', '', True);
  FDescrID := TFieldWrap.Create(Self, 'DescrID');
  FDescriptionID := TFieldWrap.Create(Self, 'p.DescriptionID');

  FProductCategoryId := TParamWrap.Create(Self, 'ppc.ProductCategoryId');
end;

end.
