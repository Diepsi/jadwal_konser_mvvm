// lib/main.dart

import 'package:flutter/material.dart';
// Impor screens
import 'screens/placeholder_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/news_screen.dart';
// Impor global state (Agar sinkron dengan Admin)
import 'globals.dart';

// --- GENRE TAGS & COLORS (STYLE) ---
const List<String> genreTags = [
  'Semua',
  'Metal',
  'Rock',
  'R&B',
  'Pop',
  'K-Pop',
  'Indie',
  'Reggae',
  'Punk',
];

const Map<String, Color> genreColors = {
  'Metal': Color(0xFF9E9E9E),
  'Rock': Color(0xFFFF5252),
  'R&B': Color(0xFF4CAF50),
  'Pop': Color(0xFF40C4FF),
  'K-Pop': Color(0xFFFF4081),
  'Indie': Color(0xFF7C4DFF),
  'Reggae': Color(0xFFFFC107),
  'Punk': Color(0xFFE91E63),
  'Semua': Color(0xFFEEEEEE),
};

// --- APLIKASI UTAMA ---
void main() {
  runApp(const GigFinderApp());
}

class GigFinderApp extends StatelessWidget {
  const GigFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GigFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A1F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF72585),
          secondary: Color(0xFF4895EF),
          surface: Color(0xFF1B1B3A),
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const MainScreenWrapper(),
    );
  }
}

// --- SCREEN WRAPPER UNTUK BOTTOM NAV BAR ---
class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const PlaceholderScreen(title: 'Wishlist'),
    const NewsScreen(),
    const PlaceholderScreen(title: 'Tickets'),
    const PlaceholderScreen(title: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

// --- LAYAR UTAMA (HOMESCREEN) ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedGenre = 'Semua';

  // HELPER: Cek Gambar (URL Internet atau Aset Lokal)
  ImageProvider _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage(
        'assets/images/placeholder.jpg',
      ); // Pastikan ada atau ganti path
    }
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      // Jika bukan link, anggap aset lokal di folder band_photos
      return AssetImage('assets/band_photos/$imagePath');
    }
  }

  // NAVIGASI: Konversi Data Global (Dynamic) ke Data Detail (String)
  void _navigateToDetail(Map<String, dynamic> item) {
    final Map<String, String> convertedData = {
      'artist':
          item['band']?.toString() ??
          'Unknown', // Kunci 'band' di global jadi 'artist'
      'date': item['date']?.toString() ?? '-',
      'price': item['price']?.toString() ?? 'TBA',
      'genre': item['genre']?.toString() ?? 'Music',
      'location': item['location']?.toString() ?? 'TBA',
      'image':
          item['main_photo']?.toString() ??
          '', // Kunci 'main_photo' jadi 'image'
      'description': item['bio']?.toString() ?? 'Tidak ada deskripsi',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(concertData: convertedData),
      ),
    ).then((_) {
      // Refresh saat kembali (jika status wishlist berubah)
      setState(() {});
    });
  }

  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildSearchBar(context),
          ),
          const SizedBox(height: 24),

          _buildGenreTags(),
          const SizedBox(height: 24),

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

          _buildConcertCarousel(), // Carousel sekarang pakai data global
          const SizedBox(height: 30),

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

          _buildConcertList(context), // List sekarang pakai data global
        ],
      ),
    );
  }

  // Widget 1: Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.15),
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
          suffixIcon: IconButton(
            icon: Icon(Icons.mic, color: Theme.of(context).colorScheme.primary),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  // Widget 2: Genre Tags
  Widget _buildGenreTags() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genreTags.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final genre = genreTags[index];
          final isSelected = genre == _selectedGenre;
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
              onPressed: () => _onGenreSelected(genre),
            ),
          );
        },
      ),
    );
  }

  // Widget 3: Carousel (Menggunakan globalBandData)
  Widget _buildConcertCarousel() {
    // 1. Ambil data dari globalBandData
    List<Map<String, dynamic>> filteredCarouselList;

    if (_selectedGenre == 'Semua') {
      filteredCarouselList = globalBandData.take(5).toList(); // Ambil 5 teratas
    } else {
      filteredCarouselList = globalBandData
          .where((k) => k['genre'] == _selectedGenre)
          .take(5)
          .toList();
    }

    if (filteredCarouselList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tidak ada Konser untuk genre "$_selectedGenre".',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredCarouselList.length,
        itemBuilder: (context, index) {
          final item = filteredCarouselList[index];

          // Mapping Key Global -> UI
          final String bandName = item['band'] ?? 'Unknown';
          final String genre = item['genre'] ?? 'Music';
          final String date = item['date'] ?? '-';
          final String location = item['location'] ?? 'TBA';
          final String? imagePath = item['main_photo']; // Bisa URL atau Asset

          final genreColor = genreColors[genre] ?? Colors.white;

          return Container(
            width: MediaQuery.of(context).size.width * 0.88,
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: 8,
              bottom: 8,
            ),
            child: InkWell(
              onTap: () => _navigateToDetail(item),
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
                    // GAMBAR LATAR (Menggunakan Helper)
                    Image(
                      image: _getImageProvider(imagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: Colors.grey.shade900,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    // Gradient Gelap
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                    // Teks Info
                    Positioned(
                      bottom: 15,
                      left: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bandName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '$date | $location | $genre',
                            style: TextStyle(
                              fontSize: 14,
                              color: genreColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge Genre Pojok Kanan
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: genreColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
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

  // Widget 4: List View (Menggunakan globalBandData)
  Widget _buildConcertList(BuildContext context) {
    // 1. Ambil data dari globalBandData
    final filteredList = _selectedGenre == 'Semua'
        ? globalBandData
        : globalBandData.where((k) => k['genre'] == _selectedGenre).toList();

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filteredList.length,
      separatorBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(height: 1, color: Color(0xFF333355)),
      ),
      itemBuilder: (context, index) {
        final item = filteredList[index];

        // Mapping Key Global -> UI
        final String bandName = item['band'] ?? 'Unknown';
        final String genre = item['genre'] ?? 'Music';
        final String date = item['date'] ?? '-';
        final String price = item['price'] ?? 'TBA';
        final String location = item['location'] ?? 'TBA';

        final genreColor = genreColors[genre] ?? Colors.white;

        // Kunci unik untuk Wishlist (Gunakan nama band + lokasi agar unik)
        final wishlistKey = '$bandName - $genre $location';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: genreColor, width: 2),
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surface,
              ),
              alignment: Alignment.center,
              child: Text(
                genre.isNotEmpty ? genre[0] : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: genreColor,
                ),
              ),
            ),
            title: Text(
              bandName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '$date | $price',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ⭐️ TOMBOL WISHLIST
                IconButton(
                  icon: Icon(
                    globalWishlistItems.contains(wishlistKey)
                        ? Icons.star
                        : Icons.star_border,
                    color: globalWishlistItems.contains(wishlistKey)
                        ? Colors.yellow.shade700
                        : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (globalWishlistItems.contains(wishlistKey)) {
                        removeFromWishlist(wishlistKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$bandName dihapus dari Wishlist.'),
                          ),
                        );
                      } else {
                        addToWishlist(wishlistKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$bandName ditambahkan ke Wishlist!'),
                            backgroundColor: Colors.yellow.shade800,
                          ),
                        );
                      }
                    });
                  },
                ),
                // TOMBOL DETAIL
                ElevatedButton(
                  onPressed: () => _navigateToDetail(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text(
                    'Detail',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            onTap: () => _navigateToDetail(item),
          ),
        );
      },
    );
  }
}
