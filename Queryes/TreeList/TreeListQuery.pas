unit TreeListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, QueryWithDataSourceUnit;

type
  TQueryTreeList = class(TQueryWithDataSource)
  private
    function CalculateExternalId(ParentId, ALevel: Integer): string;
    function GetExternalID: TField;
    function GetIsRootFocused: Boolean;
    function GetParentID: TField;
    function GetValue: TField;
    { Private declarations }
  protected
  public
    procedure AddChildCategory(const AValue: string; ALevel: Integer);
    procedure AddRoot;
    function CheckPossibility(ParentId: Integer; value: string): Boolean;
    procedure FilterByExternalID(AExternalID: string);
    function LocateByExternalID(AExternalID: string): Boolean;
    procedure LocateToRoot;
    property ExternalID: TField read GetExternalID;
    property IsRootFocused: Boolean read GetIsRootFocused;
    property ParentID: TField read GetParentID;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

uses System.Generics.Collections, ProjectConst;

{$R *.dfm}

procedure TQueryTreeList.AddChildCategory(const AValue: string; ALevel:
    Integer);
var
  AParentId: Variant;
  AExternalId: string;
begin
  Assert(FDQuery.RecordCount > 0);
  AParentId := PK.Value;

  if not CheckPossibility(AParentId, AValue) then
    Exit;

  TryPost;

  AExternalId := CalculateExternalId(AParentId, ALevel);
  TryAppend;
  Value.AsString := AValue;
  ParentID.AsInteger := AParentId;
  ExternalID.AsString := AExternalId;
  TryPost;
end;

// Добавляет корень дерева
procedure TQueryTreeList.AddRoot;
begin
  Assert(FDQuery.State = dsBrowse);
  if FDQuery.RecordCount = 0 then
  begin
    TryAppend;
    Value.AsString := sTreeRootNodeName;
    ExternalID.AsString := '00000';
    TryPost;
  end;
end;

function TQueryTreeList.CalculateExternalId(ParentId, ALevel: Integer):
    string;
var
  AQuery: TFDQuery;
  vLevel, vId, vInteger: Integer;
  vLevelStr, vExternalId: string;
  vIntegers: TList<Integer>;
begin
  vLevel := ALevel - 1;
  vLevelStr := Format('%.2d', [vLevel]);
  Result := '';

  AQuery := TFDQuery.Create(nil);
  vIntegers := TList<Integer>.Create;
  try
    AQuery.Connection := FDQuery.Connection;
    AQuery.Params.CreateParam(ftString, 'vPartOfExternalId', ptInput);
    AQuery.ParamByName('vPartOfExternalId').AsString := vLevelStr + '%';
    AQuery.SQL.Add
      ('select * from ProductCategories where externalId like :vPartOfExternalId');
    AQuery.Open();
    AQuery.First;
    while not AQuery.Eof do
    begin
      vExternalId := AQuery.FieldByName('ExternalId').AsString;
      Delete(vExternalId, 1, 2); // удалить 2 символа в начале
      vIntegers.Add(StrToInt(vExternalId));
      AQuery.Next;
    end;
    vIntegers.Sort;
    vId := 1;
    for vInteger in vIntegers do
    begin
      if vInteger <> vId then
        Break;
      vId := vId + 1;
    end;
    Result := vLevelStr + Format('%.3d', [vId]);
  finally
    AQuery.Free;
    vIntegers.Free;
  end;
end;

function TQueryTreeList.CheckPossibility(ParentId: Integer; value: string):
    Boolean;
var
  AQuery: TFDQuery;
begin
//  Result := false;
  AQuery := TFDQuery.Create(nil);
  try
    AQuery.Connection := FDQuery.Connection;
    AQuery.Params.CreateParam(ftInteger, 'vId', ptInput);
    AQuery.ParamByName('vId').AsInteger := ParentId;
    AQuery.Params.CreateParam(ftString, 'vValue', ptInput);
    AQuery.ParamByName('vValue').AsString := value;
    AQuery.SQL.Add
      ('select * from ProductCategories where ParentId = :vId and value LIKE :vValue');
    AQuery.Open();
    Result := AQuery.RecordCount = 0;
  finally
    AQuery.Free;
  end;
end;

procedure TQueryTreeList.FilterByExternalID(AExternalID: string);
begin
  if AExternalID.Length > 0 then
  begin
    FDQuery.Filter := Format('ExternalID = ''%s*''', [AExternalID]);
    FDQuery.Filtered := True;
  end
  else
    FDQuery.Filtered := False;
end;

function TQueryTreeList.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQueryTreeList.GetIsRootFocused: Boolean;
begin
  Result := (FDQuery.RecordCount > 0) and (ParentID.IsNull);
end;

function TQueryTreeList.GetParentID: TField;
begin
  Result := Field('ParentID');
end;

function TQueryTreeList.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQueryTreeList.LocateByExternalID(AExternalID: string): Boolean;
begin
  Assert(not AExternalID.IsEmpty);
  Result := FDQuery.LocateEx(ExternalID.FieldName, AExternalID, []);
end;

procedure TQueryTreeList.LocateToRoot;
begin
  FDQuery.LocateEx(ParentID.FieldName, NULL, []);
end;

end.
