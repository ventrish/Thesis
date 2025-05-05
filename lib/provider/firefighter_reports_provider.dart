import 'package:fire_response_app/api.dart';
import 'package:fire_response_app/models/firefighter_report.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Provider for Firefighter Reports
class FirefighterReportsProvider with ChangeNotifier {
  List<FirefighterReport> _fireReports = [];
  bool _isLoading = false;

  List<FirefighterReport> get fireReports => _fireReports;
  final String api = API.baseUrl;
  bool get isLoading => _isLoading;

  // Fetch data from the API
  Future<void> fetchFireReports() async {
    final url = '$api/firefighter_reports';
    // http://127.0.0.1:8000/api/firefighter_reports
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _fireReports =
            data
                .map((reportData) => FirefighterReport.fromJson(reportData))
                .toList();
        notifyListeners(); // Notify listeners when data is updated
      } else {
        throw Exception('Failed to load fire reports');
      }
    } catch (error) {
      throw error;
    }
  }
}
