// lib/screens/admin_panel_screen.dart

import 'package:flutter/material.dart';
import '../globals.dart'; // Pastikan path import ini benar

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variabel Form
  String _bandName = '';
  String _genre = 'Rock';
  String _title = '';
  String _excerpt = '';
  String _bio = '';
  String _mainPhoto = '';
  final String _date = 'Baru Saja';

  final List<String> genres = [
    'Rock',
    'Pop',
    'K-Pop',
    'Metal',
    'R&B',
    'Indie',
    'Reggae',
    'Punk',
  ];

  // --- HELPER: Cek Gambar (Sama seperti di Home) ---
  // Ini memungkinkan Admin melihat gambar baik dari Link maupun File Lokal (Assets)
  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    // Jika link internet
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    }
    // Jika bukan link, anggap file kita (aset lokal)
    else {
      return AssetImage('assets/band_photos/$imagePath');
    }
  }

  // --- LOGIKA TAMBAH DATA ---
  void _submitBand() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBand = {
        'band': _bandName,
        'genre': _genre,
        'title': _title,
        'date': _date,
        'excerpt': _excerpt,
        'bio': _bio,
        // Simpan foto (trim spasi agar aman)
        'main_photo': _mainPhoto.trim().isNotEmpty ? _mainPhoto.trim() : null,
        'albums': [],
      };

      setState(() {
        addBandData(newBand);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Artis $_bandName berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState!.reset();
      // Reset variabel lokal
      setState(() {
        _mainPhoto = '';
        _genre = 'Rock';
      });

      // Pindah ke tab List (index 0)
      DefaultTabController.of(context).animateTo(0);
    }
  }

  // --- LOGIKA HAPUS DATA ---
  void _confirmDelete(int index, Map<String, dynamic> band) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus ${band['band']}?'),
        content: const Text('Data yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // Hapus data berdasarkan INDEX
              removeBandData(index);

              // Refresh UI
              setState(() {});

              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Daftar Artis'),
              Tab(icon: Icon(Icons.add), text: 'Tambah Baru'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: LIST
            _buildListTab(),
            // TAB 2: FORM
            _buildFormTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTab() {
    if (globalBandData.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data artis.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: globalBandData.length,
      itemBuilder: (context, index) {
        final band = globalBandData[index];
        final photoUrl = band['main_photo'];

        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[800],
              // Gunakan helper _getImageProvider agar mendukung URL & Aset
              backgroundImage: _getImageProvider(photoUrl),
              child: (photoUrl == null || photoUrl.isEmpty)
                  ? const Icon(Icons.music_note, color: Colors.white)
                  : null,
            ),
            title: Text(
              band['band'] ?? 'Tanpa Nama',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              band['genre'] ?? '-',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmDelete(index, band),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nama Band/Artis',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group, color: Colors.white70),
              ),
              validator: (v) => v!.isEmpty ? 'Harus diisi' : null,
              onSaved: (v) => _bandName = v!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Genre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category, color: Colors.white70),
              ),
              value: _genre,
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              items: genres
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _genre = v!),
              onSaved: (v) => _genre = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Judul Berita/Konser',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title, color: Colors.white70),
              ),
              onSaved: (v) => _title = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Kutipan Singkat (Excerpt)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.short_text, color: Colors.white70),
              ),
              onSaved: (v) => _excerpt = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Biografi',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description, color: Colors.white70),
              ),
              maxLines: 3,
              onSaved: (v) => _bio = v!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'URL Foto / Nama File (contoh: dewa.jpeg)',
                hintText: 'Link HTTP atau nama file di folder assets',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image, color: Colors.white70),
              ),
              onSaved: (v) => _mainPhoto = v!,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitBand,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'SIMPAN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
