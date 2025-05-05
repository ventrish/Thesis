import 'package:fire_response_app/pages/components/bottom_nav.dart';
import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_stations.dart';
import 'package:fire_response_app/pages/public%20users%20pages/profile.dart';
import 'package:fire_response_app/pages/public%20users%20pages/report_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fire_response_app/provider/fire_report_provider.dart';
import 'package:intl/intl.dart';

class FireReports extends StatefulWidget {
  const FireReports({super.key});

  @override
  State<FireReports> createState() => _FireReportsState();
}

class _FireReportsState extends State<FireReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FireReportProvider>().fetchFireReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final fireReportProvider = context.watch<FireReportProvider>();
    fireReportProvider.sortByDate();

    int selectedIndex = 1;

    void onItemTapped(int index) {
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
    }

    return Scaffold(
      appBar: AppBar(title: Text('Fire Reports')),
      body:
          fireReportProvider.fireReports.isEmpty
              ? Center(child: Text("No fire reports available."))
              : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 25, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Container(
                              height: 45, // Tinitiyak na may tamang height
                              decoration: BoxDecoration(
                                color:
                                    Colors
                                        .white, // (Optional) Lagyan ng background para kita ang border
                                borderRadius: BorderRadius.circular(
                                  50,
                                ), // Siguraduhin na gumagana
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ), // Outline border
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search report ...',
                                  border:
                                      InputBorder
                                          .none, // Tanggalin ang default border
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search, size: 40),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[300],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Location",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Actions",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fireReportProvider.fireReports.length,
                      itemBuilder: (context, index) {
                        final report = fireReportProvider.fireReports[index];

                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    report.location,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    DateFormat(
                                      'MM/dd/yyyy',
                                    ).format(report.createdAt),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    report.status,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          report.status == "Ongoing"
                                              ? Colors.red
                                              : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        fireReportProvider.selectReport(
                                          report,
                                        ); // Select the report
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ReportDetails(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "View Details",
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
      bottomNavigationBar: BottomNav(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
