// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- IMPORT VIEWMODELS ---
// Pastikan path case-sensitive sesuai folder Anda (UI atau ui)
import 'UI/viewmodels/main_viewmodel.dart';
import 'UI/views/home_screen.dart';

// --- IMPORT SCREENS ---
import 'screens/splash_screen.dart';
import 'screens/initial_auth_screen.dart';
import 'screens/news_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/placeholder_screen.dart';
import 'screens/admin_panel_screen.dart';

// --- IMPORT GLOBALS ---
import 'globals.dart';

void main() async {
  // Pastikan binding Flutter diinisialisasi untuk SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  // Memuat data awal dari storage sebelum aplikasi berjalan
  await loadWishlist();
  await loadBandDataFromStorage();

  runApp(
    ChangeNotifierProvider(
      create: (_) => MainViewModel(),
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
          centerTitle: true,
        ),
      ),
      // HALAMAN PERTAMA: Splash Screen
      // Setelah Splash Screen selesai (3-4 detik), ia akan memanggil 
      // Navigator yang mengarah ke InitialAuthScreen atau logic login lainnya.
      home: const SplashScreen(),
    );
  }
}

// Wrapper Utama setelah Login
class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  // Navigasi halaman
  final List<Widget> _pages = [
    const HomeScreen(),
    const WishlistScreen(),
    const NewsScreen(),
    const PlaceholderScreen(title: 'Tickets'),
    const ProfileWrapper(),
  ];

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0: return 'GigFinder';
      case 1: return 'Wishlist';
      case 2: return 'News Feed';
      case 3: return 'Tickets';
      case 4: return 'My Profile';
      default: return 'GigFinder';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<MainViewModel>(context, listen: false).refreshData(),
          ),
        ],
      ),
      // Menggunakan IndexedStack agar posisi scroll tidak hilang saat pindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0A0A1F),
          selectedItemColor: const Color(0xFFF72585),
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Tickets'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// Widget Halaman Profil
class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar dengan indikator mode admin
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF1B1B3A),
                    child: Icon(Icons.person, size: 60, color: viewModel.isAdminMode ? const Color(0xFFF72585) : Colors.white),
                  ),
                  if (viewModel.isAdminMode)
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.amber,
                      child: Icon(Icons.verified_user, size: 15, color: Colors.black),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.isAdminMode ? "Administrator" : "Music Enthusiast",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.isAdminMode ? "Admin Mode Active" : "Guest Account",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              // Panel khusus Admin
              if (viewModel.isAdminMode) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4895EF),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text("Open Admin Panel"),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Tombol Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
                  onPressed: () {
                    viewModel.logout();
                    // Setelah logout, kembalikan ke Auth Screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const InitialAuthScreen()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}