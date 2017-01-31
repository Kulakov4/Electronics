unit TreeListQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit;

type
  TQueryTreeList = class(TQueryWithDataSource)
  private
    function CalculateExternalId(ParentId, ALevel: Integer): string;
    function GetIsRootFocused: Boolean;
    function GetValue: TField;
    { Private declarations }
  public
    procedure AddChildCategory(value: string; ALevel: Integer);
    procedure AddRoot;
    function CheckPossibility(ParentId: Integer; value: string): Boolean;
    procedure FilterByExternalID(AExternalID: string);
    procedure LocateToRoot;
    property IsRootFocused: Boolean read GetIsRootFocused;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

uses System.Generics.Collections;

{$R *.dfm}

procedure TQueryTreeList.AddChildCategory(value: string; ALevel: Integer);
var
  vParentId: Integer;
  vExternalId: string;
begin
  vParentId := FDQuery.FieldByName('Id').AsInteger;

  if not CheckPossibility(vParentId, value) then
    Exit;

  TryPost;

  vExternalId := CalculateExternalId(vParentId, ALevel);
  FDQuery.Append;
  FDQuery.FieldByName('Value').AsString := value;
  FDQuery.FieldByName('ParentId').AsInteger := vParentId;
  FDQuery.FieldByName('ExternalId').AsString := vExternalId;
  FDQuery.Post;
  FDQuery.Refresh;
end;

// Добавляет корень дерева
procedure TQueryTreeList.AddRoot;
begin
  Assert(FDQuery.State = dsBrowse);
  if FDQuery.RecordCount = 0 then
  begin
    FDQuery.Append;
    FDQuery.FieldByName('Id').AsInteger := 0;
    FDQuery.FieldByName('Value').AsString := 'Структура';
    FDQuery.FieldByName('ParentId').AsInteger := -1;
    FDQuery.Post;
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

function TQueryTreeList.GetIsRootFocused: Boolean;
begin
  Result := PKValue = 1;
end;

function TQueryTreeList.GetValue: TField;
begin
  Result := FDQuery.FieldByName('Value');
end;

procedure TQueryTreeList.LocateToRoot;
begin
//  LockScroll := True;
  try
    FDQuery.Locate('Id', 1, []);
  finally
//    LockScroll := False;
  end;
//  AfterScroll.CallEventHandlers(FDQuery);
end;

end.
