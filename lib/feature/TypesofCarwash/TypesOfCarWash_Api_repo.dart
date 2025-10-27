import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';
import 'typesof_carWash_model.dart';
import 'package:madaduser/feature/service/model/service_model.dart';
class TypesOfCarWashRepo {
  Future<TypesOfCarWash?> getServicesByCategory(String categoryId) async {
    final url = '${AppConstants.baseUrl}${AppConstants.getServicesByCategoryUrl(categoryId)}';
   // final url = 'https://madadservices.com/api/v1/customer/service/servicesbycategory/$categoryId';
    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return TypesOfCarWash.fromJson(json.decode(body));
    } else {
      throw Exception('Failed to load services: ${response.reasonPhrase}');
    }
  }
    Future<Service> getServiceById(String serviceId) async { // Changed return type to `Service`
    final url = '${AppConstants.baseUrl}${AppConstants.getServiceByIdUrl(serviceId)}';

    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send(); // Send the HTTP request

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final Map<String, dynamic> jsonBody = json.decode(body);

      // Parse the full API response into your ServiceModel
      final serviceModelResponse = ServiceModel.fromJson(jsonBody);

      // Check if the response was successful and contains content and serviceList
      if (serviceModelResponse.responseCode == '200' &&
          serviceModelResponse.content != null &&
          serviceModelResponse.content!.serviceList != null &&
          serviceModelResponse.content!.serviceList!.isNotEmpty) {
        // Return the first (and presumably only) Service object from the list
        return serviceModelResponse.content!.serviceList!.first;
      } else {
        // Handle cases where API returns 200 but content is not as expected
        throw Exception('API response successful, but service data not found or invalid. Message: ${serviceModelResponse.message}');
      }
    } else {
      // Handle non-200 HTTP status codes
      throw Exception('Failed to load service details for ID $serviceId: ${response.reasonPhrase}');
    }
  }
  
}
