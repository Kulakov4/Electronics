unit BodyTypesTreeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RootForm, BodyTypesTreeView;

type
  TfrmBodyTypesTree = class(TfrmRoot)
    ViewBodyTypesTree: TViewBodyTypesTree;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBodyTypesTree: TfrmBodyTypesTree;

implementation

{$R *.dfm}

end.
