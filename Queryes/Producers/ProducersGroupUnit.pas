unit ProducersGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, QueryGroupUnit, Vcl.ExtCtrls,
  ProducersQuery, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  QueryWithDataSourceUnit, ProducerTypesQuery, ProducersExcelDataModule,
  OrderQuery;

type
  TProducersGroup = class(TQueryGroup)
    qProducerTypes: TQueryProducerTypes;
    qProducers: TQueryProducers;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertRecordList(AProducersExcelTable: TProducersExcelTable);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB;

constructor TProducersGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qProducerTypes;
  Detail := qProducers;
end;

procedure TProducersGroup.InsertRecordList(AProducersExcelTable:
    TProducersExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qProducerTypes.FDQuery.DisableControls;
  qProducers.FDQuery.DisableControls;
  try
    // ÷икл по всем запис€м, которые будем добавл€ть
    AProducersExcelTable.First;
    AProducersExcelTable.CallOnProcessEvent;
    while not AProducersExcelTable.Eof do
    begin
      qProducerTypes.LocateOrAppend(AProducersExcelTable.ProducerType.AsString.Trim);

      // ≈сли производитель с таким именем уже есть
      if qProducers.Locate( AProducersExcelTable.Name.AsString.Trim ) then
        qProducers.TryEdit
      else
        qProducers.TryAppend;

      // —в€зываем производител€ с его типом
      qProducers.ProducerTypeID.AsInteger := qProducerTypes.PKValue;

      for I := 0 to AProducersExcelTable.FieldCount - 1 do
      begin
        AField := qProducers.FDQuery.FindField(AProducersExcelTable.Fields[I]
          .FieldName);
        if AField <> nil then
          AField.Value := AProducersExcelTable.Fields[I].Value;
      end;

      qProducers.TryPost;

      AProducersExcelTable.Next;
      AProducersExcelTable.CallOnProcessEvent;
    end;

  finally
    qProducers.FDQuery.EnableControls;
    qProducerTypes.FDQuery.EnableControls;
  end;
end;

end.
