import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../repo/booking_details_repo.dart';
import 'EligibleDates_controller.dart';

class EligibleDatesView extends StatefulWidget {
  final String bookingId;
  final String bookingreadableId;

  const EligibleDatesView({
    Key? key,
    required this.bookingId,
    required this.bookingreadableId,
  }) : super(key: key);

  @override
  State<EligibleDatesView> createState() => _EligibleDatesViewState();
}

class _EligibleDatesViewState extends State<EligibleDatesView> {
  final BookingController controller = Get.put(
    BookingController(
      repository: BookingDetailsRepo(
        sharedPreferences: Get.find(),
        apiClient: Get.find(),
      ),
    ),
  );

  DateTime _focusedDay = DateTime.now();
  Set<String> _apiSelectedDates = {};
  Map<String, bool> _monthHasApiDates = {};
  Set<String> _userSelectedDates = {};

  @override
  void initState() {
    super.initState();
    controller.getEligibleDates(widget.bookingId);
  }

  List<String> _formatDates(Set<String> dates) {
    return dates.map((d) {
      final date = DateTime.parse(d);
      return "${date.day} ${_getMonthName(date.month)} ${date.year}";
    }).toList();
  }

  void _debugPrintSelectedDates() {
    print(' User Selected Dates (Blue): ${_formatDates(_userSelectedDates)}');
    print(' API Selected Dates (Red): ${_formatDates(_apiSelectedDates)}');
    print(' Months with API dates: $_monthHasApiDates');
  }

