import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: FirstPage()));

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('First Page')),
    drawer: AppDrawer(),
    body: Center(child: Text('Awais', style: TextStyle(fontSize: 24))),
  );
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Second Page')),
    drawer: AppDrawer(),
    body: Center(
      child: ElevatedButton(onPressed: () {}, child: Text('Press Me')),
    ),
  );
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Third Page')),
    drawer: AppDrawer(),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Awais', style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: Text('Press Me')),
        ],
      ),
    ),
  );
}

class FourthPage extends StatefulWidget {
  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final List<String> names = ['Awais', 'Amir', 'Azeem', 'Asad', 'Umar'];
  int index = 0;

  void toggleName() => setState(() => index = (index + 1) % names.length);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Fourth Page')),
    drawer: AppDrawer(),
    body: Center( 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(names[index], style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
          ElevatedButton(onPressed: toggleName, child: Text('Toggle Name')),
        ],
      ),
    ),
  );
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Menu',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        for (var page in [FirstPage(), SecondPage(), ThirdPage(), FourthPage()])
          ListTile(
            title: Text(
              page.runtimeType.toString().replaceAll('Page', ' Page'),
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                ),
          ),
      ],
    ),
  );
}
