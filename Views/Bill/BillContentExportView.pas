unit BillContentExportView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridFrame, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit,
  cxNavigator, dxDateRanges, Data.DB, cxDBData, dxBarBuiltInMenu,
  cxGridCustomPopupMenu, cxGridPopupMenu, Vcl.Menus, System.Actions,
  Vcl.ActnList, dxBar, cxClasses, Vcl.ComCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridBandedTableView,
  cxGridDBBandedTableView, cxGrid, BillContentExportQry;

type
  TViewBillContentExport = class(TfrmGrid)
  private
    function GetW: TBillContentExportW;
    procedure SetW(const Value: TBillContentExportW);
    { Private declarations }
  public
    property W: TBillContentExportW read GetW write SetW;
    { Public declarations }
  end;

implementation

{$R *.dfm}

function TViewBillContentExport.GetW: TBillContentExportW;
begin
  Result := DSWrap as TBillContentExportW;
end;

procedure TViewBillContentExport.SetW(const Value: TBillContentExportW);
begin
  if DSWrap = Value then
    Exit;

  DSWrap := Value;
end;

end.
