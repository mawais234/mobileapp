import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const StudentProfileApp());
}

class StudentProfileApp extends StatelessWidget {
  const StudentProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFD2B48C), // Skin color
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Inter',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFF1E1E1E),
          labelStyle: const TextStyle(color: Color(0xFFD2B48C)),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const StudentProfileScreen(),
    );
  }
}

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final List<String> _subjects = [
    'Artificial Intelligence',
    'Database',
    'Compiler Construction',
    'MobileApp',
    'Information Security'
  ];
  final List<Map<String, dynamic>> _selectedSubjects = [];
  final TextEditingController _marksController = TextEditingController();
  String? _selectedSubject;
  double _percentage = 0.0;
  String _grade = 'N/A';
  bool _showResults = false;

  // [Keep all your existing methods unchanged...]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Student Profile',
            style: TextStyle(color: Color(0xFFD2B48C))),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFFD2B48C)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildMarksInputCard(),
            if (_showResults) ...[
              const SizedBox(height: 24),
              _buildResultsBox(),
            ],
            const SizedBox(height: 24),
            if (_selectedSubjects.isNotEmpty) _buildSubjectsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD2B48C).withOpacity(0.3),
              border: Border.all(
                color: const Color(0xFFD2B48C),
                width: 2,
              ),
            ),
            child: Icon(Icons.person, size: 40, color: const Color(0xFFD2B48C)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  " M Awais",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD2B48C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  " BSCS | Roll No: 34",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksInputCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Marks",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD2B48C),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(
                labelText: "Subject",
                prefixIcon:
                    Icon(Icons.menu_book, color: const Color(0xFFD2B48C)),
              ),
              items: _subjects
                  .map((subject) => DropdownMenuItem(
                        value: subject,
                        child: Text(subject,
                            style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedSubject = value),
              isExpanded: true,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _marksController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Marks (0-100)",
                prefixIcon: Icon(Icons.grade, color: const Color(0xFFD2B48C)),
                suffixText: "/100",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addSubject,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2B48C),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Add Marks",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD2B48C).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Your Results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD2B48C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Percentage",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFD2B48C),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      "${_percentage.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD2B48C),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Grade",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _getGradeColor(_grade),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _grade,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsList() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Subjects",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD2B48C),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: _selectedSubjects
                  .map((subject) => _buildSubjectTile(subject))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(Map<String, dynamic> subject) {
    final marks = subject['marks'] as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD2B48C).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD2B48C),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.school,
              color: const Color(0xFFD2B48C),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              subject['subject'],
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            "$marks",
            style: TextStyle(
              color: _getMarksColor(marks),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMarksColor(int marks) {
    if (marks < 40) return Colors.red[400]!;
    if (marks < 75) return const Color(0xFFD2B48C);
    return Colors.green[400]!;
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green[400]!;
      case 'A':
        return Colors.green[300]!;
      case 'B':
        return const Color(0xFFD2B48C);
      case 'C':
        return Colors.orange[300]!;
      case 'D':
        return Colors.orange[400]!;
      case 'E':
        return Colors.red[300]!;
      case 'F':
        return Colors.red[400]!;
      default:
        return const Color(0xFFD2B48C);
    }
  }

  // [Keep all your existing methods unchanged...]
  void _addSubject() {
    if (_selectedSubject == null) {
      _showError('Please select a subject');
      return;
    }

    if (_marksController.text.isEmpty) {
      _showError('Please enter marks');
      return;
    }

    final marks = int.tryParse(_marksController.text);
    if (marks == null || marks < 0 || marks > 100) {
      _showError('Invalid marks (0-100 only)');
      return;
    }

    setState(() {
      _selectedSubjects.add({
        'subject': _selectedSubject,
        'marks': marks,
      });
      _calculatePercentageAndGrade();
      _marksController.clear();
      _selectedSubject = null;
      _showResults = true;
    });
  }

  void _calculatePercentageAndGrade() {
    if (_selectedSubjects.isEmpty) {
      setState(() {
        _percentage = 0.0;
        _grade = 'N/A';
      });
      return;
    }

    final total = _selectedSubjects.fold<int>(
        0, (sum, item) => sum + (item['marks'] as int));
    final percentage = (total / (_selectedSubjects.length * 100)) * 100;

    String grade;
    if (percentage >= 90) {
      grade = 'A+';
    } else if (percentage >= 80) {
      grade = 'A';
    } else if (percentage >= 70) {
      grade = 'B';
    } else if (percentage >= 60) {
      grade = 'C';
    } else if (percentage >= 50) {
      grade = 'D';
    } else if (percentage >= 40) {
      grade = 'E';
    } else {
      grade = 'F';
    }

    setState(() {
      _percentage = percentage;
      _grade = grade;
    });
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red[700],
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
