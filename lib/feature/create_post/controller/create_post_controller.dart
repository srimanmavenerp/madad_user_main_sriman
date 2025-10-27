import 'dart:convert';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class CreatePostController extends GetxController implements GetxService{

  final CreatePostRepo createPostRepo;
  CreatePostController({required this.createPostRepo});

  bool _isLoading= false;
  bool get isLoading => _isLoading;


  String selectedCategoryName= "";
  String selectedCategoryId= "";



  int _offset = 1;
  int get offset => _offset;

  Service? selectedService;

  List<String> additionalInstruction = [];

  TextEditingController descriptionController = TextEditingController();
  TextEditingController additionalInstructionController = TextEditingController();

  PostModel? postModel;
  List<List<MyPostData>>? listOfMyPost= [];
  List allPostList=[];
  List<String> dateList = [];

  ProviderOfferModel? providerOfferModel;
  List<ProviderOfferData>? listOfProviderOffer = [];

  ProviderOfferData? notificationBiddingDetails;


  Future<void> createCustomPost(String? schedule, {AddressModel? serviceAddress }) async {
    _isLoading = true;
    update();
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress;

    Response  response = await createPostRepo.createCustomPost(
      CreatePostBody(
        serviceId: selectedService?.id,
        categoryId: selectedService?.categoryId,
        subCategoryId: selectedService?.subCategoryId,
        addressId: addressModel?.id == "null" || addressModel?.id == null ? "" :  addressModel?.id,
        serviceDescription: descriptionController.text,
        serviceSchedule: schedule,
        additionDescriptions: additionalInstruction,
        serviceAddress: jsonEncode(serviceAddress)
      )
    );

    if(response.statusCode==200){
      resetCreatePostValue();
      Get.offNamed(RouteHelper.getCreatePostSuccessfullyScreen());
      customSnackBar("your_post_has_been_created_successfully".tr,type : ToasterMessageType.success);
    }else{
      customSnackBar( response.body['message'] ?? response.statusText);
    }
    _isLoading = false;
    update();
  }




  Future<void> getMyPostList(int offset,{reload = false}) async {
    _offset = offset;
    if(reload){
      allPostList = [];
      listOfMyPost = [];
      dateList = [];
    }
    _isLoading = true;
    Response response = await createPostRepo.getMyPostList(offset);
    if(response.statusCode == 200){
      allPostList =[];
      postModel = PostModel.fromJson(response.body);
      for (var data in postModel!.content!.data!) {
        if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
          dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
        }
      }

      for (var data in postModel!.content!.data!) {
        allPostList.add(data);
      }

      for(int i=0;i< dateList.length;i++){
        listOfMyPost?.add([]);
        for (var element in allPostList) {
          if(dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            listOfMyPost![i].add(element);
          }
        }
      }
      _isLoading =false;
    } else{
      _isLoading =false;
    }
    update();
  }


  Future<void> getProvidersOfferList(int offset,String postId,{reload = false}) async {
    if(reload && providerOfferModel == null){
      providerOfferModel= null;
      providerOfferModel = null;
    }
    Response response = await createPostRepo.getProvidersOfferList(offset,postId);

    providerOfferModel = ProviderOfferModel.fromJson(response.body);


    if(response.statusCode == 200 && response.body["response_code"]=="default_200"){
      if(offset!=1){
        listOfProviderOffer!.addAll(providerOfferModel!.content!.data!);
      }else{
        listOfProviderOffer = [];
        listOfProviderOffer!.addAll(providerOfferModel!.content!.data!);
      }
    }
    else {
      listOfProviderOffer = [];
    }
    update();
  }


  Future<void> providerBidDetailsForNotification(String postId,String providerId) async {
    Response response = await createPostRepo.getProviderBidDetails(postId,providerId);
    if(response.statusCode==200){

      if(response.body['content']!=null){
        notificationBiddingDetails = ProviderOfferData.fromJson(response.body['content']['post_bid']);

        showGeneralDialog(
          context: Get.context!,
          barrierDismissible: true,
          transitionDuration: const Duration(milliseconds: 500),
          barrierLabel: MaterialLocalizations.of(Get.context!).dialogLabel,
          barrierColor: Colors.black.withValues(alpha: 0.5),
          pageBuilder: (context, _, __) {
            return ProviderBiddingNotificationDialog(providerOfferData: notificationBiddingDetails??ProviderOfferData(), postId: postId,);
          },
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ).drive(Tween<Offset>(
                begin: const Offset(0, -1.0),
                end: Offset.zero,
              )),
              child: child,
            );
          },
        );


      }else{
        notificationBiddingDetails = null;
      }

    }
    else{
      notificationBiddingDetails = null;
    }
    update();
  }

  Future<Response> updatePostStatus(String postId, String providerId, String status, {int? isPartial, String? serviceAddress, String? serviceAddressId}) async {
    Response response = await createPostRepo.updatePostStatus(postId, providerId, status, isPartial: isPartial, serviceAddress: serviceAddress, serviceAddressId: serviceAddressId);

    return response;
  }

  Future<Response> makePayment({String? postId, String? providerId, String? paymentMethod, String? offlinePaymentId, String? customerInfo, int? isPartial} ) async {

    String zoneId = Get.find<LocationController>().getUserAddress()!.zoneId.toString();
    String? schedule = Get.find<ScheduleController>().scheduleTime;
    AddressModel? addressModel = Get.find<LocationController>().selectedAddress ?? Get.find<LocationController>().getUserAddress();

    Response response = await createPostRepo.makePayment(
      paymentMethod : paymentMethod,
      postId : postId,
      providerId : providerId,
      schedule : schedule,
      serviceAddressID : addressModel?.id.toString() ?? "",
      address: jsonEncode(addressModel),
      zoneId : zoneId,
      offlinePaymentId: offlinePaymentId,
      customerInformation: customerInfo,
      isPartial: isPartial
    );
    return response;
  }


  void selectCategory(String id){
    if(Get.find<CategoryController>().categoryList!=null){
      for (var element in Get.find<CategoryController>().categoryList!) {
        if(element.id==id){
          selectedCategoryName =element.name!;
          selectedCategoryId =element.id!;
        }
      }
      update();
    }
  }



  void updateSelectedService(Service? newService){
    selectedService = newService;
    selectedCategoryName = newService?.category?.name ?? "";
    selectedCategoryId = newService?.category?.id ?? "";
    update();
  }


  void addAdditionalInstruction(String newInstruction){
    additionalInstruction.add(newInstruction);
    additionalInstructionController.text = '';
    update();
  }


  void removeAdditionalInstruction(int index){
    additionalInstruction.removeAt(index);
    update();
  }


  void resetCreatePostValue({bool removeService = true}){
    _isLoading = false;
    selectedCategoryName= "";
    selectedCategoryId= "";
    additionalInstruction = [];
    descriptionController.clear();
    if(removeService){
      selectedService= null;
    }
  }

  bool checkProviderAvailability({required ProviderData providerData}){
    return providerData.nextBookingEligibility ?? false;
  }
}