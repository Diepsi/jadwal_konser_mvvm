import 'package:flutter/material.dart';
// Import package untuk membuka URL
import 'package:url_launcher/url_launcher.dart';

class BandDetailScreen extends StatelessWidget {
  final Map<String, dynamic> bandData;

  const BandDetailScreen({super.key, required this.bandData});

  // Fungsi untuk mendapatkan warna aksen berdasarkan genre
  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'Metal':
        return const Color(0xFF9E9E9E);
      case 'Rock':
        return const Color(0xFFFF5252);
      case 'R&B':
        return const Color(0xFF4CAF50);
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

  // FUNGSI PERBAIKAN untuk membuka URL
  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);

    // Logic yang menggunakan await dan !await
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Tampilkan error jika gagal membuka URL
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka link: $url')));
      // Melemparkan exception agar tidak melanjutkan
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final genre = bandData['genre'] as String;
    final color = _getGenreColor(genre);

    // Ambil albums sebagai List<dynamic> karena berisi Map
    final albums = bandData['albums'] as List<dynamic>;

    // MENGHILANGKAN LOGIKA PLACEHOLDER URL PALSU
    // Sekarang, kita hanya mengambil data yang sudah ada di 'albums'
    final List<Map<String, dynamic>> albumsWithUrl = albums.map((album) {
      // Konversi Map<dynamic, dynamic> menjadi Map<String, dynamic> dan pastikan kunci 'url' ada
      final Map<String, dynamic> albumMap = Map<String, dynamic>.from(
        album as Map,
      );

      // Menggunakan URL dari kunci 'url' yang DIBERIKAN di news_screen.dart
      String spotifyUrl = albumMap['url'] ?? '';

      return {
        'title': albumMap['title'] ?? 'Nama Album Tidak Diketahui',
        'cover': albumMap['cover'] ?? '',
        'spotify_url': spotifyUrl, // Mengambil URL yang valid
      };
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(bandData['band']!),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Band (ANDA BISA MENGGUNAKAN LOGIKA DARI RESPONSE SEBELUMNYA)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: color, width: 2),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bandData['band']!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian Bio
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Biografi', Icons.info_outline),
                  const SizedBox(height: 10),
                  Text(
                    bandData['bio']!,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            // Bagian Album Populer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                    context,
                    'Album Populer',
                    Icons.music_note,
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: albumsWithUrl.length,
                    itemBuilder: (context, index) {
                      final album = albumsWithUrl[index];
                      final albumTitle = album['title'] as String;
                      final albumCover = album['cover'] as String;
                      final spotifyLink = album['spotify_url'] as String;

                      return InkWell(
                        // Menggunakan InkWell agar dapat di-tap
                        onTap: () {
                          // PANGGIL FUNGSI PERBAIKAN
                          // Cek apakah link tersedia sebelum mencoba launch
                          if (spotifyLink.isNotEmpty) {
                            try {
                              _launchUrl(spotifyLink, context);
                            } catch (e) {
                              // Pesan error sudah dihandle di dalam _launchUrl
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Link Spotify belum tersedia untuk album ini.',
                                ),
                              ),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              // Image/Cover Album
                              Container(
                                width: 50,
                                height: 50,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/album_covers/$albumCover', // LOKASI DARI album_covers/
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey.shade700,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.album,
                                                color: Colors.white,
                                                size: 20,
                                              ), // Fallback Icon
                                            ),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  albumTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // 🔗 Ikon Link
                              Icon(
                                Icons.link,
                                size: 18,
                                color: spotifyLink.isNotEmpty
                                    ? Colors.blueAccent
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '#${index + 1}',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
