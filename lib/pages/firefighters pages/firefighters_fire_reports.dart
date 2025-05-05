import 'package:fire_response_app/pages/components/bottom_nav_ff.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_home.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_settings.dart';
import 'package:fire_response_app/provider/firefighter_reports_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class FirefightersFireReports extends StatefulWidget {
  const FirefightersFireReports({super.key});

  @override
  State<FirefightersFireReports> createState() =>
      _FirefightersFireReportsState();
}

class _FirefightersFireReportsState extends State<FirefightersFireReports> {
  final TextEditingController searchController = TextEditingController();
  final int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // Fetching fire reports when the page loads
    Provider.of<FirefighterReportsProvider>(
      context,
      listen: false,
    ).fetchFireReports();
  }

  void onItemTapped(int index) {
    if (index == selectedIndex) return;

    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = FirefightersHome();
        break;
      case 1:
        nextPage = FirefightersFireReports();
        break;
      case 2:
        nextPage = FirefightersSettings();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fireReportProvider = Provider.of<FirefighterReportsProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(242, 248, 252, 1.0),
          centerTitle: true,
          title: Text(
            'Firefighter Reports',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      backgroundColor: const Color.fromRGBO(242, 248, 252, 1.0),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
  children: [
    Expanded(
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 248, 255, 1.0),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Search reports...',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
          style: TextStyle(fontSize: 16),
        ),
      ),
    ),
    const SizedBox(width: 10), // space between search box and calendar icon
    Container(
      
      child: IconButton(
        icon: Icon(Icons.calendar_month_outlined, color: Colors.grey[800], size: 22),
        onPressed: () {
          // Filter action
        },
        tooltip: 'Filter by date',
      ),
    ),
  ],
)

                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(240, 248, 255, 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    "Type",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Date",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Actions",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: fireReportProvider.fireReports.isEmpty
                ? Center(
                    child: fireReportProvider.isLoading
                        ? CircularProgressIndicator() // Show loading indicator if fetching
                        : Text(
                            "No data available",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ), // Show no data message
                  )
                : ListView.builder(
                    itemCount: fireReportProvider.fireReports.length,
                    itemBuilder: (context, index) {
                      final report = fireReportProvider.fireReports[index];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        color: const Color.fromRGBO(240, 248, 255, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: const Color.fromARGB(255, 12, 12, 12), // Border color
                            width: 1, // Border width
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  report.reportType,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  report.createdAt,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      // Navigate to detailed report
                                    },
                                    child: Text(
                                      "View Details",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color:  Colors.red[900],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavFF(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
