import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:intl/intl.dart';

enum ScheduleType { asap, schedule }

class ScheduleController extends GetxController implements GetxService {
  final ScheduleRepo scheduleRepo;
  ScheduleController({required this.scheduleRepo});

  String selectedTimeSlot = '5am to 9am';

  ServiceType _selectedServiceType = ServiceType.regular;
  ServiceType get selectedServiceType => _selectedServiceType;

  int _scheduleDaysCount = 1;
  int get scheduleDaysCount => _scheduleDaysCount;

  ScheduleType _selectedScheduleType = ScheduleType.asap;
  ScheduleType get selectedScheduleType => _selectedScheduleType;

  ScheduleType? _initialSelectedScheduleType;
  ScheduleType? get initialSelectedScheduleType => _initialSelectedScheduleType;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedTime = DateFormat('HH:mm:ss').format(DateTime.now().add(const Duration(minutes: 2)));

  String? scheduleTime;

  RepeatBookingType _selectedRepeatBookingType = RepeatBookingType.daily;
  RepeatBookingType get selectedRepeatBookingType => _selectedRepeatBookingType;

  DateTimeRange? _pickedDailyRepeatBookingDateRange;
  DateTimeRange? get pickedDailyRepeatBookingDateRange => _pickedDailyRepeatBookingDateRange;
  set updateDailyRepeatBookingDateRange(DateTimeRange? dateRange) => _pickedDailyRepeatBookingDateRange = dateRange;

  TimeOfDay? _pickedDailyRepeatTime;
  TimeOfDay? get pickedDailyRepeatTime => _pickedDailyRepeatTime;
  set updatePickedDailyRepeatTime(TimeOfDay? time) => _pickedDailyRepeatTime = time;

  DateTimeRange? _finalPickedWeeklyRepeatBookingDateRange;
  DateTimeRange? get pickedWeeklyRepeatBookingDateRange => _finalPickedWeeklyRepeatBookingDateRange;

  DateTimeRange? _initialPickedWeeklyRepeatBookingDateRange;
  DateTimeRange? get initialPickedWeeklyRepeatBookingDateRange => _initialPickedWeeklyRepeatBookingDateRange;
  set updateInitialWeeklyRepeatBookingDateRange(DateTimeRange? dateRange) => _initialPickedWeeklyRepeatBookingDateRange = dateRange;

  TimeOfDay? _pickedWeeklyRepeatTime;
  TimeOfDay? get pickedWeeklyRepeatTime => _pickedWeeklyRepeatTime;
  set updatePickedWeeklyRepeatTime(TimeOfDay? time) => _pickedWeeklyRepeatTime = time;

  bool _isFinalRepeatWeeklyBooking = false;
  bool get isFinalRepeatWeeklyBooking => _isFinalRepeatWeeklyBooking;

  bool _isInitialRepeatWeeklyBooking = false;
  bool get isInitialRepeatWeeklyBooking => _isInitialRepeatWeeklyBooking;

  List<String> daysList = ['saturday', "sunday", "monday", "tuesday", "wednesday", "thursday", "friday"];
  List<bool> finalDaysCheckList = List.filled(7, false);
  List<bool> initialDaysCheckList = List.filled(7, false);

  List<DateTime> _pickedCustomRepeatBookingDateTimeList = [];
  List<DateTime> get pickedCustomRepeatBookingDateTimeList => _pickedCustomRepeatBookingDateTimeList;

  List<DateTime> _pickedInitialCustomRepeatBookingDateTimeList = [];
  List<DateTime> get pickedInitialCustomRepeatBookingDateTimeList => _pickedInitialCustomRepeatBookingDateTimeList;
  set updateInitialCustomRepeatBookingDateRange(List<DateTime> dateList) => _pickedInitialCustomRepeatBookingDateTimeList = dateList;

