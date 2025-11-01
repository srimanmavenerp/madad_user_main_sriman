import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TypesOfCarWash_Api_repo.dart';
import 'typesof_carWash_model.dart';

class TypesOfCarWashController extends GetxController {
  final TypesOfCarWashRepo repo = TypesOfCarWashRepo();

  var typesOfCarWash = Rxn<TypesOfCarWash>();
  var isLoading = false.obs;
  var error = RxnString();
  var currentServiceId = RxnString(); // Track current service ID

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load previously stored service IDs
  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList('service_ids');
    if (storedIds != null && storedIds.isNotEmpty) {
      currentServiceId.value = storedIds.first;
    }
  }

  // Fetch services for a given category with Snackbar for errors
  Future<void> fetchServicesByCategory(String categoryId) async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await repo.getServicesByCategory(categoryId);

      // No services found
      if (response == null ||
          response.services == null ||
          response.services!.isEmpty) {
        typesOfCarWash.value = null;
        currentServiceId.value = null;
        _showErrorSnackbar('No services available in this category.'.tr);
        return;
      }

      typesOfCarWash.value = response;

      // Store all service IDs in SharedPreferences
      final ids = response.services!
          .map((s) => s.id)
          .whereType<String>()
          .toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('service_ids', ids);

      // Update current service ID
      currentServiceId.value = ids.isNotEmpty ? ids.first : null;

      print(
        'Fetched ${ids.length} services. Current service ID: ${currentServiceId.value}',
      );
    } on SocketException {
      currentServiceId.value = null;
      // _showErrorSnackbar(
      //   'Please check your internet connection and try again.'.tr,
      // );
    } on TimeoutException {
      currentServiceId.value = null;
      // _showErrorSnackbar('The request timed out. Please try again.'.tr);
    } on HttpException {
      currentServiceId.value = null;
      // _showErrorSnackbar(
      //   'Unable to reach the server. Please try again later.'.tr,
      // );
    } catch (_) {
      currentServiceId.value = null;
      // _showErrorSnackbar('Something went wrong. Please try again.'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // Display Snackbar with custom message
  void _showErrorSnackbar(String message) {
    error.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFB00020),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  // Get the first available service ID
  String? getPrimaryServiceId() {
    return currentServiceId.value ??
        typesOfCarWash.value?.services?.firstOrNull?.id;
  }

  // Get all service IDs
  List<String> getAllServiceIds() {
    return typesOfCarWash.value?.services
            ?.map((s) => s.id)
            .whereType<String>()
            .toList() ??
        [];
  }

  // Clear all stored data
  Future<void> clearData() async {
    typesOfCarWash.value = null;
    currentServiceId.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('service_ids');
  }
}
