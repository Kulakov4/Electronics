unit BodyTypesGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, BodyKindsQuery, BodyTypesQuery2, FireDAC.Comp.Client,
  NotifyEvents, BodyTypesExcelDataModule3, BodyTypesBranchQuery,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit,
  QueryGroupUnit, ProducersQuery, OrderQuery, BodiesQuery;

type
  TBodyTypesGroup = class(TQueryGroup)
    qBodyKinds: TQueryBodyKinds;
    qBodyTypes2: TQueryBodyTypes2;
    qBodyTypesBranch: TQueryBodyTypesBranch;
    qProducers: TQueryProducers;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterOpen(Sender: TObject);
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable3);
    // TODO: Append
    /// / TODO: InsertRecordList
    /// /  procedure InsertRecordList(ABodyTypesExcelTable: TBodyTypesExcelTable);
    // function Append(APackage, AOutlineDrawing, ALandPattern, AVariation: String):
    // Integer;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses Data.DB, BodyTypesTreeQuery;

constructor TBodyTypesGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qBodyKinds;
  Detail := qBodyTypes2;

  qBodyTypes2.QueryBodyTypesBranch := qBodyTypesBranch;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qBodyKinds.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyKinds.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qBodyTypes2.AfterOpen, DoAfterOpen);

  // Для каскадного удаления
  TNotifyEventWrap.Create(qBodyKinds.BeforeDelete, DoBeforeDelete);
end;

procedure TBodyTypesGroup.DoAfterOpen(Sender: TObject);
begin
  // Загружаем справочник корпусов 1-го уровня
  // qBodyTypesBranch1.Load(1);
  // Загружаем справочник корпусов 2-го уровня
  // qBodyTypesBranch2.Load(2);
end;

procedure TBodyTypesGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TBodyTypesGroup.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем типы корпусов
  qBodyTypes2.CascadeDelete(qBodyKinds.PKValue,
    qBodyTypes2.IDBodyKind.FieldName);
end;

procedure TBodyTypesGroup.InsertRecordList(ABodyTypesExcelTable
  : TBodyTypesExcelTable3);
begin
  ABodyTypesExcelTable.DisableControls;
  try
    ABodyTypesExcelTable.First;
    ABodyTypesExcelTable.CallOnProcessEvent;
    while not ABodyTypesExcelTable.Eof do
    begin
      // ищем или добавляем корень - вид корпуса
      qBodyKinds.LocateOrAppend(ABodyTypesExcelTable.BodyKind.AsString);
{
      qBodyTypes2.LocateOrAppend(qBodyKinds.PKValue,
        ABodyTypesExcelTable.BodyType.AsString,
        ABodyTypesExcelTable.Package.AsString,
        ABodyTypesExcelTable.OutlineDrawing.AsString,
        ABodyTypesExcelTable.LandPattern.AsString,
        ABodyTypesExcelTable.Variation.AsString,
        ABodyTypesExcelTable.Image.AsString);
}
      ABodyTypesExcelTable.Next;
      ABodyTypesExcelTable.CallOnProcessEvent;
    end;

  finally
    ABodyTypesExcelTable.EnableControls;
  end;

end;

end.
