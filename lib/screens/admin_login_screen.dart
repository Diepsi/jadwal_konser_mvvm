// lib/screens/admin_login_screen.dart

import 'package:flutter/material.dart';
import '../globals.dart'; // Import state global

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
    setState(() {
      _errorMessage = '';
    });

    // Cek kredensial (admin / 123) dari globals.dart
    if (_usernameController.text == adminUsername &&
        _passwordController.text == adminPassword) {
      // Login Sukses
      setState(() {
        isAdmin = true; // Set status global
      });
      // Kembali ke layar sebelumnya
      Navigator.pop(context, true);
    } else {
      // Login Gagal
      setState(() {
        _errorMessage = 'Username atau password salah.';
        isAdmin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Icon(
                Icons.admin_panel_settings,
                size: 80,
                color: Color(0xFFF72585),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username Admin',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Admin',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _doLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color(0xFFF72585),
              ),
              child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}