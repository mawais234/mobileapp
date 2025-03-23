import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Ensure this file exists

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Flutter SQLite Signup',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignupScreen(), // Ensure SignupScreen is correctly implemented
    );
  }
}
