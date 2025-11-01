import 'package:get/get.dart';
import 'package:madaduser/customsnackbar.dart';
import 'package:madaduser/utils/core_export.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../subscription/controller/controller.dart';
import '../../../../subscription/model/service_varient_model.dart';
import '../../../TypesofCarwash/TypesOfCarWash_controller.dart';
import '../controller/vehicle_controller.dart';
import '../model/vehicle_model.dart';
import '../service/vehicle_service.dart';

class VehicleSelectView extends StatefulWidget {
  final String serviceId;
  final String subCategoryId;
  final String categoryId;
  const VehicleSelectView({
    super.key,
    required this.serviceId,
    required this.subCategoryId,
    required this.categoryId,
  });

  @override
  State<VehicleSelectView> createState() => _VehicleSelectViewState();
}

class _VehicleSelectViewState extends State<VehicleSelectView> {
  final VehicleController vehicleController = Get.find();
  final VariantController variantController = Get.put(VariantController());
  final TypesOfCarWashController typesOfCarWashController = Get.put(
    TypesOfCarWashController(),
  );

  final RxString selectedBrand = ''.obs;
  final RxString selectedType = ''.obs;
  final RxString selectedModel = ''.obs;
  final RxString selectedOption = 'existing'.obs;
  final RxString selectedCountryCode = '+968'.obs;
  int? selectedPackageIndex;

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController _additionalDetailsController =
      TextEditingController();
  late Future<void> _autoCareFuture;

  final GlobalKey<FormState> vehicleFormKey = GlobalKey<FormState>();
  Map<int, ServiceVariantModel?> selectedVariants = {};
  final Uuid _uuid = const Uuid();
  late String _userId;
  var autoCarePackages = <ServicePackage>[].obs;

  bool _hasFetchedVariants = false;

