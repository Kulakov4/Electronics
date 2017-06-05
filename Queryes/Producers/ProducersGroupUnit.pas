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
  protected
    procedure DoAfterDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertRecordList(AProducersExcelTable: TProducersExcelTable);
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB, NotifyEvents;

constructor TProducersGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qProducerTypes;
  Detail := qProducers;

  // Для каскадного удаления
  TNotifyEventWrap.Create(qProducerTypes.AfterDelete, DoAfterDelete);
end;

procedure TProducersGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(qProducerTypes.OldPKValue > 0);
  // Каскадно удаляем производителей
  qProducers.CascadeDelete(qProducerTypes.OldPKValue, qProducers.ProducerTypeID.FieldName, True);
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
    // Цикл по всем записям, которые будем добавлять
    AProducersExcelTable.First;
    AProducersExcelTable.CallOnProcessEvent;
    while not AProducersExcelTable.Eof do
    begin
      qProducerTypes.LocateOrAppend(AProducersExcelTable.ProducerType.AsString.Trim);

      // Если производитель с таким именем уже есть
      if qProducers.Locate( AProducersExcelTable.Name.AsString.Trim ) then
        qProducers.TryEdit
      else
        qProducers.TryAppend;

      // Связываем производителя с его типом
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
