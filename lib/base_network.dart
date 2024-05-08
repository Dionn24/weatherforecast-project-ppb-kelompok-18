// import 'dart:convert';
// import 'package:http/http.dart' as http;
// class BaseNetwork {
//   static final String baseUrl = "https://ibnux.github.io/BMKG-importer/cuaca";
//   static Future<Map<String, dynamic>> get(String partUrl) async {
//     final String fullUrl = baseUrl + "/" + partUrl;
//     debugPrint("BaseNetwork - fullUrl : $fullUrl");
//     final response = await http.get(Uri.parse(fullUrl));
//     debugPrint("BaseNetwork - response : ${response.body}");
//     return _processResponse(response);
//   }
//   static Future<Map<String, dynamic>> _processResponse(
//       http.Response response) async {
//     final body = response.body;
//     if (body.isNotEmpty) {
//       final jsonBody = json.decode(body);
//       return jsonBody;
//     } else {
//       print("processResponse error");
//       return {"error": true};
//     }
//   }
//   static void debugPrint(String value) {
//     print("[BASE_NETWORK] - $value");
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = "https://ibnux.github.io/BMKG-importer";

  static Future<List<dynamic>> get(String partUrl) async {
    final String fullUrl = "$baseUrl/$partUrl";
    final response = await http.get(Uri.parse(fullUrl));

    // if success get response
    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body) as List;
      return jsonBody;
    }

    return [];
  }
}