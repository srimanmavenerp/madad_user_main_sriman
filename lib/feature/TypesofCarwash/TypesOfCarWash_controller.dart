// import 'package:get/get.dart';
// import 'TypesOfCarWash_Api_repo.dart';
// import 'typesof_carWash_model.dart';
//
// class TypesOfCarWashController extends GetxController {
//   final TypesOfCarWashRepo repo = TypesOfCarWashRepo();
//
//   var typesOfCarWash = Rxn<TypesOfCarWash>();
//   var isLoading = false.obs;
//   var error = RxnString();
//
//   Future<void> fetchServicesByCategory(String categoryId) async {
//     isLoading.value = true;
//     error.value = null;
//     try {
//       typesOfCarWash.value = await repo.getServicesByCategory(categoryId);
//     } catch (e) {
//       error.value = e.toString();
//     }
//     isLoading.value = false;
//   }
// }


import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TypesOfCarWash_Api_repo.dart';
import 'typesof_carWash_model.dart';

class TypesOfCarWashController extends GetxController {
  final TypesOfCarWashRepo repo = TypesOfCarWashRepo();

  var typesOfCarWash = Rxn<TypesOfCarWash>();
  var isLoading = false.obs;
  var error = RxnString();
  var currentServiceId = RxnString(); // Track current service ID

  // Initialize controller and load data if needed
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load initial data from storage if available
  Future<void> loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedIds = prefs.getStringList('service_ids');
    if (storedIds != null && storedIds.isNotEmpty) {
      currentServiceId.value = storedIds.first;
    }
  }

  Future<void> fetchServicesByCategory(String categoryId) async {
    isLoading.value = true;
    error.value = null;

    try {
      final response = await repo.getServicesByCategory(categoryId);
      typesOfCarWash.value = response;

      if (response?.services != null && response!.services!.isNotEmpty) {
        // Store all service IDs in SharedPreferences
        final ids = response.services!.map((s) => s.id).whereType<String>().toList();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('service_ids', ids);

        // Update current service ID
        currentServiceId.value = ids.isNotEmpty ? ids.first : null;

        print('Fetched ${ids.length} services. Current service ID: ${currentServiceId.value}');
      } else {
        print('No services found for category: $categoryId');
        currentServiceId.value = null;
      }

    } catch (e) {
      error.value = e.toString();
      print('Error fetching services: $e');
      currentServiceId.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Get the first available service ID
  String? getPrimaryServiceId() {
    return currentServiceId.value ??
        typesOfCarWash.value?.services?.firstOrNull?.id;
  }

  // Get all service IDs
  List<String> getAllServiceIds() {
    return typesOfCarWash.value?.services?.map((s) => s.id).whereType<String>().toList() ?? [];
  }

  // Clear all stored data
  Future<void> clearData() async {
    typesOfCarWash.value = null;
    currentServiceId.value = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('service_ids');
  }
}
