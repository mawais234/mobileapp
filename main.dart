import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentPage(), // Removed 'const'
      routes: {
        '/math': (context) => const MathPage(),
      },
    );
  }
}

class StudentPage extends StatelessWidget {
  StudentPage({super.key}); // Removed 'const' because of the list

  final List<Map<String, String>> students = [
    {"name": "M.ZEESHAN", "roll": "M31", "department": "Computer Science"},
    {"name": "M.AWAIS", "roll": "M34", "department": "Computer Science"},
    {"name": "AZ SHAKIR", "roll": "M08", "department": "Computer Science"},
    {"name": "ASAD MUSTAFA", "roll": "M12", "department": "Computer Science"},
    {"name": "UMAR FAROOQ", "roll": "M01", "department": "Computer Science"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Data'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Roll No')),
                    DataColumn(label: Text('Department')),
                  ],
                  rows: students
                      .map((student) => DataRow(cells: [
                            DataCell(Text(student['name']!)),
                            DataCell(Text(student['roll']!)),
                            DataCell(Text(student['department']!)),
                          ]))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/math');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Go to Math Operations'),
            ),
          ],
        ),
      ),
    );
  }
}

class MathPage extends StatefulWidget {
  const MathPage({super.key});

  @override
  _MathPageState createState() => _MathPageState();
}

class _MathPageState extends State<MathPage> {
  double operand1 = 0;
  double operand2 = 0;
  String operation = '';
  String result = '';

  void calculateResult() {
    double res = 0;
    switch (operation) {
      case 'Add':
        res = operand1 + operand2;
        break;
      case 'Subtract':
        res = operand1 - operand2;
        break;
      case 'Multiply':
        res = operand1 * operand2;
        break;
      case 'Divide':
        if (operand2 != 0) {
          res = operand1 / operand2;
        } else {
          result = "Cannot divide by zero!";
        }
        break;
      default:
        res = 0;
    }
    setState(() {
      result = res.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Operations'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Math Operations",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Operand 1',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                operand1 = double.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Operand 2',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                operand2 = double.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Add';
                    });
                    calculateResult();
                  },
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Subtract';
                    });
                    calculateResult();
                  },
                  child: const Text('Subtract'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Multiply';
                    });
                    calculateResult();
                  },
                  child: const Text('Multiply'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      operation = 'Divide';
                    });
                    calculateResult();
                  },
                  child: const Text('Divide'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal, width: 2),
              ),
              child: Text(
                result.isEmpty ? 'Result will appear here' : 'Result: $result',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
