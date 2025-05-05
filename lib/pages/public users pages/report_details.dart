import 'package:fire_response_app/pages/public%20users%20pages/edit_report_details.dart';
import 'package:fire_response_app/provider/fire_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_time_ago/get_time_ago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

class ReportDetails extends StatefulWidget {
  const ReportDetails({super.key});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  Widget build(BuildContext context) {
    final fireReportProvider = context.watch<FireReportProvider>();
    final report = fireReportProvider.selectedReport;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Report Details")),
        body: Center(child: Text("No report selected.")),
      );
    }

    String relativeTime = timeago.GetTimeAgo.parse(report.createdAt);

Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.right,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ),
    ],
  );
}


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: Colors.black87), // or any icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Report Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB), // light gray background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                SizedBox(height: 20),
                _buildInfoRow("Location", report.location),
                Divider(height: 28, thickness: 1, color: Colors.grey[300]),
                _buildInfoRow("Reported", relativeTime),
                Divider(height: 28, thickness: 1, color: Colors.grey[300]),
                _buildInfoRow(
                  "Status",
                  report.status,
                  valueColor: report.status == 'Pending'
                      ? Colors.orange[800]
                      : Colors.green[700],
                ),
                SizedBox(height: 32),
                if (report.status == 'Pending')
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.edit, size: 20),
                      label: Text(
                        "Edit Report",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditDetails(report: report),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
