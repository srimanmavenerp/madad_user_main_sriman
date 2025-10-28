import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:madaduser/feature/booking/controller/booking_details_controller.dart';
import 'package:madaduser/feature/booking/model/booking_details_model.dart';

import '../interior-cleaning-dates/EligibleDates_widget.dart';

class BookingHistory extends StatefulWidget {
  final String? bookingId;
  final bool isSubBooking;
  const BookingHistory({super.key, this.bookingId, required this.isSubBooking});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool _hasBlockedSubCategory(BookingDetailsContent? details) {
    return details?.subCategoryId == '1a5bf45c-9d32-4f4e-a726-126e1a40c836';
  }

  bool _hasEligibleSubCategory(BookingDetailsContent? details) {
    print('_hasEligibleSubCategory() was called');

    if (details == null) {
      print('details is null');
      return false;
    }

    print('subCategoryId: ${details.subCategoryId}');
    print('bookingDetails list: ${details.bookingDetails}');

    final isSubCategoryMatched =
        details.subCategoryId == '01c87dde-f46a-4b9c-b852-2de93d804ac7';

    final hasPremiumService = details.bookingDetails?.any((item) {
          final name = item.variantKey;
          print('Service variantKey: $name');
          return name != null && name.toLowerCase().contains('premium');
        }) ??
        false;

    print('isSubCategoryMatched: $isSubCategoryMatched');
    print('hasPremiumService: $hasPremiumService');

    return isSubCategoryMatched && hasPremiumService;
  }

