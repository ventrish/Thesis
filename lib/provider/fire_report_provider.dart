import 'dart:convert';
import 'package:fire_response_app/api.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/models/fire_reports.dart';
import 'package:http/http.dart' as http;

class FireReportProvider extends ChangeNotifier {
  static const String api = API.baseUrl;
  final List<FireReport> _fireReports = [];
  // Current selected report
  FireReport? _selectedReport;
  late final AuthProvider _authProvider;

  FireReportProvider(this._authProvider);

  List<FireReport> get fireReports => _fireReports;
  FireReport? get selectedReport => _selectedReport;

  // Fetch fire reports for the logged-in user
  Future<void> fetchFireReports() async {
    try {
      String userId = _authProvider.userId;

      if (userId.isEmpty) {
        print("No user is logged in.");
        return;
      }

      final response = await http.get(
        Uri.parse('$api/firereports/$userId/user'),
        headers: {
          'Authorization':
              'Bearer ${_authProvider.token}', // Add token for authentication
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if the response data is empty
        if (data.isEmpty) {
          print("No reports found for the user.");
          return;
        }

        _fireReports.clear(); // Clear existing reports before adding new ones

        // Map the response data to FireReport objects
        for (var reportData in data) {
          _fireReports.add(
            FireReport.fromJson(reportData), // Use fromJson here
          );
        }

        notifyListeners(); // Notify UI to rebuild
      } else {
        print("Failed to load reports: ${response.statusCode}");
        // Optionally handle the error response here, e.g., show a toast or dialog
      }
    } catch (e) {
      print("Error fetching reports: $e");
      // Optionally show a generic error message or toast
    }
  }

  // 🔥 Add new report
  void addFireReport(FireReport report) {
    _fireReports.add(report);
    notifyListeners(); // UI will auto-rebuild
  }

  // 🔥 Edit a report
  void updateFireReport(int index, FireReport updatedReport) {
    _fireReports[index] = updatedReport;
    _selectedReport = updatedReport;
    notifyListeners(); // UI will auto-rebuild
  }

  // 🔥 Delete a report
  void deleteFireReport(int reportId) {
    // Find the report by its id
    _fireReports.removeWhere((report) => report.id == reportId);
    notifyListeners(); // UI will auto-rebuild
  }

  // Selecting reports to view details
  void selectReport(FireReport report) {
    _selectedReport = report;
    notifyListeners(); // Notify listeners when the selected report changes
  }

  // 🔥 Sort by date
  void sortByDate() {
    _fireReports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners(); // UI will auto-rebuild
  }
}
