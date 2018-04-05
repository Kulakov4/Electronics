unit ComponentsExQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, ApplyQueryFrame, NotifyEvents,
  ComponentsQuery, System.Generics.Collections;

type
  TQueryComponentsEx = class(TQueryComponents)
  private
    FOnLocate: TNotifyEventsEx;
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
    procedure LocateInStorehouse;
    property Analog: TField read GetAnalog;
    property OnLocate: TNotifyEventsEx read FOnLocate;
    property On_ApplyUpdate: TNotifyEventsEx read FOn_ApplyUpdate;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DBRecordHolder;

constructor TQueryComponentsEx.Create(AOwner: TComponent);
begin
  inherited;
  FOn_ApplyUpdate := TNotifyEventsEx.Create(Self);
  FOnLocate := TNotifyEventsEx.Create(Self);
  FRecordHolder := TRecordHolder.Create();
end;

destructor TQueryComponentsEx.Destroy;
begin
  inherited;
  FreeAndNil(FRecordHolder);
end;

procedure TQueryComponentsEx.ApplyDelete(ASender: TDataSet; ARequest: TFDUpdateRequest;
  var AAction: TFDErrorAction; AOptions: TFDUpdateRowOptions);
begin
  // ничего не делаем при удаении
end;

procedure TQueryComponentsEx.ApplyInsert(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // Ќичего не делаем при добавлении
end;

procedure TQueryComponentsEx.ApplyUpdate(ASender: TDataSet;
  ARequest: TFDUpdateRequest; var AAction: TFDErrorAction;
  AOptions: TFDUpdateRowOptions);
begin
  // ќповещаем что надо обработать обновление
  On_ApplyUpdate.CallEventHandlers(Self);
end;

function TQueryComponentsEx.GetAnalog: TField;
begin
  Result := Field('Analog');
end;

procedure TQueryComponentsEx.LocateInStorehouse;
Var
  l: TList<String>;
begin
  Assert(FOnLocate <> nil);
  Assert(FDQuery.RecordCount > 0);

  l := TList<String>.Create();
  try
    l.Add(Value.AsString);
    // »звещаем всех что нужно осуществить поиск этого компонента на складах
    FOnLocate.CallEventHandlers(l);
  finally
    FreeAndNil(l);
  end;
end;

end.
