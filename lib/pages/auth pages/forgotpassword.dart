import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final TextEditingController emailController = TextEditingController();

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
        title: Text(
          'Back to Login',
          style: TextStyle(
            color: Colors.black,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        // centerTitle: true, // Center the title text
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        padding: EdgeInsets.fromLTRB(35, 60, 35, 60),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Enter your email address',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.w800,
                  fontSize: 23,
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
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
                'Request Reset Link',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      Colors
                          .white, // Usually, white works better on dark buttons
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
