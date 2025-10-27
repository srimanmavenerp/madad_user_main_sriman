import 'package:http/http.dart' as http;

void fetchVehicleData() async {
  var url = Uri.parse('https://madadservices.com/api/v1/customer/service/vehicles/c0a32cb6-a5f4-423b-a4c9-dc17f76fedc3');
  var request = http.Request('GET', url);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    print(responseBody);
  } else {
    print('Request failed with status: ${response.statusCode}');
    print('Reason: ${response.reasonPhrase}');
  }
}
