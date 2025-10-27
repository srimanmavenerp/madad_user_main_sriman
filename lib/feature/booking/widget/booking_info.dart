// import 'package:madaduser/feature/booking/widget/booking_status_widget.dart';
// import 'package:get/get.dart';
// import 'package:madaduser/utils/core_export.dart';
//
// import '../../checkout/view/thawani_payment_page.dart';
//
// class BookingInfo extends StatelessWidget {
//   final BookingDetailsContent bookingDetails;
//   final bool isSubBooking;
//   // final JustTheController tooltipController;
//   // final String fromPage;
//   final BookingDetailsController bookingDetailsTabController;
//   const BookingInfo({super.key, required this.bookingDetails, required this.bookingDetailsTabController, required this.isSubBooking,}) ;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(color: Theme.of(context).cardColor , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//         boxShadow: Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
//       ),
//       child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//         child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
//
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start ,children: [
//             Column( crossAxisAlignment: CrossAxisAlignment.start ,children: [
//               Text('${'booking'.tr} #${bookingDetails.readableId}',
//                 style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,
//                     color: Theme.of(context).textTheme.bodyLarge!.color,decoration: TextDecoration.none),
//               ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//               ],
//             ),
//             BookingStatusButtonWidget(bookingStatus: bookingDetails.bookingStatus)
//           ]),
//
//           Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
//           BookingItem(
//             img: Images.calendar1,
//             title: "${'booking_date'.tr} : ",
//             date: DateConverter.dateMonthYearTimeTwentyFourFormat(DateConverter.isoUtcStringToLocalDate(bookingDetails.createdAt!)),
//           ),
//
//
//           Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//           if(bookingDetails.serviceSchedule !=null) BookingItem(
//             img: Images.calendar1,
//             title: "${'service_schedule_date'.tr} : ",
//             date:   DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.tryParse(bookingDetails.serviceSchedule!)!),
//           ),
//           Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
//
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Row(
//               //   children: [
//               //     Icon(
//               //       Icons.access_time,
//               //       color: Colors.deepPurpleAccent,
//               //       size: 15,
//               //     ),
//               //     const SizedBox(width: 8),
//               //     // Text(
//               //     //   // You might want to get this from the API as well
//               //     //   "Service Schedule Slot : 5am – 11am",
//               //     //   style: robotoMedium.copyWith(
//               //     //     fontSize: 12,
//               //     //     color: Colors.black54,
//               //     //     decoration: TextDecoration.none,
//               //     //   ),
//               //     // ),
//               //   ],
//               // ),
//               const SizedBox(height: 8),
//               // --- Dynamic Vehicle Details ---
//               if (bookingDetails.vehicle != null) ...[
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.directions_car,
//                       color: const Color.fromARGB(255, 155, 135, 209),
//                       size: 15,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Vehicle Model : ${bookingDetails.vehicle!.model ?? 'N/A'}", // Dynamic Model
//                       style: robotoMedium.copyWith(
//                         fontSize: 12,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//
//
//                 const SizedBox(height: 8),
//
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.punch_clock,
//                       color: const Color.fromARGB(255, 155, 135, 209),
//                       size: 15,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Slot : ${bookingDetails!.slot ?? 'N/A'}", // Dynamic Model
//                       style: robotoMedium.copyWith(
//                         fontSize: 12,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.palette,
//                       color: const Color.fromARGB(255, 155, 135, 209),
//                       size: 15,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Vehicle Color : ${bookingDetails.vehicle!.color ?? 'N/A'}", // Dynamic Color
//                       style: robotoMedium.copyWith(
//                         fontSize: 12,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.confirmation_number,
//                       color: const Color.fromARGB(255, 155, 135, 209),
//                       size: 15,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Vehicle Number : ${bookingDetails.vehicle!.vehicleNo ?? 'N/A'}", // Dynamic Vehicle Number
//                       style: robotoMedium.copyWith(
//                         fontSize: 12,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.car_repair,
//                       color: const Color.fromARGB(255, 155, 135, 209),
//                       size: 15,
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       "Vehicle Type : ${bookingDetails.vehicle!.type ?? 'N/A'}", // Dynamic Vehicle Type
//                       style: robotoMedium.copyWith(
//                         fontSize: 12,
//                         color: Colors.black54,
//                         decoration: TextDecoration.none,
//                       ),
//                     ),
//
//
//
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 if (bookingDetails.vehicle!.contactNo != null &&
//                     bookingDetails.vehicle!.contactNo!.isNotEmpty) ...[
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.phone,
//                         color: const Color.fromARGB(255, 155, 135, 209),
//                         size: 15,
//                       ),
//                       const SizedBox(width: 8),
//                       GestureDetector(
//
//                         onTap: () async {
//                           final number = bookingDetails.vehicle!.contactNo!;
//                           final uri = Uri(scheme: 'tel', path: number);
//                           if (await canLaunchUrl(uri)) {
//                             await launchUrl(uri);
//                           }
//                         },
//                         child: Text(
//                           "Contact No : ${bookingDetails.vehicle!.contactNo}",
//                           style: robotoMedium.copyWith(
//                             fontSize: 12,
//                             color: Colors.black54,
//                             decoration: TextDecoration.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//                 if (bookingDetails.vehicle!.additionalDetails != null &&
//                     bookingDetails.vehicle!.additionalDetails!.isNotEmpty) ...[
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.info_outline,
//                         color: const Color.fromARGB(255, 155, 135, 209),
//                         size: 15,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           "Additional Details : ${bookingDetails.vehicle!.additionalDetails}",
//                           style: robotoMedium.copyWith(
//                             fontSize: 12,
//                             color: Colors.black54,
//                             decoration: TextDecoration.none,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//
//
//
//                       if (bookingDetails.isPaid == 0 && bookingDetails != "canceled" && bookingDetails.paymentMethod == "cash_after_service")
//                         ElevatedButton(
//                           onPressed: () {
//
//
//                               debugPrint("Booking ID: ${bookingDetails.id.toString()}");
//                               bookingDetailsTabController.showCustomPayViaOnlineDialog(bookingDetails.id);
//
//                           },
//
//
//                           // onPressed: (widget.pageState == "payment" ||
//                           //     checkoutController.currentPageState == PageState.payment) &&
//                           //     checkoutController.othersPaymentList.isEmpty &&
//                           //     checkoutController.digitalPaymentList.isEmpty
//                           //     ? null
//                           //     : () {
//                           //   if (errorText != null &&
//                           //       scheduleController.selectedScheduleType !=
//                           //           ScheduleType.asap) {
//                           //     customSnackBar(errorText.tr);
//                           //   } else if (checkoutController.acceptTerms ||
//                           //       cartController.cartList.isEmpty) {
//                           //     AddressModel? addressModel =
//                           //     CheckoutHelper.selectedAddressModel(
//                           //       selectedAddress:
//                           //       Get.find<LocationController>().selectedAddress,
//                           //       pickedAddress: Get.find<LocationController>().getUserAddress(),
//                           //       selectedLocationType:
//                           //       Get.find<LocationController>().selectedServiceLocationType,
//                           //     );
//                           //
//                           //     if (cartController.cartList.isEmpty) {
//                           //       Get.offAllNamed(RouteHelper.getMainRoute('home'));
//                           //     } else if (cartController.cartList.isNotEmpty &&
//                           //         cartController.cartList.first.provider != null &&
//                           //         (cartController.cartList[0].provider?.serviceAvailability == 0 ||
//                           //             cartController.cartList[0].provider?.isActive == 0)) {
//                           //       Future.delayed(const Duration(milliseconds: 50)).then((value) {
//                           //         Future.delayed(const Duration(milliseconds: 500)).then((value) {
//                           //           showModalBottomSheet(
//                           //             useRootNavigator: true,
//                           //             isScrollControlled: true,
//                           //             backgroundColor: Colors.transparent,
//                           //             context: Get.context!,
//                           //             builder: (context) => AvailableProviderWidget(
//                           //               subcategoryId:
//                           //               Get.find<CartController>().cartList.first.subCategoryId,
//                           //               showUnavailableError: true,
//                           //             ),
//                           //           );
//                           //         });
//                           //
//                           //         customSnackBar(
//                           //           "your_selected_provider_is_unavailable_right_now".tr,
//                           //           duration: 3,
//                           //           type: ToasterMessageType.info,
//                           //         );
//                           //       });
//                           //     } else if (checkoutController.currentPageState == PageState.orderDetails &&
//                           //         PageState.orderDetails.name == widget.pageState) {
//                           //       // Validation checks for schedule and address etc.
//                           //       if (schedule == null &&
//                           //           scheduleController.selectedScheduleType != ScheduleType.asap &&
//                           //           scheduleController.selectedServiceType == ServiceType.regular) {
//                           //         customSnackBar("select_your_preferable_booking_time".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (scheduleController.selectedScheduleType == ScheduleType.schedule &&
//                           //           configModel.content?.scheduleBookingTimeRestriction == 1 &&
//                           //           scheduleController.checkValidityOfTimeRestriction(
//                           //               Get.find<SplashController>()
//                           //                   .configModel
//                           //                   .content!
//                           //                   .advanceBooking!) !=
//                           //               null &&
//                           //           scheduleController.selectedServiceType == ServiceType.regular) {
//                           //         customSnackBar(scheduleController
//                           //             .checkValidityOfTimeRestriction(Get.find<SplashController>()
//                           //             .configModel
//                           //             .content!
//                           //             .advanceBooking!));
//                           //       } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                           //           scheduleController.selectedRepeatBookingType ==
//                           //               RepeatBookingType.daily &&
//                           //           scheduleController.pickedDailyRepeatBookingDateRange == null) {
//                           //         customSnackBar("daily_select_time_and_date_hint".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                           //           scheduleController.selectedRepeatBookingType ==
//                           //               RepeatBookingType.daily &&
//                           //           scheduleController.pickedDailyRepeatTime == null) {
//                           //         customSnackBar("select_time_hint".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                           //           scheduleController.selectedRepeatBookingType ==
//                           //               RepeatBookingType.weekly &&
//                           //           scheduleController.getWeeklyPickedDays().isEmpty) {
//                           //         customSnackBar("weekly_select_time_and_date_hint".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                           //           scheduleController.selectedRepeatBookingType ==
//                           //               RepeatBookingType.weekly &&
//                           //           scheduleController.pickedWeeklyRepeatTime == null) {
//                           //         customSnackBar("select_time_hint".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (scheduleController.selectedServiceType == ServiceType.repeat &&
//                           //           scheduleController.selectedRepeatBookingType ==
//                           //               RepeatBookingType.custom &&
//                           //           scheduleController.pickedCustomRepeatBookingDateTimeList.isEmpty) {
//                           //         customSnackBar("custom_select_time_and_date_hint".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (addressModel == null) {
//                           //         customSnackBar("add_address_first".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if ((addressModel.contactPersonName == "null" ||
//                           //           addressModel.contactPersonName == null ||
//                           //           addressModel.contactPersonName!.isEmpty) ||
//                           //           (addressModel.contactPersonNumber == "null" ||
//                           //               addressModel.contactPersonNumber == null ||
//                           //               addressModel.contactPersonNumber!.isEmpty)) {
//                           //         customSnackBar(
//                           //             "please_input_contact_person_name_and_phone_number".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (checkoutController.isCheckedCreateAccount &&
//                           //           checkoutController.passwordController.text.isEmpty) {
//                           //         customSnackBar("please_input_new_account_password".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (checkoutController.isCheckedCreateAccount &&
//                           //           checkoutController.confirmPasswordController.text.isEmpty) {
//                           //         customSnackBar("please_input_confirm_password".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (checkoutController.isCheckedCreateAccount &&
//                           //           checkoutController.confirmPasswordController.text !=
//                           //               checkoutController.passwordController.text) {
//                           //         customSnackBar("confirm_password_does_not_matched".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else {
//                           //         if (checkoutController.isCheckedCreateAccount &&
//                           //             !isLoggedIn &&
//                           //             createGuestAccount) {
//                           //           checkoutController
//                           //               .checkExistingUser(
//                           //               phone: "${addressModel.contactPersonNumber}")
//                           //               .then((value) {
//                           //             if (!value) {
//                           //               customSnackBar('phone_already_taken'.tr,
//                           //                   type: ToasterMessageType.info);
//                           //             } else {
//                           //               checkoutController.updateState(PageState.payment);
//                           //             }
//                           //           });
//                           //         } else {
//                           //           checkoutController.updateState(PageState.payment);
//                           //         }
//                           //       }
//                           //     } else if (checkoutController.currentPageState == PageState.payment ||
//                           //         PageState.payment.name == widget.pageState) {
//                           //       if (scheduleController.selectedServiceType == ServiceType.repeat) {
//                           //         checkoutController.placeBookingRequest(
//                           //           paymentMethod: "cash_after_service",
//                           //           schedule: schedule!,
//                           //           isPartial: 0,
//                           //           address: addressModel!,
//                           //           slot: scheduleController.getSlot(),
//                           //         );
//                           //       } else if (cartController.walletPaymentStatus &&
//                           //           isPartialPayment &&
//                           //           checkoutController.selectedPaymentMethod ==
//                           //               PaymentMethodName.walletMoney) {
//                           //         customSnackBar(
//                           //             "select_another_payment_method_to_pay_remaining_bill".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (checkoutController.selectedPaymentMethod ==
//                           //           PaymentMethodName.none) {
//                           //         customSnackBar("select_payment_method".tr,
//                           //             type: ToasterMessageType.info);
//                           //       } else if (checkoutController.selectedPaymentMethod ==
//                           //           PaymentMethodName.cos) {
//                           //         checkoutController.placeBookingRequest(
//                           //             paymentMethod: "cash_after_service",
//                           //             schedule: schedule!,
//                           //             isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                           //             address: addressModel!,
//                           //             slot: scheduleController.getSlot()
//                           //         );
//                           //       } else if (checkoutController.selectedPaymentMethod ==
//                           //           PaymentMethodName.walletMoney) {
//                           //         checkoutController.placeBookingRequest(
//                           //             paymentMethod: "wallet_payment",
//                           //             schedule: schedule!,
//                           //             isPartial: isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                           //             address: addressModel!,
//                           //             slot: scheduleController.getSlot());
//                           //
//                           //       } else if (checkoutController.selectedPaymentMethod ==
//                           //           PaymentMethodName.offline) {
//                           //         double bookingAmount = isPartialPayment
//                           //             ? (totalAmount - cartController.walletBalance)
//                           //             : totalAmount;
//                           //         if (checkoutController.selectedOfflineMethod != null) {
//                           //           int selectedOfflinePaymentIndex = checkoutController
//                           //               .offlinePaymentModelList
//                           //               .indexOf(checkoutController.selectedOfflineMethod!);
//                           //           checkoutController.placeBookingRequest(
//                           //               paymentMethod: "offline_payment",
//                           //               schedule: schedule!,
//                           //               isPartial:
//                           //               isPartialPayment && cartController.walletPaymentStatus ? 1 : 0,
//                           //               address: addressModel!,
//                           //               offlinePaymentId: checkoutController.selectedOfflineMethod?.id,
//                           //               selectedOfflinePaymentIndex:
//                           //               selectedOfflinePaymentIndex != -1 ? selectedOfflinePaymentIndex : 0,
//                           //               bookingAmount: bookingAmount,
//                           //               slot: scheduleController.getSlot()
//                           //           );
//                           //         } else {
//                           //           customSnackBar("provide_offline_payment_info".tr,
//                           //               type: ToasterMessageType.info);
//                           //         }
//                           //       } else if (checkoutController.selectedPaymentMethod ==
//                           //           PaymentMethodName.digitalPayment) {
//                           //         if (checkoutController.selectedDigitalPaymentMethod !=
//                           //             null &&
//                           //             checkoutController.selectedDigitalPaymentMethod?.gateway !=
//                           //                 "offline") {
//                           //           _makeDigitalPayment(addressModel,
//                           //               checkoutController.selectedDigitalPaymentMethod, isPartialPayment, checkoutController);
//                           //         } else {
//                           //           customSnackBar("select_any_payment_method".tr,
//                           //               type: ToasterMessageType.info);
//                           //         }
//                           //       }
//                           //     } else {
//                           //       if (kDebugMode) {
//                           //         print("In Here");
//                           //       }
//                           //     }
//                           //   } else {
//                           //     if (schedule == null &&
//                           //         scheduleController.selectedScheduleType != ScheduleType.asap &&
//                           //         scheduleController.selectedServiceType == ServiceType.regular) {
//                           //       customSnackBar("select_your_preferable_booking_time".tr,
//                           //           type: ToasterMessageType.info);
//                           //     } else {
//                           //       customSnackBar('please_agree_with_terms_conditions'.tr,
//                           //           type: ToasterMessageType.info);
//                           //     }
//                           //   }
//                           // },
//
//                           child: Text("pay".tr),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ],
//               // --- End Dynamic Vehicle Details ---
//             ],
//           ),
//
//           BookingItem(
//             img: Images.iconLocation,
//             title: '${'address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'no_address_found'.tr}',
//             date: '',
//           ),
//
//           Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
//
//         ]),
//       ),
//     );
//   }
//
//
// }
//
// class DigitalPayment_MethodView extends StatelessWidget {
//   final Function(int index) onTap;
//   final List<DigitalPaymentMethod> paymentList;
//
//   const DigitalPayment_MethodView({
//     super.key, required this.onTap, required this.paymentList,
//   }) ;
//
//   @override
//   Widget build(BuildContext context) {
//
//     List<String> offlinePaymentTooltipTextList = [
//       'to_pay_offline_you_have_to_pay_the_bill_from_a_option_below',
//       'save_the_necessary_information_that_is_necessary_to_identify_or_confirmation_of_the_payment',
//       'insert_the_information_and_proceed'
//     ];
//
//     return GetBuilder<CheckOutController>(builder: (checkoutController){
//
//       return SingleChildScrollView(child: ListView.builder(
//         itemCount: paymentList.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemBuilder: (context, index){
//
//           bool isSelected = paymentList[index] == Get.find<CheckOutController>().selectedDigitalPaymentMethod;
//           bool isOffline = paymentList[index].gateway == 'offline';
//
//           return InkWell(
//             onTap: isOffline ? null :  ()=> onTap(index),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: isSelected ? Theme.of(context).hoverColor : Colors.transparent,
//                   borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                   border: isSelected ? Border.all(color: Theme.of(context).hintColor.withValues(alpha: 0.2),width: 0.5) : null
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 InkWell(
//                   onTap: isOffline ?  ()=> onTap(index) : null,
//                   child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween ,children: [
//                     Row(children: [
//                       Container(
//                         height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle, color: isSelected ? Colors.green: Theme.of(context).cardColor,
//                             border: Border.all(color: Theme.of(context).disabledColor)
//                         ),
//                         child: Icon(Icons.check, color: isSelected ? Colors.white : Colors.transparent, size: 16),
//                       ),
//                       const SizedBox(width: Dimensions.paddingSizeDefault),
//
//                       isOffline ? const SizedBox() :
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                         child: CustomImage(
//                           height: Dimensions.paddingSizeLarge, fit: BoxFit.contain,
//                           image: paymentList[index].gatewayImageFullPath ?? "",
//                         ),
//                       ),
//                       const SizedBox(width: Dimensions.paddingSizeSmall),
//
//                       Text( isOffline ? 'pay_offline'.tr : paymentList[index].label ?? "",
//                         style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
//                       ),
//                     ]),
//
//                     isOffline ? JustTheTooltip(
//                       // backgroundColor: Colors.black87, controller: tooltipController,
//                       preferredDirection: AxisDirection.down, tailLength: 14, tailBaseWidth: 20,
//                       content: Padding( padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
//                         child:  Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start ,children: [
//                           Text("note".tr, style: robotoBold.copyWith(color: Theme.of(context).colorScheme.primary),),
//                           const SizedBox(height: Dimensions.paddingSizeSmall,),
//                           Column(mainAxisSize: MainAxisSize.min ,crossAxisAlignment: CrossAxisAlignment.start, children: offlinePaymentTooltipTextList.map((element) => Padding(
//                             padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
//                             child: Text( "●  ${element.tr}",
//                               style: robotoRegular.copyWith(color: Colors.white70),
//                             ),
//                           ),).toList(),
//                           ),
//                         ]),
//                       ),
//
//                       child: ( isOffline && isSelected )? InkWell(
//                         onTap:(){},
//                             //()=> tooltipController.showTooltip(),
//                         child: Icon(Icons.info, color: Theme.of(context).colorScheme.primary,),
//                       ): const SizedBox(),
//
//                     ) : const SizedBox()
//
//                   ]),
//                 ),
//
//                 if( isOffline && isSelected ) SingleChildScrollView(
//                   padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
//                   scrollDirection: Axis.horizontal,
//                   child: checkoutController.offlinePaymentModelList.isNotEmpty ? Row(mainAxisAlignment: MainAxisAlignment.start, children: checkoutController.offlinePaymentModelList.map((offlineMethod) => InkWell(
//                     onTap: (){
//                       if(isOffline){
//                         checkoutController.changePaymentMethod(offlinePaymentModel: offlineMethod);
//                       }else{
//                         checkoutController.changePaymentMethod(digitalMethod : paymentList[index]);
//                       }
//                     } ,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
//                       padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
//                       decoration: BoxDecoration(
//                         color: checkoutController.selectedOfflineMethod == offlineMethod ? Theme.of(context).colorScheme.primary : Theme.of(context).cardColor,
//                         border: Border.all(width: 1, color: Theme.of(context).colorScheme.primary.withValues(alpha:
//                         checkoutController.selectedOfflineMethod == offlineMethod ? 0.7 : 0.2,
//                         )),
//                         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                       ),
//                       child: Text(offlineMethod.methodName ?? '', style: robotoMedium.copyWith(
//                           color: checkoutController.selectedOfflineMethod == offlineMethod ? Colors.white : null
//                       )),
//                     ),
//                   )).toList()) : Text("no_offline_payment_method_available".tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),),
//                 ),
//
//               ]),
//             ),
//           );
//         },));
//     });
//   }
// }
//

import 'package:madaduser/feature/booking/widget/booking_status_widget.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../checkout/view/thawani_payment_page.dart';

class BookingInfo extends StatelessWidget {
  final BookingDetailsContent bookingDetails;
  final bool isSubBooking;

  // final JustTheController tooltipController;
  // final String fromPage;
  final BookingDetailsController bookingDetailsTabController;

  const BookingInfo({
    super.key,
    required this.bookingDetails,
    required this.bookingDetailsTabController,
    required this.isSubBooking,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleanedNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch phone dialer',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error opening phone dialer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow:
            Get.find<ThemeController>().darkTheme ? null : searchBoxShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'booking'.tr} #${bookingDetails.readableId}',
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          decoration: TextDecoration.none),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ],
                ),
                BookingStatusButtonWidget(
                    bookingStatus: bookingDetails.bookingStatus)
              ]),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
          BookingItem(
            img: Images.calendar1,
            title: "${'booking_date'.tr} : ",
            date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                DateConverter.isoUtcStringToLocalDate(
                    bookingDetails.createdAt!)),
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          if (bookingDetails.serviceSchedule != null)
            BookingItem(
              img: Images.calendar1,
              title: "${'service_schedule_date'.tr} : ",
              date: DateConverter.dateMonthYearTimeTwentyFourFormat(
                  DateTime.tryParse(bookingDetails.serviceSchedule!)!),
            ),
          Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Icon(
              //       Icons.access_time,
              //       color: Colors.deepPurpleAccent,
              //       size: 15,
              //     ),
              //     const SizedBox(width: 8),
              //     // Text(
              //     //   // You might want to get this from the API as well
              //     //   "Service Schedule Slot : 5am – 11am",
              //     //   style: robotoMedium.copyWith(
              //     //     fontSize: 12,
              //     //     color: Colors.black54,
              //     //     decoration: TextDecoration.none,
              //     //   ),
              //     // ),
              //   ],
              // ),
              const SizedBox(height: 8),
              // --- Dynamic Vehicle Details ---
              if (bookingDetails.vehicle != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.directions_car,
                      color: const Color.fromARGB(255, 155, 135, 209),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Vehicle Model : ${bookingDetails.vehicle!.model ?? 'N/A'}", // Dynamic Model
                      style: robotoMedium.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: const Color.fromARGB(255, 155, 135, 209),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Vehicle Color : ${bookingDetails.vehicle!.color ?? 'N/A'}", // Dynamic Color
                      style: robotoMedium.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      color: const Color.fromARGB(255, 155, 135, 209),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Vehicle Number : ${bookingDetails.vehicle!.vehicleNo ?? 'N/A'}", // Dynamic Vehicle Number
                      style: robotoMedium.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.car_repair,
                      color: const Color.fromARGB(255, 155, 135, 209),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Vehicle Type : ${bookingDetails.vehicle!.type ?? 'N/A'}",
                      // Dynamic Vehicle Type
                      style: robotoMedium.copyWith(
                        fontSize: 12,
                        color: Colors.black54,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (bookingDetails.endDate != null &&
                    bookingDetails.endDate!.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: const Color.fromARGB(255, 155, 135, 209),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Expiry date : ${bookingDetails.endDate}",
                        style: robotoMedium.copyWith(
                          fontSize: 12,
                          color: Colors.black54,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 3,
                ),
                if (bookingDetails.interiorSchedules != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (bookingDetails.interiorSchedules != null &&
                          bookingDetails.interiorSchedules!.isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: const Color.fromARGB(255, 155, 135, 209),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Interior cleaning Dates : ${bookingDetails.interiorSchedules!.join(', ')}",
                                style: robotoMedium.copyWith(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  decoration: TextDecoration.none,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    () {
                      print("Slottttttttttttttttt: ${bookingDetails.slot}");
                      return Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: const Color.fromARGB(255, 155, 135, 209),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Slot : ${bookingDetails.slot}",
                            style: robotoMedium.copyWith(
                              fontSize: 12,
                              color: Colors.black54,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      );
                    }(),
                  ],
                ),
                const SizedBox(height: 5),
                if (bookingDetails.vehicle!.contactNo != null &&
                    bookingDetails.vehicle!.contactNo!.isNotEmpty) ...[
                  bookingDetails.vehicle?.contactNo != null &&
                          bookingDetails.vehicle!.contactNo!.trim().isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            // Call the phone dialer method when contact number is tapped
                            _makePhoneCall(bookingDetails.vehicle!.contactNo!);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: const Color.fromARGB(255, 155, 135, 209),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact Number'.tr,
                                      style: robotoMedium.copyWith(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () async {
                                          final phone = (bookingDetails
                                                          .vehicle?.contactNo !=
                                                      null &&
                                                  bookingDetails
                                                          .vehicle!.contactNo!
                                                          .trim()
                                                          .length >=
                                                      6)
                                              ? bookingDetails
                                                  .vehicle!.contactNo!
                                              : Get.find<UserController>()
                                                  .userInfoModel
                                                  ?.phone;
                                          if (phone != null &&
                                              phone.isNotEmpty) {
                                            final Uri telUri =
                                                Uri(scheme: 'tel', path: phone);
                                            if (await canLaunchUrl(telUri)) {
                                              await launchUrl(telUri);
                                            } else {
                                              print('Could not launch dialer');
                                            }
                                          }
                                        },
                                        child: Text(
                                          (bookingDetails.vehicle?.contactNo !=
                                                      null &&
                                                  bookingDetails
                                                          .vehicle!.contactNo!
                                                          .trim()
                                                          .length >=
                                                      6)
                                              ? bookingDetails
                                                  .vehicle!.contactNo!
                                              : Get.find<UserController>()
                                                      .userInfoModel
                                                      ?.phone ??
                                                  'contact_number_not_found'.tr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
                SizedBox(
                  height: 5,
                ),
                if (bookingDetails.vehicle!.additionalDetails != null &&
                    bookingDetails.vehicle!.additionalDetails!.isNotEmpty &&
                    bookingDetails.subCategoryId !=
                        '01c87dde-f46a-4b9c-b852-2de93d804ac7') ...[
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: const Color.fromARGB(255, 155, 135, 209),
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Additional Details : ${bookingDetails.vehicle!.additionalDetails}",
                          style: robotoMedium.copyWith(
                            fontSize: 12,
                            color: Colors.black54,
                            decoration: TextDecoration.none,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            ],
          ),
          BookingItem(
            img: Images.iconLocation,
            title:
                '${'address'.tr} : ${bookingDetails.serviceAddress?.address ?? bookingDetails.subBooking?.serviceAddress?.address ?? 'no_address_found'.tr}',
            date: '',
          ),
          Gaps.verticalGapOf(Dimensions.paddingSizeSmall),
        ]),
      ),
    );
  }
}

class DigitalPayment_MethodView extends StatelessWidget {
  final Function(int index) onTap;
  final List<DigitalPaymentMethod> paymentList;

  const DigitalPayment_MethodView({
    super.key,
    required this.onTap,
    required this.paymentList,
  });

  @override
  Widget build(BuildContext context) {
    List<String> offlinePaymentTooltipTextList = [
      'to_pay_offline_you_have_to_pay_the_bill_from_a_option_below',
      'save_the_necessary_information_that_is_necessary_to_identify_or_confirmation_of_the_payment',
      'insert_the_information_and_proceed'
    ];

    return GetBuilder<CheckOutController>(builder: (checkoutController) {
      return SingleChildScrollView(
          child: ListView.builder(
        itemCount: paymentList.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          bool isSelected = paymentList[index] ==
              Get.find<CheckOutController>().selectedDigitalPaymentMethod;
          bool isOffline = paymentList[index].gateway == 'offline';

          return InkWell(
            onTap: isOffline ? null : () => onTap(index),
            child: Container(
              decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).hoverColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: isSelected
                      ? Border.all(
                          color: Theme.of(context)
                              .hintColor
                              .withValues(alpha: 0.2),
                          width: 0.5)
                      : null),
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeDefault),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: isOffline ? () => onTap(index) : null,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                height: Dimensions.paddingSizeLarge,
                                width: Dimensions.paddingSizeLarge,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? Colors.green
                                        : Theme.of(context).cardColor,
                                    border: Border.all(
                                        color:
                                            Theme.of(context).disabledColor)),
                                child: Icon(Icons.check,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                    size: 16),
                              ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeDefault),
                              isOffline
                                  ? const SizedBox()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                      child: CustomImage(
                                        height: Dimensions.paddingSizeLarge,
                                        fit: BoxFit.contain,
                                        image: paymentList[index]
                                                .gatewayImageFullPath ??
                                            "",
                                      ),
                                    ),
                              const SizedBox(
                                  width: Dimensions.paddingSizeSmall),
                              Text(
                                isOffline
                                    ? 'pay_offline'.tr
                                    : paymentList[index].label ?? "",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault),
                              ),
                            ]),
                            isOffline
                                ? JustTheTooltip(
                                    // backgroundColor: Colors.black87, controller: tooltipController,
                                    preferredDirection: AxisDirection.down,
                                    tailLength: 14, tailBaseWidth: 20,
                                    content: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeDefault),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "note".tr,
                                              style: robotoBold.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                            ),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  offlinePaymentTooltipTextList
                                                      .map(
                                                        (element) => Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              bottom: Dimensions
                                                                  .paddingSizeExtraSmall),
                                                          child: Text(
                                                            "●  ${element.tr}",
                                                            style: robotoRegular
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white70),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                            ),
                                          ]),
                                    ),

                                    child: (isOffline && isSelected)
                                        ? InkWell(
                                            onTap: () {},
                                            //()=> tooltipController.showTooltip(),
                                            child: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )
                                        : const SizedBox(),
                                  )
                                : const SizedBox()
                          ]),
                    ),
                    if (isOffline && isSelected)
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeExtraLarge),
                        scrollDirection: Axis.horizontal,
                        child: checkoutController
                                .offlinePaymentModelList.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: checkoutController
                                    .offlinePaymentModelList
                                    .map((offlineMethod) => InkWell(
                                          onTap: () {
                                            if (isOffline) {
                                              checkoutController
                                                  .changePaymentMethod(
                                                      offlinePaymentModel:
                                                          offlineMethod);
                                            } else {
                                              checkoutController
                                                  .changePaymentMethod(
                                                      digitalMethod:
                                                          paymentList[index]);
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: Dimensions
                                                    .paddingSizeExtraSmall),
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    Dimensions.paddingSizeSmall,
                                                horizontal: Dimensions
                                                    .paddingSizeExtraLarge),
                                            decoration: BoxDecoration(
                                              color: checkoutController
                                                          .selectedOfflineMethod ==
                                                      offlineMethod
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context).cardColor,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                      .withValues(
                                                        alpha: checkoutController
                                                                    .selectedOfflineMethod ==
                                                                offlineMethod
                                                            ? 0.7
                                                            : 0.2,
                                                      )),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusDefault),
                                            ),
                                            child: Text(
                                                offlineMethod.methodName ?? '',
                                                style: robotoMedium.copyWith(
                                                    color: checkoutController
                                                                .selectedOfflineMethod ==
                                                            offlineMethod
                                                        ? Colors.white
                                                        : null)),
                                          ),
                                        ))
                                    .toList())
                            : Text(
                                "no_offline_payment_method_available".tr,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color),
                              ),
                      ),
                  ]),
            ),
          );
        },
      ));
    });
  }
}
