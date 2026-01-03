import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/band_model.dart';
import '../viewmodels/main_viewmodel.dart';
import '../../globals.dart';
import '../../screens/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // =======================
  // HELPER IMAGE PROVIDER
  // =======================
  ImageProvider _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/placeholder.jpg');
    }
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage('assets/band_photos/$imagePath');
    }
  }

  // =======================
  // NAVIGATION
  // =======================
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
        builder: (_) => DetailScreen(concertData: convertedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =======================
              // SEARCH BAR
              // =======================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearchBar(context),
              ),

              const SizedBox(height: 24),

              // =======================
              // GENRE FILTER
              // =======================
              _buildGenreTags(context, viewModel),

              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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

              // =======================
              // CAROUSEL
              // =======================
              _buildConcertCarousel(context, viewModel),

              const SizedBox(height: 30),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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

              // =======================
              // LIST
              // =======================
              _buildConcertList(context, viewModel),
            ],
          ),
        );
      },
    );
  }

  // =======================
  // SEARCH BAR (AKTIF)
  // =======================
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .secondary
                .withValues(alpha: 0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),

        // 🔥 INI KUNCI SEARCH
        onChanged: (value) {
          context.read<MainViewModel>().setSearchQuery(value);
        },

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

  // =======================
  // GENRE TAGS
  // =======================
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
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ActionChip(
              label: Text(genre),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : genreColor,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: isSelected
                  ? genreColor
                  : Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: genreColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              onPressed: () => viewModel.setGenre(genre),
            ),
          );
        },
      ),
    );
  }

  // =======================
  // CAROUSEL
  // =======================
  Widget _buildConcertCarousel(
      BuildContext context, MainViewModel viewModel) {
    final list = viewModel.filteredBands.take(5).toList();

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Tidak ada konser ditemukan'),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final band = list[index];
          final genreColor = genreColors[band.genre] ?? Colors.white;

          return Container(
            width: MediaQuery.of(context).size.width * 0.88,
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: InkWell(
              onTap: () => _navigateToDetail(context, band),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                clipBehavior: Clip.antiAlias,
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

  // =======================
  // LIST
  // =======================
  Widget _buildConcertList(
      BuildContext context, MainViewModel viewModel) {
    final list = viewModel.filteredBands;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Band tidak ditemukan'),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFF333355)),
      itemBuilder: (context, index) {
        final band = list[index];
        final genreColor = genreColors[band.genre] ?? Colors.white;
        final isFav = viewModel.isFavorite(band);

        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: genreColor, width: 2),
            ),
            child: Text(
              band.genre.isNotEmpty ? band.genre[0] : '?',
              style: TextStyle(
                color: genreColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
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
                  color:
                      isFav ? Colors.yellow.shade700 : Colors.grey,
                ),
                onPressed: () => viewModel.toggleWishlist(band),
              ),
              ElevatedButton(
                onPressed: () => _navigateToDetail(context, band),
                child: const Text('Detail'),
              ),
            ],
          ),
        );
      },
    );
  }
}
