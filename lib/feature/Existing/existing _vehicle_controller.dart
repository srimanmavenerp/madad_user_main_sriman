import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:madaduser/feature/Existing/existing_vehicle_model.dart';
import '../auth/controller/auth_controller.dart';


class VehicleSessionController extends GetxController {
  Rx<VehicleSessionModel?> vehicleSession = Rx<VehicleSessionModel?>(null);
  RxBool isLoading = false.obs;

  Future<bool> createVehicleSession(String vehicleId) async {
    isLoading.value = true;
    final authController = Get.find<AuthController>();
    final token = authController.getUserToken();

    final url = Uri.parse('https://madadservices.com/api/v1/customer/vehicle/session');
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({'vehicle_id': vehicleId});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('[VehicleSessionController] Response status: ${response.statusCode}');
      print('[VehicleSessionController] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        vehicleSession.value = VehicleSessionModel.fromJson(data);
        print('[VehicleSessionController] Session created: ${vehicleSession.value?.data?.vehicleId}');
        return true;
      }
      else {
        print('[VehicleSessionController] Failed to create session');
        vehicleSession.value = null;
        return false;
      }
    } catch (e) {
      print('[VehicleSessionController] Exception: $e');
      vehicleSession.value = null;
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
