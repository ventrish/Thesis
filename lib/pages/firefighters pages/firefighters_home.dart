import 'package:fire_response_app/pages/components/assigned_incident.dart';
import 'package:fire_response_app/provider/firefighter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fire_response_app/pages/components/bottom_nav_ff.dart';
import 'package:fire_response_app/pages/firefighters%20pages/assigned_incident_details.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_fire_reports.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_settings.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:google_fonts/google_fonts.dart';

class FirefightersHome extends StatefulWidget {
  const FirefightersHome({super.key});

  @override
  State<FirefightersHome> createState() => _FirefightersHomeState();
}

class _FirefightersHomeState extends State<FirefightersHome> {
  bool _isDataFetched = false;
  // int? firefighterId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  // Load firefighterId from SharedPreferences
  Future<void> _initializeData() async {
    if (_isDataFetched) return;

    final firefighterProvider = Provider.of<FirefighterProvider>(
      context,
      listen: false,
    );

    try {
      // ✅ Get from SharedPreferences via provider
      int? firefighterId = await firefighterProvider.getSavedFirefighterId();

      if (firefighterId == null) {
        print("❌ Firefighter ID is not saved in SharedPreferences.");

        // 🚨 You probably need to get userId here, which is used to fetch firefighter details
        // Assuming you already have the userId from login, use that instead of 0
        int userId = firefighterProvider.userId ?? 0;

        await firefighterProvider.fetchFirefighterDetails(userId, context);

        firefighterId = firefighterProvider.getFirefighterId;

        if (firefighterId == null) {
          print("❌ Firefighter ID still not found after fetch.");
          return;
        } else {
          // ✅ Save the fetched ID to SharedPreferences
          await firefighterProvider.saveFirefighterId(firefighterId);
          print("✅ Firefighter ID fetched and saved: $firefighterId");
        }
      } else {
        print("✅ Firefighter ID loaded from SharedPreferences: $firefighterId");
        firefighterProvider.setFirefighterId(
          firefighterId,
        ); // Make sure provider is updated
      }

      // 🚀 Fetch assigned incident
      await firefighterProvider.fetchAssignedIncident(firefighterId);

      setState(() {
        _isDataFetched = true;
      });
    } catch (e) {
      print("🔥 Error during initialization: $e");
    }
  }

  // Retrieve firefighterId from SharedPreferences
  // Future<int?> getSavedFirefighterId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getInt('firefighterId');
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirefighterProvider>(
      builder: (context, firefighterProvider, child) {
        return Scaffold(
          appBar: AppBar(
              backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
              centerTitle: true,
              title: Text(
                'Dashboard',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              )
          ),
          backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 5, 24, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, ${firefighterProvider.firefighterName}!',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      Column(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'lib/images/pfp.jpg', // Placeholder profile image
                              height: 40,
                              width: 40,
                            ),
                          ),
                          Text(
                            firefighterProvider.firefighterRole,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Status: ${firefighterProvider.status}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    print("Card clicked!");
                    final firefighterId = firefighterProvider.getFirefighterId;
                    if (firefighterId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssignedIncidentDetails(
                            firefighterId: firefighterId,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Firefighter ID is missing! Please try again.',
                          ),
                        ),
                      );
                    }
                  },
                  
                    child: SizedBox(
                      
                      width: double.infinity,
                      height: 230,
                      child: Card(
                        elevation: 4,
                        color: Color.fromRGBO(240, 248, 255, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assigned Incident",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red[900],
                                ),
                              ),
                              const Divider(),
                              InfoRow(
                                icon: Icons.location_on,
                                label: "Location:",
                                value: firefighterProvider
                                        .assignedIncident?.location ??
                                    'Loading...',
                              ),
                              InfoRow(
                                icon: Icons.map,
                                label: "Landmark:",
                                value: firefighterProvider
                                        .assignedIncident?.landmark ??
                                    'Loading...',
                              ),
                              InfoRow(
                                icon: Icons.access_time,
                                label: "Time Reported:",
                                value: firefighterProvider
                                        .assignedIncident?.timeReported ??
                                    'Loading...',
                              ),
                              InfoRow(
                                icon: Icons.fire_truck,
                                label: "Assigned Team/s:",
                                value: firefighterProvider
                                        .assignedIncident?.teamName
                                        ?.join(', ') ??
                                    'Loading...',
                              ),
                              InfoRow(
                                icon: Icons.fire_truck,
                                label: "Team Leader/s:",
                                value: firefighterProvider.assignedIncident
                                            ?.teamLeader?.isEmpty ??
                                        true
                                    ? 'Loading...'
                                    : firefighterProvider
                                            .assignedIncident?.teamLeader
                                            ?.join(', ') ??
                                        'Loading...',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavFF(
            currentIndex: 0,
            onTap: onItemTapped,
          ),
        );
      },
    );
  }

  void onItemTapped(int index) {
    Widget nextPage;
    switch (index) {
      case 0:
        nextPage = const FirefightersHome();
        break;
      case 1:
        nextPage = const FirefightersFireReports();
        break;
      case 2:
        nextPage = const FirefightersSettings();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }
}
