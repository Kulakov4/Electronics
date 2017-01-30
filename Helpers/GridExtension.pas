unit GridExtension;

interface

uses
  cxDataStorage, cxEdit, cxDBData, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, StdCtrls, cxCustomData,
  cxGridBandedTableView,
  System.Classes, cxGridDBBandedTableView, Data.DB, DataModuleFrame;

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

procedure InitializeLookupColumn2(AView: TcxGridTableView; AFieldName: string;
  ADataSource: TDataSource);

implementation

uses cxDBLookupComboBox, System.SysUtils;

procedure InitializeLookupColumn2(AView: TcxGridTableView; AFieldName: string;
  ADataSource: TDataSource);
var
  AColumn1: TcxGridDBColumn;
  AColumn2: TcxGridDBBandedColumn;
begin
  if AView is TcxGridDBTableView then
  begin
    AColumn1 := (AView as TcxGridDBTableView).GetColumnByFieldName(AFieldName);
    (AColumn1.Properties as TcxLookupComboBoxProperties).ListSource :=
      ADataSource;
  end
  else if AView is TcxGridDBBandedTableView then
  begin
    AColumn2 := (AView as TcxGridDBBandedTableView).GetColumnByFieldName
      (AFieldName);
    Assert(AColumn2 <> nil);
    (AColumn2.Properties as TcxLookupComboBoxProperties).ListSource :=
      ADataSource;
  end
  else
    raise Exception.Create('Неподдерживаемый класс TcxGridTableView');

end;

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
