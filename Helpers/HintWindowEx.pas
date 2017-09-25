unit HintWindowEx;

interface

uses
  System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.Forms, System.Types;

type
  THintWindowEx = class(THintWindow)
  private
    FShowTimer: TTimer;
    FHideTimer: TTimer;
    FHint: string;
    procedure HideTime(Sender: TObject);
    procedure ShowTime(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoActivateHint(const AHint: string);
    destructor Destroy; override;
  end;

implementation

uses System.sysutils;

{ THintWindowEx }

constructor THintWindowEx.Create(AOwner: TComponent);
begin
  inherited;
  FShowTimer := TTimer.Create(self);
  FShowTimer.Interval := Application.HintPause;

  FHideTimer := TTimer.Create(self);
  FHideTimer.Interval := Application.HintHidePause;
end;

destructor THintWindowEx.Destroy;
begin
  FHideTimer.OnTimer := nil;
  FShowTimer.OnTimer := nil;
  self.ReleaseHandle;
  inherited;
end;

procedure THintWindowEx.DoActivateHint(const AHint: string);
begin
  // force remove of the "old" hint window
  HideTime(self);

  if (AHint.IsEmpty) then
    Exit;

  FHint := AHint;

  FShowTimer.OnTimer := ShowTime;
  FHideTimer.OnTimer := HideTime;
end;

procedure THintWindowEx.HideTime(Sender: TObject);
begin
  // hide (destroy) hint window
  self.ReleaseHandle;
  FHideTimer.OnTimer := nil;
end;

procedure THintWindowEx.ShowTime(Sender: TObject);
var
  R: TRect;
  wdth: integer;
  hght: integer;
begin
  FShowTimer.OnTimer := nil;

  if FHint.IsEmpty then
    Exit;

  // position and resize
  wdth := Canvas.TextWidth(FHint);
  hght := Canvas.TextHeight(FHint);

  R.Left := Mouse.CursorPos.X + 16;
  R.Top := Mouse.CursorPos.Y + 16;
  R.Right := R.Left + wdth + 6;
  R.Bottom := R.Top + hght + 4;

  ActivateHint(R, FHint);

end;

end.
