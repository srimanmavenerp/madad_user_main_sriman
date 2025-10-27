import 'package:get/get.dart';

import '../controller/vehicle_controller.dart';


class VehicleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VehicleController());
  }
}