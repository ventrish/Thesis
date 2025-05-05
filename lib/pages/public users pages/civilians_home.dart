import 'package:fire_response_app/pages/components/bottom_nav.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_reports.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_stations.dart';
import 'package:fire_response_app/pages/public%20users%20pages/profile.dart';
import 'package:fire_response_app/pages/public%20users%20pages/submit_report.dart';
import 'package:flutter/material.dart';

class CiviliansHomePage extends StatefulWidget {
  const CiviliansHomePage({super.key});

  @override
  State<CiviliansHomePage> createState() => _CiviliansHomePageState();
}

class _CiviliansHomePageState extends State<CiviliansHomePage> {
  final TextEditingController searchController = TextEditingController();
  int selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fire Response App')),
      backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 20, 60),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color:
                              Colors
                                  .white, // (Optional) Lagyan ng background para kita ang border
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ), // Outline border
                        ),
                        child: TextFormField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search the Nearest Fire Station...',
                            border: InputBorder.none,
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubmitReportPage()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(
                      seconds: 3,
                    ), // Duration for the gradient animation
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // Inside color of the container
                    ),
                    child: ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: [Colors.red, Colors.yellow, Colors.green],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 130, // Limit text width
                    child: Text(
                      "Report A Fire Emergency",
                      textAlign: TextAlign.center,
                      maxLines: 2, // Limit the text to 2 lines
                      softWrap: true, // Allow text to wrap within the container
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
            GestureDetector(
              onTap: () {
                // Handle the tap event (e.g., trigger emergency alert)
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 85,
                    decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    // Limit text width
                    width: 200, // Mas maliit sa bilog para may margin
                    child: Text(
                      "Fire Responders are on the way. ETA: 5 mins",
                      textAlign: TextAlign.center,
                      maxLines: 3, // Limit sa 2 lines para hindi lumagpas
                      softWrap: true, // Para mag-wrap yung text
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('Hold 5 seconds'),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 15, 8),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.red[600],
              tooltip: 'Report a Fire',
              child: Icon(Icons.sos, color: Colors.white, size: 30),
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
