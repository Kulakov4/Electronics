unit DescriptionsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, DescriptionTypesQuery, DescriptionsQuery,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, ProducersQuery, NotifyEvents,
  DescriptionsExcelDataModule, QueryWithDataSourceUnit, BaseQuery,
  BaseEventsQuery, QueryWithMasterUnit, QueryGroupUnit, OrderQuery;

type
  TDescriptionsGroup = class(TQueryGroup)
    qDescriptionTypes: TQueryDescriptionTypes;
    qDescriptions: TQueryDescriptions;
    qProducers: TQueryProducers;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    procedure DoAfterDelete(Sender: TObject);
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure Commit; override;
    procedure InsertRecordList(ADescriptionsExcelTable
      : TDescriptionsExcelTable);
    procedure LocateDescription(AIDDescription: Integer);
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
  TNotifyEventWrap.Create(qDescriptionTypes.AfterDelete, DoAfterDelete);
end;

procedure TDescriptionsGroup.Commit;
begin
  Inherited;
  // qProducers.DropUnuses;
end;

procedure TDescriptionsGroup.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TDescriptionsGroup.DoAfterDelete(Sender: TObject);
begin
  Assert(qDescriptionTypes.OldPKValue > 0);
  // Каскадно удаляем производителей
  qDescriptions.CascadeDelete(qDescriptionTypes.OldPKValue,
    qDescriptions.IDComponentType.FieldName, True);
end;

procedure TDescriptionsGroup.InsertRecordList(ADescriptionsExcelTable
  : TDescriptionsExcelTable);
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
      qDescriptionTypes.LocateOrAppend
        (ADescriptionsExcelTable.ComponentType.AsString);

      qProducers.LocateOrAppend(ADescriptionsExcelTable.Manufacturer.AsString);

      qDescriptions.FDQuery.Append;

      for I := 0 to ADescriptionsExcelTable.FieldCount - 1 do
      begin
        AField := qDescriptions.FDQuery.FindField
          (ADescriptionsExcelTable.Fields[I].FieldName);
        if AField <> nil then
          AField.Value := ADescriptionsExcelTable.Fields[I].Value;
      end;
      qDescriptions.IDComponentType.Value := qDescriptionTypes.PK.Value;
      qDescriptions.IDProducer.Value := qProducers.PK.Value;
      qDescriptions.FDQuery.Post;

      ADescriptionsExcelTable.Next;
      ADescriptionsExcelTable.CallOnProcessEvent;
    end;

  finally
    qDescriptions.FDQuery.EnableControls;
    qDescriptionTypes.FDQuery.EnableControls;
  end;
end;

procedure TDescriptionsGroup.LocateDescription(AIDDescription: Integer);
begin
  Assert(AIDDescription > 0);

  qDescriptions.FDQuery.DisableControls;
  qDescriptionTypes.FDQuery.DisableControls;
  try
    qDescriptions.LocateByPK(AIDDescription);
    qDescriptionTypes.LocateByPK(qDescriptions.IDComponentType.AsInteger );
  finally
    qDescriptionTypes.FDQuery.EnableControls;
    qDescriptions.FDQuery.EnableControls;
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
