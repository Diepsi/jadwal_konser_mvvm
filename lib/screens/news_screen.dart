import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ui/viewmodels/main_viewmodel.dart';
import '../main.dart'; // Untuk mengambil genreColors

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari MainViewModel
    final viewModel = Provider.of<MainViewModel>(context);
    final newsList = viewModel.allBands;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Berita Band & Gig',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0A0A1F),
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
                // Mengambil warna berdasarkan genre dari main.dart
                final bandColor = genreColors[news.genre] ?? Colors.white;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: bandColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: bandColor, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.article, color: bandColor),
                  ),
                  title: Text(
                    news.title.isNotEmpty ? news.title : "Informasi Band",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '${news.band} - ${news.date}',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Logika navigasi detail bisa ditambahkan di sini
                  },
                );
              },
            ),
    );
  }
}
