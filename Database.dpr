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
  QueryWithMasterUnit in 'Queryes\QueryWithMasterUnit.pas' {QueryWithMaster: TFrame},
  QueryWithDataSourceUnit in 'Queryes\QueryWithDataSourceUnit.pas' {QueryWithDataSource: TFrame},
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
  QueryGroupUnit in 'Queryes\QueryGroupUnit.pas' {QueryGroup: TFrame},
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
  SearchParametersForCategoryQuery in 'Queryes\Search\SearchParametersForCategoryQuery.pas' {QuerySearchParametersForCategory: TFrame},
  SearchParameterValues in 'Queryes\Search\SearchParameterValues.pas' {QuerySearchParameterValues: TFrame},
  SearchProducerTypesQuery in 'Queryes\Search\SearchProducerTypesQuery.pas' {QuerySearchProducerTypes: TFrame},
  SearchProductDescriptionQuery in 'Queryes\Search\SearchProductDescriptionQuery.pas' {QuerySearchProductDescription: TFrame},
  SearchProductParameterValuesQuery in 'Queryes\Search\SearchProductParameterValuesQuery.pas' {QuerySearchProductParameterValues: TFrame},
  SearchProductQuery in 'Queryes\Search\SearchProductQuery.pas' {QuerySearchProduct: TFrame},
  SearchStorehouseProduct in 'Queryes\Search\SearchStorehouseProduct.pas' {QuerySearchStorehouseProduct: TFrame},
  ProducersQuery in 'Queryes\Producers\ProducersQuery.pas' {QueryProducers: TFrame},
  ProducersGroupUnit in 'Queryes\Producers\ProducersGroupUnit.pas' {ProducersGroup: TFrame},
  BodyTypesGroupUnit in 'Queryes\BodyTypes\BodyTypesGroupUnit.pas' {BodyTypesGroup: TFrame},
  ChildCategoriesQuery in 'Queryes\ChildCategories\ChildCategoriesQuery.pas' {QueryChildCategories: TFrame},
  DescriptionTypesQuery in 'Queryes\Descriptions\DescriptionTypesQuery.pas' {QueryDescriptionTypes: TFrame},
  DescriptionsQuery in 'Queryes\Descriptions\DescriptionsQuery.pas' {QueryDescriptions: TFrame},
  DescriptionsExcelDataModule in 'Excel\DescriptionsExcelDataModule.pas' {DescriptionsExcelDM: TDataModule},
  DescriptionsGroupUnit in 'Queryes\Descriptions\DescriptionsGroupUnit.pas' {DescriptionsGroup: TFrame},
  SequenceQuery in 'Queryes\Sequence\SequenceQuery.pas' {QuerySequence: TFrame},
  TreeExcelDataModule in 'Excel\TreeExcelDataModule.pas' {TreeExcelDM: TDataModule},
  TreeListQuery in 'Queryes\TreeList\TreeListQuery.pas' {QueryTreeList: TFrame},
  VersionQuery in 'Queryes\Version\VersionQuery.pas' {QueryVersion: TFrame},
  ReportQuery in 'Queryes\Report\ReportQuery.pas' {QueryReports: TFrame},
  ParameterTypesQuery in 'Queryes\Parameters\ParameterTypesQuery.pas' {QueryParameterTypes: TFrame},
  ParameterPosQuery in 'Queryes\Parameters\ParameterPosQuery.pas' {QueryParameterPos: TFrame},
  MainParametersQuery in 'Queryes\Parameters\MainParametersQuery.pas' {QueryMainParameters: TFrame},
  SubParametersQuery in 'Queryes\Parameters\SubParametersQuery.pas' {QuerySubParameters: TFrame},
  ParametersExcelDataModule in 'Excel\ParametersExcelDataModule.pas' {ParametersExcelDM: TDataModule},
  ParametersGroupUnit in 'Queryes\Parameters\ParametersGroupUnit.pas' {ParametersGroup: TFrame},
  ParametricExcelDataModule in 'Excel\ParametricExcelDataModule.pas' {ParametricExcelDM: TDataModule},
  ParametersForProductQuery in 'Queryes\ParameterValues\ParametersForProductQuery.pas' {QueryParametersForProduct: TFrame},
  ParametersValueQuery in 'Queryes\ParameterValues\ParametersValueQuery.pas' {QueryParametersValue: TFrame},
  IDTempTableQuery in 'Queryes\IDTempTable\IDTempTableQuery.pas' {QueryIDTempTable: TFrame},
  ParameterValuesUnit in 'Queryes\ParameterValues\ParameterValuesUnit.pas',
  CategoryParametersQuery in 'Queryes\CategoryParameters\CategoryParametersQuery.pas' {QueryCategoryParameters: TFrame},
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
  BaseComponentsGroupUnit in 'Queryes\Components\BaseComponentsGroupUnit.pas' {BaseComponentsGroup: TFrame},
  ComponentsSearchGroupUnit in 'Queryes\Components\ComponentsSearchGroupUnit.pas' {ComponentsSearchGroup: TFrame},
  ComponentsExcelDataModule in 'Excel\ComponentsExcelDataModule.pas' {ComponentsExcelDM: TDataModule},
  ComponentsGroupUnit in 'Queryes\Components\ComponentsGroupUnit.pas' {ComponentsGroup: TFrame},
  ParametersForCategoryQuery in 'Queryes\Components\ParametricTable\ParametersForCategoryQuery.pas' {QueryParametersForCategory: TFrame},
  ProductParametersQuery in 'Queryes\Components\ParametricTable\ProductParametersQuery.pas' {QueryProductParameters: TFrame},
  ComponentsExGroupUnit in 'Queryes\Components\ParametricTable\ComponentsExGroupUnit.pas' {ComponentsExGroup: TFrame},
  ProductsBaseQuery in 'Queryes\Products\ProductsBaseQuery.pas' {QueryProductsBase: TFrame},
  StoreHouseProductsCountQuery in 'Queryes\Products\Count\StoreHouseProductsCountQuery.pas' {QueryStoreHouseProductsCount: TFrame},
  StoreHouseListQuery in 'Queryes\Products\StoreHouse\StoreHouseListQuery.pas' {QueryStoreHouseList: TFrame},
  ProductsExcelDataModule in 'Excel\ProductsExcelDataModule.pas' {ProductsExcelDM: TDataModule},
  ProductsQuery in 'Queryes\Products\ProductsQuery.pas' {QueryProducts: TFrame},
  StoreHouseGroupUnit in 'Queryes\Products\StoreHouse\StoreHouseGroupUnit.pas' {StoreHouseGroup: TFrame},
  ProductsSearchQuery in 'Queryes\Products\Search\ProductsSearchQuery.pas' {QueryProductsSearch: TFrame},
  RootForm in 'Views\RootForm.pas' {frmRoot},
  DictonaryForm in 'Views\DictonaryForm.pas' {frmDictonary},
  PathSettingsForm in 'Views\PathSettingsForm.pas' {frmPathSettings},
  PopupForm in 'Views\PopupForm.pas' {frmPopupForm},
  GridSort in 'Helpers\GridSort.pas',
  GridFrame in 'Views\GridFrame.pas' {frmGrid: TFrame},
  TreeListFrame in 'Views\TreeListFrame.pas' {frmTreeList: TFrame},
  ModCheckDatabase in 'Helpers\ModCheckDatabase.pas',
  DataModule2 in 'Queryes\DataModule2.pas' {DM2},
  AutoBindingDocForm in 'Views\AutoBinding\AutoBindingDocForm.pas' {frmAutoBindingDoc},
  AutoBindingDescriptionForm in 'Views\AutoBinding\AutoBindingDescriptionForm.pas' {frmAutoBindingDescriptions},
  GridView in 'Views\GridView\GridView.pas' {ViewGrid: TFrame},
  CustomGridViewForm in 'Views\GridView\CustomGridViewForm.pas' {frmCustomGridView},
  ImportProcessForm in 'Views\GridView\ImportProcessForm.pas' {frmImportProcess},
  GridViewForm in 'Views\GridView\GridViewForm.pas' {frmGridView},
  CustomErrorForm in 'Views\GridView\ErrorForm\CustomErrorForm.pas' {frmCustomError},
  ErrorForm in 'Views\GridView\ErrorForm\ErrorForm.pas' {frmError},
  ImportErrorForm in 'Views\GridView\ErrorForm\ImportErrorForm.pas' {frmImportError},
  DialogUnit2 in 'Helpers\DialogUnit2.pas',
  ProgressBarForm in 'Views\ProgressBar\ProgressBarForm.pas' {frmProgressBar},
  ProgressBarForm2 in 'Views\ProgressBar\ProgressBarForm2.pas' {frmProgressBar2},
  ProgressBarForm3 in 'Views\ProgressBar\ProgressBarForm3.pas' {frmProgressBar3},
  LoadFromExcelFileHelper in 'Helpers\LoadFromExcelFileHelper.pas',
  ProducersView in 'Views\Producers\ProducersView.pas' {ViewProducers: TFrame},
  ProducersForm in 'Views\Producers\ProducersForm.pas' {frmProducers},
  BodyTypesView in 'Views\BodyTypes\BodyTypesView.pas' {ViewBodyTypes: TFrame},
  BodyTypesForm in 'Views\BodyTypes\BodyTypesForm.pas' {frmBodyTypes},
  ParametersView in 'Views\Parameters\ParametersView.pas' {ViewParameters: TFrame},
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
  Sort.ListView in 'Helpers\NaturalSort\Sort.ListView.pas',
  Sort.StringCompare in 'Helpers\NaturalSort\Sort.StringCompare.pas',
  Sort.StringList in 'Helpers\NaturalSort\Sort.StringList.pas',
  AnalogForm in 'Views\Analog\AnalogForm.pas' {frmAnalog},
  AnalogView in 'Views\Analog\AnalogView.pas' {ViewAnalog: TFrame},
  AnalogQueryes in 'Queryes\Analog\AnalogQueryes.pas' {AnalogGroup: TFrame},
  UniqueParameterValuesQuery in 'Queryes\Analog\UniqueParameterValuesQuery.pas' {QueryUniqueParameterValues: TFrame},
  GridViewEx in 'Views\GridViewEx.pas' {ViewGridEx: TFrame},
  AnalogGridView3 in 'Views\Analog\AnalogGridView3.pas' {ViewAnalogGrid3: TFrame},
  BandsInfo in 'Views\BandsInfo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMRepository, DMRepository);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
