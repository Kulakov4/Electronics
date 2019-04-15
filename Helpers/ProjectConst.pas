unit ProjectConst;

interface

resourcestring
  sMainFormCaption = 'Database';

  sSaveAllActionCaption = 'Перезаписать уже имеющиеся';
  sSkipAllActionCaption = 'Пропустить уже имеющиеся';

  sRecommendedReplacement = 'Recommended Replacement';

  sOperatingTemperatureRange = 'Operating Temperature Range';

  sDoDescriptionsBind = 'Выполняем прикрепление кратких описаний';

  sIsNotEnoughProductAmount = 'На складе недостаточное количество товара';

  // Папка по умолчанию для хранения документации на складе
  sWareHouseFolder = 'Склад';

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

  // Папка по умолчанию для хранения JEDEC
  sBodyJEDECFolder = 'Чертёж корпуса\JEDEC';

  sBodyTypesFilesExt = 'pdf;jpg;png;bmp;gif';

  sDefaultDatabaseFileName = 'database_1.4.db';
  sEmptyDatabaseFileName = 'database_empty_1.4.db';

  sDoYouWantToDeleteCategoryParameter =
    'Вы действительно хотите убрать выделенные параметры из текущей категории?';
  sDoYouWantToDeleteCategorySubParameter =
    'Вы действительно хотите удалить выделенные подпараметры?';
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

  sExtraChargeRangeError =
    'Поле количество должно содержать диапазон вида 2-10';
  sExtraChargeRangeError2 = 'Левая граница диапазона должна быть больше правой';

  sLocalizationFileName = 'Localization.ini';

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
  DBVersion = 7;
  ProgramVersion = 1.4;
  DragDropTimeOut = 200; // Защита от случайного перетаскивания
  DefaultRate = 60; // Курс доллара к рублю "по умолчанию"
  OnReadProcessEventRecordCount = 100;
  // Через сколько считанных / записанных записей извещать о прогрессе
  OnWriteProcessEventRecordCount = 5;
  MinWholeSaleDef = 10; // Минимальная оптовая наценка по "умолчанию"

implementation

end.
