import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const GradeManagerApp());
}

class GradeManagerApp extends StatelessWidget {
  const GradeManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grade Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const GradeHomeScreen(),
    );
  }
}

class GradeHomeScreen extends StatefulWidget {
  const GradeHomeScreen({super.key});

  @override
  State<GradeHomeScreen> createState() => _GradeHomeScreenState();
}

class _GradeHomeScreenState extends State<GradeHomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const SubmitGradeScreen(),
    const ViewGradesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Manager'),
        centerTitle: true,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Submit Grade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'View Grades',
          ),
        ],
      ),
    );
  }
}

class SubmitGradeScreen extends StatefulWidget {
  const SubmitGradeScreen({super.key});

  @override
  State<SubmitGradeScreen> createState() => _SubmitGradeScreenState();
}

class _SubmitGradeScreenState extends State<SubmitGradeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _semesterNoController = TextEditingController();
  final _creditsController = TextEditingController();
  final _marksController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitGrade() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await http.post(
        Uri.parse('https://devtechtop.com/management/public/api/grades'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': _userIdController.text,
          'course_name': _courseController.text,
          'semester_no': _semesterNoController.text,
          'credit_hours': _creditsController.text,
          'marks': _marksController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccess('Grade submitted successfully');
        _formKey.currentState?.reset();
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      _showError('Failed to connect to server. Please try again.');
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _handleErrorResponse(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      if (errorData.containsKey('errors')) {
        final errors = errorData['errors'] as Map<String, dynamic>;
        final errorMessage = errors.entries
            .map((e) => '${e.key}: ${e.value.join(', ')}')
            .join('\n');
        _showError(errorMessage);
      } else {
        _showError(
            errorData['message'] ?? 'Submission failed. Please try again.');
      }
    } catch (e) {
      _showError('Server returned an unexpected response');
    }
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField(_userIdController, 'User ID', Icons.person),
            const SizedBox(height: 15),
            _buildTextField(_courseController, 'Course Name', Icons.school),
            const SizedBox(height: 15),
            _buildTextField(_semesterNoController, 'Semester Number',
                Icons.format_list_numbered),
            const SizedBox(height: 15),
            _buildNumberField(
                _creditsController, 'Credit Hours', Icons.credit_score),
            const SizedBox(height: 15),
            _buildNumberField(_marksController, 'Marks', Icons.score),
            const SizedBox(height: 25),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitGrade,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue[800],
                    ),
                    child: const Text(
                      'SUBMIT GRADE',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          value?.isEmpty ?? true ? '$label is required' : null,
    );
  }

  Widget _buildNumberField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty ?? true) return '$label is required';
        if (double.tryParse(value!) == null) return 'Enter valid number';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _courseController.dispose();
    _semesterNoController.dispose();
    _creditsController.dispose();
    _marksController.dispose();
    super.dispose();
  }
}

class ViewGradesScreen extends StatefulWidget {
  const ViewGradesScreen({super.key});

  @override
  State<ViewGradesScreen> createState() => _ViewGradesScreenState();
}

class _ViewGradesScreenState extends State<ViewGradesScreen> {
  final _userIdController = TextEditingController();
  List<dynamic> _grades = [];
  bool _isLoading = false;

  Future<void> _fetchGrades() async {
    if (_userIdController.text.isEmpty) {
      _showError('Please enter User ID');
      return;
    }

    setState(() {
      _isLoading = true;
      _grades = [];
    });

    try {
      final response = await http.post(
        Uri.parse('https://devtechtop.com/management/public/api/select_data'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': _userIdController.text}),
      );

      _handleFetchResponse(response);
    } catch (e) {
      _showError('Failed to connect to server. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleFetchResponse(http.Response response) {
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);

        // Handle both array and object responses
        if (data is List) {
          setState(() => _grades = data);
        } else if (data is Map && data.containsKey('data')) {
          final gradesData = data['data'];
          if (gradesData is List) {
            setState(() => _grades = gradesData);
          } else {
            _showError('Unexpected data format in response');
            return;
          }
        } else {
          _showError('Server returned unexpected format');
          return;
        }

        if (_grades.isEmpty) {
          _showInfo('No grades found for this user');
        }
      } catch (e) {
        _showError('Failed to parse server response');
      }
    } else {
      _showError('Server error: ${response.statusCode}');
    }
  }

  Future<void> _fetchLastUserId() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('https://devtechtop.com/management/public/api/grades'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          _userIdController.text = data.last['user_id'].toString();
        } else if (data is Map && data.containsKey('data')) {
          final grades = data['data'] as List;
          if (grades.isNotEmpty) {
            _userIdController.text = grades.last['user_id'].toString();
          }
        }
      }
    } catch (e) {
      _showError('Failed to fetch last user ID');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void _showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _userIdController,
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _fetchGrades,
                tooltip: 'Fetch Grades',
              ),
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: _fetchLastUserId,
                tooltip: 'Last User ID',
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _grades.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'No grades to display',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _grades.length,
                        itemBuilder: (context, index) {
                          final grade = _grades[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text(
                                grade['course_name']?.toString() ??
                                    'Unknown Course',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                      'Semester: ${grade['semester_no'] ?? 'N/A'}'),
                                  Text('Marks: ${grade['marks'] ?? 'N/A'}'),
                                  Text(
                                      'Credits: ${grade['credit_hours'] ?? 'N/A'}'),
                                ],
                              ),
                              trailing:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
}
