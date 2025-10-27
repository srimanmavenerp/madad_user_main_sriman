import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/dimensions.dart';
import '../../../utils/styles.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/model/cart_model.dart';
import '../../checkout/controller/schedule_controller.dart';

class CustomDatePicker extends StatelessWidget {
  final DateRangePickerController dateRangePickerController;
  final bool Function(DateTime)? selectableDayPredicate;

  const CustomDatePicker({
    super.key,
    required this.dateRangePickerController,
    this.selectableDayPredicate,
  });

  // The restricted service that disallows selecting today's date
  static const String restrictedServiceId =
      '10646e61-1a40-4b4f-a388-2ae804e2e301';

  @override
  Widget build(BuildContext context) {
    // Get current cart list from controller
    final List<CartModel> cartList = Get.find<CartController>().cartList;

    // Check if restricted service is present in the cart
    final bool hasRestrictedService = cartList.any((item) {
      final serviceId = item.service?.id;
      return serviceId == restrictedServiceId;
    });

    // Custom logic to disable today's date only if restricted service is present
    bool customSelectablePredicate(DateTime date) {
      final bool isToday =
          DateUtils.dateOnly(date) == DateUtils.dateOnly(DateTime.now());

      // If restricted service is in cart and date is today, disallow selection
      if (hasRestrictedService && isToday) {
        return false;
      }

      // Use custom logic from parent if provided
      if (selectableDayPredicate != null) {
        return selectableDayPredicate!(date);
      }

      return true; // Allow all other dates
    }

    return SizedBox(
      height: 300,
      width: 500,
      child: GetBuilder<ScheduleController>(builder: (scheduleController) {
        return SfDateRangePicker(
          backgroundColor: Theme.of(context).cardColor,
          controller: dateRangePickerController,
          showNavigationArrow: true,
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            final DateTime? selectedDate = args.value;
            if (selectedDate == null) return;

            final bool isToday = DateUtils.dateOnly(selectedDate) ==
                DateUtils.dateOnly(DateTime.now());
            if (hasRestrictedService && isToday) {
              Get.snackbar(
                'Invalid Date',
                'Please select next day',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }

            // Save selected date and update controller
            scheduleController.selectedDate =
                DateFormat('yyyy-MM-dd').format(selectedDate);

            scheduleController.updateScheduleType(
                scheduleType: ScheduleType.schedule);
            scheduleController.update();
            scheduleController.update();
            print("date :${selectedDate}");
          },
          initialSelectedDate: scheduleController.getSelectedDateTime(),
          selectionMode: DateRangePickerSelectionMode.single,
          selectionShape: DateRangePickerSelectionShape.rectangle,
          viewSpacing: 10,
          headerHeight: 50,
          toggleDaySelection: true,
          enablePastDates: false,
          selectableDayPredicate: customSelectablePredicate,
          headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardColor,
            textAlign: TextAlign.center,
            textStyle: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.8),
            ),
          ),
        );
      }),
    );
  }
}
