import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/band_model.dart';
import '../viewmodels/main_viewmodel.dart';
import '../../main.dart'; // Mengambil genreTags & genreColors
import '../../screens/detail_screen.dart'; // Navigasi ke Detail

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // HELPER: Logika penentuan sumber gambar (Internet atau Lokal)
  ImageProvider _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/placeholder.jpg');
    }
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      // Mengambil dari folder assets/band_photos/ sesuai struktur projek
      return AssetImage('assets/band_photos/$imagePath');
    }
  }

  // NAVIGASI: Konversi data model ke Map untuk DetailScreen
  void _navigateToDetail(BuildContext context, BandModel band) {
    final Map<String, String> convertedData = {
      'artist': band.band,
      'date': band.date,
      'price': band.price,
      'genre': band.genre,
      'location': band.location,
      'image': band.mainPhoto,
      'description': band.bio,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(concertData: convertedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer agar UI otomatis update saat notifyListeners() di VM dipanggil
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildSearchBar(context),
              ),
              const SizedBox(height: 24),

              // GENRE TAGS
              _buildGenreTags(context, viewModel),
              const SizedBox(height: 24),

              // CAROUSEL KONSEUR UNGGULAN
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Konser Unggulan 🔥',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildConcertCarousel(context, viewModel),

              const SizedBox(height: 30),

              // LIST GIG TERDEKAT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Gig Terdekat Lainnya',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildConcertList(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  // WIDGET 1: Search Bar UI
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            // PERBAIKAN: Menggunakan .withValues menggantikan .withOpacity
            color: Theme.of(
              context,
            ).colorScheme.secondary.withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari Artis, Genre, atau Kota...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
          suffixIcon: const Icon(Icons.mic, color: Colors.pink),
        ),
      ),
    );
  }

  // WIDGET 2: Genre Tags
  Widget _buildGenreTags(BuildContext context, MainViewModel viewModel) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genreTags.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final genre = genreTags[index];
          final isSelected = genre == viewModel.selectedGenre;
          final genreColor = genreColors[genre] ?? Colors.white;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ActionChip(
              label: Text(genre),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : genreColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: isSelected
                  ? genreColor
                  : Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: genreColor,
                  width: isSelected ? 2.0 : 1.0,
                ),
              ),
              onPressed: () => viewModel.setGenre(genre),
            ),
          );
        },
      ),
    );
  }

  // WIDGET 3: Carousel Horizontal
  Widget _buildConcertCarousel(BuildContext context, MainViewModel viewModel) {
    final filteredList = viewModel.filteredBands.take(5).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Tidak ada konser untuk genre ini.'),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final band = filteredList[index];
          final genreColor = genreColors[band.genre] ?? Colors.white;

          return Container(
            width: MediaQuery.of(context).size.width * 0.88,
            margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            child: InkWell(
              onTap: () => _navigateToDetail(context, band),
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: _getImageProvider(band.mainPhoto),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            // PERBAIKAN: Menggunakan .withValues menggantikan .withOpacity
                            Colors.black.withValues(alpha: 0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            band.band,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${band.date} | ${band.location} | ${band.genre}',
                            style: TextStyle(
                              color: genreColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // WIDGET 4: List View Vertical
  Widget _buildConcertList(BuildContext context, MainViewModel viewModel) {
    final list = viewModel.filteredBands;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFF333355), height: 1),
      itemBuilder: (context, index) {
        final band = list[index];
        final genreColor = genreColors[band.genre] ?? Colors.white;
        final isFav = viewModel.isFavorite(band);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: genreColor, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                band.genre.isNotEmpty ? band.genre[0] : '?',
                style: TextStyle(
                  color: genreColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            title: Text(
              band.band,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${band.date} | ${band.price}',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.yellow.shade700 : Colors.grey,
                  ),
                  onPressed: () {
                    viewModel.toggleWishlist(band);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        content: Text(
                          isFav
                              ? '${band.band} dihapus dari Wishlist.'
                              : '${band.band} ditambahkan ke Wishlist!',
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () => _navigateToDetail(context, band),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
