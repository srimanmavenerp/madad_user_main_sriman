// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import 'Autocare_service_model.dart';
//
// class AutoCareServiceController {
//   Future<AutoCareServiceModel?> fetchAutoCareService({
//     required String serviceId,
//     required String zoneId,
//   }) async {
//     final url = Uri.parse(
//       'https://madadservices.com/api/v1/customer/service/get-autocarevariant-by-service?service_id=$serviceId&zone_id=$zoneId',
//     );
//
//     try {
//       var request = http.Request('GET', url);
//       http.StreamedResponse response = await request.send();
//
//       if (response.statusCode == 200) {
//         final String responseBody = await response.stream.bytesToString();
//         final jsonData = json.decode(responseBody);
//         return AutoCareServiceModel.fromJson(jsonData);
//       } else {
//         print('Error: ${response.reasonPhrase}');
//         return null;
//       }
//     } catch (e) {
//       print('Exception occurred: $e');
//       return null;
//     }
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Autocare_service_model.dart';

class AutoCareServiceController {
  Future<AutoCareServiceModel?> fetchAutoCareService({
    required String serviceId,
    required String zoneId,
  }) async {
    final url = Uri.parse(
      'https://madadservices.com/api/v1/customer/service/get-autocarevariant-by-service'
          '?service_id=$serviceId&zone_id=$zoneId',

    );
    print('Fetching variants frommmmmmmmmmmmmmmm: $url');

    try {
      var request = http.Request('GET', url);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);
        return AutoCareServiceModel.fromJson(jsonData);
      } else {
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }
}