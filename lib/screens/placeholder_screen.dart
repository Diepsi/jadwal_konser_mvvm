// lib/screens/placeholder_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../globals.dart'; // Import globals
import 'admin_login_screen.dart'; // Layar Login
import 'admin_panel_screen.dart'; // Layar Admin Panel

// Data dummy festival
const List<Map<String, String>> festivalEvents = [
  {
    'festival': 'Rockaroma Festival',
    'date': '17 - 19 Mei 2026',
    'location': 'Jakarta',
    'headliners': 'Efek Rumah Kaca, The S.I.G.I.T, DeadSquad',
    'ticket_link': 'https://www.google.com',
  },
  {
    'festival': 'Indie Vibes Fest',
    'date': '02 Juni 2026',
    'location': 'Bandung',
    'headliners': 'Sunwich, Reality Club',
    'ticket_link': 'https://www.google.com',
  },
];

class PlaceholderScreen extends StatefulWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  // Variabel _showList DIHAPUS karena fitur wishlist pengunjung ditiadakan
  bool _isAdminLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isAdminLoggedIn = isAdmin; // Sinkronisasi status admin saat init
  }

  // --- NAVIGASI ADMIN ---

  void _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
    );
    if (result == true) {
      setState(() {
        _isAdminLoggedIn = isAdmin;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Admin Berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _navigateToAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
    ).then((_) {
      setState(() {}); // Refresh setelah dari admin panel
    });
  }

  void _doAdminLogout() {
    setState(() {
      isAdmin = false;
      _isAdminLoggedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout Admin Berhasil.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // --- HELPER UI ---

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $url')));
      }
    }
  }

  IconData _getIcon() {
    if (widget.title == 'Profile') return Icons.person;
    if (widget.title == 'Festival') return Icons.festival;
    return Icons.more_horiz;
  }

  String _getSubtitle() {
    if (widget.title == 'Profile') return 'Halaman khusus Administrator.';
    if (widget.title == 'Festival') return 'Info festival musik mendatang.';
    return 'Halaman tambahan.';
  }

  // --- BUILD CONTENT ---

  Widget _buildProfileSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade400),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildProfileSettings(BuildContext context) {
    if (widget.title == 'Profile' || widget.title == 'Lainnya') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BAGIAN PENGUNJUNG / WISHLIST SUDAH DIHAPUS

            // HANYA MENAMPILKAN AKSES ADMIN
            if (_isAdminLoggedIn) ...[
              const Text(
                'Panel Admin:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5252),
                ),
              ),
              _buildProfileSettingItem(
                context,
                'Tambah Info Artis',
                Icons.add_box,
                _navigateToAdminPanel,
                color: const Color(0xFFFF5252),
              ),
              _buildProfileSettingItem(
                context,
                'Logout Admin',
                Icons.logout,
                _doAdminLogout,
                color: Colors.red,
              ),
            ] else ...[
              const Text(
                'Akses Admin:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              _buildProfileSettingItem(
                context,
                'Login Admin',
                Icons.login,
                _navigateToLogin,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
            const Divider(height: 20, color: Colors.white24),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _buildContent(BuildContext context) {
    // 1. KONTEN TAB PROFILE (Kosong, karena Wishlist dihapus)
    if (widget.title == 'Profile' || widget.title == 'Lainnya') {
      // Tidak menampilkan apa-apa di bawah menu setting
      return const SizedBox.shrink();
    }
    // 2. KONTEN TAB FESTIVAL (Tetap Ada)
    else if (widget.title == 'Festival') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: festivalEvents.map((event) {
            return Card(
              color: const Color(0xFF2A2A40),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['festival']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${event['date']} @ ${event['location']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => _launchUrl(event['ticket_link']!),
                      child: const Text('Beli Tiket'),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          if (_isAdminLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _doAdminLogout,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              child: Column(
                children: [
                  Icon(
                    _getIcon(),
                    size: 70,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _getSubtitle(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            _buildProfileSettings(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
