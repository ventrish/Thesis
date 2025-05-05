import 'package:fire_response_app/pages/auth%20pages/forgotpassword.dart';
import 'package:fire_response_app/pages/auth%20pages/register.dart';
import 'package:fire_response_app/pages/emergency_page/emergency_report.dart';
import 'package:fire_response_app/pages/firefighters%20pages/firefighters_home.dart';
import 'package:fire_response_app/pages/public%20users%20pages/civilians_home.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(35, 60, 35, 20),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Colors.red.shade800, Colors.black87],
          //     begin: Alignment.topCenter,
          //     end: Alignment.bottomCenter,
          //   ),
          // ),
          child: Column(
            children: [
              // Align widget to correctly position the 'Login' text
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    color: Colors.black, // Ensure the text color is visible
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please sign in to continue.',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                    color: Colors.black, // Ensure the text color is visible
                  ),
                ),
              ),
              const SizedBox(height: 40),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.email_outlined),
                    hintText: "Enter your email",
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintText: "Enter your password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgotpassword()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // LOGIN BUTTON WITH LOADING STATE
              _isLoading
                  ? CircularProgressIndicator(color: Colors.black)
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();

                          if (emailController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Please enter both email and password",
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          String? result = await authProvider.login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          if (result == null) {
                            String userRole = authProvider.userRole;

                            if (userRole == "firefighter") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FirefightersHome(),
                                ),
                              );
                            } else if (userRole == "civilian") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CiviliansHomePage(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Unknown user role: $userRole"),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(result)));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(160, 40),
                          backgroundColor: Colors.white,
                        ),
                        
                        child: Row(
                          children: [
                            Text(
                              "LOGIN",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(width: 15),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              const SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign Up.",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.black)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider(color: Colors.black)),
                ],
              ),

              const SizedBox(height: 40),
              // EMERGENCY BUTTON
              Container(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmergencyReport(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      'REPORT A FIRE EMERGENCY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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