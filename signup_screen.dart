import 'package:flutter/material.dart';
import 'database.dart'; // Import the DatabaseHelper
import 'display.dart'; // Import the DisplayScreen

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final _emailController =
      TextEditingController(); // Controller for email input
  final _passwordController =
      TextEditingController(); // Controller for password input

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Form'), // Title of the screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the form
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            children: [
              // Email input field
              TextFormField(
                controller: _emailController, // Assign the email controller
                decoration: InputDecoration(
                  labelText: 'Email', // Label for the email field
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email'; // Validation message
                  }
                  return null;
                },
              ),
              // Password input field
              TextFormField(
                controller:
                    _passwordController, // Assign the password controller
                decoration: InputDecoration(
                  labelText: 'Password', // Label for the password field
                ),
                obscureText: true, // Hide the password text
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password'; // Validation message
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Add some spacing
              // Submit button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print('Form is valid'); // Debugging
                    // If the form is valid, save the data
                    Map<String, dynamic> user = {
                      'email': _emailController.text,
                      'password': _passwordController.text,
                    };
                    try {
                      // Insert the user data into SQLite
                      await DatabaseHelper().insertUser(user);
                      print('User inserted successfully'); // Debugging
                      print('Navigating to DisplayScreen'); // Debugging
                      // Navigate to the DisplayScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayScreen(),
                        ),
                      );
                    } catch (e) {
                      print('Error inserting user: $e'); // Debugging
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  } else {
                    print('Form is invalid'); // Debugging
                  }
                },
                child: Text('Submit'), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
