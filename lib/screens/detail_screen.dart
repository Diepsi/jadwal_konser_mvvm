import 'package:flutter/material.dart';
import '../globals.dart'; // Impor data global

class DetailScreen extends StatefulWidget {
  final Map<String, String> concertData;

  const DetailScreen({super.key, required this.concertData});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool isWishlisted;

  @override
  void initState() {
    super.initState();
    // Item yang dicari: 'Artis - Genre Lokasi'
    String itemKey =
        '${widget.concertData['artist']} - ${widget.concertData['genre']} ${widget.concertData['location']}';
    isWishlisted = globalWishlistItems.contains(itemKey);
  }

  // Fungsi untuk mendapatkan warna aksen berdasarkan genre
  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'EDM':
      case 'Electronic':
        return const Color(0xFF64FFDA);
      case 'Rock':
        return const Color(0xFFFF5252);
      case 'Pop':
      case 'K-Pop':
        return const Color(0xFF40C4FF);
      case 'Jazz':
        return const Color(0xFFFFD740);
      case 'Indie':
        return const Color(0xFF7C4DFF);
      case 'Metal':
        return const Color(0xFF9E9E9E);
      case 'Folk':
        return const Color(0xFF8BC34A);
      case 'Hip-Hop':
        return const Color(0xFF9C27B0);
      case 'Classic':
      case 'Orchestra':
        return const Color(0xFF00B0FF);
      case 'Latin':
        return const Color(0xFFFF9800);
      case 'Punk':
        return const Color(0xFFE91E63);
      case 'R&B':
        return const Color(0xFF4CAF50);
      case 'Reggae':
        return const Color(0xFFFFC107);
      default:
        return Colors.white;
    }
  }

  void _toggleWishlist() {
    setState(() {
      String itemKey =
          '${widget.concertData['artist']} - ${widget.concertData['genre']} ${widget.concertData['location']}';
      if (isWishlisted) {
        removeFromWishlist(itemKey);
      } else {
        addToWishlist(itemKey);
      }
      isWishlisted = !isWishlisted;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isWishlisted
                ? '${widget.concertData['artist']} ditambahkan ke Wishlist!'
                : '${widget.concertData['artist']} dihapus dari Wishlist.',
          ),
          duration: const Duration(milliseconds: 1000),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final genre = widget.concertData['genre']!;
    final color = _getGenreColor(genre);
    final artist = widget.concertData['artist']!;
    final location = widget.concertData['location']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(artist),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.grey.shade400,
            ),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/band_photos/${widget.concertData['image']}',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
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

            // Detail Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Tanggal',
                    widget.concertData['date']!,
                  ),
                  _buildDetailRow(
                    Icons.location_on,
                    'Lokasi',
                    location,
                    color: Colors.blueAccent,
                  ),
                  _buildDetailRow(
                    Icons.money,
                    'Harga Tiket',
                    widget.concertData['price']!,
                    color: Colors.greenAccent,
                  ),

                  const SizedBox(height: 20),

                  // Deskripsi
                  Text(
                    'Tentang Konser',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Konser tunggal dari $artist di $location. Saksikan penampilan mereka membawakan lagu-lagu hits dan album terbaru. Ini adalah event wajib bagi penggemar $genre!',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: Colors.grey.shade800, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Anda menekan tombol Beli Tiket!'),
                      duration: const Duration(milliseconds: 700),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Beli Tiket Sekarang',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.grey.shade400, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color ?? Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
