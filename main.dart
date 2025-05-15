import 'package:flutter/material.dart';
import 'db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Records',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshStudentList();
  }

  Future<void> _refreshStudentList() async {
    setState(() => _isLoading = true);
    final data = await DBHelper.getAllStudents();
    setState(() {
      _students = data;
      _isLoading = false;
    });
  }

  Future<void> _addStudent() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    await DBHelper.addStudent(_nameController.text.trim());
    _nameController.clear();
    _refreshStudentList();
    FocusScope.of(context).unfocus();
  }

  Future<void> _deleteStudent(int id) async {
    await DBHelper.deleteStudent(id);
    _refreshStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Records'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshStudentList,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Student Card
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Student Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'Enter student name',
                      ),
                      onSubmitted: (_) => _addStudent(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Student'),
                        onPressed: _addStudent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Student List Header
            Row(
              children: [
                Text(
                  'Students (${_students.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Student List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _students.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 64,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No students found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a student to get started',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                itemCount: _students.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final student = _students[index];
                  final createdAt = DateTime.parse(student['createdAt']);
                  return Dismissible(
                    key: Key(student['id'].toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) => _deleteStudent(student['id']),
                    child: Card(
                      elevation: 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                        ),
                        title: Text(
                          student['name'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'Added: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteStudent(student['id']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}