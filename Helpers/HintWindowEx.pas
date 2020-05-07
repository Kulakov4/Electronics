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
var
  fs: Integer;
  S: String;
begin
  inherited;
  fs := Canvas.Font.Size;
  S := Canvas.Font.Name;

//  Canvas.Font.Size := 14;
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
  // Отменяем показ предыдущего хинта
  HideTime(self);

  if (AHint.IsEmpty) then
  begin
    FShowTimer.OnTimer := nil;
    FHideTimer.OnTimer := nil;
    Exit;
  end;

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
  n: Integer;
begin
  FShowTimer.OnTimer := nil;

  if FHint.IsEmpty then
  begin
    FHideTimer.OnTimer := nil;
    Exit;
  end;

  // position and resize
  wdth := Canvas.TextWidth(FHint);
  hght := Canvas.TextHeight(FHint);
  if wdth > 600 then
  begin
    n := wdth div 600;
    if frac(wdth / 600) > 0 then
      Inc(n);

    hght := hght * n;
    wdth := 600;
  end;


  R.Left := Mouse.CursorPos.X + 16;
  R.Top := Mouse.CursorPos.Y + 16;
  R.Right := R.Left + wdth + 6;
  R.Bottom := R.Top + hght + 4;

  ActivateHint(R, FHint);

end;

end.
