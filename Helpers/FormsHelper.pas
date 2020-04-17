unit FormsHelper;

interface

uses
  Vcl.Forms, System.SysUtils, System.Classes;

type
  TFormsHelper = class(TObject)
  private const
    cswsNormal = 'Normal';
    cswsMinimized = 'Minimized';
    cswsMaximized = 'Maximized';
  public
    class function FormStatsToString(form: TForm): string; static;
    class procedure StringToFormStats(sForm: string; form: TForm); static;
    class procedure SetFont(AContainer: TComponent; AFontSize: Integer); static;
  end;

implementation

uses
  dxBar;

// Перевести форму в строку оформления
class function TFormsHelper.FormStatsToString(form: TForm): string;
var
  AState: string;
begin
  Result := '';
  with form do
  begin
    case WindowState of
      TWindowState.wsNormal:
        AState := cswsNormal;
      TWindowState.wsMinimized:
        AState := cswsMinimized;
      TWindowState.wsMaximized:
        AState := cswsMaximized;
    end;
    Result := Format('%s,%d,%d,%d,%d', [AState, Left, Top, Width, Height]);
  end;
end;

// Перевести строку в оформление формы
class procedure TFormsHelper.StringToFormStats(sForm: string; form: TForm);
var
  ASplitted: TArray<string>;
begin
  try
    ASplitted := sForm.Split([',']);
    if Length(ASplitted) = 5 then // должно быть 5 частей оформления
    begin
      if ASplitted[0] = cswsNormal then
        form.WindowState := wsNormal;
      if ASplitted[0] = cswsMinimized then
        form.WindowState := wsMinimized;
      if ASplitted[0] = cswsMaximized then
        form.WindowState := wsMaximized;

      if form.WindowState = wsNormal then
      begin
        form.Left := StrToInt(ASplitted[1]);
        form.Top := StrToInt(ASplitted[2]);
        form.Width := StrToInt(ASplitted[3]);
        form.Height := StrToInt(ASplitted[4]);
        form.Position := poDesigned;
      end;
    end;
  except
    // если не удалось перевести строку - игнорировать её
  end;
end;

class procedure TFormsHelper.SetFont(AContainer: TComponent;
  AFontSize: Integer);
var
  AComponent: TComponent;
  AdxBar: TdxBar;
  // AForm: TForm;
  i: Integer;
begin
  Exit;
  (*
    if AContainer is TFrame then
    (AContainer as TFrame).Font.Size := AFontSize;

    if AContainer is TForm then
    begin
    AForm := (AContainer as TForm);
    AForm.Font.Size := AFontSize;
    end;
  *)
  for i := 0 to AContainer.ComponentCount - 1 do
  begin
    AComponent := AContainer.Components[i];
    if AComponent is TdxBar then
    begin
      AdxBar := AComponent as TdxBar;
      AdxBar.BarManager.UseSystemFont := False;
      AdxBar.BarManager.Scaled := True;
      if AdxBar.Font.Size <> 13 then
      begin
        AdxBar.Font.Name := 'Calibry';
        AdxBar.Font.Size := 13;
      end;
    end;
  end;
end;

end.
