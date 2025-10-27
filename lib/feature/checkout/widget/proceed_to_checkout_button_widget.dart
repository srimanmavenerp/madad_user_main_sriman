//
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
// import 'package:universal_html/html.dart' as html;
//
// class ProceedToCheckoutButtonWidget extends StatefulWidget {
//   final String pageState;
//   final String addressId;
//   const ProceedToCheckoutButtonWidget({
//     super.key,
//     required this.pageState,
//     required this.addressId,
//   });
//
//   @override
//   State<ProceedToCheckoutButtonWidget> createState() =>
//       _ProceedToCheckoutButtonWidgetState();
// }
//
// class _ProceedToCheckoutButtonWidgetState
//     extends State<ProceedToCheckoutButtonWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ScheduleController>(builder: (scheduleController) {
//       return GetBuilder<CartController>(builder: (cartController) {
//         // Check if cart contains blocked subcategory
//         bool hasBlockedSubCategory = cartController.cartList.any(
//               (item) =>
//           item.subCategoryId ==
//               '1a5bf45c-9d32-4f4e-a726-126e1a40c836',
//         );
//
//         String? errorText = cartController.checkScheduleBookingAvailability();
//         double totalAmount = cartController.totalPrice;
//         bool isPartialPayment = CheckoutHelper.checkPartialPayment(
//           walletBalance: cartController.walletBalance,
//           bookingAmount: cartController.totalPrice,
//         );
//         String? schedule = scheduleController.scheduleTime;
//
//         ConfigModel configModel = Get.find<SplashController>().configModel;
//         bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
//         bool createGuestAccount =
//             Get.find<SplashController>().configModel.content?.createGuestUserAccount == 1;
//
//         return GetBuilder<CheckOutController>(builder: (checkoutController) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: Dimensions.paddingSizeDefault),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Conditionally show total price (hide if blocked subcategory exists)
//                 if (!hasBlockedSubCategory)
//                   Padding(
//                     padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//                     child: Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "total_price".tr,
//                             style: robotoRegular.copyWith(
//                               fontSize: Dimensions.fontSizeDefault,
//                               color: Theme.of(context).textTheme.bodyLarge!.color,
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Directionality(
//                             textDirection: TextDirection.ltr,
//                             child: Text(
//                               PriceConverter.convertPrice(totalAmount),
//                               style: robotoBold.copyWith(
//                                 color: Theme.of(context).colorScheme.error,
//                                 fontSize: Dimensions.fontSizeDefault,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 CustomButton(
//                   height: 50,
//                   radius: Dimensions.radiusDefault,
//                   isLoading: checkoutController.isLoading,
//                   fontSize: Dimensions.fontSizeDefault + 1,
//                   buttonText: cartController.cartList.isEmpty
//                       ? "empty_cart_go_back".tr
//                       : (widget.pageState == "orderDetails" &&
//                       checkoutController.currentPageState == PageState.orderDetails)
//                       ? "make_payment".tr
//                       : 'confirm_booking'.tr,
//                   onPressed: (widget.pageState == "payment" ||
//                       checkoutController.currentPageState == PageState.payment) &&
//                       checkoutController.othersPaymentList.isEmpty &&
//                       checkoutController.digitalPaymentList.isEmpty
//                       ? null
//                       : () {
//                     if (errorText != null &&
//                         scheduleController.selectedScheduleType !=
//                             ScheduleType.asap) {
//                       customSnackBar(errorText.tr);
//                     } else if (checkoutController.acceptTerms ||
//                         cartController.cartList.isEmpty) {
//                       AddressModel? addressModel =
//                       CheckoutHelper.selectedAddressModel(
//                         selectedAddress:
//                         Get.find<LocationController>().selectedAddress,
//                         pickedAddress: Get.find<LocationController>().getUserAddress(),
//                         selectedLocationType:
//                         Get.find<LocationController>().selectedServiceLocationType,
//                       );
//
//                       if (cartController.cartList.isEmpty) {
//                         Get.offAllNamed(RouteHelper.getMainRoute('home'));
//                       } else if (cartController.cartList.isNotEmpty &&
//                           cartController.cartList.first.provider != null &&
//                           (cartController.cartList[0].provider?.serviceAvailability == 0 ||
//                               cartController.cartList[0].provider?.isActive == 0)) {
//                         Future.delayed(const Duration(milliseconds: 50)).then((value) {
//                           Future.delayed(const Duration(milliseconds: 500)).then((value) {
//                             showModalBottomSheet(
//                               useRootNavigator: true,
//                               isScrollControlled: true,
//                               backgroundColor: Colors.transparent,
//                               context: Get.context!,
//                               builder: (context) => AvailableProviderWidget(
//                                 subcategoryId:
//                                 Get.find<CartController>().cartList.first.subCategoryId,
//                                 showUnavailableError: true,
//                               ),
//                             );
//                           });
//
//                           customSnackBar(
//                             "your_selected_provider_is_unavailable_right_now".tr,
//                             duration: 3,
//                             type: ToasterMessageType.info,
//                           );
//                         });
//                       } else if (checkoutController.currentPageState == PageState.orderDetails &&
//                           PageState.orderDetails.name == widget.pageState) {
//                         // Validation checks for schedule and address etc.
//                         if (schedule == null &&
//                             scheduleController.selectedScheduleType != ScheduleType.asap &&
//                             scheduleController.selectedServiceType == ServiceType.regular) {
//                           customSnackBar("select_your_preferable_booking_time".tr,
//                               type: ToasterMessageType.info);
//                         } else if (scheduleController.selectedScheduleType == ScheduleType.schedule &&
//                             configModel.content?.scheduleBookingTimeRestriction == 1 &&
//                             scheduleController.checkValidityOfTimeRestriction(
//                                 Get.find<SplashController>()
//                                     .configModel
//                                     .content!
//                                     .advanceBooking!) !=
//                                 null &&
//                             scheduleController.selectedServiceType == ServiceType.regular) {
//                           customSnackBar(scheduleController
//                               .checkValidityOfTimeRestriction(Get.find<SplashController>()
//                               .configModel
//                               .content!
//                               .advanceBooking!));
//                         } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                             scheduleController.selectedRepeatBookingType ==
//                                 RepeatBookingType.daily &&
//                             scheduleController.pickedDailyRepeatBookingDateRange == null) {
//                           customSnackBar("daily_select_time_and_date_hint".tr,
//                               type: ToasterMessageType.info);
//                         } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                             scheduleController.selectedRepeatBookingType ==
//                                 RepeatBookingType.daily &&
//                             scheduleController.pickedDailyRepeatTime == null) {
//                           customSnackBar("select_time_hint".tr,
//                               type: ToasterMessageType.info);
//                         } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                             scheduleController.selectedRepeatBookingType ==
//                                 RepeatBookingType.weekly &&
//                             scheduleController.getWeeklyPickedDays().isEmpty) {
//                           customSnackBar("weekly_select_time_and_date_hint".tr,
//                               type: ToasterMessageType.info);
//                         } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                             scheduleController.selectedRepeatBookingType ==
//                                 RepeatBookingType.weekly &&
//                             scheduleController.pickedWeeklyRepeatTime == null) {
//                           customSnackBar("select_time_hint".tr,
//                               type: ToasterMessageType.info);
//                         } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                             scheduleController.selectedRepeatBookingType ==
//                                 RepeatBookingType.custom &&
//                             scheduleController.pickedCustomRepeatBookingDateTimeList.isEmpty) {
//                           customSnackBar("custom_select_time_and_date_hint".tr,
//                               type: ToasterMessageType.info);
//                         } else if (addressModel == null) {
//                           customSnackBar("add_address_first".tr,
//                               type: ToasterMessageType.info);
//                         } else if ((addressModel.contactPersonName == "null" ||
//                             addressModel.contactPersonName == null ||
//                             addressModel.contactPersonName!.isEmpty) ||
//                             (addressModel.contactPersonNumber == "null" ||
//                                 addressModel.contactPersonNumber == null ||
//                                 addressModel.contactPersonNumber!.isEmpty)) {
//                           customSnackBar(
//                               "please_input_contact_person_name_and_phone_number".tr,
//                               type: ToasterMessageType.info);
//                         } else if (checkoutController.isCheckedCreateAccount &&
//                             checkoutController.passwordController.text.isEmpty) {
//                           customSnackBar("please_input_new_account_password".tr,
//                               type: ToasterMessageType.info);
//                         } else if (checkoutController.isCheckedCreateAccount &&
//                             checkoutController.confirmPasswordController.text.isEmpty) {
//                           customSnackBar("please_input_confirm_password".tr,
//                               type: ToasterMessageType.info);
//                         } else if (checkoutController.isCheckedCreateAccount &&
//                             checkoutController.confirmPasswordController.text !=
//                                 checkoutController.passwordController.text) {
//                           customSnackBar("confirm_password_does_not_matched".tr,
//                               type: ToasterMessageType.info);
//                         } else {
//                           if (checkoutController.isCheckedCreateAccount &&
//                               !isLoggedIn &&
//                               createGuestAccount) {
//                             checkoutController
//                                 .checkExistingUser(
//                                 phone: "${addressModel.contactPersonNumber}")
//                                 .then((value) {
//                               if (!value) {
//                                 customSnackBar('phone_already_taken'.tr,
//                                     type: ToasterMessageType.info);
//                               } else {
//                                 checkoutController.updateState(PageState.payment);
//                               }
//                             });
//                           } else {
//                             checkoutController.updateState(PageState.payment);
//                           }
//                         }
//                       } else if (checkoutController.currentPageState == PageState.payment ||
//                           PageState.payment.name == widget.pageState) {
//                         if (scheduleController.selectedServiceType == ServiceType.repeat) {
//                           checkoutController.placeBookingRequest(
//                             paymentMethod: "cash_after_service",
//                             schedule: schedule!,
//                             isPartial: 0,
//                             address: addressModel!,
//                           );
//                         } else if (cartController.walletPaymentStatus &&
//                             isPartialPayment &&
//                             checkoutController.selectedPaymentMethod ==
//                                 PaymentMethodName.walletMoney) {
//                           customSnackBar(
//                               "select_another_payment_method_to_pay_remaining_bill".tr,
//                               type: ToasterMessageType.info);
//                         } else if (checkoutController.selectedPaymentMethod ==
//                             PaymentMethodName.none) {
//                           customSnackBar("select_payment_method".tr,
//                               type: ToasterMessageType.info);
//                         } else if (checkoutController.selectedPaymentMethod ==
//                             PaymentMethodName.cos) {
//                           checkoutController.placeBookingRequest(
//                             paymentMethod: "cash_after_service",
//                             schedule: schedule!,
//                             isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                             address: addressModel!,
//                           );
//                         } else if (checkoutController.selectedPaymentMethod ==
//                             PaymentMethodName.walletMoney) {
//                           checkoutController.placeBookingRequest(
//                               paymentMethod: "wallet_payment",
//                               schedule: schedule!,
//                               isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                               address: addressModel!);
//                         } else if (checkoutController.selectedPaymentMethod ==
//                             PaymentMethodName.offline) {
//                           double bookingAmount = isPartialPayment
//                               ? (totalAmount - cartController.walletBalance)
//                               : totalAmount;
//                           if (checkoutController.selectedOfflineMethod != null) {
//                             int selectedOfflinePaymentIndex = checkoutController
//                                 .offlinePaymentModelList
//                                 .indexOf(checkoutController.selectedOfflineMethod!);
//                             checkoutController.placeBookingRequest(
//                               paymentMethod: "offline_payment",
//                               schedule: schedule!,
//                               isPartial:
//                               isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                               address: addressModel!,
//                               offlinePaymentId: checkoutController.selectedOfflineMethod?.id,
//                               selectedOfflinePaymentIndex:
//                               selectedOfflinePaymentIndex != -1 ? selectedOfflinePaymentIndex : 0,
//                               bookingAmount: bookingAmount,
//                             );
//                           } else {
//                             customSnackBar("provide_offline_payment_info".tr,
//                                 type: ToasterMessageType.info);
//                           }
//                         } else if (checkoutController.selectedPaymentMethod ==
//                             PaymentMethodName.digitalPayment) {
//                           if (checkoutController.selectedDigitalPaymentMethod !=
//                               null &&
//                               checkoutController.selectedDigitalPaymentMethod?.gateway !=
//                                   "offline") {
//                             _makeDigitalPayment(addressModel,
//                                 checkoutController.selectedDigitalPaymentMethod, isPartialPayment, checkoutController);
//                           } else {
//                             customSnackBar("select_any_payment_method".tr,
//                                 type: ToasterMessageType.info);
//                           }
//                         }
//                       } else {
//                         if (kDebugMode) {
//                           print("In Here");
//                         }
//                       }
//                     } else {
//                       customSnackBar('please_agree_with_terms_conditions'.tr,
//                           type: ToasterMessageType.info);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//       });
//     });
//   }
//
//   _makeDigitalPayment(AddressModel? address, DigitalPaymentMethod? paymentMethod,
//       bool isPartialPayment, CheckOutController checkoutController) {
//     String url = '';
//     String hostname = html.window.location.hostname!;
//     String protocol = html.window.location.protocol;
//     String port = html.window.location.port;
//     String? path = html.window.location.pathname;
//     SignUpBody? newUserInfo = CheckoutHelper.getNewUserInfo(
//         address: address,
//         password: checkoutController.passwordController.text,
//         isCheckedCreateAccount: checkoutController.isCheckedCreateAccount);
//
//     String? schedule = Get.find<ScheduleController>().scheduleTime;
//     String userId = Get.find<UserController>().userInfoModel?.id ??
//         Get.find<SplashController>().getGuestId();
//     String encodedAddress = base64Encode(utf8.encode(jsonEncode(address?.toJson())));
//     String encodedNewUserInfo =
//     base64Encode(utf8.encode(jsonEncode(newUserInfo?.toJson())));
//     String serviceLocation = Get.find<LocationController>().selectedServiceLocationType.name;
//
//     String addressId = (address?.id == "null" || address?.id == null) ? "" : address?.id ?? "";
//     String zoneId = Get.find<LocationController>().getUserAddress()?.zoneId ?? "";
//     String callbackUrl =
//     GetPlatform.isWeb ? "$protocol//$hostname:$port$path" : AppConstants.baseUrl;
//     int isPartial = Get.find<CartController>().walletPaymentStatus && isPartialPayment ? 1 : 0;
//     String platform = ResponsiveHelper.isWeb() ? "web" : "app";
//
//     url =
//     '${AppConstants.baseUrl}/payment?payment_method=${paymentMethod?.gateway}&access_token=${base64Url.encode(utf8.encode(userId))}&zone_id=$zoneId'
//         '&service_schedule=$schedule&service_address_id=$addressId&callback=$callbackUrl'
//         '&service_address=$encodedAddress&new_user_info=$encodedNewUserInfo&is_partial=$isPartial'
//         '&payment_platform=$platform&service_location=$serviceLocation';
//
//     if (GetPlatform.isWeb) {
//       printLog("url_with_digital_payment:$url");
//       html.window.open(url, "_self");
//     } else {
//       printLog("url_with_digital_payment_mobile:$url");
//       Get.to(() => PaymentScreen(url: url, fromPage: "checkout"));
//     }
//   }
// }




import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:universal_html/html.dart' as html;

class ProceedToCheckoutButtonWidget extends StatefulWidget {
  final String pageState;
  final String addressId;
  const ProceedToCheckoutButtonWidget({
    super.key,
    required this.pageState,
    required this.addressId,
  });

  @override
  State<ProceedToCheckoutButtonWidget> createState() =>
      _ProceedToCheckoutButtonWidgetState();
}

class _ProceedToCheckoutButtonWidgetState
    extends State<ProceedToCheckoutButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(builder: (scheduleController) {
      return GetBuilder<CartController>(builder: (cartController) {
        // Check if cart contains blocked subcategory
        bool hasBlockedSubCategory = cartController.cartList.any(
              (item) =>
          item.subCategoryId ==
              '1a5bf45c-9d32-4f4e-a726-126e1a40c836',
        );

        String? errorText = cartController.checkScheduleBookingAvailability();
        double totalAmount = cartController.totalPrice;
        bool isPartialPayment = CheckoutHelper.checkPartialPayment(
          walletBalance: cartController.walletBalance,
          bookingAmount: cartController.totalPrice,
        );
        String? schedule = scheduleController.scheduleTime;
        String? slot = scheduleController.getSlot();

        ConfigModel configModel = Get.find<SplashController>().configModel;
        bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
        bool createGuestAccount =
            Get.find<SplashController>().configModel.content?.createGuestUserAccount == 1;

        return GetBuilder<CheckOutController>(builder: (checkoutController) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Conditionally show total price (hide if blocked subcategory exists)
                if (!hasBlockedSubCategory)
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "total_price".tr,
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              PriceConverter.convertPrice(totalAmount),
                              style: robotoBold.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: Dimensions.fontSizeDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                CustomButton(
                  height: 50,
                  radius: Dimensions.radiusDefault,
                  isLoading: checkoutController.isLoading,
                  fontSize: Dimensions.fontSizeDefault + 1,
                  buttonText: cartController.cartList.isEmpty
                      ? "empty_cart_go_back".tr
                      : (widget.pageState == "orderDetails" &&
                      checkoutController.currentPageState == PageState.orderDetails)
                      ? "make_payment".tr
                      : 'confirm_booking'.tr,
                  onPressed: (widget.pageState == "payment" ||
                      checkoutController.currentPageState == PageState.payment) &&
                      checkoutController.othersPaymentList.isEmpty &&
                      checkoutController.digitalPaymentList.isEmpty
                      ? null
                      : () {
                    if (errorText != null &&
                        scheduleController.selectedScheduleType !=
                            ScheduleType.asap) {
                      customSnackBar(errorText.tr);
                    } else if (checkoutController.acceptTerms ||
                        cartController.cartList.isEmpty) {
                      AddressModel? addressModel =
                      CheckoutHelper.selectedAddressModel(
                        selectedAddress:
                        Get.find<LocationController>().selectedAddress,
                        pickedAddress: Get.find<LocationController>().getUserAddress(),
                        selectedLocationType:
                        Get.find<LocationController>().selectedServiceLocationType,
                      );

                      if (cartController.cartList.isEmpty) {
                        Get.offAllNamed(RouteHelper.getMainRoute('home'));
                      } else if (cartController.cartList.isNotEmpty &&
                          cartController.cartList.first.provider != null &&
                          (cartController.cartList[0].provider?.serviceAvailability == 0 ||
                              cartController.cartList[0].provider?.isActive == 0)) {
                        Future.delayed(const Duration(milliseconds: 50)).then((value) {
                          Future.delayed(const Duration(milliseconds: 500)).then((value) {
                            showModalBottomSheet(
                              useRootNavigator: true,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: Get.context!,
                              builder: (context) => AvailableProviderWidget(
                                subcategoryId:
                                Get.find<CartController>().cartList.first.subCategoryId,
                                showUnavailableError: true,
                              ),
                            );
                          });

                          customSnackBar(
                            "your_selected_provider_is_unavailable_right_now".tr,
                            duration: 3,
                            type: ToasterMessageType.info,
                          );
                        });
                      } else if (checkoutController.currentPageState == PageState.orderDetails &&
                          PageState.orderDetails.name == widget.pageState) {
                        // Validation checks for schedule and address etc.
                        if (schedule == null &&
                            scheduleController.selectedScheduleType != ScheduleType.asap &&
                            scheduleController.selectedServiceType == ServiceType.regular) {
                          customSnackBar("select_your_preferable_booking_time".tr,
                              type: ToasterMessageType.info);
                        } else if (scheduleController.selectedScheduleType == ScheduleType.schedule &&
                            configModel.content?.scheduleBookingTimeRestriction == 1 &&
                            scheduleController.checkValidityOfTimeRestriction(
                                Get.find<SplashController>()
                                    .configModel
                                    .content!
                                    .advanceBooking!) !=
                                null &&
                            scheduleController.selectedServiceType == ServiceType.regular) {
                          customSnackBar(scheduleController
                              .checkValidityOfTimeRestriction(Get.find<SplashController>()
                              .configModel
                              .content!
                              .advanceBooking!));
                        } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
                            scheduleController.selectedRepeatBookingType ==
                                RepeatBookingType.daily &&
                            scheduleController.pickedDailyRepeatBookingDateRange == null) {
                          customSnackBar("daily_select_time_and_date_hint".tr,
                              type: ToasterMessageType.info);
                        } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
                            scheduleController.selectedRepeatBookingType ==
                                RepeatBookingType.daily &&
                            scheduleController.pickedDailyRepeatTime == null) {
                          customSnackBar("select_time_hint".tr,
                              type: ToasterMessageType.info);
                        } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
                            scheduleController.selectedRepeatBookingType ==
                                RepeatBookingType.weekly &&
                            scheduleController.getWeeklyPickedDays().isEmpty) {
                          customSnackBar("weekly_select_time_and_date_hint".tr,
                              type: ToasterMessageType.info);
                        } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
                            scheduleController.selectedRepeatBookingType ==
                                RepeatBookingType.weekly &&
                            scheduleController.pickedWeeklyRepeatTime == null) {
                          customSnackBar("select_time_hint".tr,
                              type: ToasterMessageType.info);
                        } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
                            scheduleController.selectedRepeatBookingType ==
                                RepeatBookingType.custom &&
                            scheduleController.pickedCustomRepeatBookingDateTimeList.isEmpty) {
                          customSnackBar("custom_select_time_and_date_hint".tr,
                              type: ToasterMessageType.info);
                        } else if (addressModel == null) {
                          customSnackBar("add_address_first".tr,
                              type: ToasterMessageType.info);
                        } else if ((addressModel.contactPersonName == "null" ||
                            addressModel.contactPersonName == null ||
                            addressModel.contactPersonName!.isEmpty) ||
                            (addressModel.contactPersonNumber == "null" ||
                                addressModel.contactPersonNumber == null ||
                                addressModel.contactPersonNumber!.isEmpty)) {
                          customSnackBar(
                              "please_input_contact_person_name_and_phone_number".tr,
                              type: ToasterMessageType.info);
                        } else if (checkoutController.isCheckedCreateAccount &&
                            checkoutController.passwordController.text.isEmpty) {
                          customSnackBar("please_input_new_account_password".tr,
                              type: ToasterMessageType.info);
                        } else if (checkoutController.isCheckedCreateAccount &&
                            checkoutController.confirmPasswordController.text.isEmpty) {
                          customSnackBar("please_input_confirm_password".tr,
                              type: ToasterMessageType.info);
                        } else if (checkoutController.isCheckedCreateAccount &&
                            checkoutController.confirmPasswordController.text !=
                                checkoutController.passwordController.text) {
                          customSnackBar("confirm_password_does_not_matched".tr,
                              type: ToasterMessageType.info);
                        } else {
                          if (checkoutController.isCheckedCreateAccount &&
                              !isLoggedIn &&
                              createGuestAccount) {
                            checkoutController
                                .checkExistingUser(
                                phone: "${addressModel.contactPersonNumber}")
                                .then((value) {
                              if (!value) {
                                customSnackBar('phone_already_taken'.tr,
                                    type: ToasterMessageType.info);
                              } else {
                                checkoutController.updateState(PageState.payment);
                              }
                            });
                          } else {
                            checkoutController.updateState(PageState.payment);
                          }
                        }
                      } else if (checkoutController.currentPageState == PageState.payment ||
                          PageState.payment.name == widget.pageState) {
                        if (scheduleController.selectedServiceType == ServiceType.repeat) {
                          checkoutController.placeBookingRequest(
                            paymentMethod: "cash_after_service",
                            schedule: schedule!,
                            isPartial: 0,
                            address: addressModel!,
                            slot: scheduleController.getSlot(),
                          );
                        } else if (cartController.walletPaymentStatus &&
                            isPartialPayment &&
                            checkoutController.selectedPaymentMethod ==
                                PaymentMethodName.walletMoney) {
                          customSnackBar(
                              "select_another_payment_method_to_pay_remaining_bill".tr,
                              type: ToasterMessageType.info);
                        } else if (checkoutController.selectedPaymentMethod ==
                            PaymentMethodName.none) {
                          customSnackBar("select_payment_method".tr,
                              type: ToasterMessageType.info);
                        } else if (checkoutController.selectedPaymentMethod ==
                            PaymentMethodName.cos) {
                          checkoutController.placeBookingRequest(
                              paymentMethod: "cash_after_service",
                              schedule: schedule!,
                              isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
                              address: addressModel!,
                              slot: scheduleController.getSlot()
                          );
                        } else if (checkoutController.selectedPaymentMethod ==
                            PaymentMethodName.walletMoney) {
                          checkoutController.placeBookingRequest(
                              paymentMethod: "wallet_payment",
                              schedule: schedule!,
                              isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
                              address: addressModel!,
                              slot: scheduleController.getSlot());

                        } else if (checkoutController.selectedPaymentMethod ==
                            PaymentMethodName.offline) {
                          double bookingAmount = isPartialPayment
                              ? (totalAmount - cartController.walletBalance)
                              : totalAmount;
                          if (checkoutController.selectedOfflineMethod != null) {
                            int selectedOfflinePaymentIndex = checkoutController
                                .offlinePaymentModelList
                                .indexOf(checkoutController.selectedOfflineMethod!);
                            checkoutController.placeBookingRequest(
                                paymentMethod: "offline_payment",
                                schedule: schedule!,
                                isPartial:
                                isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
                                address: addressModel!,
                                offlinePaymentId: checkoutController.selectedOfflineMethod?.id,
                                selectedOfflinePaymentIndex:
                                selectedOfflinePaymentIndex != -1 ? selectedOfflinePaymentIndex : 0,
                                bookingAmount: bookingAmount,
                                slot: scheduleController.getSlot()
                            );
                          } else {
                            customSnackBar("provide_offline_payment_info".tr,
                                type: ToasterMessageType.info);
                          }
                        } else if (checkoutController.selectedPaymentMethod ==
                            PaymentMethodName.digitalPayment) {
                          if (checkoutController.selectedDigitalPaymentMethod !=
                              null &&
                              checkoutController.selectedDigitalPaymentMethod?.gateway !=
                                  "offline") {
                            _makeDigitalPayment(addressModel,
                                checkoutController.selectedDigitalPaymentMethod, isPartialPayment, checkoutController);
                          } else {
                            customSnackBar("select_any_payment_method".tr,
                                type: ToasterMessageType.info);
                          }
                        }
                      } else {
                        if (kDebugMode) {
                          print("In Here");
                        }
                      }
                    } else {
                      if (schedule == null &&
                          scheduleController.selectedScheduleType != ScheduleType.asap &&
                          scheduleController.selectedServiceType == ServiceType.regular) {
                        customSnackBar("select_your_preferable_booking_time".tr,
                            type: ToasterMessageType.info);
                      } else {
                        customSnackBar('please_agree_with_terms_conditions'.tr,
                            type: ToasterMessageType.info);
                      }
                    }
                  },
                ),

              ],
            ),
          );
        });
      });
    });
  }

  _makeDigitalPayment(AddressModel? address, DigitalPaymentMethod? paymentMethod,
      bool isPartialPayment, CheckOutController checkoutController) {
    try {
      print("🔽 Starting _makeDigitalPayment...");

      String hostname = html.window.location.hostname!;
      String protocol = html.window.location.protocol;
      String port = html.window.location.port;
      String? path = html.window.location.pathname;

      print("🌐 Hostname: $hostname");
      print("🌐 Protocol: $protocol");
      print("🌐 Port: $port");
      print("🌐 Path: $path");

      SignUpBody? newUserInfo = CheckoutHelper.getNewUserInfo(
          address: address,
          password: checkoutController.passwordController.text,
          isCheckedCreateAccount: checkoutController.isCheckedCreateAccount
      );
      print("👤 New User Info: ${jsonEncode(newUserInfo?.toJson())}");

      String? schedule = Get
          .find<ScheduleController>()
          .scheduleTime;
      print("📅 Schedule: $schedule");

      String userId = Get
          .find<UserController>()
          .userInfoModel
          ?.id ??
          Get.find<SplashController>().getGuestId();
      print("🆔 User ID: $userId");

      String encodedAddress = base64Encode(
          utf8.encode(jsonEncode(address?.toJson())));
      print("📦 Encoded Address: $encodedAddress");

      String encodedNewUserInfo = base64Encode(
          utf8.encode(jsonEncode(newUserInfo?.toJson())));
      print("📄 Encoded New User Info: $encodedNewUserInfo");

      String serviceLocation = Get
          .find<LocationController>()
          .selectedServiceLocationType
          .name;
      print("📍 Service Location: $serviceLocation");

      String addressId = (address?.id == "null" || address?.id == null)
          ? ""
          : address?.id ?? "";
      print("🏠 Address ID: $addressId");

      String zoneId = Get
          .find<LocationController>()
          .getUserAddress()
          ?.zoneId ?? "";
      print("🗺️ Zone ID: $zoneId");

      String callbackUrl = GetPlatform.isWeb
          ? "$protocol//$hostname:$port$path"
          : AppConstants.baseUrl;
      print("🔁 Callback URL: $callbackUrl");

      int isPartial = Get
          .find<CartController>()
          .walletPaymentStatus && isPartialPayment ? 1 : 0;
      print("💰 Is Partial Payment: $isPartial");

      String platform = ResponsiveHelper.isWeb() ? "web" : "app";
      print("📱 Platform: $platform");

      String paymentMethodStr = paymentMethod?.gateway ?? "";


      String? slot = Get.find<ScheduleController>().getSlot();
      print('Slot from ScheduleController: $slot');

      print("💳 Payment Method: $paymentMethodStr");

      String url =
          '${AppConstants.baseUrl}/payment?payment_method=$paymentMethodStr'
          '&access_token=${base64Url.encode(utf8.encode(userId))}'
          '&zone_id=$zoneId'
          '&service_schedule=$schedule'
          '&service_address_id=$addressId'
          '&callback=$callbackUrl'
          '&service_address=$encodedAddress'
          '&new_user_info=$encodedNewUserInfo'
          '&is_partial=$isPartial'
          '&payment_platform=$platform'
          '&service_location=$serviceLocation'
          '&slot=${Uri.encodeComponent(slot)}';

      ///rani


      print("🔗 Final Payment URL: $url");

      if (GetPlatform.isWeb) {
        print("🌍 Opening payment URL in browser...");
        html.window.open(url, "_self");
      } else {
        print("📱 Navigating to PaymentScreen in app...");
        Get.to(() => PaymentScreen(url: url, fromPage: "checkout"));
      }

      print("✅ _makeDigitalPayment completed.");
    } catch (e, stackTrace) {
      print("❌ Error in _makeDigitalPayment: $e");
      print("🧵 Stack trace:\n$stackTrace");
    }
  }
  }