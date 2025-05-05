import 'package:fire_response_app/models/fire_station.dart';
import 'package:fire_response_app/services/firestation_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FireStationProvider extends ChangeNotifier {
  List<FireStation> _fireStation = [];
  FireStation? _selectedStation;
  final List<String> _searchHistory = [];

  List<FireStation> get fireStation => _fireStation;
  FireStation? get selectedStation => _selectedStation;

  final FireStationService _fireStationService = FireStationService();

  // Fetch all fire stations from the database
  Future<void> fetchFireStations() async {
    _fireStation = await _fireStationService.getFireStations();
    notifyListeners(); // Notify UI
  }

  // Add new fire station
  Future<void> addFireStation(FireStation station) async {
    await _fireStationService.addFireStation(station);
    _fireStation.add(station); // Update local state
    notifyListeners(); // Notify UI
  }

  // Edit a fire station
  Future<void> updateFireStation(int index, FireStation updatedStation) async {
    await _fireStationService.updateFireStation(updatedStation);
    _fireStation[index] = updatedStation; // Update local state
    _selectedStation =
        updatedStation; // Optional: If you want to keep track of the selected station
    notifyListeners(); // Notify UI
  }

  // Delete a fire station
  Future<void> deleteFireStation(int stationId) async {
    await _fireStationService.deleteFireStation(
      stationId,
    ); // Delete from the database
    _fireStation.removeWhere(
      (station) => station.id == stationId,
    ); // Update local state
    notifyListeners(); // Notify UI
  }

  // Select a fire station to view details
  void selectStation(FireStation station) {
    _selectedStation = station;
    notifyListeners(); // Notify UI
  }

  // Search for fire stations by name
  Future<void> searchStations(String query) async {
    _fireStation = await _fireStationService.searchFireStations(query);
    if (!_searchHistory.contains(query)) {
      if (_searchHistory.length >= 5) {
        _searchHistory.removeAt(0); // Keep the history list size small (max 5)
      }
      _searchHistory.add(query); // Add query to search history
    }
    notifyListeners(); // Notify UI
  }

  // Get the nearest fire station based on user's location
  Future<void> findNearestStation(Position userPosition) async {
    FireStation? nearestStation = await _fireStationService.getNearestStation(
      userPosition,
    );
    _selectedStation =
        nearestStation; // Optionally, update selected station with nearest one
    notifyListeners(); // Notify UI
  }
}
