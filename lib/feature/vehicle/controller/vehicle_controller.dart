import 'package:get/get.dart';
import '../model/vehicle_model.dart';
import '../service/vehicle_service.dart';
class VehicleController extends GetxController {
  var vehicles = <VehicleModel>[].obs;
  var brandList = <String>[].obs;
  var modelList = <String>[].obs;

  Future<void> fetchBrands() async {
    brandList.value = await VehicleService.getBrands();
  }

  Future<void> fetchModels(String brand) async {
    modelList.value = await VehicleService.getModels(brand);
  }

  void addVehicle(VehicleModel vehicle) {
    vehicles.add(vehicle);
    VehicleService.saveVehicle(vehicle);
  }

  void deleteVehicle(String id) {
    vehicles.removeWhere((v) => v.id == id);
    VehicleService.deleteVehicle(id);
  }
}