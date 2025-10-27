import 'package:madaduser/common/models/popup_menu_model.dart';
import 'package:madaduser/feature/checkout/widget/payment_section/incomplete_offline_payment_dialog.dart';
import 'package:madaduser/feature/home/widget/referal_welcome_dialog.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:universal_html/html.dart' as html;


enum BookingDetailsTabs {bookingDetails, status}
class BookingDetailsController extends GetxController implements GetxService{
  BookingDetailsRepo bookingDetailsRepo;
  BookingDetailsController({required this.bookingDetailsRepo});

  BookingDetailsTabs _selectedDetailsTabs = BookingDetailsTabs.bookingDetails;
  BookingDetailsTabs get selectedBookingStatus =>_selectedDetailsTabs;


  final bookingIdController = TextEditingController();
  final phoneController = TextEditingController();
  // Add this inside BookingDetailsController

  List<CalendarEvent> get calendarEvents =>
      _bookingDetailsContent?.calendarEvents ?? [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;

  BookingDetailsContent? _bookingDetailsContent;
  BookingDetailsContent? get bookingDetailsContent => _bookingDetailsContent;

  BookingDetailsContent? _subBookingDetailsContent;
  BookingDetailsContent? get subBookingDetailsContent => _subBookingDetailsContent;

  DigitalPaymentMethod? _selectedDigitalPaymentMethod;
  DigitalPaymentMethod ? get selectedDigitalPaymentMethod => _selectedDigitalPaymentMethod;


  void updateBookingStatusTabs(BookingDetailsTabs bookingDetailsTabs){
    _selectedDetailsTabs = bookingDetailsTabs;
    update();
  }





  void showCustomPayViaOnlineDialog(bookingDetailsId) {
    Get.dialog(
      GetBuilder<CheckOutController>(builder: (checkoutController) {
        return GetBuilder<CartController>(builder: (cartController) {
          AddressModel? addressModel = CheckoutHelper.selectedAddressModel(
              selectedAddress: Get.find<LocationController>().selectedAddress,
              pickedAddress: Get.find<LocationController>().getUserAddress());
          bool isPartialPayment = CheckoutHelper.checkPartialPayment(
              walletBalance: cartController.walletBalance,
              bookingAmount: cartController.totalPrice);
          return Dialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // PAY VIA ONLINE
                  Stack(
                    children: [
                      Opacity(
                        opacity: 1,
                        child: Column(
                          children: [
                            if (checkoutController
                                .digitalPaymentList.isNotEmpty)
                              Row(children: [
                                Text(" ${'pay_via_online'.tr} ",
                                    style: robotoBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault)),
                                Expanded(
                                    child: Text(
                                        'faster_and_secure_way_to_pay_bill'.tr,
                                        style: robotoLight.copyWith(
                                            fontSize:
                                            Dimensions.fontSizeSmall - 2,
                                            color: Colors.amber))),
                              ]),
                            if (checkoutController
                                .digitalPaymentList.isNotEmpty)
                              Container(
                                  child: ListView.builder(
                                    itemCount: checkoutController
                                        .digitalPaymentList.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      bool isSelected = checkoutController
                                          .digitalPaymentList[index] ==
                                          Get.find<CheckOutController>()
                                              .selectedDigitalPaymentMethod;
                                      bool isOffline = checkoutController
                                          .digitalPaymentList[index].gateway ==
                                          'offline';

                                      return InkWell(
                                        onTap: () {
                                          checkoutController.changePaymentMethod(
                                              digitalMethod: checkoutController
                                                  .digitalPaymentList[index]);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Theme.of(context).hoverColor
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.circular(
                                                  Dimensions.radiusDefault),
                                              border: isSelected
                                                  ? Border.all(
                                                  color: Theme.of(context)
                                                      .hintColor
                                                      .withValues(alpha: 0.2),
                                                  width: 0.5)
                                                  : null),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                              Dimensions.paddingSizeDefault,
                                              vertical:
                                              Dimensions.paddingSizeDefault),
                                          child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    checkoutController
                                                        .changePaymentMethod(
                                                        digitalMethod:
                                                        checkoutController
                                                            .digitalPaymentList[
                                                        index]);
                                                  },
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Row(children: [
                                                          Container(
                                                            height: Dimensions
                                                                .paddingSizeLarge,
                                                            width: Dimensions
                                                                .paddingSizeLarge,
                                                            decoration: BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                color: isSelected
                                                                    ? Colors.green
                                                                    : Theme.of(
                                                                    context)
                                                                    .cardColor,
                                                                border: Border.all(
                                                                    color: Theme.of(
                                                                        context)
                                                                        .disabledColor)),
                                                            child: Icon(Icons.check,
                                                                color: isSelected
                                                                    ? Colors.white
                                                                    : Colors
                                                                    .transparent,
                                                                size: 16),
                                                          ),
                                                          const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeDefault),
                                                          isOffline
                                                              ? const SizedBox()
                                                              : ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                Dimensions
                                                                    .radiusSmall),
                                                            child:
                                                            CustomImage(
                                                              height: Dimensions
                                                                  .paddingSizeLarge,
                                                              fit: BoxFit
                                                                  .contain,
                                                              image: checkoutController
                                                                  .digitalPaymentList[
                                                              index]
                                                                  .gatewayImageFullPath ??
                                                                  "",
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: Dimensions
                                                                  .paddingSizeSmall),
                                                          Text(
                                                            isOffline
                                                                ? 'pay_offline'.tr
                                                                : checkoutController
                                                                .digitalPaymentList[
                                                            index]
                                                                .label ??
                                                                "",
                                                            style: robotoMedium.copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault),
                                                          ),
                                                        ]),
                                                        const SizedBox()
                                                      ]),
                                                ),
                                                if (isOffline && isSelected)
                                                  SingleChildScrollView(
                                                    padding: const EdgeInsets.only(
                                                        top: Dimensions
                                                            .paddingSizeExtraLarge),
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child: checkoutController
                                                        .offlinePaymentModelList
                                                        .isNotEmpty
                                                        ? Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: checkoutController
                                                            .offlinePaymentModelList
                                                            .map(
                                                                (offlineMethod) =>
                                                                InkWell(
                                                                  onTap:
                                                                      () {
                                                                    if (isOffline) {
                                                                      checkoutController.changePaymentMethod(
                                                                          offlinePaymentModel: offlineMethod);
                                                                    } else {
                                                                      checkoutController.changePaymentMethod(
                                                                          digitalMethod: checkoutController.digitalPaymentList[index]);
                                                                    }
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                        Dimensions.paddingSizeExtraSmall),
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                        Dimensions.paddingSizeSmall,
                                                                        horizontal: Dimensions.paddingSizeExtraLarge),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color: checkoutController.selectedOfflineMethod == offlineMethod
                                                                          ? Theme.of(context).colorScheme.primary
                                                                          : Theme.of(context).cardColor,
                                                                      border: Border.all(
                                                                          width: 1,
                                                                          color: Theme.of(context).colorScheme.primary.withValues(
                                                                            alpha: checkoutController.selectedOfflineMethod == offlineMethod ? 0.7 : 0.2,
                                                                          )),
                                                                      borderRadius:
                                                                      BorderRadius.circular(Dimensions.radiusDefault),
                                                                    ),
                                                                    child: Text(
                                                                        offlineMethod.methodName ??
                                                                            '',
                                                                        style:
                                                                        robotoMedium.copyWith(color: checkoutController.selectedOfflineMethod == offlineMethod ? Colors.white : null)),
                                                                  ),
                                                                ))
                                                            .toList())
                                                        : Text(
                                                      "no_offline_payment_method_available"
                                                          .tr,
                                                      style: robotoRegular
                                                          .copyWith(
                                                          color: Theme.of(
                                                              context)
                                                              .textTheme
                                                              .bodySmall
                                                              ?.color),
                                                    ),
                                                  ),
                                              ]),
                                        ),
                                      );
                                    },
                                  ))
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        child: Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close the dialog
                          Get.snackbar("Confirmed", "You pressed OK!",
                              snackPosition: SnackPosition.BOTTOM);

                          makeDigitalPayment(
                            addressModel,
                            checkoutController.selectedDigitalPaymentMethod,
                            isPartialPayment,
                            checkoutController,
                            bookingDetailsId,
                          );
                        },

                        child: Text("Pay now"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      }),
      barrierDismissible: false, // Prevent closing when tapping outside
    );
  }






  Future<void> bookingCancel({required String bookingId, bool fromListScreen = false,})async{
    _isCancelling = true;
    update();
    Response? response =  await  bookingDetailsRepo.bookingCancel(bookingID: bookingId);
    if(response.statusCode == 200 && response.body['response_code']=="status_update_success_200"){
      _isCancelling = false;
      customSnackBar('booking_cancelled_successfully'.tr, type : ToasterMessageType.success);
      if(fromListScreen) {
        Get.find<ServiceBookingController>().updateBookingStatusTabs(
            Get.find<ServiceBookingController>().selectedBookingStatus,
        );
      }else{
        await getBookingDetails(bookingId: bookingId);
        Get.find<ServiceBookingController>().updateBookingStatusTabs(
          Get.find<ServiceBookingController>().selectedBookingStatus,
        );
      }

    }else if(response.statusCode == 200 && (response.body['response_code'] == "booking_already_accepted_200"
        || response.body['response_code'] == "booking_already_ongoing_200" || response.body['response_code'] == "booking_already_completed_200")){
      customSnackBar(response.body['message'] ?? "");
      await getBookingDetails(bookingId: bookingId);
      _isCancelling = false;
    }
    else{
      _isCancelling = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> subBookingCancel({required String subBookingId})async{
    _isCancelling = true;
    update();
    Response? response =  await  bookingDetailsRepo.subBookingCancel(bookingID: subBookingId);
    if(response.statusCode == 200 ){
      _isCancelling = false;

      await getSubBookingDetails(bookingId: subBookingId);
      if(_bookingDetailsContent != null){
        getBookingDetails(bookingId: _bookingDetailsContent?.id ?? "", reload : false );
      }
      customSnackBar('booking_cancelled_successfully'.tr, type : ToasterMessageType.success);
    } else{
      _isCancelling = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBookingDetails({required String bookingId, bool reload = true})async{
    if(reload){
      _bookingDetailsContent = null;
    }
    Response response = await bookingDetailsRepo.getBookingDetails(bookingID: bookingId);
    print('API Responsehh: ${response.body}');
    if(response.statusCode == 200){
      _bookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);
      print('Parsed Content: $_bookingDetailsContent');
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getSubBookingDetails({required String bookingId})async{

    _subBookingDetailsContent = null;
    Response response = await bookingDetailsRepo.getSubBookingDetails(bookingID: bookingId);
    if(response.statusCode == 200){
      _subBookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);

    } else {
      ApiChecker.checkApi(response);
    }
    update();

  }


  Future<void> trackBookingDetails(String bookingReadableId, String phone, {bool reload = false}) async {
    if(reload){
      _isLoading = true;
      update();
    }
    if( reload || _bookingDetailsContent == null){

      Response response = await bookingDetailsRepo.trackBookingDetails(bookingID: bookingReadableId, phoneNUmber: phone);
      if(response.statusCode == 200){
        _bookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);
        update();
      }else{
        _bookingDetailsContent = null;
        _isLoading = false;
        update();
      }
    }
    if(reload){
      _isLoading = false;
      update();
    }

  }

  void updateSelectedDigitalPayment({DigitalPaymentMethod? value, bool shouldUpdate = true}){
    _selectedDigitalPaymentMethod = value;
    if(shouldUpdate){
      update();
    }
  }

  void resetBookingDetailsValue({bool shouldUpdate = false, bool resetBookingDetails = false}){
    _selectedDetailsTabs = BookingDetailsTabs.bookingDetails;
    _subBookingDetailsContent = null;
    if(resetBookingDetails){
      _bookingDetailsContent = null;
    }
  }


  void resetTrackingData({bool shouldUpdate = true}){
    bookingIdController.clear();
    phoneController.clear();
    _bookingDetailsContent = null;

    if(shouldUpdate){
      update();
    }
  }

  void manageDialog(){

    var userData = Get.find<UserController>().userInfoModel;
    if(Get.find<AuthController>().isLoggedIn() && userData !=null && userData.lastIncompleteOfflineBooking != null && getLastIncompleteOfflineBookingId() != userData.lastIncompleteOfflineBooking?.id){
     if(Get.isDialogOpen == false){
       if(ResponsiveHelper.isDesktop(Get.context)){
         Get.dialog(Center(child: IncompleteOfflinePaymentDialog(booking: Get.find<UserController>().userInfoModel?.lastIncompleteOfflineBooking,))).then((value){
           setLastIncompleteOfflineBookingId(userData.lastIncompleteOfflineBooking?.id ?? "");
         });
       }else{
         showModalBottomSheet(context: Get.context!,
           builder: (_){
             return  IncompleteOfflinePaymentDialog(booking: Get.find<UserController>().userInfoModel?.lastIncompleteOfflineBooking,);
           },
           backgroundColor: Colors.transparent,
         ).then((value){
           setLastIncompleteOfflineBookingId(userData.lastIncompleteOfflineBooking?.id ?? "");
         });
       }
     }
    }

    if(Get.find<ServiceController>().allService !=null && Get.find<ServiceController>().allService!.isNotEmpty && (Get.currentRoute.contains(RouteHelper.home) || Get.currentRoute.contains("/?page=home"))){
      if(Get.find<UserController>().showReferWelcomeDialog() && Get.find<AuthController>().getIsShowReferralBottomSheet() == true){
        Future.delayed(const Duration(microseconds: 500), () {
          showModalBottomSheet(
            isDismissible: false,
            context: Get.context!,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (context) => const ReferWelcomeDialog(),
            backgroundColor: Colors.transparent,
          );
        });
      }
    }
  }

  Future<void>  setLastIncompleteOfflineBookingId(String bookingId) async {
    await  bookingDetailsRepo.setLastIncompleteOfflineBookingId(bookingId);
  }

  String getLastIncompleteOfflineBookingId() {
    return bookingDetailsRepo.getLastIncompleteOfflineBookingId();
  }

  List<PopupMenuModel> getPopupMenuList(String status) {
    if (status == "pending") {
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        PopupMenuModel(title: "cancel", icon: Icons.cancel_outlined),
      ];
    } else if(status == "completed"){
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        PopupMenuModel(title: "review", icon: Icons.reviews_outlined),
      ];
    }
    return [];
  }

  List<PopupMenuModel> getPServiceLogMenuList({required String status,  bool nextService = false}) {

    if (status == "pending") {
      return [
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),

      ];
    } else if (status == "accepted") {
      return [
        if(nextService) PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),
        if(!nextService) PopupMenuModel(title: "cancel", icon: Icons.cancel_outlined),
      ];
    }

    else if (status == "ongoing" || status == "completed" || status == "canceled") {
      return [
        PopupMenuModel(title: "booking_details", icon: Icons.remove_red_eye),
        PopupMenuModel(title: "download_invoice", icon: Icons.file_download_outlined),

      ];
    }
    return [];
  }


  makeDigitalPayment(
      AddressModel? address,
      DigitalPaymentMethod? paymentMethod,
      bool isPartialPayment,
      CheckOutController checkoutController,
      String bookingDetailsId
      ) {
    String url = '';
    String hostname = html.window.location.hostname!;
    String protocol = html.window.location.protocol;
    String port = html.window.location.port;
    String? path = html.window.location.pathname;
    SignUpBody? newUserInfo = CheckoutHelper.getNewUserInfo(
        address: address,
        password: checkoutController.passwordController.text,
        isCheckedCreateAccount: checkoutController.isCheckedCreateAccount);

    String? schedule = Get.find<ScheduleController>().scheduleTime;
    String userId = Get.find<UserController>().userInfoModel?.id ??
        Get.find<SplashController>().getGuestId();
    String encodedAddress =
    base64Encode(utf8.encode(jsonEncode(address?.toJson())));
    String encodedNewUserInfo =
    base64Encode(utf8.encode(jsonEncode(newUserInfo?.toJson())));

    String addressId =
    (address?.id == "null" || address?.id == null) ? "" : address?.id ?? "";
    String zoneId =
        Get.find<LocationController>().getUserAddress()?.zoneId ?? "";
    String callbackUrl = GetPlatform.isWeb
        ? "$protocol//$hostname:$port$path"
        : AppConstants.baseUrl;
    int isPartial =
    Get.find<CartController>().walletPaymentStatus && isPartialPayment
        ? 1
        : 0;
    String platform = ResponsiveHelper.isWeb() ? "web" : "app";

    url = '${AppConstants.baseUrl}/payment?payment_method=${paymentMethod?.gateway}&access_token=${base64Url.encode(utf8.encode(userId))}&zone_id=$zoneId'
        '&service_schedule=$schedule&service_address_id=$addressId&callback=$callbackUrl&service_address=$encodedAddress&new_user_info=$encodedNewUserInfo&is_partial=$isPartial&payment_platform=$platform&booking_id=$bookingDetailsId';

    print('pain $url');

    if (GetPlatform.isWeb) {
      printLog("url_with_digital_payment:$url");
      html.window.open(url, "_self");
    } else {
      printLog("url_with_digital_payment_mobile:$url");
      Get.to(() => PaymentScreen(
        url: url,
        fromPage: "checkout",
      ));
    }
  }

  void showCancelBookingDialog(String? id) {}




}