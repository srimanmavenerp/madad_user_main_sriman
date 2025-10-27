// import 'package:get/get.dart';
// import '../models/eligible_dates.dart';
// import '../repository/booking_repository.dart';
//
// class BookingController extends GetxController {
//   final BookingRepository _repository = BookingRepository();
//
//   var eligibleDates = Rxn<EligibleDates>();
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//
//   Future<void> getEligibleDates(String bookingId) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final result = await _repository.fetchEligibleDates(bookingId);
//       if (result != null) {
//         eligibleDates.value = result;
//       } else {
//         errorMessage.value = 'Failed to load eligible dates.';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: $e';
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'package:get/get.dart';
import '../repo/booking_details_repo.dart';
import 'package:madaduser/utils/core_export.dart';
import 'EligibleDates_model.dart';

class BookingController extends GetxController {
  final BookingDetailsRepo _repository;

  BookingController({required BookingDetailsRepo repository}) : _repository = repository;

  var eligibleDates = Rxn<EligibleDates>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> getEligibleDates(String bookingId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _repository.getEligibleDates(bookingID: bookingId);

      if (response.statusCode == 200) {
        eligibleDates.value = EligibleDates.fromJson(response.body);
      } else {
        errorMessage.value = 'Failed to load eligible dates: ${response.statusText}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔄 Expose submitSelectedDates to the view
  Future<Response> submitSelectedDates({
    required String bookingID,
    required List<String> selectedDates,
  }) async {
    return await _repository.submitSelectedDates(
      bookingID: bookingID,
      selectedDates: selectedDates,
    );
  }
}

