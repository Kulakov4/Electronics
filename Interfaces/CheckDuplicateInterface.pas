unit CheckDuplicateInterface;

interface

uses
  CustomExcelTable;

type
  ICheckDuplicate = interface(IInterface)
    function HaveDuplicate(AExcelTable: TCustomExcelTable): Boolean; stdcall;
  end;

implementation

end.
