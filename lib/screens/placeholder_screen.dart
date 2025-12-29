import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(
          0xFF0A0A1F,
        ), // Menyesuaikan tema gelap Anda
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForTitle(title),
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman $title sedang dikembangkan',
              style: const TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk menentukan ikon berdasarkan judul halaman
  IconData _getIconForTitle(String title) {
    switch (title.toLowerCase()) {
      case 'wishlist':
        return Icons.favorite_border;
      case 'tickets':
        return Icons.confirmation_number_outlined;
      case 'profile':
        return Icons.person_outline;
      default:
        return Icons.hourglass_empty;
    }
  }
}
