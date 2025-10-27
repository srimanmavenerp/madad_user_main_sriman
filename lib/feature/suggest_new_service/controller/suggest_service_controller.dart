import 'package:madaduser/utils/core_export.dart';
import 'package:madaduser/feature/suggest_new_service/model/suggest_service_model.dart';
import 'package:madaduser/feature/suggest_new_service/repository/suggest_service_repo.dart';
import 'package:get/get.dart';

class SuggestServiceController extends GetxController{

  final SuggestServiceRepo suggestServiceRepo;
  SuggestServiceController({required this.suggestServiceRepo});

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  bool _isShowInputField = false;
  bool get isShowInputField => _isShowInputField;

  double initialButtonPadding = 230;
  double initialContainerOpacity = 0.0;
  double initialImageSize = 100.0;
  String selectedCategoryName= "";
  String selectedCategoryId= "";


  TextEditingController serviceNameController = TextEditingController();
  TextEditingController serviceDetailsController = TextEditingController();


  List<SuggestedService> suggestedServiceList =[];
  SuggestedServiceModel? suggestedServiceModel;

  // Future<void> getCategoryList() async {
  //   Response response = await suggestServiceRepo.getCategoryList();
  //   if(response.statusCode == 200){
  //
  //     serviceCategoryList = [];
  //     List<dynamic> list = response.body['content']['data'];
  //     for (var category in list) {
  //       serviceCategoryList.add(CategoryModel.fromJson(category));
  //     }
  //
  //     serviceCategoryList.add(CategoryModel(
  //       name: "others".tr
  //     ));
  //
  //   }
  //   else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }


  Future<void> getSuggestedServiceList(int offset,{reload = false}) async {
    if(reload){
      suggestedServiceModel= null;
    }
    Response response = await suggestServiceRepo.getSuggestedServiceList(offset);
    if(response.statusCode == 200){
      suggestedServiceModel = SuggestedServiceModel.fromJson(response.body);
      if(offset!=1){
        suggestedServiceList.addAll(suggestedServiceModel!.content!.suggestedServiceList!);
      }else{
        suggestedServiceList = [];
        suggestedServiceList.addAll(suggestedServiceModel!.content!.suggestedServiceList!);
      }
    }
    else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> submitNewServiceRequest() async {
    _isLoading = true;
    update();

    Map<String,String> body={
      "category_id":selectedCategoryId,
      "service_name": serviceNameController.text,
      "service_description": serviceDetailsController.text
    };
    Response response = await suggestServiceRepo.submitNewServiceRequest(body);
    if(response.statusCode == 200){
      clearData();
      customSnackBar("service_request_placed_successfully_to_admin".tr,type : ToasterMessageType.success);
    }
    else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void updateShowInputField(){
    _isShowInputField = true;
    update();
    if(_isShowInputField){
      initialButtonPadding = 570;
      initialImageSize = 70;
      initialContainerOpacity = 1.0;
    }
    update();
  }
  void setIdentityType(CategoryModel? category){
    selectedCategoryName = category?.name ?? "";
    selectedCategoryId = category?.id ?? "";
    update();
  }

  clearData(){
    serviceNameController.text="";
    serviceDetailsController.text = "";
    selectedCategoryName= "";
    selectedCategoryId= "";
  }

}