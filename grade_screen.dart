import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  final _addFormKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _courseController = TextEditingController();
  final _semesterController = TextEditingController();
  final _creditController = TextEditingController();
  final _marksController = TextEditingController();
  final _fetchIdController = TextEditingController();

  List<Map<String, dynamic>> _grades = [];
  bool _isLoading = false;
  String _lastInsertedId = '';

  // Updated _addGrade function
  Future<void> _addGrade() async {
    if (!_addFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final userId = _userIdController.text.trim();
    final url =
        'https://devtechtop.com/management/public/api/grades?user_id=${Uri.encodeComponent(userId)}'
        '&course_name=${Uri.encodeComponent(_courseController.text.trim())}'
        '&semester_no=${Uri.encodeComponent(_semesterController.text.trim())}'
        '&credit_hours=${Uri.encodeComponent(_creditController.text.trim())}'
        '&marks=${Uri.encodeComponent(_marksController.text.trim())}';

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Insert GET Response: ${response.body}');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final responseData = json.decode(response.body);
          if (responseData is Map &&
              (responseData['success'] == true ||
                  responseData['status'] == 'success' ||
                  responseData['message'] == 'Grade inserted successfully')) {
            _showToast('Grade added successfully!');
          } else {
            _showToast('Grade added (no success flag)');
          }
        } catch (e) {
          // If response isn't JSON or doesn't have "success"
          _showToast('Grade added! (Raw 201 response)');
        }

        _lastInsertedId = userId;
        _fetchIdController.text = userId;
        _addFormKey.currentState!.reset();
      } else {
        _showToast('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showToast('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchGrades() async {
    final userId = _fetchIdController.text.trim();
    if (userId.isEmpty) {
      _showToast('Please enter User ID');
      return;
    }

    setState(() {
      _isLoading = true;
      _grades = [];
    });

    try {
      final response = await http.get(Uri.parse(
          'https://devtechtop.com/management/public/api/select_data?user_id=$userId'));
      debugPrint('Fetch GET Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() => _grades = List<Map<String, dynamic>>.from(data));
        } else {
          _showToast('No grades found for ID: $userId');
        }
      } else {
        _showToast('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showToast('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Grade Management'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.add), text: "Add"),
              Tab(icon: Icon(Icons.search), text: "View"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Add Grade Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _addFormKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _userIdController,
                      decoration: const InputDecoration(labelText: 'User ID'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _courseController,
                      decoration:
                          const InputDecoration(labelText: 'Course Name'),
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _semesterController,
                      decoration:
                          const InputDecoration(labelText: 'Semester Number'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _creditController,
                      decoration:
                          const InputDecoration(labelText: 'Credit Hours'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _marksController,
                      decoration: const InputDecoration(labelText: 'Marks'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addGrade,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit Grade'),
                    ),
                  ],
                ),
              ),
            ),

            // Fetch Grades Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _fetchIdController,
                    decoration: InputDecoration(
                      labelText: 'Enter User ID',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _fetchGrades,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_lastInsertedId.isNotEmpty)
                    OutlinedButton(
                      onPressed: () {
                        _fetchIdController.text = _lastInsertedId;
                        _fetchGrades();
                      },
                      child: Text('Fetch last inserted ID: $_lastInsertedId'),
                    ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _grades.isEmpty
                        ? Center(
                            child: Text(
                              _isLoading ? 'Loading...' : 'No grades found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _grades.length,
                            itemBuilder: (context, index) {
                              final grade = _grades[index];
                              return Card(
                                child: ListTile(
                                  title:
                                      Text(grade['course_name'] ?? 'Unknown'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Semester: ${grade['semester_no']}'),
                                      Text('Marks: ${grade['marks']}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _courseController.dispose();
    _semesterController.dispose();
    _creditController.dispose();
    _marksController.dispose();
    _fetchIdController.dispose();
    super.dispose();
  }
}
