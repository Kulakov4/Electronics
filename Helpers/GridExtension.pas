unit GridExtension;

interface

uses
  cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, StdCtrls, cxCustomData,
  cxGridBandedTableView,
  System.Classes, cxGridDBBandedTableView, Data.DB;

type

  TcxMyGridMasterDataRow = class(TcxGridMasterDataRow)
    CanExpand: boolean;
    function GetExpandable: boolean; override;
  public
    procedure MyCollapse(ARecurse: boolean);
    procedure MyExpand(ARecurse: boolean);
  end;

  TcxMyGridViewData = class(TcxGridViewData)
    function GetRecordClass(const ARecordInfo: TcxRowInfo)
      : TcxCustomGridRecordClass; override;
  end;

  TcxGridDBBandedTableViewWithoutExpand = class(TcxGridDBBandedTableView)
  protected
    function GetViewDataClass: TcxCustomGridViewDataClass; override;
  end;

implementation

uses cxDBLookupComboBox, System.SysUtils;

{ TcxMyGridMasterDataRow }

function TcxMyGridMasterDataRow.GetExpandable: boolean;
begin
  Result := inherited GetExpandable and CanExpand;
end;

procedure TcxMyGridMasterDataRow.MyCollapse(ARecurse: boolean);
begin
  CanExpand := True;
  Collapse(ARecurse);
  CanExpand := False;
end;

procedure TcxMyGridMasterDataRow.MyExpand(ARecurse: boolean);
begin
  CanExpand := True;
  Expand(ARecurse);
  CanExpand := False;
end;

{ TcxMyGridViewData }

function TcxMyGridViewData.GetRecordClass(const ARecordInfo: TcxRowInfo)
  : TcxCustomGridRecordClass;
begin
  Result := nil;
  if Inherited GetRecordClass(ARecordInfo) = TcxGridMasterDataRow then
    Result := TcxMyGridMasterDataRow;
end;

function TcxGridDBBandedTableViewWithoutExpand.GetViewDataClass
  : TcxCustomGridViewDataClass;
begin
  Result := TcxMyGridViewData;
end;

end.
