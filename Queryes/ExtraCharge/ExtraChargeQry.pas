unit ExtraChargeQry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseFDQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, DSWrap,
  ExtraChargeExcelDataModule;

type
  TExtraChargeW = class;

  TQryExtraCharge = class(TQryBase)
  private
    FW: TExtraChargeW;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property W: TExtraChargeW read FW;
    { Public declarations }
  end;

  TExtraChargeW = class(TDSWrap)
  private
    FRange: TFieldWrap;
    FWholeSale: TFieldWrap;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDataFromExcelTable(AExcelTable: TExtraChargeExcelTable);
    function LocateByRange(ARange: string): Boolean;
    property Range: TFieldWrap read FRange;
    property WholeSale: TFieldWrap read FWholeSale;
  end;

implementation

constructor TExtraChargeW.Create(AOwner: TComponent);
begin
  inherited;
  FRange := TFieldWrap.Create(Self, 'Range');
  FWholeSale := TFieldWrap.Create(Self, 'WholeSale');
end;

procedure TExtraChargeW.LoadDataFromExcelTable(AExcelTable:
    TExtraChargeExcelTable);
begin
  // FDQuery.DisableControls;
  try
    AExcelTable.First;
    while not AExcelTable.Eof do
    begin
      // Если такой диапазон уже есть
      if LocateByRange(AExcelTable.Range.Value) then
        TryEdit
      else
        TryAppend;

      Range.F.Value := AExcelTable.Range.Value;
      WholeSale.F.Value := AExcelTable.WholeSale.Value;
      TryPost;

      AExcelTable.Next;
    end;
  finally
    // FDQuery.EnableControls;
  end;
end;

function TExtraChargeW.LocateByRange(ARange: string): Boolean;
begin
  Result := FDDataSet.LocateEx(Range.FieldName, ARange, []);
end;

constructor TQryExtraCharge.Create(AOwner: TComponent);
begin
  inherited;
  FW := TExtraChargeW.Create(FDQuery);
  FDQuery.OnUpdateRecord := DoOnQueryUpdateRecord;
end;


{$R *.dfm}

end.
