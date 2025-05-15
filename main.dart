import 'package:flutter/material.dart';
import 'text_to_qr.dart';
import 'qr_to_text.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Utility')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Convert Text to QR Code'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => TextToQrScreen()));
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Convert QR Code to Text'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => QrToTextScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
