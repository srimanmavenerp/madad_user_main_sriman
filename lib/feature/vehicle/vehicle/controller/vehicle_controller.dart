// import 'package:get/get.dart';
// import '../model/vehicle_model.dart';
// import '../service/vehicle_service.dart';
// import 'package:madaduser/utils/core_export.dart'; // Contains customSnackBar, AuthController, etc.
// import '../../../auth/controller/auth_controller.dart'; // Explicit import for AuthController if not in core_export
//
// class VehicleController extends GetxController {
//   // Renamed 'vehicles' to 'vehicleList' for consistency with _VehicleSelectViewState
//   final RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
//   // `filteredVehicles` is not currently used in the provided UI, keeping for future use if needed
//   final RxList<VehicleModel> filteredVehicles = <VehicleModel>[].obs;
//
//   final RxList<String> brandList = <String>[].obs;
//   final RxList<Map<String, dynamic>> typeList = <Map<String, dynamic>>[].obs;
//   final RxList<String> modelList = <String>[].obs;
//
//   // This is for a newly being-created vehicle or the vehicle whose details are currently in the form
//   final Rxn<VehicleModel> selectedVehicle = Rxn<VehicleModel>();
//   // This is for an existing vehicle selected from the list
//   final Rxn<VehicleModel> selectedExistingVehicle = Rxn<VehicleModel>();
//
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs; // Added for better error feedback
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch user vehicles when the controller initializes to populate the "Existing Vehicles" list
//     fetchUserVehicles();
//     fetchBrands(); // Fetch brands on init
//     fetchTypes(); // Fetch types on init
//   }
//
//   // Fetch all vehicles for the current user (for the "Existing Vehicle" list)
//   Future<void> fetchUserVehicles() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in to fetch vehicles.';
//         isLoading.value = false;
//         return;
//       }
//       //final List<VehicleModel> fetched = await VehicleService.getUserVehicles(token: authToken);
//       //vehicleList.assignAll(fetched);
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch user vehicles: $e';
//       customSnackBar('Failed to load your vehicles: ${e.toString()}', type: ToasterMessageType.error);
//       print('Error fetching user vehicles: $e'); // For debugging
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchBrands() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in.';
//         isLoading.value = false;
//         return;
//       }
//       // Assuming VehicleService.getBrands now takes a token
//       //brandList.value = await VehicleService.getBrands(token: authToken);
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch brands: $e';
//       customSnackBar('Failed to load brands: ${e.toString()}', type: ToasterMessageType.error);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchTypes() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in.';
//         isLoading.value = false;
//         return;
//       }
//       // Assuming VehicleService.getTypes now takes a token
//       typeList.value = await VehicleService.getTypes(token: authToken);
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch types: $e';
//       customSnackBar('Failed to load vehicle types: ${e.toString()}', type: ToasterMessageType.error);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> fetchModels(String brand) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in.';
//         isLoading.value = false;
//         return;
//       }
//       // Assuming VehicleService.getModels now takes a token
//       //modelList.value = await VehicleService.getModels(brand, token: authToken);
//     } catch (e) {
//       errorMessage.value = 'Failed to fetch models: $e';
//       customSnackBar('Failed to load models: ${e.toString()}', type: ToasterMessageType.error);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Method to add a new vehicle
//   Future<void> addVehicle(VehicleModel vehicle) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in to add vehicle.';
//         isLoading.value = false;
//         return;
//       }
//       // Assuming VehicleService.saveVehicle now takes a token
//       await VehicleService.saveVehicle(vehicle, token: authToken);
//       vehicleList.add(vehicle); // Add to the local list
//       customSnackBar('Vehicle added successfully', type: ToasterMessageType.success);
//       // No Get.back() here, as this method might be called from within the view logic.
//       // The view itself should handle navigation if needed after a successful add.
//     } catch (e) {
//       errorMessage.value = 'Failed to add vehicle: ${e.toString()}';
//       customSnackBar('Failed to add vehicle', type: ToasterMessageType.error);
//       print('Error adding vehicle: $e'); // For debugging
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Method to delete a vehicle
//   Future<void> deleteVehicle(String id) async {
//     isLoading.value = true;
//     errorMessage.value = '';
//     try {
//       final authController = Get.find<AuthController>();
//       final authToken = authController.getUserToken();
//       if (authToken == null || authToken.isEmpty) {
//         errorMessage.value = 'Authentication token is missing. Please log in to delete vehicle.';
//         isLoading.value = false;
//         return;
//       }
//       // Assuming VehicleService.deleteVehicle now takes a token
//       await VehicleService.deleteVehicle(id, token: authToken);
//       vehicleList.removeWhere((v) => v.id == id); // Remove from local list
//       customSnackBar('Vehicle deleted successfully', type: ToasterMessageType.success);
//     } catch (e) {
//       errorMessage.value = 'Failed to delete vehicle: ${e.toString()}';
//       customSnackBar('Failed to delete vehicle', type: ToasterMessageType.error);
//       print('Error deleting vehicle: $e'); // For debugging
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // New: Method to set the selected existing vehicle
//   void setSelectedExistingVehicle(VehicleModel vehicle) {
//     selectedExistingVehicle.value = vehicle;
//     // You might want to clear or update the `selectedVehicle` (the one for new vehicle form)
//     // if a user selects an existing one, to prevent confusion.
//     selectedVehicle.value = null; // Clear any pending new vehicle data
//   }
//
//   // New: Method to clear the selected existing vehicle
//   void clearSelectedExistingVehicle() {
//     selectedExistingVehicle.value = null;
//   }
// }

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Add GetStorage import
import '../model/vehicle_model.dart';
import '../service/vehicle_service.dart';
import 'package:madaduser/utils/core_export.dart'; // Contains customSnackBar, AuthController, etc.
import '../../../auth/controller/auth_controller.dart'; // Explicit import for AuthController if not in core_export

