import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class FireLocation extends StatefulWidget {
  final LatLng incidentLocation;

  const FireLocation({super.key, required this.incidentLocation});

  @override
  _FireLocationState createState() => _FireLocationState();
}

class _FireLocationState extends State<FireLocation> {
  GoogleMapController? _mapController;
  LatLng? firefighterLocation;
  Set<Marker> _markers = {};
  Polyline? _routePolyline;
  double? eta;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.deniedForever) {
      return; // Handle location permission issues
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        firefighterLocation = LatLng(position.latitude, position.longitude);
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('firefighter'),
            position: firefighterLocation!,
            infoWindow: InfoWindow(title: 'Firefighter'),
          ),
        );
      });

      if (firefighterLocation != null) {
        _getRouteAndETA(firefighterLocation!, widget.incidentLocation);
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _getRouteAndETA(LatLng origin, LatLng destination) async {
    final String googleApiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0]['legs'][0];
          final duration = route['duration']['text']; // ETA
          final polyline = route['overview_polyline']['points'];

          setState(() {
            eta = route['duration']['value'] / 60; // ETA in minutes
            _routePolyline = Polyline(
              polylineId: PolylineId('route'),
              color: Colors.blue,
              width: 5,
              points: _decodePolyline(polyline),
            );
          });

          print('ETA: $duration');
        }
      } else {
        print('Failed to get directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;

      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  double _calculateZoomLevel(LatLng origin, LatLng destination) {
    double distance = Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      destination.latitude,
      destination.longitude,
    );
    // Adjust the zoom level based on the distance
    if (distance < 1000) {
      return 15.0; // More zoomed in
    } else if (distance < 5000) {
      return 12.0;
    } else {
      return 10.0; // Less zoomed in
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fire Responder Tracker")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.incidentLocation,
              zoom: _calculateZoomLevel(
                firefighterLocation!,
                widget.incidentLocation,
              ),
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            polylines: _routePolyline != null ? {_routePolyline!} : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (eta != null)
            Positioned(
              bottom: 50,
              left: 20,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ETA: ${eta!.toStringAsFixed(0)} minutes'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
