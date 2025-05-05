import 'dart:io';

import 'package:fire_response_app/provider/submit_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubmitReportPage extends StatefulWidget {
  @override
  _SubmitReportPageState createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage> {
  final _formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final descriptionController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  // Coordinates
  double? existingLatitude;
  double? existingLongitude;

  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize existing coordinates if available
    existingLatitude = 0.0;
    existingLongitude = 0.0;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> submitFireReport(BuildContext context) async {
    final submitReportProvider = Provider.of<SubmitReportProvider>(
      context,
      listen: false,
    );

    // Use the coordinates that are already available
    double? latitude = existingLatitude;
    double? longitude = existingLongitude;

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coordinates are missing, cannot submit report.'),
        ),
      );
      return;
    }

    // Validate form
    if (_formKey.currentState!.validate()) {
      try {
        await submitReportProvider.submitFireReport(
          context,
          formKey: _formKey,
          locationController: locationController,
          landmarkController: landmarkController,
          descriptionController: descriptionController,
          clearFields: () {
            setState(() {
              descriptionController.clear();
              locationController.clear();
              landmarkController.clear();
            });
          },
          geocodedLocation: null, // No need to pass coordinates from here
          existingLatitude: latitude,
          existingLongitude: longitude,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting fire report. Please try again.'),
          ),
        );
      }
    } else {
      // If form is invalid, show a validation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill out all required fields.')),
      );
    }
  }

  // Method to get current location and convert to address
  // Future<void> _getCurrentLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Location services are disabled. Please enable them.'),
  //       ),
  //     );
  //     return; // Exit the method if location services are disabled
  //   }

  //   // Check for location permissions
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.whileInUse &&
  //         permission != LocationPermission.always) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Location permission is denied.')),
  //       );
  //       return; // Exit the method if permission is denied
  //     }
  //   }

  //   // Get current position (latitude, longitude)
  //   Position position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );

  //   // Validate latitude and longitude values
  //   if (position.latitude == null || position.longitude == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Unable to fetch valid coordinates.')),
  //     );
  //     return;
  //   }

  //   // Get the address from the coordinates using Google Maps Geocoding API
  //   String apiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';
  //   String url =
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&location_type=ROOFTOP&result_type=locality|sublocality|neighborhood|administrative_area_level_2&key=$apiKey';

  //   try {
  //     // Make HTTP request to the Geocoding API
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       // Parse the response
  //       var data = json.decode(response.body);
  //       if (data['results'].isNotEmpty) {
  //         // Get the first result
  //         String address = '';
  //         for (var component in data['results'][0]['address_components']) {
  //           if (component['types'].contains('locality')) {
  //             address += '${component['long_name']}, ';
  //           }
  //           if (component['types'].contains('sublocality') ||
  //               component['types'].contains('neighborhood')) {
  //             address += '${component['long_name']}, ';
  //           }
  //           if (component['types'].contains('administrative_area_level_1')) {
  //             address += '${component['long_name']}, ';
  //           }
  //           if (component['types'].contains('country')) {
  //             address += '${component['long_name']}';
  //           }
  //         }

  //         setState(() {
  //           locationController.text = address;
  //           existingLatitude = position.latitude;
  //           existingLongitude = position.longitude;
  //         });
  //       } else {
  //         // If no address found, show a message
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('No address found for the location.')),
  //         );
  //       }
  //     } else {
  //       // Handle error if the API request fails
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to fetch address from Google API.')),
  //       );
  //     }
  //   } catch (e) {
  //     // Catch errors if the API request fails
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Unable to get address for the location: $e')),
  //     );
  //   }
  // }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location services are disabled. Please enable them.'),
        ),
      );
      return; // Exit the method if location services are disabled
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission is denied.')),
        );
        return; // Exit the method if permission is denied
      }
    }

    // Get current position (latitude, longitude)
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Validate latitude and longitude values
    if (position.latitude == null || position.longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to fetch valid coordinates.')),
      );
      return;
    }

    // Get the address from the coordinates using Google Maps Geocoding API
    String apiKey =
        'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4'; // Replace with your Google API Key
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&location_type=ROOFTOP&result_type=street_address&key=$apiKey';

    try {
      // Make HTTP request to the Geocoding API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the response
        var data = json.decode(response.body);
        if (data['status'] == 'OK') {
          // Get the first result from the response
          String address = data['results'][0]['formatted_address'];

          // Update the location field with the address
          setState(() {
            locationController.text = address;
            existingLatitude = position.latitude;
            existingLongitude = position.longitude;
          });
        } else {
          // If no address found, show a message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No address found for the location.')),
          );
        }
      } else {
        // Handle error if the API request fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch address from Google API.')),
        );
      }
    } catch (e) {
      // Catch errors if the API request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get address for the location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Fire Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              labelField("Location"),
              Row(
                children: [
                  Expanded(
                    child: textInput(
                      locationController,
                      'Enter fire location...',
                    ),
                  ),
                  // Button to get the current location
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                ],
              ),

              labelField("Landmark"),
              textInput(landmarkController, 'Enter nearest landmark...'),

              // Description
              labelField("Description"),
              textInput(descriptionController, 'Brief description...'),

              // Image upload
              SizedBox(height: 10),
              labelField("Upload Image (optional)"),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo, color: Colors.white),
                    label: Text(
                      'Select from Gallery',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),

              if (_image != null) ...[
                SizedBox(height: 10),
                Image.file(
                  File(_image!.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ],

              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      submitFireReport(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child:
                        isSubmitting
                            ? CircularProgressIndicator() // Show a loader when submitting
                            : Text(
                              'Submit Report',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widgets for consistent style
Widget labelField(String label) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0, bottom: 4),
    child: Text(label, style: TextStyle(color: Colors.black38, fontSize: 16)),
  );
}

Widget textInput(TextEditingController controller, String hint) {
  return TextFormField(
    controller: controller,
    validator:
        (value) =>
            value == null || value.isEmpty ? 'This field is required.' : null,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.black38),
      border: InputBorder.none,
      filled: true,
      fillColor: Colors.grey.withOpacity(0.2),
    ),
    style: TextStyle(color: Colors.black),
    cursorColor: Colors.white,
  );
}
