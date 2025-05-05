import 'dart:convert';

import 'package:fire_response_app/provider/fire_stations_provider.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/services/location_service.dart'; // Import location service
import 'package:fire_response_app/models/fire_station.dart'; // Your FireStation model
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; // Import provider

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  Position? _userLocation;
  FireStation? _nearestFireStation;

  Position? get userLocation => _userLocation;
  FireStation? get nearestFireStation => _nearestFireStation;

  // Fetch coordinates from address
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    const String _googleMapsApiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';
    final encodedAddress = Uri.encodeComponent(address);
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$_googleMapsApiKey",
    );

    try {
      final response = await http.get(url);
      print("Response from Google Geocoding API: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          double lat = data['results'][0]['geometry']['location']['lat'];
          double lon = data['results'][0]['geometry']['location']['lng'];
          return {'latitude': lat, 'longitude': lon};
        } else {
          print("⚠️ No results found for the address: $address");
          return null;
        }
      } else {
        print("❌ Failed to fetch data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error during geocoding: $e");
      return null;
    }
  }

  // ✅ Fetch user's location and nearest fire station
  Future<void> fetchLocationAndNearestStation(BuildContext context) async {
    try {
      // 🚨 Check if permission is granted before fetching location
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Check if permission is still denied after request
      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          "Location permissions are permanently denied. Please enable them in the app settings.",
        );
      }

      // 🔍 Get user's current location
      _userLocation = await _locationService.getUserLocation();

      // 📡 Fetch fire stations
      final fireStationProvider = Provider.of<FireStationProvider>(
        context,
        listen: false,
      );
      await fireStationProvider.fetchFireStations();
      final fireStations = fireStationProvider.fireStation;

      if (fireStations.isEmpty) {
        throw Exception("No fire stations found.");
      }

      // 🏆 Find the nearest fire station
      FireStation? closestStation;
      double shortestDistance = double.infinity;

      for (final station in fireStations) {
        if (station.firestationLocation != null &&
            station.firestationLocation.isNotEmpty) {
          try {
            print(
              "🔎 Fetching coordinates for: ${station.firestationLocation}",
            );

            // 🌍 Convert address to coordinates using location service
            Map<String, double>? coordinates = await _locationService
                .getCoordinatesFromAddress(station.firestationLocation);

            if (coordinates != null && coordinates.isNotEmpty) {
              double stationLat = coordinates['latitude'] ?? 0.0;
              double stationLon = coordinates['longitude'] ?? 0.0;

              // Ensure valid coordinates before proceeding
              if (stationLat != 0.0 && stationLon != 0.0) {
                double distance = _locationService.calculateDistance(
                  _userLocation!.latitude,
                  _userLocation!.longitude,
                  stationLat,
                  stationLon,
                );

                if (distance < shortestDistance) {
                  shortestDistance = distance;
                  closestStation = station;
                }
              } else {
                print("⚠️ Invalid coordinates for: ${station.firestationName}");
              }
            } else {
              print("⚠️ No coordinates found for: ${station.firestationName}");
            }
          } catch (e) {
            print(
              "❌ Error geocoding address for ${station.firestationName}: $e",
            );
          }
        } else {
          print("⚠️ Invalid or missing address: ${station.firestationName}");
        }
      }

      if (closestStation != null) {
        _nearestFireStation = closestStation;
        print("🔥 Nearest Fire Station: ${closestStation.firestationName}");
      } else {
        print("❌ No valid fire stations found.");
      }

      // 🔄 Update UI
      notifyListeners();
    } catch (e) {
      print("🚨 Error fetching location or nearest station: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading map data: ${e.toString()}')),
      );
    }
  }
}
