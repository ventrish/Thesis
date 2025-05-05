import 'package:fire_response_app/pages/auth%20pages/login.dart';
import 'package:fire_response_app/pages/components/bottom_nav.dart';
import 'package:fire_response_app/pages/public%20users%20pages/change_password.dart';
import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/edit_profile.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_reports.dart';
import 'package:fire_response_app/pages/public%20users%20pages/fire_stations.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:fire_response_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool notif = true;
  bool theme = false;
  final int _selectedIndex = 3;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

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

  // @override
  // void initState() {
  //   super.initState();
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   // 🔥 Load user session before fetching data
  //   authProvider.loadUserSession().then((_) {
  //     if (authProvider.token != null) {
  //       userProvider.fetchUserData(authProvider.token!);
  //     } else {
  //       print("❌ Error: No token found.");
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (authProvider.token != null) {
        await userProvider.fetchUserData(authProvider.token!);
      } else {
        print("No token found.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body:
          user == null
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Loading state
              : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.person, size: 30),
                        SizedBox(width: 7),
                        Text(
                          'User Profile',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'lib/images/pfp.jpg', // Palitan kung may profile picture ang user
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Address: ${user.address}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Contact Number: ${user.contactNumber}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => EditProfile(user: user),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ChangePassword(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.settings, size: 30),
                        SizedBox(width: 7),
                        Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.notifications,
                              color: Colors.black,
                              size: 22,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Notifications',
                              style: TextStyle(fontSize: 22),
                            ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.brightness_4_outlined,
                              color: Colors.black,
                              size: 22,
                            ),
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
                    const SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
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
                                title: const Text("Confirm Logout"),
                                content: const Text(
                                  "Are you sure you want to log out?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(false); // Cancel logout
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pop(true); // Confirm logout
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.red),
                                    ),
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
