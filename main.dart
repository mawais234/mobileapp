import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Realtime DB',
      home: FirebasePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirebasePage extends StatefulWidget {
  @override
  _FirebasePageState createState() => _FirebasePageState();
}

class _FirebasePageState extends State<FirebasePage> {
  final TextEditingController _controller = TextEditingController();
  final String firebaseUrl = 'https://umeh-bf31e-default-rtdb.firebaseio.com/data.json';
  List<String> fetchedData = [];

  Future<void> submitData() async {
    final enteredText = _controller.text.trim();
    if (enteredText.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        body: json.encode(enteredText),
      );

      if (response.statusCode == 200) {
        _controller.clear();
        fetchData();
      } else {
        print('Error submitting: ${response.statusCode}');
      }
    } catch (e) {
      print('Submit error: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data != null) {
          setState(() {
            fetchedData = data.values.map((item) => item.toString()).toList();
          });
        }
      } else {
        print('Error fetching: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Realtime Database')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: submitData,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: fetchedData.isEmpty
                  ? Center(child: Text('No data available'))
                  : ListView.builder(
                itemCount: fetchedData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.data_usage),
                    title: Text(fetchedData[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
