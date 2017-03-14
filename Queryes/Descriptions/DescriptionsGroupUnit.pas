unit DescriptionsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, DescriptionTypesQuery, DescriptionsQuery,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, ProducersQuery, NotifyEvents,
  DescriptionsExcelDataModule, QueryWithDataSourceUnit, BaseQuery,
  BaseEventsQuery, QueryWithMasterUnit, QueryGroupUnit;

type
  TDescriptionsGroup = class(TQueryGroup)
    qDescriptionTypes: TQueryDescriptionTypes;
    qDescriptions: TQueryDescriptions;
    qProducers: TQueryProducers;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoBeforeDelete(Sender: TObject);
    { Private declarations }
  protected
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

constructor TDescriptionsGroup.Create(AOwner: TComponent);
begin
  inherited;
  Main := qDescriptionTypes;
  Detail := qDescriptions;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(qDescriptionTypes.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptionTypes.AfterDelete, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptions.AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(qDescriptions.AfterDelete, DoAfterPostOrDelete);
  // Для каскадного удаления
  TNotifyEventWrap.Create(qDescriptionTypes.BeforeDelete, DoBeforeDelete);
end;

procedure TDescriptionsGroup.Commit;
begin
  Inherited;
  qProducers.DropUnuses;
end;

procedure TDescriptionsGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TDescriptionsGroup.DoBeforeDelete(Sender: TObject);
begin
  // Каскадно удаляем описания
  qDescriptions.CascadeDelete(qDescriptionTypes.PKValue, qDescriptions.IDComponentType.FieldName);
end;

procedure TDescriptionsGroup.InsertRecordList(ADescriptionsExcelTable:
    TDescriptionsExcelTable);
var
  AField: TField;
  I: Integer;
begin
  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    // Цикл по всем записям, которые будем добавлять
    ADescriptionsExcelTable.First;
    ADescriptionsExcelTable.CallOnProcessEvent;
    while not ADescriptionsExcelTable.Eof do
    begin
      qDescriptionTypes.LocateOrAppend(ADescriptionsExcelTable.ComponentType.AsString);

      qProducers.LocateOrAppend(ADescriptionsExcelTable.Manufacturer.AsString);

      qDescriptions.FDQuery.Append;

      for I := 0 to ADescriptionsExcelTable.FieldCount - 1 do
      begin
        AField := qDescriptions.FDQuery.FindField
          (ADescriptionsExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ADescriptionsExcelTable.Fields[I].Value;
      end;
      qDescriptions.IDComponentType.AsInteger :=
        qDescriptionTypes.PKValue;
      qDescriptions.IDProducer.AsInteger := qProducers.PKValue;
      qDescriptions.FDQuery.Post;

      ADescriptionsExcelTable.Next;
      ADescriptionsExcelTable.CallOnProcessEvent;
    end;

  finally
    qDescriptions.FDQuery.EnableControls;
    qDescriptionTypes.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsGroup.ReOpen;
begin
  qDescriptionTypes.RefreshQuery;
  qDescriptions.RefreshQuery;
  qProducers.RefreshQuery;
end;

procedure TDescriptionsGroup.Rollback;
begin
  inherited;
end;

end.
