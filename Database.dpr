program Database;

uses
  Vcl.Forms,
  DBRecordHolder in 'Helpers\DBRecordHolder.pas',
  DialogUnit in 'Helpers\DialogUnit.pas',
  StrHelper in 'Helpers\StrHelper.pas',
  ProjectConst in 'Helpers\ProjectConst.pas',
  ClipboardUnit in 'Helpers\ClipboardUnit.pas',
  ColumnsBarButtonsHelper in 'Helpers\ColumnsBarButtonsHelper.pas',
  SettingsController in 'Helpers\SettingsController.pas',
  DocFieldInfo in 'Helpers\DocFieldInfo.pas',
  DragHelper in 'Helpers\DragHelper.pas',
  FormsHelper in 'Helpers\FormsHelper.pas',
  GridExtension in 'Helpers\GridExtension.pas',
  HRTimer in 'Helpers\HRTimer.pas',
  OpenDocumentUnit in 'Helpers\OpenDocumentUnit.pas',
  RepositoryDataModule in 'Queryes\RepositoryDataModule.pas' {DMRepository: TDataModule},
  BaseQuery in 'Queryes\BaseQuery.pas' {QueryBase: TFrame},
  CustomErrorTable in 'Excel\CustomErrorTable.pas',
  FieldInfoUnit in 'Excel\FieldInfoUnit.pas',
  ErrorTable in 'Excel\ErrorTable.pas',
  CustomExcelTable in 'Excel\CustomExcelTable.pas',
  ExcelDataModule in 'Excel\ExcelDataModule.pas' {ExcelDM: TDataModule},
  BodyTypesExcelDataModule in 'Excel\BodyTypesExcelDataModule.pas' {BodyTypesExcelDM: TDataModule},
  BodyKindsQuery in 'Queryes\BodyTypes\BodyKindsQuery.pas' {QueryBodyKinds: TFrame},
  ApplyQueryFrame in 'Queryes\ApplyQuery\ApplyQueryFrame.pas' {frmApplyQuery: TFrame},
  BodyTypesQuery2 in 'Queryes\BodyTypes\BodyTypesQuery2.pas' {QueryBodyTypes2: TFrame},
  RootForm in 'Views\RootForm.pas' {frmRoot},
  DictonaryForm in 'Views\DictonaryForm.pas' {frmDictonary},
  PathSettingsForm in 'Views\PathSettingsForm.pas' {frmPathSettings},
  PopupForm in 'Views\PopupForm.pas' {frmPopupForm},
  GridFrame in 'Views\GridFrame.pas' {frmGrid: TFrame},
  BodyTypesView in 'Views\BodyTypes\BodyTypesView.pas' {ViewBodyTypes: TFrame},
  BodyTypesForm in 'Views\BodyTypes\BodyTypesForm.pas' {frmBodyTypes},
  ReportQuery in 'Queryes\Report\ReportQuery.pas' {QueryReports: TFrame},
  ReportsView in 'Views\Reports\ReportsView.pas' {ViewReports: TFrame},
  ReportsForm in 'Views\Reports\ReportsForm.pas' {frmReports},
  ProducersExcelDataModule in 'Excel\ProducersExcelDataModule.pas' {ProducersExcelDM: TDataModule},
  ProducersQuery in 'Queryes\Producers\ProducersQuery.pas' {QueryProducers: TFrame},
  ProducersView in 'Views\Producers\ProducersView.pas' {ViewProducers: TFrame},
  ProducersForm in 'Views\Producers\ProducersForm.pas' {frmProducers},
  ChildCategoriesQuery in 'Queryes\ChildCategories\ChildCategoriesQuery.pas' {QueryChildCategories: TFrame},
  ParameterTypesQuery in 'Queryes\Parameters\ParameterTypesQuery.pas' {QueryParameterTypes: TFrame},
  ParametersForCategories in 'Queryes\ParametersForCategories\ParametersForCategories.pas',
  ParametersDetailQuery in 'Queryes\ParametersForCategories\ParametersDetailQuery.pas' {QueryParametersDetail: TFrame},
  ParametersForCategoriesGroupUnit in 'Queryes\ParametersForCategories\ParametersForCategoriesGroupUnit.pas' {ParametersForCategoriesGroup: TFrame},
  TreeListQuery in 'Queryes\TreeList\TreeListQuery.pas' {QueryTreeList: TFrame},
  SubParametersQuery in 'Queryes\Parameters\SubParametersQuery.pas' {QuerySubParameters: TFrame},
  MainParametersQuery in 'Queryes\Parameters\MainParametersQuery.pas' {QueryMainParameters: TFrame},
  ParametersExcelDataModule in 'Excel\ParametersExcelDataModule.pas' {ParametersExcelDM: TDataModule},
  ParametersGroupUnit in 'Queryes\Parameters\ParametersGroupUnit.pas' {ParametersGroup: TFrame},
  ParametersView in 'Views\Parameters\ParametersView.pas' {ViewParameters: TFrame},
  ParametersForm in 'Views\Parameters\ParametersForm.pas' {frmParameters},
  DescriptionTypesQuery in 'Queryes\Descriptions\DescriptionTypesQuery.pas' {QueryDescriptionTypes: TFrame},
  DescriptionsQuery in 'Queryes\Descriptions\DescriptionsQuery.pas' {QueryDescriptions: TFrame},
  DescriptionsExcelDataModule in 'Excel\DescriptionsExcelDataModule.pas' {DescriptionsExcelDM: TDataModule},
  DescriptionsView in 'Views\Descriptions\DescriptionsView.pas' {ViewDescriptions: TFrame},
  DescriptionsForm in 'Views\Descriptions\DescriptionsForm.pas' {frmDescriptions},
  FamilyQuery in 'Queryes\Components\FamilyQuery.pas' {QueryFamily: TFrame},
  FamilyExQuery in 'Queryes\Components\FamilyExQuery.pas' {QueryFamilyEx: TFrame},
  BaseComponentsQuery in 'Queryes\Components\BaseComponentsQuery.pas' {QueryBaseComponents: TFrame},
  ComponentsQuery in 'Queryes\Components\ComponentsQuery.pas' {QueryComponents: TFrame},
  ComponentsExQuery in 'Queryes\Components\ComponentsExQuery.pas' {QueryComponentsEx: TFrame},
  BaseComponentsGroupUnit in 'Queryes\Components\BaseComponentsGroupUnit.pas' {BaseComponentsGroup: TFrame},
  BaseComponentsCountQuery in 'Queryes\Components\Count\BaseComponentsCountQuery.pas' {QueryBaseComponentsCount: TFrame},
  ComponentsCountQuery in 'Queryes\Components\Count\ComponentsCountQuery.pas' {QueryComponentsCount: TFrame},
  EmptyFamilyCountQuery in 'Queryes\Components\Count\EmptyFamilyCountQuery.pas' {QueryEmptyFamilyCount: TFrame},
  ComponentsExcelDataModule in 'Excel\ComponentsExcelDataModule.pas' {ComponentsExcelDM: TDataModule},
  ComponentsGroupUnit in 'Queryes\Components\ComponentsGroupUnit.pas' {ComponentsGroup: TFrame},
  SearchInterfaceUnit in 'Queryes\SearchInterfaceUnit.pas',
  ComponentsSearchQuery in 'Queryes\Components\ComponentsSearchQuery.pas' {QueryComponentsSearch: TFrame},
  ComponentsSearchGroupUnit in 'Queryes\Components\ComponentsSearchGroupUnit.pas' {ComponentsSearchGroup: TFrame},
  SubGroupsQuery in 'Queryes\Components\SubGroups\SubGroupsQuery.pas' {frmQuerySubGroups: TFrame},
  CategoriesTreePopupForm in 'Views\Components\SubGroup\CategoriesTreePopupForm.pas' {frmCategoriesTreePopup},
  SubGroupListPopupForm in 'Views\Components\SubGroup\SubGroupListPopupForm.pas' {frmSubgroupListPopup},
  ComponentsParentView in 'Views\Components\ComponentsParentView.pas' {ViewComponentsParent: TFrame},
  ComponentsBaseView in 'Views\Components\ComponentsBaseView.pas' {ViewComponentsBase: TFrame},
  ParametricExcelDataModule in 'Excel\ParametricExcelDataModule.pas' {ParametricExcelDM: TDataModule},
  ProgressInfo in 'Helpers\ProgressInfo.pas',
  ProgressBarForm in 'Views\ProgressBar\ProgressBarForm.pas' {frmProgressBar},
  ParametersForCategoryQuery in 'Queryes\Components\ParametricTable\ParametersForCategoryQuery.pas' {QueryParametersForCategory: TFrame},
  ProductParametersQuery in 'Queryes\Components\ParametricTable\ProductParametersQuery.pas' {QueryProductParameters: TFrame},
  ComponentsExGroupUnit in 'Queryes\Components\ParametricTable\ComponentsExGroupUnit.pas' {ComponentsExGroup: TFrame},
  ParametricTableView in 'Views\Components\ParametricTable\ParametricTableView.pas' {ViewParametricTable: TFrame},
  ParametricTableForm in 'Views\Components\ParametricTable\ParametricTableForm.pas' {frmParametricTable},
  ParametersForProductQuery in 'Queryes\ParameterValues\ParametersForProductQuery.pas' {QueryParametersForProduct: TFrame},
  ParametersValueQuery in 'Queryes\ParameterValues\ParametersValueQuery.pas' {QueryParametersValue: TFrame},
  ParameterValuesUnit in 'Queryes\ParameterValues\ParameterValuesUnit.pas',
  ComponentsView in 'Views\Components\ComponentsView.pas' {ViewComponents: TFrame},
  FamilySearchQuery in 'Queryes\Components\FamilySearchQuery.pas' {QueryFamilySearch: TFrame},
  ProductsBaseQuery in 'Queryes\Products\ProductsBaseQuery.pas' {QueryProductsBase: TFrame},
  StoreHouseProductsCountQuery in 'Queryes\Products\Count\StoreHouseProductsCountQuery.pas' {QueryStoreHouseProductsCount: TFrame},
  ProductsQuery in 'Queryes\Products\ProductsQuery.pas' {QueryProducts: TFrame},
  ProductsSearchQuery in 'Queryes\Products\Search\ProductsSearchQuery.pas' {QueryProductsSearch: TFrame},
  StoreHouseListQuery in 'Queryes\Products\StoreHouse\StoreHouseListQuery.pas' {QueryStoreHouseList: TFrame},
  ProductsBaseView in 'Views\Products\ProductsBaseView.pas' {ViewProductsBase: TFrame},
  ProductsSearchView in 'Views\Products\ProductsSearchView.pas' {ViewProductsSearch: TFrame},
  ParametersForCategoriesView in 'Views\ParametersForCategories\ParametersForCategoriesView.pas' {ViewParametersForCategories: TFrame},
  StoreHouseInfoView in 'Views\StoreHouse\StoreHouseInfoView.pas' {ViewStorehouseInfo: TFrame},
  ComponentsSearchView in 'Views\Components\Search\ComponentsSearchView.pas' {ViewComponentsSearch: TFrame},
  ModCheckDatabase in 'Helpers\ModCheckDatabase.pas',
  DataModule in 'Queryes\DataModule.pas' {DM},
  Main in 'Views\Main.pas' {frmMain},
  NotifyEvents in 'Helpers\NotifyEvents.pas',
  Sequence in 'Helpers\Sequence.pas',
  AllFamilyQuery in 'Queryes\Components\AllFamilyQuery.pas' {QueryAllFamily: TFrame},
  GridView in 'Views\GridView\GridView.pas' {ViewGrid: TFrame},
  SearchComponentCategoryQuery in 'Queryes\Search\SearchComponentCategoryQuery.pas' {QuerySearchComponentCategory: TFrame},
  CustomGridViewForm in 'Views\GridView\CustomGridViewForm.pas' {frmCustomGridView},
  ImportErrorForm in 'Views\GridView\ErrorForm\ImportErrorForm.pas' {frmImportError},
  ErrorForm in 'Views\GridView\ErrorForm\ErrorForm.pas' {frmError},
  ImportProcessForm in 'Views\GridView\ImportProcessForm.pas' {frmImportProcess},
  CustomComponentsQuery in 'Queryes\Components\CustomComponentsQuery.pas' {QueryCustomComponents: TFrame},
  SearchParameterQuery in 'Queryes\Search\SearchParameterQuery.pas' {QuerySearchParameter: TFrame},
  BaseFamilyQuery in 'Queryes\Components\BaseFamilyQuery.pas' {QueryBaseFamily: TFrame},
  StoreHouseGroupUnit in 'Queryes\Products\StoreHouse\StoreHouseGroupUnit.pas' {StoreHouseGroup: TFrame},
  ProductsView in 'Views\Products\ProductsView.pas' {ViewProducts: TFrame},
  SearchCategoriesPathQuery in 'Queryes\Search\SearchCategoriesPathQuery.pas' {QuerySearchCategoriesPath: TFrame},
  SearchDescriptionsQuery in 'Queryes\Search\SearchDescriptionsQuery.pas' {QuerySearchDescriptions: TFrame},
  SearchParameterValues in 'Queryes\Search\SearchParameterValues.pas' {QuerySearchParameterValues: TFrame},
  SearchProductParameterValuesQuery in 'Queryes\Search\SearchProductParameterValuesQuery.pas' {QuerySearchProductParameterValues: TFrame},
  TableWithProgress in 'Helpers\TableWithProgress.pas',
  SearchParametersForCategoryQuery in 'Queryes\Search\SearchParametersForCategoryQuery.pas' {QuerySearchParametersForCategory: TFrame},
  QueryWithDataSourceUnit in 'Queryes\QueryWithDataSourceUnit.pas' {QueryWithDataSource: TFrame},
  BaseEventsQuery in 'Queryes\BaseEventsQuery.pas' {QueryBaseEvents: TFrame},
  QueryWithMasterUnit in 'Queryes\QueryWithMasterUnit.pas' {QueryWithMaster: TFrame},
  HandlingQueryUnit in 'Queryes\HandlingQueryUnit.pas' {HandlingQuery: TFrame},
  ProcRefUnit in 'Helpers\ProcRefUnit.pas',
  GridViewForm in 'Views\GridView\GridViewForm.pas' {frmGridView},
  AutoBindingDocForm in 'Views\AutoBinding\AutoBindingDocForm.pas' {frmAutoBindingDoc},
  AutoBindingDescriptionForm in 'Views\AutoBinding\AutoBindingDescriptionForm.pas' {frmAutoBindingDescriptions},
  AutoBinding in 'Helpers\AutoBinding.pas',
  SearchComponentOrFamilyQuery in 'Queryes\Search\SearchComponentOrFamilyQuery.pas' {QuerySearchComponentOrFamily: TFrame},
  SearchFamily in 'Queryes\Search\SearchFamily.pas' {QuerySearchFamily: TFrame},
  SearchProductQuery in 'Queryes\Search\SearchProductQuery.pas' {QuerySearchProduct: TFrame},
  QueryGroupUnit in 'Queryes\QueryGroupUnit.pas' {QueryGroup: TFrame},
  ProductsExcelDataModule in 'Excel\ProductsExcelDataModule.pas' {ProductsExcelDM: TDataModule},
  DialogUnit2 in 'Helpers\DialogUnit2.pas',
  SearchProducerTypesQuery in 'Queryes\Search\SearchProducerTypesQuery.pas' {QuerySearchProducerTypes: TFrame},
  ProductsForm in 'Views\Products\ProductsForm.pas' {frmProducts},
  DescriptionsGroupUnit in 'Queryes\Descriptions\DescriptionsGroupUnit.pas' {DescriptionsGroup: TFrame},
  VersionQuery in 'Queryes\Version\VersionQuery.pas' {QueryVersion: TFrame},
  RecursiveTreeQuery in 'Queryes\TreeList\RecursiveTreeQuery.pas' {QueryRecursiveTree: TFrame},
  RecursiveTreeView in 'Views\TreeList\RecursiveTreeView.pas' {ViewRecursiveTree: TFrame},
  TreeExcelDataModule in 'Excel\TreeExcelDataModule.pas' {TreeExcelDM: TDataModule},
  DeleteLostFamily in 'Queryes\Components\DeleteLostFamily.pas' {QueryDeleteLostFamily: TFrame},
  CategoryParametersQuery in 'Queryes\CategoryParameters\CategoryParametersQuery.pas' {QueryCategoryParameters: TFrame},
  CategoryParametersView in 'Views\CategoryParameters\CategoryParametersView.pas' {ViewCategoryParameters: TFrame},
  ParameterPosQuery in 'Queryes\Parameters\ParameterPosQuery.pas' {QueryParameterPos: TFrame},
  RecursiveParametersQuery in 'Queryes\ParametersForCategories\RecursiveParametersQuery.pas' {QueryRecursiveParameters: TFrame},
  MaxCategoryParameterOrderQuery in 'Queryes\CategoryParameters\MaxCategoryParameterOrderQuery.pas' {QueryMaxCategoryParameterOrder: TFrame},
  SequenceQuery in 'Queryes\Sequence\SequenceQuery.pas' {QuerySequence: TFrame},
  IDTempTableQuery in 'Queryes\IDTempTable\IDTempTableQuery.pas' {QueryIDTempTable: TFrame},
  ProducersGroupUnit in 'Queryes\Producers\ProducersGroupUnit.pas' {ProducersGroup: TFrame},
  ProducerTypesQuery in 'Queryes\Producers\ProducerTypesQuery.pas' {QueryProducerTypes: TFrame},
  DocBindExcelDataModule in 'Excel\DocBindExcelDataModule.pas' {DocBindExcelDM: TDataModule},
  BindDocUnit in 'Helpers\BindDocUnit.pas',
  ComponentsTabSheetView in 'Views\Components\ComponentsTabSheetView.pas' {ComponentsFrame: TFrame},
  ProductsTabSheetView in 'Views\Products\ProductsTabSheetView.pas' {ProductsFrame: TFrame},
  OrderQuery in 'Queryes\OrderQuery.pas' {QueryOrder: TFrame},
  BodyTypesGroupUnit in 'Queryes\BodyTypes\BodyTypesGroupUnit.pas' {BodyTypesGroup: TFrame},
  BodiesQuery in 'Queryes\BodyTypes\BodiesQuery.pas' {QueryBodies: TFrame},
  BodyDataQuery in 'Queryes\BodyTypes\BodyDataQuery.pas' {QueryBodyData: TFrame},
  BodyVariationsQuery in 'Queryes\BodyTypes\BodyVariationsQuery.pas' {QueryBodyVariations: TFrame},
  BodyTypesBaseQuery in 'Queryes\BodyTypes\BodyTypesBaseQuery.pas' {QueryBodyTypesBase: TFrame},
  BodyTypesSimpleQuery in 'Queryes\BodyTypes\BodyTypesSimpleQuery.pas' {QueryBodyTypesSimple: TFrame},
  DescriptionPopupForm in 'Views\Components\Descriptions\DescriptionPopupForm.pas' {frmDescriptionPopup},
  GridSort in 'Helpers\GridSort.pas',
  QueryGroupUnit3 in 'Queryes\QueryGroupUnit3.pas',
  ProductBaseGroupUnit in 'Queryes\Products\ProductBaseGroupUnit.pas',
  ProductGroupUnit in 'Queryes\Products\ProductGroupUnit.pas',
  ProductSearchGroupUnit in 'Queryes\Products\ProductSearchGroupUnit.pas',
  ComponentGroupsQuery in 'Queryes\Products\ComponentGroupsQuery.pas' {QueryComponentGroups: TFrame},
  TreeListFrame in 'Views\TreeListFrame.pas' {frmTreeList: TFrame},
  ProductsBaseView2 in 'Views\Products\ProductsBaseView2.pas' {ViewProductsBase2: TFrame},
  SearchComponentGroup in 'Queryes\Search\SearchComponentGroup.pas' {QuerySearchComponentGroup: TFrame},
  SearchStorehouseProduct in 'Queryes\Search\SearchStorehouseProduct.pas' {QuerySearchStorehouseProduct: TFrame},
  ProductsView2 in 'Views\Products\ProductsView2.pas' {ViewProducts2: TFrame},
  ProductsSearchView2 in 'Views\Products\ProductsSearchView2.pas' {ViewProductsSearch2: TFrame},
  MapFieldsUnit in 'Helpers\MapFieldsUnit.pas',
  ProgressBarForm2 in 'Views\ProgressBar\ProgressBarForm2.pas' {frmProgressBar2},
  LoadFromExcelFileHelper in 'Helpers\LoadFromExcelFileHelper.pas',
  CustomErrorForm in 'Views\GridView\ErrorForm\CustomErrorForm.pas' {frmCustomError},
  SearchProductDescriptionQuery in 'Queryes\Search\SearchProductDescriptionQuery.pas' {QuerySearchProductDescription: TFrame},
  SearchCategoryQuery in 'Queryes\Search\SearchCategoryQuery.pas' {QuerySearchCategory: TFrame},
  ProgressBarForm3 in 'Views\ProgressBar\ProgressBarForm3.pas' {frmProgressBar3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMRepository, DMRepository);
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
