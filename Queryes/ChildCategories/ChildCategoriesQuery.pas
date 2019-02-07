unit ChildCategoriesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, SearchCategoryQuery, OrderQuery, DSWrap;

type
  TChildCategoriesW = class(TOrderW)
  private
    FExternalID: TFieldWrap;
    FID: TFieldWrap;
    FParentExternalId: TFieldWrap;
    FParentID: TFieldWrap;
    FValue: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    property ExternalID: TFieldWrap read FExternalID;
    property ID: TFieldWrap read FID;
    property ParentExternalId: TFieldWrap read FParentExternalId;
    property ParentID: TFieldWrap read FParentID;
    property Value: TFieldWrap read FValue;
  end;

  TQueryChildCategories = class(TQueryOrder)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FqSearchCategory: TQuerySearchCategory;
    FW: TChildCategoriesW;
    function GetqSearchCategory: TQuerySearchCategory;
    { Private declarations }
  protected
    function CreateDSWrap: TDSWrap; override;
    procedure DoAfterOpen(Sender: TObject);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory(const AValue: String);
    function CheckPossibility(const AParentID: Integer;
      const AValue: String): Boolean;
    function GetLevel: Integer;
    property W: TChildCategoriesW read FW;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

{$R *.dfm}

constructor TQueryChildCategories.Create(AOwner: TComponent);
begin
  inherited;
  FW := FDSWrap as TChildCategoriesW;
  DetailParameterName := W.ParentID.FieldName;
  TNotifyEventWrap.Create(W.AfterOpen, DoAfterOpen, W.EventList);
end;

procedure TQueryChildCategories.AddCategory(const AValue: String);
var
  AExternalID: string;
  ALevel: Integer;
  AParentID: Integer;
begin
  Assert(not AValue.IsEmpty);

  // Получаем идентификатор дочернего узла
  AParentID := FDQuery.ParamByName(DetailParameterName).AsInteger;
  ALevel := GetLevel;

  FDQuery.DisableControls;
  try
    W.TryPost;
    AExternalID := qSearchCategory.CalculateExternalId( AParentID, ALevel );

    W.TryAppend;
    W.Value.F.AsString := AValue;
    W.ParentID.F.AsInteger := AParentID;
    W.ExternalID.F.AsString := AExternalID;
    W.TryPost;
  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryChildCategories.CheckPossibility(const AParentID: Integer;
  const AValue: String): Boolean;
begin
  Assert(FDQuery.Active);

  Result := qSearchCategory.SearchByParentAndValue(AParentID, AValue) = 0;
end;

function TQueryChildCategories.CreateDSWrap: TDSWrap;
begin
  Result := TChildCategoriesW.Create(FDQuery);
end;

procedure TQueryChildCategories.DoAfterOpen(Sender: TObject);
begin
  W.ParentExternalId.F.Required := False;

  // Порядок будет заполняться на стороне сервера
  OrderW.Ord.F.Required := False;
end;

function TQueryChildCategories.GetLevel: Integer;
var
  AParentID: Integer;
begin
  Assert(FDQuery.Active);
  Result := 1;
  // Получаем идентификатор дочернего узла
  AParentID := FDQuery.ParamByName(DetailParameterName).AsInteger;
  qSearchCategory.SearchByID(AParentID, 1);
  // Пока мы не добрались до корня дерева
  while not qSearchCategory.W.ParentID.F.IsNull do
  begin
    Inc(Result);
    qSearchCategory.SearchByID(qSearchCategory.W.ParentID.F.AsInteger, 1);
  end;
end;

function TQueryChildCategories.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

constructor TChildCategoriesW.Create(AOwner: TComponent);
begin
  inherited;
  FID := TFieldWrap.Create(Self, 'ID', '', True);
  FOrd := TFieldWrap.Create(Self, 'Ord');
  FExternalID := TFieldWrap.Create(Self, 'ExternalID');
  FParentExternalID := TFieldWrap.Create(Self, 'ParentExternalID');
  FParentID := TFieldWrap.Create(Self, 'ParentID');
  FValue := TFieldWrap.Create(Self, 'Value');
end;

end.
