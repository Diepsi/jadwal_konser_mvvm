// lib/screens/news_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Gunakan 'UI' huruf besar sesuai struktur folder proyek Anda
import '../UI/viewmodels/main_viewmodel.dart'; 

// PERBAIKAN: Import dari globals.dart untuk mengambil genreColors
import '../globals.dart'; 

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan tipe data Provider spesifik sesuai ViewModel Anda
    final viewModel = Provider.of<MainViewModel>(context);
    final newsList = viewModel.allBands;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Berita Band & Gig',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: newsList.isEmpty
          ? const Center(child: Text('Tidak ada berita tersedia'))
          : ListView.separated(
              itemCount: newsList.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) =>
                  const Divider(color: Color(0xFF333355), height: 20),
              itemBuilder: (context, index) {
                final news = newsList[index];
                
                // Sekarang genreColors diambil langsung dari globals.dart
                final bandColor = genreColors[news.genre] ?? const Color(0xFFF72585);

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      // Menggunakan withValues sesuai standar Flutter terbaru
                      color: bandColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: bandColor, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.article_outlined, color: bandColor),
                  ),
                  title: Text(
                    news.band,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Genre: ${news.genre} • Lokasi: ${news.location}',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Logika navigasi detail bisa diletakkan di sini
                  },
                );
              },
            ),
    );
  }
}