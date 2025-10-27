import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../auth/controller/auth_controller.dart';
import '../model/vehicle_model.dart';

class VehicleService {
  static final String _baseUrl = 'https://madadservices.com/api/v1/customer';

  /// 🔐 Generate headers using token, fallback to AuthController if not passed.
  static Map<String, String> _getHeaders({String? token}) {
    final authToken = token ?? Get.find<AuthController>().getUserToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  /// Mocked brand list (static)
  static Future<List<String>> getBrands() async {
    return ['Hyundai', 'Maruti', 'Toyota', 'Honda'];
  }

  /// 🚗 Fetch vehicle types from backend
  static Future<List<Map<String, dynamic>>> getTypes({String? token}) async {
    final url = Uri.parse('$_baseUrl/service/vehicle-types');

    final response = await http.get(url, headers: _getHeaders(token: token));

    print('[GET TYPES] Status: ${response.statusCode}');
    print('[GET TYPES] Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return List<Map<String, dynamic>>.from(data['data'].map((e) => {
          'id': e['id'],
          'vehicle_name': e['vehicle_name'],
        }));
      }
      return [];
    } else {
      throw Exception('Failed to fetch vehicle types (${response.statusCode})');
    }
  }

  /// Mocked model list (static)
  static Future<List<String>> getModels(String brand) async {
    return ['Model A', 'Model B', 'Model C'];
  }

  /// 🛠️ Save vehicle to backend
  static Future<void> saveVehicle(VehicleModel vehicle, {String? token}) async {
    final url = Uri.parse('$_baseUrl/vehicle/store');

    final response = await http.post(
      url,
      headers: _getHeaders(token: token),
      body: jsonEncode(vehicle.toJson()),
    );

    print('[SAVE VEHICLE] Status: ${response.statusCode}');
    print('[SAVE VEHICLE] Body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save vehicle. ${response.statusCode} ${response.body}');
    }
  }

  /// 🧼 Delete vehicle (placeholder for now)
  static Future<void> deleteVehicle(String id, {String? token}) async {
    // When real endpoint is available, implement this:
    // final url = Uri.parse('$_baseUrl/vehicle/$id');
    // final response = await http.delete(url, headers: _getHeaders(token: token));
    // Add error handling similar to saveVehicle()
    throw UnimplementedError('deleteVehicle not implemented yet.');
  }
}
