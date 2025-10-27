// import 'package:madaduser/utils/core_export.dart';
// import 'package:get/get.dart';
//
//
// class BookingDetailsRepo{
//   final SharedPreferences sharedPreferences;
//   final ApiClient apiClient;
//   BookingDetailsRepo({required this.sharedPreferences,required this.apiClient});
//
//
//   Future<Response> getBookingDetails({required String bookingID})async{
//     return await apiClient.getData("${AppConstants.bookingDetails}/$bookingID");
//   }
//
//   Future<Response> getSubBookingDetails({required String bookingID})async{
//     return await apiClient.getData("${AppConstants.subBookingDetails}/$bookingID");
//   }
//
//   Future<Response> trackBookingDetails({required String bookingID, required String phoneNUmber})async{
//     return await apiClient.postData("${AppConstants.trackBooking}/$bookingID",{
//       "phone": phoneNUmber
//     });
//   }
//
//
//   Future<Response> bookingCancel({required String bookingID}) async {
//     return await apiClient.postData('${AppConstants.bookingCancel}/$bookingID', {
//       "booking_status" :"canceled",
//       "_method" : "put"});
//   }
//
//   Future<Response> subBookingCancel({required String bookingID}) async {
//     return await apiClient.postData('${AppConstants.subBookingCancel}/$bookingID', {});
//   }
//
//   Future<void>  setLastIncompleteOfflineBookingId(String bookingId) async {
//     await sharedPreferences.setString(AppConstants.lastIncompleteOfflineBookingId, bookingId);
//   }
//
//   String getLastIncompleteOfflineBookingId() {
//     return sharedPreferences.getString(AppConstants.lastIncompleteOfflineBookingId) ?? "";
//   }
//
// }




import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class BookingDetailsRepo{
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  BookingDetailsRepo({required this.sharedPreferences,required this.apiClient});


  Future<Response> getBookingDetails({required String bookingID})async{
    return await apiClient.getData("${AppConstants.bookingDetails}/$bookingID");
  }

  Future<Response> getSubBookingDetails({required String bookingID})async{
    return await apiClient.getData("${AppConstants.subBookingDetails}/$bookingID");
  }

  Future<Response> trackBookingDetails({required String bookingID, required String phoneNUmber})async{
    return await apiClient.postData("${AppConstants.trackBooking}/$bookingID",{
      "phone": phoneNUmber
    });
  }


  Future<Response> bookingCancel({required String bookingID}) async {
    return await apiClient.postData('${AppConstants.bookingCancel}/$bookingID', {
      "booking_status" :"canceled",
      "_method" : "put"});
  }

  Future<Response> subBookingCancel({required String bookingID}) async {
    return await apiClient.postData('${AppConstants.subBookingCancel}/$bookingID', {});
  }

  Future<void>  setLastIncompleteOfflineBookingId(String bookingId) async {
    await sharedPreferences.setString(AppConstants.lastIncompleteOfflineBookingId, bookingId);
  }

  String getLastIncompleteOfflineBookingId() {
    return sharedPreferences.getString(AppConstants.lastIncompleteOfflineBookingId) ?? "";
  }


  // Future<Response> getEligibleDates({required String bookingID}) async {
  //   return await apiClient.getData("${AppConstants.bookingDetails}/$bookingID/interior-cleaning-dates");
  // }
  /////Balu


  Future<Response> getEligibleDates({required String bookingID}) async {
    final String url = "${AppConstants.bookingDetails}/$bookingID/interior-cleaning-dates";
    print("Requesting getEligibleDates: $url");

    final Response response = await apiClient.getData(url);

    print("Response Status getEligibleDates: ${response.statusCode}");
    print("Response Body getEligibleDates: ${response.body}");

    return response;
  }

  /////////

  Future<Response> submitSelectedDates({
    required String bookingID,
    required List<String> selectedDates,
  }) async {
    final String url = "${AppConstants.bookingDetails}/$bookingID/interior-cleaning-dates";

    final Map<String, dynamic> body = {
      "dates": selectedDates,
    };

    print("Submitting selected dates to: $url");
    print(" Body: $body");

    final Response response = await apiClient.postData(url, body);

    print(" Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    return response;
  }



}