import 'dart:convert';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fire_response_app/models/fire_station.dart';
import 'package:fire_response_app/api.dart';

class FireStationService {
  static const String api = API.baseUrl;
  List<String> searchHistory = [];

  // Fetch all fire stations from the database
  Future<List<FireStation>> getFireStations() async {
    try {
      final response = await http.get(Uri.parse('$api/fire_stations'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => FireStation.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load fire stations');
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  // Search fire stations by name
  Future<List<FireStation>> searchFireStations(String query) async {
    try {
      final fireStations = await getFireStations();
      final List<FireStation> filteredStations =
          fireStations.where((station) {
            return station.firestationName.toLowerCase().contains(
              query.toLowerCase(),
            );
          }).toList();

      // Save the search query to the search history (limit to 5 for neatness)
      if (!searchHistory.contains(query)) {
        if (searchHistory.length >= 5) {
          searchHistory.removeAt(
            0,
          ); // Remove the oldest search if history is full
        }
        searchHistory.add(query);
      }

      return filteredStations;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  // Calculate the nearest station to a user's location
  Future<FireStation?> getNearestStation(Position userPosition) async {
    try {
      final fireStations = await getFireStations();

      FireStation? nearestStation;
      double minDistance = double.infinity;

      for (var station in fireStations) {
        // Calculate the distance between the user and each station using Haversine formula
        double distance = _calculateDistance(
          userPosition.latitude,
          userPosition.longitude,
          double.parse(station.latitude),
          double.parse(station.longitude),
        );

        // Find the nearest station
        if (distance < minDistance) {
          minDistance = distance;
          nearestStation = station;
        }
      }

      return nearestStation;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  // Calculate distance between two points (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double radius = 6371; // Earth's radius in kilometers
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; // Return distance in kilometers
  }

  // Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Add a new fire station to the database
  Future<void> addFireStation(FireStation station) async {
    final response = await http.post(
      Uri.parse('$api/fire_stations/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(station.toJson()..['id'] = null),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add fire station');
    }
  }

  // Update an existing fire station in the database
  Future<void> updateFireStation(FireStation station) async {
    final response = await http.put(
      Uri.parse('$api/fire_stations/${station.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(station.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update fire station');
    }
  }

  // Delete a fire station from the database
  Future<void> deleteFireStation(int id) async {
    final response = await http.delete(Uri.parse('$api/fire_stations/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete fire station');
    }
  }
}
