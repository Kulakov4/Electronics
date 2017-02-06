unit DescriptionsMasterDetailUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MasterDetailFrame, Vcl.ExtCtrls, DescriptionsMasterQuery,
  DescriptionsDetailQuery, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  Manufacturers2Query, NotifyEvents, DescriptionsExcelDataModule,
  QueryWithDataSourceUnit, BaseQuery, BaseEventsQuery, QueryWithMasterUnit;

type
  TDescriptionsMasterDetail = class(TfrmMasterDetail)
    qDescriptionsMaster: TQueryDescriptionsMaster;
    qDescriptionsDetail: TQueryDescriptionsDetail;
    qManufacturers2: TQueryManufacturers2;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure Commit; override;
    procedure InsertRecordList(ADescriptionsExcelTable: TDescriptionsExcelTable);
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    { Public declarations }
  end;

implementation

uses
  FireDAC.Comp.DataSet, Data.DB, RepositoryDataModule;

{$R *.dfm}

constructor TDescriptionsMasterDetail.Create(AOwner: TComponent);
begin
  inherited;
  Main := qDescriptionsMaster;
  Detail := qDescriptionsDetail;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qDescriptionsMaster.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptionsMaster.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptionsDetail.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptionsDetail.AfterDelete, DoAfterPostOrDelete);
  // Для каскадного удаления
  TNotifyEventWrap.Create(qDescriptionsMaster.BeforeDelete, DoBeforeDelete);
end;

procedure TDescriptionsMasterDetail.Commit;
begin
  Inherited;
  qManufacturers2.DropUnuses;
end;

procedure TDescriptionsMasterDetail.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TDescriptionsMasterDetail.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем описания
  qDescriptionsDetail.CascadeDelete(qDescriptionsMaster.PKValue, qDescriptionsDetail.IDComponentType.FieldName);
end;

procedure TDescriptionsMasterDetail.InsertRecordList(ADescriptionsExcelTable:
    TDescriptionsExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qDescriptionsDetail.FDQuery.DisableControls;
  qDescriptionsMaster.FDQuery.DisableControls;
  try
    // Цикл по всем записям, которые будем добавлять
    ADescriptionsExcelTable.First;
    ADescriptionsExcelTable.CallOnProcessEvent;
    while not ADescriptionsExcelTable.Eof do
    begin
      qDescriptionsMaster.LocateOrAppend(ADescriptionsExcelTable.ComponentType.AsString);

      qManufacturers2.LocateOrAppend(ADescriptionsExcelTable.Manufacturer.AsString);

      qDescriptionsDetail.FDQuery.Append;

      for I := 0 to ADescriptionsExcelTable.FieldCount - 1 do
      begin
        AField := qDescriptionsDetail.FDQuery.FindField
          (ADescriptionsExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ADescriptionsExcelTable.Fields[I].Value;
      end;
      qDescriptionsDetail.IDComponentType.AsInteger :=
        qDescriptionsMaster.PKValue;
      qDescriptionsDetail.IDManufacturer.AsInteger := qManufacturers2.PKValue;
      qDescriptionsDetail.FDQuery.Post;

      ADescriptionsExcelTable.Next;
      ADescriptionsExcelTable.CallOnProcessEvent;
    end;

  finally
    qDescriptionsDetail.FDQuery.EnableControls;
    qDescriptionsMaster.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsMasterDetail.ReOpen;
begin
  qManufacturers2.DropUnuses;
  qDescriptionsMaster.RefreshQuery;
  qDescriptionsDetail.RefreshQuery;
end;

procedure TDescriptionsMasterDetail.Rollback;
begin
  inherited;
  qManufacturers2.DropUnuses;
end;

end.
