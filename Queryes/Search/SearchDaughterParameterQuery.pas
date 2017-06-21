unit SearchDaughterParameterQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchDaughterParameter = class(TQueryBase)
    procedure FDQueryAfterOpen(DataSet: TDataSet);
  private
    function GetParentParameter: TField;
    function GetValue: TField;
    { Private declarations }
  public
    procedure Append(const AValue: String);
    function Search(const AValue: String; AParentID: Integer): Integer;
      overload;
    property ParentParameter: TField read GetParentParameter;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQuerySearchDaughterParameter.Append(const AValue: String);
var
  AParentParameter: Integer;
begin
  Assert(not AValue.IsEmpty);
  AParentParameter := FDQuery.ParamByName('ParentParameter').AsInteger;
  Assert(AParentParameter > 0);
  FDQuery.Append;
  Value.AsString := AValue;
  ParentParameter.AsInteger := AParentParameter;
  FDQuery.Post;
end;

procedure TQuerySearchDaughterParameter.FDQueryAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetFieldsRequired(False);
end;

function TQuerySearchDaughterParameter.GetParentParameter: TField;
begin
  Result := Field('ParentParameter');
end;

function TQuerySearchDaughterParameter.GetValue: TField;
begin
  Result := Field('Value');
end;

function TQuerySearchDaughterParameter.Search(const AValue: String;
  AParentID: Integer): Integer;
begin
  Assert(not AValue.IsEmpty);
  Assert(AParentID > 0);

  Result := Search(['Value', 'ParentParameter'], [AValue, AParentID]);
end;

end.
