unit QueryGroupUnit3;

interface

uses
  System.Classes, System.Generics.Collections, QueryWithDataSourceUnit;

type
  TQueryGroup3 = class(TComponent)
  private
    function GetHaveAnyChanges: Boolean;
  protected
    FQueries: TList<TQueryWithDataSource>;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ApplyUpdates; virtual;
    procedure CancelUpdates; virtual;
    property HaveAnyChanges: Boolean read GetHaveAnyChanges;
  end;

implementation

uses System.SysUtils;

constructor TQueryGroup3.Create(AOwner: TComponent);
begin
  inherited;
  FQueries := TList<TQueryWithDataSource>.Create;
end;

destructor TQueryGroup3.Destroy;
begin
  inherited;
  FreeAndNil(FQueries);
end;

procedure TQueryGroup3.ApplyUpdates;
var
  Q: TQueryWithDataSource;
begin
  Assert(FQueries.Count > 0);

  for Q in FQueries do
  begin
    Q.TryPost;
  end;

  for Q in FQueries do
  begin
    Q.ApplyUpdates;
  end;
end;

procedure TQueryGroup3.CancelUpdates;
var
  Q: TQueryWithDataSource;
begin
  Assert(FQueries.Count > 0);

  // отменяем все сделанные изменения на стороне клиента
  for Q in FQueries do
  begin
    Q.CancelUpdates;
  end;
end;

function TQueryGroup3.GetHaveAnyChanges: Boolean;
var
  Q: TQueryWithDataSource;
begin
  Result := False;
  Assert(FQueries.Count > 0);
  for Q in FQueries do
  begin
    Result := Q.HaveAnyChanges;
    if Result then
      Exit;
  end;
end;

end.
