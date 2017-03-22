unit RecursiveTreeQuery;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BaseQuery, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  QueryWithDataSourceUnit, TreeExcelDataModule;

type
  TQueryRecursiveTree = class(TQueryWithDataSource)
  private
    function GetParentExternalID: TField;
    function GetValue: TField;
    { Private declarations }
  public
    procedure DeleteAll;
    procedure LoadRecords(ATreeExcelTable: TTreeExcelTable);
    property ParentExternalID: TField read GetParentExternalID;
    property Value: TField read GetValue;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TQueryRecursiveTree.DeleteAll;
begin
  if FDQuery.RecordCount = 0 then
    Exit;

  FDQuery.First;
  // Первая запись - это корень всего дерева
  Assert(ParentExternalID.IsNull);
  // При удалении корня на сервере каскадно удалятся и дочерние ветви
  FDQuery.Delete;
  RefreshQuery;
  Assert(FDQuery.RecordCount = 1);
end;

function TQueryRecursiveTree.GetParentExternalID: TField;
begin
  Result := Field('ParentExternalID');
end;

function TQueryRecursiveTree.GetValue: TField;
begin
  Result := Field(Value);
end;

procedure TQueryRecursiveTree.LoadRecords(ATreeExcelTable: TTreeExcelTable);
begin
  DeleteAll;

  FDQuery.DisableControls;
  try
    ATreeExcelTable.First;
    ATreeExcelTable.CallOnProcessEvent;

    while not ATreeExcelTable.Eof do
    begin
      TryAppend;

      // Если это корневая запись
      if ATreeExcelTable.ParentExternalID.IsNull then
      begin
        Value.AsString := ATreeExcelTable.Value.AsString;
      end
      else
      begin

      end;

      TryPost;
      ATreeExcelTable.Next;
      ATreeExcelTable.CallOnProcessEvent;
    end;

  finally
    FDQuery.EnableControls;
  end;
end;

end.
