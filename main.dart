import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding
import 'output_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isActive = false;
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  /// Load saved data from SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedUsers = prefs.getString('users');

    if (savedUsers != null) {
      setState(() {
        users = List<Map<String, dynamic>>.from(jsonDecode(savedUsers));
      });
    }
  }

  /// Save user data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', jsonEncode(users));
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        users.add({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'isActive': _isActive,
        });
      });

      _saveData(); // Save updated data

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _isActive = false;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutputPage(users: users, onDelete: _deleteUser),
        ),
      );
    }
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });

    _saveData(); // Save updated data after deletion

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OutputPage(users: users, onDelete: _deleteUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your name'
                                : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your email'
                                : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Please enter your password'
                                : null,
                  ),
                  Row(
                    children: [
                      Text("Active"),
                      Radio(
                        value: true,
                        groupValue: _isActive,
                        onChanged:
                            (value) =>
                                setState(() => _isActive = value as bool),
                      ),
                      Text("Inactive"),
                      Radio(
                        value: false,
                        groupValue: _isActive,
                        onChanged:
                            (value) =>
                                setState(() => _isActive = value as bool),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: _submitData, child: Text('Submit')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
