import 'dart:convert';
import 'dart:io';
import 'package:fire_response_app/provider/submit_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EmergencyReport extends StatefulWidget {
  const EmergencyReport({super.key});

  @override
  State<EmergencyReport> createState() => _EmergencyReportState();
}

class _EmergencyReportState extends State<EmergencyReport> {
  final _formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();
  final descriptionController = TextEditingController();
  final contactinfoController = TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  // Variables to store latitude and longitude
  double? existingLatitude;
  double? existingLongitude;

  @override
  void dispose() {
    locationController.dispose();
    landmarkController.dispose();
    descriptionController.dispose();
    contactinfoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them.');
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showSnackBar('Location permission is denied.');
        return;
      }
    }

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (position.latitude == null || position.longitude == null) {
        _showSnackBar('Unable to fetch valid coordinates.');
        return;
      }

      // Get address from coordinates
      String apiKey = 'AIzaSyAnst45VUe9XkXDduDBPmuPo7H3YmWDNJ4';
      String url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&location_type=ROOFTOP&result_type=street_address&key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'OK') {
          String address = data['results'][0]['formatted_address'];
          setState(() {
            locationController.text = address;
            existingLatitude = position.latitude;
            existingLongitude = position.longitude;
          });
        } else {
          _showSnackBar('No address found for the location.');
        }
      } else {
        _showSnackBar('Failed to fetch address from Google API.');
      }
    } catch (e) {
      _showSnackBar('Unable to get address for the location: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  Future<void> submitFireReport(BuildContext context) async {
    if (_isSubmitting) return;
    
    setState(() => _isSubmitting = true);
    
    final submitReportProvider = Provider.of<SubmitReportProvider>(
      context,
      listen: false,
    );

    double? latitude = existingLatitude;
    double? longitude = existingLongitude;

    if (latitude == null || longitude == null) {
      _showSnackBar('Coordinates are missing, cannot submit report.');
      setState(() => _isSubmitting = false);
      return;
    }

    if (_formKey.currentState!.validate()) {
      try {
        await submitReportProvider.submitFireReportUnauthenticated(
          context,
          formKey: _formKey,
          locationController: locationController,
          landmarkController: landmarkController,
          descriptionController: descriptionController,
          contactinfoController: contactinfoController,
          clearFields: () {
            setState(() {
              descriptionController.clear();
              locationController.clear();
              landmarkController.clear();
              contactinfoController.clear();
              _image = null;
            });
          },
          geocodedLocation: null,
          existingLatitude: latitude,
          existingLongitude: longitude,
        );

        _showSnackBar('Report submitted successfully!');
      } catch (e) {
        _showSnackBar('Error submitting fire report. Please try again.');
      }
    } else {
      _showSnackBar('Please fill out all required fields.');
    }
    
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Report', 
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[800],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red[800]!,
              Colors.red[600]!,
              Colors.red[400]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Fire Emergency',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please provide accurate details to help emergency responders',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 30),

                // Location
                _buildSectionHeader('Location'),
                _buildLocationField(),

                // Landmark
                _buildSectionHeader('Landmark'),
                _buildTextField(
                  controller: landmarkController,
                  hintText: 'Enter nearest landmark...',
                  icon: Icons.location_city,
                ),

                // Description
                _buildSectionHeader('Description'),
                _buildTextField(
                  controller: descriptionController,
                  hintText: 'Brief description of the emergency...',
                  icon: Icons.description,
                  maxLines: 3,
                ),

                // Contact Info
                _buildSectionHeader('Contact Information'),
                _buildTextField(
                  controller: contactinfoController,
                  hintText: 'Your name & contact number',
                  icon: Icons.person,
                ),

                // Image upload
                _buildSectionHeader('Upload Image (optional)'),
                _buildImageUploadSection(),

                SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: locationController,
            hintText: 'Enter fire location...',
            icon: Icons.location_on,
          ),
        ),
        SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.my_location, color: Colors.red[800]),
            onPressed: _getCurrentLocation,
            tooltip: 'Use current location',
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(icon, color: Colors.red[800]),
          filled: true,
          fillColor: Colors.white,
        ),
        style: GoogleFonts.poppins(color: Colors.black),
        cursorColor: Colors.red[800],
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.photo_camera, color: Colors.red[800]),
            label: Text(
              'Select from Gallery',
              style: GoogleFonts.poppins(
                color: Colors.red[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        if (_image != null) ...[
          SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_image!.path),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () => setState(() => _image = null),
            child: Text(
              'Remove Image',
              style: GoogleFonts.poppins(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : () => submitFireReport(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          child: _isSubmitting
              ? CircularProgressIndicator(color: Colors.red[800])
              : Text(
                  'SUBMIT REPORT',
                  style: GoogleFonts.poppins(
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}