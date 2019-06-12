import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:nfresh/models/response_home.dart';

class ApiProvider {
  Client client = Client();
  final String baseUrl =
      "http://cloudart.com.au/projects/nfresh//index.php/api/data_v1";

  // Webservice call to fetch home page data
  Future<ResponseHome> fetchHomeData() async {
    print("entered");
    Map map = {'device_id': '123456789'};
    final response = await client.post("$baseUrl/homepage", body: map);
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ResponseHome.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('WOW: Failed to load home service');
    }
  }
}
