import 'dart:async';
import 'package:fire_response_app/api.dart';
import 'package:fire_response_app/models/user.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:fire_response_app/models/assigned_incident.dart'; // Import AssignedIncident model
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class FirefighterProvider extends ChangeNotifier {
  bool _isIncidentFetched = false;
  static const String api = API.baseUrl;
  Position? _currentLocation;
  String _status = "Off Duty"; // Default status
  StreamSubscription<Position>? _positionStream;
  String firefighterName = "";
  String firefighterRole = "";
  int? firefighterId;
  String team = "";
  int userId = 0;
  int? get getFirefighterId => firefighterId;

  // set firefighterId(int? id) {
  //   _firefighterId = id;
  //   notifyListeners(); // Notify listeners when the ID is set
  // }

  Position? get currentLocation => _currentLocation;
  String get status => _status;
  User? _currentUser;

  User? get currentUser => _currentUser;

  static Timer? _timer; // Timer for periodic updates

  // Add _assignedIncident variable here
  AssignedIncident? _assignedIncident;
  AssignedIncident? get assignedIncident => _assignedIncident;

  FirefighterProvider();

  void setFirefighterId(int id) {
    firefighterId = id;
    notifyListeners();
  }

  Future<void> fetchFirefighterIdFromPreferences() async {
    final id =
        await getSavedFirefighterId(); // Get firefighter ID from SharedPreferences
    if (id != null) {
      if (firefighterId != id) {
        firefighterId = id;
        print(
          "🚨 fetchFirefighterIdFromPreferences Before notifyListeners: Firefighter ID = $firefighterId",
        );
        notifyListeners();
        print(
          "🚨fetchFirefighterIdFromPreferences After notifyListeners: Firefighter ID = $firefighterId",
        );
      } else {
        print("ℹ️ Firefighter ID is already set: $firefighterId");
      }
    } else {
      print("❌ Firefighter ID not found in SharedPreferences.");
    }
  }

  // Save firefighterId to SharedPreferences
  Future<void> saveFirefighterId(int firefighterId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool success = await prefs.setInt('firefighterId', firefighterId);
    if (success) {
      print("✅ Firefighter ID saved successfully: $firefighterId");
    } else {
      print("❌ Failed to save Firefighter ID.");
    }

    // Ensure listeners are notified
    // notifyListeners();

    // Now retrieve the firefighterId after the delay
    // int? savedId = await getSavedFirefighterId();
    // print("Retrieved firefighterId: $savedId");
  }

  // Retrieve firefighterId from SharedPreferences
  Future<int?> getSavedFirefighterId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('firefighterId');
  }

  Future<void> fetchFirefighterDetails(
    int firefighterId,
    BuildContext context,
  ) async {
    try {
      // Fallback: Get firefighterId from SharedPreferences if null
      if (firefighterId == null) {
        firefighterId = await getSavedFirefighterId() ?? 0;
        if (firefighterId == null) {
          throw Exception(
            "❌ Firefighter ID is null and not found in SharedPreferences.",
          );
        }
      }

      await fetchFirefighterIdFromPreferences();

      // Step 1: Load token from AuthProvider
      await Provider.of<AuthProvider>(context, listen: false).loadToken();
      final token = Provider.of<AuthProvider>(context, listen: false).token;

      if (token == null || token.isEmpty) {
        throw Exception('Token is missing or invalid');
      }

      // Step 2: Fetch user details first to get userId
      final userResponse = await http.get(
        Uri.parse('$api/user'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(userResponse.body);

        // Access the user's first name
        firefighterName = userData['userFirstName'] ?? 'No name available';
        userId = userData['id']; // Set the userId for subsequent requests
      } else {
        print("User response body: ${userResponse.body}");
        throw Exception('Failed to fetch user details');
      }

      // Step 3: Fetch firefighter details using the userId
      final firefighterResponse = await http.get(
        Uri.parse('$api/firefighters/$userId/details'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (firefighterResponse.statusCode == 200) {
        final Map<String, dynamic> firefighterData = jsonDecode(
          firefighterResponse.body,
        );

        // Ensure firefighterId is set only once (if it's 0)
        if (firefighterId == null || firefighterId == 0) {
          firefighterId = firefighterData['id'];
          print("🚨 Firefighter ID set to: $firefighterId"); // Debugging line
          await saveFirefighterId(firefighterId);
          firefighterId = await getSavedFirefighterId() ?? 0;
          print("🚨 Firefighter ID after save: $firefighterId");
        }

        // Extract firefighter position and team name
        firefighterRole =
            firefighterData['position']['position_name'] ?? 'No position';
        team = firefighterData['team']['teamName'] ?? 'No team assigned';
        print("🚨 Firefighter ID: $firefighterId");

        // Fetch status and assigned incident at once
        await fetchFirefighterStatus(firefighterId);
        await fetchAssignedIncident(firefighterId);

        print(
          "🚨fetchFirefighterDetails Before notifyListeners: Firefighter ID = ${this.firefighterId}",
        );

        notifyListeners();

        print(
          "🚨 fetchFirefighterDetails After notifyListeners: Firefighter ID = ${this.firefighterId}",
        );
        // await fetchFirefighterStatus(firefighterId);
        // print('$firefighterId');
      } else {
        throw Exception("Failed to fetch firefighter details");
      }
    } catch (e) {
      print("Error fetching firefighter details: $e");
    }
  }

  Future<void> fetchFirefighterStatus(firefighterId) async {
    try {
      print("🚨 Fetching status for firefighterId: $firefighterId");

      final response = await http.get(
        Uri.parse('$api/firefighters/$firefighterId/status'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String fetchedStatus = data['status'] ?? 'Off Duty';

        print("✅ Firefighter status fetched: $fetchedStatus");

        _status = fetchedStatus;

        // After getting the status, fetch the assigned incident using the same firefighterId
        await fetchAssignedIncident(firefighterId);

        if (_status == "On Response" || _status == "Standby") {
          print("✅ Starting location tracking...");
          print('$firefighterId');
          startLocationTracking(userId);
        } else {
          print("🚫 Location tracking stopped.");
          stopLocationTracking();
        }
        // print(
        //   "🚨fetchFirefighterStatus Before notifyListeners: Firefighter ID = $firefighterId",
        // );
        // notifyListeners();
        // print(
        //   "🚨fetchFirefighterStatus After notifyListeners: Firefighter ID = $firefighterId",
        // );
      } else {
        print(
          "⚠️ Failed to fetch firefighter status. Status: ${response.statusCode}",
        );
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      print("❌ Error fetching firefighter status: $e");
    }
  }

  Future<void> fetchAssignedIncident(int firefighterId) async {
    // if (_isIncidentFetched) {
    //   print("❌ Assigned incident already fetched. Skipping.");
    //   return;
    // }
    try {
      // if (firefighterId == null) {
      //   throw Exception('Firefighter ID is null');
      // }

      final response = await http.get(
        Uri.parse('$api/assigned-incident/$firefighterId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("✅ Raw data from API: $data");

        if (data != null && data is List && data.isNotEmpty) {
          List<String> teamNames = [];
          List<String> teamLeaders = [];

          for (var item in data) {
            if (item['teamName'] is String) {
              teamNames.add(item['teamName']);
            } else if (item['teamName'] is List) {
              teamNames.addAll(List<String>.from(item['teamName']));
            }

            if (item['teamLeader'] is String) {
              teamLeaders.add(item['teamLeader']);
            } else if (item['teamLeader'] is List) {
              teamLeaders.addAll(List<String>.from(item['teamLeader']));
            }
          }

          // Check if the firefighter_id exists and is valid
          if (data[0]['firefighter_id'] == null) {
            print("❌ Firefighter ID not found in assigned incident data.");
            _assignedIncident = null;
          } else {
            _assignedIncident = AssignedIncident.fromJson({
              'firefighter_id': data[0]['firefighter_id'],
              'location': data[0]['location'],
              'landmark': data[0]['landmark'],
              'timeReported': data[0]['timeReported'],
              'teamName': teamNames,
              'teamLeader': teamLeaders,
              'latitude': data[0]['latitude'],
              'longitude': data[0]['longitude'],
            });

            print(
              "✅ Assigned Incident Loaded: ${_assignedIncident?.firefighterId}",
            );
          }
        } else {
          _assignedIncident = null;
          print("🟡 No assigned incident found.");
        }
        // print(
        //   "🚨fetchAssignedIncident Before notifyListeners: Firefighter ID = $firefighterId",
        // );
        // notifyListeners();
        // print(
        //   "🚨fetchAssignedIncident After notifyListeners: Firefighter ID = $firefighterId",
        // );
      }
    } catch (e) {
      print("❌ Error in fetchAssignedIncident: $e");
    }
  }

  // ✅ Get Current Location
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("GPS is disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw Exception("Location permission permanently denied.");
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ✅ Update Location to Server
  static Future<void> updateLocation(int userId, double lat, double lng) async {
    try {
      final response = await http.post(
        Uri.parse("$api/update-location"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "latitude": lat,
          "longitude": lng,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Location updated successfully!");
      } else {
        print("❌ Error updating location: ${response.body}");
      }
    } catch (e) {
      print("❌ Network Error: $e");
    }
  }

  static void startLocationTracking(int userId) {
    _timer?.cancel(); // Cancel existing timer if any

    _timer = Timer.periodic(Duration(seconds: 120), (timer) async {
      try {
        Position position = await getCurrentLocation();
        await updateLocation(userId, position.latitude, position.longitude);
      } catch (e) {
        print("❌ Location tracking error: $e");
      }
    });
  }

  // ✅ Stop Tracking
  static void stopLocationTracking() {
    _timer?.cancel();
    print("🚫 Location tracking stopped.");
  }
}
