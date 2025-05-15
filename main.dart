import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Portal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> subjects = [
    {
      'subject': 'Data Structures',
      'teacher': 'Mr. Ali Khan',
      'credit': '3'
    },
    {
      'subject': 'Database Systems',
      'teacher': 'Ms. Fatima',
      'credit': '4'
    },
    {
      'subject': 'Operating Systems',
      'teacher': 'Mr. Usman',
      'credit': '3'
    },
    {
      'subject': 'Web Development',
      'teacher': 'Ms. Ayesha',
      'credit': '3'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Welcome Student!',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Pakistan Flag'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlagScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/home_image.png',
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.book, color: Colors.green),
                    title: Text(subject['subject']!),
                    subtitle: Text(
                        'Teacher: ${subject['teacher']} | Credit Hours: ${subject['credit']}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlagScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pakistan Flag'),
      ),
      body: Center(
        child: Image.asset(
          'assets/pakistan_flag.png',
          width: 300,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
