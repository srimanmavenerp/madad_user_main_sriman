import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madaduser/feature/vehicle/vehicle/view/vehicle_select_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/core_export.dart';

class VehicleSelectLoader extends StatefulWidget {
  const VehicleSelectLoader({Key? key}) : super(key: key);

  @override
  _VehicleSelectLoaderState createState() => _VehicleSelectLoaderState();
}

class _VehicleSelectLoaderState extends State<VehicleSelectLoader> {
  @override
  void initState() {
    super.initState();
    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    try {
      // Retrieve SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      final List<String> validServiceIds = prefs.getStringList('service_ids') ?? [];

      // Get parameters from GetX navigation
      final serviceId = Get.parameters['serviceId'] ?? '';
      final subCategoryId = Get.parameters['subCategoryId'] ?? '';
      final categoryId = Get.parameters['categoryId'] ?? '';

      // Log parameters for debugging
      print('VehicleSelectLoader: Retrieved parameters - serviceId=$serviceId, subCategoryId=$subCategoryId, categoryId=$categoryId');

      // Validate serviceId
      final validatedServiceId = validServiceIds.contains(serviceId) ? serviceId : '';

      // Check if required parameters are present
      if (validatedServiceId.isEmpty || subCategoryId.isEmpty || categoryId.isEmpty) {
        Get.snackbar(
          'Error',
          'Invalid or missing service parameters. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Navigate back after a delay to ensure snackbar is visible
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Get.back();
        return;
      }

      // Log navigation attempt
      print('Navigating to VehicleSelectView with: serviceId=$validatedServiceId, subCategoryId=$subCategoryId, categoryId=$categoryId');

      // Navigate to VehicleSelectView with validated data
      if (mounted) {
        Get.to(() => VehicleSelectView(
          serviceId: validatedServiceId,
          subCategoryId: subCategoryId,
          categoryId: categoryId,
        ));
      }
    } catch (e) {
      // Handle any errors during SharedPreferences access or navigation
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to load service data: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Navigate back after a delay to ensure snackbar is visible
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}