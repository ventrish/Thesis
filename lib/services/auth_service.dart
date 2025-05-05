import 'dart:convert';
import 'package:fire_response_app/api.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String api = API.baseUrl;

  Future<Map<String, dynamic>?> register(
    String email,
    String password,
    String firstname,
    String lastname,
  ) async {
    final response = await http.post(
      Uri.parse("$api/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$api/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return _handleResponse(response);
  }

  Map<String, dynamic>? _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        "status": "error",
        "message":
            "Invalid response from server. Raw Response: ${response.body}",
      };
    }
  }
}
