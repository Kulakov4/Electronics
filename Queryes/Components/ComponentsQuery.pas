unit ComponentsQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.StdCtrls, {Sequence,} ApplyQueryFrame,
  BaseComponentsQuery;

type
  TQueryComponents = class(TQueryBaseComponents)
  private
    { Private declarations }
  protected
    procedure AddNewValue(const AIDParentComponent: Integer;
      const AValue: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure LocateOrAppend(const AIDParentComponent: Integer;
      const AValue: string);
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

procedure TQueryComponents.LocateOrAppend(const AIDParentComponent: Integer;
  const AValue: string);
begin
  // Ещем дочерний компонент
  if not FDQuery.LocateEx(Format('%s;%s', [ParentProductID.FieldName,
    Value.FieldName]), VarArrayOf([AIDParentComponent, AValue]),
    [lxoCaseInsensitive]) then
    AddNewValue(AIDParentComponent, AValue);

end;

procedure TQueryComponents.AddNewValue(const AIDParentComponent: Integer;
  const AValue: string);
begin
  // Добавляем дочерний компонент
  FDQuery.Append;
  ParentProductID.AsInteger := AIDParentComponent;
  Value.AsString := AValue;
  FDQuery.Post;
end;

end.
