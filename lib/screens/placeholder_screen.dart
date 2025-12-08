import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Digunakan untuk membuka link tiket
import '../globals.dart'; // Import data global

// Data dummy untuk simulasi event/festival
const List<Map<String, String>> festivalEvents = [
  {
    'festival': 'Rockaroma Festival',
    'date': '17 - 19 Mei 2026',
    'location': 'Jakarta',
    'headliners': 'Efek Rumah Kaca, The S.I.G.I.T, DeadSquad',
    'ticket_link':
        'https://www.vestival-rockaroma.com', // Ganti dengan link pembelian real
  },
  {
    'festival': 'Indie Vibes Fest',
    'date': '02 Juni 2026',
    'location': 'Bandung',
    'headliners': 'Sunwich, Reality Club',
    'ticket_link': 'https://www.vestival-indievibes.com',
  },
  {
    'festival': 'Metal Massacre III',
    'date': '30 Maret 2026',
    'location': 'Surabaya',
    'headliners': 'Burgerkill, Seringai',
    'ticket_link': 'https://www.vestival-metalmassacre.com',
  },
  {
    'festival': 'Reggae Beach Party',
    'date': '15 Juli 2026',
    'location': 'Bali',
    'headliners': 'Dhyo Haw, Momonon, Shaggy Dog',
    'ticket_link': 'https://www.vestival-reggaebeach.com',
  },
];

class PlaceholderScreen extends StatefulWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  bool _showList = false;

  // Fungsi BARU untuk membuka URL
  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal membuka link: $url')));
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // Fungsi untuk mendapatkan ikon berdasarkan judul
  IconData _getIcon() {
    switch (widget.title) {
      case 'Wishlist':
        return Icons.favorite;
      case 'Tickets':
        return Icons.calendar_month; // Icon diganti
      case 'Profile':
        return Icons.person;
      default:
        return Icons.info;
    }
  }

  // Fungsi untuk mendapatkan subjudul berdasarkan judul
  String _getSubtitle() {
    switch (widget.title) {
      case 'Wishlist':
        return 'Konser yang Anda simpan akan muncul di sini.';
      case 'Tickets':
        return 'Jadwal festival mendatang dan link pembelian tiket.'; // Subtitle diganti
      case 'Profile':
        return 'Kelola akun, preferensi, dan informasi pribadi Anda.';
      default:
        return 'Halaman informasi.';
    }
  }

  Widget _buildContent(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    if (widget.title == 'Wishlist') {
      // ... (Logika Wishlist tetap sama)
      final currentWishlist = globalWishlistItems;

      return Column(
        children: [
          const SizedBox(height: 20),
          _buildActionButton(
            context,
            _showList
                ? 'Sembunyikan Daftar'
                : 'Lihat Konser Tersimpan (${currentWishlist.length})',
            _showList ? Icons.visibility_off : Icons.visibility,
            primaryColor,
            () {
              setState(() {
                _showList = !_showList;
              });
              Future.delayed(
                const Duration(milliseconds: 100),
                () => setState(() {}),
              );
            },
          ),
          const SizedBox(height: 10),

          _buildActionButton(
            context,
            'Hapus Semua Wishlist',
            Icons.delete_forever,
            Colors.red.shade700,
            () {
              if (currentWishlist.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist sudah kosong!')),
                );
                return;
              }

              int count = currentWishlist.length;
              setState(() {
                clearWishlist();
                _showList = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count konser dihapus dari wishlist.'),
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            },
          ),

          _showList
              ? (currentWishlist.isNotEmpty
                    ? _buildWishlistList(context, primaryColor, currentWishlist)
                    : Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Wishlist Anda kosong. Tambahkan konser dari halaman Home!',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ))
              : const SizedBox.shrink(),
        ],
      );
    } else if (widget.title == 'Tickets') {
      // --- LOGIKA BARU UNTUK FESTIVAL/EVENTS ---
      return _buildFestivalList(context);
    } else if (widget.title == 'Profile') {
      // ... (Logika Profile tetap sama)
      return Column(
        children: [
          const SizedBox(height: 20),
          _buildProfileSetting(context, 'Edit Data Diri', Icons.badge),
          _buildProfileSetting(
            context,
            'Pengaturan Notifikasi',
            Icons.notifications,
          ),
          _buildProfileSetting(context, 'Bantuan & FAQ', Icons.help_outline),
          _buildProfileSetting(context, 'Logout', Icons.exit_to_app),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // --- WIDGET BARU: DAFTAR FESTIVAL ---
  Widget _buildFestivalList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: festivalEvents.length,
        itemBuilder: (context, index) {
          final event = festivalEvents[index];

          return Card(
            color: Theme.of(context).colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['festival']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 ${event['location']} | ${event['date']}',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  const Divider(height: 20, color: Colors.white12),

                  Text(
                    'Lineup Utama: ${event['headliners']}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 12),

                  // TOMBOL LINK PEMBELIAN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        try {
                          _launchUrl(event['ticket_link']!, context);
                        } catch (e) {
                          // Error dihandle di _launchUrl
                        }
                      },
                      icon: const Icon(Icons.link, color: Colors.black),
                      label: const Text(
                        'Beli Tiket di Situs Festival',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF64FFDA), // Hijau Neon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget kustom untuk tombol utama di halaman sekunder
  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Widget baru: Daftar Konser Wishlist
  Widget _buildWishlistList(
    BuildContext context,
    Color color,
    List<String> wishlist,
  ) {
    // ... (Logika Wishlist sama)
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daftar Konser Tersimpan:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const Divider(color: Colors.white24),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlist[index];
              return Dismissible(
                key: Key(item + index.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  setState(() {
                    removeFromWishlist(item);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$item dihapus dari Wishlist')),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red.shade900,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  leading: Icon(Icons.star, color: color),
                  title: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text('Geser ke kiri untuk menghapus'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Membuka detail untuk $item')),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget kustom untuk list setting di halaman Profile
  void onProfileSettingTap(BuildContext context, String title) {
    switch (title) {
      case 'Edit Data Diri':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulasi: Menuju Halaman Edit Data Diri.'),
          ),
        );
        break;
      case 'Pengaturan Notifikasi':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulasi: Menuju Halaman Pengaturan Notifikasi.'),
          ),
        );
        break;
      case 'Bantuan & FAQ':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Simulasi: Memuat Halaman Bantuan & FAQ.'),
          ),
        );
        break;
      case 'Logout':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Simulasi: Anda Berhasil Logout!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Aksi tidak dikenali.')));
    }
  }

  // Widget kustom untuk list setting di halaman Profile
  Widget _buildProfileSetting(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => onProfileSettingTap(context, title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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
                  Icon(_getIcon(), size: 70, color: primaryColor),
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
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
