import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

// Custom exception for better error handling
class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() {
    return "LocationServiceException: $message"; // Add this to make the error message clearer
  }
}

class LocationService {
  // Your Google Maps Geocoding API Key (make sure to replace it with your actual key)
  final String _googleMapsApiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';

  // ✅ Get user location
  Future<Position> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceException('Location services are disabled.');
      }

      // Check location permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationServiceException('Location permissions are denied');
        }
      }

      // Handle permanently denied permission
      if (permission == LocationPermission.deniedForever) {
        throw LocationServiceException(
          'Location permissions are permanently denied',
        );
      }

      // Return the current position if everything is okay
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // If error occurs, rethrow it with more context
      throw LocationServiceException('Failed to get user location: $e');
    }
  }

  // ✅ Convert address to coordinates using Google Maps Geocoding API
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$_googleMapsApiKey",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body
        final data = jsonDecode(response.body);

        if (data['results'].isNotEmpty) {
          // Extract latitude and longitude from the results
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

  // Calculate distance between two geo-coordinates using Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the Earth in km
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = R * c; // in km
    return distance;
  }
}
