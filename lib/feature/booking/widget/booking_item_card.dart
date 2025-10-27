import 'package:madaduser/common/models/popup_menu_model.dart';
import 'package:madaduser/feature/booking/widget/booking_status_widget.dart';
import 'package:madaduser/helper/booking_helper.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class BookingItemCard extends StatelessWidget {
  final BookingModel bookingModel;
  final String bookingId;
  final String bookingTitle;
  final int index;
  const BookingItemCard({super.key, required this.bookingId,
    required this.bookingTitle, required this.bookingModel, required this.index});

  @override
  Widget build(BuildContext context) {
    String bookingStatus = bookingModel.bookingStatus!;
    final checkOutController = Get.find<CheckOutController>();
    // Fetch payment methods (digital and others)
    checkOutController.getPaymentMethodList();

    return InkWell(
      onTap: () {
        if (bookingModel.isRepeatBooking == 1) {
          Get.toNamed(RouteHelper.getRepeatBookingDetailsScreen(bookingId: bookingModel.id!));
        } else {
          Get.toNamed(RouteHelper.getBookingDetailsScreen(bookingID: bookingModel.id!));
        }
      },
      child: GetBuilder<ServiceBookingController>(builder: (serviceBookingController) {
        return GetBuilder<BookingDetailsController>(builder: (bookingDetailsController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), width: 0.5),
              boxShadow: Get.find<ThemeController>().darkTheme ? null : lightShadow,
            ),
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeEight, horizontal: Dimensions.paddingSizeDefault),
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('${'booking'.tr}# ${bookingModel.readableId}', style: robotoBold.copyWith()),
                        if (bookingModel.isRepeatBooking == 1)
                          Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                            padding: const EdgeInsets.all(2),
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                            child: const Icon(Icons.repeat, color: Colors.white, size: 10),
                          ),
                      ],
                    ),
                    PopupMenuButton<PopupMenuModel>(
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                        side: BorderSide(color: Theme.of(context).hintColor.withValues(alpha: 0.1)),
                      ),
                      surfaceTintColor: Theme.of(context).cardColor,
                      position: PopupMenuPosition.under,
                      elevation: 8,
                      shadowColor: Theme.of(context).hintColor.withValues(alpha: 0.3),
                      itemBuilder: (BuildContext context) {
                        return serviceBookingController.getPopupMenuList(
                          status: bookingStatus,
                          isRepeatBooking: bookingModel.isRepeatBooking == 1,
                        ).map((PopupMenuModel option) {
                          return PopupMenuItem<PopupMenuModel>(
                            value: option,
                            height: 35,
                            onTap: () async {
                              if (option.title == "booking_details") {
                                if (bookingModel.isRepeatBooking == 1) {
                                  Get.toNamed(RouteHelper.getRepeatBookingDetailsScreen(bookingId: bookingModel.id!));
                                } else {
                                  Get.toNamed(RouteHelper.getBookingDetailsScreen(bookingID: bookingModel.id!));
                                }
                              }
                              if (option.title == "rebook") {
                                serviceBookingController.updateRebookIndex(index);
                                await serviceBookingController.checkCartSubcategory(bookingModel.id!, bookingModel.subCategoryId!);
                              } else if (option.title == "download_invoice") {
                                String uri = "";
                                String languageCode = Get.find<LocalizationController>().locale.languageCode;
                                if (bookingModel.isRepeatBooking == 1) {
                                  uri = "${AppConstants.baseUrl}${AppConstants.repeatBookingInvoiceUrl}${bookingModel.id}/$languageCode";
                                } else {
                                  uri = "${AppConstants.baseUrl}${AppConstants.regularBookingInvoiceUrl}${bookingModel.id}/$languageCode";
                                }
                                if (kDebugMode) {
                                  print("Uri : $uri");
                                }
                                await _launchUrl(Uri.parse(uri));
                              }
                            },
                            child: Row(
                              children: [
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Icon(option.icon, size: Dimensions.fontSizeLarge),
                                const SizedBox(width: Dimensions.paddingSizeSmall),
                                Text(option.title.tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: Icon(Icons.more_vert_sharp, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeEight),
                Row(
                  children: [
                    Text('${'booking_date'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6))),
                    Text(DateConverter.dateMonthYearTimeTwentyFourFormat(DateConverter.isoUtcStringToLocalDate(bookingModel.createdAt.toString())),
                        textDirection: TextDirection.ltr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6))),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                Row(
                  children: [
                    Text('${'service_date'.tr} : ', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6))),
                    if (BookingHelper.getRepeatBookingCurrentSchedule(bookingModel) != null)
                      Text(
                        DateConverter.dateMonthYearTimeTwentyFourFormat(DateTime.tryParse(BookingHelper.getRepeatBookingCurrentSchedule(bookingModel)!)!),
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha: .6)),
                        textDirection: TextDirection.ltr,
                      ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BookingStatusButtonWidget(bookingStatus: bookingModel.bookingStatus),
                    // if (checkOutController.digitalPaymentList.isNotEmpty)
                    //   ElevatedButton(
                    //     onPressed: () {
                    //       checkOutController.changePaymentMethod(digitalMethod: checkOutController.digitalPaymentList.first);
                    //       bookingDetailsController.showCustomPayViaOnlineDialog(bookingModel.id);
                    //     },
                    //     child: const Text("Pay"),
                    //   ),

                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.convertPrice(bookingModel.totalBookingAmount!.toDouble()),
                        style: robotoBold.copyWith(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}