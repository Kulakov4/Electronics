unit BaseComponentsGroupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Comp.Client, Vcl.ExtCtrls, Data.DB,
  System.Generics.Collections, NotifyEvents, FireDAC.Comp.DataSet,
  ProducersQuery, BodyTypesQuery2, ExcelDataModule, CustomErrorTable,
  DocFieldInfo, CustomComponentsQuery, ProcRefUnit,
  TableWithProgress, BaseComponentsQuery, BaseFamilyQuery, QueryGroupUnit;

type
  TBaseComponentsGroup = class(TQueryGroup)
  strict private
  private
    FAfterApplyUpdates: TNotifyEventsEx;
    FFullDeleted: TList<Integer>;
    FProducers: TQueryProducers;
    function GetProducers: TQueryProducers;
    function GetQueryBaseComponents: TQueryBaseComponents;
    function GetQueryBaseFamily: TQueryBaseFamily;
    { Private declarations }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Commit; override;
    procedure LoadDocFile(const AFileName: String;
      ADocFieldInfo: TDocFieldInfo);
    procedure ReOpen; override;
    procedure Rollback; override;
    property AfterApplyUpdates: TNotifyEventsEx read FAfterApplyUpdates;
    property FullDeleted: TList<Integer> read FFullDeleted;
    property QueryBaseComponents: TQueryBaseComponents
      read GetQueryBaseComponents;
    property QueryBaseFamily: TQueryBaseFamily read GetQueryBaseFamily;
    property Producers: TQueryProducers read GetProducers;
    { Public declarations }
  end;

implementation

uses RepositoryDataModule, System.Math, System.IOUtils, SettingsController,
  System.Types, ProjectConst, StrHelper, BaseQuery;

{$R *.dfm}

constructor TBaseComponentsGroup.Create(AOwner: TComponent);
begin
  inherited;
  FFullDeleted := TList<Integer>.Create;

  // ������ �������
  FAfterApplyUpdates := TNotifyEventsEx.Create(Self);
end;

destructor TBaseComponentsGroup.Destroy;
begin
  FreeAndNil(FFullDeleted);
  inherited;
end;

procedure TBaseComponentsGroup.Commit;
begin
  inherited;
  FFullDeleted.Clear;
end;

function TBaseComponentsGroup.GetProducers: TQueryProducers;
begin
  if FProducers = nil then
  begin
    FProducers := TQueryProducers.Create(Self);
    FProducers.FDQuery.Open;
  end;
  Result := FProducers;
end;

function TBaseComponentsGroup.GetQueryBaseComponents: TQueryBaseComponents;
begin
  Assert(Detail <> nil);
  Result := Detail as TQueryBaseComponents;
end;

function TBaseComponentsGroup.GetQueryBaseFamily: TQueryBaseFamily;
begin
  Assert(Main <> nil);
  Result := Main as TQueryBaseFamily;
end;

procedure TBaseComponentsGroup.LoadDocFile(const AFileName: String;
  ADocFieldInfo: TDocFieldInfo);
var
  S: string;
begin
  if not AFileName.IsEmpty then
  begin
    // � �� ������ ���� �� ����� ������������ ����� � �������������
    S := GetRelativeFileName(AFileName, ADocFieldInfo.Folder);
    Main.TryEdit;
    Main.FDQuery.FieldByName(ADocFieldInfo.FieldName).AsString := S;
    Main.TryPost;
  end;
end;

procedure TBaseComponentsGroup.ReOpen;
begin
  // ������� ������� ������, ����� ��� ���������� ������� ����� ������� � ���� ��������
  Detail.RefreshQuery;
  Main.RefreshQuery;
end;

procedure TBaseComponentsGroup.Rollback;
begin
  inherited;
  FFullDeleted.Clear;
end;

end.
