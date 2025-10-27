/*




import 'dart:convert';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class CheckoutRepo extends GetxService {
  final ApiClient apiClient;
  CheckoutRepo({required this.apiClient});

  Future<Response> getPostDetails(String postId, String bidId) async {
    return await apiClient.getData('${AppConstants.getPostDetails}/$postId?post_bid_id=$bidId');
  }

  Future<Response> getOfflinePaymentMethod() async {
    Response response = await apiClient.getData(AppConstants.offlinePaymentUri);
    return response;
  }

  Future<Response> getDigitalPaymentResponse({String? transactionId}) async {
    return await apiClient.getData('${AppConstants.digitalPaymentResponse}?transaction_id=$transactionId');
  }

  Future<Response?> checkExistingUser({required String phone}) async {
    return await apiClient.postData(
      AppConstants.checkExistingUser,
      {
        "phone": phone,
      },
    );
  }

  Future<Response?>submitOfflinePaymentData({required String bookingId, required String offlinePaymentId, required offlinePaymentInfo, required int isPartialPayment}) async {
    return await apiClient.postData(
      AppConstants.offlinePaymentDataStore,
      {
        "booking_id": bookingId,
        "offline_payment_id" : offlinePaymentId,
        "customer_information" : offlinePaymentInfo,
        "is_partial" : isPartialPayment,
      },
    );
  }

  Future<Response?> switchPaymentMethod({required String bookingId,  required String paymentMethod,  int isPartial = 0,  String? offlinePaymentId, String? offlinePaymentInfo}) async {
    return await apiClient.postData(
      AppConstants.switchPaymentMethod,
      {
        "booking_id": bookingId,
        "payment_method" : paymentMethod,
        "offline_payment_id" : offlinePaymentId,
        "customer_information" : offlinePaymentInfo,
        "is_partial" : isPartial
      },
    );
  }

  Future<Response> placeBookingRequest({
    required String paymentMethod, String? serviceAddressID, required AddressModel serviceAddress,String? schedule,
    required String zoneId, required int isPartial, required String serviceLocation,
    required String serviceType, String? bookingType, String? dates, SignUpBody? newUserInfo, String? slot
  }) async {
    String address = jsonEncode(serviceAddress);
    return await apiClient.postData(AppConstants.placeRequest, {
      "payment_method" : paymentMethod,
      "zone_id" : zoneId,
      "service_schedule" : schedule,
      "service_address_id" : serviceAddressID,
      "guest_id" : Get.find<SplashController>().getGuestId(),
      "service_address" : address,
      "is_partial" : isPartial,
      "service_type": serviceType,
      "booking_type": bookingType,
      "dates": dates,
      "new_user_info": newUserInfo !=null ? jsonEncode(newUserInfo) : null,
      "service_location": serviceLocation,
      "slot": slot != null ? slot : null // Uncomment if slot is needed
    });
  }
}
*/

import 'dart:convert';
import 'package:madaduser/utils/core_export.dart';
import 'package:get/get.dart';


class CheckoutRepo extends GetxService {
  final ApiClient apiClient;
  CheckoutRepo({required this.apiClient});

  Future<String?> getSelectedVehicleId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_vehicle_id');
  }

  Future<Response> getOfflinePaymentMethod() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? vehicleId = prefs.getString('selected_vehicle_id');

    // Build the URL
    String url = AppConstants.offlinePaymentUri;
    if (vehicleId != null && vehicleId.isNotEmpty) {
      url += '?service_vehicle_details_id=$vehicleId';
    }

    print(" Requesting Offline Payment URLlllll: $url");

    return await apiClient.getData(url);
  }



  Future<Response> getPostDetails(String postId, String bidId) async {
    return await apiClient.getData('${AppConstants.getPostDetails}/$postId?post_bid_id=$bidId');
  }

  // Future<Response> getOfflinePaymentMethod() async {
  //   Response response = await apiClient.getData(AppConstants.offlinePaymentUri);
  //   return response;
  // }

  Future<Response> getDigitalPaymentResponse({String? transactionId}) async {
    return await apiClient.getData('${AppConstants.digitalPaymentResponse}?transaction_id=$transactionId');
  }

  Future<Response?> checkExistingUser({required String phone}) async {
    return await apiClient.postData(
      AppConstants.checkExistingUser,
      {
        "phone": phone,
      },
    );
  }

  Future<Response?>submitOfflinePaymentData({required String bookingId, required String offlinePaymentId, required offlinePaymentInfo, required int isPartialPayment}) async {
    return await apiClient.postData(
      AppConstants.offlinePaymentDataStore,
      {
        "booking_id": bookingId,
        "offline_payment_id" : offlinePaymentId,
        "customer_information" : offlinePaymentInfo,
        "is_partial" : isPartialPayment,
      },
    );
  }

  Future<Response?> switchPaymentMethod({required String bookingId,  required String paymentMethod,  int isPartial = 0,  String? offlinePaymentId, String? offlinePaymentInfo}) async {
    return await apiClient.postData(
      AppConstants.switchPaymentMethod,
      {
        "booking_id": bookingId,
        "payment_method" : paymentMethod,
        "offline_payment_id" : offlinePaymentId,
        "customer_information" : offlinePaymentInfo,
        "is_partial" : isPartial
      },
    );
  }

  Future<Response> placeBookingRequest({
    required String paymentMethod, String? serviceAddressID,String? serviceVehicleId,
    required AddressModel serviceAddress,String? schedule,
    required String zoneId, required int isPartial,   required String serviceLocation,
    required String serviceType, String? bookingType, String? dates, SignUpBody? newUserInfo, String? slot
  }) async {
    String address = jsonEncode(serviceAddress);
    print("Placing booking with service_vehicle_details_id: $serviceVehicleId");
    return await apiClient.postData(AppConstants.placeRequest, {
      "payment_method" : paymentMethod,
      "zone_id" : zoneId,
      "service_schedule" : schedule,
      "service_address_id" : serviceAddressID,
      "guest_id" : Get.find<SplashController>().getGuestId(),
      "service_address" : address,
      "service_vehicle_details_id": serviceVehicleId,
      "is_partial" : isPartial,
      "service_type": serviceType,
      "booking_type": bookingType,
      "dates": dates,
      "new_user_info": newUserInfo !=null ? jsonEncode(newUserInfo) : null,
      "service_location": serviceLocation,
      //"slot":"9 am to 5 Pm"

      "slot": slot != null ? slot : null // Uncomment if slot is needed
    });
  }
}