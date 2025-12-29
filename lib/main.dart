// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import Layer MVVM
import 'ui/viewmodels/main_viewmodel.dart';
import 'ui/views/home_screen.dart';

// Import Screens
import 'screens/placeholder_screen.dart';
import 'screens/news_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/admin_login_screen.dart'; 
import 'screens/admin_panel_screen.dart'; 

// Import Global
import 'globals.dart';

// --- STYLE GLOBALS ---
const List<String> genreTags = [
  'Semua', 'Metal', 'Rock', 'R&B', 'Pop', 'K-Pop', 'Indie', 'Reggae', 'Punk',
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadWishlist();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
      ],
      child: const GigFinderApp(),
    ),
  );
}

class GigFinderApp extends StatelessWidget {
  const GigFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GigFinder MVVM',
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

class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  // Mendapatkan judul halaman berdasarkan index
  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0: return 'GigFinder';
      case 1: return 'Wishlist';
      case 2: return 'News';
      case 3: return 'Tickets';
      case 4: return 'Profile';
      default: return 'GigFinder';
    }
  }

  // Fungsi Refresh Global
  void _handleRefresh() async {
    await loadWishlist(); // Memuat ulang data dari storage
    setState(() {}); // Memperbarui UI
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Halaman Diperbarui'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4895EF),
      ),
    );
  }

  List<Widget> get _widgetOptions => <Widget>[
    const HomeScreen(),
    const WishlistScreen(),
    const NewsScreen(),
    const PlaceholderScreen(title: 'Tickets'),
    const AdminProfileWrapper(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR GLOBAL DENGAN BACK DAN REFRESH
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: _selectedIndex != 0 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedIndex = 0), // Kembali ke Home
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRefresh,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
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
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

// --- WIDGET PROFIL UNTUK KONTROL ADMIN ---
class AdminProfileWrapper extends StatefulWidget {
  const AdminProfileWrapper({super.key});

  @override
  State<AdminProfileWrapper> createState() => _AdminProfileWrapperState();
}

class _AdminProfileWrapperState extends State<AdminProfileWrapper> {
  @override
  Widget build(BuildContext context) {
    // Scaffold di sini tidak menggunakan AppBar lagi karena sudah ada di Wrapper
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(Icons.person, size: 60, color: isAdmin ? Colors.amber : Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            isAdmin ? "Halo, Administrator" : "Anda masuk sebagai Tamu",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (!isAdmin)
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text("Login sebagai Admin"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                ).then((_) => setState(() {})); 
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF72585)),
            )
          else ...[
            ElevatedButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("Buka Panel Admin"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                ).then((_) => setState(() {}));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  isAdmin = false; 
                });
              },
              child: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        ],
      ),
    );
  }
}