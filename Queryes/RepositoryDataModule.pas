unit RepositoryDataModule;

interface

uses
  System.SysUtils, System.Classes, cxEditRepositoryItems,
  cxExtEditRepositoryItems, cxEdit, cxClasses, cxLocalization,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, Data.DB, FireDAC.Comp.Client, Vcl.ImgList,
  Vcl.Controls, cxGraphics, cxStyles, System.ImageList, NotifyEvents,
  FireDAC.VCLUI.Wait, FireDAC.Moni.Base, FireDAC.Moni.FlatFile, cxImageList;

type
  TDMRepository = class(TDataModule)
    cerMain: TcxEditRepository;
    cxFieldValueWithExpand: TcxEditRepositoryButtonItem;
    cxFieldLabel: TcxEditRepositoryLabel;
    cxFieldMemo: TcxEditRepositoryMemoItem;
    cxFieldDateTime: TcxEditRepositoryDateItem;
    cxFieldBlobEdit: TcxEditRepositoryBlobItem;
    cxFieldCheckBox: TcxEditRepositoryCheckBoxItem;
    cxFieldComponentExternalId: TcxEditRepositoryMaskItem;
    cerMainCalcItem1: TcxEditRepositoryCalcItem;
    cxFieldNumber: TcxEditRepositoryCalcItem;
    cxFieldText: TcxEditRepositoryTextItem;
    clRus: TcxLocalizer;
    dbConnection: TFDConnection;
    cxImageList: TcxImageList;
    cxStyleRepository: TcxStyleRepository;
    cxHeaderStyle: TcxStyle;
    cxInactiveStyle: TcxStyle;
    cxStyleNotFound: TcxStyle;
    procedure DataModuleDestroy(Sender: TObject);
    procedure dbConnectionAfterCommit(Sender: TObject);
    procedure dbConnectionAfterConnect(Sender: TObject);
    procedure dbConnectionAfterRollback(Sender: TObject);
    procedure dbConnectionBeforeCommit(Sender: TObject);
    procedure dbConnectionBeforeDisconnect(Sender: TObject);
  private
    FAfterCommit: TNotifyEventsEx;
    FBeforeCommit: TNotifyEventsEx;
    FAfterConnect: TNotifyEventsEx;
    FAfterRollback: TNotifyEventsEx;
    FAfterRollback1: TNotifyEventsEx;
    FBeforeDisconnect: TNotifyEventsEx;
    FBeforeDestroy: TNotifyEventsEx;
    procedure LocalizeDevExpress;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property BeforeCommit: TNotifyEventsEx read FBeforeCommit;
    property AfterConnect: TNotifyEventsEx read FAfterConnect;
    property AfterRollback: TNotifyEventsEx read FAfterRollback;
    property AfterRollback1: TNotifyEventsEx read FAfterRollback1;
    property BeforeDisconnect: TNotifyEventsEx read FBeforeDisconnect;
    property BeforeDestroy: TNotifyEventsEx read FBeforeDestroy;
    { Public declarations }
  end;

var
  DMRepository: TDMRepository;

implementation

uses System.IOUtils, cxGridCustomView, cxGridTableView, ProjectConst;

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

constructor TDMRepository.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAfterCommit := TNotifyEventsEx.Create(Self);
  FBeforeCommit := TNotifyEventsEx.Create(Self);

  FAfterRollback := TNotifyEventsEx.Create(Self);
  FAfterConnect := TNotifyEventsEx.Create(Self);

  FBeforeDisconnect := TNotifyEventsEx.Create(Self);

  FBeforeDestroy := TNotifyEventsEx.Create(Self);

  // локализуем девэкспресс
  LocalizeDevExpress();
end;

procedure TDMRepository.DataModuleDestroy(Sender: TObject);
begin
  FBeforeDestroy.CallEventHandlers(Self);
end;

destructor TDMRepository.Destroy;
begin
  FreeAndNil(FAfterCommit);
  FreeAndNil(FBeforeCommit);

  FreeAndNil(FAfterRollback);
  FreeAndNil(FAfterConnect);

  FreeAndNil(FBeforeDisconnect);

  FreeAndNil(FBeforeDestroy);
  inherited;
end;

procedure TDMRepository.dbConnectionAfterCommit(Sender: TObject);
begin
  // Извещаем всех о коммите
  if FAfterCommit <> nil then
    FAfterCommit.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionAfterConnect(Sender: TObject);
begin
  // Извещаем всех, что соединение с БД установлено
  if FAfterConnect <> nil then
    FAfterConnect.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionAfterRollback(Sender: TObject);
begin
  // Извещаем всех о роллбэке
  if FAfterRollback <> nil then
    FAfterRollback.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionBeforeCommit(Sender: TObject);
begin
  // Извещаем всех о предстоящем коммите
  if FBeforeCommit <> nil then
    FBeforeCommit.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionBeforeDisconnect(Sender: TObject);
begin
  FBeforeDisconnect.CallEventHandlers(Self);
end;

procedure TDMRepository.LocalizeDevExpress;
var
  AFileName: string;
begin
  // локализуем девэкспресс
  AFileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
    sLocalizationFileName);
  if FileExists(AFileName) then
  begin
    clRus.FileName := AFileName;
    clRus.Active := True;
    clRus.Locale := 1049;
  end;
end;

end.
