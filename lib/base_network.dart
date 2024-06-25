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