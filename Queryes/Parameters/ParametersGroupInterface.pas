unit ParametersGroupInterface;

interface

uses
  ParametersInterface, ParametersExcelDataModule;

type
  IParametersGroup = interface(IInterface)
    function Check(AParametersExcelTable: TParametersExcelTable): TRecordCheck;
        stdcall;
  end;

implementation

end.
