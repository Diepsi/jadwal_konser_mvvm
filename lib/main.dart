import 'package:flutter/material.dart';
// Impor screens
import 'screens/placeholder_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/news_screen.dart';
// Impor global state (Wishlist)
import 'globals.dart';

// --- DATA DUMMY (ALL KONSER, TAGS, COLORS) ---
// CATATAN: Pastikan semua file di sini ada di folder proyek: assets/band_photos/

final List<Map<String, String>> allKonserData = [
  // ROCK
  {
    'artist': 'The S.I.G.I.T',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'Rock',
    'location': 'Jakarta',
    'image': 'thesgigit.jpeg',
  },
  {
    'artist': 'Dewa 19',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'Rock',
    'location': 'Jakarta',
    'image': 'dewa.jpeg',
  },
  {
    'artist': 'Slank',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'Rock',
    'location': 'Jakarta',
    'image': 'slank.jpeg',
  },

  // POP & K-POP
  {
    'artist': 'Pop Sensation X',
    'date': '25 Nov',
    'price': 'Rp 500.000',
    'genre': 'Pop',
    'location': 'Surabaya',
    'image': 'popsensationx.jpg',
  },
  {
    'artist': 'K-Blast',
    'date': '12 Des',
    'price': 'Rp 800.000',
    'genre': 'K-Pop',
    'location': 'Jakarta',
    'image': 'kblast.jpg',
  },
  {
    'artist': 'Melody Queen',
    'date': '18 Des',
    'price': 'Rp 750.000',
    'genre': 'Pop',
    'location': 'Bandung',
    'image': 'melodyqueen.jpg',
  },
  {
    'artist': 'StarLight 5',
    'date': '26 Des',
    'price': 'Rp 900.000',
    'genre': 'K-Pop',
    'location': 'Jakarta',
    'image': 'starlight5.jpg',
  },
  {
    'artist': 'Vocal Harmony',
    'date': '03 Jan',
    'price': 'Rp 680.000',
    'genre': 'Pop',
    'location': 'Yogyakarta',
    'image': 'vocalharmony.jpg',
  },
  {
    'artist': 'Global Star',
    'date': '26 Feb',
    'price': 'Rp 980.000',
    'genre': 'K-Pop',
    'location': 'Jakarta',
    'image': 'globalstar.jpg',
  },

  // R&B
  {
    'artist': 'Elephant Kind',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'R&B',
    'location': 'Jakarta',
    'image': 'elephantkind.jpg',
  },
  {
    'artist': 'Gamaliél Audrey Cantika',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'R&B',
    'location': 'Jakarta',
    'image': 'audrey.jpg',
  },
  {
    'artist': 'Sisitipsi',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'R&B',
    'location': 'Jakarta',
    'image': 'sisitipsi.jpeg',
  },
  // INDIE
  {
    'artist': 'Efek Rumah Kaca',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'genre': 'Indie',
    'location': 'Jakarta',
    'image': 'efekrumahkaca.jpg',
  },
  {
    'artist': 'Sunwich',
    'date': '04 Des',
    'price': 'Rp 380.000',
    'genre': 'Indie',
    'location': 'Jakarta',
    'image': 'sunwich.jpg',
  },
  {
    'artist': 'Reality Club',
    'date': '19 Des',
    'price': 'Rp 400.000',
    'genre': 'Indie',
    'location': 'Surabaya',
    'image': 'realityclub.jpg',
  },
  // REGGAE
  {
    'artist': 'Dhyo Haw',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Reggae',
    'location': 'Bali',
    'image': 'dhyohaw.jpg',
  },
  {
    'artist': 'Momonon',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Reggae',
    'location': 'Bali',
    'image': 'momonon.jpg',
  },
  {
    'artist': 'Shaggy Dog',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Reggae',
    'location': 'Bali',
    'image': 'shaggydog.jpg',
  },
  // PUNK
  {
    'artist': 'Rocket Rockers',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Punk',
    'location': 'Bali',
    'image': 'rocketrockers.jpg',
  },
  {
    'artist': 'Rebellion Rose',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Punk',
    'location': 'Bali',
    'image': 'rebellionrose.jpg',
  },
  {
    'artist': 'Superiots',
    'date': '28 Jan',
    'price': 'Rp 450.000',
    'genre': 'Punk',
    'location': 'Bali',
    'image': 'superiots.jpeg',
  },

  // METAL
  {
    'artist': 'DeadSquad',
    'date': '17 Des',
    'price': 'Rp 400.000',
    'genre': 'Metal',
    'location': 'Bandung',
    'image': 'deadsquad.jpg',
  },
  {
    'artist': 'Seringai',
    'date': '17 Des',
    'price': 'Rp 400.000',
    'genre': 'Metal',
    'location': 'Bandung',
    'image': 'seringai.jpeg',
  },
  {
    'artist': 'Burgerkill',
    'date': '17 Des',
    'price': 'Rp 400.000',
    'genre': 'Metal',
    'location': 'Bandung',
    'image': 'burgerkill.jpeg',
  },
];

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

