import 'package:flutter/material.dart';
import 'data_management_screen.dart'; // Ensure this file exists

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Management App',
      debugShowCheckedModeBanner: false, // ✅ Hides the DEBUG banner
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DataManagementScreen(), // Main screen of the app
    );
  }
}
