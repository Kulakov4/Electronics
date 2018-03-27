unit ProjectConst;

interface

resourcestring
  sMainFormCaption = 'Database';

  sRecommendedReplacement = 'Recommended Replacement';

  sOperatingTemperatureRange = 'Operating Temperature Range';

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
  DBVersion = 2;
  ProgramVersion = 1.1;
  DragDropTimeOut = 200; // ������ �� ���������� ��������������
  DefaultRate = 60; // ���� ������� � ����� "�� ���������"
  OnReadProcessEventRecordCount = 100; // ����� ������� ��������� / ���������� ������� �������� � ���������
  OnWriteProcessEventRecordCount = 5;

implementation

end.