  String _getMonthYearKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }

  bool _monthHasApiSelectedDates(DateTime date) {
    final monthYear = _getMonthYearKey(date);
    return _monthHasApiDates[monthYear] == true;
  }

  int _getUserSelectedCountInMonth(DateTime date) {
    final monthYear = _getMonthYearKey(date);
    return _userSelectedDates.where((dateStr) {
      final selectedDate = DateTime.parse(dateStr);
      return _getMonthYearKey(selectedDate) == monthYear;
    }).length;
  }

  void showCenteredDialog(String message) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                "Notice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // user must press OK
    );
  }

  Future<void> _submitSelectedDates() async {
    if (_userSelectedDates.isEmpty) {
      showCenteredDialog(
          "     No Selection,\n Please select at least one date");
      return;
    }

    _debugPrintSelectedDates();

    try {
      final response = await controller.submitSelectedDates(
        bookingID: widget.bookingId,
        selectedDates: _userSelectedDates.toList(),
      );

      // if (response.statusCode == 200) {
      //   Get.snackbar(
      //     "Success",
      //     "Dates submitted successfully!",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //   );
      // }

      if (response.statusCode == 200) {
        showCenteredDialog(
          "Success,\n Dates submitted successfully!",
        );

        setState(() {
          setState(() {
            _focusedDay = DateTime.now();
            _userSelectedDates.clear();
            _apiSelectedDates.clear();
            _monthHasApiDates.clear();
          });
        });

        await controller.getEligibleDates(widget.bookingId);
      } else {
        String errorMessage = "Failed to submit dates";
        bool showInPopup = false;

        if (response.body != null) {
          try {
            Map<String, dynamic> errorData;

            if (response.body is Map<String, dynamic>) {
              errorData = response.body as Map<String, dynamic>;
            } else {
              errorData = json.decode(response.body.toString());
            }

            if (errorData.containsKey('error')) {
              errorMessage = errorData['error'];
              showInPopup = true;
            }
          } catch (e) {
            errorMessage = response.statusText ?? "Failed to submit dates";
            showInPopup = false;
          }
        }

        if (showInPopup) {
          Get.dialog(
            AlertDialog(
              title: const Text(
                "Notice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              content: Text(
                errorMessage,
                style: const TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            barrierDismissible: true,
          );
        } else {
          Get.snackbar(
            "Error",
            errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Exception: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Cleaning Dates",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Booking ID #${widget.bookingreadableId} • Interior Cleaning",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        toolbarHeight: 80,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.blue));
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        final data = controller.eligibleDates.value;
        if (data == null) {
          return const Center(child: Text("No data available."));
        }

        final initialSelectedDates = data.selectedDates ?? [];
        final eligibleMonths = data.eligibleMonths ?? [];

        if (_apiSelectedDates.isEmpty && initialSelectedDates.isNotEmpty) {
          _apiSelectedDates = initialSelectedDates.toSet();

          for (final dateStr in _apiSelectedDates) {
            final date = DateTime.parse(dateStr);
            final monthYear = _getMonthYearKey(date);
            _monthHasApiDates[monthYear] = true;
          }

          print('Initialized API selected dates: $_apiSelectedDates');
          print('Months with API dates: $_monthHasApiDates');
        }

        if (eligibleMonths.isEmpty) {
          return const Center(child: Text("No eligible months."));
        }

        final allStartDates = eligibleMonths
            .where((e) => e.selectedDateRange != null)
            .map((e) => DateTime.parse(e.selectedDateRange!.start ?? ''))
            .toList();
        final allEndDates = eligibleMonths
            .where((e) => e.selectedDateRange != null)
            .map((e) => DateTime.parse(e.selectedDateRange!.end ?? ''))
            .toList();

        if (allStartDates.isEmpty || allEndDates.isEmpty) {
          return const Center(child: Text("No valid date ranges available."));
        }

        final firstDay = allStartDates.reduce((a, b) => a.isBefore(b) ? a : b);
        final lastDay = allEndDates.reduce((a, b) => a.isAfter(b) ? a : b);

        _focusedDay = _focusedDay.isBefore(firstDay) ? firstDay : _focusedDay;
        _focusedDay = _focusedDay.isAfter(lastDay) ? lastDay : _focusedDay;

        final dateRangeText =
            "${firstDay.day} ${_getMonthName(firstDay.month)} ${firstDay.year} – ${lastDay.day} ${_getMonthName(lastDay.month)} ${lastDay.year}";

        _debugPrintSelectedDates();

        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: Colors.white,
              child: Text(
                dateRangeText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: TableCalendar(
                        firstDay: firstDay,
                        lastDay: lastDay,
                        focusedDay: _focusedDay,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarFormat: CalendarFormat.month,
                        availableGestures: AvailableGestures.horizontalSwipe,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          leftChevronIcon: Icon(Icons.chevron_left, size: 28),
                          rightChevronIcon: Icon(Icons.chevron_right, size: 28),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          defaultTextStyle: const TextStyle(fontSize: 16),
                          todayTextStyle: const TextStyle(fontSize: 16),
                          weekendTextStyle: const TextStyle(fontSize: 16),
                          disabledTextStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final dateStr =
                                day.toIso8601String().substring(0, 10);

                            // Check if this date is in API selected dates (RED)
                            if (_apiSelectedDates.contains(dateStr)) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Check if this date is in user selected dates (BLUE)
                            if (_userSelectedDates.contains(dateStr)) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4A90E2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return null;
                          },
                        ),
                        enabledDayPredicate: (day) {
                          if (day.weekday == DateTime.friday) {
                            return false;
                          }

                          for (var month in eligibleMonths) {
                            if (month.selectedDateRange != null) {
                              final start = DateTime.parse(
                                  month.selectedDateRange!.start ?? '');
                              final end = DateTime.parse(
                                  month.selectedDateRange!.end ?? '');
                              if (!day.isBefore(start) && !day.isAfter(end)) {
                                return true;
                              }
                            }
                          }
                          return false;
                        },
                        selectedDayPredicate: (_) => false,

                        onDaySelected: (selectedDay, focusedDay) {
                          final dateStr =
                              selectedDay.toIso8601String().substring(0, 10);
                          print("You tapped on: $dateStr");

                          // ❗️ Keep this check to avoid modifying API-selected (red) dates
                          if (_apiSelectedDates.contains(dateStr)) {
                            print("This date is red and not selectable.");
                            Get.dialog(
                              AlertDialog(
                                title: const Text(
                                  "API Response",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                content: const Text(
                                  "This date is already selected and cannot be changed",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Color(0xFF4A90E2),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              barrierDismissible: true,
                            );
                            return;
                          }

                          setState(() {
                            _focusedDay = focusedDay;

                            if (_userSelectedDates.contains(dateStr)) {
                              _userSelectedDates.remove(dateStr);
                              print("Removed: $dateStr");
                            } else {
                              _userSelectedDates.add(dateStr);
                              print("Added: $dateStr");
                            }

                            _debugPrintSelectedDates();
                          });
                        },

                        // onDaySelected: (selectedDay, focusedDay) {
                        //   final dateStr = selectedDay.toIso8601String().substring(0, 10);
                        //   print("You tapped on: $dateStr");
                        //
                        //   if (_monthHasApiSelectedDates(selectedDay)) {
                        //     print("This month already has existing cleaning dates.");
                        //     Get.snackbar(
                        //       "Month Has Existing Cleaning Dates",
                        //       "This month already has existing cleaning dates and cannot be modified",
                        //       snackPosition: SnackPosition.BOTTOM,
                        //       backgroundColor: Colors.red,
                        //       colorText: Colors.white,
                        //       duration: const Duration(seconds: 3),
                        //     );
                        //     return;
                        //   }
                        //
                        //   if (_apiSelectedDates.contains(dateStr)) {
                        //     print("This date is red and not selectable.");
                        //     Get.dialog(
                        //       AlertDialog(
                        //         title: const Text(
                        //           "API Response",
                        //           style: TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //             color: Colors.red,
                        //           ),
                        //         ),
                        //         content: const Text(
                        //           "This date is already selected and cannot be changed",
                        //           style: TextStyle(fontSize: 16),
                        //         ),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () => Get.back(),
                        //             child: const Text(
                        //               "OK",
                        //               style: TextStyle(
                        //                 color: Color(0xFF4A90E2),
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(12),
                        //         ),
                        //       ),
                        //       barrierDismissible: true,
                        //     );
                        //     return;
                        //   }
                        //
                        //   setState(() {
                        //     _focusedDay = focusedDay;
                        //
                        //     if (_userSelectedDates.contains(dateStr)) {
                        //       _userSelectedDates.remove(dateStr);
                        //       print(" Removed: $dateStr");
                        //     } else {
                        //
                        //       _userSelectedDates.add(dateStr);
                        //       print(" Added: $dateStr");
                        //     }
                        //
                        //     _debugPrintSelectedDates();
                        //   });
                        // },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            "Select your preferred cleaning dates",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Months with existing cleaning dates cannot be modified",
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Already selected",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4A90E2),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Your selection",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: _userSelectedDates.isNotEmpty
                            ? _submitSelectedDates
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save Selected Dates",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
