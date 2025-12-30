import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy berita (Nanti bisa dipindahkan ke globals atau ViewModel)
    final List<Map<String, String>> newsList = [
      {
        'title': 'The Sigit Umumkan Tur Dunia 2026',
        'date': '30 Des 2025',
        'image': 'thesiggit.jpeg',
        'category': 'Band Update',
        'desc': 'Setelah sukses dengan album terbaru, The Sigit bersiap menyapa fans di Eropa...'
      },
      {
        'title': 'Tiket Konser Hindia di Jakarta Habis dalam 5 Menit',
        'date': '28 Des 2025',
        'image': 'hindia.jpg',
        'category': 'Concert',
        'desc': 'Antusiasme luar biasa dari para fans membuat platform penjualan tiket sempat down...'
      },
      {
        'title': 'Festival Rock Terbesar di Asia Tenggara Hadir di Bandung',
        'date': '25 Des 2025',
        'image': 'placeholder.jpg',
        'category': 'Festival',
        'desc': 'Lebih dari 50 band internasional dan lokal akan memeriahkan panggung utama...'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1F),
      body: CustomScrollView(
        slivers: [
          // AppBar yang bisa mengecil saat di scroll
          const SliverAppBar(
            expandedHeight: 60,
            floating: true,
            backgroundColor: Color(0xFF0A0A1F),
            title: Text('Berita Band & Gig', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: false,
          ),

          // News Feed
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final news = newsList[index];
                return _buildNewsCard(news);
              },
              childCount: newsList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, String> news) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B3A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Berita
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: _displayImage(news['image']!),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Kategori
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF72585).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    news['category']!,
                    style: const TextStyle(color: Color(0xFFF72585), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                // Judul Berita
                Text(
                  news['title']!,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                // Tanggal
                Text(
                  news['date']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 10),
                // Deskripsi Singkat
                Text(
                  news['desc']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi helper untuk menampilkan gambar agar aman di Web (Edge)
  Widget _displayImage(String path) {
    if (kIsWeb) {
      return Container(
        color: Colors.black26,
        child: const Icon(Icons.image, color: Colors.white24, size: 50),
      );
    }
    
    if (path.contains('/') || path.contains('\\')) {
      return Image.file(File(path), fit: BoxFit.cover);
    }
    return Image.asset('assets/band_photos/$path', fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black26, child: const Icon(Icons.broken_image)));
  }
}