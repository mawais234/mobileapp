import 'package:flutter/material.dart';
import 'database.dart'; // Import the DatabaseHelper

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  List<Map<String, dynamic>> _users = []; // List to store user data

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users when the screen is initialized
  }

  // Method to load users from the database
  Future<void> _loadUsers() async {
    List<Map<String, dynamic>> users = await DatabaseHelper().getUsers();
    setState(() {
      _users = users; // Update the state with the retrieved users
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Users'), // Title of the screen
      ),
      body:
          _users.isEmpty
              ? Center(
                child: Text(
                  'No users found.', // Display if no users are found
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: _users.length, // Number of users to display
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Email: ${_users[index]['email']}',
                    ), // Display email
                    subtitle: Text(
                      'Password: ${_users[index]['password']}',
                    ), // Display password
                  );
                },
              ),
    );
  }
}
