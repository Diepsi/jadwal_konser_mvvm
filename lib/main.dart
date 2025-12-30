// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// --- PENTING: Gunakan path yang konsisten (UI huruf besar sesuai struktur folder Anda) ---
import 'UI/viewmodels/main_viewmodel.dart';
import 'UI/views/home_screen.dart';

// Import Screens
import 'screens/placeholder_screen.dart';
import 'screens/news_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/admin_panel_screen.dart'; 
import 'screens/initial_auth_screen.dart'; 

// Import Global
import 'globals.dart';

void main() async {
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
        ),
      ),
      // GATEKEEPER: Consumer memantau isLoggedIn dari MainViewModel
      // Jika false, tampilkan InitialAuthScreen (Halaman Login Utama)
      home: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isLoggedIn) {
            return const InitialAuthScreen();
          }
          return const MainScreenWrapper();
        },
      ),
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

  void _handleRefresh() async {
    final viewModel = Provider.of<MainViewModel>(context, listen: false);
    await viewModel.refreshData(); 
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Halaman Diperbarui'),
          duration: Duration(seconds: 1),
          backgroundColor: Color(0xFF4895EF),
        ),
      );
    }
  }

  // Opsi widget untuk navigasi bawah
  List<Widget> get _widgetOptions => <Widget>[
    const HomeScreen(),
    const WishlistScreen(),
    const NewsScreen(),
    const PlaceholderScreen(title: 'Tickets'),
    const ProfileWrapper(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: const TextStyle(fontWeight: FontWeight.bold)),
        leading: _selectedIndex != 0 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedIndex = 0),
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
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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
          onTap: (index) => setState(() => _selectedIndex = index),
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

// --- WIDGET PROFIL: Terkoneksi dengan ViewModel untuk mode Admin/Logout ---
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
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Icon(
                  Icons.person, 
                  size: 60, 
                  color: viewModel.isAdminMode ? Colors.amber : Colors.white
                ),
              ),
              const SizedBox(height: 20),
              Text(
                viewModel.isAdminMode ? "Halo, Administrator" : "Halo, Pengunjung",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              if (viewModel.isAdminMode) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text("Buka Panel Admin"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                ),
                const SizedBox(height: 10),
              ],
              
              TextButton.icon(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text("Logout / Keluar", style: TextStyle(color: Colors.redAccent)),
                onPressed: () => viewModel.logout(), 
              ),
            ],
          ),
        );
      },
    );
  }
}