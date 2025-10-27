import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/core_export.dart';
import '../controller/controller.dart';

class VariantListView extends StatelessWidget {
  final String serviceId;
  final String vehicleType;

  VariantListView({required this.serviceId, required this.vehicleType, Key? key}) : super(key: key);

  final VariantController controller = Get.put(VariantController());

  @override
  Widget build(BuildContext context) {
    // Safe async call via addPostFrameCallback to avoid premature fetch during widget build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.variants.isEmpty && !controller.isLoading.value) {
        controller.fetchVariants(serviceId, vehicleType);
      }
    });

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.variants.isEmpty) {
        return const Center(child: Text('No packages available'));
      }

      return ListView.builder(
        itemCount: controller.variants.length,
        itemBuilder: (context, index) {
          final variant = controller.variants[index];

          return Card(
            margin: const EdgeInsets.all(12),
            elevation: 3,
            child: ListTile(
              title: Text(
                variant.variant,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("₹${variant.price.toStringAsFixed(2)}"),
              onTap: () {
                // You can implement selection logic here
              },
            ),
          );
        },
      );
    });
  }
}
