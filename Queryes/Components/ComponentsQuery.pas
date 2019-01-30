unit ComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, {Sequence,} ApplyQueryFrame,
  BaseComponentsQuery, DSWrap, CustomComponentsQuery;

type
  TComponentsW = class(TCustomComponentsW)
  protected
    procedure AddNewValue(const AIDParentComponent: Integer;
      const AValue: string);
  public
    procedure LocateOrAppend(const AIDParentComponent: Integer;
      const AValue: string);
  end;

  TQueryComponents = class(TQueryBaseComponents)
  private
    function GetComponentsW: TComponentsW;
    { Private declarations }
  protected
    function CreateDataSetWrap: TCustomComponentsW; override;
  public
    constructor Create(AOwner: TComponent); override;
    property ComponentsW: TComponentsW read GetComponentsW;
    { Public declarations }
  end;

implementation

uses NotifyEvents, RepositoryDataModule, DBRecordHolder;

{$R *.dfm}
{ TfrmQueryComponentsDetail }

constructor TQueryComponents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DetailParameterName := 'vProductCategoryId';
end;

function TQueryComponents.CreateDataSetWrap: TCustomComponentsW;
begin
  Result := TComponentsW.Create(FDQuery);
end;

function TQueryComponents.GetComponentsW: TComponentsW;
begin
  Result := W as TComponentsW;
end;

procedure TComponentsW.AddNewValue(const AIDParentComponent: Integer;
  const AValue: string);
begin
  // Добавляем дочерний компонент
  TryAppend;
  ParentProductID.F.AsInteger := AIDParentComponent;
  Value.F.AsString := AValue;
  TryPost;
end;

procedure TComponentsW.LocateOrAppend(const AIDParentComponent: Integer;
  const AValue: string);
begin
  // Ещем дочерний компонент
  if not FDDataSet.LocateEx(Format('%s;%s', [ParentProductID.FieldName,
    Value.FieldName]), VarArrayOf([AIDParentComponent, AValue]),
    [lxoCaseInsensitive]) then
    AddNewValue(AIDParentComponent, AValue);

end;

end.
