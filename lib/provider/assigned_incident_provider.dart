// import 'dart:convert';
// import 'package:fire_response_app/models/assigned_incident.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:fire_response_app/api.dart';
// import 'package:provider/provider.dart';
// import 'package:fire_response_app/provider/auth_provider.dart';

// class AssignedIncidentProvider with ChangeNotifier {
//   String api = API.baseUrl;

//   AssignedIncident? _assignedIncident;
//   AssignedIncident? get assignedIncident => _assignedIncident;

//   // Fetch the assigned incident using the firefighter ID
//   Future<void> fetchAssignedIncident(BuildContext context) async {
//     try {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       await authProvider
//           .loadUserSession(); // Ensure token and userId are loaded

//       final token = authProvider.token;
//       final userId = authProvider.userId;

//       // Check if token and userId are present before proceeding
//       if (token == null || userId.isEmpty) {
//         throw Exception('User is not authenticated or user ID is missing');
//       }

//       // Proceed to fetch firefighter ID
//       final firefighterIdResponse = await http.get(
//         Uri.parse('$api/firefighter-id'),
//         headers: {
//           'Authorization': 'Bearer $token', // Include token for authentication
//           'Accept': 'application/json',
//         },
//       );

//       if (firefighterIdResponse.statusCode != 200) {
//         throw Exception('Failed to fetch firefighter ID');
//       }

//       final idData = jsonDecode(firefighterIdResponse.body);
//       final firefighterId = idData['firefighter_id'];

//       if (firefighterId == null) {
//         throw Exception('Firefighter ID is null');
//       }

//       // Fetch assigned incident using the retrieved firefighterId
//       final response = await http.get(
//         Uri.parse('$api/assigned-incident/$firefighterId'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data != null && data is List && data.isNotEmpty) {
//           _assignedIncident = AssignedIncident.fromJson(data[0]);
//           print("✅ Assigned Incident Loaded: $_assignedIncident");
//         } else {
//           _assignedIncident = null;
//           print("🟡 No assigned incident found.");
//         }
//         notifyListeners();
//       } else {
//         throw Exception(
//           "Failed to load assigned incident. Status: ${response.statusCode}",
//         );
//       }
//     } catch (e) {
//       print("❌ Error in fetchAssignedIncident: $e");
//     }
//   }
// }
