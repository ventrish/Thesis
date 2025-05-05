import 'package:fire_response_app/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fire_response_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _birthDateController;

  @override
  void initState() {
    super.initState();
    // Get the current user data from the provider
    final user = Provider.of<UserProvider>(context, listen: false).currentUser;

    // Initialize text controllers with current user data
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _contactController = TextEditingController(text: user?.contactNumber ?? '');
    _birthDateController = TextEditingController(text: user?.birthDate ?? '');
  }

  Future<void> _pickBirthdate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _birthDateController.text =
            '${picked.toLocal()}'.split(' ')[0]; // Format as yyyy-MM-dd
      });
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        id:
            Provider.of<UserProvider>(context, listen: false).currentUser?.id ??
            0,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        contactNumber: _contactController.text.trim(),
        birthDate: _birthDateController.text,
      );

      // 👉 Load token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Session expired. Please log in again.")),
        );
        return;
      }

      // 👉 Call updateUser with the token
      final success = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).updateUser(updatedUser, token);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully.")),
        );
        Navigator.pop(context); // 👈 Go back to profile page
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update profile.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator:
                    (value) => value!.isEmpty ? 'Enter first name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact Number'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(labelText: 'Birthdate'),
                readOnly: true, // Make it read-only so user can't type in it
                onTap: _pickBirthdate, // Trigger date picker on tap
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Save Changes?'),
                          // content: Text(
                          //   'Are you sure you want to change your password?',
                          // ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                ); // ❌ Cancel - close dialog
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _saveChanges();
                                Navigator.pop(
                                  context,
                                ); // ✅ Close dialog and return to profile page
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text('Save Changes', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
