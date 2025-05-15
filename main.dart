import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      debugShowCheckedModeBanner: false,
      home: LocalImagesScreen(),
      routes: {
        '/global': (context) => GlobalImagesScreen(),
      },
    );
  }
}

// Screen 1: Local Images (Vertical)
class LocalImagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Images (Vertical)'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pushNamed(context, '/global');
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset('assets/amir.jpeg', height: 200),
          SizedBox(height: 16),
          Image.asset('assets/download.jpeg', height: 200),
          SizedBox(height: 16),
          Image.asset('assets/SEO.png', height: 200),
        ],
      ),
    );
  }
}

// Screen 2: Global Images (Horizontal)
class GlobalImagesScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/id/1018/300/200',
    'https://picsum.photos/id/1015/300/200',
    'https://picsum.photos/id/1020/300/200',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global Images (Horizontal)'),
      ),
      body: Container(
        height: 220,
        padding: EdgeInsets.all(16),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: imageUrls.length,
          separatorBuilder: (context, index) => SizedBox(width: 16),
          itemBuilder: (context, index) {
            return Image.network(imageUrls[index]);
          },
        ),
      ),
    );
  }
}
