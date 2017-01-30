unit Manufacturers2Query;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  NotifyEvents, ManufacturersExcelDataModule;

type
  TQueryManufacturers2 = class(TfrmDataModule)
    FDQueryID: TFDAutoIncField;
    FDQueryName: TWideStringField;
    fdqDropUnused: TFDQuery;
    FDQueryProducts: TWideStringField;
  private
    FAfterDataChange: TNotifyEventsEx;
    procedure DoAfterPostOrDelete(Sender: TObject);
    function GetName: TField;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddNewValue(const AValue: string);
    procedure ApplyUpdates; override;
    procedure CancelUpdates; override;
    procedure DropUnuses;
    procedure InsertRecordList(AManufacturesExcelTable
      : TManufacturesExcelTable);
    function Locate(AValue: string): Boolean;
    procedure LocateOrAppend(AValue: string);
    property AfterDataChange: TNotifyEventsEx read FAfterDataChange;
    property Name: TField read GetName;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses RepositoryDataModule;

constructor TQueryManufacturers2.Create(AOwner: TComponent);
begin
  inherited;

  FAfterDataChange := TNotifyEventsEx.Create(Self);

  TNotifyEventWrap.Create(AfterPost, DoAfterPostOrDelete);
  TNotifyEventWrap.Create(AfterDelete, DoAfterPostOrDelete);

  AutoTransaction := False;
end;

procedure TQueryManufacturers2.AddNewValue(const AValue: string);
begin
  FDQuery.Append;
  Name.AsString := AValue;
  FDQuery.Post;
end;

procedure TQueryManufacturers2.ApplyUpdates;
begin
  TryPost;
  FDQuery.Connection.Commit;
end;

procedure TQueryManufacturers2.CancelUpdates;
begin
  // �������� ��� ��������� ��������� �� ������� �������
  TryCancel;
  FDQuery.Connection.Rollback;
  RefreshQuery;
end;

procedure TQueryManufacturers2.DoAfterPostOrDelete(Sender: TObject);
begin
  FAfterDataChange.CallEventHandlers(Self);
end;

procedure TQueryManufacturers2.DropUnuses;
begin
  fdqDropUnused.ExecSQL;
  RefreshQuery;
end;

function TQueryManufacturers2.GetName: TField;
begin
  Result := Field('Name');
end;

procedure TQueryManufacturers2.InsertRecordList(AManufacturesExcelTable
  : TManufacturesExcelTable);
var
  AField: TField;
  I: Integer;
begin
  FDQuery.DisableControls;
  try
    // ���� �� ���� �������, ������� ����� ���������
    AManufacturesExcelTable.First;
    while not AManufacturesExcelTable.Eof do
    begin
      FDQuery.Append;

      for I := 0 to AManufacturesExcelTable.FieldCount - 1 do
      begin
        AField := FDQuery.FindField(AManufacturesExcelTable.Fields[I]
          .FieldName);
        if AField <> nil then
          AField.Value := AManufacturesExcelTable.Fields[I].Value;
      end;
      TryPost;

      AManufacturesExcelTable.Next;
    end;

  finally
    FDQuery.EnableControls;
  end;
end;

function TQueryManufacturers2.Locate(AValue: string): Boolean;
begin
  Result := FDQuery.LocateEx(Name.FieldName, AValue, []);
end;

procedure TQueryManufacturers2.LocateOrAppend(AValue: string);
var
  OK: Boolean;
begin
  OK := Locate(AValue);

  if not OK then
    AddNewValue(AValue);
end;

end.
