import 'package:fire_response_app/provider/fire_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/models/fire_reports.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart' as timeago;

class EditDetails extends StatefulWidget {
  final FireReport report; // Receive the report data

  const EditDetails({super.key, required this.report});

  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final landmarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the selected report's data
    descriptionController.text = widget.report.description;
    locationController.text = widget.report.location;
    landmarkController.text = widget.report.landmark;
  }

  @override
  void dispose() {
    // Don't forget to dispose controllers when done to avoid memory leaks
    descriptionController.dispose();
    locationController.dispose();
    landmarkController.dispose();
    super.dispose();
  }

  // Function to show the confirmation dialog before saving
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.help_outline,
            size: 48,
            color: Colors.orange[700],
          ),
          SizedBox(height: 16),
          Text(
            'Save Changes?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Do you want to save the changes made to this report?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                  side: BorderSide(color: Colors.grey.shade400),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  FireReport updatedReport = FireReport(
                    id: widget.report.id,
                    reportedBy: widget.report.reportedBy,
                    fireStationId: widget.report.fireStationId,
                    location: locationController.text,
                    landmark: landmarkController.text,
                    description: descriptionController.text,
                    createdAt: widget.report.createdAt,
                    status: widget.report.status,
                  );

                  context.read<FireReportProvider>().updateFireReport(
                        context.read<FireReportProvider>().fireReports.indexOf(
                              widget.report,
                            ),
                        updatedReport,
                      );

                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back
                },
                child: Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  },
);

  }

  @override
  Widget build(BuildContext context) {
    // DateTime dateTime = DateTime.parse(widget.report.createdAt);
    String relativeTime = timeago.GetTimeAgo.parse(widget.report.createdAt);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                color: Colors.black87), // or any icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
          title: Text("Edit Details")),
      backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 3),
              TextFormField(
                controller: locationController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text(
                "Landmark",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 3),
              TextFormField(
                controller: landmarkController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 3),
              TextFormField(
                controller: descriptionController,
                minLines: 4,
                maxLines: null, // Makes it grow with input
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reported:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    relativeTime,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Status:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    widget.report.status,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: widget.report.status == 'Pending'
                          ? Colors.orange[800]
                          : Colors.green[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 28, 28),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 90, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _showConfirmationDialog();
                  },
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
