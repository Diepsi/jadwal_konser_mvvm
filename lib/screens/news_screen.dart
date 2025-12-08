// lib/screens/news_screen.dart

import 'package:flutter/material.dart';
import 'band_detail_screen.dart'; // Import detail
import '../globals.dart'; // Import globalBandData

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'Metal':
        return const Color(0xFF9E9E9E);
      case 'Rock':
        return const Color(0xFFFF5252);
      case 'Pop':
      case 'K-Pop':
        return const Color(0xFF40C4FF);
      case 'Indie':
        return const Color(0xFF7C4DFF);
      case 'Reggae':
        return const Color(0xFFFFC107);
      case 'Punk':
        return const Color(0xFFE91E63);
      default:
        return Colors.white;
    }
  }

  void _navigateToBandDetail(
    BuildContext context,
    Map<String, dynamic> bandData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BandDetailScreen(bandData: bandData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan data dari global (termasuk yang baru ditambah Admin)
    final newsList = globalBandData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Band & Gig'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: newsList.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) =>
            const Divider(color: Color(0xFF333355), height: 20),
        itemBuilder: (context, index) {
          final news = newsList[index];
          final bandColor = _getGenreColor(news['genre']!);

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bandColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bandColor, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.article, color: bandColor),
            ),
            title: Text(
              news['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${news['band']} - ${news['date']}',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _navigateToBandDetail(context, news),
          );
        },
      ),
    );
  }
}
