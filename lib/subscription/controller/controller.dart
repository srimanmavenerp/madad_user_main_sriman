import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../feature/auth/controller/auth_controller.dart';
import '../../subscription/model/service_varient_model.dart';
import 'package:madaduser/feature/location/controller/location_controller.dart';
import 'package:madaduser/feature/address/model/address_model.dart';

class VariantController extends GetxController {
  final Rx<ServiceVariantResponse?> serviceVariantResponse = Rx<ServiceVariantResponse?>(null);
  final RxBool isLoading = false.obs;

  List<ServiceVariantModel> get variants {
    final response = serviceVariantResponse.value;
    if (response == null || response.data.isEmpty) return [];
    return response.data.expand((package) => package.variantOptions).toList();
  }

  Future<void> fetchVariants(String serviceId, String vehicleType, {String? zoneId}) async {
    if (serviceId.isEmpty || vehicleType.isEmpty) {
      Get.snackbar('Error', 'Service ID and Vehicle Type are required');
      return;
    }

    try {
      isLoading.value = true;

      final String finalZoneId = zoneId ?? await _getZoneId();

      if (finalZoneId.isEmpty) {
        Get.snackbar('Error', 'Zone ID is required. Please select your address first.');
        return;
      }

      final headers = {
        'Content-Type': 'application/json',
      };

      final authController = Get.find<AuthController>();
      final token = authController.getUserToken();
      if (authController.isLoggedIn() && token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(
        'https://madadservices.com/api/v1/customer/service/get-variant-by-service'
        '?service_id=$serviceId&vehicle_type=$vehicleType&zone_id=$finalZoneId',
      );

      print('Fetching variants from: $uri');
      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));

      await _handleResponse(response);
    } catch (e) {
      await _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

 Future<String> _getZoneId() async {
  try {
    if (Get.isRegistered<LocationController>()) {
      final locationController = Get.find<LocationController>();
      final selectedAddress = locationController.selectedAddress;

      if (selectedAddress != null) {
        return selectedAddress.zoneId ?? '';
      }
    }
    return '';
  } catch (e) {
    print('Error getting zoneId: $e');
    return '';
  }
}


  Future<void> _handleResponse(http.Response response) async {
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    switch (response.statusCode) {
      case 200:
        try {
          final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
          if (jsonData.containsKey('success') && jsonData.containsKey('data')) {
            serviceVariantResponse.value = ServiceVariantResponse.fromJson(jsonData);
            if (serviceVariantResponse.value?.data.isEmpty ?? true) {
              await Get.snackbar('Info', 'No packages found for selected vehicle type in this zone.');
            }
          } else {
            throw FormatException('Invalid response format');
          }
        } catch (e) {
          throw FormatException('Failed to parse response: $e');
        }
        break;
      case 401:
        await Get.find<AuthController>().clearSharedData();
        throw Exception('Authentication failed. Please login again.');
      case 404:
        throw Exception('Service not found');
      default:
        throw Exception('Server error: ${response.statusCode}');
    }
  }

  Future<void> _handleError(dynamic e) async {
    print('Error fetching variants: $e');
    serviceVariantResponse.value = ServiceVariantResponse(success: false, data: []);

    if (e.toString().contains('TimeoutException')) {
      await Get.snackbar('Error', 'Request timeout. Please check your internet connection.');
    } else if (e is FormatException) {
      await Get.snackbar('Error', 'Invalid data format received from server');
    } else {
      await Get.snackbar('Error', e.toString());
    }
  }

  void clearVariants() {
    serviceVariantResponse.value = null;
  }
}
