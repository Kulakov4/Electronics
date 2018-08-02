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
    procedure dbConnectionAfterCommit(Sender: TObject);
    procedure dbConnectionAfterConnect(Sender: TObject);
    procedure dbConnectionAfterRollback(Sender: TObject);
    procedure dbConnectionBeforeCommit(Sender: TObject);
    procedure dbConnectionBeforeConnect(Sender: TObject);
  private
    FAfterCommit: TNotifyEventsEx;
    FBeforeCommit: TNotifyEventsEx;
    FAfterConnect: TNotifyEventsEx;
    FAfterRollback: TNotifyEventsEx;
    procedure LocalizeDevExpress;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
    property BeforeCommit: TNotifyEventsEx read FBeforeCommit;
    property AfterConnect: TNotifyEventsEx read FAfterConnect;
    property AfterRollback: TNotifyEventsEx read FAfterRollback;
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

  // локализуем девэкспресс
  LocalizeDevExpress();
end;

destructor TDMRepository.Destroy;
begin
  inherited;
  FreeAndNil(FAfterCommit);
  FreeAndNil(FBeforeCommit);

  FreeAndNil(FAfterRollback);
  FreeAndNil(FAfterConnect);
end;

procedure TDMRepository.dbConnectionAfterCommit(Sender: TObject);
begin
  // Извещаем всех о коммите
  FAfterCommit.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionAfterConnect(Sender: TObject);
begin
  // Извещаем всех, что соединение с БД установлено
  FAfterConnect.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionAfterRollback(Sender: TObject);
begin
  // Извещаем всех о роллбэке
  FAfterRollback.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionBeforeCommit(Sender: TObject);
begin
  // Извещаем всех о предстоящем коммите
  FBeforeCommit.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionBeforeConnect(Sender: TObject);
begin
;
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
