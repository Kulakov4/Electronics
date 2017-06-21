unit ParametersForCategoriesGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, ParametersDetailQuery, ParameterTypesQuery,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, OrderQuery;

type
  TParametersForCategoriesGroup = class(TQueryGroup)
    qParameterTypes: TQueryParameterTypes;
    qParametersDetail: TQueryParametersDetail;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure RefreshDetail(AIDParameterType: Integer);
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TParametersForCategoriesGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qParameterTypes;
  Detail := qParametersDetail;
end;

procedure TParametersForCategoriesGroup.RefreshDetail(AIDParameterType
  : Integer);
begin
  // if qParametersDetail.FDQuery.ParamByName('ParameterGroupType').AsString <> AIDParameterType then
  // begin
  qParametersDetail.Load(['IDParameterType'], [AIDParameterType]);
  // end;
end;

end.
