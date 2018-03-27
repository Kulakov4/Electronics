unit ChildCategoriesQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit,
  SearchCategoryQuery;

type
  TQueryChildCategories = class(TQueryWithDataSource)
    FDUpdateSQL: TFDUpdateSQL;
  private
    FqSearchCategory: TQuerySearchCategory;
    function GetExternalID: TField;
    function GetOrd: TField;
    function GetParentExternalId: TField;
    function GetParentID: TField;
    function GetqSearchCategory: TQuerySearchCategory;
    function GetValue: TField;
    { Private declarations }
  protected
    procedure DoAfterOpen(Sender: TObject);
    property qSearchCategory: TQuerySearchCategory read GetqSearchCategory;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddCategory(const AValue: String);
    function CheckPossibility(const AParentID: Integer;
      const AValue: String): Boolean;
    function GetLevel: Integer;
    property ExternalID: TField read GetExternalID;
    property Ord: TField read GetOrd;
    property ParentExternalId: TField read GetParentExternalId;
    property ParentID: TField read GetParentID;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

uses
  NotifyEvents;

{$R *.dfm}

constructor TQueryChildCategories.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ParentId';
  TNotifyEventWrap.Create(AfterOpen, DoAfterOpen, FEventList);
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
    TryPost;
    AExternalID := qSearchCategory.CalculateExternalId( AParentID, ALevel );
//    AExternalID := CalculateExternalId(AParentID, ALevel);

    TryAppend;
    Value.AsString := AValue;
    ParentID.AsInteger := AParentID;
    ExternalID.AsString := AExternalID;
    TryPost;
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

procedure TQueryChildCategories.DoAfterOpen(Sender: TObject);
begin
  ParentExternalId.Required := False;
end;

function TQueryChildCategories.GetExternalID: TField;
begin
  Result := Field('ExternalID');
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
  while not qSearchCategory.ParentID.IsNull do
  begin
    Inc(Result);
    qSearchCategory.SearchByID(qSearchCategory.ParentID.AsInteger, 1);
  end;
end;

function TQueryChildCategories.GetOrd: TField;
begin
  Result := Field('Ord');
end;

function TQueryChildCategories.GetParentExternalId: TField;
begin
  Result := Field('ParentExternalId');
end;

function TQueryChildCategories.GetParentID: TField;
begin
  Result := Field('ParentID');
end;

function TQueryChildCategories.GetqSearchCategory: TQuerySearchCategory;
begin
  if FqSearchCategory = nil then
    FqSearchCategory := TQuerySearchCategory.Create(Self);

  Result := FqSearchCategory;
end;

function TQueryChildCategories.GetValue: TField;
begin
  Result := Field('Value');
end;

end.
