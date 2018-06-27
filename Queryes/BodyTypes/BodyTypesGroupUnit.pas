unit BodyTypesGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, BodyKindsQuery, BodyTypesQuery2, FireDAC.Comp.Client,
  NotifyEvents, BodyTypesExcelDataModule, QueryWithDataSourceUnit,
  BaseQuery, BaseEventsQuery, QueryWithMasterUnit, QueryGroupUnit,
  ProducersQuery, OrderQuery, BodiesQuery, BodyTypesSimpleQuery,
  BodyTypesBaseQuery, DocFieldInfo, System.IOUtils;

type
  TBodyTypesGroup = class(TQueryGroup)
  private
    FqBodyKinds: TQueryBodyKinds;
    FqBodyTypes2: TQueryBodyTypes2;
    FqProducers: TQueryProducers;
    FQueryBodyTypesSimple: TQueryBodyTypesSimple;
    procedure DoAfterDelete(Sender: TObject);
    function GetqBodyKinds: TQueryBodyKinds;
    function GetqBodyTypes2: TQueryBodyTypes2;
    function GetqProducers: TQueryProducers;
    function GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadDataFromExcelTable(ABodyTypesExcelTable: TBodyTypesExcelTable;
      AIDProducer: Integer);
    procedure Rollback; override;
    property qBodyKinds: TQueryBodyKinds read GetqBodyKinds;
    property qBodyTypes2: TQueryBodyTypes2 read GetqBodyTypes2;
    property qProducers: TQueryProducers read GetqProducers;
    property QueryBodyTypesSimple: TQueryBodyTypesSimple
      read GetQueryBodyTypesSimple;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB;

constructor TBodyTypesGroup.Create(AOwner: TComponent);
begin
  inherited;
  QList.Add(qBodyKinds);
  QList.Add(qBodyTypes2);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qBodyKinds.AfterDelete, DoAfterDelete, EventList);
end;

procedure TBodyTypesGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(qBodyKinds.OldPKValue > 0);
  // Каскадно удаляем типы корпусов
  qBodyTypes2.CascadeDelete(qBodyKinds.OldPKValue,
    qBodyTypes2.IDBodyKind.FieldName, True);
end;

function TBodyTypesGroup.GetqBodyKinds: TQueryBodyKinds;
begin
  if FqBodyKinds = nil then
    FqBodyKinds := TQueryBodyKinds.Create(Self);

  Result := FqBodyKinds;
end;

function TBodyTypesGroup.GetqBodyTypes2: TQueryBodyTypes2;
begin
  if FqBodyTypes2 = nil then
    FqBodyTypes2 := TQueryBodyTypes2.Create(Self);

  Result := FqBodyTypes2;
end;

function TBodyTypesGroup.GetqProducers: TQueryProducers;
begin
  if FqProducers = nil then
    FqProducers := TQueryProducers.Create(Self);
  Result := FqProducers;
end;

function TBodyTypesGroup.GetQueryBodyTypesSimple: TQueryBodyTypesSimple;
begin
  if FQueryBodyTypesSimple = nil then
  begin
    FQueryBodyTypesSimple := TQueryBodyTypesSimple.Create(Self);
  end;

  Result := FQueryBodyTypesSimple;
end;

procedure TBodyTypesGroup.LoadDataFromExcelTable(ABodyTypesExcelTable
  : TBodyTypesExcelTable; AIDProducer: Integer);
var
  AField: TField;
  AProducerID: Integer;
  F: TField;
begin
  ABodyTypesExcelTable.DisableControls;
  try
    QueryBodyTypesSimple.RefreshQuery;

    ABodyTypesExcelTable.First;
    ABodyTypesExcelTable.CallOnProcessEvent;
    QueryBodyTypesSimple.ClearUpdateRecCount;
    while not ABodyTypesExcelTable.Eof do
    begin
      if AIDProducer > 0 then
        AProducerID := AIDProducer
      else
        AProducerID := (ABodyTypesExcelTable as TBodyTypesExcelTable2).IDProducer.AsInteger;

      // ищем или добавляем корень - вид корпуса
      qBodyKinds.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);

      QueryBodyTypesSimple.TryAppend;
      QueryBodyTypesSimple.IDProducer.AsInteger := AProducerID;
      QueryBodyTypesSimple.IDBodyKind.Value := qBodyKinds.PK.Value;
      QueryBodyTypesSimple.Variations.AsString :=
        ABodyTypesExcelTable.Variation.AsString;
      QueryBodyTypesSimple.JEDEC.AsString :=
        ABodyTypesExcelTable.JEDEC.AsString;
      QueryBodyTypesSimple.Options.AsString :=
        ABodyTypesExcelTable.Options.AsString;

      for AField in ABodyTypesExcelTable.Fields do
      begin
        F := QueryBodyTypesSimple.FDQuery.FindField(AField.FieldName);
        if F <> nil then
          F.Value := AField.Value;
      end;

      QueryBodyTypesSimple.TryPost;
      QueryBodyTypesSimple.IncUpdateRecCount;

      ABodyTypesExcelTable.Next;
      ABodyTypesExcelTable.CallOnProcessEvent;
    end;
    // Финальный коммит
    QueryBodyTypesSimple.FDQuery.Connection.Commit;

    // Обновляем данные в сгруппированном запросе
    qBodyTypes2.RefreshQuery;
  finally
    ABodyTypesExcelTable.EnableControls;
  end;

end;

procedure TBodyTypesGroup.Rollback;
begin
  inherited;
  qBodyTypes2.RefreshLinkedData;
end;

end.
