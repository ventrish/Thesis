// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:fire_response_app/pages/auth%20pages/login.dart';
// import 'package:fire_response_app/pages/firefighters%20pages/firefighters_home.dart';
// import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';
// import 'package:fire_response_app/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       width: 100,
//       child: AnimatedSplashScreen(
//         backgroundColor: Colors.red,
//         splash: SingleChildScrollView(
//           child: Column(
//             children: [
//               Center(
//                 child: Lottie.asset(
//                   'assets/animations/Animation - 1746015078938.json',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         nextScreen: FutureBuilder(
//           future:
//               Provider.of<AuthProvider>(
//                 context,
//                 listen: false,
//               ).loadUserSession(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             }

//             final authProvider = Provider.of<AuthProvider>(context);

//             if (authProvider.isLoggedIn) {
//               return authProvider.userRole == "firefighter"
//                   ? FirefightersHome()
//                   : CiviliansHomePage();
//             } else {
//               return LoginPage();
//             }
//           },
//         ),
//         duration: 3500,
//       ),
//     );
//   }
// }
