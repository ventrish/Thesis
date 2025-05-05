import 'dart:convert';
import 'package:fire_response_app/api.dart';
import 'package:http/http.dart' as http;

class FirefighterService {
  final String api = API.baseUrl; // Your base URL

  // Fetch Firefighter Status
  Future<String> fetchFirefighterStatus(int firefighterId) async {
    try {
      final response = await http.get(
        Uri.parse("$api/firefighters/$firefighterId/team-status"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['status']; // Returning status directly
      } else {
        throw Exception("Failed to load status");
      }
    } catch (e) {
      throw Exception("Error fetching status: $e");
    }
  }

  // Fetch User Details (linked to the firefighter)
  Future<Map<String, dynamic>> fetchFirefighterDetails(
    int firefighterId,
  ) async {
    try {
      // Step 1: Fetch firefighter details
      final response = await http.get(
        Uri.parse("$api/$firefighterId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
          'Firefighter Details Response: $data',
        ); // Debugging: Log the entire response

        // Step 2: Check if the necessary data exists
        if (data.containsKey('user') &&
            data['user'].containsKey('userFirstName') &&
            data['user'].containsKey('userLastName') &&
            data.containsKey('team') &&
            data['team'].containsKey('teamName')) {
          // Extract teamName directly from the response
          String teamName = data['team']['teamName'] ?? 'Unknown';

          // The position is directly in the firefighter object
          String position = data['position'] ?? 'Unknown';

          // Return the firefighter details along with team and position
          return {
            'userFirstName': data['user']['userFirstName'],
            'userLastName': data['user']['userLastName'],
            'position': position,
            'team': teamName,
          };
        } else {
          throw Exception("Missing expected data in the response");
        }
      } else {
        throw Exception(
          "Failed to load firefighter details, status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error fetching firefighter details: $e");
    }
  }
}
