// lib/screens/initial_auth_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UI/viewmodels/main_viewmodel.dart';
import '../main.dart'; // PENTING: Untuk memanggil MainScreenWrapper

class InitialAuthScreen extends StatefulWidget {
  const InitialAuthScreen({super.key});

  @override
  State<InitialAuthScreen> createState() => _InitialAuthScreenState();
}

class _InitialAuthScreenState extends State<InitialAuthScreen> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _adminPassController = TextEditingController();

  void _showAdminLogin(BuildContext context, MainViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Admin Login", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _adminIdController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Admin ID", labelStyle: TextStyle(color: Colors.grey)),
            ),
            TextField(
              controller: _adminPassController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Password", labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF72585)),
            onPressed: () {
              // Validasi Admin
              if (_adminIdController.text == "admin" && _adminPassController.text == "123") {
                viewModel.loginAsAdmin();
                Navigator.pop(context); // Tutup dialog
                
                // PINDAH KE HALAMAN UTAMA (MainScreenWrapper)
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreenWrapper()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("ID atau Password Salah!"), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0A1F), Color(0xFF1B1B3A)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note_rounded, size: 80, color: Color(0xFFF72585)),
            const SizedBox(height: 20),
            const Text(
              "GIGFINDER",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 5, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text("Temukan Konser Band Favoritmu", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 60),
            
            // TOMBOL MASUK PENGUNJUNG
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4895EF),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  viewModel.loginAsGuest();
                  // PINDAH KE HALAMAN UTAMA (MainScreenWrapper)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreenWrapper()),
                  );
                },
                child: const Text("MASUK SEBAGAI PENGUNJUNG", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // TOMBOL ADMIN
            TextButton(
              onPressed: () => _showAdminLogin(context, viewModel),
              child: Text(
                "Masuk sebagai Admin",
                style: TextStyle(color: Colors.white.withOpacity(0.6), decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}