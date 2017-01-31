unit ParametersDetailQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DataModuleFrame, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit;

type
  TfrmParametersDetailQuery = class(TQueryWithDataSource)
    procedure FDQueryUpdateRecord(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;

implementation

{$R *.dfm}
{ TfrmParametersDetailQuery }

uses ParametersForCategories, NotifyEvents;

constructor TfrmParametersDetailQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'ProductCategoryId';
end;

procedure TfrmParametersDetailQuery.FDQueryUpdateRecord(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
var
  AParametersFor: TParametersForCategories;
//  APKValue: Integer;
begin

  if ARequest = arUpdate then
  begin
    FDQuery.DisableControls;
    try


      // FBeforeUpdateEvent.CallEventHandlers(Self);
      AParametersFor := TParametersForCategories.Create;
      try
        AParametersFor.UpdateRecordRecursive(ParentValue,
          // qTreeList.FieldByName('Id').AsInteger,
          FDQuery.FieldByName('Id').AsInteger, ASender['IsAdded'],
          ASender['IsAttribute'], FDQuery.FieldByName('Order').AsInteger);
      finally
        AParametersFor.Free;
        // FAfterUpdateEvent.CallEventHandlers(Self);
      end;


    finally
      FDQuery.EnableControls;
    end;
    AAction := eaApplied;
  end;

end;

end.
