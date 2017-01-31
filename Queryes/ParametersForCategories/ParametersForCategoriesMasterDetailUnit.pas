unit ParametersForCategoriesMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MasterDetailFrame, Vcl.ExtCtrls, ParametersDetailQuery,
  ParameterTypesQuery, QueryWithDataSourceUnit, BaseQuery;

type
  TParametersForCategoriesMasterDetail = class(TfrmMasterDetail)
    qParametersDetail: TfrmParametersDetailQuery;
    qParameterTypes: TQueryParameterTypes;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshDetail(AIDParameterType: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TParametersForCategoriesMasterDetail.Create(AOwner:
    TComponent);
begin
  inherited;
  Main := qParameterTypes;
  Detail := qParametersDetail;
end;

procedure TParametersForCategoriesMasterDetail.RefreshDetail(AIDParameterType:
    Integer);
begin
//  if qParametersDetail.FDQuery.ParamByName('ParameterGroupType').AsString <> AIDParameterType then
//  begin
    qParametersDetail.Load(['IDParameterType'], [AIDParameterType]);
//  end;
end;

end.
