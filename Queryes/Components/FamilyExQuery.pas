unit FamilyExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FamilyQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  ApplyQueryFrame, NotifyEvents, System.Generics.Collections, DBRecordHolder;

type
  TQueryFamilyEx = class(TQueryFamily)
  private
    FOn_ApplyUpdate: TNotifyEventsEx;
    function GetAnalog: TField;
    { Private declarations }
  protected
    procedure ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyInsert(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
    procedure ApplyUpdate(ASender: TDataSet; ARequest: TFDUpdateRequest;
      var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Analog: TField read GetAnalog;
    property On_ApplyUpdate: TNotifyEventsEx read FOn_ApplyUpdate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

constructor TQueryFamilyEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);

  FRecordHolder := TRecordHolder.Create();
end;

destructor TQueryFamilyEx.Destroy;
begin
  FreeAndNil(FOn_ApplyUpdate);
  FreeAndNil(FRecordHolder);
  inherited;
end;

procedure TQueryFamilyEx.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  // ничего не делаем при удаении
end;

procedure TQueryFamilyEx.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ничего не делаем при добавлении
end;

procedure TQueryFamilyEx.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Оповещаем что надо обработать обновление
  On_ApplyUpdate.CallEventHandlers(Self);
end;


function TQueryFamilyEx.GetAnalog: TField;
begin
  Result := Field('Analog');
end;

end.
