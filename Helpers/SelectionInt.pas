unit SelectionInt;

interface

type
  ISelection = interface(IUnknown)
  ['{91D2CF36-DC51-41F8-BF16-75355A6ABC27}']
    procedure ClearSelection();
    function GetHaveFocus: Boolean;
    property HaveFocus: Boolean read GetHaveFocus;
  end;

implementation

end.