  @override
  void initState() {
    super.initState();
    _userId = _uuid.v4();
    _brandController.text = selectedBrand.value;
    _modelController.text = selectedModel.value;

    _brandController.addListener(
      () => selectedBrand.value = _brandController.text,
    );
    _modelController.addListener(
      () => selectedModel.value = _modelController.text,
    );
    _additionalDetailsController.addListener(() {});
    _autoCareFuture = fetchAutoCareVariants();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadInitialData();

      final authController = Get.find<AuthController>();
      if (authController.getUserToken() == null ||
          authController.getUserToken()!.isEmpty) {
        Get.dialog(
          WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text(
                "Authentication Required",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text("Please log in to avail our services."),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed(RouteHelper.getSignInRoute());
                  },
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildVehicleCard(
    VehicleModel vehicle, {
    required bool isSelected,
    required VoidCallback onSelect,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.directions_car, size: 48, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.brand,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    vehicle.model,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  Text(
                    "Color: ${vehicle.color}",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    "No: ${vehicle.vehicleNo}",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: isSelected ? null : onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  isSelected ? "Selected" : "Select",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadInitialData() async {
    final hasLocation = await _checkLocation();
    if (!hasLocation) return;

    vehicleController.fetchBrands();
    vehicleController.fetchTypes();
    fetchVehicleData();
    if (widget.categoryId == '226716a4-0eb4-43bb-9078-5b4a08db5849') {
      await fetchAutoCareVariants();
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    colorController.dispose();
    numberController.dispose();
    contactController.dispose();
    _additionalDetailsController.dispose();
    super.dispose();
  }

  Future<String?> _getZoneId() async {
    try {
      final locationController = Get.find<LocationController>();
      final sharedPreferences = Get.find<SharedPreferences>();

      // ✅ 1. Try addressList first
      final addresses = locationController.addressList;
      if (addresses != null && addresses.isNotEmpty) {
        for (final address in addresses) {
          final zoneId = address.zoneId;
          if (zoneId != null && zoneId.trim().isNotEmpty) {
            print('[ZoneID] Found from addressList: $zoneId');
            return zoneId;
          }
        }
      }

      // ✅ 2. Fallback: try stored userAddress
      final savedAddressStr = sharedPreferences.getString(
        AppConstants.userAddress,
      );
      if (savedAddressStr != null && savedAddressStr.isNotEmpty) {
        final savedAddress = AddressModel.fromJson(jsonDecode(savedAddressStr));
        if (savedAddress.zoneId != null &&
            savedAddress.zoneId!.trim().isNotEmpty) {
          print(
            '[ZoneID] Found from SharedPreferences: ${savedAddress.zoneId}',
          );
          return savedAddress.zoneId;
        }
      }

      print('[ZoneID] Not found in addressList or SharedPreferences.');
      return null;
    } catch (e, stack) {
      print('[ZoneID ERROR] $e\n$stack');
      return null;
    }
  }

  Future<bool> _checkLocation() async {
    final sharedPreferences = Get.find<SharedPreferences>();
    try {
      final addressStr = sharedPreferences.getString(AppConstants.userAddress);
      if (addressStr == null || addressStr.isEmpty) {
        throw 'No address saved';
      }

      final address = AddressModel.fromJson(jsonDecode(addressStr));
      final zoneId = address.zoneId;

      if (zoneId == null || zoneId.trim().isEmpty) {
        print('[Location Check] Invalid or missing zoneId->${zoneId}.');
        throw 'Invalid zoneId';
      }

      return true;
    } catch (_) {
      showCustomSnackbar(
        title: 'Warning',
        message: 'Please select your area from profile settings to proceed.',
        type: SnackbarType.warning,
        position: SnackPosition.TOP,
        mainButton: TextButton(
          onPressed: () {
            Get.back();
            Get.toNamed(RouteHelper.getAddAddressRoute(true));
          },
          child: const Text(
            'Add Address',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  Future<void> fetchAutoCareVariants() async {
    print('[AutoCare] Fetching variants...');
    final zoneId = await _getZoneId();

    if (zoneId == null || zoneId.trim().isEmpty) {
      print('[AutoCare] ❌ ZoneId missing');
      showCustomSnackbar(
        title: 'Warning',
        message: 'Please set your location to see available packages.',
        type: SnackbarType.warning,
        position: SnackPosition.TOP,
      );
      return;
    }

    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}${AppConstants.getAutoCareVariantByServiceUrl(widget.serviceId, zoneId)}',
      );
      print('[AutoCare] Request → $url');

      final response = await http.get(url);
      print('[AutoCare] Status → ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = data['data'] as List?;
        if (items == null || items.isEmpty) {
          showCustomSnackbar(
            title: 'Notice',
            message: 'No packages available in your area.',
            type: SnackbarType.info,
            position: SnackPosition.BOTTOM,
          );
          return;
        }

        setState(() {
          autoCarePackages.assignAll(
            items.map((e) => ServicePackage.fromJson(e)).toList(),
          );
          selectedVariants.clear();
          for (int i = 0; i < autoCarePackages.length; i++) {
            if (autoCarePackages[i].variantOptions.isNotEmpty) {
              selectedVariants[i] = autoCarePackages[i].variantOptions.first;
            }
          }
        });

        print('[AutoCare] ✅ Loaded ${autoCarePackages.length} packages');
      } else {
        print('[AutoCare] ❌ Server Error: ${response.statusCode}');
        showCustomSnackbar(
          title: 'Error',
          message: 'Failed to fetch packages. Try again later.',
          type: SnackbarType.error,
          position: SnackPosition.BOTTOM,
        );
      }
    } catch (e, stack) {
      print('[AutoCare] Exception: $e\n$stack');
      showCustomSnackbar(
        title: 'Error',
        message: 'Something went wrong while fetching packages.',
        type: SnackbarType.error,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> fetchVehicleData() async {
    try {
      final authController = Get.find<AuthController>();
      final token = authController.getUserToken();
      if (token == null || token.isEmpty) {
        print('[Vehicle] Missing token');
        return;
      }

      final url = Uri.parse(
        'https://madadservices.com/api/v1/customer/service/vehicles',
      );
      print('[Vehicle] Fetching → $url');

      final request = http.Request('GET', url);
      request.headers['Authorization'] = 'Bearer $token';
      final response = await request.send();

      final body = await response.stream.bytesToString();
      print('[Vehicle] Status: ${response.statusCode}, Body: $body');

      if (response.statusCode == 200) {
        final data = jsonDecode(body);
        if (data['data'] is List) {
          vehicleController.vehicleList.assignAll(
            (data['data'] as List)
                .map((e) => VehicleModel.fromJson(e))
                .toList(),
          );
        } else if (data['data'] is Map) {
          vehicleController.vehicleList.assignAll([
            VehicleModel.fromJson(data['data']),
          ]);
        }
      } else {
        showCustomSnackbar(
          title: 'Error',
          message: 'Failed to fetch vehicles (${response.statusCode}).',
          type: SnackbarType.error,
        );
      }
    } catch (e, stack) {
      print('[Vehicle] Exception: $e\n$stack');
      showCustomSnackbar(
        title: 'Error',
        message: 'Unable to load vehicle data.',
        type: SnackbarType.error,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  void _onTypeChanged(String? typeName) async {
    if (!(await _checkLocation())) return;
    selectedType.value = typeName ?? '';

    if (typeName != null && widget.serviceId.isNotEmpty) {
      final typeObj = vehicleController.typeList.firstWhere(
        (t) => t['vehicle_name'] == typeName,
        orElse: () => <String, dynamic>{},
      );
      final typeId = typeObj['id']?.toString() ?? '';

      vehicleController.selectedVehicle.value = VehicleModel(
        id: _uuid.v4(),
        userId: _uuid.v4(),
        brand: _brandController.text,
        type: typeId,
        model: _modelController.text,
        color: colorController.text,
        contact_no: contactController.text,
        additional_details: _additionalDetailsController.text,
        vehicleNo: numberController.text,
      );

      final zoneId = await _getZoneId();
      if (widget.categoryId != '274ceb96-647d-4fd5-8f66-c813fc2d51d6') {
        if (zoneId != null && zoneId.isNotEmpty) {
          variantController.fetchVariants(
            widget.serviceId,
            typeId,
            zoneId: zoneId,
          );
          selectedVariants.clear();
        }
      } else {
        await fetchAutoCareVariants();
        selectedVariants.clear();
      }
    }
  }

  void onVehicleTypeSelected(String? newValue) async {
    if (newValue == null) return;
    selectedType.value = newValue;
    await fetchAutoCareVariants();
  }

  // Future<String?> _getZoneId() async {
  //   try {
  //     final locationController = Get.find<LocationController>();
  //     final addresses = locationController.addressList;

  //     if (addresses == null || addresses.isEmpty) {
  //       print('[Zone Tracking] No addresses available in address list.');
  //       return null;
  //     }

  //     print('[Zone Tracking] Address list (${addresses.length} items):');
  //     for (int i = 0; i < addresses.length; i++) {
  //       final address = addresses[i];
  //       print(
  //         '  [$i] zoneId: ${address.zoneId}, full address: ${address.toString()}',
  //       );
  //     }

  //     const maxChecks = 7;
  //     for (int i = 0; i < addresses.length && i < maxChecks; i++) {
  //       final zoneId = addresses[i].zoneId;
  //       if (zoneId != null && zoneId.trim().isNotEmpty) {
  //         print('Zone Final zoneId (from index $i): $zoneId');
  //         return zoneId;
  //       } else {
  //         print('ZoneId at index $i is null or empty.');
  //       }
  //     }

  //     print('No valid zoneId found in first $maxChecks addresses.');
  //     return null;
  //   } catch (e, stack) {
  //     print('Zone ERROR: $e');
  //     print('Stack trace: $stack');
  //     return null;
  //   }
  // }

  // Future<bool> _checkLocation() async {
  //   final sharedPreferences = Get.find<SharedPreferences>();
  //   final zoneId = AddressModel.fromJson(
  //     jsonDecode(sharedPreferences.getString(AppConstants.userAddress)!),
  //   ).zoneId;

  //   if (zoneId == null || zoneId.trim().isEmpty) {
  //     print('[Location Check] Invalid or missing zoneId.');

  //     showCustomSnackbar(
  //       title: 'Warning',
  //       message: 'Please select your area from profile settings to proceed.',
  //       type: SnackbarType.warning,
  //       position: SnackPosition.TOP,
  //       mainButton: TextButton(
  //         onPressed: () {
  //           Get.back(); // Close the snackbar
  //           Get.toNamed(RouteHelper.getAddAddressRoute(true));
  //         },
  //         child: const Text(
  //           'Add Address',
  //           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       duration: const Duration(seconds: 2),
  //     );

  //     return false;
  //   }

  //   return true;
  // }

  // Future<void> fetchAutoCareVariants() async {
  //   print(' [Debug] Starting fetchAutoCareVariants...');

  //   final zoneId = await _getZoneId();
  //   if (zoneId == null || zoneId.trim().isEmpty) {
  //     print('zoneId is null or empty in fetchAutoCareVariants');

  //     return;
  //   }

  //   try {
  //     final url = Uri.parse(
  //       '${AppConstants.baseUrl}${AppConstants.getAutoCareVariantByServiceUrl(widget.serviceId, zoneId)}',
  //     );
  //     print(' Requesting URL: $url');

  //     final response = await http.get(url);
  //     print(' Response status: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print(' Response data keys: ${data.keys}');

  //       if (data['data'] != null && data['data'] is List) {
  //         final List<dynamic> dataList = data['data'] as List;
  //         print(' Found ${dataList.length} packages');

  //         setState(() {
  //           autoCarePackages.assignAll(
  //             dataList.map((item) => ServicePackage.fromJson(item)).toList(),
  //           );
  //           selectedVariants.clear();
  //           for (int i = 0; i < autoCarePackages.length; i++) {
  //             if (autoCarePackages[i].variantOptions.isNotEmpty) {
  //               selectedVariants[i] = autoCarePackages[i].variantOptions.first;
  //             }
  //           }
  //         });

  //         print(' Successfully loaded ${autoCarePackages.length} packages');
  //       } else {
  //         print(' No data found in response or data is not a list');
  //         showCustomSnackbar(
  //           title: 'Notice',
  //           message: 'No service packages found in your area.',
  //           type: SnackbarType
  //               .info, // automatically sets blue background and info icon
  //           position: SnackPosition.BOTTOM,
  //           duration: const Duration(seconds: 2),
  //         );
  //       }
  //     } else {
  //       print(' HTTP Error: ${response.statusCode}');
  //       print(' Response body: ${response.body}');
  //       showCustomSnackbar(
  //         title: 'Server Error',
  //         message: 'Failed to fetch service packages. Please try again later.',
  //         type: SnackbarType
  //             .error, // sets red background and error icon automatically
  //         position: SnackPosition.BOTTOM,
  //         duration: const Duration(seconds: 2),
  //       );
  //     }
  //   } catch (e, stack) {
  //     print(' Exception during fetch: $e');
  //     print(' Stack trace: $stack');
  //     showCustomSnackbar(
  //       title: 'Error',
  //       message:
  //           'Something went wrong while fetching packages. Please try again.',
  //       type: SnackbarType
  //           .error, // automatically sets red background and error icon
  //       position: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 2),
  //     );
  //   }
  // }

  // Future<void> fetchVehicleData() async {
  //   final authController = Get.find<AuthController>();
  //   final token = authController.getUserToken();

  //   if (token == null || token.isEmpty) return;

  //   try {
  //     var url = Uri.parse(
  //       'https://madadservices.com/api/v1/customer/service/vehicles',
  //     );
  //     print('Fetching vehicle data from URL: $url');

  //     var request = http.Request('GET', url);
  //     request.headers['Authorization'] = 'Bearer $token';

  //     http.StreamedResponse response = await request.send();
  //     print('HTTP Status Code: ${response.statusCode}');

  //     String responseBody = await response.stream.bytesToString();
  //     print('Raw Response Body: $responseBody');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(responseBody);
  //       print('Decoded JSON Response: $data');

  //       if (data['data'] != null) {
  //         if (data['data'] is List) {
  //           List<VehicleModel> vehicles = (data['data'] as List)
  //               .map((item) => VehicleModel.fromJson(item))
  //               .toList();
  //           print('Parsed Vehicle List: $vehicles');
  //           vehicleController.vehicleList.assignAll(vehicles);
  //         } else if (data['data'] is Map) {
  //           VehicleModel vehicle = VehicleModel.fromJson(data['data']);
  //           print('Parsed Single Vehicle: $vehicle');
  //           vehicleController.vehicleList.assignAll([vehicle]);
  //         }
  //       }
  //     } else {
  //       print('Vehicle API Error: ${response.statusCode}');
  //       Get.snackbar(
  //         'Error',
  //         'Failed to fetch vehicles: ${response.statusCode}',
  //       );
  //     }
  //   } catch (e) {
  //     print('Vehicle API Exception: $e');
  //     showCustomSnackbar(
  //       title: 'Error',
  //       message: 'Failed to fetch vehicles: $e',
  //       type: SnackbarType.error, // sets red background and error icon
  //       position: SnackPosition.BOTTOM,
  //       duration: const Duration(seconds: 2),
  //     );
  //   }
  // }

  // void _onTypeChanged(String? typeName) async {
  //   final hasLocation = await _checkLocation();
  //   if (!hasLocation) return;

  //   selectedType.value = typeName ?? '';

  //   if (typeName != null &&
  //       typeName.isNotEmpty &&
  //       widget.serviceId.isNotEmpty) {
  //     final selectedTypeObj = vehicleController.typeList.firstWhere(
  //       (type) => type['vehicle_name'] == typeName,
  //       orElse: () => <String, dynamic>{},
  //     );
  //     final typeId = selectedTypeObj['id']?.toString() ?? '';

  //     vehicleController.selectedVehicle.value = VehicleModel(
  //       id: _uuid.v4(),
  //       userId: _uuid.v4(),
  //       brand: _brandController.text,
  //       type: typeId,
  //       model: _modelController.text,
  //       color: colorController.text,
  //       contact_no: contactController.text,
  //       additional_details: _additionalDetailsController.text,
  //       vehicleNo: numberController.text,
  //     );

  //     if (widget.categoryId != '274ceb96-647d-4fd5-8f66-c813fc2d51d6') {
  //       final zoneId = await _getZoneId();
  //       if (zoneId != null && zoneId.isNotEmpty) {
  //         variantController.fetchVariants(
  //           widget.serviceId,
  //           typeId,
  //           zoneId: zoneId,
  //         );
  //         selectedVariants.clear();
  //       }
  //     } else {
  //       await fetchAutoCareVariants();
  //       selectedVariants.clear();
  //     }
  //   }
  // }

  // void onVehicleTypeSelected(String? newValue) async {
  //   if (newValue == null) return;
  //   selectedType.value = newValue;
  //   await fetchAutoCareVariants();
  // }

  String? validateMobileNumber(String? value, String countryCode) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Only digits are allowed';
    }

    int requiredLength;
    switch (countryCode) {
      case '+91': // India
        requiredLength = 10;
        break;
      case '+968': // Oman
        requiredLength = 8;
        break;
      default:
        requiredLength = 6; // fallback or set as needed
    }

    if (value.length != requiredLength) {
      return 'Mobile number must be $requiredLength digits';
    }
    return null;
  }

  String? validateAdditionalDetails(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter additional details';
    }
    return null;
  }

  void clearFormControllers() {
    _brandController.clear();
    _modelController.clear();
    colorController.clear();
    numberController.clear();
    contactController.clear();
    _additionalDetailsController.clear();
    selectedType.value = '';
  }

  Future<void> _addToCartWithController() async {
    final hasLocation = await _checkLocation();
    if (!hasLocation) return;

    final isManualCategory =
        widget.categoryId == '274ceb96-647d-4fd5-8f66-c813fc2d51d6';
    final isMobileOnlyCategory =
        widget.categoryId == '226716a4-0eb4-43bb-9078-5b4a08db5849';

    final fullContactNo =
        '${selectedCountryCode.value}${contactController.text.trim()}';

    if (!vehicleFormKey.currentState!.validate()) return;

    ServiceVariantModel? selectedVariant = selectedVariants.values.firstWhere(
      (v) => v != null,
      orElse: () => null,
    );

    if (selectedVariant == null ||
        selectedVariants.isEmpty ||
        selectedPackageIndex == null) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Please select a package variant',
        type: SnackbarType
            .error, // sets red background and error icon automatically
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      //Get.snackbar('Error', 'Please select a package variant');
      return;
    }

    VehicleModel? vehicleToSave;

    if (!isMobileOnlyCategory) {
      if (selectedOption.value == 'new') {
        final selectedTypeObj = vehicleController.typeList.firstWhere(
          (type) => type['vehicle_name'] == selectedType.value,
          orElse: () => <String, dynamic>{},
        );
        final typeId = selectedTypeObj['id']?.toString() ?? '';

        vehicleToSave = VehicleModel(
          id: _uuid.v4(),
          userId: _userId,
          brand: _brandController.text,
          type: typeId,
          model: _modelController.text,
          color: colorController.text,
          vehicleNo: numberController.text,
          contact_no: fullContactNo,
          additional_details: _additionalDetailsController.text,
        );
      } else if (selectedOption.value == 'existing') {
        if (vehicleController.selectedExistingVehicle.value == null) {
          showCustomSnackbar(
            title: 'Info',
            message: 'Please select an existing vehicle from the list.',
            type: SnackbarType
                .info, // automatically sets blue background and info icon
            position: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );

          final existingVehicle =
              vehicleController.selectedExistingVehicle.value!;
          vehicleToSave = VehicleModel(
            id: existingVehicle.id,
            userId: _userId,
            brand: existingVehicle.brand,
            type: existingVehicle.type,
            model: existingVehicle.model,
            color: existingVehicle.color,
            vehicleNo: existingVehicle.vehicleNo,
            contact_no: fullContactNo,
            additional_details: _additionalDetailsController.text,
          );
        }
      }
    }

    final authToken = Get.find<AuthController>().getUserToken();
    if (authToken == null || authToken.isEmpty) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Authentication token is missing',
        type: SnackbarType.error, // sets red background and error icon
        position: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      return;
    }

    if (vehicleToSave != null && selectedOption.value == 'new') {
      try {
        if (vehicleToSave.type == null || vehicleToSave.type!.isEmpty) {
          final selectedTypeObj = vehicleController.typeList.firstWhere(
            (type) => type['vehicle_name'] == selectedType.value,
            orElse: () => <String, dynamic>{},
          );
          vehicleToSave.type = selectedTypeObj['id']?.toString() ?? '';
        }

        print('Saving vehicle with data: ${vehicleToSave.toJson()}');
        await VehicleService.saveVehicle(vehicleToSave, token: authToken);
        await vehicleController.fetchUserVehicles();
      } catch (e) {
        print('Error saving vehicle: $e');
        showCustomSnackbar(
          title: 'Error',
          message: 'Failed to save vehicle: $e',
          type: SnackbarType
              .error, // automatically sets red background and error icon
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );

        // Get.snackbar('Error', 'Failed to save vehicle: $e');
        return;
      }
    }

    final cartModelBody = CartModelBody(
      serviceId: widget.serviceId,
      categoryId: widget.categoryId,
      subCategoryId: widget.subCategoryId,
      variantKey: selectedVariant.variantKey,
      quantity: '1',
      guestId: Get.find<SplashController>().getGuestId(),
      contact_no: fullContactNo,
      additional_details: _additionalDetailsController.text,
    );

    try {
      // print('Attempting to add to cart...');
      final response = await Get.find<CartController>().cartRepo
          .addToCartListToServer(cartModelBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body to check for actual success
        dynamic responseData;
        try {
          responseData = response.body is String
              ? jsonDecode(response.body)
              : response.body;
        } catch (e) {
          print('Error parsing response: $e');
          responseData = response.body;
        }

        // Check if the API actually succeeded
        if (responseData is Map &&
            responseData['response_code'] != null &&
            responseData['response_code'] != 'default_200' &&
            responseData['response_code'] != '200' &&
            responseData['response_code'].toString().contains('404')) {
          // print('API returned error: ${responseData['message']}');
          showCustomSnackbar(
            title: 'Error',
            message:
                responseData['message'] ?? 'Service not available in your area',
            type: SnackbarType
                .error, // automatically sets red background and error icon
            position: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );

          return;
        }

        // print('Successfully added to cart');

        // Set manual fare for special categories
        if (isManualCategory || isMobileOnlyCategory) {
          final cartController = Get.find<CartController>();
          cartController.manualFareForManualCategory =
              selectedVariant.price ?? 0.0;
          // print('Set manualFareForManualCategory to: ${selectedVariant.price}');
        }

        // print('Navigating to CheckoutScreen...');

        final checkoutController = Get.find<CheckOutController>();
        final cartController = Get.find<CartController>();
        final scheduleController = Get.find<ScheduleController>();
        final locationController = Get.find<LocationController>();
        final couponController = Get.find<CouponController>();

        // Reset tab/page
        checkoutController.updateState(
          PageState.orderDetails,
          shouldUpdate: false,
        );

        // Load all required data
        await cartController.getCartListFromServer(shouldUpdate: false);
        await checkoutController.getOfflinePaymentMethod(true);
        scheduleController.resetScheduleData(shouldUpdate: false);
        scheduleController.resetSchedule();
        locationController.updateSelectedServiceLocationType();
        await couponController.getCouponList();

        // Now navigate
        Get.to(() => const CheckoutScreen('orderDetails', 'addressId'));
        //  to checkout screen
        // Get.to(() => CheckoutScreen('orderDetails', 'addressId'));

        // print('Navigation completed');
      } else {
        // print('Failed to add to cart - Status: ${response.statusCode}');
        // print('Response body: ${response.body}');
        showCustomSnackbar(
          title: 'Error',
          message:
              'Failed to add to cart: ${response.statusText ?? 'Unknown error'}',
          type: SnackbarType
              .error, // automatically sets red background and error icon
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // print('Exception while adding to cart: $e');
      // print('Exception type: ${e.runtimeType}');
      showCustomSnackbar(
        title: 'Error',
        message: 'Unexpected error: $e',
        type: SnackbarType
            .error, // automatically sets red background and error icon
        position: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Widget _buildCarWashFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Option",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Obx(
            () => Column(
              children: [
                RadioListTile<String>(
                  title: const Text("Existing Vehicle"),
                  value: 'existing',
                  groupValue: selectedOption.value,
                  onChanged: (value) {
                    selectedOption.value = value!;
                    vehicleController.clearSelectedExistingVehicle();
                    clearFormControllers();
                    fetchVehicleData();
                  },
                ),
                RadioListTile<String>(
                  title: const Text("New Vehicle"),
                  value: 'new',
                  groupValue: selectedOption.value,
                  onChanged: (value) {
                    selectedOption.value = value!;
                    vehicleController.clearSelectedExistingVehicle();
                    clearFormControllers();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final isNew = selectedOption.value == 'new';
            final isExistingAndSelected =
                selectedOption.value == 'existing' &&
                vehicleController.selectedExistingVehicle.value != null;
            print(
              'CarWashFlow: Rendering vehicle section - isNew: $isNew, isExistingAndSelected: $isExistingAndSelected, '
              'isLoading: ${vehicleController.isLoading.value}, vehicleList length: ${vehicleController.vehicleList.length}, '
              'selectedExistingVehicle: ${vehicleController.selectedExistingVehicle.value?.id ?? "none"}',
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNew)
                  Form(
                    key: vehicleFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _brandController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Brand",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Brand'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Vehicle Type",
                            ),
                            value:
                                vehicleController.typeList.any(
                                  (type) =>
                                      type['vehicle_name'] ==
                                      selectedType.value,
                                )
                                ? selectedType.value
                                : null,
                            items: vehicleController.typeList
                                .map<DropdownMenuItem<String>>((typeObj) {
                                  final name =
                                      typeObj['vehicle_name'] as String;
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name),
                                  );
                                })
                                .toSet()
                                .toList(),
                            onChanged: _onTypeChanged,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select a type'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _modelController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Model",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Model'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: numberController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle No",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Vehicle No'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: colorController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Color",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Color'
                              : null,
                        ),
                      ],
                    ),
                  )
                else
                  Form(
                    key: vehicleFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Vehicles",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          if (vehicleController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (vehicleController.vehicleList.isEmpty) {}

                          final selectedVehicle =
                              vehicleController.selectedExistingVehicle.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (vehicleController.vehicleList.isEmpty) {
                                    showCustomSnackbar(
                                      title: 'No Vehicles Found',
                                      message:
                                          'You have no existing vehicles. Please add a vehicle first.',
                                      type: SnackbarType
                                          .error, // automatically sets red color and error icon
                                      duration: const Duration(seconds: 2),
                                      position: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 350,
                                          child: ListView.builder(
                                            itemCount: vehicleController
                                                .vehicleList
                                                .length,
                                            itemBuilder: (context, index) {
                                              final vehicle = vehicleController
                                                  .vehicleList[index];
                                              final isSelected =
                                                  selectedVehicle?.id ==
                                                  vehicle.id;
                                              return _buildVehicleCard(
                                                vehicle,
                                                isSelected: isSelected,
                                                onSelect: () async {
                                                  vehicleController
                                                      .setSelectedExistingVehicle(
                                                        vehicle,
                                                      );
                                                  _handleExistingVehicleSelection(
                                                    vehicle,
                                                  );
                                                  Navigator.of(context).pop();

                                                  final prefs =
                                                      await SharedPreferences.getInstance();
                                                  await prefs.setString(
                                                    'selected_vehicle_id',
                                                    vehicle.id.toString(),
                                                  );

                                                  print(
                                                    "Selected Vehicle ID stored in CarWashFlow: ${vehicle.id}",
                                                  );

                                                  if (widget.categoryId !=
                                                      '274ceb96-647d-4fd5-8f66-c813fc2d51d6') {
                                                    final zoneId =
                                                        await _getZoneId();
                                                    if (zoneId != null &&
                                                        zoneId.isNotEmpty) {
                                                      variantController
                                                          .fetchVariants(
                                                            widget.serviceId,
                                                            vehicle.type ?? '',
                                                            zoneId: zoneId,
                                                          );
                                                      selectedVariants.clear();
                                                    }
                                                  } else {
                                                    await fetchAutoCareVariants();
                                                    selectedVariants.clear();
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: "Select Existing Vehicle",
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                    readOnly: true,
                                    validator: (value) =>
                                        selectedVehicle == null
                                        ? 'Please select a vehicle'
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (selectedVehicle != null)
                                _buildVehicleCard(
                                  selectedVehicle,
                                  isSelected: true,
                                  onSelect: () {},
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Obx(() {
                  if (selectedOption.value == 'existing' &&
                      vehicleController.selectedExistingVehicle.value == null) {
                    return const Text(
                      'Please select a vehicle to see packages',
                    );
                  }
                  if (selectedOption.value == 'new' &&
                      selectedType.value.isEmpty) {
                    return const Text('Select vehicle type to see packages');
                  }
                  if (widget.categoryId ==
                      '274ceb96-647d-4fd5-8f66-c813fc2d51d6') {
                    if (autoCarePackages.isEmpty) {
                      return const Text('No packages available');
                    }
                    return Column(
                      children: autoCarePackages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final package = entry.value;
                        return _buildFancyPackageCard(
                          package: package,
                          packageIndex: index,
                          bubbleColor: index == 0
                              ? Colors.purple
                              : Colors.amber,
                          bgColor: Colors.white,
                          icon: index == 0
                              ? Icons.shield_outlined
                              : Icons.star_rate,
                        );
                      }).toList(),
                    );
                  } else {
                    final response =
                        variantController.serviceVariantResponse.value;
                    if (variantController.isLoading.value) {
                      return const CircularProgressIndicator();
                    }
                    if (response == null || response.data.isEmpty) {
                      return const Text('No packages available');
                    }
                    return Column(
                      children: response.data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final package = entry.value;
                        return _buildFancyPackageCard(
                          package: ServicePackage(
                            packageName: package.packageName,
                            variantOptions: package.variantOptions,
                            description: package.description,
                          ),
                          packageIndex: index,
                          bubbleColor: index == 0
                              ? Colors.purple
                              : Colors.amber,
                          bgColor: Colors.white,
                          icon: index == 0
                              ? Icons.shield_outlined
                              : Icons.star_rate,
                        );
                      }).toList(),
                    );
                  }
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildManualCategoryFlow() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Option",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Obx(
            () => Column(
              children: [
                RadioListTile<String>(
                  title: const Text("Existing Vehicle"),
                  value: 'existing',
                  groupValue: selectedOption.value,
                  onChanged: (value) {
                    selectedOption.value = value!;
                    vehicleController.clearSelectedExistingVehicle();
                    clearFormControllers();
                    fetchVehicleData();
                  },
                ),
                RadioListTile<String>(
                  title: const Text("New Vehicle"),
                  value: 'new',
                  groupValue: selectedOption.value,
                  onChanged: (value) {
                    selectedOption.value = value!;
                    vehicleController.clearSelectedExistingVehicle();
                    clearFormControllers();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final isNew = selectedOption.value == 'new';
            final isExistingAndSelected =
                selectedOption.value == 'existing' &&
                vehicleController.selectedExistingVehicle.value != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNew)
                  Form(
                    key: vehicleFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _brandController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Brand",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Brand'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: "Vehicle Type",
                            ),
                            value:
                                vehicleController.typeList.any(
                                  (type) =>
                                      type['vehicle_name'] ==
                                      selectedType.value,
                                )
                                ? selectedType.value
                                : null,
                            items: vehicleController.typeList
                                .map<DropdownMenuItem<String>>((typeObj) {
                                  final name =
                                      typeObj['vehicle_name'] as String;
                                  return DropdownMenuItem<String>(
                                    value: name,
                                    child: Text(name),
                                  );
                                })
                                .toSet()
                                .toList(),
                            onChanged: _onTypeChanged,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select a type'
                                : null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _modelController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Model",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Model'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: numberController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle No",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Vehicle No'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: colorController,
                          decoration: const InputDecoration(
                            labelText: "Vehicle Color",
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter Color'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          title: 'Contact Details',
                          hintText: 'Enter your mobile number',
                          controller: contactController,
                          inputType: TextInputType.phone,
                          countryDialCode: selectedCountryCode.value,
                          onCountryChanged: (countryCode) {
                            selectedCountryCode.value = countryCode.dialCode!;
                          },
                          onValidate: (value) => validateMobileNumber(
                            value,
                            selectedCountryCode.value,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _additionalDetailsController,
                          decoration: const InputDecoration(
                            labelText: 'Additional Details *',
                            hintText: "Enter Service Related Info",
                            border: OutlineInputBorder(),
                          ),
                          validator: validateAdditionalDetails,
                        ),
                      ],
                    ),
                  )
                else
                  Form(
                    key: vehicleFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Vehicles",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Obx(() {
                          final selectedVehicle =
                              vehicleController.selectedExistingVehicle.value;
                          if (vehicleController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (vehicleController.vehicleList.isEmpty) {}

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  // await Future.delayed(
                                  //     const Duration(seconds: 4));
                                  if (vehicleController.vehicleList.isEmpty) {
                                    showCustomSnackbar(
                                      title: 'No Vehicles Found',
                                      message:
                                          'You have no existing vehicles. Please add a vehicle first.',
                                      type: SnackbarType
                                          .error, // automatically sets red background and error icon
                                      position: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 2),
                                    );
                                  } else {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 350,
                                          child: ListView.builder(
                                            itemCount: vehicleController
                                                .vehicleList
                                                .length,
                                            itemBuilder: (context, index) {
                                              final vehicle = vehicleController
                                                  .vehicleList[index];
                                              final isSelected =
                                                  selectedVehicle?.id ==
                                                  vehicle.id;
                                              return _buildVehicleCard(
                                                vehicle,
                                                isSelected: isSelected,
                                                onSelect: () async {
                                                  vehicleController
                                                      .setSelectedExistingVehicle(
                                                        vehicle,
                                                      );
                                                  _handleExistingVehicleSelection(
                                                    vehicle,
                                                  );
                                                  Navigator.of(context).pop();

                                                  print(
                                                    "Selected Vehicle ID ManualCategoryFlow: ${vehicle.id}",
                                                  );

                                                  SharedPreferences prefs =
                                                      await SharedPreferences.getInstance();
                                                  await prefs.setString(
                                                    'selected_vehicle_id',
                                                    vehicle.id.toString(),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: "Select Existing Vehicle",
                                      suffixIcon: Icon(Icons.arrow_drop_down),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (selectedVehicle != null)
                                _buildVehicleCard(
                                  selectedVehicle,
                                  isSelected: true,
                                  onSelect: () {},
                                ),
                            ],
                          );
                        }),
                        CustomTextField(
                          title: 'Contact Details',
                          hintText: 'Enter your mobile number',
                          controller: contactController,
                          inputType: TextInputType.phone,
                          countryDialCode: selectedCountryCode.value,
                          onCountryChanged: (countryCode) {
                            selectedCountryCode.value = countryCode.dialCode!;
                          },
                          onValidate: (value) => validateMobileNumber(
                            value,
                            selectedCountryCode.value,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _additionalDetailsController,
                          decoration: const InputDecoration(
                            labelText: "Additional Details ",
                            hintText: "Enter Service Related Info",
                          ),
                          validator: validateAdditionalDetails,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Obx(() {
                  if (selectedType.value.isEmpty) {
                    return const Text('Select vehicle type to see packages');
                  }
                  if (autoCarePackages.isEmpty) {
                    return const Text('No packages available');
                  }
                  return Column(
                    children: autoCarePackages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final package = entry.value;
                      return _buildFancyPackageCard(
                        package: package,
                        packageIndex: index,
                        bubbleColor: index == 0 ? Colors.purple : Colors.amber,
                        bgColor: Colors.white,
                        icon: index == 0
                            ? Icons.shield_outlined
                            : Icons.star_rate,
                      );
                    }).toList(),
                  );
                }),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileAndAdditionalDetailsOnly() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<void>(
        future: _autoCareFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error loading packages');
          }

          // Initialize variants only once when packages are loaded
          if (!_hasFetchedVariants && autoCarePackages.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedVariants.clear();
                for (int i = 0; i < autoCarePackages.length; i++) {
                  if (autoCarePackages[i].variantOptions.isNotEmpty) {
                    selectedVariants[i] =
                        autoCarePackages[i].variantOptions.first;
                  }
                }
                _hasFetchedVariants = true;
              });
            });
          }

          return Form(
            key: vehicleFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mobile Number",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => CustomTextField(
                    title: 'Contact Details',
                    hintText: 'Enter your mobile number',
                    controller: contactController,
                    inputType: TextInputType.phone,
                    countryDialCode: selectedCountryCode.value,
                    onCountryChanged: (countryCode) {
                      selectedCountryCode.value = countryCode.dialCode!;
                    },
                    onValidate: (value) =>
                        validateMobileNumber(value, selectedCountryCode.value),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Additional Details",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _additionalDetailsController,
                  decoration: const InputDecoration(
                    labelText: "Additional Details ",
                    hintText: "Enter service related info",
                  ),
                  validator: validateAdditionalDetails,
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (autoCarePackages.isEmpty) {
                    return const Text('No packages available');
                  }
                  return Column(
                    children: autoCarePackages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final package = entry.value;
                      return _buildFancyPackageCard(
                        package: package,
                        packageIndex: index,
                        bubbleColor: index == 0 ? Colors.purple : Colors.amber,
                        bgColor: Colors.white,
                        icon: index == 0
                            ? Icons.shield_outlined
                            : Icons.star_rate,
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  String TypeName(String? typeId) {
    if (typeId == null) return 'Unknown';
    final typeObj = vehicleController.typeList.firstWhere(
      (type) => type['id'] == typeId,
      orElse: () => <String, dynamic>{'vehicle_name': 'Unknown'},
    );
    return typeObj['vehicle_name'] as String;
  }

  void _handleExistingVehicleSelection(VehicleModel vehicle) {
    if (vehicle.type != null && vehicle.type!.isNotEmpty) {
      selectedType.value = TypeName(vehicle.type);
      onVehicleTypeSelected(selectedType.value);
    }
  }

  void _selectPackage(int packageIndex, ServicePackage package) {
    print(
      '***/////////////// Selecting package for packageIndex: $packageIndex ***',
    );
    setState(() {
      print(
        '**Before clear in selectPackage: selectedVariants = $selectedVariants ***',
      );
      selectedPackageIndex = packageIndex;
      selectedVariants.clear();
      print(
        '*** DEBUG: After clear in selectPackage: selectedVariants = $selectedVariants ***',
      );
      if (package.variantOptions.isNotEmpty) {
        selectedVariants[packageIndex] = package.variantOptions.first;
        print(
          '***  After setting variant in selectPackage: selectedVariants = $selectedVariants ***',
        );
      }
    });
  }

  Widget _buildFancyPackageCard({
    required ServicePackage package,
    required int packageIndex,
    required Color bubbleColor,
    required Color bgColor,
    required IconData icon,
    bool isInitiallySelected = false,
  }) {
    final isSelected = selectedPackageIndex == packageIndex;
    final selectedVariant = selectedVariants[packageIndex];

    return GestureDetector(
      onTap: () {
        print('*** DEBUG: Package $packageIndex tapped ***');
        setState(() {
          selectedPackageIndex = packageIndex;
          selectedVariants.clear();

          if (package.variantOptions.isNotEmpty) {
            selectedVariants[packageIndex] = package.variantOptions.first;
          }
        });
        print(
          '*** DEBUG: Selected package: $packageIndex, variants: $selectedVariants ***',
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: bubbleColor, width: 3)
              : Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? bubbleColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: isSelected ? 20 : 12,
              offset: const Offset(0, 4),
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and package name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: bubbleColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.packageName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSelected ? bubbleColor : Colors.black87,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: bubbleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "SELECTED",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: bubbleColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? bubbleColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? bubbleColor : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),

            // Description section
            if (package.description != null &&
                package.description!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        package.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Variant selection section
            if (isSelected) ...[
              const SizedBox(height: 16),
              if (package.variantOptions.isNotEmpty) ...[
                Text(
                  "Select Variant:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: bubbleColor.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ServiceVariantModel>(
                      isExpanded: true,
                      value: package.variantOptions.contains(selectedVariant)
                          ? selectedVariant
                          : null,
                      hint: Text(
                        "Choose your variant",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                      icon: Icon(Icons.keyboard_arrow_down, color: bubbleColor),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      items: package.variantOptions.map((serviceVariant) {
                        return DropdownMenuItem<ServiceVariantModel>(
                          value: serviceVariant,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  serviceVariant.variant,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: bubbleColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "OMR ${serviceVariant.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bubbleColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedVariants[packageIndex] = value;
                          });
                          print(
                            '*** DEBUG: Variant changed for package $packageIndex: ${value.variant} ***',
                          );
                        }
                      },
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 16,
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "No variants available for this package",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String manualCategory1 = '274ceb96-647d-4fd5-8f66-c813fc2d51d6';
    const String mobileOnlyCategory = '226716a4-0eb4-43bb-9078-5b4a08db5849';

    if (widget.categoryId == mobileOnlyCategory) {
      return Scaffold(
        appBar: AppBar(title: const Text("Select Package")),
        body: _buildMobileAndAdditionalDetailsOnly(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _addToCartWithController,
            child: const Text("Book Now"),
          ),
        ),
      );
    }

    final bool isManualCategory = widget.categoryId == manualCategory1;
    final VehicleController vehicleController = Get.put(VehicleController());

    return Scaffold(
      appBar: AppBar(title: const Text("Select Vehicle & Package")),
      body: isManualCategory ? _buildManualCategoryFlow() : _buildCarWashFlow(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => ElevatedButton(
            onPressed: vehicleController.isBookingLoading.value
                ? null // disable when loading
                : () async {
                    vehicleController.isBookingLoading.value = true;
                    try {
                      await _addToCartWithController();
                    } finally {
                      vehicleController.isBookingLoading.value = false;
                    }
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: vehicleController.isBookingLoading.value
                  ? const SizedBox(
                      key: ValueKey('loader'),
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      key: ValueKey('text'),
                      "Book Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
