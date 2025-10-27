import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madaduser/common/widgets/time_picker_snipper.dart';
import 'package:madaduser/utils/core_export.dart';

class CustomTimePicker extends StatelessWidget {
  final String serviceId;
  final bool Function(TimeOfDay)? isTimeAllowed;
  final String? sourcePage;

  static const String restrictedServiceId =
      '10646e61-1a40-4b4f-a388-2ae804e2e301';

  const CustomTimePicker({
    super.key,
    required this.serviceId,
    this.isTimeAllowed,
    this.sourcePage,
  });

  final List<Map<String, String>> timeSlots = const [
    {'label': '5am to 9am', 'start': '05:00:00', 'end': '09:00:00'},
    {'label': '7am to 5pm', 'start': '07:00:00', 'end': '17:00:00'},
    {'label': '5pm to 10pm', 'start': '17:00:00', 'end': '22:00:00'},
  ];

  final List<Map<String, String>> corporateTimeSlots = const [
    {'label': '8am to 5pm', 'start': '08:00:00', 'end': '17:00:00'},
  ];

  bool _isNotNullOrEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  List<String> generateTimes(String start, String end) {
    final startTime = TimeOfDay(
        hour: int.parse(start.split(':')[0]),
        minute: int.parse(start.split(':')[1]));
    final endTime = TimeOfDay(
        hour: int.parse(end.split(':')[0]),
        minute: int.parse(end.split(':')[1]));

    List<String> times = [];
    TimeOfDay current = startTime;

    while (current.hour < endTime.hour ||
        (current.hour == endTime.hour && current.minute <= endTime.minute)) {
      times.add(
          "${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}:00");

      int nextMinute = current.minute + 30;
      int nextHour = current.hour;
      if (nextMinute >= 60) {
        nextHour += 1;
        nextMinute = 0;
      }
      current = TimeOfDay(hour: nextHour, minute: nextMinute);
      if (current.hour > endTime.hour ||
          (current.hour == endTime.hour && current.minute > endTime.minute)) {
        break;
      }
    }
    return times;
  }

  @override
  Widget build(BuildContext context) {
    final bool? corporateUser =
        Get.find<UserController>().userInfoModel?.corporateUser;
    final List<CartModel> cartList = Get.find<CartController>().cartList;

    final bool hasRestrictedService = cartList.any((item) {
      final serviceId = item.service?.id;
      return serviceId == restrictedServiceId;
    });

    print('--------------------------------------------------');
    print('CustomTimePicker -------------------→ Service ID: $serviceId');
    print(
        'CustomTimePicker ----------------→ Has Restricted Service: $hasRestrictedService');
    print('CustomTimePicker → Corporate User: $corporateUser');
    print('CustomTimePicker → Source Page: $sourcePage');
    print('--------------------------------------------------');

    return GetBuilder<ScheduleController>(builder: (controller) {
      if (serviceId == restrictedServiceId || hasRestrictedService) {
        print('>>> Executing IF block (Restricted Service Time Picker)');
        print('>>> Navigating with restricted/corporate time slot UI');

        final List<Map<String, String>> slotsToUse =
            (corporateUser == true) ? corporateTimeSlots : timeSlots;

        final slot = slotsToUse.firstWhere(
          (s) => s['label'] == controller.selectedTimeSlot,
          orElse: () => slotsToUse[0],
        );

        final times = generateTimes(slot['start']!, slot['end']!);

        if (hasRestrictedService &&
            controller.selectedTime != "${slot['start']!}-${slot['end']!}") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.selectedTime = "${slot['start']!}-${slot['end']!}";
            controller.buildSchedule(scheduleType: ScheduleType.schedule);
            controller.update();
          });
        }

        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time Slots'.tr,
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Row(
                  children: slotsToUse.map((slot) {
                    final isSelected =
                        controller.selectedTimeSlot == slot['label'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            slot['label']!,
                            style: robotoMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        backgroundColor: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300]!,
                          ),
                        ),
                        onSelected: (_) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.selectedTimeSlot = slot['label']!;
                            if (hasRestrictedService) {
                              controller.selectedTime =
                                  "${slot['start']!}-${slot['end']!}";
                            } else {
                              controller.selectedTime = '';
                            }
                            controller.buildSchedule(
                                scheduleType: ScheduleType.schedule);
                            controller.update();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Visibility(
                visible: !hasRestrictedService,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Text('Select Time'.tr,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: times.map((time) {
                        final isSelected = controller.selectedTime == time;
                        final isToday = controller.selectedDate ==
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                        return ChoiceChip(
                          label: Text(
                            TimeOfDay(
                              hour: int.parse(time.split(':')[0]),
                              minute: int.parse(time.split(':')[1]),
                            ).format(context),
                            style: robotoMedium.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey[300]!,
                            ),
                          ),
                          onSelected: isToday
                              ? null
                              : (_) {
                                  controller.selectedTime = time;
                                  controller.buildSchedule(
                                      scheduleType: ScheduleType.schedule);
                                  controller.update();
                                },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        print(
            '>>>>>>>>>>>>>>>>>>>>>>>>> Executing ELSE block (Free Time Picker)');
        print('>>>>>>>>>>>>>>>>>>>>>>> Navigating with standard time spinner');

        DateTime initialTime = DateTime.now();
        try {
          if (controller.selectedTime.isNotEmpty) {
            final parsed =
                DateFormat('HH:mm:ss').parse(controller.selectedTime);
            initialTime = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, parsed.hour, parsed.minute, parsed.second);
          }
        } catch (_) {
          initialTime = DateTime.now().add(const Duration(minutes: 2));
        }

        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              Text(
                'Time'.tr,
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeLarge),
              TimePickerSpinner(
                time: initialTime,
                is24HourMode: Get.find<SplashController>()
                        .configModel
                        .content
                        ?.timeFormat ==
                    '24',
                normalTextStyle: robotoRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                highlightedTextStyle: robotoMedium.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).colorScheme.primary,
                ),
                spacing: Dimensions.paddingSizeDefault,
                itemHeight: Dimensions.fontSizeLarge + 2,
                itemWidth: 50,
                alignment: Alignment.topCenter,
                isForce2Digits: true,
                onTimeChange: (time) {
                  const minHour = 9;
                  const maxHour = 23;

                  final isValid =
                      (time.hour > minHour && time.hour < maxHour) ||
                          (time.hour == minHour && time.minute >= 0) ||
                          (time.hour == maxHour && time.minute == 0);

                  final formatted =
                      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";

                  controller.selectedTime = formatted;
                  controller.update();
                  controller.update();

                  if (isValid) {
                    controller.buildSchedule(
                        scheduleType: ScheduleType.schedule);
                    controller.update();
                  }
                },
              ),
            ],
          ),
        );
      }
    });
  }

  /// Checks if the selected booking time is valid
  bool _isBookingValid(TimeOfDay selectedTime) {
    // Allowed booking time window: 8:00 AM to 10:00 PM
    final startTime = TimeOfDay(hour: 8, minute: 0);
    final endTime = TimeOfDay(hour: 22, minute: 0);

    // Check if selected time is within allowed window
    if (!_isTimeInRange(selectedTime, startTime, endTime)) {
      return false;
    }

    // Current time
    final now = DateTime.now();

    // Selected date/time today
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Must be at least 1 hour in advance
    if (selectedDateTime.isBefore(now.add(const Duration(hours: 1)))) {
      return false;
    }

    return true;
  }

  /// Helper to check if a TimeOfDay is within a start-end range
  bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final totalMinutes = time.hour * 60 + time.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return totalMinutes >= startMinutes && totalMinutes <= endMinutes;
  }
}
