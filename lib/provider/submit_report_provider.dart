import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fire_response_app/api.dart';
import 'package:fire_response_app/provider/auth_provider.dart';

class SubmitReportProvider extends ChangeNotifier {
  Future<void> submitFireReport(
    BuildContext context, {

    required GlobalKey<FormState> formKey,
    required TextEditingController locationController,
    required TextEditingController landmarkController,
    required TextEditingController descriptionController,
    required Function clearFields, // Function to clear form fields
    required Map<String, double>?
    geocodedLocation, // Pass the geocodedLocation as a parameter
    required double? existingLatitude, // Optional, in case coordinates exist
    required double? existingLongitude, // Optional, in case coordinates exist
  }) async {
    const String api = API.baseUrl;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final userId = authProvider.userId;

    if (formKey.currentState!.validate() && userId != null) {
      // Use geocodedLocation if available, otherwise fall back to existing coordinates
      double? latitude = geocodedLocation?['latitude'] ?? existingLatitude;
      double? longitude = geocodedLocation?['longitude'] ?? existingLongitude;

      // Ensure that we have valid coordinates
      if (latitude == null || longitude == null) {
        print("❌ Error: No valid coordinates found for the location.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get valid coordinates for the location.'),
          ),
        );
        return; // Stop further execution if no coordinates are found
      }

      try {
        final url = Uri.parse('$api/firereports');

        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'reported_by': userId,
            'location': locationController.text,
            'landmark': landmarkController.text,
            'description': descriptionController.text,
            'latitude': latitude,
            'longitude': longitude,
          }),
        );

        if (response.statusCode == 201) {
          print("✅ Fire report submitted successfully!");
          print("User ID: $userId");
          print("Token: $token");

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fire report submitted!')));

          // Call the `clearFields` function to clear the form
          clearFields();
        } else {
          print("❌ Error submitting fire report: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit report. Please try again.'),
            ),
          );
        }
      } catch (e) {
        print("❌ Exception: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please check your internet connection.',
            ),
          ),
        );
      }
    } else {
      print("⚠️ Error: Form is invalid or userId is null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields.')),
      );
    }
  }

  Future<void> submitFireReportUnauthenticated(
    BuildContext context, {
    required GlobalKey<FormState> formKey,
    required TextEditingController locationController,
    required TextEditingController landmarkController,
    required TextEditingController descriptionController,
    required TextEditingController contactinfoController,
    required Map<String, double>? geocodedLocation,
    required double? existingLatitude,
    required double? existingLongitude,

    required Function clearFields,
  }) async {
    const String api = API.baseUrl;

    if (formKey.currentState!.validate()) {
      try {
        final url = Uri.parse('$api/firereports');

        final response = await http.post(
          url,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'location': locationController.text,
            'landmark': landmarkController.text,
            'description': descriptionController.text,
            'contact_info': contactinfoController.text,
            // ❌ remove lat/long since backend handles it
          }),
        );

        if (response.statusCode == 201) {
          print("✅ Fire report submitted successfully!");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Fire report submitted!')));
          clearFields();
        } else {
          print("❌ Error submitting fire report: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to submit report. Please try again.'),
            ),
          );
        }
      } catch (e) {
        print("❌ Exception: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please check your internet connection.',
            ),
          ),
        );
      }
    } else {
      print("⚠️ Form is invalid");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields.')),
      );
    }
  }
}