  String _getFormattedNowPlusMinutes(int minutes) {
    final now = DateTime.now().add(Duration(minutes: minutes));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  void buildSchedule({
    bool shouldUpdate = true,
    required ScheduleType scheduleType,
    String? schedule,
    String? serviceId,
  }) {
    try {
      DateTime now = DateTime.now();
      String formattedNowPlus2Min = _getFormattedNowPlusMinutes(2);

      if (schedule != null) {
        _selectedScheduleType = ScheduleType.schedule;
        scheduleTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(schedule),
        );
      } else if (_initialSelectedScheduleType == ScheduleType.asap) {
        _selectedScheduleType = ScheduleType.asap;
        scheduleTime = formattedNowPlus2Min;
      } else {
        _selectedScheduleType = ScheduleType.schedule;

        DateTime parsedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
            .parse("$selectedDate $selectedTime");

        //  Adjust time for specific service ID
        if (serviceId == 'a0e54890-a389-4a32-b5ce-e0959cb6ef14') {
          parsedDateTime = parsedDateTime.subtract(const Duration(hours: 1));
        }

        scheduleTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDateTime);
      }
    } catch (e) {
      scheduleTime = _getFormattedNowPlusMinutes(2); // fallback
      debugPrint('Invalid scheduleTime format. Falling back to now +2min: $scheduleTime');
    }

    debugPrint('📅 Schedule confirmed:');
    debugPrint('  Type: $_selectedScheduleType');
    debugPrint('  Date: $selectedDate');
    debugPrint('  Time: $selectedTime');
    debugPrint('  Slot: $selectedTimeSlot');
    debugPrint('  Final scheduleTime: $scheduleTime');

