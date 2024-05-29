import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static final String baseUrl = "https://www.themealdb.com/api/json/v1/1/";
  static Future<Map<String, dynamic>> get(String partUrl) async {
    final String fullUrl = baseUrl + partUrl;
    debugPrint("BaseNetwork - fullUrl : $fullUrl");
    final response = await http.get(Uri.parse(fullUrl));
    debugPrint("BaseNetwork - response : ${response.body}");
    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> _processResponse(
      http.Response response) async {
    final body = response.body;
    if (body.isNotEmpty) {
      try {
        final jsonBody = json.decode(body);
        return jsonBody;
      } catch (e) {
        debugPrint("Failed to decode JSON: $e");
        return {"error": "Invalid JSON response"};
      }
    } else {
      print("processResponse error: Empty response body");
      return {"error": "Empty response body"};
    }
  }

  static void debugPrint(String value) {
    print("[BASE_NETWORK] - $value");
  }
}
