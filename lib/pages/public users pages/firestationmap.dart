import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:fire_response_app/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:fire_response_app/provider/location_provider.dart'; // Import LocationProvider

class FireStationMap extends StatefulWidget {
  final String address;
  final String name;
  final LatLng firestationLocation;

  FireStationMap({
    super.key,
    required this.address,
    required this.name,
    required this.firestationLocation,
  });

  @override
  _FireStationMapState createState() => _FireStationMapState();
}

class _FireStationMapState extends State<FireStationMap> {
  final LocationService _locationService = LocationService();

  LatLng? firestationLocation;
  final MapController _mapController = MapController();

  LatLng? _userLatLng;
  LatLng? _fireStationLatLng;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapData();
    _loadCurrentLocation();
  }

  Future<void> _loadMapData() async {
    try {
      // 🚨 Access the user's location from the LocationProvider
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );

      // If location is not available, request it
      if (locationProvider.userLocation == null) {
        print("User location is not available. Requesting location...");
        _userLatLng = await _getUserLocation();
      } else {
        _userLatLng = LatLng(
          locationProvider.userLocation?.latitude ?? 0.0,
          locationProvider.userLocation?.longitude ?? 0.0,
        );
      }

      // Print the coordinates for debugging
      print('User Location: ${locationProvider.userLocation}');
      print('User Lat/Lng: $_userLatLng');

      // 📡 Fetch the fire station coordinates from the address
      final fireStationCoords = await _locationService
          .getCoordinatesFromAddress(widget.address);

      if (fireStationCoords != null && fireStationCoords.isNotEmpty) {
        setState(() {
          _fireStationLatLng = LatLng(
            fireStationCoords['latitude']!, // Assuming these are not null
            fireStationCoords['longitude']!,
          );
          _isLoading = false;
        });
      } else {
        throw Exception(
          "No coordinates found for the address: ${widget.address}",
        );
      }

      print('Fire Station Lat/Lng: $_fireStationLatLng');
    } catch (e) {
      print("❌ Error loading map data: $e");
      setState(() => _isLoading = false);

      // Show alert dialog for visibility
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: Text("Location Error"),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      });
    }
  }

  // Function to request and get user location
  Future<LatLng> _getUserLocation() async {
    try {
      // Request location permission if not already granted
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      // Get the current position after permission is granted
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Return LatLng for the user
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print("Error getting user location: $e");
      // You can set a default location or handle the error accordingly
      return LatLng(14.5995, 120.9842); // Default fallback location
    }
  }

  Future<void> _loadCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        firestationLocation = LatLng(position.latitude, position.longitude);
      });

      // ✅ Move map AFTER rendering
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // ✅ Check if widget is still active
          _mapController.move(
            _getMapCenter(_userLatLng!, firestationLocation!),
            13.0,
          );
        }
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  LatLng _getMapCenter(LatLng loc1, LatLng loc2) {
    return LatLng(
      (loc1.latitude + loc2.latitude) / 2,
      (loc1.longitude + loc2.longitude) / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until data is loaded
    if (_isLoading || _userLatLng == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: FlutterMap(
        options: MapOptions(
          initialCenter:
              _userLatLng!, // Set the map to center on user's location
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              // Marker for user's location
              Marker(
                point: _userLatLng!,
                width: 30,
                height: 30,
                child: Icon(Icons.location_pin, color: Colors.blue, size: 40),
              ),
              // Marker for fire station location
              if (_fireStationLatLng != null)
                Marker(
                  point: _fireStationLatLng!,
                  width: 30,
                  height: 30,
                  child: Icon(
                    Icons.local_fire_department,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
