// lib/screens/admin_login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/viewmodels/main_viewmodel.dart'; // Gunakan 'UI' huruf besar sesuai folder
import '../globals.dart'; 

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _doLogin() {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);

    if (_usernameController.text == adminUsername &&
        _passwordController.text == adminPassword) {
      viewModel.loginAsAdmin();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _errorMessage = 'Username atau password salah.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username Admin'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password Admin'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _doLogin,
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}