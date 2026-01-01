import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =======================
// VIEWMODEL
// =======================
import 'UI/viewmodels/main_viewmodel.dart';

// =======================
// VIEWS
// =======================
import 'UI/views/home_screen.dart';
import 'UI/views/profile/guest_profile_view.dart';
import 'UI/views/profile/edit_profile_screen.dart';

// =======================
// SCREENS
// =======================
import 'screens/splash_screen.dart';
import 'screens/initial_auth_screen.dart';
import 'screens/news_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/placeholder_screen.dart';
import 'screens/admin_panel_screen.dart';

// =======================
// GLOBALS
// =======================
import 'globals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadWishlist();
  await loadBandDataFromStorage();

  runApp(
    ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: const ScientistFestApp(),
    ),
  );
}

// =======================
// ROOT APP
// =======================
class ScientistFestApp extends StatelessWidget {
  const ScientistFestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScientistFest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A1F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF72585),
          secondary: Color(0xFF4895EF),
          surface: Color(0xFF1B1B3A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// =======================
// MAIN NAVIGATION WRAPPER
// =======================
class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    WishlistScreen(),
    NewsScreen(),
    PlaceholderScreen(title: 'Tickets'),
    ProfileWrapper(),
  ];

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'ScientistFest';
      case 1:
        return 'Wishlist';
      case 2:
        return 'News Feed';
      case 3:
        return 'Tickets';
      case 4:
        return 'My Profile';
      default:
        return 'ScientistFest';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<MainViewModel>().refreshData(),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF72585),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'News'),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number),
              label: 'Tickets'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// =======================
// PROFILE WRAPPER (ROLE-BASED FINAL)
// =======================
class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, _) {

        // =======================
        // 1. GUEST
        // =======================
        if (!viewModel.isLoggedIn) {
          return const GuestProfileView();
        }

        // =======================
        // 2. ADMIN
        // =======================
        if (viewModel.isAdminMode) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFF1B1B3A),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 60,
                      color: Color(0xFFF72585),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Administrator',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Admin Mode Active',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.admin_panel_settings),
                    label: const Text('Open Admin Panel'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPanelScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  OutlinedButton.icon(
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () {
                      viewModel.logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const InitialAuthScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        // =======================
        // 3. USER NORMAL
        // =======================
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF1B1B3A),
                  child: Icon(Icons.person, size: 60),
                ),

                const SizedBox(height: 20),

                Text(
                  viewModel.userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Genre Favorit: ${viewModel.favoriteGenre}',
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                Text(
                  'Wishlist Band: ${viewModel.wishlistCount}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () {
                    viewModel.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const InitialAuthScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
