unit ParametricTableErrorView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, GridViewEx, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray, dxSkinOffice2013LightGray,
  dxSkinOffice2013White, dxSkinOffice2016Colorful, dxSkinOffice2016Dark,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVisualStudio2013Blue, dxSkinVisualStudio2013Dark,
  dxSkinVisualStudio2013Light, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, dxSkinsdxBarPainter,
  Vcl.ExtCtrls, System.ImageList, Vcl.ImgList, cxGridCustomPopupMenu,
  cxGridPopupMenu, Vcl.Menus, System.Actions, Vcl.ActnList, dxBar, cxClasses,
  Vcl.ComCtrls, cxGridLevel, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridBandedTableView, cxGridDBBandedTableView, cxGrid,
  cxButtonEdit, ParametersForm, ParametricErrorTable, DialogUnit,
  ParametersGroupUnit2, System.UITypes,
  cxDataControllerConditionalFormattingRulesManagerDialog, dxBarBuiltInMenu,
  cxImageList;

type
  TViewParametricTableError = class(TViewGridEx)
    clButton: TcxGridDBBandedColumn;
    actFix: TAction;
    procedure actFixExecute(Sender: TObject);
  private
    function GetParametricErrorTable: TParametricErrorTable;
    { Private declarations }
  public
    property ParametricErrorTable: TParametricErrorTable
      read GetParametricErrorTable;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses BaseQuery;

procedure TViewParametricTableError.actFixExecute(Sender: TObject);
var
  AfrmParameters: TfrmParameters;
  OK: Boolean;
  AParametersGroup: TParametersGroup2;
  F: TField;
  ErrMsg: String;
  PKFieldName: String;
begin
  Assert(ParametricErrorTable <> nil);
  F := nil;

  AParametersGroup := TParametersGroup2.Create(nil);
  try
    AParametersGroup.ReOpen;

    AfrmParameters := TfrmParameters.Create(nil);
    try
      AfrmParameters.CloseAction := caHide;
      AfrmParameters.ViewParameters.ParametersGrp := AParametersGroup;
      AfrmParameters.ViewSubParameters.QuerySubParameters :=
        AParametersGroup.qSubParameters;

      OK := True;
      case ParametricErrorTable.ErrorType.AsInteger of
        Integer(petNotUnique):
          begin
            OK := False;
            ShowMessage('��� ����������� ����� �������� excel-����');
          end;

        Integer(petParamNotFound), Integer(petParamDuplicate):
          begin
            // ������������� �� ������� "���������"
            AfrmParameters.cxPageControl.ActivePage :=
              AfrmParameters.cxtsParameters;

            F := AParametersGroup.qParameters.TableName;
            ErrMsg := '��������� ��� ���������� ��������� �� ��������� � ���������� � Excel �����';
            PKFieldName := AParametersGroup.qParameters.PKFieldName;

            if ParametricErrorTable.ErrorType.AsInteger = Integer
              (petParamDuplicate) then
            begin
              AfrmParameters.ViewParameters.Search
                (ParametricErrorTable.ParameterName.AsString);
              AfrmParameters.ViewParameters.actFilterByTableName.Execute;
            end;
          end;
        Integer(petSubParamNotFound), Integer(petSubParamDuplicate):
          begin
            // ������������� �� ������� "������������"
            AfrmParameters.cxPageControl.ActivePage :=
              AfrmParameters.cxtsSubParameters;

            F := AParametersGroup.qSubParameters.Name;
            ErrMsg := '��� ���������� ������������ �� ��������� � ���������� � Excel �����';
            PKFieldName := AParametersGroup.qSubParameters.PKFieldName;
          end;
      else
        Assert(False);
      end;

      if not OK then
        Exit;

      if (F = nil) or (AfrmParameters.ShowModal <> mrOK) or
        (F.DataSet.RecordCount = 0) then
        Exit;

      if F.AsString <> ParametricErrorTable.ParameterName.AsString then
      begin
        TDialog.Create.ErrorMessageDialog(ErrMsg);
        Exit;
      end;

      // ������ ������
      ParametricErrorTable.Fix(F.DataSet.FieldByName(PKFieldName).AsInteger);

    finally
      FreeAndNil(AfrmParameters);
    end;
  finally
    FreeAndNil(AParametersGroup);
  end;
end;

function TViewParametricTableError.GetParametricErrorTable
  : TParametricErrorTable;
begin
  if DataSet = nil then
    Result := nil
  else
    Result := DataSet as TParametricErrorTable;
end;

end.
