import 'package:fire_response_app/models/fire_station.dart';
import 'package:fire_response_app/pages/components/bottom_nav.dart';
import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_reports.dart';
import 'package:fire_response_app/pages/public%20users%20pages/profile.dart';
import 'package:fire_response_app/provider/fire_stations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong2/latlong.dart' as latlng;

class FireStations extends StatefulWidget {
  const FireStations({super.key});

  @override
  State<FireStations> createState() => _FireStationsState();
}

class _FireStationsState extends State<FireStations> {
  MapController mapController = MapController();
  latlng.LatLng? userLocation;
  List<Marker> fireStationMarkers = [];
  Marker? userLocationMarker;
  final int selectedIndex = 2;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final provider = Provider.of<FireStationProvider>(context, listen: false);
    await provider.fetchFireStations();

    // Get user location
    loc.Location location = loc.Location();
    final currentLoc = await location.getLocation();

    setState(() {
      userLocation = latlng.LatLng(currentLoc.latitude!, currentLoc.longitude!);

      // Add user location marker
      userLocationMarker = Marker(
        point: userLocation!,
        width: 40.0,
        height: 40.0,
        child: Icon(
          Icons.location_pin,
          color: Colors.blue, // Blue marker for user's location
          size: 40,
        ),
      );

      // Add fire station markers
      fireStationMarkers =
          provider.fireStation.map((station) {
            return Marker(
              point: latlng.LatLng(
                double.parse(station.latitude),
                double.parse(station.longitude),
              ),
              width: 40.0,
              height: 40.0,
              child: Icon(
                Icons.local_fire_department,
                color: Colors.red, // Red marker for fire stations
                size: 40,
              ),
            );
          }).toList();
    });
  }

  void _zoomToSearchedStation(FireStation station) {
    final latlng.LatLng stationLocation = latlng.LatLng(
      double.parse(station.latitude),
      double.parse(station.longitude),
    );

    mapController.move(stationLocation, 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fire Stations')),
      body:
          userLocation == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // OpenStreetMap
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: userLocation!,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          if (userLocationMarker != null) userLocationMarker!,
                          ...fireStationMarkers,
                        ],
                      ),
                    ],
                  ),
                  // Search bar
                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search Fire Stations...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 10,
                                  ),
                                ),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.search, size: 40),
                            onPressed: () {
                              // Add search functionality here
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: BottomNav(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == selectedIndex) return;

          Widget nextPage;
          switch (index) {
            case 0:
              nextPage = CiviliansHomePage();
              break;
            case 1:
              nextPage = FireReports();
              break;
            case 2:
              nextPage = FireStations();
              break;
            case 3:
              nextPage = Profile();
              break;
            default:
              return;
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => nextPage),
          );
        },
      ),
    );
  }
}
