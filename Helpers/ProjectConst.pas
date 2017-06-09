unit ProjectConst;

interface

resourcestring
  sMainFormCaption = 'Database';

  sRecommendedReplacement = 'Recommended Replacement';

  sOperatingTemperatureRange = 'Operating Temperature Range';

  // Папка по умолчанию для хранения спецификаций компонентов
  sComponentsDatasheetFolder = 'Спецификация';

  // Папка по умолчанию для хранения схем компонентов
  sComponentsDiagramFolder = 'Схема';

  // Папка по умолчанию для хранения чертежей компонентов
  sComponentsDrawingFolder = 'Чертёж';

  // Папка по умолчанию для хранения изображений компонентов
  sComponentsImageFolder = 'Изображение';

  // Папка по умолчанию для хранения изображений корпусов
  sBodyImageFolder = 'Изображение';

  // Папка по умолчанию для хранения чертёжей посадочной площадки корпусов
  sBodyLandPatternFolder = 'Чертёж посадочной площадки';

  // Папка по умолчанию для хранения чертежей корпуса
  sBodyOutlineDrawingFolder = 'Чертёж корпуса';

  sBodyTypesFilesExt = 'pdf;jpg;png;bmp;gif';

  sDefaultDatabaseFileName = 'database.db';
  sEmptyDatabaseFileName = 'database_empty.db';

  sDoYouWantToDeleteCategoryParameter =
    'Вы действительно хотите убрать выделенные параметры из текущей категории?';
  sDoYouWantToDeleteFamily =
    'Вы действительно хотите удалить выделенные семейства компонентов из текущей категории?';
  sDoYouWantToDeleteFamilyFromAll =
    'Вы действительно хотите полностью удалить выделенные семейства компонентов из всех категорий?';
  sDoYouWantToDeleteComponent =
    'Вы действительно хотите удалить выделенные компоненты из семейства?';
  sDoYouWantToDelete = 'Вы действительно хотите удалить запись?';
  sDatabase = 'Database';
  sPleaseWrite = 'Пожалуйста, введите наименование';
  sNoExcelSheets = 'В выбранной Excel книге нет ни одного листа';
  sDoYouWantToDeleteProducts =
    'Вы действительно хотите удалить выделенные компоненты со склада?';
  sDoYouWantToSaveChanges = 'Изменения не были сохранены. Сохранить изменения?';
  sError = 'Ошибка';
  sSaving = 'Сохранение';
  sLocalizationFileName = 'bin\Localization.ini';

  sProducerParamTableName = 'Producer';
  sPackagePinsParamTableName = 'Package / Pins';
  sDatasheetParamTableName = 'Datasheet';
  sDiagramParamTableName = 'Diagram';
  sDrawingParamTableName = 'Drawing';
  sImageParamTableName = 'Image';
  sDescriptionParamTableName = 'Description';

  sRows = 'строк';
  sRecords = 'записей';
  sComponents = 'компонентов';
  sFiles = 'файлов';
  sParameters = 'параметров';

  sTreeRootNodeName = 'Структура';
const
  DBVersion = 28;
  DragDropTimeOut = 200; // Защита от случайного перетаскивания

implementation

end.
