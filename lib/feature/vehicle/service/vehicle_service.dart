import '../model/vehicle_model.dart';
class VehicleService {
  static Future<List<String>> getBrands() async {
    // Replace with your API call
    return ['Hyundai', 'Maruti', 'Toyota', 'Honda'];
  }

  static Future<List<String>> getModels(String brand) async {
    // Replace with your API call based on brand
    return ['Model A', 'Model B', 'Model C'];
  }

  static Future<void> saveVehicle(VehicleModel vehicle) async {
    // Save to backend
  }

  static Future<void> deleteVehicle(String id) async {
    // Delete from backend
  }
}