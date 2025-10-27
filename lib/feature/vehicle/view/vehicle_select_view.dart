import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vehicle_controller.dart';
import '../model/vehicle_model.dart';
import 'package:uuid/uuid.dart';

class VehicleSelectView extends StatelessWidget {
  final VehicleController controller = Get.find();
  final RxString selectedBrand = ''.obs;
  final RxString selectedModel = ''.obs;

  @override
  Widget build(BuildContext context) {
    controller.fetchBrands();

    return Scaffold(
      appBar: AppBar(title: Text("Select Vehicle")),
      body: Obx(() => Column(
            children: [
              DropdownButton<String>(
                hint: Text("Select Brand"),
                value: selectedBrand.value.isEmpty ? null : selectedBrand.value,
                items: controller.brandList.map((brand) {
                  return DropdownMenuItem(value: brand, child: Text(brand));
                }).toList(),
                onChanged: (val) {
                  selectedBrand.value = val!;
                  selectedModel.value = '';
                  controller.fetchModels(val);
                },
              ),
              DropdownButton<String>(
                hint: Text("Select Model"),
                value: selectedModel.value.isEmpty ? null : selectedModel.value,
                items: controller.modelList.map((model) {
                  return DropdownMenuItem(value: model, child: Text(model));
                }).toList(),
                onChanged: (val) => selectedModel.value = val!,
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedBrand.isNotEmpty && selectedModel.isNotEmpty) {
                    controller.addVehicle(
                      VehicleModel(
                        id: Uuid().v4(),
                        brand: selectedBrand.value,
                        model: selectedModel.value,
                      ),
                    );
                    Get.back();
                  }
                },
                child: Text("Save Vehicle"),
              )
            ],
          )),
    );
  }
}