class VehicleController extends GetxController {
  // Renamed 'vehicles' to 'vehicleList' for consistency with _VehicleSelectViewState
  final RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  // `filteredVehicles` is not currently used in the provided UI, keeping for future use if needed
  final RxList<VehicleModel> filteredVehicles = <VehicleModel>[].obs;

  final RxList<String> brandList = <String>[].obs;
  final RxList<Map<String, dynamic>> typeList = <Map<String, dynamic>>[].obs;
  final RxList<String> modelList = <String>[].obs;

  // This is for a newly being-created vehicle or the vehicle whose details are currently in the form
  final Rxn<VehicleModel> selectedVehicle = Rxn<VehicleModel>();
  // This is for an existing vehicle selected from the list
  final Rxn<VehicleModel> selectedExistingVehicle = Rxn<VehicleModel>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs; // Added for better error feedback

  // New: Properties to persist service arguments
  final RxString serviceId = ''.obs;
  final RxString subCategoryId = ''.obs;
  final RxString categoryId = ''.obs;

  // New: GetStorage instance for persistent storage
  final GetStorage _storage = GetStorage();
  final isBookingLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Fetch user vehicles when the controller initializes to populate the "Existing Vehicles" list
    fetchUserVehicles();
    fetchBrands(); // Fetch brands on init
    fetchTypes(); // Fetch types on init
    // Load stored arguments from GetStorage
    loadStoredArguments();
  }

  // New: Method to load arguments from GetStorage
  void loadStoredArguments() {
    serviceId.value = _storage.read('serviceId') ?? '';
    subCategoryId.value = _storage.read('subCategoryId') ?? '';
    categoryId.value = _storage.read('categoryId') ?? '';
    print(
      ' VehicleController: Loaded stored arguments: serviceId=${serviceId.value}, '
      'subCategoryId=${subCategoryId.value}, categoryId=${categoryId.value}',
    );
  }

  void setServiceArguments(
    String serviceId,
    String subCategoryId,
    String categoryId,
  ) {
    this.serviceId.value = serviceId;
    this.subCategoryId.value = subCategoryId;
    this.categoryId.value = categoryId;

    // Persist values in GetStorage
    _storage.write('serviceId', serviceId);
    _storage.write('subCategoryId', subCategoryId);
    _storage.write('categoryId', categoryId);

    print(
      'VehicleController: Set serviceId=$serviceId, subCategoryId=$subCategoryId, categoryId=$categoryId',
    );
  }

  // New: Method to set service arguments and store them in GetStorage
  // void setServiceArguments(String serviceId, String subCategoryId, String categoryId) {
  //   this.serviceId.value = serviceId;
  //   this.subCategoryId.value = subCategoryId;
  //   this.categoryId.value = categoryId;
  //   // Store in GetStorage for persistence
  //   _storage.write('serviceId', serviceId);
  //   _storage.write('subCategoryId', subCategoryId);
  //   _storage.write('categoryId', categoryId);
  //   print('VehicleController: Set serviceId=$serviceId, subCategoryId=$subCategoryId, categoryId=$categoryId');
  // }

  // Fetch all vehicles for the current user (for the "Existing Vehicle" list)
  Future<void> fetchUserVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value =
            'Authentication token is missing. Please log in to fetch vehicles.';
        isLoading.value = false;
        return;
      }
      //final List<VehicleModel> fetched = await VehicleService.getUserVehicles(token: authToken);
      //vehicleList.assignAll(fetched);
    } catch (e) {
      errorMessage.value = 'Failed to fetch user vehicles: $e';
      customSnackBar(
        'Failed to load your vehicles: ${e.toString()}',
        type: ToasterMessageType.error,
      );
      print('Error fetching user vehicles: $e'); // For debugging
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBrands() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value = 'Authentication token is missing. Please log in.';
        isLoading.value = false;
        return;
      }
      // Assuming VehicleService.getBrands now takes a token
      //brandList.value = await VehicleService.getBrands(token: authToken);
    } catch (e) {
      errorMessage.value = 'Failed to fetch brands: $e';
      customSnackBar(
        'Failed to load brands: ${e.toString()}',
        type: ToasterMessageType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTypes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value = 'Authentication token is missing. Please log in.';
        isLoading.value = false;
        return;
      }
      // Assuming VehicleService.getTypes now takes a token
      typeList.value = await VehicleService.getTypes(token: authToken);
    } catch (e) {
      errorMessage.value = 'Failed to fetch types: $e';
      customSnackBar(
        'Failed to load vehicle types: ${e.toString()}',
        type: ToasterMessageType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchModels(String brand) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value = 'Authentication token is missing. Please log in.';
        isLoading.value = false;
        return;
      }
      // Assuming VehicleService.getModels now takes a token
      //modelList.value = await VehicleService.getModels(brand, token: authToken);
    } catch (e) {
      errorMessage.value = 'Failed to fetch models: $e';
      customSnackBar(
        'Failed to load models: ${e.toString()}',
        type: ToasterMessageType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method to add a new vehicle
  Future<void> addVehicle(VehicleModel vehicle) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value =
            'Authentication token is missing. Please log in to add vehicle.';
        isLoading.value = false;
        return;
      }
      // Assuming VehicleService.saveVehicle now takes a token
      await VehicleService.saveVehicle(vehicle, token: authToken);
      vehicleList.add(vehicle); // Add to the local list
      customSnackBar(
        'Vehicle added successfully',
        type: ToasterMessageType.success,
      );
      // No Get.back() here, as this method might be called from within the view logic.
      // The view itself should handle navigation if needed after a successful add.
    } catch (e) {
      errorMessage.value = 'Failed to add vehicle: ${e.toString()}';
      customSnackBar('Failed to add vehicle', type: ToasterMessageType.error);
      print('Error adding vehicle: $e'); // For debugging
    } finally {
      isLoading.value = false;
    }
  }

  // Method to delete a vehicle
  Future<void> deleteVehicle(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final authController = Get.find<AuthController>();
      final authToken = authController.getUserToken();
      if (authToken == null || authToken.isEmpty) {
        errorMessage.value =
            'Authentication token is missing. Please log in to delete vehicle.';
        isLoading.value = false;
        return;
      }
      // Assuming VehicleService.deleteVehicle now takes a token
      await VehicleService.deleteVehicle(id, token: authToken);
      vehicleList.removeWhere((v) => v.id == id); // Remove from local list
      customSnackBar(
        'Vehicle deleted successfully',
        type: ToasterMessageType.success,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete vehicle: ${e.toString()}';
      customSnackBar(
        'Failed to delete vehicle',
        type: ToasterMessageType.error,
      );
      print('Error deleting vehicle: $e'); // For debugging
    } finally {
      isLoading.value = false;
    }
  }

  // Method to set the selected existing vehicle
  void setSelectedExistingVehicle(VehicleModel vehicle) {
    selectedExistingVehicle.value = vehicle;
    // Clear any pending new vehicle data to prevent confusion
    selectedVehicle.value = null;
  }

  // Method to clear the selected existing vehicle
  void clearSelectedExistingVehicle() {
    selectedExistingVehicle.value = null;
  }

  // New: Method to clear stored arguments
  // void clearStoredArguments() {
  //   _storage.remove('serviceId');
  //   _storage.remove('subCategoryId');
  //   _storage.remove('categoryId');
  //   serviceId.value = '';
  //   subCategoryId.value = '';
  //   categoryId.value = '';
  //   print('VehicleController: Cleared stored arguments');
  // }
}
