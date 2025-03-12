import 'package:flutter/material.dart';

class OutputPage extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(int) onDelete;

  OutputPage({required this.users, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Text(
                'User Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              users.isEmpty
                  ? Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                  : DataTable(
                    border: TableBorder.all(color: Colors.black),
                    columns: [
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Password',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: List.generate(users.length, (index) {
                      var user = users[index];
                      return DataRow(
                        cells: [
                          DataCell(Text(user['name']!)),
                          DataCell(Text(user['email']!)),
                          DataCell(Text(user['password']!)),
                          DataCell(
                            Icon(
                              user['isActive']
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  user['isActive'] ? Colors.green : Colors.red,
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                onDelete(index); // Call delete function
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
