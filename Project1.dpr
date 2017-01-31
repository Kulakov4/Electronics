program Project1;

uses
  Vcl.Forms,
  DBRecordHolder in 'Helpers\DBRecordHolder.pas',
  DialogUnit in 'Helpers\DialogUnit.pas',
  StrHelper in 'Helpers\StrHelper.pas',
  SplashXP in 'Helpers\SplashXP.pas',
  ProjectConst in 'Helpers\ProjectConst.pas',
  ClipboardUnit in 'Helpers\ClipboardUnit.pas',
  ColumnsBarButtonsHelper in 'Helpers\ColumnsBarButtonsHelper.pas',
  SettingsController in 'Helpers\SettingsController.pas',
  DocFieldInfo in 'Helpers\DocFieldInfo.pas',
  DragHelper in 'Helpers\DragHelper.pas',
  FilesController in 'Helpers\FilesController.pas',
  FormsHelper in 'Helpers\FormsHelper.pas',
  GridExtension in 'Helpers\GridExtension.pas',
  HRTimer in 'Helpers\HRTimer.pas',
  OpenDocumentUnit in 'Helpers\OpenDocumentUnit.pas',
  RepositoryDataModule in 'Queryes\RepositoryDataModule.pas' {DMRepository: TDataModule},
  BaseQuery in 'Queryes\BaseQuery.pas' {QueryBase: TFrame},
  MasterDetailFrame in 'Queryes\MasterDetailFrame.pas' {frmMasterDetail: TFrame},
  CustomErrorTable in 'Excel\CustomErrorTable.pas',
  FieldInfoUnit in 'Excel\FieldInfoUnit.pas',
  ErrorTable in 'Excel\ErrorTable.pas',
  CustomExcelTable in 'Excel\CustomExcelTable.pas',
  ExcelDataModule in 'Excel\ExcelDataModule.pas' {ExcelDM: TDataModule},
  BodyTypesExcelDataModule3 in 'Excel\BodyTypesExcelDataModule3.pas' {BodyTypesExcelDM3: TDataModule},
  BodyKindsQuery in 'Queryes\BodyTypes\BodyKindsQuery.pas' {QueryBodyKinds: TFrame},
  BodyTypesQuery in 'Queryes\BodyTypes\BodyTypesQuery.pas' {QueryBodyTypes: TFrame},
  ApplyQueryFrame in 'Queryes\ApplyQuery\ApplyQueryFrame.pas' {frmApplyQuery: TFrame},
  BodyTypesBranchQuery in 'Queryes\BodyTypes\BodyTypesBranchQuery.pas' {QueryBodyTypesBranch: TFrame},
  BodyTypesQuery2 in 'Queryes\BodyTypes\BodyTypesQuery2.pas' {QueryBodyTypes2: TFrame},
  BodyTypesTreeQuery in 'Queryes\BodyTypes\BodyTypesTreeQuery.pas' {QueryBodyTypesTree: TFrame},
  BodyTypesGridQuery in 'Queryes\BodyTypes\BodyTypesGridQuery.pas' {QueryBodyTypesGrid: TFrame},
  BodyTypesMasterDetailUnit in 'Queryes\BodyTypes\BodyTypesMasterDetailUnit.pas' {BodyTypesMasterDetail: TFrame},
  RootForm in 'Views\RootForm.pas' {frmRoot},
  DictonaryForm in 'Views\DictonaryForm.pas' {frmDictonary},
  PathSettingsForm in 'Views\PathSettingsForm.pas' {frmPathSettings},
  PopupForm in 'Views\PopupForm.pas' {frmPopupForm},
  GridFrame in 'Views\GridFrame.pas' {frmGrid: TFrame},
  BodyTypesGridView in 'Views\BodyTypes\BodyTypesGridView.pas' {ViewBodyTypesGrid: TFrame},
  BodyTypesTreeView in 'Views\BodyTypes\BodyTypesTreeView.pas' {ViewBodyTypesTree: TFrame},
  BodyTypesTreeForm in 'Views\BodyTypes\BodyTypesTreeForm.pas' {frmBodyTypesTree},
  BodyTypesView in 'Views\BodyTypes\BodyTypesView.pas' {ViewBodyTypes: TFrame},
  BodyTypesForm in 'Views\BodyTypes\BodyTypesForm.pas' {frmBodyTypes},
  ReportQuery in 'Queryes\Report\ReportQuery.pas' {QueryReports: TFrame},
  ReportsView in 'Views\Reports\ReportsView.pas' {ViewReports: TFrame},
  ReportsForm in 'Views\Reports\ReportsForm.pas' {frmReports},
  ManufacturersExcelDataModule in 'Excel\ManufacturersExcelDataModule.pas' {ManufacturersExcelDM: TDataModule},
  Manufacturers2Query in 'Queryes\Manufacturers\Manufacturers2Query.pas' {QueryManufacturers2: TFrame},
  ManufacturersView in 'Views\Manufacturers\ManufacturersView.pas' {ViewManufacturers: TFrame},
  ManufacturersForm in 'Views\Manufacturers\ManufacturersForm.pas' {frmManufacturers},
  ChildCategoriesQuery in 'Queryes\ChildCategories\ChildCategoriesQuery.pas' {QueryChildCategories: TFrame},
  ParameterTypesQuery in 'Queryes\ParametersForCategories\ParameterTypesQuery.pas' {QueryParameterTypes: TFrame},
  ParametersForCategories in 'Queryes\ParametersForCategories\ParametersForCategories.pas',
  ParametersDetailQuery in 'Queryes\ParametersForCategories\ParametersDetailQuery.pas' {frmParametersDetailQuery: TFrame},
  ParametersForCategoriesMasterDetailUnit in 'Queryes\ParametersForCategories\ParametersForCategoriesMasterDetailUnit.pas' {ParametersForCategoriesMasterDetail: TFrame},
  TreeListQuery in 'Queryes\TreeList\TreeListQuery.pas' {QueryTreeList: TFrame},
  SearchQuery in 'Queryes\Search\SearchQuery.pas' {QuerySearch: TFrame},
  SearchComponentQuery in 'Queryes\Search\SearchComponentQuery.pas' {QuerySearchComponent: TFrame},
  SearchMainComponent in 'Queryes\Search\SearchMainComponent.pas' {QuerySearchMainComponent: TFrame},
  SearchProductCategoryByExternalID in 'Queryes\Search\SearchProductCategoryByExternalID.pas' {QuerySearchProductCategoryByExternalID: TFrame},
  SubParametersQuery in 'Queryes\Parameters\SubParametersQuery.pas' {QuerySubParameters: TFrame},
  MainParametersQuery in 'Queryes\Parameters\MainParametersQuery.pas' {QueryMainParameters: TFrame},
  ParametersExcelDataModule in 'Excel\ParametersExcelDataModule.pas' {ParametersExcelDM: TDataModule},
  ParametersMasterDetailUnit in 'Queryes\Parameters\ParametersMasterDetailUnit.pas' {ParametersMasterDetail2: TFrame},
  ParametersView in 'Views\Parameters\ParametersView.pas' {ViewParameters: TFrame},
  ParametersForm in 'Views\Parameters\ParametersForm.pas' {frmParameters},
  DescriptionsMasterQuery in 'Queryes\Descriptions\DescriptionsMasterQuery.pas' {QueryDescriptionsMaster: TFrame},
  DescriptionsDetailQuery in 'Queryes\Descriptions\DescriptionsDetailQuery.pas' {QueryDescriptionsDetail: TFrame},
  DescriptionsExcelDataModule in 'Excel\DescriptionsExcelDataModule.pas' {DescriptionsExcelDM: TDataModule},
  DescriptionsMasterDetailUnit in 'Queryes\Descriptions\DescriptionsMasterDetailUnit.pas' {DescriptionsMasterDetail: TFrame},
  DescriptionsView in 'Views\Descriptions\DescriptionsView.pas' {ViewDescriptions: TFrame},
  DescriptionsForm in 'Views\Descriptions\DescriptionsForm.pas' {frmDescriptions},
  ComponentsQuery in 'Queryes\Components\ComponentsQuery.pas' {QueryComponents: TFrame},
  ComponentsExQuery in 'Queryes\Components\ComponentsExQuery.pas' {QueryComponentsEx: TFrame},
  ComponentsBaseDetailQuery in 'Queryes\Components\ComponentsBaseDetailQuery.pas' {QueryComponentsBaseDetail: TFrame},
  ComponentsDetailQuery in 'Queryes\Components\ComponentsDetailQuery.pas' {QueryComponentsDetail: TFrame},
  ComponentsDetailExQuery in 'Queryes\Components\ComponentsDetailExQuery.pas' {QueryComponentsDetailEx: TFrame},
  LostComponentsQuery in 'Queryes\Components\LostComponentsQuery.pas',
  ComponentsBaseMasterDetailUnit in 'Queryes\Components\ComponentsBaseMasterDetailUnit.pas' {ComponentsBaseMasterDetail: TFrame},
  ComponentsCountQuery in 'Queryes\Components\Count\ComponentsCountQuery.pas' {QueryComponentsCount: TFrame},
  ComponentsDetailCountQuery in 'Queryes\Components\Count\ComponentsDetailCountQuery.pas' {QueryComponentsDetailCount: TFrame},
  ComponentsMainCountQuery in 'Queryes\Components\Count\ComponentsMainCountQuery.pas' {QueryComponentsMainCount: TFrame},
  ComponentsExcelDataModule in 'Excel\ComponentsExcelDataModule.pas' {ComponentsExcelDM: TDataModule},
  ComponentBodyTypesExcelDataModule in 'Excel\ComponentBodyTypesExcelDataModule.pas' {ComponentBodyTypesExcelDM: TDataModule},
  ComponentsMasterDetailUnit in 'Queryes\Components\ComponentsMasterDetailUnit.pas' {ComponentsMasterDetail: TFrame},
  SearchInterfaceUnit in 'Queryes\SearchInterfaceUnit.pas',
  ComponentsDetailsSearchQuery in 'Queryes\Components\ComponentsDetailsSearchQuery.pas' {QueryComponentsDetailsSearch: TFrame},
  ComponentsSearchMasterDetailUnit in 'Queryes\Components\ComponentsSearchMasterDetailUnit.pas' {ComponentsSearchMasterDetail: TFrame},
  SubGroupsQuery in 'Queryes\Components\SubGroups\SubGroupsQuery.pas' {frmQuerySubGroups: TFrame},
  CategoriesTreePopupForm in 'Views\Components\SubGroup\CategoriesTreePopupForm.pas' {frmCategoriesTreePopup},
  SubGroupListPopupForm in 'Views\Components\SubGroup\SubGroupListPopupForm.pas' {frmSubgroupListPopup},
  ComponentsParentView in 'Views\Components\ComponentsParentView.pas' {ViewComponentsParent: TFrame},
  ComponentsBaseView in 'Views\Components\ComponentsBaseView.pas' {ViewComponentsBase: TFrame},
  RecommendedReplacementExcelDataModule in 'Excel\RecommendedReplacementExcelDataModule.pas' {ParameterExcelDM: TDataModule},
  ProgressInfo in 'Helpers\ProgressInfo.pas',
  ProgressBarForm in 'Views\ProgressBar\ProgressBarForm.pas' {frmProgressBar},
  ParametersForCategoryQuery in 'Queryes\Components\ParametricTable\ParametersForCategoryQuery.pas' {QueryParametersForCategory: TFrame},
  ProductParametersQuery in 'Queryes\Components\ParametricTable\ProductParametersQuery.pas' {QueryProductParameters: TFrame},
  ComponentsExMasterDetailUnit in 'Queryes\Components\ParametricTable\ComponentsExMasterDetailUnit.pas' {ComponentsExMasterDetail: TFrame},
  ParametricTableView in 'Views\Components\ParametricTable\ParametricTableView.pas' {ViewParametricTable: TFrame},
  ParametricTableForm in 'Views\Components\ParametricTable\ParametricTableForm.pas' {frmParametricTable},
  ParametersForProductQuery in 'Queryes\ParameterValues\ParametersForProductQuery.pas' {QueryParametersForProduct: TFrame},
  ParametersValueQuery in 'Queryes\ParameterValues\ParametersValueQuery.pas' {QueryParametersValue: TFrame},
  ParameterValuesUnit in 'Queryes\ParameterValues\ParameterValuesUnit.pas',
  ComponentsView in 'Views\Components\ComponentsView.pas' {ViewComponents: TFrame},
  ComponentsSearchQuery in 'Queryes\Components\ComponentsSearchQuery.pas' {QueryComponentsSearch: TFrame},
  ProductsBaseQuery in 'Queryes\Products\ProductsBaseQuery.pas' {QueryProductsBase: TFrame},
  StoreHouseProductsCountQuery in 'Queryes\Products\Count\StoreHouseProductsCountQuery.pas' {QueryStoreHouseProductsCount: TFrame},
  ProductsQuery in 'Queryes\Products\ProductsQuery.pas' {QueryProducts: TFrame},
  ProductsSearchQuery in 'Queryes\Products\Search\ProductsSearchQuery.pas' {QueryProductsSearch: TFrame},
  StoreHouseListQuery in 'Queryes\Products\StoreHouse\StoreHouseListQuery.pas' {QueryStoreHouseList: TFrame},
  ProductsBaseView in 'Views\Products\ProductsBaseView.pas' {ViewProductsBase: TFrame},
  ProductsSearchView in 'Views\Products\ProductsSearchView.pas' {ViewProductsSearch: TFrame},
  ParametersForCategoriesView in 'Views\ParametersForCategories\ParametersForCategoriesView.pas' {ViewParametersForCategories: TFrame},
  StoreHouseInfoView in 'Views\StoreHouse\StoreHouseInfoView.pas' {ViewStorehouseInfo: TFrame},
  StoreHouseView in 'Views\StoreHouse\StoreHouseView.pas' {ViewStoreHouse: TFrame},
  ComponentsSearchView in 'Views\Components\Search\ComponentsSearchView.pas' {ViewComponentsSearch: TFrame},
  ModCheckDatabase in 'Helpers\ModCheckDatabase.pas',
  DataModule in 'Queryes\DataModule.pas' {DM},
  Main in 'Views\Main.pas' {frmMain},
  AutoBindingForm in 'Views\AutoBindingForm.pas' {frmAutoBinding},
  NotifyEvents in 'Helpers\NotifyEvents.pas',
  Sequence in 'Helpers\Sequence.pas',
  AllMainComponentsQuery in 'Queryes\Components\AllMainComponentsQuery.pas' {QueryAllMainComponents: TFrame},
  ImportErrorView in 'Views\ImportError\ImportErrorView.pas' {ViewImportError: TFrame},
  SearchComponentCategoryQuery in 'Queryes\Search\SearchComponentCategoryQuery.pas' {QuerySearchComponentCategory: TFrame},
  SearchCategoryQuery in 'Queryes\Search\SearchCategoryQuery.pas' {QuerySearchCategory: TFrame},
  SearchComponentCategoryQuery2 in 'Queryes\Search\SearchComponentCategoryQuery2.pas' {QuerySearchComponentCategory2: TFrame},
  CustomErrorForm in 'Views\ImportError\CustomErrorForm.pas' {frmCustomError},
  ImportErrorForm in 'Views\ImportError\ImportErrorForm.pas' {frmImportError},
  ErrorForm in 'Views\ImportError\ErrorForm.pas' {frmError},
  ImportProcessForm in 'Views\ImportError\ImportProcessForm.pas' {frmImportProcess},
  CustomComponentsQuery in 'Queryes\Components\CustomComponentsQuery.pas' {QueryCustomComponents: TFrame},
  SearchProductCategoryByID in 'Queryes\Search\SearchProductCategoryByID.pas' {QuerySearchProductCategoryByID: TFrame},
  SearchDetailComponentQuery in 'Queryes\Search\SearchDetailComponentQuery.pas' {QuerySearchDetailComponent: TFrame},
  SearchMainParameterQuery in 'Queryes\Search\SearchMainParameterQuery.pas' {QuerySearchMainParameter: TFrame},
  SearchDaughterParameterQuery in 'Queryes\Search\SearchDaughterParameterQuery.pas' {QuerySearchDaughterParameter: TFrame},
  ExcelFileLoader in 'Helpers\ExcelFileLoader.pas',
  SearchMainComponent2 in 'Queryes\Search\SearchMainComponent2.pas' {QuerySearchMainComponent2: TFrame},
  SearchComponentsByValues in 'Queryes\Search\SearchComponentsByValues.pas' {QuerySearchComponentsByValues: TFrame},
  MainComponentsQuery in 'Queryes\Components\MainComponentsQuery.pas' {QueryMainComponents: TFrame},
  SearchBodyType in 'Queryes\Search\SearchBodyType.pas' {QuerySearchBodyType: TFrame},
  StoreHouseMasterDetailUnit in 'Queryes\Products\StoreHouse\StoreHouseMasterDetailUnit.pas' {StoreHouseMasterDetail: TFrame},
  ProductsView in 'Views\Products\ProductsView.pas' {ViewProducts: TFrame},
  SearchCategoriesPathQuery in 'Queryes\Search\SearchCategoriesPathQuery.pas' {QuerySearchCategoriesPath: TFrame},
  SearchDescriptionsQuery in 'Queryes\Search\SearchDescriptionsQuery.pas' {QuerySearchDescriptions: TFrame},
  SearchParameterValues in 'Queryes\Search\SearchParameterValues.pas' {QuerySearchParameterValues: TFrame},
  SearchProductParameterValuesQuery in 'Queryes\Search\SearchProductParameterValuesQuery.pas' {QuerySearchProductParameterValues: TFrame},
  TableWithProgress in 'Helpers\TableWithProgress.pas',
  SearchSubCategoriesQuery in 'Queryes\Search\SearchSubCategoriesQuery.pas' {QuerySearchSubCategories: TFrame},
  SearchParametersForCategoryQuery in 'Queryes\Search\SearchParametersForCategoryQuery.pas' {QuerySearchParametersForCategory: TFrame},
  QueryWithDataSourceUnit in 'Queryes\QueryWithDataSourceUnit.pas' {QueryWithDataSource: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMRepository, DMRepository);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmCategoriesTreePopup, frmCategoriesTreePopup);
  Application.CreateForm(TfrmSubgroupListPopup, frmSubgroupListPopup);
  Application.Run;

end.
