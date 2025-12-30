// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals.dart';
import '../UI/viewmodels/main_viewmodel.dart'; // Pastikan path UI konsisten (huruf besar/kecil)
import 'detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          color: const Color(0xFF0A0A1F),
          child: globalWishlistItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: globalWishlistItems.length,
                  itemBuilder: (context, index) {
                    final wishlistKey = globalWishlistItems[index];
                    
                    // Mencari data band di ViewModel (bukan mentah dari globals) 
                    // agar lebih aman dan sinkron dengan model data
                    final band = viewModel.allBands.firstWhere(
                      (b) => '${b.band} - ${b.genre} ${b.location}' == wishlistKey,
                      orElse: () => viewModel.allBands.first, // Fallback aman
                    );

                    // Jika tidak ditemukan di list band (mungkin sudah dihapus admin)
                    if (!viewModel.allBands.any((b) => '${b.band} - ${b.genre} ${b.location}' == wishlistKey)) {
                      return const SizedBox.shrink();
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: const Color(0xFF1B1B3A),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A1F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.favorite, color: Color(0xFFF72585)),
                        ),
                        title: Text(
                          band.band,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${band.date} | ${band.location}',
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                          onPressed: () {
                            // PERBAIKAN: Gunakan method yang ada di ViewModel
                            // Jangan memanggil notifyListeners() secara manual dari UI
                            viewModel.toggleWishlist(band);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${band.band} dihapus dari favorit'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(concertData: {
                                'artist': band.band,
                                'date': band.date,
                                'price': band.price,
                                'genre': band.genre,
                                'location': band.location,
                                'image': band.mainPhoto,
                                'description': band.bio,
                              }),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // Widget untuk tampilan saat wishlist kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border_rounded, size: 100, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 20),
          const Text(
            'Belum ada konser favorit',
            style: TextStyle(
              color: Colors.white70, 
              fontSize: 18, 
              fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ketuk ikon bintang pada beranda untuk\nmenambahkan ke sini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}