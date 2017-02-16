unit SearchCategoryByID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQuerySearchCategoryByID = class(TQueryBase)
  private
    function GetExternalID: TField;
    { Private declarations }
  protected
  public
    function Search(const AID: Integer): Integer; overload;
    property ExternalID: TField read GetExternalID;
    { Public declarations }
  end;


implementation

{$R *.dfm}

function TQuerySearchCategoryByID.GetExternalID: TField;
begin
  Result := Field('ExternalID');
end;

function TQuerySearchCategoryByID.Search(const AID: Integer): Integer;
begin
  Assert(AID > 0);
  Result := Search(['ID'], [AID]);
end;

end.
