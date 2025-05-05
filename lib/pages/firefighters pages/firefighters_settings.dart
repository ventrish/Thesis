import 'package:fire_response_app/pages/auth%20pages/login.dart';
import 'package:fire_response_app/pages/components/bottom_nav_ff.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_fire_reports.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/change_password.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:fire_response_app/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

class FirefightersSettings extends StatefulWidget {
  const FirefightersSettings({super.key});

  @override
  State<FirefightersSettings> createState() => _FirefightersSettingsState();
}

class _FirefightersSettingsState extends State<FirefightersSettings> {
  bool notif = true;
  bool theme = false;
  final int selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // KUNIN ANG TOKEN MULA SA AUTH PROVIDER
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userToken =
        authProvider.token; // Siguraduhin kung saan mo sinesave ang token

    if (userToken != null) {
      userProvider.fetchUserData(userToken); // Huwag na gumamit ng user ID
    } else {
      print("No token found. User not authenticated.");
    }
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
    final userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromRGBO(240, 248, 255, 1.0),
          centerTitle: true,
          title: Text(
            'User Profile',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          )),
      backgroundColor: Color.fromRGBO(240, 248, 255, 1.0),
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            ) // Show loader until data loads
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon(Icons.person, size: 30),
                      // SizedBox(width: 7),
                      // Text(
                      //   'User Profile',
                      //   style: TextStyle(
                      //     fontSize: 24,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'lib/images/pfp.jpg',
                        width: 150.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '${user.firstName} ${user.lastName}',
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ),

                  //Container for user details
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 251, 253),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Email: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: user.email,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),
                        const SizedBox(height: 10),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Address: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: user.address,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),
                        const SizedBox(height: 10),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Contact Number: ',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: user.contactNumber,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(),
                        const SizedBox(height: 5),

                        // Edit Profile Row
                        InkWell(
                          onTap: () {
                            // Navigate to Edit Profile
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Edit Profile',
                                  style: GoogleFonts.poppins(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // Change Password Row
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Change Password',
                                  style: GoogleFonts.poppins(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                          ),
                        ),

                        //Notifications Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.notifications,
                                    color: Colors.black, size: 22),
                                SizedBox(width: 6),
                                Text('Notifications',
                                    style: TextStyle(fontSize: 22)),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: notif,
                                onChanged: (bool value) {
                                  setState(() {
                                    notif = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),

                        // Theme Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.brightness_4_outlined,
                                    color: Colors.black, size: 22),
                                SizedBox(width: 6),
                                Text('Theme', style: TextStyle(fontSize: 22)),
                              ],
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: theme,
                                onChanged: (bool value) {
                                  setState(() {
                                    theme = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Logout Button
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900],
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.2,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              bool confirmLogout = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    titlePadding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 8),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        24, 0, 24, 20),
                                    actionsPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    title: Row(
                                      children: [
                                        const Icon(Icons.logout,
                                            color: Color.fromARGB(255, 183, 28, 28)),
                                        const SizedBox(width: 12),
                                        const Text(
                                          "Log Out",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      "Are you sure you want to log out from your account?",
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.end,
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              GoogleFonts.poppins(fontSize: 15),
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: Color.fromARGB(255, 183, 28, 28),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: const Text("Logout"),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmLogout == true) {
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );
                                await authProvider.logout();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Logged out successfully"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.exit_to_app_rounded,
                                    color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Logout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // EndLogout Button
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  // const Divider(),
                  // const SizedBox(height: 10),

                  // // Settings Label
                  // const Row(
                  //   children: [
                  //     Icon(Icons.settings, size: 30),
                  //     SizedBox(width: 7),
                  //     Text(
                  //       'Settings',
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w700,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 15),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavFF(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
