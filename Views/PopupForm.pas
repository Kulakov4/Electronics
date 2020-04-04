unit PopupForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxDropDownEdit, NotifyEvents;

type
  TfrmPopupForm = class(TForm)
    procedure FormHide(Sender: TObject);
  private
    FCloseOnEscape: Boolean;
    FOnHide: TNotifyEventsEx;
    function GetPopupWindow: TcxCustomEditPopupWindow;
    { Private declarations }
  protected
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    property PopupWindow: TcxCustomEditPopupWindow read GetPopupWindow;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CloseOnEscape: Boolean read FCloseOnEscape write FCloseOnEscape;
    property OnHide: TNotifyEventsEx read FOnHide;
    { Public declarations }
  end;

implementation

uses
  FormsHelper, ProjectConst;

{$R *.dfm}

constructor TfrmPopupForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCloseOnEscape := True;

  FOnHide := TNotifyEventsEx.Create(Self);
  TFormsHelper.SetFont(Self, BaseFontSize);
end;

destructor TfrmPopupForm.Destroy;
begin
  FreeAndNil(FOnHide);
  inherited;
end;

procedure TfrmPopupForm.CMDialogKey(var Message: TCMDialogKey);
begin
  with Message do
    if (FCloseOnEscape) and // разрешено закрывать окно по Esc
      (CharCode = VK_ESCAPE) and // была нажата клавиша Escape
      (KeyDataToShiftState(KeyData) = []) then // сдвиговые клавиши не тронуты
    begin
      PopupWindow.CloseUp;
    end;

  inherited;
end;

procedure TfrmPopupForm.FormHide(Sender: TObject);
begin
  FOnHide.CallEventHandlers(Self);
end;

function TfrmPopupForm.GetPopupWindow: TcxCustomEditPopupWindow;
var
  PopupWindow: TCustomForm;
begin
  PopupWindow := GetParentForm(Self);
  Result := PopupWindow as TcxCustomEditPopupWindow;
end;

end.
