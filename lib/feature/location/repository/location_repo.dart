import 'package:get/get.dart';
import 'package:madaduser/utils/core_export.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getAllAddress() async {
    return await apiClient.getData("${AppConstants.addressUri}?limit=100&offset=1&guest_id=${Get.find<SplashController>().getGuestId()}");
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient.getData('${AppConstants.zoneUri}?lat=$lat&lng=$lng',headers: AppConstants.configHeader);
  }

  Future<Response> removeAddressByID(String id) async {
    return await apiClient.postData("${AppConstants.addressUri}/$id", {
      '_method': 'delete',
      'guest_id': Get.find<SplashController>().getGuestId()
    });
  }

  // Future<Response> addAddress(AddressModel addressModel) async {
  //   return await apiClient.postData("${AppConstants.addressUri}?guest_id=${Get.find<SplashController>().getGuestId()}", addressModel.toJson());
  // }


  Future<Response> addAddress(AddressModel addressModel) async {
    final guestId = Get.find<SplashController>().getGuestId();
    final String url = "${AppConstants.addressUri}?guest_id=$guestId";

    // Log the full request URL
    print(' Request URrrrrrrrrrrrrrrrL: ${AppConstants.addressUri}$url');

    // Log the request body
    print(' Request Body: ${addressModel.toJson()}');

    // Make the POST request
    final response = await apiClient.postData(url, addressModel.toJson());

    // Log the response
    print(' Response Status: ${response.statusCode}');
    print(' Response Body: ${response.body}');

    return response;
  }




  // Future<Response> updateAddress(AddressModel addressModel, String addressId) async {
  //   return await apiClient.putData('${AppConstants.addressUri}/$addressId?guest_id=${Get.find<SplashController>().getGuestId()}', addressModel.toJson());
  // }


  Future<Response> updateAddress(AddressModel addressModel, String addressId) async {
    final guestId = Get.find<SplashController>().getGuestId();
    final String url = '${AppConstants.addressUri}/$addressId?guest_id=$guestId';

    // Print the full request URL
    print(' Request URLllllll: ${AppConstants.addressUri}$url');

    // Print the request body
    print(' Request Body: ${addressModel.toJson()}');

    // Make the PUT request
    final response = await apiClient.putData(url, addressModel.toJson());

    // Print the full response
    print(' Response Status: ${response.statusCode}');
    print(' Response Body: ${response.body}');

    return response;
  }


  Future<bool> saveUserAddress(String address, String? zoneIDs) async {
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token), zoneIDs,
      sharedPreferences.getString(AppConstants.languageCode),
      sharedPreferences.getString(AppConstants.guestId)
    );
    return await sharedPreferences.setString(AppConstants.userAddress, address);
  }



  Future<Response> getAddressFromGeocode(LatLng? latLng) async {

    return await apiClient.getData('${AppConstants.geocodeUri}?lat=${latLng!.latitude}&lng=${latLng.longitude}',headers: AppConstants.configHeader);
  }

  String? getUserAddress() {
    return sharedPreferences.getString(AppConstants.userAddress);
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient.getData('${AppConstants.searchLocationUri}?search_text=$text');
  }

  Future<Response> getPlaceDetails(String placeID) async {
    return await apiClient.getData('${AppConstants.placeDetailsUri}?placeid=$placeID');
  }

  Future<Response> changePostServiceAddress(String postId, String addressId) async {
    return await apiClient.postData(AppConstants.updatePostInfo,{
      "_method":"put",
      "post_id":postId,
      "service_address_id": addressId
    });
  }

  Future<void>  setZoneContinue(String isContinue) async {
    await sharedPreferences.setString(AppConstants.isContinueZone, isContinue);
  }

  String getZoneContinue() {
    return sharedPreferences.getString(AppConstants.isContinueZone) ?? "";
  }

}
