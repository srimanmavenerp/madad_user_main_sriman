import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vehicle_controller.dart';
import '../model/vehicle_model.dart';
import 'vehicle_select_view.dart';

class VehicleView extends StatelessWidget {
  final VehicleController controller = Get.put(VehicleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Vehicles")),
      body: Obx(() {
        if (controller.vehicles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 60, color: Colors.red),
                Text("No vehicles added."),
                TextButton(
                  onPressed: () => Get.to(() => VehicleSelectView()),
                  child: Text("Add a Vehicle"),
                )
              ],
            ),
          );
        } else {
          return ListView(
            children: [
              ...controller.vehicles.map((v) => ListTile(
                    title: Text("${v.brand} ${v.model}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteVehicle(v.id),
                    ),
                  )),
              ListTile(
                leading: Icon(Icons.add, color: Colors.green),
                title: Text("Add another vehicle"),
                onTap: () => Get.to(() => VehicleSelectView()),
              )
            ],
          );
        }
      }),
    );
  }
}