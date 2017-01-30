unit ParametricTableForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, GridFrame,
  ComponentsParentView, ParametricTableView, NotifyEvents, ComponentsBaseView;

{$WARN UNIT_PLATFORM OFF}

type
  TfrmParametricTable = class(TfrmRoot)
    ViewParametricTable: TViewParametricTable;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FBeforeClose: TNotifyEventsEx;
    FCategoryPath: string;
    procedure UpdateCaption;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property BeforeClose: TNotifyEventsEx read FBeforeClose;
    property CategoryPath: string read FCategoryPath write FCategoryPath;
    { Public declarations }
  end;

var
  frmParametricTable: TfrmParametricTable;

implementation

{$R *.dfm}

uses Vcl.FileCtrl;

constructor TfrmParametricTable.Create(AOwner: TComponent);
begin
  inherited;
  FBeforeClose := TNotifyEventsEx.Create(Self);
end;

procedure TfrmParametricTable.FormClose(Sender: TObject; var Action:
    TCloseAction);
begin
  inherited;
  FBeforeClose.CallEventHandlers(Self);
  Action := caFree;
  frmParametricTable := nil;
end;

procedure TfrmParametricTable.FormResize(Sender: TObject);
begin
  inherited;
  UpdateCaption;
end;

procedure TfrmParametricTable.FormShow(Sender: TObject);
begin
  inherited;
  UpdateCaption;
end;

procedure TfrmParametricTable.UpdateCaption;
var
  S: string;
begin
  if not CategoryPath.IsEmpty then
  begin
    S := MinimizeName(CategoryPath, Canvas, Width - 120);
    S := S.Trim(['\']).Replace('\', '-');
    Caption := S;
  end
end;

end.