  String _formatDateOnly(String? dateTimeString) {
    if (dateTimeString == null) return '-';
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";
    } catch (_) {
      return '-';
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingDetailsController>(
      builder: (controller) {
        BookingDetailsContent? bookingDetails = widget.isSubBooking
            ? controller.subBookingDetailsContent
            : controller.bookingDetailsContent;

        final List<CalendarEvent> events = controller.calendarEvents;
        Map<DateTime, List<CalendarEvent>> eventMap = {};
        for (var event in events) {
          final date = DateTime.tryParse(event.date ?? '');
          if (date != null) {
            final eventDate = DateTime(date.year, date.month, date.day);
            eventMap.putIfAbsent(eventDate, () => []).add(event);
          }
        }

        List<CalendarEvent> _getEventsForDay(DateTime day) {
          return eventMap[DateTime(day.year, day.month, day.day)] ?? [];
        }

        bool isPending =
            bookingDetails?.bookingStatus?.toLowerCase() == 'pending';

        return Column(
          children: [
            if (bookingDetails != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        "Service Scheduled Date: ${_formatDateOnly(bookingDetails.createdAt)}",
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        "Payment Status: ${bookingDetails.isPaid == 0 ? 'Unpaid' : 'Paid'}"),
                    const SizedBox(height: 4),
                    Text(
                        "Booking Status: ${bookingDetails.bookingStatus ?? '-'}"),
                    const SizedBox(height: 4),
                    if (isPending)
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.red),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 20),
                            SizedBox(width: 8, height: 20),
                            Expanded(
                              child: Text(
                                "Your Order Still Hasn't Been Accepted By The Provider, Please Wait Till It's Accepted By Provider To Get The Service and The Details.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            if (_hasEligibleSubCategory(bookingDetails) && !isPending)
              ElevatedButton(
                onPressed: () {
//                      print("sriman :");
//       final decoded = jsonDecode(response.body); // decoded is Map<String, dynamic>
// final internalBookings = decoded['content']['internalBookingStatus']['internal_bookings'];

// print("Internal Bookings: $internalBookings"); // prints true/false

// print("object : ${bookingDetails!.internalBookings}");
                  if (bookingDetails == null) {
                    customSnackBar("Something went wrong");
                  } else if (bookingDetails!.internalBookings == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EligibleDatesView(
                          bookingId: widget.bookingId ?? '',
                          bookingreadableId: bookingDetails?.readableId ?? '',
                        ),
                      ),
                    );
                  } else {
                    showCenteredDialog(
                        "Your Maximum Interior Dates are already Booked");
                  }
                },
                child: const Text('Click here to add interior car wash'),
              ),
            if (!isPending && eventMap.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    if (!_hasBlockedSubCategory(bookingDetails)) ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cleaning Details: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D2E95),
                          ),
                        ),
                      ),
                      TableCalendar<CalendarEvent>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        eventLoader: _getEventsForDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });

                          final selectedEvents = _getEventsForDay(selectedDay);
                          for (var event in selectedEvents) {
                            final hasBeforeImages =
                                event.beforeimages != null &&
                                    event.beforeimages!.isNotEmpty;
                            final hasAfterImages = event.images != null &&
                                event.images!.isNotEmpty;

                            if (hasBeforeImages || hasAfterImages) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24)),
                                ),
                                builder: (context) => _ImageCarouselBottomSheet(
                                  beforeImages: event.beforeimages,
                                  afterImages: event.images,
                                  beforeUploadedAt:
                                      event.beforeImagesUploadedAt,
                                  afterUploadedAt: event.afterImagesUploadedAt,
                                ),
                              );
                              break;
                            }
                          }
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) => Container(),
                          defaultBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(day);
                            if (events.isNotEmpty) {
                              final event = events.first;
                              Color color = _getEventColor(event);
                              return _buildDayCell(day, color,
                                  isSelected: isSameDay(_selectedDay, day));
                            }
                            return null;
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(day);
                            if (events.isNotEmpty) {
                              final event = events.first;
                              Color color = _getEventColor(event);
                              return _buildDayCell(day, color,
                                  isSelected: true);
                            }
                            return null;
                          },
                          todayBuilder: (context, day, focusedDay) {
                            final events = _getEventsForDay(day);
                            if (events.isNotEmpty) {
                              final event = events.first;
                              Color color = _getEventColor(event);
                              return _buildDayCell(day, color, isToday: true);
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_selectedDay != null)
                        ..._getEventsForDay(_selectedDay!).map(
                          (event) => ListTile(
                            title: Text(event.label ?? ''),
                            subtitle: Text(event.note ?? ''),
                            leading: Icon(
                              Icons.event,
                              color: (event.status?.toLowerCase() ==
                                          'completed' ||
                                      event.status?.toLowerCase() ==
                                          'service_completed')
                                  ? Colors.green
                                  : Color(int.parse(
                                      event.color?.replaceFirst('#', '0xff') ??
                                          '0xff2196F3')),
                            ),
                            trailing: (event.images != null &&
                                    event.images!.isNotEmpty)
                                ? const Icon(Icons.image, color: Colors.grey)
                                : null,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  Color _getEventColor(CalendarEvent event) {
    if (event.status?.toLowerCase() == 'completed' ||
        event.status?.toLowerCase() == 'service_completed') {
      return Colors.green;
    } else if (event.color != null) {
      try {
        return Color(int.parse(event.color!.replaceFirst('#', '0xff')));
      } catch (_) {}
    }
    return Colors.blue;
  }

  Widget _buildDayCell(DateTime day, Color color,
      {bool isSelected = false, bool isToday = false}) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: color.withOpacity(isSelected ? 1 : 0.7),
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.black, width: 2)
            : isToday
                ? Border.all(color: Colors.orange, width: 2)
                : null,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ImageCarouselBottomSheet extends StatefulWidget {
  final List<String>? beforeImages;
  final List<String>? afterImages;
  final String? beforeUploadedAt;
  final String? afterUploadedAt;

  const _ImageCarouselBottomSheet({
    this.beforeImages,
    this.afterImages,
    this.beforeUploadedAt,
    this.afterUploadedAt,
  });

  @override
  State<_ImageCarouselBottomSheet> createState() =>
      _ImageCarouselBottomSheetState();
}

class _ImageCarouselBottomSheetState extends State<_ImageCarouselBottomSheet> {
  int _currentIndex = 0;
  String _selectedTab = 'before';

  @override
  Widget build(BuildContext context) {
    final double sheetWidth = MediaQuery.of(context).size.width * 0.9;
    final double sheetHeight = MediaQuery.of(context).size.height * 0.6;

    List<String>? currentImages =
        _selectedTab == 'before' ? widget.beforeImages : widget.afterImages;

    String? currentUploadDate = _selectedTab == 'before'
        ? widget.beforeUploadedAt
        : widget.afterUploadedAt;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tab Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Before'),
                const SizedBox(width: 16),
                _buildTabButton('After'),
              ],
            ),

            const SizedBox(height: 16),

            // Upload Date
            if (currentUploadDate != null)
              Text(
                'Uploaded on: ${_formatDate(currentUploadDate)}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

            const SizedBox(height: 12),

            // Image Viewer
            if (currentImages != null && currentImages.isNotEmpty)
              Column(
                children: [
                  SizedBox(
                    width: sheetWidth,
                    height: sheetHeight * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        currentImages[_currentIndex],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentIndex > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              _currentIndex--;
                            });
                          },
                        ),
                      Text('${_currentIndex + 1} / ${currentImages.length}'),
                      if (_currentIndex < currentImages.length - 1)
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              _currentIndex++;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              )
            else
              const Text('No images available in this section.'),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label) {
    final isSelected = _selectedTab == label.toLowerCase();
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedTab = label.toLowerCase();
          _currentIndex = 0;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final date =
          DateTime.parse(rawDate).toLocal(); // Convert to local timezone

      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year;

      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$day/$month/$year at $hour:$minute $period';
    } catch (_) {
      return rawDate;
    }
  }
}
