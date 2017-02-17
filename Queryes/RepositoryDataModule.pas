unit RepositoryDataModule;

interface

uses
  System.SysUtils, System.Classes, cxEditRepositoryItems,
  cxExtEditRepositoryItems, cxEdit, cxClasses, cxLocalization,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, Data.DB, FireDAC.Comp.Client, Vcl.ImgList,
  Vcl.Controls, cxGraphics, cxStyles, System.ImageList, NotifyEvents;

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
    cxStyle1: TcxStyle;
    procedure dbConnectionAfterCommit(Sender: TObject);
    procedure dbConnectionAfterRollback(Sender: TObject);
    // TODO: cxFieldValueWithExpandPropertiesButtonClick
    // procedure cxFieldValueWithExpandPropertiesButtonClick(Sender: TObject;
    // AButtonIndex: Integer);
  private
    FAfterCommit: TNotifyEventsEx;
    FAfterRollback: TNotifyEventsEx;
    procedure LocalizeDevExpress;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property AfterCommit: TNotifyEventsEx read FAfterCommit;
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
  FAfterRollback := TNotifyEventsEx.Create(Self);

  // локализуем девэкспресс
  LocalizeDevExpress();
end;

procedure TDMRepository.dbConnectionAfterCommit(Sender: TObject);
begin
  // Извещаем всех о коммите
  FAfterCommit.CallEventHandlers(Sender);
end;

procedure TDMRepository.dbConnectionAfterRollback(Sender: TObject);
begin
  // Извещаем всех о роллбэке
  FAfterRollback.CallEventHandlers(Sender);
end;

// TODO: cxFieldValueWithExpandPropertiesButtonClick
// procedure TDMRepository.cxFieldValueWithExpandPropertiesButtonClick(
// Sender: TObject; AButtonIndex: Integer);
// var
// ASender, AParent: TComponent;
// AGridSite : TcxGridSite;
// ACustomGridView: TcxCustomGridView;
// begin
// ASender := Sender as TComponent;
// AParent := ASender.GetParentComponent;
// AGridSite := AParent as TcxGridSite;
// if AGridSite <> nil then
// begin
// ACustomGridView := AGridSite.GridView;
// with (ACustomGridView as TcxGridTableView).Controller do
// begin
// if (FocusedRow as TcxMyGridMasterDataRow).Expanded then       //если уже был развёрнут - свернуть
// begin
// (FocusedRow as TcxMyGridMasterDataRow).MyCollapse(True);
// end
// else                                                          //иначе - развернуть
// begin
// (FocusedRow as TcxMyGridMasterDataRow).MyExpand(True);
// end;
// end;
// end;
// end;

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
