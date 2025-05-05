import 'package:fire_response_app/pages/auth%20pages/login.dart';
import 'package:fire_response_app/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  // String hashPassword(String password) {
  //   final bytes = utf8.encode(password); // Convert to bytes
  //   final hashed = sha256.convert(bytes); // Hash using SHA-256
  //   return hashed.toString();
  // }

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

bool _isLoading = false;

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isObscured = true;
  bool _isObscuredConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black), // Back arrow
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: EdgeInsets.fromLTRB(35, 20, 35, 60),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                    color: Colors.black, // Ensure the text color is visible
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.person_2_outlined),
                    hintText: "Enter your first name",
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.person_2_outlined),
                    hintText: "Enter your last name",
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
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
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.home_outlined),
                    hintText: "Enter your address",
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),

              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
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
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 187, 161, 161),
                      blurRadius: 6,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14),
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    hintText: "Confirm your password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscuredConfirm = !_isObscuredConfirm;
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
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed:
                    _isLoading
                        ? null
                        : () async {
                          FocusScope.of(context).unfocus();

                          if (firstNameController.text.trim().isEmpty ||
                              lastNameController.text.trim().isEmpty ||
                              emailController.text.trim().isEmpty ||
                              passwordController.text.trim().isEmpty ||
                              confirmPasswordController.text.trim().isEmpty ||
                              addressController.text.trim().isEmpty) {
                            _showErrorDialog("Please fill out all fields");
                            return;
                          }

                          if (passwordController.text.trim() !=
                              confirmPasswordController.text.trim()) {
                            _showErrorDialog("Passwords do not match");
                            return;
                          }

                          setState(() => _isLoading = true); // 🔥 START loading

                          final authProvider = Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          );

                          String? result = await authProvider.register(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            confirmPassword:
                                confirmPasswordController.text.trim(),
                            firstname: firstNameController.text.trim(),
                            lastname: lastNameController.text.trim(),
                            address: addressController.text.trim(),
                          );

                          setState(() => _isLoading = false); // 🔥 END loading

                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration Successful!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            await Future.delayed(Duration(seconds: 2));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          } else {
                            _showErrorDialog(result);
                          }
                        },

                style: ElevatedButton.styleFrom(minimumSize: Size(170, 40)),
                child:
                    _isLoading
                        ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                        : Text(
                          "SIGN UP",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 18,
                          ),
                        ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to Sign Up Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Login to your account",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("Registration Failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }
}
