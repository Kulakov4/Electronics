program Database;

uses
  Vcl.Forms,
  DBRecordHolder in 'Helpers\DBRecordHolder.pas',
  ProjectConst in 'Helpers\ProjectConst.pas',
  DialogUnit in 'Helpers\DialogUnit.pas',
  SettingsController in 'Helpers\SettingsController.pas',
  StrHelper in 'Helpers\StrHelper.pas',
  ClipboardUnit in 'Helpers\ClipboardUnit.pas',
  ColumnsBarButtonsHelper in 'Helpers\ColumnsBarButtonsHelper.pas',
  DragHelper in 'Helpers\DragHelper.pas',
  FormsHelper in 'Helpers\FormsHelper.pas',
  GridExtension in 'Helpers\GridExtension.pas',
  HRTimer in 'Helpers\HRTimer.pas',
  OpenDocumentUnit in 'Helpers\OpenDocumentUnit.pas',
  RepositoryDataModule in 'Queryes\RepositoryDataModule.pas' {DMRepository: TDataModule},
  NotifyEvents in 'Helpers\NotifyEvents.pas',
  MapFieldsUnit in 'Helpers\MapFieldsUnit.pas',
  BaseQuery in 'Queryes\BaseQuery.pas' {QueryBase: TFrame},
  BaseEventsQuery in 'Queryes\BaseEventsQuery.pas' {QueryBaseEvents: TFrame},
  ProgressInfo in 'Helpers\ProgressInfo.pas',
  ProcRefUnit in 'Helpers\ProcRefUnit.pas',
  TableWithProgress in 'Helpers\TableWithProgress.pas',
  HandlingQueryUnit in 'Queryes\HandlingQueryUnit.pas' {HandlingQuery: TFrame},
  CustomErrorTable in 'Excel\CustomErrorTable.pas',
  FieldInfoUnit in 'Excel\FieldInfoUnit.pas',
  ErrorTable in 'Excel\ErrorTable.pas',
  CustomExcelTable in 'Excel\CustomExcelTable.pas',
  ExcelDataModule in 'Excel\ExcelDataModule.pas' {ExcelDM: TDataModule},
  BodyTypesExcelDataModule in 'Excel\BodyTypesExcelDataModule.pas' {BodyTypesExcelDM: TDataModule},
  ApplyQueryFrame in 'Queryes\ApplyQuery\ApplyQueryFrame.pas' {frmApplyQuery: TFrame},
  BodiesQuery in 'Queryes\BodyTypes\BodiesQuery.pas' {QueryBodies: TFrame},
  BodyDataQuery in 'Queryes\BodyTypes\BodyDataQuery.pas' {QueryBodyData: TFrame},
  BodyVariationsQuery in 'Queryes\BodyTypes\BodyVariationsQuery.pas' {QueryBodyVariations: TFrame},
  BodyTypesBaseQuery in 'Queryes\BodyTypes\BodyTypesBaseQuery.pas' {QueryBodyTypesBase: TFrame},
  BodyTypesSimpleQuery in 'Queryes\BodyTypes\BodyTypesSimpleQuery.pas' {QueryBodyTypesSimple: TFrame},
  BodyTypesQuery2 in 'Queryes\BodyTypes\BodyTypesQuery2.pas' {QueryBodyTypes2: TFrame},
  OrderQuery in 'Queryes\OrderQuery.pas' {QueryOrder: TFrame},
  BodyKindsQuery in 'Queryes\BodyTypes\BodyKindsQuery.pas' {QueryBodyKinds: TFrame},
  ProducerTypesQuery in 'Queryes\Producers\ProducerTypesQuery.pas' {QueryProducerTypes: TFrame},
  ProducersExcelDataModule in 'Excel\ProducersExcelDataModule.pas' {ProducersExcelDM: TDataModule},
  DefaultParameters in 'Helpers\DefaultParameters.pas',
  SearchCategoriesPathQuery in 'Queryes\Search\SearchCategoriesPathQuery.pas' {QuerySearchCategoriesPath: TFrame},
  SearchCategoryQuery in 'Queryes\Search\SearchCategoryQuery.pas' {QuerySearchCategory: TFrame},
  SearchComponentCategoryQuery in 'Queryes\Search\SearchComponentCategoryQuery.pas' {QuerySearchComponentCategory: TFrame},
  SearchComponentGroup in 'Queryes\Search\SearchComponentGroup.pas' {QuerySearchComponentGroup: TFrame},
  SearchComponentOrFamilyQuery in 'Queryes\Search\SearchComponentOrFamilyQuery.pas' {QuerySearchComponentOrFamily: TFrame},
  SearchDescriptionsQuery in 'Queryes\Search\SearchDescriptionsQuery.pas' {QuerySearchDescriptions: TFrame},
  SearchFamily in 'Queryes\Search\SearchFamily.pas' {QuerySearchFamily: TFrame},
  SearchParameterQuery in 'Queryes\Search\SearchParameterQuery.pas' {QuerySearchParameter: TFrame},
  SearchProductDescriptionQuery in 'Queryes\Search\SearchProductDescriptionQuery.pas' {QuerySearchProductDescription: TFrame},
  SearchProductParameterValuesQuery in 'Queryes\Search\SearchProductParameterValuesQuery.pas' {QuerySearchProductParameterValues: TFrame},
  SearchProductQuery in 'Queryes\Search\SearchProductQuery.pas' {QuerySearchProduct: TFrame},
  SearchStorehouseProduct in 'Queryes\Search\SearchStorehouseProduct.pas' {QuerySearchStorehouseProduct: TFrame},
  ProducersQuery in 'Queryes\Producers\ProducersQuery.pas' {QueryProducers: TFrame},
  ChildCategoriesQuery in 'Queryes\ChildCategories\ChildCategoriesQuery.pas' {QueryChildCategories: TFrame},
  DescriptionTypesQuery in 'Queryes\Descriptions\DescriptionTypesQuery.pas' {QueryDescriptionTypes: TFrame},
  DescriptionsQuery in 'Queryes\Descriptions\DescriptionsQuery.pas' {QueryDescriptions: TFrame},
  DescriptionsExcelDataModule in 'Excel\DescriptionsExcelDataModule.pas' {DescriptionsExcelDM: TDataModule},
  SequenceQuery in 'Queryes\Sequence\SequenceQuery.pas' {QuerySequence: TFrame},
  TreeExcelDataModule in 'Excel\TreeExcelDataModule.pas' {TreeExcelDM: TDataModule},
  TreeListQuery in 'Queryes\TreeList\TreeListQuery.pas' {QueryTreeList: TFrame},
  VersionQuery in 'Queryes\Version\VersionQuery.pas' {QueryVersion: TFrame},
  ReportQuery in 'Queryes\Report\ReportQuery.pas' {QueryReports: TFrame},
  ParameterTypesQuery in 'Queryes\Parameters\ParameterTypesQuery.pas' {QueryParameterTypes: TFrame},
  ParameterPosQuery in 'Queryes\Parameters\ParameterPosQuery.pas' {QueryParameterPos: TFrame},
  ParametersQuery in 'Queryes\Parameters\ParametersQuery.pas' {QueryParameters: TFrame},
  ParametersExcelDataModule in 'Excel\ParametersExcelDataModule.pas' {ParametersExcelDM: TDataModule},
  ParametricExcelDataModule in 'Excel\ParametricExcelDataModule.pas' {ParametricExcelDM: TDataModule},
  ParametersValueQuery in 'Queryes\ParameterValues\ParametersValueQuery.pas' {QueryParametersValue: TFrame},
  IDTempTableQuery in 'Queryes\IDTempTable\IDTempTableQuery.pas' {QueryIDTempTable: TFrame},
  ParameterValuesUnit in 'Queryes\ParameterValues\ParameterValuesUnit.pas',
  MaxCategoryParameterOrderQuery in 'Queryes\CategoryParameters\MaxCategoryParameterOrderQuery.pas' {QueryMaxCategoryParameterOrder: TFrame},
  RecursiveParametersQuery in 'Queryes\CategoryParameters\RecursiveParametersQuery.pas' {QueryRecursiveParameters: TFrame},
  CustomComponentsQuery in 'Queryes\Components\CustomComponentsQuery.pas' {QueryCustomComponents: TFrame},
  BaseFamilyQuery in 'Queryes\Components\BaseFamilyQuery.pas' {QueryBaseFamily: TFrame},
  BaseComponentsCountQuery in 'Queryes\Components\Count\BaseComponentsCountQuery.pas' {QueryBaseComponentsCount: TFrame},
  ComponentsCountQuery in 'Queryes\Components\Count\ComponentsCountQuery.pas' {QueryComponentsCount: TFrame},
  EmptyFamilyCountQuery in 'Queryes\Components\Count\EmptyFamilyCountQuery.pas' {QueryEmptyFamilyCount: TFrame},
  SubGroupsQuery in 'Queryes\Components\SubGroups\SubGroupsQuery.pas' {frmQuerySubGroups: TFrame},
  AllFamilyQuery in 'Queryes\Components\AllFamilyQuery.pas' {QueryAllFamily: TFrame},
  ComponentsQuery in 'Queryes\Components\ComponentsQuery.pas' {QueryComponents: TFrame},
  ComponentsExQuery in 'Queryes\Components\ComponentsExQuery.pas' {QueryComponentsEx: TFrame},
  FamilyQuery in 'Queryes\Components\FamilyQuery.pas' {QueryFamily: TFrame},
  FamilyExQuery in 'Queryes\Components\FamilyExQuery.pas' {QueryFamilyEx: TFrame},
  SearchInterfaceUnit in 'Queryes\SearchInterfaceUnit.pas',
  FamilySearchQuery in 'Queryes\Components\FamilySearchQuery.pas' {QueryFamilySearch: TFrame},
  ComponentsSearchQuery in 'Queryes\Components\ComponentsSearchQuery.pas' {QueryComponentsSearch: TFrame},
  DocFieldInfo in 'Helpers\DocFieldInfo.pas',
  BaseComponentsQuery in 'Queryes\Components\BaseComponentsQuery.pas' {QueryBaseComponents: TFrame},
  ComponentsExcelDataModule in 'Excel\ComponentsExcelDataModule.pas' {ComponentsExcelDM: TDataModule},
  ProductParametersQuery in 'Queryes\Components\ParametricTable\ProductParametersQuery.pas' {QueryProductParameters: TFrame},
  ProductsBaseQuery in 'Queryes\Products\ProductsBaseQuery.pas' {QueryProductsBase: TFrame},
  StoreHouseProductsCountQuery in 'Queryes\Products\Count\StoreHouseProductsCountQuery.pas' {QueryStoreHouseProductsCount: TFrame},
  StoreHouseListQuery in 'Queryes\Products\StoreHouse\StoreHouseListQuery.pas' {QueryStoreHouseList: TFrame},
  ProductsExcelDataModule in 'Excel\ProductsExcelDataModule.pas' {ProductsExcelDM: TDataModule},
  ProductsQuery in 'Queryes\Products\ProductsQuery.pas' {QueryProducts: TFrame},
  ProductsSearchQuery in 'Queryes\Products\Search\ProductsSearchQuery.pas' {QueryProductsSearch: TFrame},
  RootForm in 'Views\RootForm.pas' {frmRoot},
  DictonaryForm in 'Views\DictonaryForm.pas' {frmDictonary},
  PathSettingsForm in 'Views\PathSettingsForm.pas' {frmPathSettings},
  PopupForm in 'Views\PopupForm.pas' {frmPopupForm},
  GridSort in 'Helpers\GridSort.pas',
  GridFrame in 'Views\GridFrame.pas' {frmGrid: TFrame},
  TreeListFrame in 'Views\TreeListFrame.pas' {frmTreeList: TFrame},
  ModCheckDatabase in 'Helpers\ModCheckDatabase.pas',
  AutoBindingDocForm in 'Views\AutoBinding\AutoBindingDocForm.pas' {frmAutoBindingDoc},
  AutoBindingDescriptionForm in 'Views\AutoBinding\AutoBindingDescriptionForm.pas' {frmAutoBindingDescriptions},
  GridView in 'Views\GridView\GridView.pas' {ViewGrid: TFrame},
  ImportProcessForm in 'Views\GridView\ImportProcessForm.pas' {frmImportProcess},
  DialogUnit2 in 'Helpers\DialogUnit2.pas',
  ProgressBarForm in 'Views\ProgressBar\ProgressBarForm.pas' {frmProgressBar},
  ProgressBarForm2 in 'Views\ProgressBar\ProgressBarForm2.pas' {frmProgressBar2},
  ProgressBarForm3 in 'Views\ProgressBar\ProgressBarForm3.pas' {frmProgressBar3},
  LoadFromExcelFileHelper in 'Helpers\LoadFromExcelFileHelper.pas',
  ProducersView in 'Views\Producers\ProducersView.pas' {ViewProducers: TFrame},
  ProducersForm in 'Views\Producers\ProducersForm.pas' {frmProducers},
  BodyTypesView in 'Views\BodyTypes\BodyTypesView.pas' {ViewBodyTypes: TFrame},
  BodyTypesForm in 'Views\BodyTypes\BodyTypesForm.pas' {frmBodyTypes},
  ParametersForm in 'Views\Parameters\ParametersForm.pas' {frmParameters},
  CategoryParametersView in 'Views\CategoryParameters\CategoryParametersView.pas' {ViewCategoryParameters: TFrame},
  DescriptionsView in 'Views\Descriptions\DescriptionsView.pas' {ViewDescriptions: TFrame},
  DescriptionsForm in 'Views\Descriptions\DescriptionsForm.pas' {frmDescriptions},
  ReportsView in 'Views\Reports\ReportsView.pas' {ViewReports: TFrame},
  ReportsForm in 'Views\Reports\ReportsForm.pas' {frmReports},
  StoreHouseInfoView in 'Views\StoreHouse\StoreHouseInfoView.pas' {ViewStorehouseInfo: TFrame},
  CategoriesTreePopupForm in 'Views\Components\SubGroup\CategoriesTreePopupForm.pas' {frmCategoriesTreePopup},
  SubGroupListPopupForm in 'Views\Components\SubGroup\SubGroupListPopupForm.pas' {frmSubgroupListPopup},
  ComponentsParentView in 'Views\Components\ComponentsParentView.pas' {ViewComponentsParent: TFrame},
  DescriptionPopupForm in 'Views\Components\Descriptions\DescriptionPopupForm.pas' {frmDescriptionPopup},
  ComponentsBaseView in 'Views\Components\ComponentsBaseView.pas' {ViewComponentsBase: TFrame},
  DocBindExcelDataModule in 'Excel\DocBindExcelDataModule.pas' {DocBindExcelDM: TDataModule},
  ComponentsView in 'Views\Components\ComponentsView.pas' {ViewComponents: TFrame},
  ComponentsSearchView in 'Views\Components\Search\ComponentsSearchView.pas' {ViewComponentsSearch: TFrame},
  ParametricTableView in 'Views\Components\ParametricTable\ParametricTableView.pas' {ViewParametricTable: TFrame},
  ParametricTableForm in 'Views\Components\ParametricTable\ParametricTableForm.pas' {frmParametricTable},
  AutoBinding in 'Helpers\AutoBinding.pas',
  BindDocUnit in 'Helpers\BindDocUnit.pas',
  ComponentsTabSheetView in 'Views\Components\ComponentsTabSheetView.pas' {ComponentsFrame: TFrame},
  ProductsBaseView2 in 'Views\Products\ProductsBaseView2.pas' {ViewProductsBase2: TFrame},
  ProductsSearchView2 in 'Views\Products\ProductsSearchView2.pas' {ViewProductsSearch2: TFrame},
  ProductsView2 in 'Views\Products\ProductsView2.pas' {ViewProducts2: TFrame},
  ProductsTabSheetView in 'Views\Products\ProductsTabSheetView.pas' {ProductsFrame: TFrame},
  RecursiveTreeQuery in 'Queryes\TreeList\RecursiveTreeQuery.pas' {QueryRecursiveTree: TFrame},
  RecursiveTreeView in 'Views\TreeList\RecursiveTreeView.pas' {ViewRecursiveTree: TFrame},
  Main in 'Views\Main.pas' {frmMain},
  HintWindowEx in 'Helpers\HintWindowEx.pas',
  AnalogForm in 'Views\Analog\AnalogForm.pas' {frmAnalog},
  UniqueParameterValuesQuery in 'Queryes\Analog\UniqueParameterValuesQuery.pas' {QueryUniqueParameterValues: TFrame},
  GridViewEx in 'Views\GridViewEx.pas' {ViewGridEx: TFrame},
  AnalogGridView in 'Views\Analog\AnalogGridView.pas' {ViewAnalogGrid: TFrame},
  BandsInfo in 'Views\BandsInfo.pas',
  CustomGridViewForm in 'Views\GridView\CustomGridViewForm.pas' {frmCustomGridView},
  GridViewForm in 'Views\GridView\GridViewForm.pas' {frmGridView},
  CustomErrorForm in 'Views\GridView\ErrorForm\CustomErrorForm.pas' {frmCustomError},
  ImportErrorForm in 'Views\GridView\ErrorForm\ImportErrorForm.pas' {frmImportError},
  AutoSizeGridViewForm in 'Views\GridView\AutoSizeGridViewForm.pas' {frmGridViewAutoSize},
  SearchProductByParamValuesQuery in 'Queryes\Search\SearchProductByParamValuesQuery.pas' {qSearchProductByParamValues: TFrame},
  ParameterKindEnum in 'Helpers\ParameterKindEnum.pas',
  PopupAnalogGridView in 'Views\Analog\PopupAnalogGridView.pas' {ViewGridPopupAnalog: TFrame},
  ParameterKindsQuery in 'Queryes\Parameters\ParameterKindsQuery.pas' {QueryParameterKinds: TFrame},
  NaturalSort in 'Helpers\NaturalSort\NaturalSort.pas',
  ParametricErrorTable in 'Queryes\Components\ParametricTable\ParametricErrorTable.pas',
  ParametricTableErrorView in 'Views\Components\ParametricTable\ParametricTableErrorView.pas' {ViewParametricTableError: TFrame},
  ParametricTableErrorForm in 'Views\Components\ParametricTable\ParametricTableErrorForm.pas' {frmParametricTableError},
  ProtectUnit in 'Helpers\ProtectUnit.pas',
  SearchFamilyParamValuesQuery in 'Queryes\Search\SearchFamilyParamValuesQuery.pas' {QueryFamilyParamValues: TFrame},
  UpdateParamValueRec in 'Helpers\UpdateParamValueRec.pas',
  SubParametersQuery2 in 'Queryes\Parameters\SubParametersQuery2.pas' {QuerySubParameters2: TFrame},
  SubParametersView in 'Views\Parameters\SubParametersView.pas' {ViewSubParameters: TFrame},
  SubParametersExcelDataModule in 'Excel\SubParametersExcelDataModule.pas' {SubParametersExcelDM: TDataModule},
  ParamSubParamsQuery in 'Queryes\Parameters\ParamSubParamsQuery.pas' {QueryParamSubParams: TFrame},
  CategoryParametersQuery2 in 'Queryes\CategoryParameters\CategoryParametersQuery2.pas' {QueryCategoryParameters2: TFrame},
  SearchParamSubParamQuery in 'Queryes\Search\SearchParamSubParamQuery.pas' {QuerySearchParamSubParam: TFrame},
  SearchParamDefSubParamQuery in 'Queryes\Search\SearchParamDefSubParamQuery.pas' {QuerySearchParamDefSubParam: TFrame},
  SubParametersForm in 'Views\Parameters\SubParametersForm.pas' {frmSubParameters},
  UpdateNegativeOrdQuery in 'Queryes\CategoryParameters\UpdateNegativeOrdQuery.pas' {QueryUpdNegativeOrd: TFrame},
  MoveHelper in 'Helpers\MoveHelper.pas',
  UpdateParameterValuesParamSubParamQuery in 'Queryes\ParameterValues\UpdateParameterValuesParamSubParamQuery.pas' {qUpdateParameterValuesParamSubParam: TFrame},
  TextRectHelper in 'Helpers\TextRectHelper.pas',
  ComponentTypeSetUnit in 'Helpers\ComponentTypeSetUnit.pas',
  ChildCategoriesView in 'Views\ChildCategories\ChildCategoriesView.pas' {ViewChildCategories: TFrame},
  TreeListView in 'Views\TreeList\TreeListView.pas' {ViewTreeList: TFrame},
  DuplicateCategoryQuery in 'Queryes\TreeList\DuplicateCategoryQuery.pas',
  DuplicateCategoryView in 'Views\TreeList\DuplicateCategoryView.pas' {ViewDuplicateCategory: TFrame},
  HttpUnit in 'Queryes\HTTP\HttpUnit.pas',
  ExtraChargeView in 'Views\ExtraCharge\ExtraChargeView.pas' {ViewExtraCharge: TFrame},
  ExtraChargeForm in 'Views\ExtraCharge\ExtraChargeForm.pas' {frmExtraCharge},
  ExtraChargeSimpleQuery in 'Queryes\ExtraCharge\ExtraChargeSimpleQuery.pas' {QueryExtraChargeSimple: TFrame},
  ExceptionHelper in 'Helpers\ExceptionHelper.pas',
  ExtraChargeExcelDataModule in 'Excel\ExtraChargeExcelDataModule.pas' {ExtraChargeExcelDM: TDataModule},
  CheckDuplicateInterface in 'Interfaces\CheckDuplicateInterface.pas',
  ProductsViewForm in 'Views\Products\ProductsViewForm.pas' {frmProducts},
  CategoryParametersQuery in 'Queryes\CategoryParameters\CategoryParametersQuery.pas' {QueryCategoryParams: TFrame},
  SearchComponentParamSubParamsQuery in 'Queryes\Search\SearchComponentParamSubParamsQuery.pas' {QuerySearchComponentParamSubParams: TFrame},
  SearchDaughterCategoriesQuery in 'Queryes\Search\SearchDaughterCategoriesQuery.pas' {QuerySearchDaughterCategories: TFrame},
  JEDECPopupForm in 'Views\BodyTypes\JEDECPopupForm.pas' {frmJEDECPopup},
  BodyOptionsQuery in 'Queryes\BodyTypes\BodyOptionsQuery.pas' {QueryBodyOptions: TFrame},
  JEDECQuery in 'Queryes\BodyTypes\JEDECQuery.pas' {QueryJEDEC: TFrame},
  BodyVariationJedecQuery in 'Queryes\BodyTypes\BodyVariationJedecQuery.pas' {QueryBodyVariationJedec: TFrame},
  BodyVariationOptionQuery in 'Queryes\BodyTypes\BodyVariationOptionQuery.pas' {QueryBodyVariationOption: TFrame},
  BodyVariationJedecView in 'Views\BodyTypes\BodyVariationJedecView.pas' {ViewBodyVariationJEDEC: TFrame},
  BodyVariationsJedecQuery in 'Queryes\BodyTypes\BodyVariationsJedecQuery.pas' {QueryBodyVariationsJedec: TFrame},
  OpenJedecUnit in 'Helpers\OpenJedecUnit.pas',
  ProducerInterface in 'Queryes\Producers\ProducerInterface.pas',
  CurrencyInterface in 'Helpers\CurrencyInterface.pas',
  CurrencyUnit in 'Queryes\HTTP\CurrencyUnit.pas',
  QueryGroupUnit2 in 'Queryes\QueryGroupUnit2.pas',
  BodyTypesGroupUnit2 in 'Queryes\BodyTypes\BodyTypesGroupUnit2.pas',
  DataModule in 'Queryes\DataModule.pas',
  ProducersGroupUnit2 in 'Queryes\Producers\ProducersGroupUnit2.pas',
  BaseComponentsGroupUnit2 in 'Queryes\Components\BaseComponentsGroupUnit2.pas',
  ComponentsSearchGroupUnit2 in 'Queryes\Components\ComponentsSearchGroupUnit2.pas',
  CategoryParametersGroupUnit2 in 'Queryes\CategoryParameters\CategoryParametersGroupUnit2.pas',
  ComponentsGroupUnit2 in 'Queryes\Components\ComponentsGroupUnit2.pas',
  ComponentsExGroupUnit2 in 'Queryes\Components\ParametricTable\ComponentsExGroupUnit2.pas',
  ParametersGroupUnit2 in 'Queryes\Parameters\ParametersGroupUnit2.pas',
  DescriptionsGroupUnit2 in 'Queryes\Descriptions\DescriptionsGroupUnit2.pas',
  DescriptionsInterface in 'Queryes\Descriptions\DescriptionsInterface.pas',
  ExtraChargeInterface in 'Queryes\ExtraCharge\ExtraChargeInterface.pas',
  ErrorType in 'Helpers\ErrorType.pas',
  RecordCheck in 'Helpers\RecordCheck.pas',
  SubParametersInterface in 'Queryes\Parameters\SubParametersInterface.pas',
  ParametersView2 in 'Views\Parameters\ParametersView2.pas' {ViewParameters2: TFrame},
  BaseFDQuery in 'Queryes\BaseFDQuery.pas' {QryBase: TFrame},
  ExtraChargeQry in 'Queryes\ExtraCharge\ExtraChargeQry.pas' {QryExtraCharge: TFrame},
  ExtraChargeGroupUnit in 'Queryes\ExtraCharge\ExtraChargeGroupUnit.pas',
  ExtraChargeQuery2 in 'Queryes\ExtraCharge\ExtraChargeQuery2.pas' {QueryExtraCharge2: TFrame},
  ExtraChargeTypeQuery in 'Queryes\ExtraCharge\ExtraChargeTypeQuery.pas' {QueryExtraChargeType: TFrame},
  DBLookupComboBoxHelper in 'Helpers\DBLookupComboBoxHelper.pas',
  ExtraChargeSimpleView in 'Views\ExtraCharge\ExtraChargeSimpleView.pas' {ViewExtraChargeSimple: TFrame},
  BillQuery in 'Queryes\Bill\BillQuery.pas' {QryBill: TFrame},
  MaxBillNumberQuery in 'Queryes\Bill\MaxBillNumberQuery.pas' {QryMaxBillNumber: TFrame},
  BillContentQuery in 'Queryes\Bill\BillContentQuery.pas' {QueryBillContent: TFrame},
  BillQuery2 in 'Queryes\Bill\BillQuery2.pas' {QryBill2: TFrame},
  DSWrap in 'Queryes\DSWrap.pas',
  DescriptionsQueryWrap in 'Queryes\DescriptionsQueryWrap.pas',
  AnalogQueryes in 'Queryes\Analog\AnalogQueryes.pas',
  ProductsBasketView in 'Views\Products\ProductsBasketView.pas' {ViewProductsBasket: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.






