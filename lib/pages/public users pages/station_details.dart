import 'dart:convert';

import 'package:fire_response_app/models/fire_station.dart';
import 'package:fire_response_app/pages/public%20users%20pages/firestationmap.dart';
import 'package:fire_response_app/provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart'; // For accessing the LocationProvider

class StationDetails extends StatefulWidget {
  final FireStation station;
  const StationDetails({super.key, required this.station});

  @override
  State<StationDetails> createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> {
  String firestationAddress = "";
  LatLng? firestationLatLng;

  @override
  void initState() {
    super.initState();
    firestationAddress = widget.station.firestationLocation;
    print("Fetching coordinates for: $firestationAddress");
    getLatLngFromAddress();
  }

  Future<void> getLatLngFromAddress() async {
    const String googleMapsApiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';
    final String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(firestationAddress)}&key=$googleMapsApiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(
          response.body,
        ); // ✅ Use a Map
        final List<dynamic> results =
            data["results"]; // ✅ Extract the results list

        if (data.isNotEmpty) {
          final Map<String, dynamic> location =
              results[0]["geometry"]["location"]; // ✅ Get first result
          double lat = location["lat"];
          double lon = location["lng"];

          setState(() {
            firestationLatLng = LatLng(lat, lon);
          });

          print("Fire Station Location: $lat, $lon");
        } else {
          print("No coordinates found for this address.");
        }
      } else {
        print("Error fetching coordinates: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final station = widget.station;

    // Access the LocationProvider
    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(station.firestationName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the fire station's location and contact info
            Text(
              'Location: ${station.firestationLocation}', // Assuming it's the address
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Contact: ${station.firestationContactNumber}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            SizedBox(height: 20),

            // Button to view the station on a map
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.blue[100]),
              onPressed: () async {
                // Fetch coordinates from the LocationProvider for fire station
                final coordinates = await locationProvider
                    .getCoordinatesFromAddress(station.firestationLocation);

                if (coordinates != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => FireStationMap(
                            name: station.firestationName,
                            address:
                                station.firestationLocation ??
                                'Unknown Location',
                            firestationLocation: firestationLatLng!,
                          ),
                    ),
                  );
                } else {
                  // Handle case where coordinates are not found
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: Text("Location Error"),
                          content: Text(
                            "Could not fetch coordinates for this address.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: Row(
                children: [
                  Icon(Icons.map),
                  SizedBox(width: 4),
                  Text(
                    'View on Map',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
