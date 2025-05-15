import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TextToQrScreen extends StatefulWidget {
  @override
  _TextToQrScreenState createState() => _TextToQrScreenState();
}

class _TextToQrScreenState extends State<TextToQrScreen> {
  TextEditingController controller = TextEditingController();
  String qrData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text to QR Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Generate QR Code"),
              onPressed: () {
                setState(() {
                  qrData = controller.text;
                });
              },
            ),
            SizedBox(height: 20),
            if (qrData.isNotEmpty)
              QrImageView(
                data: qrData,
                size: 200,
              ),
          ],
        ),
      ),
    );
  }
}
