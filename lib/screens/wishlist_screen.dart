// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import '../globals.dart';
import 'detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Fungsi untuk menyegarkan tampilan secara lokal
  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menghapus Scaffold/AppBar internal agar menyatu dengan AppBar global di main.dart
    return Container(
      color: const Color(0xFF0A0A1F),
      child: globalWishlistItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade800),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada konser favorit.',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: globalWishlistItems.length,
              itemBuilder: (context, index) {
                final wishlistKey = globalWishlistItems[index];
                
                // Mencari data band asli di globals berdasarkan key unik
                final bandData = globalBandData.firstWhere(
                  (b) => '${b['band']} - ${b['genre']} ${b['location']}' == wishlistKey,
                  orElse: () => {},
                );

                if (bandData.isEmpty) return const SizedBox.shrink();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFF1B1B3A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A1F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.music_note, color: Color(0xFFF72585)),
                    ),
                    title: Text(
                      bandData['band'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${bandData['date']} | ${bandData['location']}',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        // Menghapus dari storage melalui globals dan refresh UI
                        removeFromWishlist(wishlistKey);
                        _refresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${bandData['band']} dihapus'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(concertData: {
                            'artist': bandData['band'].toString(),
                            'date': bandData['date'].toString(),
                            'price': bandData['price'].toString(),
                            'genre': bandData['genre'].toString(),
                            'location': bandData['location'].toString(),
                            'image': bandData['main_photo'].toString(),
                            'description': bandData['bio'].toString(),
                          }),
                        ),
                      ).then((_) => _refresh()); // Refresh otomatis saat kembali dari Detail
                    },
                  ),
                );
              },
            ),
    );
  }
}