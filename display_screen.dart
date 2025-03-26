import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const DisplayScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Username: ${user['username']}'),
            Text('Email: ${user['email']}'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
