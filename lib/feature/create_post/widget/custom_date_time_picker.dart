//
//
//
//
// import 'package:madaduser/utils/core_export.dart';
// import 'package:madaduser/feature/create_post/widget/custom_date_picker.dart';
// import 'package:madaduser/feature/create_post/widget/custom_time_picker.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:madaduser/utils/core_export.dart';
// import 'package:madaduser/feature/create_post/widget/custom_date_picker.dart';
// import 'package:madaduser/feature/create_post/widget/custom_time_picker.dart';
// import 'package:get/get.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// class CustomDateTimePicker extends StatelessWidget {
//   final bool Function(DateTime)? isDateAllowed;
//   final bool Function(TimeOfDay)? isTimeAllowed;
//   final String serviceId;
//
//   const CustomDateTimePicker({
//     super.key,
//     this.isDateAllowed,
//     this.isTimeAllowed,
//     required this.serviceId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (ResponsiveHelper.isDesktop(context)) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
//         ),
//         insetPadding: const EdgeInsets.all(30),
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: pointerInterceptor(),
//       );
//     }
//     return pointerInterceptor();
//   }
//
//   Widget pointerInterceptor() {
//     Get.find<ScheduleController>().setInitialScheduleValue();
//     ConfigModel configModel = Get.find<SplashController>().configModel;
//     var dateRangePickerController = DateRangePickerController();
//
//     return Container(
//       width: ResponsiveHelper.isDesktop(Get.context!)
//           ? Dimensions.webMaxWidth / 2
//           : Dimensions.webMaxWidth,
//       decoration: BoxDecoration(
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(Dimensions.radiusLarge),
//           topRight: Radius.circular(Dimensions.radiusLarge),
//         ),
//         color: Theme.of(Get.context!).cardColor,
//       ),
//       padding: const EdgeInsets.all(15),
//       child: GetBuilder<ScheduleController>(builder: (scheduleController) {
//         return SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: Dimensions.paddingSizeDefault),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(Get.context!).hintColor,
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 height: 4,
//                 width: 80,
//               ),
//               const SizedBox(height: Dimensions.paddingSizeSmall),
//
//               /// Custom Date Picker
//               CustomDatePicker(
//                 dateRangePickerController: dateRangePickerController,
//                 selectableDayPredicate: (date) =>
//                     Get.find<ScheduleController>().isDateAllowed(date),
//               ),
//
//               /// Conditionally show one of the two time pickers
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: ResponsiveHelper.isDesktop(Get.context!)
//                       ? Dimensions.paddingSizeLarge * 2
//                       : 0,
//                 ),
//                 child: CustomTimePicker(
//                   isTimeAllowed: (time) => Get.find<ScheduleController>().isTimeAllowed(time),
//                   serviceId: serviceId,
//                 ),
//               ),
//
//               /// Optional ASAP section
//               if (configModel.content?.instantBooking == 1)
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: ResponsiveHelper.isDesktop(Get.context!)
//                         ? Dimensions.paddingSizeLarge * 2
//                         : 0,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//                       Divider(
//                         color: Theme.of(Get.context!).hintColor,
//                         height: 0.5,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//                     ],
//                   ),
//                 ),
//
//               /// OK/Cancel Button
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: ResponsiveHelper.isDesktop(Get.context!)
//                       ? Dimensions.paddingSizeLarge * 3
//                       : 0,
//                 ),
//                 child: actionButtonWidget(Get.context!, scheduleController),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Row actionButtonWidget(
//       BuildContext context, ScheduleController scheduleController) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           style: TextButton.styleFrom(
//             padding: EdgeInsets.zero,
//             minimumSize: const Size(50, 30),
//             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           ),
//           onPressed: () => Get.back(),
//           child: Text(
//             'cancel'.tr.toUpperCase(),
//             style: robotoMedium.copyWith(
//               color: Get.isDarkMode
//                   ? Theme.of(context).primaryColorLight
//                   : Colors.black.withOpacity(0.6),
//             ),
//           ),
//         ),
//         const SizedBox(width: Dimensions.paddingSizeDefault),
//         CustomButton(
//           width: ResponsiveHelper.isDesktop(context) ? 90 : 70,
//           height: ResponsiveHelper.isDesktop(context) ? 45 : 40,
//           radius: Dimensions.radiusExtraMoreLarge,
//           buttonText: "ok".tr.toUpperCase(),
//           onPressed: () {
//             ConfigModel config = Get.find<SplashController>().configModel;
//
//             if (serviceId == 'a0e54890-a389-4a32-b5ce-e0959cb6ef14') {
//               String selectedTimeStr = scheduleController.selectedTime!;
//               TimeOfDay selectedTime = _convertStringToTimeOfDay(selectedTimeStr);
//               if (!_isTimeInRange(selectedTime)) {
//                 customSnackBar(
//                   'selected_time_between_8am_to_10pm'.tr,
//                   showDefaultSnackBar: false,
//                 );
//                 return;
//               }
//             }
//
//             // Proceed with scheduling logic
//             if (scheduleController.initialSelectedScheduleType == null) {
//               customSnackBar(
//                 'select_your_preferable_booking_time'.tr,
//                 showDefaultSnackBar: false,
//               );
//             } else {
//               scheduleController.buildSchedule(
//                   scheduleType: scheduleController.selectedScheduleType);
//               Get.back();
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   TimeOfDay _convertStringToTimeOfDay(String timeString) {
//     final timeParts = timeString.split(':');
//     final hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);
//     return TimeOfDay(hour: hour, minute: minute);
//   }
//
//   bool _isTimeInRange(TimeOfDay time) {
//     final timeInMinutes = time.hour * 60 + time.minute;
//     final start = 8 * 60; // 8:00 AM
//     final end = 22 * 60; // 10:00 PM
//     return timeInMinutes >= start && timeInMinutes <= end;
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:madaduser/feature/create_post/widget/custom_date_picker.dart';
import 'package:madaduser/feature/create_post/widget/custom_time_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDateTimePicker extends StatelessWidget {
  final bool Function(DateTime)? isDateAllowed;
  final bool Function(TimeOfDay)? isTimeAllowed;
  final String serviceId;

  const CustomDateTimePicker({
    super.key,
    this.isDateAllowed,
    this.isTimeAllowed,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        ),
        insetPadding: const EdgeInsets.all(30),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: pointerInterceptor(),
      );
    }
    return pointerInterceptor();
  }

  Widget pointerInterceptor() {
    Get.find<ScheduleController>().setInitialScheduleValue();
    ConfigModel configModel = Get.find<SplashController>().configModel;
    var dateRangePickerController = DateRangePickerController();

    return Container(
      width: ResponsiveHelper.isDesktop(Get.context!)
          ? Dimensions.webMaxWidth / 2
          : Dimensions.webMaxWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(Dimensions.radiusLarge),
          topRight: Radius.circular(Dimensions.radiusLarge),
        ),
        color: Theme.of(Get.context!).cardColor,
      ),
      padding: const EdgeInsets.all(15),
      child: GetBuilder<ScheduleController>(builder: (scheduleController) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!).hintColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 4,
                width: 80,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              /// Custom Date Picker
              CustomDatePicker(
                dateRangePickerController: dateRangePickerController,
                selectableDayPredicate: (date) =>
                    Get.find<ScheduleController>().isDateAllowed(date),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isDesktop(Get.context!)
                      ? Dimensions.paddingSizeLarge * 2
                      : 0,
                ),
                child: CustomTimePicker(
                  isTimeAllowed: (time) =>
                      Get.find<ScheduleController>().isTimeAllowed(time),
                  serviceId: serviceId,
                ),
              ),

              if (configModel.content?.instantBooking == 1)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.isDesktop(Get.context!)
                        ? Dimensions.paddingSizeLarge * 2
                        : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Divider(
                        color: Theme.of(Get.context!).hintColor,
                        height: 0.5,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                    ],
                  ),
                ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.isDesktop(Get.context!)
                      ? Dimensions.paddingSizeLarge * 3
                      : 0,
                ),
                child: actionButtonWidget(Get.context!, scheduleController),
              ),
            ],
          ),
        );
      }),
    );
  }

  Row actionButtonWidget(
      BuildContext context, ScheduleController scheduleController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => Get.back(),
          child: Text(
            'cancel'.tr.toUpperCase(),
            style: robotoMedium.copyWith(
              color: Get.isDarkMode
                  ? Theme.of(context).primaryColorLight
                  : Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),
        CustomButton(
          width: ResponsiveHelper.isDesktop(context) ? 90 : 70,
          height: ResponsiveHelper.isDesktop(context) ? 45 : 40,
          radius: Dimensions.radiusExtraMoreLarge,
          buttonText: "ok".tr.toUpperCase(),
          onPressed: () async {
            ConfigModel config = Get.find<SplashController>().configModel;

            // if (serviceId == 'a0e54890-a389-4a32-b5ce-e0959cb6ef14') {
            //   String selectedTimeStr = scheduleController.selectedTime!;
            //   TimeOfDay selectedTime =
            //       _convertStringToTimeOfDay(selectedTimeStr);

            // if (!_isBookingValid(selectedTime)) {
            //   customSnackBar(
            //     'selected time between 8am to 10 pm and at least 1 hour Before current time'
            //         .tr,
            //     showDefaultSnackBar: false,
            //   );
            //   return;
            // }
            // }

            if (scheduleController.initialSelectedScheduleType == null) {
              customSnackBar(
                'select_your_preferable_booking_time'.tr,
                showDefaultSnackBar: false,
              );
            } else {
              scheduleController.buildSchedule(
                  scheduleType: scheduleController.selectedScheduleType);
              // await Future.delayed(Duration(seconds: 1));
              Get.back();
            }
          },
        ),
      ],
    );
  }

  // TimeOfDay _convertStringToTimeOfDay(String timeString) {
  //   final timeParts = timeString.split(':');
  //   final hour = int.parse(timeParts[0]);
  //   final minute = int.parse(timeParts[1]);
  //   return TimeOfDay(hour: hour, minute: minute);
  // }

  // /// Checks if the selected booking time is valid
  // bool _isBookingValid(TimeOfDay selectedTime) {
  //   // Allowed booking time window: 8:00 AM to 10:00 PM
  //   final startTime = TimeOfDay(hour: 8, minute: 0);
  //   final endTime = TimeOfDay(hour: 22, minute: 0);

  //   // Check if selected time is within allowed window
  //   if (!_isTimeInRange(selectedTime, startTime, endTime)) {
  //     return false;
  //   }

  //   // Current time
  //   final now = DateTime.now();

  //   // Selected date/time today
  //   final selectedDateTime = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     selectedTime.hour,
  //     selectedTime.minute,
  //   );

  //   // Must be at least 1 hour in advance
  //   if (selectedDateTime.isBefore(now.add(const Duration(hours: 1)))) {
  //     return false;
  //   }

  //   return true;
  // }

  // /// Helper to check if a TimeOfDay is within a start-end range
  // bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
  //   final totalMinutes = time.hour * 60 + time.minute;
  //   final startMinutes = start.hour * 60 + start.minute;
  //   final endMinutes = end.hour * 60 + end.minute;

  //   return totalMinutes >= startMinutes && totalMinutes <= endMinutes;
  // }
}
