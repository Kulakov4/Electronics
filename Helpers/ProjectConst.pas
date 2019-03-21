unit ProjectConst;

interface

resourcestring
  sMainFormCaption = 'Database';

  sRecommendedReplacement = 'Recommended Replacement';

  sOperatingTemperatureRange = 'Operating Temperature Range';

  sIsNotEnoughProductAmount = '�� ������ ������������� ���������� ������';

  // ����� �� ��������� ��� �������� ������������ �� ������
  sWareHouseFolder = '�����';

  // ����� �� ��������� ��� �������� ������������ �����������
  sComponentsDatasheetFolder = '������������';

  // ����� �� ��������� ��� �������� ���� �����������
  sComponentsDiagramFolder = '�����';

  // ����� �� ��������� ��� �������� �������� �����������
  sComponentsDrawingFolder = '�����';

  // ����� �� ��������� ��� �������� ����������� �����������
  sComponentsImageFolder = '�����������';

  // ����� �� ��������� ��� �������� ����������� ��������
  sBodyImageFolder = '�����������';

  // ����� �� ��������� ��� �������� ������� ���������� �������� ��������
  sBodyLandPatternFolder = '����� ���������� ��������';

  // ����� �� ��������� ��� �������� �������� �������
  sBodyOutlineDrawingFolder = '����� �������';

  // ����� �� ��������� ��� �������� JEDEC
  sBodyJEDECFolder = '����� �������\JEDEC';

  sBodyTypesFilesExt = 'pdf;jpg;png;bmp;gif';

  sDefaultDatabaseFileName = 'database.db';
  sEmptyDatabaseFileName = 'database_empty.db';

  sDoYouWantToDeleteCategoryParameter =
    '�� ������������� ������ ������ ���������� ��������� �� ������� ���������?';
  sDoYouWantToDeleteCategorySubParameter =
    '�� ������������� ������ ������� ���������� ������������?';
  sDoYouWantToDeleteFamily =
    '�� ������������� ������ ������� ���������� ��������� ����������� �� ������� ���������?';
  sDoYouWantToDeleteFamilyFromAll =
    '�� ������������� ������ ��������� ������� ���������� ��������� ����������� �� ���� ���������?';
  sDoYouWantToDeleteComponent =
    '�� ������������� ������ ������� ���������� ���������� �� ���������?';
  sDoYouWantToDelete = '�� ������������� ������ ������� ������?';
  sDatabase = 'Database';
  sPleaseWrite = '����������, ������� ������������';
  sNoExcelSheets = '� ��������� Excel ����� ��� �� ������ �����';
  sDoYouWantToDeleteProducts =
    '�� ������������� ������ ������� ���������� ���������� �� ������?';
  sDoYouWantToSaveChanges = '��������� �� ���� ���������. ��������� ���������?';
  sError = '������';
  sSaving = '����������';

  sExtraChargeRangeError =
    '���� ���������� ������ ��������� �������� ���� 2-10';
  sExtraChargeRangeError2 = '����� ������� ��������� ������ ���� ������ ������';

  sLocalizationFileName = 'Localization.ini';

  sProducerParamTableName = 'Producer';
  sPackagePinsParamTableName = 'Package / Pins';
  sDatasheetParamTableName = 'Datasheet';
  sDiagramParamTableName = 'Diagram';
  sDrawingParamTableName = 'Drawing';
  sImageParamTableName = 'Image';
  sDescriptionParamTableName = 'Description';

  sRows = '�����';
  sRecords = '�������';
  sComponents = '�����������';
  sFiles = '������';
  sParameters = '����������';

  sTreeRootNodeName = '���������';

const
  DBVersion = 7;
  ProgramVersion = 1.4;
  DragDropTimeOut = 200; // ������ �� ���������� ��������������
  DefaultRate = 60; // ���� ������� � ����� "�� ���������"
  OnReadProcessEventRecordCount = 100;
  // ����� ������� ��������� / ���������� ������� �������� � ���������
  OnWriteProcessEventRecordCount = 5;
  MinWholeSaleDef = 10; // ����������� ������� ������� �� "���������"

implementation

end.