    if (shouldUpdate) update();
  }

  Map<String, dynamic> getSelectedScheduleInfo() => {
    'type': _selectedScheduleType.name,
    'date': selectedDate,
    'time': selectedTime,
    'slot': selectedTimeSlot,
    'scheduleTime': scheduleTime,
  };

  String getSlot() => selectedTimeSlot;

  updateScheduleType({bool shouldUpdate = true, required ScheduleType scheduleType}) {
    _initialSelectedScheduleType = scheduleType;
    if (shouldUpdate) update();
  }

  DateTime? getSelectedDateTime() {
    try {
      if (_selectedScheduleType == ScheduleType.schedule && scheduleTime != null) {
        return DateFormat('yyyy-MM-dd HH:mm:ss').parse(scheduleTime!);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  String? checkValidityOfTimeRestriction(AdvanceBooking advanceBooking) {
    Duration diff = DateConverter.dateTimeStringToDate("$selectedDate $selectedTime").difference(DateTime.now());
    if (advanceBooking.advancedBookingRestrictionType == "day" &&
        diff.inDays < advanceBooking.advancedBookingRestrictionValue!) {
      return 'You must book at least ${advanceBooking.advancedBookingRestrictionValue} days in advance.';
    } else if (advanceBooking.advancedBookingRestrictionType == "hour" &&
        diff.inHours < advanceBooking.advancedBookingRestrictionValue!) {
      return 'You must book at least ${advanceBooking.advancedBookingRestrictionValue} hours in advance.';
    }
    return null;
  }

  void resetSchedule() {
    if (Get.find<SplashController>().configModel.content?.instantBooking == 1) {
      _selectedScheduleType = ScheduleType.asap;
      _initialSelectedScheduleType = ScheduleType.asap;
      scheduleTime = _getFormattedNowPlusMinutes(2);
    } else {
      _selectedScheduleType = ScheduleType.schedule;
      scheduleTime = null;
    }
  }

  void setInitialScheduleValue() {
    if (_selectedScheduleType == ScheduleType.asap) {
      _initialSelectedScheduleType = ScheduleType.asap;
    }
  }

  void updateSelectedDate(String? date) {
    scheduleTime = date ?? null;
  }

  Future<void> updatePostInformation(String postId) async {
    final slot = selectedTimeSlot;
    final time = scheduleTime;
    debugPrint('Updating post with: schedule=$scheduleTime, slot=$selectedTimeSlot');

    if (time == null) {
      customSnackBar("Schedule time is not set.", type: ToasterMessageType.error);
      return;
    }

    Response response = await scheduleRepo.changePostScheduleTime(postId, time, slot);
    if (response.statusCode == 200 && response.body['response_code'] == "default_update_200") {
      customSnackBar("service_schedule_updated_successfully".tr, type: ToasterMessageType.success);
    }
  }

  void removeInitialPickedCustomRepeatBookingDate({required index}) =>
      _pickedInitialCustomRepeatBookingDateTimeList.removeAt(index);
  void removePickedCustomRepeatBookingDate({required index}) =>
      _pickedCustomRepeatBookingDateTimeList.removeAt(index);

  void updateSelectedRepeatBookingType({RepeatBookingType? type}) {
    _selectedRepeatBookingType = type ?? RepeatBookingType.daily;
    update();
  }

  void toggleDaysCheckedValue(int index) {
    initialDaysCheckList[index] = !initialDaysCheckList[index];
    update();
  }

  void updateWeeklyRepeatBookingStatus({bool shouldUpdate = true}) {
    _initialPickedWeeklyRepeatBookingDateRange = null;
    _isInitialRepeatWeeklyBooking = !_isInitialRepeatWeeklyBooking;
    if (shouldUpdate) update();
  }

  void updateSelectedBookingType({ServiceType? type}) {
    _selectedServiceType = type ?? ServiceType.regular;
    update();
  }

  List<String> getWeeklyPickedDays() {
    return [for (int i = 0; i < finalDaysCheckList.length; i++) if (finalDaysCheckList[i]) daysList[i]];
  }

  List<String> getInitialWeeklyPickedDays() {
    return [for (int i = 0; i < initialDaysCheckList.length; i++) if (initialDaysCheckList[i]) daysList[i]];
  }

  void updateCustomRepeatBookingDateTime({required int index, required DateTime dateTime}) {
    pickedInitialCustomRepeatBookingDateTimeList[index] = dateTime;
    update();
  }

  void resetScheduleData({RepeatBookingType? repeatBookingType, bool shouldUpdate = true}) {
    _pickedDailyRepeatBookingDateRange = null;
    _finalPickedWeeklyRepeatBookingDateRange = null;
    _pickedCustomRepeatBookingDateTimeList = [];
    _pickedDailyRepeatTime = null;
    _pickedWeeklyRepeatTime = null;
    finalDaysCheckList = List.filled(7, false);
    _isFinalRepeatWeeklyBooking = false;
    _selectedRepeatBookingType = repeatBookingType ?? RepeatBookingType.daily;

    calculateScheduleCountDays(
        serviceType: repeatBookingType == null ? ServiceType.regular : ServiceType.repeat,
        repeatBookingType: _selectedRepeatBookingType);

    if (shouldUpdate) update();
  }

  void initWeeklySelectedSchedule({bool isFirst = true}) {
    if (isFirst) {
      _isInitialRepeatWeeklyBooking = _isFinalRepeatWeeklyBooking;
      initialDaysCheckList = [...finalDaysCheckList];
      _initialPickedWeeklyRepeatBookingDateRange = _finalPickedWeeklyRepeatBookingDateRange;
    } else {
      _isFinalRepeatWeeklyBooking = _isInitialRepeatWeeklyBooking;
      finalDaysCheckList = [...initialDaysCheckList];
      _finalPickedWeeklyRepeatBookingDateRange = _initialPickedWeeklyRepeatBookingDateRange;
      update();
    }
  }

  void initCustomSelectedSchedule({bool isFirst = true}) {
    if (isFirst) {
      _pickedInitialCustomRepeatBookingDateTimeList = [..._pickedCustomRepeatBookingDateTimeList];
    } else {
      _pickedCustomRepeatBookingDateTimeList = [..._pickedInitialCustomRepeatBookingDateTimeList];
      update();
    }
  }

  void calculateScheduleCountDays({ServiceType? serviceType, required RepeatBookingType repeatBookingType}) {
    if (selectedServiceType == ServiceType.regular || serviceType == ServiceType.regular) {
      _scheduleDaysCount = 1;
    } else {
      if (repeatBookingType == RepeatBookingType.daily) {
        _scheduleDaysCount = CheckoutHelper.calculateDaysCountBetweenDateRange(_pickedDailyRepeatBookingDateRange);
      } else if (repeatBookingType == RepeatBookingType.weekly) {
        _scheduleDaysCount = CheckoutHelper
            .calculateDaysCountBetweenDateRangeWithSpecificSelectedDay(_finalPickedWeeklyRepeatBookingDateRange, getWeeklyPickedDays());
      } else {
        _scheduleDaysCount = _pickedCustomRepeatBookingDateTimeList.length;
      }
    }
  }

  bool isDateAllowed(DateTime date) => date.weekday != DateTime.friday;

  bool isTimeAllowed(TimeOfDay time) {
    final start = selectedTimeSlot == '5am to 9am' ? const TimeOfDay(hour: 5, minute: 0) : const TimeOfDay(hour: 17, minute: 0);
    final end = selectedTimeSlot == '5am to 9am' ? const TimeOfDay(hour: 9, minute: 0) : const TimeOfDay(hour: 22, minute: 0);
    return _isTimeInRange(time, start, end);
  }

  bool _isTimeInRange(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final t = time.hour * 60 + time.minute;
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;
    return t >= s && t <= e;
  }
}