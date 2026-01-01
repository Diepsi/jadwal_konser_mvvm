import 'package:flutter/material.dart';
import '../../../screens/initial_auth_screen.dart';

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar Guest
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF1B1B3A),
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Status Guest
            const Text(
              "Guest User",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Login untuk menyimpan wishlist dan\nmendapatkan update konser",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),
            const Divider(color: Colors.white24),
            const SizedBox(height: 20),

            // Statistik Konser (sementara statis)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatItem(title: "Concerts", value: "120+"),
                _StatItem(title: "Artists", value: "50+"),
              ],
            ),

            const SizedBox(height: 40),

            // Tombol Login
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF72585),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const InitialAuthScreen(),
                  ),
                );
              },
              child: const Text(
                "Login / Register",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