// --- APLIKASI UTAMA (MATERIALAPP) ---
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

      // Bottom Navigation Bar
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
          // LIST ITEM INI HARUS DEKLARASI LANGSUNG, BUKAN MEMBANGUN DENGAN BUILDER
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

  void _navigateToDetail(Map<String, String> concertData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(concertData: concertData),
      ),
    );
  }

  void _onGenreSelected(String genre) {
    setState(() {
      _selectedGenre = genre;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filter Genre: $genre diterapkan.'),
        duration: const Duration(milliseconds: 700),
        backgroundColor:
            genreColors[genre] ?? Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60),
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

          _buildConcertCarousel(),
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

          _buildConcertList(context),
        ],
      ),
    );
  }

  // --- Implementasi Widget 1: Search Bar ---
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fungsi Voice Search diaktifkan!'),
                  duration: Duration(milliseconds: 500),
                  backgroundColor: Colors.blueGrey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Implementasi Widget 2: Chip/Filter Tags ---
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

  // --- Implementasi Widget 3: Carousel Card (Filter dan Geser) ---
  Widget _buildConcertCarousel() {
    List<Map<String, String>> filteredCarouselList;

    if (_selectedGenre == 'Semua') {
      filteredCarouselList = allKonserData
          .where((k) => k.containsKey('image') && k['image']!.isNotEmpty)
          .take(4)
          .toList();
    } else {
      filteredCarouselList = allKonserData
          .where((k) => k['genre'] == _selectedGenre)
          .take(4)
          .toList();
    }

    if (filteredCarouselList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tidak ada Konser Unggulan untuk genre "$_selectedGenre" saat ini.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
      );
    }

    // TAMPILAN
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredCarouselList.length,
        itemBuilder: (context, index) {
          final item = filteredCarouselList[index];
          final genre = item['genre']!;
          final genreColor = genreColors[genre] ?? Colors.white;

          // Path gambar yang benar
          final imagePath = 'assets/band_photos/${item['image']}';

          return Container(
            width: MediaQuery.of(context).size.width * 0.88,
            margin: EdgeInsets.only(
              left: index == 0 ? 16 : 8,
              right: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: genreColor.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 0.5,
                  offset: const Offset(0, 4),
                ),
              ],
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
                    Image.asset(
                      imagePath, // Menggunakan path yang sudah disederhanakan
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade900,
                        alignment: Alignment.center,
                        child: Text(
                          item['artist']!,
                          style: TextStyle(
                            color: genreColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['artist']!,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${item['date']} | ${item['location']} | ${item['genre']}',
                            style: TextStyle(
                              fontSize: 14,
                              color: genreColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: genreColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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

  // --- Implementasi Widget 4: List View with Separator (Filter dan Bintang Wishlist) ---
  Widget _buildConcertList(BuildContext context) {
    // Filter data berdasarkan genre yang dipilih
    final filteredList = _selectedGenre == 'Semua'
        ? allKonserData
        : allKonserData.where((k) => k['genre'] == _selectedGenre).toList();

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
        final genre = item['genre']!;
        final genreColor = genreColors[genre] ?? Colors.white;

        // Kunci unik untuk Wishlist
        final wishlistKey =
            '${item['artist']} - ${item['genre']} ${item['location']}';

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
                boxShadow: [
                  BoxShadow(
                    color: genreColor.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                item['genre']![0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: genreColor,
                ),
              ),
            ),
            title: Text(
              item['artist']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${item['date']} | ${item['price']}',
              style: TextStyle(color: Colors.grey.shade400),
            ),

            // TRAILING BARU: Menggabungkan Bintang dan Tombol Detail
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Agar tidak memakan ruang lebar
              children: [
                // ⭐️ TOMBOL WISHLIST (BINTANG)
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
                    // Gunakan setState untuk update tampilan bintang
                    setState(() {
                      if (globalWishlistItems.contains(wishlistKey)) {
                        removeFromWishlist(wishlistKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item['artist']} dihapus dari Wishlist.',
                            ),
                          ),
                        );
                      } else {
                        addToWishlist(wishlistKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${item['artist']} ditambahkan ke Wishlist!',
                            ),
                            backgroundColor: Colors.yellow.shade700,
                          ),
                        );
                      }
                    });
                  },
                ),

                const SizedBox(width: 8),

                // Tombol Detail
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Anda menekan tombol Detail untuk ${item['artist']}!',
                          ),
                          duration: const Duration(milliseconds: 700),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      );
                      _navigateToDetail(item);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
