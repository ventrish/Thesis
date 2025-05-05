// import 'package:fire_response_app/provider/assigned_incident_provider.dart';
import 'package:fire_response_app/provider/firefighter_provider.dart';
import 'package:fire_response_app/provider/firefighter_reports_provider.dart';
import 'package:fire_response_app/provider/location_provider.dart';
import 'package:fire_response_app/provider/submit_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:fire_response_app/provider/fire_report_provider.dart';
import 'package:fire_response_app/provider/fire_stations_provider.dart';
import 'package:fire_response_app/provider/user_provider.dart';
import 'package:fire_response_app/theme.dart';

import 'package:fire_response_app/pages/auth%20pages/login.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create:
              (context) => FireReportProvider(
                Provider.of<AuthProvider>(context, listen: false),
              ),
        ),

        ChangeNotifierProvider(create: (context) => FireStationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => FirefighterReportsProvider(),
        ),
        ChangeNotifierProvider(create: (context) => FirefighterProvider()),
        // ChangeNotifierProvider(create: (_) => AssignedIncidentProvider()),
        ChangeNotifierProvider(create: (context) => SubmitReportProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future:
            Provider.of<AuthProvider>(context, listen: false).loadUserSession(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final authProvider = Provider.of<AuthProvider>(context);

          if (authProvider.isLoggedIn) {
            return authProvider.userRole == "firefighter"
                ? FirefightersHome()
                : CiviliansHomePage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
