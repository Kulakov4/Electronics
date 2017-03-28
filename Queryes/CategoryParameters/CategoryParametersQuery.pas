unit CategoryParametersQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryWithDataSourceUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TQueryCategoryParameters = class(TQueryWithDataSource)
  private
    function GetPosID: TField;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetPos(APosID: Integer);
    property PosID: TField read GetPosID;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryCategoryParameters.Create(AOwner: TComponent);
begin
  inherited;
  DetailParameterName := 'ProductCategoryID';
end;

function TQueryCategoryParameters.GetPosID: TField;
begin
  Result := Field('PosID');
end;

procedure TQueryCategoryParameters.SetPos(APosID: Integer);
begin
  Assert(FDQuery.RecordCount > 0);
  Assert((APosID >= 0) and (APosID <= 2));
  TryEdit;
  PosID.AsInteger := APosID;
  TryPost;
end;

end.
