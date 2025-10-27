import 'package:madaduser/api/local/cache_response.dart';
import 'package:madaduser/helper/data_sync_helper.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:madaduser/common/models/category_types_model.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  List<Service>? _searchProductList = [];
  List<CategoryModel>? _campaignBasedCategoryList ;

  bool _isLoading = false;
  int? _pageSize;
  bool? _isSearching = false;
  final String _type = 'all';
  final String _searchText = '';

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get campaignBasedCategoryList => _campaignBasedCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  List<Service>? get searchServiceList => _searchProductList;
  bool get isLoading => _isLoading;
  int? get pageSize => _pageSize;
  bool? get isSearching => _isSearching;
  String? get type => _type;
  String? get searchText => _searchText;


  Future<void> getCategoryList(bool reload ) async {

    if(_categoryList == null || reload){
      DataSyncHelper.fetchAndSyncData(
        fetchFromLocal: ()=> categoryRepo.getCategoryList<CacheResponseData>( source: DataSourceEnum.local),
        fetchFromClient: ()=> categoryRepo.getCategoryList(source: DataSourceEnum.client),
        onResponse: (data, source) {

          _categoryList = [];
          data['content']['data'].forEach((category) {
            _categoryList!.add(CategoryModel.fromJson(category));
          });
          Get.find<AllSearchController>().insertCategoryCheckedList();
          update();
        },
      );
    }
  }


  Future<void> getSubCategoryList(String categoryID, {bool shouldUpdate = true}) async {
    _subCategoryList = null;
    if(shouldUpdate){
      update();
    }
    Response response = await categoryRepo.getSubCategoryList(categoryID);
    if (response.statusCode == 200 && response.body['response_code'] == 'default_200') {
      _subCategoryList= [];
      response.body['content']['data'].forEach((category) =>
          _subCategoryList!.addIf(CategoryModel.fromJson(category).isActive , CategoryModel.fromJson(category)));
    } else {
      _subCategoryList= [];
    }
    update();
  }

  Future<void> getCampaignBasedCategoryList(String campaignID, bool isWithPagination) async {
    printLog("inside_campaign_based_category !");
    Response response = await categoryRepo.getItemsBasedOnCampaignId(campaignID: campaignID);

    if (response.body['response_code'] == 'default_200') {
      if(!isWithPagination){
        _campaignBasedCategoryList = [];
      }
      response.body['content']['data'].forEach((categoryTypesModel) {
        if(CategoryTypesModel.fromJson(categoryTypesModel).category != null){
          _campaignBasedCategoryList!.add(CategoryTypesModel.fromJson(categoryTypesModel).category!);
        }
      });
      _isLoading = false;
      Get.toNamed(RouteHelper.getCategoryRoute('fromCampaign',campaignID));
    } else {
      if(response.statusCode != 200){
        ApiChecker.checkApi(response);
      }else{
        customSnackBar('campaign_is_not_available_for_this_service'.tr, type: ToasterMessageType.info);
      }
    }
    update();
  }


  void toggleSearch() {
    _isSearching = !_isSearching!;
    _searchProductList = [];
    update();
  }
  void showBottomLoader() {
    _isLoading = true;
    update();
  }

}
