import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'display_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _username = '';
  String _email = '';
  String _password = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final dbHelper = DatabaseHelper.instance;

    try {
      if (_isLogin) {
        final user = await dbHelper.getUser(_username, _password);
        if (user == null) {
          throw Exception('Invalid credentials');
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DisplayScreen(user: user)),
        );
      } else {
        await dbHelper.insertUser({
          DatabaseHelper.columnUsername: _username,
          DatabaseHelper.columnEmail: _email,
          DatabaseHelper.columnPassword: _password,
        });
        setState(() => _isLogin = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (!_isLogin)
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter valid email'
                              : null,
                  onSaved: (value) => _email = value ?? '',
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter username'
                            : null,
                onSaved: (value) => _username = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter password'
                            : null,
                onSaved: (value) => _password = value ?? '',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin ? 'Create new account' : 'Already have an account?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
